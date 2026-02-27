select zone_id,count(1) from int_asos.int_pe_simple_promo_stg where INT_STATUS='N' group by zone_id;
select zone_id,count(1) from int_asos.int_pe_simple_promo_stg group by zone_id;
select INT_STATUS,count(1) from int_asos.int_pe_simple_promo_stg group by INT_STATUS; --1369051
select count(1) from int_asos.int_pe_simple_promo_stg;
select count(1) from  ma_asos.ma_stage_simple_promo;
select * from  rpm_stage_simple_promo;
select count(1) from  rpm_stage_simple_promo;

select state,count(1) from rms.rpm_promo_dtl where trunc(CREATE_DATE) = '02-MAR-20' group by state;

select * from rpm_bulk_cc_pe_thread  group by status;
select status,count(1) from rpm_bulk_cc_pe_thread  group by status;
select THREAD_NUM,status,ERROR_MESSAGE,count(1) from rpm_stage_simple_promo group by THREAD_NUM,status,ERROR_MESSAGE;

sed -i 's/20200917/20201217/g' *.csv
sed -i 's/20200918/20201228/g' *.csv
sed -i 's/20200919/20201219/g' *.csv
sed -i 's/20200927/20201228/g' *.csv


select (797187)/15 from dual; 53k options --7.30 -- to process
select (797187-626256)/15 from dual; 12k options --10.30
select (797187-597945)/15 from dual; 13.2k options --11.00
select (797187-597945)/15 from dual; 13.2k options --11.00
select (250000)/15 from dual; 18k options --11.00


cd /asos/oracle/prod/data/inbound/Merret/archive
cd /asos/oracle/prod/data/inbound/Merret/pending

cd /orabin/app/oracle/product/retail/batch/error
cd /orabin/app/oracle/product/retail/batch/log
cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin
vi int_price_upload.ksh

select * from rms_plsql_batch_config where program_name like 'INT_PRICING_ONL_SQL';
select * from rms.rms_plsql_batch_config where program_name like '%PRICING%';

begin
delete rpm_stage_item_loc_clean; 
delete rpm_stage_item_loc; 
delete from ma_asos.ma_stage_price_change;
delete from ma_asos.ma_stage_clearance;
delete from ma_asos.ma_stage_simple_promo;
delete from ma_asos.MA_STAGE_PROM_DTL_CUST_ATTR;
commit;
end;
/

delete from int_asos.INT_PE_FILE_UPLD where trunc(CREATE_DATETIME) = trunc(sysdate);
-- Data Corrections

begin 
--delete FROM oracnv.DM_XREF_STYLE_COLOUR_KEY WHERE item in (select item from PTITEMS) ;
delete FROM int_asos.INT_BATCH_QUEUE WHERE BATCH_NAME = 'int_price_release.ksh';
delete int_asos.INT_PE_XREF_PROMO_DTL;
delete int_asos.INT_PE_SIMPLE_PROMO_STG;
delete from int_asos.INT_PE_PROM_UPLD where EXT_BATCH_SEQ_NO>='85597';
commit;
end;
/

truncate table int_asos.INT_PE_XREF_PROMO_DTL;
truncate table int_asos.INT_PE_SIMPLE_PROMO_STG;
truncate table int_asos.INT_PE_PROM_UPLD;

Update ma_asos.MA_PRICE_EVENT_THRESHOLD set PRICE_CHANGE_LOCS='10', CLEARANCE_LOCS='10', SIMPLE_PROMO_LOCS='5000', COMPLEX_PROMO_LOCS='10', CLEARANCE_RESET_LOCS='10';
Update ma_asos.MA_PRICE_EVENT_THRESHOLD set SIMPLE_PROMO_LOCS='5000';
select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;

begin
delete rpm_stage_item_loc_clean; 
delete rpm_stage_item_loc; 
delete from ma_asos.ma_stage_price_change;
delete from ma_asos.ma_stage_clearance;
commit;
end;
/


