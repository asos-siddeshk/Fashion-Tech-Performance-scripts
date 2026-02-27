
select * from all_tables where table_name like '%RIB%';

select * from RIB_MESSAGE;
select * from RIB_MESSAGE_FAILURE;
select * from RIB_MESSAGE_ROUTING_INFO;
select * from RIB_MESSAGE_HOSPITAL_REF;

select * from RIB_TYPE_SETTINGS;


select * from rib_message where ADAPTER_CLASS_LOCATION = 'rib-rms_XItem_sub';




create table RIB_MESSAGE_bk_0226 as
select * from RIB_MESSAGE;
create table RIB_MESSAGE_FAILURE_bk_0226 as
select * from RIB_MESSAGE_FAILURE;
create table RIB_MESSAGE_ROUTING_INFO_0226 as
select * from RIB_MESSAGE_ROUTING_INFO;
create table RIB_MESSAGE_HOSPITAL_REF_0226 as
select * from RIB_MESSAGE_HOSPITAL_REF;

select TYPE,count(1) from RIB_MESSAGE group by TYPE order by 1;
select FAMILY,count(1) from RIB_MESSAGE  group by FAMILY order by 2 desc;

select TYPE,count(1) from RIB_MESSAGE where type!='pubError' group by TYPE order by 1;
select FAMILY,count(1) from RIB_MESSAGE where type!='pubError' group by FAMILY order by 2 desc;

 select * from RIB_MESSAGE where FAMILY ='Items' order by 1 desc; -- All invalid items
 select * from RIB_MESSAGE where MESSAGE_NUM =626848;
 select * from RIB_MESSAGE_FAILURE where MESSAGE_NUM =626848;
 select * from RIB_MESSAGE_ROUTING_INFO where MESSAGE_NUM =626848;

select * from ordhead where order_no ='18900004092';
select * from ordloc where order_no ='18900004092';
select * from ordsku where order_no ='18900004092';

select message_num from RIB_MESSAGE rm where FAMILY ='Order'
    and not exists (select 1 from ordhead oh where oh.order_no = rm.id) order by 1 desc; 

select MESSAGE_NUM from Del_rib_msg;

-- 1. InvAdjustCre
        drop table Del_rib_msg;
    select * from rib_message where ADAPTER_CLASS_LOCATION = 'rib-rms_XItem_sub';

        create table Del_rib_msg as
        select MESSAGE_NUM from rib_message where ADAPTER_CLASS_LOCATION = 'rib-rms_XItem_sub';
        select MESSAGE_NUM from RIB_MESSAGE where type ='InvAdjustCre';
select * from RIB_MESSAGE_FAILURE where type ='InvAdjustCre';
	
-- 2. Order's doesnt exists in RMS 
    insert into Del_rib_msg
      select message_num from RIB_MESSAGE rm where FAMILY ='Order' 
    and not exists (select 1 from ordhead oh where oh.order_no = rm.id) order by 1 desc;  -- Order's doesnt exists
      
-- 3. Messages older than a week 
    insert into Del_rib_msg
    select message_num from RIB_MESSAGE where trunc(PUBLISH_TIME)<'25-DEC-2018';

-- 4. Receipt message  Invalid PO & Item numbers
    insert into Del_rib_msg
    select message_num from RIB_MESSAGE where FAMILY ='Receipt' and message_num in 
        (select distinct message_num from RIB_MESSAGE_FAILURE where DESCRIPTION like '%value too large for column%');
                         /*         <po_nbr>0130002026001</po_nbr> 
                                    <document_type>P</document_type>
                                    <asn_nbr>01317170004144</asn_nbr>
                                    <ReceiptDtl> 
                                        <item_id>ZTRDR1619583</item_id> */
                                        
                                        
 -- 5. Items's doesnt exists in RMS  & Unapproved Items
    insert into Del_rib_msg
      select message_num from RIB_MESSAGE rm where FAMILY ='Items'
    and not exists (select 1 from item_master oh where oh.item = rm.id and status !='A') order by 1 desc;    

-- 6.  Orders unpublished

    insert into Del_rib_msg
      select message_num from RIB_MESSAGE rm ;
    
set serveroutput on;
set timing on;
 
DECLARE
 l_MESSAGE_NUM             rms.RIB_MESSAGE.MESSAGE_NUM%type;
 COUNTER_COMMIT            NUMBER(8)     := 0;

    cursor cur_dept is --16991
		select MESSAGE_NUM from Del_rib_msg;

