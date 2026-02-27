select status,count(1) from ma_asos.ma_stg_order group by status;
select count(1) from ma_asos.ma_stg_sizing_sku;
select status,count(1) from ordhead group by status;

select * from ma_asos.ma_stg_order;
select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku where OPTION_ID = '100000897';


select * from ma_asos.ma_stg_order where MASTER_ORDER_NO not in (select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku); --1856

select count(distinct (MASTER_ORDER_NO)) from ma_asos.ma_stg_sizing_sku;

select MASTER_ORDER_NO,count(1) from ma_asos.ma_stg_sizing_sku group by MASTER_ORDER_NO order by MASTER_ORDER_NO desc;

select * from PO_MA_CID_NOTEXIST;
select distinct (MASTER_ORDER_NO)) from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO not in (select MASTER_ORDER_NO from ma_asos.ma_stg_order);

select count(distinct (MASTER_ORDER_NO)) from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO not in (select MASTER_ORDER_NO from ma_asos.ma_stg_order);

select * from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO ='20490083';

select * from ma_asos.ma_stg_order where status ='A';
create table del_order (I_MASTER_ORDER_NO NUMBER,ERROR_MESSAGE VARCHAR2(200));

select status,count(1) from ma_asos.ma_stg_order group by status;
select count(1) from ma_asos.ma_stg_sizing_sku; --137803434

drop table PO_MA_CID_NOTEXIST;
create table PO_MA_CID_NOTEXIST as
    select distinct (MASTER_ORDER_NO) from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO not in (select distinct MASTER_ORDER_NO from ma_asos.ma_stg_order);
insert into PO_MA_CID_NOTEXIST
select distinct (MASTER_ORDER_NO) from ma_asos.ma_stg_order where MASTER_ORDER_NO not in (select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku);


select * from PO_MA_CID_NOTEXIST;

select distinct (MASTER_ORDER_NO) from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO in (select MASTER_ORDER_NO from ma_asos.ma_stg_order);

select * from rms.ordhead where MASTER_PO_NO in (select MASTER_ORDER_NO from PO_MA_CID_NOTEXIST);

select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='A';
select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='W' AND ROWNUM<='10032';
select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='S' AND ROWNUM<='17060';

select distinct MASTER_PO_NO from rms.ordhead where MASTER_PO_NO in (select MASTER_ORDER_NO from ma_asos.ma_stg_order );
SELECT * FROM del_order where error_message not like '%S%';
    
W	14032
S	17060
A	11993

drop table PO_MA_CID_NOTEXIST;
create table PO_MA_CID_NOTEXIST as
    select distinct (MASTER_ORDER_NO) from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO not in (select distinct MASTER_ORDER_NO from ma_asos.ma_stg_order);

insert into PO_MA_CID_NOTEXIST
select distinct (MASTER_ORDER_NO) from ma_asos.ma_stg_order where MASTER_ORDER_NO not in (select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku);



set serveroutput on;
set TIMING on;

DECLARE
    c_commit  	  NUMBER(8):= 0;
  O_ERROR_MESSAGE VARCHAR2(200);
  I_MASTER_ORDER_NO NUMBER;
  v_Return BOOLEAN;
  
  CURSOR c_order is
    select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='A'
/*  UNION
    select MASTER_ORDER_NO from PO_MA_CID_NOTEXIST
   union  
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





TRUNCATE TABLE SVC_ORDSKU_HTS_ASSESS;
TRUNCATE TABLE SVC_ORDSKU_HTS;
TRUNCATE TABLE SVC_ORDLOC_EXP;
TRUNCATE TABLE SVC_ORDLC;
TRUNCATE TABLE SVC_ORDHEAD_CFA_EXT;
TRUNCATE TABLE SVC_ORDDETAIL;
TRUNCATE TABLE SVC_ORDHEAD;
TRUNCATE TABLE coresvc_po_err;


ALTER TABLE SVC_ORDSKU_HTS_ASSESS MOVE;
ALTER TABLE SVC_ORDSKU_HTS MOVE;
ALTER TABLE SVC_ORDLOC_EXP MOVE;
ALTER TABLE SVC_ORDLC MOVE;
ALTER TABLE SVC_ORDHEAD_CFA_EXT MOVE;
ALTER TABLE SVC_ORDHEAD MOVE;
ALTER TABLE SVC_ORDDETAIL MOVE;

ALTER INDEX SVC_OCE_UK REBUILD ONLINE;
ALTER INDEX SVC_ORDLOC_EXP_PK REBUILD ONLINE;
ALTER INDEX SVC_ORDSKU_HTS_PK REBUILD ONLINE;
ALTER INDEX SVC_OHA_UK REBUILD ONLINE;
ALTER INDEX UK_SVC_ORDHEAD_1 REBUILD ONLINE;
ALTER INDEX SVC_ORD_UK REBUILD ONLINE;
ALTER INDEX SVC_ORH_UK REBUILD ONLINE;
ALTER INDEX SVC_ODT_UK REBUILD ONLINE;
ALTER INDEX SVC_ORDSKU_HTS_ASSESS_PK REBUILD ONLINE;
ALTER INDEX SVC_ORDHEAD_PK REBUILD ONLINE;
ALTER INDEX SVC_ORDDETAIL_PK REBUILD ONLINE;
ALTER INDEX SVC_ORDHEAD_CFA_EXT_PK REBUILD ONLINE;
ALTER INDEX SVC_ORDLC_PK REBUILD ONLINE;
ALTER INDEX SVC_ORE_UK REBUILD ONLINE;
truncate table daily_purge;


select * from ordhead where
    MASTER_PO_NO in (select MASTER_PO_NO from ordupdqty);