WF_PE_FILE_UPLOAD chain
WF.RMS.WF_PE_RELEASE_CYCLE Chain
./int_price_upload_pre.ksh  

 select * from int_asos.INT_PE_FILE_UPLD order by 3 desc;
 select * from int_asos.INT_PE_FILE_UPLD where trunc(CREATE_DATETIME) = trunc(sysdate);
 select * from int_asos.INT_PE_PROM_UPLD where EXT_BATCH_SEQ_NO <'85597';
 select * from int_asos.INT_PE_XREF_PROMO_DTL; --802217

select * from int_asos.INT_PE_PROM_UPLD where EXT_BATCH_SEQ_NO>='85597' and INT_STATUS='N';

select INT_STATUS,INT_ERROR_MSG,count(1) from int_asos.INT_PE_PROM_UPLD where EXT_BATCH_SEQ_NO>='85597' group by INT_STATUS,INT_ERROR_MSG;
select zone_id,count(1) from int_asos.int_pe_simple_promo_stg group by zone_id;
select INT_STATUS,count(1) from int_asos.int_pe_simple_promo_stg group by INT_STATUS;
select count(1) from int_asos.int_pe_simple_promo_stg;

vi int_price_upload.ksh
select INT_STATUS,count(1) from int_asos.int_pe_simple_promo_stg where SOURCE_EXT_BATCH_SEQ_NO>='85597' group by INT_STATUS;
select * from int_asos.int_pe_simple_promo_stg;
select * from int_asos.int_pe_simple_promo_stg where SOURCE_EXT_BATCH_SEQ_NO='85597';
select distinct item from int_asos.int_pe_simple_promo_stg where SOURCE_EXT_BATCH_SEQ_NO='85597';
select * from int_asos.INT_PE_PROM_UPLD where EXT_BATCH_SEQ_NO='85597';
select INT_STATUS,count(1) from int_asos.int_pe_simple_promo_stg where SOURCE_EXT_BATCH_SEQ_NO='85597' group by INT_STATUS;
select * from int_asos.INT_V_PE_BLOCKED_ITEM_ZONES; 

cd /orabin/app/oracle/product/retail/batch/error
cd /orabin/app/oracle/product/retail/batch/log
cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin
vi int_price_upload.ksh


select * FROM int_asos.INT_BATCH_QUEUE WHERE BATCH_NAME = 'int_price_release.ksh';

        IF INT_PRICING_PROM_SQL.LOAD (:GV_script_error, L_errors_prom) = FALSE THEN
        INT_BATCH_SCHEDULER_SQL.SET_REQUEST
--        delete FROM int_asos.INT_BATCH_QUEUE WHERE BATCH_NAME = 'int_price_release.ksh';


WF.RMS.WF_PE_RELEASE_CYCLE Chain


nb_prepost pre
select * FROM int_asos.INT_BATCH_QUEUE WHERE BATCH_NAME = 'int_price_release.ksh'; -- Status in L for long
    INT_BATCH_SCHEDULER_SQL.PRE_POST_PROCESS
    --INSERT INTO int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, STATUS, KEY_1, KEY_2, KEY_3, KEY_4, EXT_REF_NO, REQUEST_TYPE, ERROR_DESC, CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) VALUES (int_asos.INT_BATCH_QUEUE_SEQ.NEXTVAL, 'int_price_release.ksh', 'N', NULL, NULL, NULL, NULL, NULL, 'T', NULL, USER,SYSDATE, USER, SYSDATE);


vi int_price_release.ksh

select INT_STATUS,count(1) from int_asos.int_pe_simple_promo_stg group by INT_STATUS;
select PROMO_DTL_ID from int_asos.int_pe_simple_promo_stg where SOURCE_EXT_BATCH_SEQ_NO>='85597';

select zone_id, count(1) from ma_asos.MA_STAGE_SIMPLE_PROMO group by zone_id; --13 zones 250~ distinct options

