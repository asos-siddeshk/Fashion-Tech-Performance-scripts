delete from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete from ma_asos.ma_stage_price_change where status='N';
delete from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '22-MAR-22' AND CREATE_ID likE 'PTESTUSER%';
delete from ma_asos.ma_stage_price_change;
select * from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '22-MAR-22' AND CREATE_ID likE 'PTESTUSER%';

delete from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete from ma_asos.ma_stage_price_change where status='N';

select * from ma_asos.MA_PRICE_CONFLICT_CHECK where PRICE_CHANGE_ID in 
(select PRICE_CHANGE_ID from ma_asos.ma_price_change where  EFFECTIVE_DATE='11-MAR-22');

delete from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '26-APR-23' AND CREATE_ID likE 'PTESTUSER%';
delete from ma_asos.ma_price_change where PRICE_CHANGE_ID > '20089120';

select status,CREATE_ID,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '26-APR-23' AND CREATE_ID likE 'PTESTUSER%' group by status,CREATE_ID;


select * from ma_asos.MA_PRICE_CONFLICT_CHECK where PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_price_change where PRICE_CHANGE_ID > '20089120');
select * from ma_asos.ma_price_change where ITEM = '115008700';

select * from ma_asos.ma_price_change where PRICE_CHANGE_ID > '20089120';
select status,CREATE_ID,count(1) from ma_asos.ma_price_change where PRICE_CHANGE_ID > '20089120' group by status,CREATE_ID;

select EFFECTIVE_DATE,status,CREATE_ID,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '1-APR-22' group by EFFECTIVE_DATE,status,CREATE_ID;

select status,CREATE_ID,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '11-MAR-22' group by status,CREATE_ID;
select status,EFFECTIVE_DATE,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '01-JAN-22' group by status,EFFECTIVE_DATE order by 2,1; --
delete from rms.ORDHEAD_LOCK;   

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1; --
select * from ma_asos.ma_stage_price_change where trunc(CREATE_DATETIME)> = '01-JAN-22';
delete from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete from ma_asos.ma_stage_price_change where status='N';
delete from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '01-JAN-22' AND CREATE_ID likE 'PTESTUSER%';
select * from ma_asos.ma_price_change where PRICE_CHANGE_ID >= '20089120';

delete from WH_CFA_EXT  where wh = '13';
Insert into WH_CFA_EXT (WH,GROUP_ID,VARCHAR2_1,VARCHAR2_2,VARCHAR2_3,VARCHAR2_4,VARCHAR2_5,VARCHAR2_6,VARCHAR2_7,VARCHAR2_8,VARCHAR2_9,VARCHAR2_10,NUMBER_11,NUMBER_12,NUMBER_13,NUMBER_14,NUMBER_15,NUMBER_16,NUMBER_17,NUMBER_18,NUMBER_19,NUMBER_20,DATE_21,DATE_22,DATE_23,DATE_24,DATE_25) 
values (6001,40100,'Y','N','N',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

sudo su - oracle
cat env.sh
cd /orabin/app/oracle/product/retail/batch
. ./batch_int_asos.profile
sqlplus $UP
truncate table int_asos.INT_ITEM_REST_EVENT_DNLD_STG;
truncate table int_asos.int_tckt_dnld_stage ;
truncate table int_asos.INT_PE_XREF_PROMO_DTL;
truncate table int_asos.INT_PE_SIMPLE_PROMO_STG;
truncate table int_asos.INT_PE_PROM_UPLD;
truncate table int_asos.INT_VAT_ITEM;
delete from ma_asos.ma_ship_rest_rule where CREATE_ID= 'PTUSER' and GROUP_ID != '1';
commit;
exit

select * from ma_asos.INT_ITEM_REST_EVENT_DNLD_STG;

select * from ma_asos.ma_ship_rest_rule_mfqueue;
select * from ma_asos.ma_ship_rest_rule where CREATE_ID= 'PTUSER' and GROUP_ID = '1';

select * from raf_notification order by 1 desc;
delete from rms.raf_notification where CREATED_BY like 'PTEST%';
delete from rms.raf_notification where CREATED_BY like 'SIDD%';

begin
delete from rms.raf_notification where CREATED_BY like 'PTEST%';
delete from ma_asos.ma_ship_rest_rule where CREATE_ID= 'PTUSER' and GROUP_ID != '1';
--DELETE FROM ma_asos.ma_price_change WHERE rowid not in (SELECT MIN(rowid) FROM ma_asos.ma_price_change GROUP BY ZONE_GROUP_ID, ZONE_ID, LOCATION, ITEM, EFFECTIVE_DATE, STATUS);			
delete from rms.DAILY_PURGE;
delete from rms.ORDHEAD_LOCK;
commit;
end;
/

select * FROM ma_asos.ma_price_change WHERE rowid not in (SELECT MIN(rowid) FROM ma_asos.ma_price_change GROUP BY ZONE_ID, LOCATION, ITEM, EFFECTIVE_DATE, STATUS);			

delete FROM ma_asos.ma_price_change WHERE rowid not in (SELECT MIN(rowid) FROM ma_asos.ma_price_change GROUP BY ZONE_ID, LOCATION, ITEM, EFFECTIVE_DATE, STATUS);			

delete from rms.DAILY_PURGE;
delete from rms.ORDHEAD_LOCK;
commit;

delete from rpm_promo where promo_id not in (select promo_id from rpm_promo_comp);


select * from rms.ORDHEAD_LOCK;
select * from rms.DAILY_PURGE;

select count(1) from ma_asos.ma_price_change;

delete from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE)>='31-MAR-20';
delete from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE)>='31-MAR-20';
select * from ma_asos.ma_price_change where trunc(CREATE_DATETIME) = '28-APR-2020';

