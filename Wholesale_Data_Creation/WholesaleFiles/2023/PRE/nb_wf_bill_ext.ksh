#! /bin/ksh
#-------------------------------------------------------------------------
#  File:  nb_wf_bill_ext.ksh
#
#  Desc:  UNIX shell script to extract WF billing information.
#-------------------------------------------------------------------------
. ${MMHOME}/oracle/lib/src/rmsksh.lib
pgmName='nb_wf_bill_ext.ksh'
pgmName=${pgmName##*/}               # remove the path
pgmExt=${pgmName##*.}                # get the extension
pgmName=${pgmName%.*}                # get the program name
pgmPID=$$                            # get the process ID
exeDate=`date +"%h_%d"`              # get the execution date
extractDate=`date +"%Y%m%d%H%M%S"`   # get the execution date

LOGFILE="${MMHOME}/log/$exeDate.log"
ERRORFILE="${MMHOME}/error/err.$pgmName.$exeDate.$pgmPID"
ERRINDFILE=err.ind
DIR=`pwd`

OK=0
FATAL=255

#--------------------------------------------------------------------------------
# Function Name: USAGE
# Purpose      : Defines how the program should be invoked
#--------------------------------------------------------------------------------
function USAGE
{
   echo "USAGE: . $pgmName <connect string> <mode> <path>

   <connect string>   Username/password@db.
   
   <mode> mode of extraction. pre or process or post
   
   <path> folder where files will be extracted in case mode is process"
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

#--------------------------------------------------------------------------------
# Function Name: PRE_PROCESSING
# Purpose:       Initiate records to be extracted from the NB_WF_BILL_EXT_TMP
#                table.
#--------------------------------------------------------------------------------

function PRE_PROCESSING
{
   sqlTxt="
      DECLARE
         FUNCTION_ERROR    EXCEPTION;
         L_error_message VARCHAR2(250);
      BEGIN

      if NOT NB_WF_BILL_EXT_SQL.PRE_PROCESS(L_error_message) then
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
      echo "NB_WF_BILL_EXT_SQL.PRE_PROCESS Failed" >>${ERRORFILE}
      return ${FATAL}
   else
      return ${OK}
   fi
}

#-------------------------------------------------------------------------
# Function Name: PROCESS_EXTRACT
# Purpose      : Export WF Billing Information
#-------------------------------------------------------------------------

function PROCESS_EXTRACT
{

    # Set filename 
   NBWFBILLEXT=$DIR/nb_wf_bill_ext
   
	if [ -f $NBWFBILLEXT ]; then
		LOG_ERROR "File already exists " "FILE EXISTS" "$NBWFBILLEXT" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
		exit 1
	fi

    # Get the WF Billing Information to be extracted
   $ORACLE_HOME/bin/sqlplus -s $CONNECT <<EOF >$NBWFBILLEXT
   set pause off
   set echo off
   set heading off
   set feedback off
   set verify off
   set linesize 2500;
   set pages 0

   select WF_CUSTOMER_ID           || '|' ||
          CUST_ORD_REF_NO          || '|' ||
          CURRENCY_CODE            || '|' ||
          INVOICE_DATE             || '|' ||
          ORDER_QTY                || '|' ||
          CUSTOMER_COST            || '|' ||
          WP_PARTNER_DC_ID         || '|' ||
          WP_PARTNER_DEPT_NO       || '|' ||
          ITEM_PARENT              || '|' ||
          ITEM_PARENT_DESC         || '|' ||
          ITEM_SKU                 || '|' ||
          ITEM_UPC                 || '|' ||
          ITEM_EAN                 || '|' ||
          SIZE_DESC                || '|' ||
          FROM_COUNTRY_ID          || '|' ||
          SOURCE_LOC_ID            || '|' ||
          CUSTOMER_LOC             || '|' ||
          TO_COUNTRY_ID            || '|' ||
          TO_STATE                 || '|' ||
          TO_CHAR(ROUND(NO_OF_CARTONS,2),'FM999999990.00')            || '|' ||
          GROUP_NO                 
     from (select WF_CUSTOMER_ID,
                  CUST_ORD_REF_NO,
                  CURRENCY_CODE,
                  INVOICE_DATE,
                  SUM(ORDER_QTY) ORDER_QTY,
                  CUSTOMER_COST,
                  WP_PARTNER_DC_ID,
                  WP_PARTNER_DEPT_NO,
                  ITEM_PARENT,
                  ITEM_PARENT_DESC,
                  ITEM_SKU,
                  ITEM_UPC,
                  ITEM_EAN,
                  SIZE_DESC,
                  FROM_COUNTRY_ID,
                  SOURCE_LOC_ID,
                  CUSTOMER_LOC,
                  TO_COUNTRY_ID,
                  TO_STATE,
                  SUM(NO_OF_CARTONS) NO_OF_CARTONS,
                  GROUP_NO
          FROM NB_WF_BILL_EXT_TMP
          GROUP BY WF_CUSTOMER_ID,
                   CUST_ORD_REF_NO,
                   CURRENCY_CODE,
                   INVOICE_DATE,
                   CUSTOMER_COST,
                   WP_PARTNER_DC_ID,
                   WP_PARTNER_DEPT_NO,
                   ITEM_PARENT,
                   ITEM_PARENT_DESC,
                   ITEM_SKU,
                   ITEM_UPC,
                   ITEM_EAN,
                   SIZE_DESC,
                   FROM_COUNTRY_ID,
                   SOURCE_LOC_ID,
                   CUSTOMER_LOC,
                   TO_COUNTRY_ID,
                   TO_STATE,
                   GROUP_NO);

EOF
   err=$?

   if [[ `grep "^ORA-" $NBWFBILLEXT | wc -l` -gt 0 ]]; then
      status=${FATAL}
      cat $NBWFBILLEXT >> $ERRORFILE
      rm $NBWFBILLEXT
   else
   	  
      mv "${NBWFBILLEXT}" "${NBWFBILLEXT}_${extractDate}".dat
      status=${OK}
   fi

   return ${status}

}

#--------------------------------------------------------------------------------
# Function Name: POST_PROCESSING
# Purpose:       Truncate NB_WF_BILL_EXT_TMP table
#--------------------------------------------------------------------------------

function POST_PROCESSING
{
   sqlTxt="
      DECLARE
         FUNCTION_ERROR    EXCEPTION;
         L_error_message VARCHAR2(250);
      BEGIN

      if NOT NB_WF_BILL_EXT_SQL.POST_PROCESS(L_error_message) then
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
      echo "NB_WF_BILL_EXT_SQL.POST_PROCESS Failed" >>${ERRORFILE}
      return ${FATAL}
   else
      return ${OK}
   fi
}

#-----------------------------------------------
# Main program starts
# Parse the command line
#-----------------------------------------------

# Test for the number of input arguments
if [[ $# -lt 2 || $# -gt 3 ]]; then
   USAGE
   exit 1
fi

#Validate mode
if [[ $2 != "pre" && $2 != "process" && $2 != "post" ]]; then
    LOG_ERROR "Invalid mode set " "INVALID MODE" "$2" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
    exit 1
fi

#Validate if mode is process, then third parameter is provided
if [[ $2 = "process" ]]; then
	if [[ $# -lt 3 ]]; then
   		USAGE
   		exit 1
	fi
fi

#Validate folder exists
if [[ $2 = "process" ]]; then
	if [ ! -d "$3" ]; then
	   LOG_ERROR "Folder to extract files does not exists " "INVALID FOLDER" "$3" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
	   exit 1
	else
		DIR=$3
	fi
fi

CONNECT=$1

#Validate that DB connection is valid and available
ConnCheck=`echo "exit" | $ORACLE_HOME/bin/sqlplus -s -l ${CONNECT}`
constatus=$?

if [[ ${constatus} -ne ${OK} ]]; then
   LOG_ERROR "invalid username/password; logon denied" "CONNECTION_FAILED" "${constatus}" "${ERRORFILE}" "${LOGFILE}" $pgmName $pgmPID
   exit 1
else
   LOG_MESSAGE "nb_wf_bill_ext.ksh - Started by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

#Call data extract
if [[ $2 = "pre" ]]; then
    PRE_PROCESSING
    prep_status=$?
    if [[ ${prep_status} -ne ${OK} ]]; then
        LOG_MESSAGE "Job terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
        exit 1
    fi
elif [[ $2 = "process" ]]; then
    PROCESS_EXTRACT 
    process_status=$?
    if [[ ${process_status} -ne ${OK} ]]; then
        LOG_MESSAGE "Job terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
        exit 1
    fi
elif [[ $2 = "post" ]]; then
    POST_PROCESSING 
    postp_status=$?
    if [[ ${postp_status} -ne ${OK} ]]; then
        LOG_MESSAGE "Job terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
        exit 1
    fi
fi

LOG_MESSAGE "nb_wf_bill_ext.ksh - Completed by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}

exit 0