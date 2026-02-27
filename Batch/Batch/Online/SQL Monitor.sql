exec system.killsession ('628');

update nb_system_parameters set value_2 = TO_DATE('2021-11-09 04:00:16','YYYY-MM-DD HH:mi:ss') WHERE FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';
delete from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'REPLICATION_RD_DASH_INTAKE_FLAG';
Update sa_system_options set CHECK_DUP_MISS_TRAN= 'N';

select * from rms.RMS_BATCH_STATUS;
update RMS_BATCH_STATUS set BATCH_RUNNING_IND = 'N';
select * from v$restore_point;
select * from all_constraints where STATUS != 'ENABLED' and owner in ('RMS','MA_ASOS','INT_ASOS');

select * from rms.sa_system_options;
select * from rms.period;


select c.owner,c.object_name,c.object_type,b.sid,b.serial#,b.status,b.osuser,b.machine
  from v$locked_object a ,v$session b,dba_objects c
 where b.sid = a.session_id --and b.status= 'INACTIVE'
   and a.object_id = c.object_id 
 order by b.status; 
    
select blocking_session, sid, serial#, wait_class, seconds_in_wait
  from v$session 
where blocking_session is not NULL
 order by blocking_session;    


select distinct b.sid from v$locked_object a ,v$session b,dba_objects c
    where b.sid = a.session_id  -- and b.status= 'ACTIVE'
    and a.object_id = c.object_id ;

select * from v$locked_object;

select status,count(1) from rms.rpm_bulk_cc_pe_thread group by status;
select count(1) from rpm_stage_item_loc;exec system.killsession ('4902');

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo group by PROMO_START_DATE order by 1;
select count(1) from if_tran_data; -- 33275525
select count(1) from reclass_item; --
select count(1) from item_mfqueue; 
select count(1) from RPM_ITEM_MODIFICATION; 
select count(1) from RPM_EVENT_ITEMLOC; --15979551-15549285 from dual
select count(1) from int_asos.INT_PL_SALES_DNLD_STG; --77 56 584
select count(1) from emer_price_hist; --227184
select count(1) from RPM_ITEMLOC_THREAD;
select 15979551-15549285 from dual;

select status,count(1) from rms.ordhead group by status;
select status,count(1) from rms.tsfhead group by status;
select status_code,count(1) from rms.shipment group by status_code;

cd /orabin/app/oracle/product/retail/batch/error
cd /orabin/app/oracle/product/retail/batch/log
cd /orabin/app/oracle/product/retail/batch
. ./batch.profile
cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin

./saimptlogfin $UP /asos/oracle/vpt/data/internal/sales/ref/storedayfile.1 &


Insert into restart_program_status (RESTART_NAME,THREAD_VAL,START_TIME,PROGRAM_NAME,PROGRAM_STATUS,RESTART_FLAG,RESTART_TIME,FINISH_TIME,CURRENT_PID,CURRENT_OPERATOR_ID,ERR_MESSAGE,CURRENT_ORACLE_SID,CURRENT_SHADOW_PID) 
values ('saimptlogfin',3,to_date('19-AUG-21','DD-MON-RR'),'saimptlogfin','ready for start',null,null,to_date('19-AUG-21','DD-MON-RR'),null,null,null,null,null);


select * from rms.restart_program_status where restart_name like '%nb_vatdlxpl%' order by 3 desc;
select * from restart_program_history where restart_name like 'saimptlogi' order by 3 desc;
select * from rms.restart_control where program_name like 'nb_snapshot_inv_status';
select * from restart_bookmark where restart_name like 'prchstprg';

update restart_control set NUM_THREADS='1' where program_name like 'prchstprg';
Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where restart_name like '%vat%';
delete from rms.restart_bookmark where restart_name like 'nb_commitment_refresh';

select * from rms.restart_program_status where PROGRAM_STATUS!='ready for start';

select * from RMS.sa_STORE_DAY WHERE BUSINESS_DATE > '03-MAY-21' order by 2,3 ;

exec system.killsession ('2045');

2864
3585

Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' ;
delete from rms.restart_bookmark;



Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where restart_name like 'saimptlogfin';
delete from rms.restart_bookmark where restart_name like 'saimptlogfin';

select * from rms.restart_bookmark;
select * from RMS.RPM_BATCH_CONTROL;
select * from rms.restart_program_status where PROGRAM_STATUS!='ready for start';
Update rms.restart_program_status set PROGRAM_STATUS ='ready for start';