select * from ma_asos.MA_STAGE_SIMPLE_PROMO;
select * from ma_asos.MA_STAGE_PROM_DTL_CUST_ATTR;

     IF INT_PROMO_SQL.UNBLOCK_FAILED_RECORDS (:GV_script_error) = FALSE THEN
        RAISE FUNCTION_ERROR;
     END IF;
    IF INT_PROMO_SQL.RELEASE (:GV_script_error) = FALSE THEN
          RAISE FUNCTION_ERROR;
        END IF;
      

----- RPM -- Intra day --- 
select * from ma_asos.MA_STAGE_SIMPLE_PROMO;
select * from ma_asos.MA_STAGE_PROM_DTL_CUST_ATTR;

create table rpm_STAGE_SIMPLE_PROMO_29_d as 
    select * from rpm_STAGE_SIMPLE_PROMO;

select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;  --E	1119

select * from rpm_stage_simple_promo;
select * from rpm_STAGE_SIMPLE_PROMO_29_d;
select state,count(1) from rms.rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rpm_stage_simple_promo) group by state;

select * from ma_asos.ma_stage_simple_promo;
select * from ma_asos.MA_STAGE_PROM_DTL_CUST_ATTR;


nb_prepost post
select * FROM int_asos.INT_BATCH_QUEUE WHERE BATCH_NAME = 'int_price_release.ksh'; -- Status in L for long

int_price_release_post.ksh   /@int_asos_rms

select INT_STATUS,count(1) from int_asos.int_pe_simple_promo_stg group by INT_STATUS;
select * from int_asos.int_pe_simple_promo_stg where SOURCE_EXT_BATCH_SEQ_NO='85597' and INT_STATUS = 'N';
select * from int_asos.INT_V_PE_BLOCKED_ITEM_ZONES; 
select * FROM int_asos.INT_BATCH_QUEUE WHERE BATCH_NAME = 'int_price_release.ksh';

select * from int_asos.INT_PE_SIMPLE_PROMO_STG where trunc(CREATE_DATETIME)! = trunc(sysdate);
select * from int_asos.int_pe_xref_promo_dtl where trunc(CREATE_DATETIME)= trunc(sysdate);

   IF INT_PROMO_SQL.BLOCK_FAILED_RECORDS (:GV_script_error) = FALSE THEN
   IF INT_PROMO_SQL.RESET_PROMO_DTL_ID (:GV_script_error) = FALSE THEN
   IF INT_PRICING_PROM_SQL.ARCHIVE (:GV_script_error) = FALSE THEN
   IF INT_PROMO_SQL.ARCHIVE (:GV_script_error) = FALSE THEN
   
cd /orabin/app/oracle/product/retail/batch/error
cd /orabin/app/oracle/product/retail/batch/log
cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin
vi int_price_release_post.ksh

 select MAX_PROMO_COMP_DETAIL from RPM_SYSTEM_OPTIONS;

 select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;
 
 select * from rpm_promo order by 1 desc;
 select * from rpm_promo_comp order by 1 desc;

    select * from int_asos.int_pe_xref_promo;

delete from int_asos.INT_PE_SIMPLE_PROMO_STG where trunc(CREATE_DATETIME)! = trunc(sysdate);


select * from V$RESTORE_POINT;
 
 select * from rpm_STAGE_SIMPLE_PROMO;

select state,count(1) from rms.rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rpm_STAGE_SIMPLE_PROMO_29_d) group by state;




select node.item, decode(item_level, tran_level, 'TRAN', 'PARENT') item_type,
       NVL(rzl.location, rzl.zone_id) loc, rp.promo_display_id, comp.comp_display_id, comp.customer_type, 
       dtl.promo_dtl_display_id, dtl.start_date, dtl.end_date,
       dsc.change_type, NVL(dsc.change_percent, dsc.change_amount) discount, dtl.price_guide_id,
       decode(dtl.state, 0, 'worksheet', 1, 'rejected', 2, 'submitted', 3, 'approved', 
                         4, 'cancelled', 5, 'active', 6, 'complete', 7, 'conflict checking', 8, 'pending', 'n/a') state,
       DECODE(expl.promo_dtl_id, null, 'NO', 'YES') flowed,
       dtl.create_id, to_char(dtl.approval_date, 'DD/Mon/YYYY: HH24:MM:SS') approval_date,
       dtl.approval_id, to_char(dtl.create_date, 'DD/Mon/YYYY: HH24:MM:SS') create_date
