#! /bin/ksh
#-------------------------------------------------------------------------
#  File:  nb_wtso_imp_error_report.ksh
#
#  Desc:  UNIX shell script to extract the records of Wholesale
#         sales order import failures for exception report.
#-------------------------------------------------------------------------
pgmName='nb_wtso_imp_error_report.ksh'
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
LCOUNT=0

USAGE="Usage: `basename $0`  <connect> <file_path> <archive_path>
  <connect string>   Username/password@db.

  <file_path> folder where exception file will be created

  <archive_path> folder where exception files will be archived"

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
# Function Name: EXTRACT_ERRORED_RECORDS
# Purpose      : Extract and spool the Wholesale sales order import error records.
#-------------------------------------------------------------------------
function EXTRACT_ERRORED_RECORDS
{

sysDate=`date +"%Y%m%d%H%M%S"`   # get the sysdate

set -A file_data `$ORACLE_HOME/bin/sqlplus -s $CONNECT <<EOF
set pause off
set linesize 32766
set pagesize 0
set feedback off
set verify off
set heading off
set echo off
set trimspool on
set trims on

spool $FILE_PATH/WTSO_Imp_Exception_Report_$sysDate.csv

 select 'OptionID' || ',' ||
       'DespatchMonth'  || ',' ||
       'PartnerID'  || ',' ||
       'DC' || ',' ||
       'StoreID'  || ',' ||
       'SalesOrder'  || ',' ||
       'SalesOrdtype' ||','||
       'CancelId' ||','||
       'CancelDate'  || ',' ||
       'Units_by_size'  || ',' ||
       'Error_desc'  || ',' ||    
       'Buying_Group'  || ',' ||
       'Assigned_Team'
       from dual
       union all
select OptionID || ',' ||
       DespatchMonth || ',' || 
       PartnerID || ',' ||
       DC || ',' ||
       StoreID || ',' ||
       SalesOrder || ',' ||
       SalesOrdtype || ',' ||
       CancelId || ',' ||
       CancelDate || ',' ||
       units_by_size || ',' ||
       error_desc || ',' ||
       Buying_Group || ',' ||
       Assigned_Team 
 from(
 select
 OptionID ,
       DespatchMonth , 
       PartnerID ,
       DC ,
       StoreID ,
       SalesOrder ,
       SalesOrdtype ,
       CancelId ,
       CancelDate ,
       units_by_size ,
       error_desc ,
       Buying_Group ,
       Assigned_Team 
       from
       (
 select whse.option_id OptionID,
       whse.despatch_month DespatchMonth,
       whse.partner_id PartnerID,
       whse.dc_id DC,
       whse.store_id StoreID,
       whse.sales_order_id SalesOrder,
       whse.sales_order_type SalesOrdtype,
       whse.order_row_cancel_id CancelId,
       whse.order_row_cancel_date CancelDate,
       whse.units_by_size,
       --whse.int_error_msg error_desc,
       replace(whse.int_error_msg, ',', ';') error_desc,
       (case
        when whse.option_id is not null then
            (select ma.buying_group_name
              from ma_v_buyerarchy ma
             where ma.item = whse.option_id) 
        end) Buying_Group,
       (case
        when upper(whse.int_error_msg) like '%WP_SO_IMPORT_SQL%' then
            'Commercial Team'            
        else 
         'Wholesale Team'
        end) Assigned_Team,
        whse.create_datetime
  from wp_so_import_arch whse,
       (select max(seq_no)seq_no, sales_order_id
          from wp_so_import_arch 
        where int_status ='P'
        group by sales_order_id) whse1
  where whse.int_status ='E'       
    and whse.sales_order_id = whse1.sales_order_id
    and whse.seq_no > whse1.seq_no
union  
select whse.option_id OptionID,
       whse.despatch_month DespatchMonth,
       whse.partner_id PartnerID,
       whse.dc_id DC,
       whse.store_id StoreID,
       whse.sales_order_id SalesOrder,
       whse.sales_order_type SalesOrdtype,
       whse.order_row_cancel_id CancelId,
       whse.order_row_cancel_date CancelDate,
       whse.units_by_size,
       --whse.int_error_msg error_desc,
       replace(whse.int_error_msg, ',', ';') error_desc,
       (case
        when whse.option_id is not null then
            (select ma.buying_group_name
               from ma_v_buyerarchy ma
              where ma.item = whse.option_id) 
        end) Buying_Group,
       (case
        when upper(whse.int_error_msg) like '%WP_SO_IMPORT_SQL%' then
            'Commercial Team'            
        else 
         'Wholesale Team'
        end) Assigned_Team,
         whse.create_datetime
   from wp_so_import_arch whse
  where whse.int_status ='E'  
    and not exists ( select 1 
                       from wp_so_import_arch whse1
                      where whse.sales_order_id = whse1.sales_order_id
                        and whse1.int_status ='P')
   ) order by create_datetime
   );           

spool off;
exit;
EOF`

  if [[ $? -ne ${OK} ]]; then
        LOG_ERROR "Creation of Wholesale Sales Order Import Exception Report:Failed." "EXTRACT_ERRORED_RECORDS" ${FATAL} ${ERRORFILE} ${LOGFILE} ${pgmName}
        return ${FATAL}
   else
        LOG_MESSAGE "Creation of Wholesale Sales Order Import Exception Report:Successfully Completed" "EXTRACT_ERRORED_RECORDS" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
        return ${OK}
   fi
  
}

#-----------------------------------------------
# Main program starts
# Parse the command line
#-----------------------------------------------

# Test for the number of input arguments
if [ $# -lt 3 ]
then
   echo $USAGE
   exit 1
fi

CONNECT=$1
USER=${CONNECT#/@}
FILE_PATH=$2
ARCHIVE_PATH=$3


#Validate that DB connection is valid and available
ConnCheck=`echo "exit" | $ORACLE_HOME/bin/sqlplus -s -l ${CONNECT}`


if [[ $? -ne ${OK} ]]; then
   echo $ConnCheck
   LOG_MESSAGE "${ConnCheck}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
   exit 1
else
   LOG_MESSAGE "nb_wtso_imp_error_report.ksh - Started by ${USER}" "" ${OK} ${LOGFILE} ${pgmName} ${pgmPID}
fi

#------------------------------------------------------------
# Call the process to extract the data
#------------------------------------------------------------
# Move the existing files to archive directory 
cd $2
mv  WTSO_Imp_Exception_Report_*.csv  $3

EXTRACT_ERRORED_RECORDS
exit $?
#-----------End of Processing -------------------------------------------------