delete from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) = '01-MAR-2020' and status = 'W' and rownum <= '50000';

select * from ma_asos.ma_price_change where item = '100805615';

select * from rms.SVC_ORDHEAD;
select * from rms.SVC_ITEM_MASTER;

cd /orabin/app/oracle/product/retail/batch
. ./batch.profile
sqlplus $UP
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
commit;
Exit


delete from MA_ASOS.ma_group_detail where LAST_UPDATE_DATETIME>=to_date('01-MAR-2020 12:00', 'DD-MON-YYYY hh24:mi') and LAST_UPDATE_ID like 'PTESTUSER%'; 
update ma_asos.ma_price_change set PLACE_OF_CREATION = 'M' where PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) between '25-APR-20' and '28-APR-20';
select * from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) between '25-APR-20' and '28-APR-20';
select * from ma_asos.ma_price_change where PLACE_OF_CREATION = 'U' anD trunc(EFFECTIVE_DATE) between '25-APR-20' and '28-APR-20';
select * from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE) >='31-MAR-20';

select EFFECTIVE_DATE,status,count(1) from ma_asos.ma_price_change where 
PLACE_OF_CREATION = 'U' anD trunc(EFFECTIVE_DATE) between '25-APR-20' and '28-APR-20' group by EFFECTIVE_DATE,status order by 1; --


delete  from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) between '25-APR-20' and '28-APR-20';

2008
begin
--delete  from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) >='31-MAR-20' and status = 'P';
delete  from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete  from ma_asos.ma_stage_price_change where status='N';
commit;
end;
/


select * from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO='934740';

select MASTER_ORDER_NO, ORDER_NO,count(1) from ma_asos.ma_stg_sizing_sku group by MASTER_ORDER_NO, ORDER_NO order by 3 desc;  
select MASTER_ORDER_NO, count(1) from ma_asos.ma_stg_sizing_sku group by MASTER_ORDER_NO order by 2 desc;  
select * from rms.ordhead where CREATE_DATETIME>= to_date('28-JAN-2021 10:00', 'DD-MON-YYYY hh24:mi');

select count(1) from ma_asos.ma_stg_sizing_sku; 
select MASTER_ORDER_NO,count(1) from ma_asos.ma_stg_sizing_sku group by MASTER_ORDER_NO order by 2 desc; 
select MASTER_ORDER_NO,count(1) from ma_asos.ma_stg_sizing_sku group by MASTER_ORDER_NO order by 1 desc; 
select * from ma_asos.ma_stg_sizing_sku order by 1 desc; 
select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku where MASTER_ORDER_NO between 27951 and 28750 order by 1; 

set serveroutput on;
set TIMING on;

DECLARE
  c_commit  	        NUMBER(8):= 0;
  O_ERROR_MESSAGE       VARCHAR2(200);
  I_MASTER_ORDER_NO     NUMBER;
  v_Return              BOOLEAN;
  
  CURSOR c_order is
 select MASTER_ORDER_NO from ma_asos.ma_stg_order where status ='A';
 
BEGIN
for k in c_order loop
		I_MASTER_ORDER_NO:=k.MASTER_ORDER_NO;

  v_Return := MA_ASOS.MA_ORDER_UTILS_SQL.DELETE_STG_ORDER_TABLES(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_MASTER_ORDER_NO => I_MASTER_ORDER_NO
  );
 
IF (v_Return) THEN 
      dbms_output.put_line('pass');
  ELSE
      dbms_output.put_line('Fail'||I_MASTER_ORDER_NO );
    
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

truncate table del_order;