from rpm_promo_dtl dtl,
     rpm_promo_dtl_merch_node node,
     rpm_promo_zone_location rzl,
     rpm_promo_dtl_list_grp grp,
     rpm_promo_dtl_list lst,
     rpm_promo_dtl_disc_ladder dsc,
     rpm_promo_comp comp,
     rpm_promo rp,
     item_master im,
     rpm_promo_item_loc_expl expl
where node.promo_dtl_id = dtl.promo_dtl_id
and rzl.promo_dtl_id = dtl.promo_dtl_id
and node.promo_dtl_id = rzl.promo_dtl_id
and grp.promo_dtl_id = dtl.promo_dtl_id
and lst.promo_dtl_list_grp_id = grp.promo_dtl_list_grp_id
and lst.promo_dtl_list_id = dsc.promo_dtl_list_id
and comp.promo_comp_id = dtl.promo_comp_id
and rp.promo_id = comp.promo_id
and im.item = node.item
and dtl.PROMO_DTL_ID in (select PROMO_DTL_ID from int_asos.int_pe_simple_promo_stg)
and dtl.promo_dtl_id = expl.promo_dtl_id(+)
order by node.item, rzl.location, approval_date desc, dtl.start_date;



select * from all_sequences where sequence_name like '%PROMO%' order by 1,2;

RPM_PROMO_COMP_DISPLAY_ID_SEQ
RPM_PROMO_COMP_SEQ
RPM_PROMO_DETAIL_DISPLAY_SEQ
RPM_PROMO_DISPLAY_ID_SEQ
RPM_PROMO_DTL_SEQ
RPM_PROMO_SEQ



select rms.RPM_PROMO_COMP_DISPLAY_ID_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 264837 INTO last_used FROM dual; --7051315644

  LOOP
    SELECT rms.RPM_PROMO_COMP_DISPLAY_ID_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/





 
-- Before ------  
 DECLARE

  L_rpm_promo_start_date DATE;
  L_rpm_promo_end_date   DATE      := TO_DATE('31-12-2025 23:59:00', 'DD-MM-YYYY HH24:MI:SS');

  L_rpm_promo_comp_type  NUMBER(2) := 1;

  L_rpm_promo_name_start   VARCHAR2(160) := 'Merret ';
  L_rpm_promo_name_end     VARCHAR2(160) := ' migrated promotions ';

  L_promo_comp_name       VARCHAR2(160) := ' Merret Simple Promotions 1';
  L_promo_comp_id         NUMBER(10);
  L_promo_comp_display_id VARCHAR2(10);

  CURSOR C_get_promo IS
    select a.name,
           a.currency_code,
           xr.rpm_zone_id as zone_id,
           a.promo_id,
           a.promo_display_id,
           a.start_date,
           a.end_date,
           count(*) as cnt
      from rms.rpm_promo a,
           rms.rpm_promo_comp b,
           int_asos.int_pe_xref_promo xr
     where a.promo_id = b.promo_id
       and b.promo_comp_id = xr.rpm_promo_comp_id
    /* ADD HERE ZONES TO BE ADDED PROMO COMPS */
       and xr.rpm_zone_id in (99,100,101,102,103,104,105,106,107,108,109,110,111,112,113)
    /* ADD HERE MONTH TO BE ADDED PROMO COMPS */
       and xr.create_month = TO_DATE('2020-10-01', 'YYYY-MM-DD')
     group by a.name,
              a.currency_code,
              xr.rpm_zone_id,
              a.promo_id,
              a.promo_display_id,
              a.start_date,
              a.end_date;

  CURSOR get_vdate IS
    SELECT vdate
    from rms.period;