BEGIN
for k in cur_dept loop
  l_MESSAGE_NUM := k.MESSAGE_NUM;
  
 delete from RIB_MESSAGE_ROUTING_INFO where MESSAGE_NUM =l_MESSAGE_NUM;
 delete from RIB_MESSAGE_FAILURE where MESSAGE_NUM =l_MESSAGE_NUM;
 delete from RIB_MESSAGE where MESSAGE_NUM =l_MESSAGE_NUM;
 delete from Del_rib_msg where MESSAGE_NUM =l_MESSAGE_NUM;

    COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 100) = 0 THEN
				COMMIT;
			   END IF;
end loop;
 commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

/*

select OWNER, TABLE_NAME, NUM_ROWS from all_tables where owner like 'SKUMAR' order by 3 desc;



drop table ALLOC_CHRG_NULL;

drop table APPRD_TSF;
drop table BOL_DEL;
drop table CNV_ORDER;
drop table CUSTM_INT_TCKT_DNLD_STAGE;
drop table CUST_AUTOPO_OUTS;
drop table CUST_AUTOPO_OUTSTAN;
drop table CUST_INT_TCKT_DNLD_STAGE;
drop table CUST_EMER_PRICE_HIST;
drop table CUST_ORDPRG;
drop table CUST_ORDPRGDU;
drop table CUST_REPL_RESULTS;
drop table CUST_REV_ORDERS;
drop table DAILY_DATA_BK;
drop table DAILY_DATA_BK_30092018;
drop table DEAL_CALC_QUEUE_BK;
drop table DEL_ASN;
drop table DEL_ORDER;
drop table DOC_CLOSE_QUEUE_BK;
drop table DOC_CLOSE_QUEUE_BK2;
drop table D_REPL_ATTR_ID;
drop table IF_TRAN_DATA_BK_RETEN;
drop table INT_TCKT_DNLD_STAGE_BK;
drop table INT_TCKT_DNLD_STAGE_BK_2;
drop table ITEMLIST_BK;
drop table ITEMS_RPM_LOC;
drop table ITEM_GROUP_EVENT_BK;
drop table ITEM_GROUP_EVENT_DNLD_STG_BK;
drop table ITEM_GROUP_EVENT_TBL_BK;
drop table ITEM_MFQUEUE_BKP;
drop table MAN_TSF_BK;
drop table MAN_TSF_UP_BK;
drop table MASTER_PO_NO_3K;
drop table MA_ORDSKU_HTS_ASSESS_BK;
drop table MA_ORDSKU_HTS_BK;
drop table MA_PO_EXP_MFQUEUE_BK;
drop table MA_STAGE_CLEARANCE_BK;
drop table MA_STAGE_PRICE_CHANGE_BK;
drop table MA_STG_COST_DROP_DETAIL_BK;
drop table MA_STG_COST_EXPENSE_DETAIL_BK;
drop table MA_STG_COST_OPTION_DETAIL_BK;
drop table MA_STG_COST_UP_CD_BK;
drop table MA_STG_ORDER_BK;
drop table MA_STG_ORDER_BKP;
drop table MA_STG_ORDER_DROPS_BK;
drop table MA_STG_ORDER_DROPS_DETAIL_BK;
drop table MA_STG_ORDER_DROP_BK;
drop table MA_STG_ORDER_ITEM_DIST_BK;
drop table MA_STG_ORDER_OPTION_BK;
drop table MA_STG_ORDER_OPTION_BKP;
drop table NB_PRG_PRICING_BK;
drop table NB_STG_FIF_GL_DATA_BK_3012_4;
drop table ORDER_NO_PUR;
drop table ORDER_PRO;
drop table ORDHEAD_CUST;
drop table ORDORD_NO_REV;
drop table ORD_CUST;
drop table PERF_RPM_FUT_CLR;
drop table PERF_RPM_FUT_PC;
drop table PERF_RPM_FUT_SP;
drop table PO_COMMIT_PO;
drop table PRICING_BK;
drop table PROCESSED_ITEM;
drop table PROCESSED_ITEMLOC;
drop table PROCESS_TRACKER_BK_1;
drop table PROMO_ARC;
drop table REV_ORDERS_BK;
drop table REV_ORDERS_BK_1;
drop table RPM_BK;
drop table RPM_EVENT_ITEMLOC_BK_091218;
drop table RPM_EVENT_ITEMLOC_BK_20190102;
drop table RPM_EVENT_ITEMLOC_NOV20;
drop table RPM_EVENT_ITEMLOC_OCT17;
drop table RPM_STAGE_CLEARANCE_500;
drop table RPM_STAGE_CLEARANCE_A_BK;
drop table RPM_STAGE_CLEARANCE_BK;
drop table RPM_STAGE_ITEM_LOC_BK;
drop table RPM_STAGE_ITEM_LOC_BK_20000;
drop table RPM_STAGE_ITEM_LOC_BK_N;
drop table RPM_STAGE_SIMPLE_PROMO_BK;
drop table RSP_BK;
drop table RV_ORDER_BK;
drop table SHIPMENT_DEL;
drop table SHIPMENT_WO_SHIPSKU;
drop table SHIP_REPRO;
drop table SHIP_REPRO2R;
drop table SHIP_REST_BK;
drop table SKULIST_LOC;
drop table STG_FIF_GL_DATA_BK_3012;
drop table STG_FIF_GL_DATA_BK_3012_2;
drop table STG_FIF_GL_DATA_BK_3012_5;
drop table TCKTDNLD_BK;
drop table TCKTDNLD_R;
drop table TCKT_BK;
drop table TICKETDNNL_RE;
drop table TRAND_DATA_BK_20181209;
drop table TRANSFERS_PUB_INFO_BKP;
drop table TRAN_DATA_BK_111118;
drop table TRAN_DATA_BK_18112018;
drop table TRAN_DATA_BK_231218;
drop table TRAN_DATA_BK_ALL;



*/
select * from all_tables where table_name like '%PUB_INFO';
select * from BANNER_MFQUEUE;
select * from CODES_MFQUEUE;
select * from DELIVERY_SLOT_MFQUEUE;
select * from DIFFGRP_MFQUEUE;
select * from DIFFID_MFQUEUE;
select * from ITEMLOC_MFQUEUE;
select * from ITEM_MFQUEUE;
select * from MERCHHIER_MFQUEUE;
select * from ORDER_MFQUEUE; --19k
select * from PARTNER_MFQUEUE;
select * from RTVREQ_MFQUEUE;
select * from RUA_MFQUEUE;
select * from SEEDOBJ_MFQUEUE;
select * from STORE_MFQUEUE;
select * from SUPPLIER_MFQUEUE;
select * from TSF_MFQUEUE; --335K
select * from UDA_MFQUEUE;
select * from WH_MFQUEUE;
select * from WOIN_MFQUEUE;
select * from WOOUT_MFQUEUE;
truncate table skumar.VPT_LOGS;

