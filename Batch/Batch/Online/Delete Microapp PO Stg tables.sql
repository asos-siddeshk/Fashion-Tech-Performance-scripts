select * from logger_logs where id >= '39018025' order by 1 desc;


select * from ALL_SEQUENCES where sequence_name like 'LOGGER%';

--alter session set current_schema=rms;
select * from rms.DAILY_PURGE;
select count(1) from rms.ORDHEAD_LOCK;

delete from rms.DAILY_PURGE;
delete from rms.ORDHEAD_LOCK;

select * from SUPP_ASOS.SC_ORDER_LOCK;
commit;

truncate table del_order;

select count(1) from ordhead;
select status,count(1) from ordhead group by status order by 1;
select supplier,count(1) from ordhead group by supplier order by 1;
select * from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and trunc(CREATE_DATETIME) >='06-APR-20';
select OPTION_ID from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and trunc(CREATE_DATETIME) >='07-APR-20';
select FINAL_DEST,Count(1) from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P'  and trunc(CREATE_DATETIME) >='07-APR-20' and QTY_ORDERED = '70' group by FINAL_DEST;


select count(1) from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and trunc(CREATE_DATETIME) >='06-APR-20' and QTY_ORDERED = '70';
select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku where OPTION_ID in (select OPTION_ID from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and trunc(CREATE_DATETIME) >= '06-APR-20');
select count(distinct MASTER_ORDER_NO) from ma_asos.ma_stg_sizing_sku where OPTION_ID in (select OPTION_ID from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and trunc(CREATE_DATETIME) >= '06-APR-20');

select * from ma_asos.ma_stg_sizing_sku;


set serveroutput on;
set TIMING on;

DECLARE
    c_commit  	  NUMBER(8):= 0;
  O_ERROR_MESSAGE VARCHAR2(200);
  I_MASTER_ORDER_NO NUMBER;
  v_Return BOOLEAN;
  
  CURSOR c_order is
    select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='A'
 UNION
    select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku where OPTION_ID in (select OPTION_ID from ma_asos.MA_ORDER_REC_HEAD_STG )
 UNION
    select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku where OPTION_ID in (select parent from ma_asos.ma_v_replenishment where supplier= '1100000086')
 /*  union  
    select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='W' AND ROWNUM<='50'
    union
    select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='S' AND ROWNUM<='300' order by 1 desc */ ;
  
BEGIN

for k in c_order loop
		I_MASTER_ORDER_NO:=k.MASTER_ORDER_NO;
        

  v_Return := MA_ASOS.MA_ORDER_UTILS_SQL.DELETE_STG_ORDER_TABLES(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_MASTER_ORDER_NO => I_MASTER_ORDER_NO
  );
 
IF (v_Return) THEN 
    insert into del_order VALUES (I_MASTER_ORDER_NO,'S');
  ELSE
    insert into del_order VALUES (I_MASTER_ORDER_NO,O_ERROR_MESSAGE);
  END IF;
     c_commit :=c_commit + 1;
   IF MOD(c_commit, 10) = 0 THEN
    COMMIT;
   END IF;

END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