select * from v$restore_point;
select * from all_tab_partitions where table_name like 'SA_EXPORTED';

select owner,table_name from dba_tab_statistics
   where --owner in ('RMS') AND 
     STALE_STATS = 'YES'
     AND OBJECT_TYPE = 'TABLE';

select * from all_tables
   where owner in ('INT_ASOS', 'MA_ASOS', 'RMS') AND NUM_ROWS >= '1000000';

select * from dba_tab_statistics
   where owner in ('INT_ASOS', 'MA_ASOS', 'RMS')
     AND STALE_STATS = 'YES'
     AND OBJECT_TYPE = 'TABLE';

--1.)
select count(*) from RMS.INT_PL_SALES_DNLD_STG; --3760717
select * from dba_tab_modifications where table_owner='RMS' and TABLE_NAME='PRICE_HIST' order by partition_name;

--2.)
select count(*) from RMS.PRICE_HIST; --297810171
select owner, table_name, partition_name, subpartition_name, last_analyzed, stale_stats from dba_tab_statistics where table_name = 'PRICE_HIST' order by last_analyzed;



delete from daily_purge;
update RMS_BATCH_STATUS SET BATCH_RUNNING_IND ='N';


select owner,table_name, stale_stats, last_analyzed from 
    dba_tab_statistics where STALE_STATS ='YES';-- and owner like 'RMS' ;
    
select * from dba_tab_statistics where STALE_STATS ='YES' and table_name like '%PRICE_HIST';

select * from V$RESTORE_POINT;

SELECT NAME, SCN, TIME, DATABASE_INCARNATION#,
        GUARANTEE_FLASHBACK_DATABASE,STORAGE_SIZE
        FROM V$RESTORE_POINT;

select distinct b.sid from v$locked_object a ,v$session b,dba_objects c
where b.sid = a.session_id and b.status= 'INACTIVE'
    and a.object_id = c.object_id order by b.status; 

exec system.killsession ('121');
exec system.killsession ('5515');


delete from rms.restart_control where PROGRAM_NAME like '%saimptlogi%';



Update restart_control set NUM_THREADS ='3',COMMIT_MAX_CTR='5000',LOCK_WAIT_TIME='10',RETRY_MAX_CTR='3' where program_name like '%saimptlogi%';
--Update restart_control set NUM_THREADS ='1' where program_name like '%docclose%';
select * from rms.restart_bookmark where restart_name like '%saimptlogi%';
select * from rms.restart_control where PROGRAM_NAME like '%saimptlogi%';
select * from rms.restart_control where PROGRAM_NAME like '%fc%';

select * from rms.restart_program_status where lower(restart_name) like '%saimptlogi%' order by 3 desc;
select PROGRAM_STATUS,count(1) from rms.restart_program_status where lower(restart_name) like '%saimptlogi%' group by PROGRAM_STATUS;


select RESTART_NAME, PROGRAM_STATUS, 
       to_char(START_TIME,'dd-mon-yy hh:mi:ss am') START_TIME,
       to_char(FINISH_TIME,'dd-mon-yy hh:mi:ss am') FINISH_TIME --, to_char((to_date(FINISH_TIME)-to_date(START_TIME)),'dd-mon-yy hh:mi:ss am') RUN_TIME
    from rms.restart_program_status where upper(restart_name) in ('NB_SAEXPWEBDEP','NB_SAIMPTLOG_TAX','NB_SAEXPDW','NB_CUST_RET_PRE','NB_RMSE_RPAS_SAL_RET_PRE') order by 1,2;
select * from rms.restart_bookmark;

--
select * from rms.restart_control where upper(program_name) like '%nb_stock_buckets%';
UPdate restart_control set NUM_THREADS= '4' where upper(program_name) like '%nb_stock_buckets%';

select * from all_tables where table_name like '%LOCK%';
select * from ORDHEAD_LOCK;
SELECT * FROM V$DATABASE;

select * from gv$statistics_level;
select * from V$SQL_PLAN_STATISTICS;
select * from V$SQL where sql_id = '49xvssdzd07su';



select * from rms.restart_program_status where PROGRAM_STATUS!='ready for start';

Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where program_name like '%nb_ilbp_eod_refresh%';
delete from rms.restart_bookmark where restart_name like '%nb_ilbp_eod_refresh%';

select * from rms.restart_bookmark ;

select count(1) from int_asos.INT_PO_COMMITMENT;
delete from int_asos.INT_PO_COMMITMENT where rownum <= '100000';

select * from restart_bookmark;