select count(1) from ALLOC_PUB_INFO;
select count(1) from ITEM_PUB_INFO;
select * from ORDCUST_PUB_INFO;
select count(1) from ORDER_PUB_INFO;
select * from PARTNER_PUB_INFO;
select * from RTVREQ_PUB_INFO;
select * from SHIPMENT_PUB_INFO;
select * from STORE_PUB_INFO;
select count(1) from TRANSFERS_PUB_INFO;
select * from WH_PUB_INFO;
select * from WOOUT_PUB_INFO;

select * from ALLOC_PUB_INFO; --1000388159	Y	1	1001	1	6014782	N	Y	Y
select count(1) from ALLOC_PUB_INFO;
select * from ALLOC_PUB_INFO;
insert into ALLOC_PUB_INFO
select ah.ALLOC_NO,'Y',1,w.WH,w.PHYSICAL_WH,ah.item,'N','Y','Y' from alloc_header ah,wh w where ah.wh=w.wh;
select * from wh;
select * from alloc_header;
select ah.ALLOC_NO,'Y',1,w.WH,w.PHYSICAL_WH,ah.item,'N','Y','Y' from alloc_header ah,wh w where ah.wh=w.wh;
select count(1) from alloc_header;



select * from ITEM_PUB_INFO; --100917863	Y	Y	N	N
select count(1) from ITEM_PUB_INFO;
select * from ITEM_master where ITEM ='100917871' or ITEM_PARENT ='100917871' or ITEM_GRANDPARENT ='100917871' and status ='A';
select item from ITEM_master where status !='A';

insert into ITEM_PUB_INFO 
select item,'Y',SELLABLE_IND,'N','N' from ITEM_master where item not in (select item from ITEM_PUB_INFO) and item_level in (1);
insert into ITEM_PUB_INFO 
select item,'Y',SELLABLE_IND,'Y','N' from ITEM_master where item not in (select item from ITEM_PUB_INFO) and item_level in (2) and rownum<='1000000';
delete from ITEM_PUB_INFO where item in (select item from ITEM_master where status !='A');

select * from ORDER_PUB_INFO; --50000280926	Y	1	Y	N/B
select count(1) from ORDER_PUB_INFO;
select count(1) from ordhead;
select * from ordhead where status ! ='W';
insert into ORDER_PUB_INFO 
select ORDER_NO, 'Y', 1, 'Y', ORDER_TYPE from ordhead where ORDER_NO not in (select ORDER_NO from ORDER_PUB_INFO) and status !='W';


select * from tsfhead where tsf_no not in (select tsf_no from TRANSFERS_PUB_INFO);

select * from TRANSFERS_PUB_INFO; --7000000451	IC	Y	4	4	4001	W	8	3011	W	N	Y
select count(1) from TRANSFERS_PUB_INFO; --3553611
select count(1) from tsfhead where status ='I'; --3508541
select * from tsfhead; --3508541
select * from wh; --3508541