BEGIN

  OPEN get_vdate;
  FETCH get_vdate INTO L_rpm_promo_start_date;
  CLOSE get_vdate;

  /* ADD HERE NUMBER OF PROMO COMPS PER MONTH ZONE*/
  FOR i in 1..300 loop

  FOR ph IN C_get_promo LOOP

  INSERT INTO rms.rpm_STAGE_SIMPLE_PROMO
  (STAGE_SIMPLE_PROMO_ID,
   --MESSAGE_SEQ,
   --MESSAGE_TYPE,
   PROMO_ID,
   PROMO_COMP_ID,
   COMP_DISPLAY_ID,
   PROMO_DTL_ID,
   PROMO_DTL_DISPLAY_ID,
   MERCH_TYPE,
   DEPT,
   CLASS,
   SUBCLASS,
   DIFF_ID,
   ITEM,
   ATTRIBUTE_1,
   ATTRIBUTE_2,
   ATTRIBUTE_3,
   ZONE_NODE_TYPE,
   ZONE_ID,
   LOCATION,
   APPLY_TO_CODE,
   PROMO_START_DATE,
   PROMO_END_DATE,
   IGNORE_CONSTRAINTS,
   CHANGE_TYPE,
   CHANGE_AMOUNT,
   CHANGE_PERCENT,
   CHANGE_SELLING_UOM,
   PRICE_GUIDE_ID,
   AUTO_APPROVE_IND,
   PROCESS_ID,
   STATUS,
   ERROR_MESSAGE,
   SKULIST,
   TIMEBASED_DTL_IND,
   THREAD_NUM,
   EXCLUSION_CREATED,
   STAGE_ID,
   STAGE_PROMO_COMP_ID,
   NAME,
   --DESCRIPTION,
   --PROMO_COMP_NAME,
   PROMO_EVENT_ID,
   DTL_START_DATE,
   DTL_END_DATE,
   PROMO_SECONDARY_IND,
   COMP_SECONDARY_IND,
   CONSIGNMENT_RATE,
   COMMENTS,
   VENDOR_FUNDED_IND,
   NEW_DEAL,
   DEAL_ID,
   DEAL_DETAIL_ID,
   PARTNER_TYPE,
   PARTNER_ID,
   SUPPLIER,
   CONTRIBUTION_PERCENT,
   INCLUDE_VAT_IND,
   STOCK_LEDGER_IND,
   INVOICE_PROC_LOGIC_CODE,
   DEAL_REPORT_LEVEL_CODE,
   BILL_BACK_PERIOD_CODE,
   BILL_BACK_METHOD_CODE,
   ZONE_GROUP_ID,
   CUSTOMER_TYPE,
   CURRENCY_CODE,
   FUNDING_PERCENT,
   PROMO_DISPLAY_ID,
   STAGE_PROM_CUST_ATTR_ID,
   STAGE_PROM_COMP_CUST_ATTR_ID,
   STAGE_PROM_DTL_CUST_ATTR_ID,
   PROM_CUST_ATTR_ID,
   PROM_COMP_CUST_ATTR_ID,
   PROM_DTL_CUST_ATTR_ID)
  VALUES
  (rms.rpm_injector_process_id_seq.NEXTVAL, --STAGE_SIMPLE_PROMO_ID
   --ma_process_id_seq.NEXTVAL, --STAGE_PROCESS_ID
   --ma_rpm_message_seq.NEXTVAL, --MESSAGE_SEQ
   --'A', --MESSAGE_TYPE
   ph.PROMO_ID, --PROMO_ID
   NULL, --PROMO_COMP_ID
   NULL, --COMP_DISPLAY_ID
   NULL, --PROMO_DTL_ID,
   NULL, --PROMO_DTL_DISPLAY_ID,
   rms.RPM_CONSTANTS.ITEM_LEVEL_ITEM, --MERCH_TYPE
   NULL, --DEPT
   NULL, --CLASS
   NULL, --SUBCLASS
   NULL, --DIFF_ID
   '100000001', --ITEM
   NULL, --ATTRIBUTE_1
   NULL, --ATTRIBUTE_2
   NULL, --ATTRIBUTE_3
   1, --ZONE_NODE_TYPE
   ph.ZONE_ID, --ZONE_ID,
   NULL, --LOCATION,
   2, --APPLY_TO_CODE,
   ph.start_date, --PROMO_START_DATE
   TRUNC(ph.end_date, 'MI'), --PROMO_END_DATE
   0, --IGNORE_CONSTRAINTS
   -1, --CHANGE_TYPE
   NULL, --CHANGE_AMOUNT
   NULL, --CHANGE_PERCENT
   NULL, --CHANGE_SELLING_UOM
   NULL, --PRICE_GUIDE_ID
   0, --AUTO_APPROVE_IND
   rms.rpm_injector_process_id_seq.nextval, --PROCESS_ID
   'N', --STATUS
   NULL, --ERROR_MESSAGE
   NULL, --SKULIST
   1, --TIMEBASED_DTL_IND
   NULL, --THREAD_NUM
   NULL, --EXCLUSION_CREATED
   NULL, --STAGE_ID
   rms.rpm_stage_promo_simple_seq.NEXTVAL, --STAGE_PROMO_COMP_ID
   ph.name, --NAME 
  -- L_rpm_promo_name_start || ph.currency_code || L_rpm_promo_name_end || ph.mon, --DESCRIPTION
   --ph.comp_name || L_promo_comp_name, --PROMO_COMP_NAME
   NULL, --PROMO_EVENT_ID
   L_rpm_promo_start_date, --DTL_START_DATE
   L_rpm_promo_end_date, --DTL_END_DATE
   0, --PROMO_SECONDARY_IND
   0, --COMP_SECONDARY_IND
   NULL, --CONSIGNMENT_RATE
   NULL, --COMMENTS
   0, --VENDOR_FUNDED_IND
   NULL, --NEW_DEAL
   NULL, --DEAL_ID
   NULL, --DEAL_DETAIL_ID
   NULL, --PARTNER_TYPE
   NULL, --PARTNER_ID
   NULL, --SUPPLIER
   NULL, --CONTRIBUTION_PERCENT
   NULL, --INCLUDE_VAT_IND
   NULL, --STOCK_LEDGER_IND
   NULL, --INVOICE_PROC_LOGIC_CODE
   NULL, --DEAL_REPORT_LEVEL_CODE
   NULL, --BILL_BACK_PERIOD_CODE
   NULL, --BILL_BACK_METHOD_CODE
   NULL, --ZONE_GROUP_ID
   NULL, --CUSTOMER_TYPE
   ph.currency_code, --CURRENCY_CODE
   NULL, --FUNDING_PERCENT
   ph.promo_display_id, --PROMO_DISPLAY_ID
   NULL, --STAGE_PROM_CUST_ATTR_ID
   NULL, --STAGE_PROM_COMP_CUST_ATTR_ID
   NULL, --STAGE_PROM_DTL_CUST_ATTR_ID
   NULL, --PROM_CUST_ATTR_ID
   NULL, --PROM_COMP_CUST_ATTR_ID
   NULL --PROM_DTL_CUST_ATTR_ID
  );

  END LOOP;

  end loop;

