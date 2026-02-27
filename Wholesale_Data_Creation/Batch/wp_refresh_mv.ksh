#! /bin/ksh

#-------------------------------------------------------------------------------
#  File:  wp_refresh_mv.ksh
#  Desc:  This shell script refresh materialized view based on input parameter
#-------------------------------------------------------------------------------


[ -z "$RETAIL_HOME" ] && echo "Need to set RETAIL_HOME environment variable, exiting... " && exit 1;

function usage {

	echo "Usage: wp_refresh_mv.ksh <alias> <materialized view> <refresh_mode> <atomic? TRUE|FALSE>"

}

function check_db {
  RETVAL=`$ORACLE_HOME/bin/sqlplus -s $ALIAS <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT 'Alive' FROM dual;
EXIT;
EOF`

  if [ "$RETVAL" = "Alive" ]; then
    DB_OK=0
  else
    DB_OK=1
  fi
}

if [[ $# -lt 4 ]]; then
	usage
	exit 1
fi

ALIAS=$1
MVIEW=$2
MODE=$3
ATOMIC=$4

check_db

if [[ $DB_OK -eq 1 ]]; then
	echo "Error while connecting to database, exiting..."
	exit 1
fi


$ORACLE_HOME/bin/sqlplus -s $ALIAS <<EOF
   set pause off
   set echo off
   set heading off
   set feedback off
   set verify off
   set linesize 2500;
   set pages 0
   
   WHENEVER SQLERROR EXIT 1
   
   DECLARE
   
   L_exists NUMBER(1);
   custom_exception EXCEPTION;
   PRAGMA EXCEPTION_INIT( custom_exception, -20001 );
   
   BEGIN
   
   SELECT COUNT(1) into L_exists FROM user_objects where object_type='MATERIALIZED VIEW' and object_name='${MVIEW}';
   
   if L_exists = 0 THEN
   		raise_application_error( -20001, 'Invalid materialized view received as input parameter: ${MVIEW}');
   end if;
   
   dbms_mview.refresh('${MVIEW}','${MODE}', atomic_refresh=> ${ATOMIC});
   
   
   END;
   /

EOF

err=$?

if [[ $err -ne 0 ]]; then
  exit 1
fi

exit 0