#! /bin/ksh
#---------------------------------------------------------------------------------------------
#  File:  wp_so_import.ksh
#
#  Desc:  Wholesale Portal Sales Order Import Processing
#---------------------------------------------------------------------------------------------
# global variables
pgmName=`basename $0`
pgmName=${pgmName##*/}    # remove the path
pgmExt=${pgmName##*.}     # get the extension
pgmName=${pgmName%.*}     # get the program name
pgmPID=$$                 # get the process ID
exeDate=`date +"%h_%d"`   # get the execution date

LOGFILE="${RETAIL_HOME}/wholesale_db_batch/log/$exeDate.log"
ERRORFILE="${RETAIL_HOME}/wholesale_db_batch/error/err.$pgmName."$exeDate
ERRINDFILE=err.ind

OK=0
FATAL=255
NON_FATAL=1

USAGE="Usage: `basename $0`  <connect> "


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

#-------------------------------------------------------------------------
# Function Name: EXEC_SQL
# Purpose      : Used for executing the sql statements.
#-------------------------------------------------------------------------

function EXEC_SQL
{
   sqlTxt=$*

   sqlReturn=`echo "set feedback off;
      set heading off;
      set term off;
      set verify off;
      set serveroutput on size 1000000;

      VARIABLE GV_return_code    NUMBER;
      VARIABLE GV_script_error   VARCHAR2(4000);

      EXEC :GV_return_code   := 0;
      EXEC :GV_script_error  := NULL;

      WHENEVER SQLERROR EXIT ${FATAL}
      $sqlTxt
      /

      print :GV_script_error;
      exit  :GV_return_code;
      " | sqlplus -s ${CONNECT}`

   if [[ $? -ne ${OK} ]]; then
      LOG_ERROR "${sqlReturn}" "EXEC_SQL" ${FATAL}
      return ${FATAL}
   fi

   return ${OK}
}

#-------------------------------------------------------------------------
# Function Name: PROCESS
# Purpose      : calls the function WP_SO_IMPORT_SQL.PROCESS_STG
#-------------------------------------------------------------------------

function PROCESS
{
   sqlTxt="
      DECLARE
         FUNCTION_ERROR    EXCEPTION;
         L_error_message VARCHAR2(250);
      BEGIN

      if NOT WP_SO_IMPORT_SQL.PROCESS_STG(L_error_message) then
             raise FUNCTION_ERROR;
      end if;

      COMMIT;

      EXCEPTION
         when FUNCTION_ERROR then
            ROLLBACK;
            :GV_return_code := ${FATAL};
	        :GV_script_error := L_error_message||' - '||SQLERRM;
         when OTHERS then
            ROLLBACK;
	        :GV_script_error := L_error_message||' - '||SQLERRM;
            :GV_return_code := ${FATAL};
      END;"
   EXEC_SQL ${sqlTxt}

   if [[ $? -ne ${OK} ]]; then
      echo "WP_SO_IMPORT_SQL.PROCESS_STG Failed" >>${ERRORFILE}
      return ${FATAL}
   else
      LOG_MESSAGE "Successfully Completed"
      return ${OK}
   fi
}

#-----------------------------------------------
# Main program starts
# Parse the command line
#-----------------------------------------------

# Test for the number of input arguments
if [ $# -lt 1 ]
then
   echo $USAGE
   exit 1
fi

CONNECT=$1
USER=${CONNECT#/@}

if [ ! -d ${RETAIL_HOME}/wholesale_db_batch/log ]; then
	mkdir -p ${RETAIL_HOME}/wholesale_db_batch/log
fi

if [ ! -d ${RETAIL_HOME}/wholesale_db_batch/error ]; then
	mkdir -p ${RETAIL_HOME}/wholesale_db_batch/error
fi

#Validate that DB connection is valid and available
ConnCheck=`echo "exit" | $ORACLE_HOME/bin/sqlplus -s -l ${CONNECT}`

if [[ $? -ne ${OK} ]]; then
   echo $ConnCheck
   LOG_ERROR "${ConnCheck}" "SQLPlus" ${FATAL}
   exit 1
else
   LOG_MESSAGE "wp_so_import.ksh - Started by ${USER}"
fi



PROCESS
exit $?