END;
/

delete from rpm_stage_simple_promo;
select * from rpm_stage_simple_promo;
select zone_id,count(1) from rpm_stage_simple_promo group by zone_id;
select status,count(1) from rpm_stage_simple_promo group by status;

-- After ------ 

declare

cursor c_get_comps is
select
name, promo_id, promo_comp_id,
row_number() over (partition by name, promo_id order by promo_comp_id) as row_num
from
(
select d.name, a.promo_id, a.promo_comp_id
  from rms.rpm_promo_comp          a,
       rms.rpm_promo_dtl           b,
       rms.rpm_promo_zone_location c,
       rms.rpm_zone                d
 where a.promo_comp_id = b.promo_comp_id
   and b.promo_dtl_id = c.promo_dtl_id
   and c.zone_id = d.zone_id
   /* ADD HERE ZONES USED IN CREATE PROMO_COMP */
   and d.zone_id in  (99,100,101,102,103,104,105,106,107,108,109,110,111,112,113)
   /* ADD HERE MONTH USED TO CREATE PROMO COMPS */
   and a.promo_id in (select promo_id from rms.rpm_promo where name like '%OCT-20%')
 group by d.name, a.promo_id, a.promo_comp_id
 )
order by promo_id, promo_comp_id, row_num;

begin

