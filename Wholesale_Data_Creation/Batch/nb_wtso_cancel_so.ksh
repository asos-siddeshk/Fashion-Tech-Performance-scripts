#! /bin/ksh

#-------------------------------------------------------------------------
#  File:  nb_wtso_cancel_so.ksh
#  Desc:  UNIX shell script to cancel the sales order for the given input
#         parameters.
#-------------------------------------------------------------------------

pgmName='nb_wtso_cancel_so.ksh'
pgmName=${pgmName##*/}    # remove the path
pgmExt=${pgmName##*.}     # get the extension
pgmName=${pgmName%.*}     # get the program name
pgmPID=$$                 # get the process ID
exeDate=`date +"%h_%d"`   # get the execution date

LOGFILE="${RETAIL_HOME}/wholesale_db_batch/log/$exeDate.log"
ERRORFILE="${RETAIL_HOME}/wholesale_db_batch/error/err.$pgmName.$exeDate.$pgmPID"
ERRINDFILE=err.ind

#initialize return values
OK=0
FATAL=255
NONFATAL=1

USAGE="Usage: `basename $0`  <connect> <param2: Sales_Order> <param3: Source_Loc> <param4: Item >"
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
# Function Name: CANCEL_SALES_ORDER
# Purpose      : Cancel the Sales Order created for the gien input parameter.
#-------------------------------------------------------------------------
function CANCEL_SALES_ORDER
{
   sales_order_no=$1
   source_loc=$2
   item=$3
   
  sqlReturn=`echo "set feedback off;
      set heading off;
      set term off;
      set verify off;
      set serveroutput on size 1000000;

      VARIABLE GV_return_code    NUMBER;
      VARIABLE GV_script_error   CHAR(255);

      EXEC :GV_return_code  := 0;
      EXEC :GV_script_error := NULL;

      WHENEVER SQLERROR EXIT ${FATAL}

      DECLARE
       I_sales_order_no    NUMBER(20):=TO_NUMBER('${sales_order_no}');
       I_source_loc        NUMBER(20):=TO_NUMBER('${source_loc}');
       I_item              VARCHAR2(25):=TO_CHAR("${item-NULL}");
  
  
       RECORD_LOCKED        EXCEPTION;
       PRAGMA               EXCEPTION_INIT(RECORD_LOCKED, -54);
   
      BEGIN
     -- Updating the the wholesale sales order tables.
      update wp_order_detail wpd
        set wpd.original_qty = nvl(wpd.original_qty,0) + nvl(wpd.current_qty,0),
	        wpd.current_qty = 0,
			wpd.cancel_reason = '40',
			wpd.cancel_date   = sysdate,
			wpd.last_update_datetime = sysdate,
            wpd.last_update_id       = user
       where wpd.sales_order_no  = I_sales_order_no
	     and wpd.item            = nvl(I_item,wpd.item)
	     and wpd.source_loc_id   = I_source_loc;
	  
	  if SQL%NOTFOUND then 
	     dbms_output.put_line('No records where updated');
      elsif SQL%FOUND then 
	     update wp_order_head wph
            set wph.status          = 'C',
		        wph.cancel_reason   = '40',
			    wph.cancel_date     = sysdate, 
		        wph.last_update_datetime = sysdate,
                wph.last_update_id       = user
           where wph.sales_order_no  = I_sales_order_no;	  
	  end if;
	  
      commit;	  
      
	  EXCEPTION
         when NO_DATA_FOUND then
            ROLLBACK;
            :GV_script_error := SQLERRM;
            :GV_return_code := ${NONFATAL};			
         when OTHERS then
            ROLLBACK;
            :GV_script_error := SQLERRM;
            :GV_return_code := ${FATAL};
      END;
      /
      print :GV_script_error;
      exit  :GV_return_code;
      " | sqlplus -s $CONNECT`

   if [[ $? -ne ${OK} ]]; then
      LOG_ERROR "${sqlReturn}" "CANCEL_SALES_ORDER" ${FATAL} ${ERRORFILE} ${LOGFILE} ${pgmName}
      return ${FATAL}
   fi
  
   return ${OK}
}

#-----------------------------------------------
# Main program starts
# Parse the command line
#-----------------------------------------------

# Test for the number of input arguments
if [ $# -lt 4 ]
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
   LOG_MESSAGE "${ConnCheck}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
   exit 1
else
   LOG_MESSAGE "nb_wtso_cancel_so.ksh - Started by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

#------------------------------------------------------------
# Call the cancel sales order
#------------------------------------------------------------
CANCEL_SALES_ORDER $2 $3 $4 
return_status=$?

if [[ ${return_status} -ne ${OK} ]]; then
    LOG_MESSAGE "Job terminated with fatal error. Error recorded in ${ERRORFILE}" "" ${FATAL} ${LOGFILE} ${pgmName} ${pgmPID}
    exit 1
else
    LOG_MESSAGE "nb_wtso_cancel_so.ksh - Successfully completed by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

exit 0
#-----------End of Processing -------------------------------------------------
