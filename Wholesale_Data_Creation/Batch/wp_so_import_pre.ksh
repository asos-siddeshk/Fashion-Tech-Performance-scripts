#! /bin/ksh
#-------------------------------------------------------------------------
#  File:  wp_so_import_pre.ksh
#
#  Desc:  UNIX shell script to import Sales Order data into Wholesale Portal
#-------------------------------------------------------------------------
#. ${MMHOME}/oracle/lib/src/rmsksh.lib
pgmName='wp_so_import_pre.ksh'
pgmName=${pgmName##*/}               # remove the path
pgmExt=${pgmName##*.}                # get the extension
pgmName=${pgmName%.*}                # get the program name
pgmPID=$$                            # get the process ID
exeDate=`date +"%h_%d"`              # get the execution date
extractDate=`date +"%G%m%d%H%M%S"`   # get the execution date

#LOGFILE="${MMHOME}/log/$exeDate.log"
#ERRORFILE="${MMHOME}/error/err.$pgmName.$exeDate.$pgmPID"
LOGFILE="${RETAIL_HOME}/wholesale_db_batch/log/$exeDate.log"
ERRORFILE="${RETAIL_HOME}/wholesale_db_batch/error/err.$pgmName.$exeDate.$pgmPID"
ERRINDFILE=err.ind
DIR=`pwd`

OK=0
FATAL=255
NON_FATAL=1
FILE_REGEX="WTSO_extract*.csv"
BAD_FILE_IN_INPUT="*.bad"

file_seq_no=
filenopath=
filenoext=

#-------------------------------------------------------------------------
# Function Name: LOG_ERROR
# Purpose      : Log the error messages to the error file.
#-------------------------------------------------------------------------
function LOG_ERROR
{
   errMsg=`echo $1`       # echo message to a single line
   errFunc=$2
   retCode=$3

   dtStamp=`date +"%G%m%d%H%M%S"`
   echo "$pgmName~$dtStamp~$errFunc~$errMsg" >> $ERRORFILE
   if [[ $retCode -eq ${FATAL} ]]; then
      LOG_MESSAGE "Aborted in" $errFunc $retCode
   fi
   return $retCode
}

#-------------------------------------------------------------------------
# Function Name: LOG_MESSAGE
# Purpose      : Log the messages to the log file.
#-------------------------------------------------------------------------
function LOG_MESSAGE
{
   logMsg=`echo $1`       # echo message to a single line
   logFunc=$2
   retCode=$3

   dtStamp=`date +"%a %b %e %T"`
   echo "$dtStamp Program: $pgmName: PID=$pgmPID: $logMsg $logFunc" >> $LOGFILE
   return $retCode
}

#--------------------------------------------------------------------------------
# Function Name: USAGE
# Purpose      : Defines how the program should be invoked
#--------------------------------------------------------------------------------
function USAGE
{
  echo "USAGE: . $pgmName <connect string> <import_path> <archive_path>

  <connect string>   Username/password@db.

  <import_path> folder where files will be imported

  <archive_path> folder where files will be archived"
}

function SET_PROCESSED_BATCH_SEQ
{

  sqlReturn=`$ORACLE_HOME/bin/sqlplus -s $CONNECT  <<EOF
  set pause off
  set echo off
  set heading off
  set feedback off
  set verify off
  set pages 0
  WHENEVER OSERROR EXIT FAILURE
  WHENEVER SQLERROR EXIT SQL.SQLCODE
    insert into WP_SO_FILE_UPLD
      (batch_seq_no,
       filename)
    values
      ('${file_seq_no}',
       '${filenopath}');
    commit;
  exit;
  EOF`

  set_processed_batch_seq_status=$?

  if [[ ${set_processed_batch_seq_status} -ne ${OK} ]]; then
     LOG_ERROR "Failed to add the new file loaded ${filenopath} into WP_SO_FILE_UPLD" "SET_PROCESSED_BATCH_SEQ" "${set_processed_batch_seq_status}" "${ERRORFILE}" "${LOGFILE}" ${pgmName} ${pgmPID}
     return ${FATAL}
  fi

  return ${OK}
}


function LOAD_SO_DATA
{
  ctl_file=${LOG_DIR}/${filenoext}.ctl
  log_file=${LOG_DIR}/${filenoext}.log
  bad_file=${INPUT_DIR}/${filenoext}.bad

  rm -f $ctl_file

  printf "
  LOAD DATA
  INFILE '${file}'
  APPEND INTO TABLE WP_SO_IMPORT_STG
  FIELDS TERMINATED BY \",\"
  OPTIONALLY ENCLOSED BY '\"'
  TRAILING NULLCOLS
  (
    ORDER_ROW_ID,
    ORDER_ROW_TIMESTAMP,
    ORDER_ROW_CODE,
    RRP_GBP,
    RRP_EUR,
    RRP_USD,
    RRP_CAD,
    DESPATCH_MONTH DATE 'YYYY-MM-DD',
    OPTION_ID,
    SALES_ORDER_TYPE,
    MANUAL_STATUS_ID,
    ORDER_ROW_CANCEL_ID,
    ORDER_ROW_CANCEL_DATE DATE 'YYYY-MM-DD',
    PARTNER_CANCEL_ID,
    PARTNER_CANCEL_DATE DATE 'YYYY-MM-DD',
    PARTNER_ORDER_NO,
    SALES_ORDER_ID,
    PARTNER_ID,
    DELIVERY_FC,
    DELIVERY_NOT_BEFORE_DATE DATE 'YYYY-MM-DD',
    DELIVERY_NOT_AFTER_DATE DATE 'YYYY-MM-DD',
    PARTNER_CURRENCY,
    SELL_PRICE,
    PARTNER_TOTAL_UNITS,
    UNITS_BY_SIZE,
    FILENAME          CONSTANT    \"${filenopath}\",
    SEQ_NO \"WP_SO_UPLD_SEQ.NEXTVAL\",
    BATCH_SEQ_NO  CONSTANT   ${file_seq_no}    
  )" >> $ctl_file

  # Load file
  sqlldr $CONNECT control=$ctl_file LOG=$log_file BAD=$bad_file 
  sqlldr_status=$?
  if [[ ${sqlldr_status} -ne ${OK} ]]; then
     LOG_ERROR "sqlldr failed to load file $filenopath" "SQLLDR" "${sqlldr_status}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
     return ${FATAL}
  fi

  rm -f $log_file
  rm -f $ctl_file

  return ${OK}

}

#-----------------------------------------------
# Main program starts
# Parse the command line
#-----------------------------------------------

# Test for the number of input arguments
if [[ $# -lt 1 || $# -gt 3 || $# -lt 3 ]]; then
   USAGE
   exit 1
fi

INPUT_DIR=$2
ARCHIVE_DIR=$3
LOG_DIR=$INPUT_DIR

CONNECT=$1

#check partially processed / missed recovery before starting new load

BAD_COUNT=`ls ${INPUT_DIR}/${BAD_FILE_IN_INPUT} 2>/dev/null | wc -l`
if [ $BAD_COUNT -gt 0 ]; then
   LOG_ERROR "Found .bad file(s) in ${INPUT_DIR}, make sure they recovered properly and remove it from input folder." "INPUT_NOT_CLEAN" "${FATAL}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
   exit ${FATAL}
fi

# check folder permissions
if [ ! -r $INPUT_DIR ] && [ ! -w $INPUT_DIR ]; then
   LOG_ERROR "Missing permissions for folder ${INPUT_DIR}" "INVALID_PERMISSIONS" "${FATAL}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
   exit ${FATAL}
fi

if [ ! -r $ARCHIVE_DIR ] && [ ! -w $ARCHIVE_DIR ]; then
   LOG_ERROR "Missing permissions for folder ${ARCHIVE_DIR}" "INVALID_PERMISSIONS" "${FATAL}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
   exit ${FATAL}
fi

if [ ! -r $LOG_DIR ] && [ ! -w $LOG_DIR ]; then
   LOG_ERROR "Missing permissions for folder ${LOG_DIR}" "INVALID_PERMISSIONS" "${FATAL}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
   exit ${FATAL}
fi

#Validate that DB connection is valid and available
ConnCheck=`echo "exit" | $ORACLE_HOME/bin/sqlplus -s -l ${CONNECT}`
constatus=$?

if [[ ${constatus} -ne ${OK} ]]; then
   LOG_ERROR "invalid username/password; logon denied" "CONNECTION_FAILED" "${constatus}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
   exit ${FATAL}
else
   LOG_MESSAGE "$pgmName - Started by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

######################### Processing ############################################

#
#Sales Order Loading
#

COUNT=`ls -ltra $INPUT_DIR/$FILE_REGEX 2>/dev/null | wc -l`

if [[ $COUNT -gt 0 ]]; then

  ###############################################################################
  #  Load files to process
  ###############################################################################

  LOG_MESSAGE "Sales Order files to process: $COUNT" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}

  ls $INPUT_DIR/$FILE_REGEX | sort -n -k1.13,1.28 | while read file
  do

    filenopath=${file##*/}
    filenoext=${filenopath%.*}
    file_seq_no=${filenoext:13:14}
    
	match=`echo $filenopath | grep -w '[A-Z]\{4\}_[a-z]\{7\}_[0-9]\{14\}.csv' | wc -l`
	
	if [[ $match -eq 0 ]]; then
		continue;
	fi

	#Remove BOM if exists
	sed -i '1s/^\xEF\xBB\xBF//' $file
	
	#convert windows format
	dos2unix $file
	file $file
    
    empty=$(wc -l <$file)
    
    if [ $empty -eq 0 ];
    then
    	LOG_MESSAGE "Empty file $file, moving to archive." "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
    	mv $file $ARCHIVE_DIR
      	mv_file_status=$?
      	if [[ ${mv_file_status} -ne ${OK} ]]; then
      	  LOG_ERROR "Failed to move ${file} to ${ARCHIVE_DIR}" "ARCHIVE FILE" "${mv_file_status}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
      	  LOG_MESSAGE "Failed with errors by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
      	  exit ${FATAL}
      	  
      	else
      	  continue;
      	fi
    fi
    
    length=$(wc -c <$file)
    if [ "$length" -ne 0 ] && [ -z "$(tail -c -1 <$file)" ]; then
      truncate -s -1 $file
    fi

	  SET_PROCESSED_BATCH_SEQ
      set_processed_batch_seq_status=$?
      if [[ ${set_processed_batch_seq_status} -ne ${OK} ]]; then
        LOG_MESSAGE "Failed with errors by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
		mv $file ${INPUT_DIR}/${filenoext}_dup.bad
		mv_bad_file_status=$?
		if [[ ${mv_bad_file_status} -ne ${OK} ]]; then
			LOG_ERROR "Failed to move ${file} to ${INPUT_DIR}/${filenoext}_dup.bad" "BAD FILE" "${mv_bad_file_status}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
			LOG_MESSAGE "Failed with errors by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
			return ${FATAL}
		fi
        #return ${FATAL}
	  else
		LOAD_SO_DATA $filenopath
		LOAD_SO_DATA_status=$?
		if [[ ${LOAD_SO_DATA_status} -ne ${OK} ]]; then
			LOG_MESSAGE "Failed with errors by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
			#exit ${FATAL}
		fi
	
      	mv $file $ARCHIVE_DIR
      	mv_file_status=$?
      	if [[ ${mv_file_status} -ne ${OK} ]]; then
      	  LOG_ERROR "Failed to move ${file} to ${ARCHIVE_DIR}" "ARCHIVE FILE" "${mv_file_status}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
      	  LOG_MESSAGE "Failed with errors by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
      	  exit ${FATAL}
      	fi
      fi
  done

else

  ###############################################################################
  #  No files to process
  ###############################################################################

  LOG_MESSAGE "No Sales Order files to process" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}

fi


if [[ -e "$ERRORFILE" ]]; then
  LOG_MESSAGE "Failed with errors by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
  exit ${FATAL}
else
  LOG_MESSAGE "Completed by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

exit ${OK}