insert into TRANSFERS_PUB_INFO 
select TSF_NO,TSF_TYPE,'N',1,w.physical_wh,FROM_LOC,FROM_LOC_TYPE, w2.physical_wh,TO_LOC,TO_LOC_TYPE,FREIGHT_CODE,'N' 
    from tsfhead th,wh w,wh w2
    where th.FROM_LOC =w.wh and th.to_loc =w2.wh and TSF_NO not in (select TSF_NO from TRANSFERS_PUB_INFO) and status ='I' 
   -- and tsf_no in (7000000002,7000000001)
    and rownum<='1000000';


select * from all_tables where table_name like '%BK';


--ALLOC_PUB_INFO;
select count(1) from ALLOC_MFQUEUE;
select count(1) from ALLOC_PUB_INFO;
Update ALLOC_PUB_INFO set PUBLISHED ='Y' where PUBLISHED ='N';
Update ALLOC_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS ='U';



select * from ALLOC_MFQUEUE where PUB_STATUS ='U';
select * from ALLOC_PUB_INFO where PUBLISHED!='Y';


select distinct PUBLISHED from ALLOC_PUB_INFO;

select * from ITEMLOC_MFQUEUE where PUB_STATUS!='Y';
select * from ITEM_MFQUEUE ;
delete from ITEM_MFQUEUE;
select * from ITEM_PUB_INFO where PUBLISHED!='Y';

Update ITEM_PUB_INFO set PUBLISHED ='Y' where PUBLISHED ='N';
--Update ITEM_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS ='U';
Update ITEMLOC_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS ='U';

select *  from ITEM_mfqueue;
select count(1)  from rib_message where trunc(PUBLISH_TIME) = trunc(sysdate)  order by 1 desc;
select * from rib_message_failure where message_num = '610073';


select count(1) from order_mfqueue;
select count(1) from ITEMLOC_MFQUEUE;
select count(1) from ITEM_PUB_INFO;
select * from ORDCUST_PUB_INFO;
select * from all_tables where table_name like 'ORDER%MFQ%';

create table ORDER_MFQUEUE_bk_121208 as
select * from ORDER_MFQUEUE ;
--delete from ORDER_MFQUEUE;
select count(1) from ORDER_MFQUEUE;
select * from ORDER_MFQUEUE;
select count(1) from ORDER_PUB_INFO;
select * from ORDER_PUB_INFO where PUBLISHED!='Y';
select * from ORDER_MFQUEUE where PUB_STATUS!='Y';
Update ORDER_PUB_INFO set PUBLISHED ='Y' where PUBLISHED ='N';
Update ORDER_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS ='U';

select * from PARTNER_PUB_INFO;
select * from RTVREQ_PUB_INFO;
select * from SHIPMENT_PUB_INFO;
select * from STORE_PUB_INFO;
select count(1) from TRANSFERS_PUB_INFO;
select * from all_tables where table_name like 'TSF%MFQ%';


select count(1) from TSF_MFQUEUE;
select count(1) from TRANSFERS_PUB_INFO;
select * from TRANSFERS_PUB_INFO where PUBLISHED!='Y';
select * from TSF_MFQUEUE where PUB_STATUS!='Y';
Update TRANSFERS_PUB_INFO set PUBLISHED ='Y' where PUBLISHED ='N';
Update TSF_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS ='U';

select * from WH_PUB_INFO;
select * from WOOUT_PUB_INFO;
delete from ORDER_MFQUEUE;
delete from TSF_MFQUEUE;
delete from  ITEMLOC_MFQUEUE;
delete from  ALLOC_MFQUEUE;
delete from  ITEM_mfqueue; 

truncate table STAGE_PURGED_SHIPSKUS;
truncate table ORDER_MFQUEUE;
truncate table TSF_MFQUEUE;
truncate table ITEMLOC_MFQUEUE;
truncate table ALLOC_MFQUEUE;
truncate table ITEM_mfqueue;

Update ORDER_PUB_INFO set PUBLISHED ='Y' where PUBLISHED !='Y';
Update ORDER_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS !='Y';
Update TRANSFERS_PUB_INFO set PUBLISHED ='Y' where PUBLISHED !='Y';
Update TSF_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS!='Y';
Update ITEM_mfqueue set PUB_STATUS ='Y' where PUB_STATUS !='Y';
Update ITEM_PUB_INFO set PUBLISHED ='Y' where PUBLISHED !='Y';
Update ITEMLOC_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS !='Y';
Update ALLOC_PUB_INFO set PUBLISHED ='Y' where PUBLISHED !='Y';
Update ALLOC_MFQUEUE set PUB_STATUS ='Y' where PUB_STATUS !='Y';
commit;