select c.owner,c.object_name,c.object_type,b.sid,b.serial#,b.status,b.osuser,b.machine
 from v$locked_object a ,v$session b,dba_objects c
where b.sid = a.session_id
  and a.object_id = c.object_id order by b.status; 
    
select blocking_session, sid, serial#, wait_class, seconds_in_wait
    from  v$session
    where blocking_session is not NULL
        order by blocking_session;    
    
    
select
   c.owner,c.object_name,c.object_type,b.sid,b.serial#,b.status,b.osuser,b.machine
from v$locked_object a ,v$session b,dba_objects c
where b.sid = a.session_id
    and a.object_id = c.object_id order by b.status; 
    
    select * from v$session where STATUS ='ACTIVE';
    
    select * from all_tab_columns where column_name like '%TOTAL%WORK%';
    
    select * from sys.V_$SESSION_LONGOPS where SOFAR = TOTALWORK;
    
select * from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where OPTION_ID ='100050320';

-- OBJ_COMP_ITEM_COST_RETURN (I_collection IN OBJ_COMP_ITEM_COST_TBL)


select * from v$sql where sql_text like '%MA_ASOS%' order by FIRST_LOAD_TIME desc;


select * from v$sql where sql_text like '%RMS_ITEMLOC_ENR%' order by FIRST_LOAD_TIME desc;

select sql_id,plan_hash_value,executions,first_load_time,last_load_time,last_active_time from v$sql where sql_id ='a2vm8cv6wj548';

select * from v$sql where lower(SQL_TEXT) like '%place_of_creation%' order by last_load_time desc;


ma_v_po_mass_mnt_search_ma


select table_name, stale_stats, last_analyzed from dba_tab_statistics where owner = 'RMS'  and STALE_STATS ='YES';

select * from ALLOC_MFQUEUE;


ajykzszjy8kdk	hstmthupd
a11h89pba5knc	hstwkupd