for rec in c_get_comps
loop

update rms.rpm_promo_comp
set name = rec.name || ' Merret Simple Promotions ' || rec.row_num
where promo_comp_id = rec.promo_comp_id
;

end loop;

end;
/

select * from int_asos.int_pe_xref_promo;

   SELECT RPM_ZONE_ID,count(1)
          FROM int_asos.INT_PE_XREF_PROMO
         WHERE TO_CHAR(CREATE_MONTH, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM')
           --AND RPM_ZONE_ID = '100'
           AND DTL_CNT < (SELECT MAX_PROMO_COMP_DETAIL FROM RPM_SYSTEM_OPTIONS) group by RPM_ZONE_ID;



insert into int_asos.int_pe_xref_promo
select distinct TO_DATE(SUBSTR(a.name, INSTR(a.name, 'promotions') + 11), 'MON-YY') , d.zone_id, b.promo_comp_id, 1
  from rms.rpm_promo          a,
       rms.rpm_promo_comp          b,
       rms.rpm_promo_dtl           c,
       rms.rpm_promo_zone_location d,
       rms.rpm_zone                e
 where a.name like '%Merret%'
   and a.promo_id = b.promo_id
   and b.promo_comp_id not in (select promo_comp_id from int_asos.int_pe_xref_promo x, rms.rpm_promo_comp y where x.rpm_promo_comp_id = y.promo_comp_id)
   and b.promo_comp_id = c.promo_comp_id
   and c.promo_dtl_id = d.promo_dtl_id
   and d.zone_id = e.zone_id
   order by TO_DATE(SUBSTR(a.name, INSTR(a.name, 'promotions') + 11), 'MON-YY'), d.zone_id, b.promo_comp_id
/

select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;
Update ma_asos.MA_PRICE_EVENT_THRESHOLD set SIMPLE_PROMO_LOCS='100000';

    With 100K Config's 2.00 PM till 4.00 PM
        -- Batch execution took ~14 mins
        -- Overall option zone's processed 

@here update Red pen event tests 
Total Volume : 1.37M Option zone's --  94.5k Options all Zone's
1. Upload & Verification Chain taking ~ 1 Hour 10 mins executions 
2. Release Chain -- Price event Approvals and File generations to Integrations
    -- Atomic batch chain was scheduled for processing's in gap of every 2 mins after completions.     
    With 50K Config's 12.00 PM till 1.54 PM -- 
        -- Each batch chain execution took ~14 mins
        -- Overall 16k option zone's processed 
        -- ~1M records are getting processed in Stage 2. 
    With 100K Config's 1.54 PM till 4.00 PM -- 78K
        -- Each batch chain execution took ~21 mins
        -- Overall 16k option zone's processed 
        -- ~1M records are getting processed in Stage 2. 
--Overall
    -- 1.1M Yet to be processed & 4.7 processed already.
    -- Total 15 Hours of processing's

Issues resolved during today tests: 
 -- Upload chain taking 6.5 Hours executions
 -- Sequence issue when processing more than 1M records 
 -- Integration clean up was required (Topics & size issues)
 -- Promotion Publis batch issue -- As per the payload records increase in volumes -- taking below 2 mins.
 
  -- Resource Utilizations did reach peak (to reverify during next run) 


