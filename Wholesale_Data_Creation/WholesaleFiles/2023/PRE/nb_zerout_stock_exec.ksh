#! /bin/ksh
#-------------------------------------------------------------------------
#  File:  nb_zerout_stock_exec.ksh
#
#  Desc: This script is for the zerout franchise store stock on hand requirement.
#		 This script will first populate the staging table ZEROUT_FRANCHISE_STOCK_STG;
#		 the item location relationships for all franchise stores with stock on hand levels <> 0
#		 This script will then prepare the staged data and split them into threads based on location
#		 This script will then process each record within the staging table as an inventory adjustment
#		 to then bring the stock on hand back to 0
#-------------------------------------------------------------------------

pgmName='nb_zerout_stock_exec.ksh'
pgmName=${pgmName##*/}               # get the file name
pgmExt=${pgmName##*.}                # get the extenstion
pgmName=${pgmName%.*}                # remove the file extenstion
pgmPID=$$                            # get the process ID
exeDate=`date +"%h_%d"`              # get the execution date

LOGFILE="${RETAIL_HOME}/log/$exeDate.log"
ERRORFILE="${RETAIL_HOME}/error/err.$pgmName.$exeDate.$pgmPID"
ERRINDFILE=err.ind
DIR=`pwd`

OK=0
FATAL=255
NON_FATAL=1

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
# Function Name: USAGE
# Purpose      : Defines how the program should be invoked
#-------------------------------------------------------------------------
function USAGE
{
   echo "USAGE: . $pgmName <connect string>

   <connect string>   Username/password@db. Use "'$UP'" if using Oracle Wallet."

}
#-------------------------------------------------------------------------
# Function Name: EXEC_SQL
# Purpose      : Execute the SQL and PL/SQL statements.
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
      " | sqlplus  ${CONNECT}`

   if [[ $? -ne ${OK} ]]; then
      LOG_ERROR "${sqlReturn}" "EXEC_SQL" ${FATAL}
      return ${FATAL}
   fi

   return ${OK}
}

#-------------------------------------------------------------------------
# Function Name: POPULATE_STG
# Purpose      : calls the function NB_ZEROUT_FRANCHISE_STOCK.POPULATE_STG
#-------------------------------------------------------------------------

function POPULATE_STG
{
   sqlTxt="
      DECLARE
         FUNCTION_ERROR    EXCEPTION;
         L_error_message VARCHAR2(250);
      BEGIN

      if NOT NB_ZEROUT_FRANCHISE_STOCK.POPULATE_STG(L_error_message) then
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
      echo "NB_ZEROUT_FRANCHISE_STOCK.POPULATE_STG Failed" >>${ERRORFILE}
      return ${FATAL}
   else
      LOG_MESSAGE "Successfully Completed NB_ZEROUT_FRANCHISE_STOCK.POPULATE_STG"
      return ${OK}
   fi
}

#-------------------------------------------------------------------------
# Function Name: SETUP_THREADS
# Purpose      : calls the function NB_ZEROUT_FRANCHISE_STOCK.SETUP_THREADS
#-------------------------------------------------------------------------

function SETUP_THREADS
{
   sqlTxt="
      DECLARE
         FUNCTION_ERROR    EXCEPTION;
         L_error_message VARCHAR2(250);
      BEGIN

      if NOT NB_ZEROUT_FRANCHISE_STOCK.SETUP_THREADS(L_error_message) then
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
      echo "NB_ZEROUT_FRANCHISE_STOCK.SETUP_THREADS Failed" >>${ERRORFILE}
      return ${FATAL}
   else
      LOG_MESSAGE "Successfully Completed NB_ZEROUT_FRANCHISE_STOCK.SETUP_THREADS"
      return ${OK}
   fi
}

#-------------------------------------------------------------------------
# Function Name: PROCESS_ZEROUT
# Purpose      : calls the function NB_ZEROUT_FRANCHISE_STOCK.POPULATE_STG
#-------------------------------------------------------------------------

function PROCESS_ZEROUT
{
   sqlTxt="
      DECLARE
         FUNCTION_ERROR    EXCEPTION;
         L_error_message VARCHAR2(250);
		 L_thread_min NUMBER(4);
		 L_thread_max NUMBER(4);   
      BEGIN

	  SELECT MIN(thread_number) 
      INTO L_thread_min
      FROM NB_ZEROUT_FRANCHISE_STOCK_STG z
      WHERE status='N';
     
      SELECT MAX(thread_number) 
      INTO L_thread_max
      FROM NB_ZEROUT_FRANCHISE_STOCK_STG z
      WHERE status='N';
	  
	  WHILE L_thread_min <= L_thread_max LOOP
		
		  if NOT NB_ZEROUT_FRANCHISE_STOCK.PROCESS_ZEROUT(L_error_message, L_thread_min) then
				 raise FUNCTION_ERROR;
		  end if;
		  
		  L_thread_min := L_thread_min + 1;
	  END LOOP;
	  
	  DELETE FROM NB_ZEROUT_FRANCHISE_STOCK_STG WHERE STATUS = 'P';

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
      echo "NB_ZEROUT_FRANCHISE_STOCK.PROCESS_ZEROUT Failed" >>${ERRORFILE}
      return ${FATAL}
   else
      LOG_MESSAGE "Successfully Completed NB_ZEROUT_FRANCHISE_STOCK.PROCESS_ZEROUT"
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

#Validate that DB connection is valid and available
ConnCheck=`echo "exit" | $ORACLE_HOME/bin/sqlplus -s -l ${CONNECT}`

if [[ $? -ne ${OK} ]]; then
   echo $ConnCheck
   LOG_ERROR "${ConnCheck}" "SQLPlus" ${FATAL}
   exit 1
else
   LOG_MESSAGE "nb_zerout_stock_exec.ksh - Started by ${USER}"
fi

POPULATE_STG
returnStatus=$?
if [[ ${returnStatus} -ne ${OK} ]]; then
    LOG_MESSAGE "NB_ZEROUT_FRANCHISE_STOCK.POPULATE_STG terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
    exit 1
fi

SETUP_THREADS
returnStatus=$?
if [[ ${returnStatus} -ne ${OK} ]]; then
    LOG_MESSAGE "NB_ZEROUT_FRANCHISE_STOCK.SETUP_THREADS Job terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
    exit 1
fi

PROCESS_ZEROUT
returnStatus=$?
if [[ ${returnStatus} -ne ${OK} ]]; then
    LOG_MESSAGE "NB_ZEROUT_FRANCHISE_STOCK.PROCESS_ZEROUT terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
    exit 1
else
    LOG_MESSAGE "nb_zerout_stock_exec.ksh - Completed by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

exit $?