select * from  del_order;
select master_po_no,status,count(*) from rms.ordhead where CREATE_DATETIME>= to_date('21-SEP-2020 17:00', 'DD-MON-YYYY hh24:mi') group by master_po_no,status;
select master_po_no,COMMENT_DESC,count(1) from rms.ordhead where CREATE_DATETIME>= to_date('21-SEP-2020 17:00', 'DD-MON-YYYY hh24:mi') group by master_po_no,COMMENT_DESC;

select * from  SVC_ORDLOC_EXP where order_no IN (select order_no from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('21-SEP-2020 17:00', 'DD-MON-YYYY hh24:mi')));
select * from  SVC_ORDDETAIL where order_no IN (select order_no from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('21-SEP-2020 17:00', 'DD-MON-YYYY hh24:mi')));
select * from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('26-APR-2023 11:00', 'DD-MON-YYYY hh24:mi'));
select * from  coresvc_po_err where order_no IN (select order_no from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('26-APR-2023 13:00', 'DD-MON-YYYY hh24:mi')));

select * from deal_head ;
select * from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('26-APR-2023 11:00', 'DD-MON-YYYY hh24:mi'));
select * from ordloc_discount where order_no = '500060025948';
select * from ordloc where order_no = '500060025948';
select * from ordsku where order_no = '500060025948';


alter table rpm_promo_comp disable constraint RPO_RPR_FK ;
delete from rpm_promo where promo_Id in (
select distinct promo_Id from (
select rp.promo_id,  rpc.promo_comp_id ,count(1) as detail_count from rpm_promo rp, rpm_promo_comp rpc, rpm_promo_dtl rpd
where rpd.promo_comp_id = rpc.promo_comp_id
and rpc.promo_Id = rp.promo_id 
group by rp.promo_id,  rpc.promo_comp_id having count(1) = 1
order by detail_count desc ))
and 
promo_Id not in (
select distinct promo_Id from (
select rp.promo_id,  rpc.promo_comp_id ,count(1) as detail_count from rpm_promo rp, rpm_promo_comp rpc, rpm_promo_dtl rpd
where rpd.promo_comp_id = rpc.promo_comp_id
and rpc.promo_Id = rp.promo_id 
group by rp.promo_id,  rpc.promo_comp_id having count(1) > 1 ));

alter table rpm_promo_comp enable novalidate constraint RPO_RPR_FK ;


select count(1) from rpm_promo;

cd /orabin/app/oracle/product/retail/batch
. ./batch_ma_asos.profile
sqlplus $UP
ALTER INDEX MA_STG_SIZING_SKU_I1 REBUILD ONLINE;
ALTER INDEX MA_STG_SIZING_SKU_I3 REBUILD ONLINE;
ALTER INDEX MA_STG_SIZING_SKU_I4 REBUILD ONLINE;
ALTER INDEX MA_STG_SIZING_SKU_PK REBUILD ONLINE;
ALTER INDEX MA_ORDER_MFQUEUE_I1 REBUILD ONLINE;
ALTER INDEX MA_ORDER_MFQUEUE_I3 REBUILD ONLINE;
ALTER INDEX MA_ORDER_MFQUEUE_U1 REBUILD ONLINE;
ALTER INDEX MA_ORDER_MFQUEUE_U2 REBUILD ONLINE;
ALTER INDEX MA_ORDER_REC_DETAIL_STG_IDX1 REBUILD ONLINE;
ALTER INDEX MA_ORDER_REC_HEAD_STG_I1 REBUILD ONLINE;
ALTER INDEX MA_ORDSKU_HTS_ASSESS_I1 REBUILD ONLINE;
ALTER INDEX MA_ORDSKU_HTS_ASSESS_I2 REBUILD ONLINE;
ALTER INDEX MA_ORDSKU_HTS_I1 REBUILD ONLINE;
ALTER INDEX MA_ORDSKU_HTS_I2 REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_DROPS_DETAIL_I1 REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_DROP_DIST_PK REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_IDX1 REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_ITEM_DIST_I1 REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_ITEM_DIST_IDX1 REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_OPTION_I1 REBUILD ONLINE;
ALTER INDEX MA_STG_ORDER_OPTION_IDX1 REBUILD ONLINE;
ALTER INDEX PK_MA_ORDER_MFQUEUE REBUILD ONLINE;
ALTER INDEX PK_MA_ORDER_PUB_INFO REBUILD ONLINE;
ALTER INDEX PK_MA_ORDER_REC_DETAIL_STG REBUILD ONLINE;
ALTER INDEX PK_MA_ORDER_REC_HEAD_STG REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER_DROP REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER_DROPS REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER_DROPS_DETAIL REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER_ITEM_DIST REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER_OPTION REBUILD ONLINE;
ALTER INDEX PK_MA_STG_ORDER_REC_RPL REBUILD ONLINE;
ALTER INDEX UK_MA_STG_ORDER_REC REBUILD ONLINE;
commit;
Exit