select
(select username || ' - ' || osuser from v$session where sid=a.sid) blocker,
a.sid || ', ' ||
(select serial# from v$session where sid=a.sid) sid_serial,
' is blocking ',
(select username || ' - ' || osuser from v$session where sid=b.sid) blockee,
b.sid || ', ' ||
(select serial# from v$session where sid=b.sid) sid_serial
from v$lock a, v$lock b
where a.block = 1
and b.request > 0
and a.id1 = b.id1
and a.id2 = b.id2;

    select * from all_tables where table_name like '%V$%';
    
    delete from rpm_event_itemloc where SELLING_UNIT_RETAIL is null;
    select count(1) from rpm_event_itemloc;

select * from v$sql where sql_text like '%RMS_ITEMLOC_ENR%' order by FIRST_LOAD_TIME desc;
--select INT_ASOS.INT_RMS_ITEMLOC_ENR.getItemLocExt(:1 ,:2 )from dual

select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('addjzgsjxfvxp') and s.snap_id = SQL.snap_id
and s.begin_interval_time> TO_date('24-JUL-2024 9:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time< TO_date('24-JUL-2024 21:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;



    select * from V$SQL where sql_id ='b692gwsfv0p7t';
    
    sql_text like 'SELECT %MA_STG_ITEM_HEAD%';


    select * from V$SQL where sql_id = 'addjzgsjxfvxp';
    select * from V$SQL_PLAN where sql_id = 'addjzgsjxfvxp';
    select * from V$SQL_PLAN_STATISTICS where sql_id = 'addjzgsjxfvxp';
    --Combined -- 
    select * from V$SQL_PLAN_STATISTICS_ALL where sql_id = '2amcyu0v5d4jr';
    select * from V$SQL_PLAN_MONITOR where sql_id = '2amcyu0v5d4jr';
    select * from plan_table;





    select * from DBA_HIST_DB_CACHE_ADVICE;
    select * from DBA_HIST_IOSTAT_DETAIL;
    
    select * from rms.logger_logs order by 1 desc;
select 577151936 - 1000 from dual;
SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE 'TRANS%';
select * from logger_logs where id > 687745395 order by id desc;




"  object      line  object
  handle    number  name
0x25bc99dd0       356  package body RMS.SQL_LIB.GET_MESSAGE_TEXT
0xbe6a8f78       142  package body RMS.RMS_NOTIFICATION_SQL.INSERT_RAF_NOTIFICATION
0xbe6a8f78       111  package body RMS.RMS_NOTIFICATION_SQL.WRITE_RAF_NOTIFICATION
0x1531cc020        25  RMS.RMS_COL_SPT_STATUS_AUR
0x2f9a4f688      4757  package body RMS.CORESVC_VAT.PROCESS
0xfc7afa68         1  anonymous block
0x11b775b40       286  package body RMS.CORESVC_ADMIN_SQL.CALL_PROCESS_API
0xbd95a830         9  anonymous block
"

select * from v$session where username is not null and status = 'ACTIVE' order by logon_time, sid;


    select * FROM rms.logger_logs where trunc(TIME_STAMP) =trunc(sysdate) order by TIME_STAMP desc;
    select * FROM ma_asos.ma_logs where trunc(LOG_TS) =trunc(sysdate) order by LOG_TS desc;
    
"PACKAGE_ERROR:ORA-20001: @0PACKAGE_ERROR@1ORA-00001: unique constraint (INT_ASOS.INT_TCKT_DNLD_STAGE_PK) violated@2INT_PO_SEND_TCKT_REQ
ORA-06512: at "RMS.NB_INT_OHE_TCKT", line 30
ORA-04088: error during execution of trigger 'RMS.NB_INT_OHE_TCKT':CORESVC"

            select dept,count(dept) from rms. rpm_item_loc where loc ='1001' group by dept;
            
select status,count(status) from rms.rpm_stage_clearance group by status;
select status,count(status) from rms.rpm_stage_simple_promo group by status;
select status,count(status) from rms.rpm_stage_price_change group by status;


select count(1) from int_asos.INT_PO_COMMITMENT;
delete from int_asos.INT_PO_COMMITMENT where rownum <= '100000';


select decode(sum(decode(s.serial#,l.serial#,1,0)),0,'No','Yes') " ",
         s.sid "Session ID",s.status "Status",
         s.username "Username", RTRIM(s.osuser) "OS User",
         b.spid "OS Process ID",s.machine "Machine Name",
         s.program  "Program",c.sql_text "SQL text"
  from v$session s, v$session_longops l,v$process b,
       (select address,sql_text from v$sqltext where piece=0) c
where (s.sid = l.sid(+)) and s.paddr=b.addr and s.sql_address = c.address  
group by s.sid,s.status,s.username,s.osuser,s.machine,
         s.program,b.spid, b.pid, c.sql_text order by s.sid;
         
         
         SELECT *
FROM   v$process
WHERE NOT EXISTS (SELECT 1
                 FROM v$session
                 WHERE paddr = addr);.
                 
                 
                 
declare
begin
for rec in ( select s.sid as session_id
 from Gv$session s
 join Gv$process p
   on s.paddr = p.addr
  and s.inst_id = p.inst_id
  AND S.USERNAME='RPM' AND  STATUS='ACTIVE'
where s.type != 'BACKGROUND');
asd
loop
--   system.killsession (rec.session_id);
end loop;
end ;
/

select *
 from Gv$session s
 join Gv$process p
   on s.paddr = p.addr
  and s.inst_id = p.inst_id
  AND  STATUS='ACTIVE'
where s.type = 'BACKGROUND';



select * 
from 
dba_role_privs
--dba_sys_privs 
--dba_tab_privs 
where grantee = 'SKUMAR';


select * 
from role_role_privs 
where role in (select granted_role from dba_role_privs where grantee= 'SKUMAR');



select * 
from role_sys_privs  
where role in (select granted_role from dba_role_privs where grantee= 'SKUMAR');


select * 
from role_tab_privs  
where role in (select granted_role from dba_role_privs where grantee= 'SKUMAR');

select * from RPM_PC_TICKET_REQUEST ;





SELECT S.USERNAME || '(' || s.sid || ')-' || s.osuser UNAME,
         s.program || '-' || s.terminal || '(' || s.machine || ')' PROG,
         s.sid || '/' || s.serial# sid,
         s.status "Status",
         p.spid,
         sql_text sqltext
    FROM v$sqltext_with_newlines t, V$SESSION s, v$process p
   WHERE     t.address = s.sql_address
         AND p.addr = s.paddr(+)
         AND t.hash_value = s.sql_hash_value
         and s.status = 'ACTIVE'
ORDER BY s.sid, t.piece;


 -- CPU usage of the USER

SELECT ss.username, se.SID, VALUE / 100 cpu_usage_seconds
    FROM v$session ss, v$sesstat se, v$statname sn
   WHERE     se.STATISTIC# = sn.STATISTIC#
         AND NAME LIKE '%CPU used by this session%'
         AND se.SID = ss.SID
         AND ss.status = 'ACTIVE'
         AND ss.username IS NOT NULL
ORDER BY VALUE DESC;

 --Long Query progress in database
SELECT a.sid,
         a.serial#,
         b.username,
         opname OPERATION,
         target OBJECT,
         TRUNC (elapsed_seconds, 5) "ET (s)",
         TO_CHAR (start_time, 'HH24:MI:SS') start_time,
         ROUND ( (sofar / totalwork) * 100, 2) "COMPLETE (%)"
    FROM v$session_longops a, v$session b
   WHERE     a.sid = b.sid
         AND b.username NOT IN ('SYS', 'SYSTEM')
         AND totalwork > 0
ORDER BY elapsed_seconds;

 -- Get current session id, process id, client process id?
SELECT b.sid,
       b.serial#,
       a.spid processid,
       b.process clientpid
  FROM v$process a, v$session b
 WHERE a.addr = b.paddr AND b.audsid = USERENV ('sessionid');
 
 
 --
sELECT *
  FROM (  SELECT ROWNUM,
                 a.sql_id,
                 SUBSTR (a.sql_text, 1, 200) sql_text,
                 TRUNC (
                    a.disk_reads / DECODE (a.executions, 0, 1, a.executions))
                    reads_per_execution,
                 a.buffer_gets,
                 a.disk_reads,
                 a.executions,
                 a.sorts,
                 a.address
            FROM v$sqlarea a
        ORDER BY 3 DESC)
 WHERE ROWNUM < 40;


SELECT program application, COUNT (program) Numero_Sesiones
    FROM v$session
GROUP BY program
ORDER BY Numero_Sesiones DESC;



select skulist,count(1) from skulist_detail where item_level = '1' group by SKULIST having count(1)> 50 order by count(1);
select * from skulist_detail where item ='100024431';
select * from ma_asos.ma_item_mass_mnt_process where process_seq= '6852';

select * from ma_asos.ma_item_mass_mnt_process order by 1 desc; 

SELECT PROCESS_SEQ, ITEM, STATUS, ERROR_MESSAGE, ERROR_MESSAGE_DETAIL,       
       to_char(CREATE_DATETIME,'dd-mon-yy hh:mi:ss am') CREATE_DATETIME ,         
/       to_char(LAST_UPDATE_DATETIME,'dd-mon-yy hh:mi:ss am') LAST_UPDATE_DATETIME,
      CREATE_ID, LAST_UPDATE_ID
  FROM ma_asos.ma_item_mass_mnt_process where process_seq = '8577' order by 1 desc;


select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL 
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('a2vm8cv6wj548')
and s.snap_id = SQL.snap_id
and s.begin_interval_time> TO_date('02-dec-2020 09:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time< TO_date('02-dec-2020 13:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;





select count(1) from tran_data; --8460140

select count(1) from tran_data; --8460140

select * from v$sql where sql_id = 'btuhz613rkb8r';
select * from v$session where SQL_HASH_VALUE = '1199123735';
select * from v$process where spid='38377';

select
   SQL_ID,ROWS_PROCESSED
from v$sql
where hash_value= (select sql_hash_value from v$session where paddr= (select addr from v$process where spid='38377'));      


SELECT NVL(a.username, '(oracle)') AS username,
       a.osuser,
       a.sid,
       a.serial#,
       c.value AS &1,
       a.lockwait,
       a.status,
       a.module,
       a.machine,
       a.program,
       TO_CHAR(a.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session a,
       v$sesstat c,
       v$statname d
WHERE  a.sid        = c.sid
AND    c.statistic# = d.statistic#
AND    d.name       = DECODE(UPPER('&1'), 'READS', 'session logical reads',
                                          'EXECS', 'execute count',
                                          'CPU',   'CPU used by this session',
                                                   'CPU used by this session')
ORDER BY c.value DESC;

select * 
from DBA_HIST_SYSMETRIC_SUMMARY
where snap_id= '273'
  and metric_name in ('Host CPU Utilization (%)','I/O Megabytes per Second','I/O Requests per Second','Total PGA Allocated');
  
  
  SELECT spid, program,
            pga_max_mem      max,
            pga_alloc_mem    alloc,
            pga_used_mem     used,
            pga_freeable_mem free
       FROM V$PROCESS
      WHERE spid = 4696;
      
SELECT p.program,
            p.spid,
            pm.category,
            pm.allocated,
            pm.used,
            pm.max_allocated
       FROM V$PROCESS p, V$PROCESS_MEMORY pm
      WHERE p.pid = pm.pid
        AND p.pid = d;
        
SELECT a.sid,a.serial#,b.username,opname OPERATION,target OBJECT,TRUNC(elapsed_seconds,5),
    TO_CHAR(start_time, 'HH24:MI:SS') as start_time, ROUND ((sofar / totalwork) * 100, 2) as COMPLETEPErcet 
FROM v$session_longops a, v$session b 
    WHERE a.sid = b.sid AND b.sid ='2558' AND totalwork > 0 ORDER BY elapsed_seconds;



select *--opname "Description", round(totalwork/60/60) "Minutes Spent", round(time_remaining/60/60) "Minutes Left", sid
from v$session_longops
where sid in ('2558')
order by time_remaining desc;





SELECT name, value FROM v$parameter WHERE name = 'processes';

SELECT * FROM v$sgastat WHERE name = 'free memory' AND pool = 'shared pool';

SELECT name, value FROM v$sysstat WHERE name LIKE 'opened cursor%';

SELECT name, value FROM v$parameter WHERE name = 'db_block_size';




----------------------------- Finaal clean up -----------------------------

set serveroutput on;
set timing on;

declare
   
		l_int_seq_no	INT_ASOS.INT_BATCH_QUEUE.SEQ_NO%type;			
		l_filename     	INT_ASOS.INT_BATCH_QUEUE.EXT_REF_NO%type;

cursor c_tsf_upld  is
    select distinct FILENAME from int_asos.int_stg_man_tsf_upld where status = 'U';

begin

delete from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_batch_man_tsf_ulpd';

for r in c_tsf_upld loop 
   l_filename := r.FILENAME;
   
insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) 
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_batch_man_tsf_ulpd','N',l_filename,'T','INT_ASOS',sysdate,'INT_ASOS',sysdate
    from dual;

end loop;	 
commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


update restart_control set NUM_THREADS='3' where program_name like 'saimptlogfin';
Update rms.restart_program_status set PROGRAM_STATUS ='ready for start';
delete from rms.restart_bookmark;

SELECT x.owner,x.table_name, x.index_name, SUM(s.leaf_blocks) * TO_NUMBER(p.value) index_size,
REPLACE(DBMS_METADATA.GET_DDL('INDEX',x.index_name,x.owner),CHR(10),CHR(32)) ddl
FROM dba_ind_statistics s, dba_indexes x, dba_users u, v$parameter p
WHERE u.oracle_maintained = 'N'
AND x.owner = u.username
AND x.tablespace_name NOT IN ('SYSTEM','SYSAUX')
AND x.index_type LIKE '%NORMAL%'
AND x.table_type = 'TABLE'
AND x.status = 'VALID'
AND x.temporary = 'N'
AND x.dropped = 'NO'
AND x.visibility = 'VISIBLE'
AND x.segment_created = 'YES'
AND x.orphaned_entries = 'NO'
AND p.name = 'db_block_size'
AND s.owner = x.owner
AND s.index_name = x.index_name
GROUP BY
x.owner, x.table_name,x.index_name, p.value
HAVING
SUM(s.leaf_blocks) * TO_NUMBER(p.value) > :minimum_size_mb * POWER(2,20)
ORDER BY
index_size DESC


select status,count(1) from rpm_bulk_cc_pe_thread group by status;

Update rms.rpm_stage_simple_promo set PROCESS_ID =null, STATUS='N', ERROR_MESSAGE=null,STAGE_ID = rownum, promo_id=null,THREAD_NUM=null,PROMO_START_DATE='11-NOV-21'
, DTL_START_DATE='11-NOV-21'
where status = 'E' AND ERROR_MESSAGE ='INVALID_PROMO_HEADER_SETUP' AND rownum <= '20000';

select count(1) from rms.rpm_stage_price_change;
select status,count(1) from rms.rpm_stage_price_change group by status;
select change_type,count(1) from rms.rpm_stage_price_change group by change_type;
select effective_date,count(1) from rms.rpm_stage_price_change group by effective_date;


select status,EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance group by status,EFFECTIVE_DATE order by 1; --
select status,LOCATION,count(1) from rms.rpm_stage_clearance group by status,LOCATION order by 1; --
select state,count(1) from rms.rpm_clearance where clearance_id in (select  clearance_id from rms.rpm_stage_clearance) group by state;

select status,LOCATION,count(1) from rms.rpm_stage_simple_promo group by status,LOCATION order by 1; --
select status,PROMO_START_DATE,count(1) from rpm_stage_simple_promo group by status,PROMO_START_DATE;
select ERROR_MESSAGE,count(1) from rpm_stage_simple_promo group by ERROR_MESSAGE;

select STATE,count(1) from rpm_promo_dtl where PROMO_DTL_ID in (select distinct PROMO_DTL_ID from rpm_stage_simple_promo where status = 'W') group by STATE;

select * from rms.rpm_stage_simple_promo where status = 'E' AND ERROR_MESSAGE ='INVALID_PROMO_HEADER_SETUP' AND rownum <= '10000';

  Update rms.rpm_stage_simple_promo set stage_id= rownum,THREAD_NUM=null where status ='N'; 
  COMMIT; 


---------- Nw changs ---------- 

delete from ma_asos.MA_COMMODITY_CODES where COMMODITY_CODE ='4202929190';
Insert into ma_asos.MA_COMMODITY_CODES (GENDER,PRODUCT_TYPE,PRODUCT_DESCRIPTION,CONSTRUCTION,MAIN_FIBRE,IMPORT_COUNTRY,COMMODITY_CODE,EXTRA_INFORMATION,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) values ('3','236','WAISTPACK','3',null,'DE','4202929190',null,to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');
Insert into ma_asos.MA_COMMODITY_CODES (GENDER,PRODUCT_TYPE,PRODUCT_DESCRIPTION,CONSTRUCTION,MAIN_FIBRE,IMPORT_COUNTRY,COMMODITY_CODE,EXTRA_INFORMATION,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) values ('3','236','WAISTPACK','3',null,'GB','4202929190',null,to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');
Insert into ma_asos.MA_COMMODITY_CODES (GENDER,PRODUCT_TYPE,PRODUCT_DESCRIPTION,CONSTRUCTION,MAIN_FIBRE,IMPORT_COUNTRY,COMMODITY_CODE,EXTRA_INFORMATION,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) values ('3','236','WAISTPACK','3',null,'US','4202929190',null,to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');


Update partner set CURRENCY_CODE ='GBP',PRINCIPLE_COUNTRY_ID='GB', VAT_REGION ='1001',STATUS='A' where PARTNER_ID='F100836';
update addr set COUNTRY_ID ='GB' where KEY_VALUE_2='F100836';
Insert into ma_asos.ma_supplier_factory (SUPPLIER,FACTORY,STATUS,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID)
    values (1100000086,'F100836','A',to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');
    
update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');
drop table uda_item_defaults_bk;
create table uda_item_defaults_bk as select * from rms.uda_item_defaults ;
delete from rms.uda_item_defaults;
insert into uda_item_defaults select * from uda_item_defaults_bk ;

delete from UDA_VALUES where UDA_ID ='5003';
delete from uda where UDA_ID ='5003';

Insert into uda (UDA_ID,UDA_DESC,MODULE,DISPLAY_TYPE,DATA_TYPE,DATA_LENGTH,SINGLE_VALUE_IND,FILTER_ORG_ID,FILTER_MERCH_ID,FILTER_MERCH_ID_CLASS,FILTER_MERCH_ID_SUBCLASS,CREATE_ID,CREATE_DATETIME) values 
(5003,'AUTO_EAN','ITEM','LV','ALPHA',null,'N',null,null,null,null,'ORACNV',to_date('24-MAY-19','DD-MON-RR'));
Insert into UDA_VALUES (UDA_ID,UDA_VALUE,UDA_VALUE_DESC,CREATE_ID,CREATE_DATETIME) values 
(5003,'2','N','ORACNV',to_date('24-MAY-19','DD-MON-RR'));
Insert into UDA_VALUES (UDA_ID,UDA_VALUE,UDA_VALUE_DESC,CREATE_ID,CREATE_DATETIME) values 
(5003,'1','Y','ORACNV',to_date('24-MAY-19','DD-MON-RR'));


select TABLE_OWNER, TABLE_NAME,count(1) from all_indexes where owner in ('RMS','INT_ASOS','MA_ASOS') group by TABLE_OWNER, TABLE_NAME order by TABLE_NAME;
select * from rms.NB_SUPS_VAT_REGION_MATRIX;
select OWNER, INDEX_NAME, INDEX_TYPE, TABLE_OWNER, TABLE_NAME, TABLE_TYPE 
    from all_indexes where owner ='RMS' and TABLE_NAME in ('ITEM_LOC_HIST','NB_SHIPSKU_REV','ORDCUST','RPM_PROMO_ITEM_LOC_EXPL') order by TABLE_NAME,INDEX_NAME;
select OWNER, INDEX_NAME, INDEX_TYPE, TABLE_OWNER, TABLE_NAME, TABLE_TYPE 
    from all_indexes where owner in('MA_ASOS','RMS','INT_ASOS') and TABLE_NAME in ('ITEM_LOC_HIST','NB_SHIPSKU_REV','ORDCUST','RPM_PROMO_ITEM_LOC_EXPL','MA_GROUP_DETAIL','MA_GROUP_HEADER') order by TABLE_NAME,INDEX_NAME;




SELECT * FROM V$DATABASE;

select * from gv$statistics_level;
select * from V$SQL_PLAN_STATISTICS;
select * from V$SQL where sql_id = '49xvssdzd07su';

select * from V$SYS_TIME_MODEL;
select * from V$SESS_TIME_MODEL;



 -- Database Time Model Query Example
SELECT STAT_NAME, TO_CHAR(VALUE/1000000,'999,999') TIME_S
FROM V$SYS_TIME_MODEL
WHERE VALUE <>0 AND STAT_NAME NOT IN ('background elapsed time',
'background cpu time')
ORDER BY VALUE DESC;

--Sessions Time Model Query

SELECT S.SID, S.USERNAME, T.STAT_NAME,
ROUND(T.VALUE/1000000,2) "TIME (SEC)"
FROM V$SESS_TIME_MODEL T, V$SESSION S
WHERE T.SID = S.SID AND T.STAT_NAME IN ('DB time','DB CPU')
AND S.USERNAME IS NOT NULL ORDER BY T.VALUE DESC;


select * from DBA_HIST_SYS_TIME_MODEL;

--Using Time Model to Measure System Scalability
SELECT TO_CHAR(DBTIME.VALUE/1000000,'999,999') DBTIME,
TO_CHAR(DBCPU.VALUE/1000000,'999,999') DBCPU,
TO_CHAR((DBTIME.VALUE-DBCPU.VALUE)/1000000,'999,999') WAIT_TIME,
TO_CHAR((DBTIME.VALUE-DBCPU.VALUE)/DBTIME.VALUE*100,'99.99') || '%'
WAIT_PCT,
(SELECT COUNT(*) FROM V$SESSION WHERE USERNAME IS NOT NULL) USERS_CNT
FROM V$SYS_TIME_MODEL DBTIME, V$SYS_TIME_MODEL DBCPU
WHERE DBTIME.STAT_NAME = 'DB time' AND DBCPU.STAT_NAME = 'DB CPU';



select * from V$SYSSTAT;
select * from V$STATNAME;
select * from V$SERVICE_STATS;
select * from V$MYSTAT;
select * from V$SEGMENT_STATISTICS;

System: - V$SYSSTAT • Services: - V$SERVICE_STATS • Sessions: - V$SESSTAT - V$MYSTAT Note: Usually linked with V$STATNAME • Segment: - V$SEGMENT_STATISTICS

V$SESSION_WAIT or V$SESSION

select * from V$SESSION_WAIT;
select * from V$SESSION;



V$SYSTEM_EVENT, V$SESSION_EVENT, and
V$SERVICE_EVENT and more.
--Full list can be obtained from V$EVENT_NAME
select * from V$EVENT_NAME;
select * from V$_EVENT;
select * from V$SYSTEM_EVENT;
select * from V$SESSION_EVENT;
select * from V$SERVICE_EVENT;

select * from V$SYSTEM_WAIT_CLASS;
select * from V$SESSION_WAIT_CLASS;
select * from V$SESSION_WAIT;
select * from V$SESSION_WAIT_HISTORY;

V$SYSTEM_EVENT Wait event statistics at the instance level
V$SESSION_EVENT Wait event statistics per session
V$SERVICE_EVENT Wait event statistics per service
V$SYSTEM_WAIT_CLASS Wait event statistics at the system level aggregated by wait
class
V$SESSION_WAIT_CLASS Wait event statistics at the session level aggregated by wait
class
V$SERVICE_WAIT_CLASS Wait event statistics at the service level aggregated by wait
class
V$SESSION Current wait events are included in the current sessions
V$SESSION_WAIT Current wait events by current sessions
V$SESSION_WAIT_HISTORY The last 10 wait events for current active sessions



select * from V$SESSION;
select * from V$SESSION_WAIT;

select * from dba_hist_wr_control;