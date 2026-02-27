
select master_po_no,count(1) from rms.ordhead where status = 'A' group by master_po_no having count(1) > 50; 
 

select trunc(WRITTEN_DATE),master_po_no,count(1) from rms.ordhead where status = 'A' group by trunc(WRITTEN_DATE),master_po_no having count(1) > 50; 

select * from ordhead where master_po_no = '22976860';
select * from ordloc where order_no in (select order_no from ordhead where master_po_no = '22976860');
select * from ordloc_exp where order_no in (select order_no from ordhead where master_po_no = '22976860');


select * from order_mfqueue where order_no in (select order_no from ordhead where master_po_no = '22976860');

select *
    from ma_asos.nb_system_parameters s
   where s.func_area in ('IMA_THRESHOLDS','PMA_THRESHOLDS','POMA_THRESHOLDS','PROMO_THRESHOLDS','UPLD_THRESHOLDS');
   

select ms.PROCESS_SEQ,TEMPLATE_ID,UPLOAD_USER,status,count(1) as Count_UPloads,        to_char(DEQUEUE_START_DATETIME,'DD-MON-YY hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'DD-MON-YY hh:mi:ss am') DEQUEUE_END_DATETIME ,        
      round((DEQUEUE_END_DATETIME - DEQUEUE_START_DATETIME)*24*60,2)  AS MINs_processing
    from  ma_asos.MA_STG_UPLOAD_PROCESS_LINE msu , ma_asos.MA_STG_UPLOAD_PROCESS ms 
        where ms.process_seq  = msu.PROCESS_SEQ (+) --and status = 'E' 
      --  and trunc(ms.ENQUEUE_DATETIME) >= trunc(sysdate)
    group by ms.PROCESS_SEQ,UPLOAD_USER,TEMPLATE_ID, ENQUEUE_DATETIME,
       DEQUEUE_START_DATETIME,
       DEQUEUE_END_DATETIME, status  order by PROCESS_SEQ desc;  -- 300

select *
    from rms.nb_system_parameters s
   where s.func_area in ('IMA_THRESHOLDS','PMA_THRESHOLDS','POMA_THRESHOLDS','PROMO_THRESHOLDS','UPLD_THRESHOLDS');
   
   
select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq  in ('583189'); 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in ('583189'); 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS where process_seq in ('583189'); 
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in ('583189') and attr_2 = '115090589'; 
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq in ('583189'); 

115448415
115448706
115448901
115448947
115450711


 select PROCESS_SEQ, TEMPLATE_ID, STATUS,UPLOAD_USER,     
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME,
      round((DEQUEUE_END_DATETIME - DEQUEUE_START_DATETIME)*24*60,2)  AS MINs_processing
 from ma_asos.MA_STG_UPLOAD_PROCESS ms
where         --TEMPLATE_ID in ('PO')    and 
       ENQUEUE_DATETIME>= to_date('17-JAN-2024 07:00', 'DD-MON-YYYY hh24:mi')
--     and      status in ('P','E')   
    --AND process_seq in ( '138652','138210','37558')
--    and exists (select 1 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR msua where msua.process_seq = ms.process_seq and msua.ATTR_1 = 'Cancel')
    order by PROCESS_SEQ desc;

select * FROM rms.logger_logs where TIME_STAMP >= to_date('17-JAN-2024 11:25', 'DD-MON-YYYY hh24:mi') 
    --and client_identifier = 'ELLIE.DEMUTH' 
    order by TIME_STAMP ;

select * from rms.logger_logs order by 1 desc;
select 577151936 - 1000 from dual;
SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE 'LOGGER%';
select * from logger_logs where id > 577464996 order by id desc;

    
select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq  in ('548232'); 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in ('548232'); 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS where process_seq in ('548232'); 
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in ('548232'); 
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq in ('548232'); 


select msuba.* from 
    ma_asos.MA_STG_UPLOAD_PROCESS msup, MA_ASOS.MA_STG_UPLOAD_BOUNDED_ATTR msuba 
where msup.status  in ('P','R') and msup.process_seq = msuba.process_seq 
    and msup.TEMPLATE_ID='PO' and msup.process_seq >= '543711';


select * from rms.order_mfqueue;

547698	PO	CHARLES.TRUSCOTT	E	204
547696	PO	CHARLES.TRUSCOTT	P	498
547648	PO	CHARLES.TRUSCOTT	E	407
547642	PO	CHARLES.TRUSCOTT	P	498

select ms.PROCESS_SEQ,TEMPLATE_ID,UPLOAD_USER,status,count(1) from 
    ma_asos.MA_STG_UPLOAD_PROCESS_LINE msu , ma_asos.MA_STG_UPLOAD_PROCESS ms 
        where ms.process_seq  = msu.PROCESS_SEQ  --and status = 'P' 

        and trunc(ms.ENQUEUE_DATETIME) >= trunc(sysdate)
    group by ms.PROCESS_SEQ,UPLOAD_USER,TEMPLATE_ID,status  order by PROCESS_SEQ desc;  -- 300

545231	PO	BETH.DUKES	P	95
543714	PO	JOANNEPOWELL	E	408
544976	PO	EMILY.READ	P	1
544922	PO	EMILY.READ	P	2
544801	PO	CHARLOTTE.GOLD	P	128

MA_PROCESS_UPLOAD_SQL.PROCESS_PO_FROM_CALLBACK	17-JAN-24 11.47.32.568927000	JOANNEPOWELL	ERROR_MASS_MAINTENANCE_CB_VALIDATIONS_ERRORS # 543714 # 500029291449 # QUEUE_FAIL	500029291449	QUEUE_FAIL	
MA_ORDERS_SQL.PROCESS_QUEUE_RECORD	17-JAN-24 11.36.59.710675000	JOANNEPOWELL	ERROR_ORDER_PUB_PROCESS_REC # 64462577			

    The total quantity ordered for the physical warehouse, 5, cannot fall below the sum of what is being shipped and what has been received which is 7.

 select * FROM ma_asos.ma_logs where trunc(LOG_TS) =trunc(sysdate) order by LOG_TS desc;

select OWNER, TABLE_NAME,NUM_ROWS from all_tables where OWNER in('RMS','MA_ASOS','INT_ASOS','ITEMHUB_ASOS','ORACNV') AND NUM_ROWS >= '5000' order by 1,2;



-- Options 
select calendar.c_date,
       NVL(options_cnt.cnt,0) option_count,
       NVL(skus_cnt.cnt,0) sku_count,
       NVL(barcodes_cnt.cnt,0) barcodes_cnt
from    (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.item_master where status ='A' and item_level ='1' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) options_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.item_master where status ='A' and item_level ='2' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) skus_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.item_master where status ='A' and item_level ='3' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) barcodes_cnt,
   (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = options_cnt.CREATE_DATETIME(+)
   and calendar.c_date = skus_cnt.CREATE_DATETIME(+)
   and calendar.c_date = barcodes_cnt.CREATE_DATETIME(+)
order by calendar.c_date;


select count(*) from rms.item_master where status ='A' and item_level ='1' and CREATE_DATETIME>=to_date('07-MAY-2021 12.59', 'DD-MON-YYYY hh24:mi');
        
-- Prices 
select distinct STATE from rpm_clearance;
select * from rpm_clearance;
select ZONE_NODE_TYPE,count(1) from RPM_PROMO_ZONE_LOCATION group by ZONE_NODE_TYPE;

select count(1) from rms.RPM_PROMO_DTL_hist where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist));
select * from rms.RPM_PROMO_DTL_hist;
select * from rms.RPM_PROMO_hist;



select count(1) from rms.RPM_PROMO where promo_id in (select PROMO_ID from rms.rpm_promo_hist);
select count(1) from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist);
select count(1) from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist));
select count(1) from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
select count(1) from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist))));
select count(1) from rms.RPM_PROMO_DTL_MERCH_NODE where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
select count(1) from rms.RPM_PROMO_ZONE_LOCATION where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
select count(1) from rms.RPM_PROMO_DTL_DISC_LADDER where promo_dtl_list_id in (select promo_dtl_list_id from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)))));

select calendar.c_date,
       NVL(promo_dtl_start.cnt,0) promo_dtl_start,
       NVL(promo_dtl_end.cnt,0) promo_dtl_end,
       NVL(price_changes.cnt,0) price_changes,
       NVL(clearances.cnt,0) clearances,       
       NVL(clearance_resets.cnt,0) clearance_resets
  from (select TRUNC(START_DATE) START_DATE, count(1) cnt from rms.rpm_promo_dtl where state in ('3','5','6') and trunc(START_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(START_DATE)) promo_dtl_start,  
       (select TRUNC(end_date) end_date, count(1) cnt from rms.rpm_promo_dtl where state in ('3','5','6') and trunc(end_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(end_date)) promo_dtl_end,  
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance where state !='pricechange.state.worksheet' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) clearances,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_price_change where trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) price_changes,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance_reset where state !='pricechange.state.worksheet' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by trunc(effective_date)) clearance_resets,       
        (SELECT to_date(:begin_date, 'mm/dd/yyyy'   ) + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = promo_dtl_start.START_DATE(+)
   and calendar.c_date = promo_dtl_end.end_date(+)
   and calendar.c_date = price_changes.st_date(+)
   and calendar.c_date = clearances.st_date(+)
   and calendar.c_date = clearance_resets.st_date(+)
order by calendar.c_date;


select calendar.c_date,
       NVL(promo_dtl_start.cnt,0) promo_dtl_start,
       NVL(promo_dtl_end.cnt,0) promo_dtl_end,
       NVL(price_changes.cnt,0) price_changes,
       NVL(clearances.cnt,0) clearances,       
       NVL(clearance_resets.cnt,0) clearance_resets
  from (select TRUNC(START_DATE) START_DATE, count(1) cnt from rms.rpm_promo_dtl_hist where state in ('3','5','6') and trunc(START_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(START_DATE)) promo_dtl_start,  
       (select TRUNC(end_date) end_date, count(1) cnt from rms.rpm_promo_dtl_hist where state in ('3','5','6') and trunc(end_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(end_date)) promo_dtl_end,  
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance where state !='pricechange.state.worksheet' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) clearances,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_price_change where trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) price_changes,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance_reset where state !='pricechange.state.worksheet' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by trunc(effective_date)) clearance_resets,       
        (SELECT to_date(:begin_date, 'mm/dd/yyyy'   ) + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = promo_dtl_start.START_DATE(+)
   and calendar.c_date = promo_dtl_end.end_date(+)
   and calendar.c_date = price_changes.st_date(+)
   and calendar.c_date = clearances.st_date(+)
   and calendar.c_date = clearance_resets.st_date(+)
order by calendar.c_date;

 
-- PO's & allocations
SELECT * FROM ALLOC_HEADER ;


select calendar.c_date,
       NVL(or_cnt.cnt,0) or_count,
       NVL(D_or_cnt.cnt,0) Direct_order_cnt,
       NVL(S_or_cnt.cnt,0) Split_order_cnt,
       NVL(A_or_cnt.cnt,0) Auto_order_cnt
from 
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) or_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where PO_TYPE ='S' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) S_or_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where PO_TYPE ='A' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) A_or_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where PO_TYPE ='D' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) D_or_cnt,
   (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = or_cnt.CREATE_DATETIME(+)
   and calendar.c_date = S_or_cnt.CREATE_DATETIME(+)
   and calendar.c_date = A_or_cnt.CREATE_DATETIME(+)
   and calendar.c_date = D_or_cnt.CREATE_DATETIME(+)
order by calendar.c_date;

select calendar.c_date,
       NVL(or_cnt.cnt,0) or_count,
       NVL(S_or_cnt.cnt,0) Split_order_cnt,
       NVL(A_or_cnt.cnt,0) Auto_order_cnt,
       NVL(D_or_cnt.cnt,0) Direct_order_cnt
from 
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where status ='A' and trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) or_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where status ='A' and PO_TYPE ='S' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) S_or_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where status ='A' and PO_TYPE ='A' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) A_or_cnt,
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from rms.ORDHEAD where status ='A' and PO_TYPE ='D' and  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) D_or_cnt,
   (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = or_cnt.CREATE_DATETIME(+)
   and calendar.c_date = S_or_cnt.CREATE_DATETIME(+)
   and calendar.c_date = A_or_cnt.CREATE_DATETIME(+)
   and calendar.c_date = D_or_cnt.CREATE_DATETIME(+)
order by calendar.c_date;



-- ASN's 

select calendar.c_date,
       NVL(asn_cnt.cnt,0) asn_count
from 
   (select TRUNC(CREATE_DATETIME) CREATE_DATETIME, count(1) cnt from SUPP_ASOS.sc_asnin where  trunc(CREATE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(CREATE_DATETIME)) asn_cnt,
   (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = asn_cnt.CREATE_DATETIME(+)
order by calendar.c_date;


-- Sales


select * from rms.store;
select * from rms.SA_store_Day;
select * from SA_TRAN_HEAD;

select calendar.c_date,
       NVL(EU_ST_Transaction_cnt.cnt,0) EU_ST_Transaction_cnt,
       NVL(UK_ST_Transaction_cnt.cnt,0) UK_ST_Transaction_cnt,
       NVL(US_ST_Transaction_cnt.cnt,0) US_ST_Transaction_cnt,
       NVL(UK2_ST_Transaction_cnt.cnt,0) UK2_ST_Transaction_cnt       
from 
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where ss.STORE = '10004' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_ST_Transaction_cnt,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where ss.STORE = '10001' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_ST_Transaction_cnt,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where ss.STORE = '10003' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_ST_Transaction_cnt,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where ss.STORE = '10006' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK2_ST_Transaction_cnt,
  (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = EU_ST_Transaction_cnt.BUSINESS_DATE(+)
    and calendar.c_date = UK_ST_Transaction_cnt.BUSINESS_DATE(+)
    and calendar.c_date = US_ST_Transaction_cnt.BUSINESS_DATE(+)
    and calendar.c_date = UK2_ST_Transaction_cnt.BUSINESS_DATE(+)
    order by calendar.c_date;

select * from rms.SA_TRAN_HEAD;


select calendar.c_date,
       NVL(EU_Transactions.cnt,0) Transactions,
       NVL(EU_Billed_Sale.cnt,0) Billed_Sale,       
       NVL(EU_Liability.cnt,0) Liability,       
       NVL(EU_Shipped_Sale.cnt,0) Shipped_Sale,       
       NVL(EU_REFUND.cnt,0) REFUND,
       NVL(EU_RETURN.cnt,0) RETURN,
       NVL(EU_ORD_CANCEL.cnt,0) ORD_CANCEL
from
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Transactions,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where TRAN_TYPE='REFUND' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_REFUND,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where TRAN_TYPE='RETURN' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_RETURN,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDINT' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Liability,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDCMP' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Shipped_Sale,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where TRAN_TYPE='SPLORD' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Billed_Sale,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from rms.SA_TRAN_HEAD sth, rms.SA_store_Day ss where TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDCAN' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_ORD_CANCEL,
  (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = EU_Transactions.BUSINESS_DATE(+)
and calendar.c_date = EU_REFUND.BUSINESS_DATE(+)
and calendar.c_date = EU_RETURN.BUSINESS_DATE(+)
and calendar.c_date = EU_Liability.BUSINESS_DATE(+)
and calendar.c_date = EU_Shipped_Sale.BUSINESS_DATE(+)
and calendar.c_date = EU_Billed_Sale.BUSINESS_DATE(+)
and calendar.c_date = EU_ORD_CANCEL.BUSINESS_DATE(+)
order by calendar.c_date;


select calendar.c_date,
       NVL(EU_Transactions.cnt,0) EU_Transactions,
       NVL(EU_Billed_Sale.cnt,0) EU_Billed_Sale,       
       NVL(EU_Liability.cnt,0) EU_Liability,       
       NVL(EU_Shipped_Sale.cnt,0) EU_Shipped_Sale,       
       NVL(EU_REFUND.cnt,0) EU_REFUND,
       NVL(EU_RETURN.cnt,0) EU_RETURN
from
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Transactions,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='REFUND' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_REFUND,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='RETURN' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_RETURN,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDINT' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Liability,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDCMP' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Shipped_Sale,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='SPLORD' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Billed_Sale,
  (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = EU_Transactions.BUSINESS_DATE(+)
and calendar.c_date = EU_REFUND.BUSINESS_DATE(+)
and calendar.c_date = EU_RETURN.BUSINESS_DATE(+)
and calendar.c_date = EU_Liability.BUSINESS_DATE(+)
and calendar.c_date = EU_Shipped_Sale.BUSINESS_DATE(+)
and calendar.c_date = EU_Billed_Sale.BUSINESS_DATE(+)
order by calendar.c_date;




select calendar.c_date,
       NVL(UK_Transactions.cnt,0) UK_Transactions,
       NVL(UK_Billed_Sale.cnt,0) UK_Billed_Sale,       
       NVL(UK_Liability.cnt,0) UK_Liability,       
       NVL(UK_Shipped_Sale.cnt,0) UK_Shipped_Sale,       
       NVL(UK_REFUND.cnt,0) UK_REFUND,
       NVL(UK_RETURN.cnt,0) UK_RETURN
from
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10001' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_Transactions,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10001' and  TRAN_TYPE='REFUND' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_REFUND,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10001' and  TRAN_TYPE='RETURN' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_RETURN,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10001' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDINT' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_Liability,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10001' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDCMP' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_Shipped_Sale,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10001' and  TRAN_TYPE='SPLORD' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) UK_Billed_Sale,
  (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = UK_Transactions.BUSINESS_DATE(+)
and calendar.c_date = UK_REFUND.BUSINESS_DATE(+)
and calendar.c_date = UK_RETURN.BUSINESS_DATE(+)
and calendar.c_date = UK_Liability.BUSINESS_DATE(+)
and calendar.c_date = UK_Shipped_Sale.BUSINESS_DATE(+)
and calendar.c_date = UK_Billed_Sale.BUSINESS_DATE(+)
order by calendar.c_date;

drop table sales_uk ;
Create table sales_uk  (c_date date, Uk_Transactions number(10), Uk_Billed_Sale number(10), Uk_Liability number(10), Uk_Shipped_Sale number(10),
Uk_REFUND number(10), Uk_RETURN number(10) );

select calendar.c_date,
       US_Transactions.cnt ,
       US_Billed_Sale.cnt ,       
       US_Liability.cnt ,       
       US_Shipped_Sale.cnt ,       
       US_REFUND.cnt,
       US_RETURN.cnt 
from
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10003' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_Transactions,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10003' and  TRAN_TYPE='REFUND' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_REFUND,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10003' and  TRAN_TYPE='RETURN' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_RETURN,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10003' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDINT' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_Liability,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10003' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDCMP' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_Shipped_Sale,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10003' and  TRAN_TYPE='SPLORD' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) US_Billed_Sale,
  (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = US_Transactions.BUSINESS_DATE(+)
and calendar.c_date = US_REFUND.BUSINESS_DATE(+)
and calendar.c_date = US_RETURN.BUSINESS_DATE(+)
and calendar.c_date = US_Liability.BUSINESS_DATE(+)
and calendar.c_date = US_Shipped_Sale.BUSINESS_DATE(+)
and calendar.c_date = US_Billed_Sale.BUSINESS_DATE(+)
order by calendar.c_date;



 ------------------------------------ 


create table item_master_tr as select ITEM, ITEM_LEVEL, CREATE_DATETIME from rms.item_master where item_level in ('1','2') 
    and trunc(CREATE_DATETIME) = '21-DEC-2023';
drop table item_master_tr;


 select t_from,t_to,count(1) from item_master_tr im,
( SELECT TIMESTAMP '2023-12-21 23:59:59' - numtodsinterval(level * 60, 'minute')              t_from,
         TIMESTAMP '2023-12-21 23:59:59' - numtodsinterval((level - 1) * 60, 'minute')        t_to,
                    ROW_NUMBER() OVER(ORDER BY level ) n
                FROM dual CONNECT BY level <= 100 ) t
where im.CREATE_DATETIME >= t.t_from AND im.item_level='2'
AND im.CREATE_DATETIME < t.t_to 
group by t_from,t_to order by t_from;

select t_from,t_to,count(1) from rms.ordhead im,
(SELECT TIMESTAMP '2023-12-21 23:59:59' - numtodsinterval(level * 60, 'minute')              t_from,
         TIMESTAMP '2023-12-21 23:59:59' - numtodsinterval((level - 1) * 60, 'minute')        t_to,
                    ROW_NUMBER() OVER(ORDER BY level) n
                FROM dual CONNECT BY level < 125 ) t
where im.CREATE_DATETIME >= t.t_from  AND im.CREATE_DATETIME < t.t_to 
group by t_from,t_to order by t_from;


--ASN
select t_from,t_to,count(1) from SUPP_ASOS.sc_asnin im,
(SELECT TIMESTAMP '2024-04-04 23:59:59' - numtodsinterval(level * 60, 'minute')              t_from,
         TIMESTAMP '2024-04-04 23:59:59' - numtodsinterval((level - 1) * 60, 'minute')        t_to,
                    ROW_NUMBER() OVER(ORDER BY level) n
                FROM dual CONNECT BY level < 25 ) t
where im.CREATE_DATETIME >= t.t_from  AND im.CREATE_DATETIME < t.t_to 
group by t_from,t_to order by t_from;


select t_from,t_to,count(1) from SUPP_ASOS.sc_asnin im,
(SELECT TIMESTAMP '2022-01-01 23:59:59' - numtodsinterval(level * 60, 'minute')              t_from,
         TIMESTAMP '2022-01-01 23:59:59' - numtodsinterval((level - 1) * 60, 'minute')        t_to,
                    ROW_NUMBER() OVER(ORDER BY level) n
                FROM dual CONNECT BY level < 400 ) t
where im.CREATE_DATETIME >= t.t_from  AND im.CREATE_DATETIME < t.t_to 
group by t_from,t_to order by t_from;




select distinct TEMPLATE_ID from ma_asos.MA_STG_UPLOAD_PROCESS;

select TEMPLATE_ID,count(1) from ma_asos.MA_STG_UPLOAD_PROCESS where status ='P' group by TEMPLATE_ID;
select * from ma_asos.MA_STG_UPLOAD_PROCESS;
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in 
    (select distinct process_seq from ma_asos.MA_STG_UPLOAD_PROCESS where TEMPLATE_ID='PO'); 

select TEMPLATE_ID,count(1) from ma_asos.MA_STG_UPLOAD_PROCESS where status ='P' group by TEMPLATE_ID;


select UPLOAD_USER,count(1) from  ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl
where msup.status ='P' and msup.process_seq = msupl.process_seq 
    and msup.TEMPLATE_ID='PO' --and trunc(ENQUEUE_DATETIME) = '21-APR-23'
    group by UPLOAD_USER;
    
select * from ma_asos.MA_STG_UPLOAD_PROCESS where TEMPLATE_ID='PGLPC' and trunc(ENQUEUE_DATETIME) ='18-AUG-23'; 

select PROCESS_SEQ, PROCESS_DESC,count(1) from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in (select process_seq from ma_asos.MA_STG_UPLOAD_PROCESS where TEMPLATE_ID='PO') group by PROCESS_SEQ, PROCESS_DESC;

select calendar.c_date,
       NVL(ITEMS_count.cnt,0)  Options_Upload,
       NVL(ITDESC_count.cnt,0)  OptionsDesc_Upload,
       NVL(ITLIST_count.cnt,0) Itemlist_Upload,
       NVL(SPROMO_count.cnt,0) SimplePromo_Upload,
       NVL(ITUDA_count.cnt,0)  Option_UDA_Upload,
       NVL(MID_count.cnt,0)  MID_Upload,
       NVL(PCHNGE_count.cnt,0) Price_change_Upload,
       NVL(CLRCES_count.cnt,0) Clearances_Upload,
       NVL(PO_count.cnt,0) Purcahse_order_Upload,
       NVL(BCODES_count.cnt,0) Barcode_Upload,
       NVL(PMETHO_count.cnt,0) Pricing_method_Upload,
       NVL(CLABEL_count.cnt,0) CLABEL_Upload,
       NVL(FABR_count.cnt,0) FABR_Upload,
       NVL(COM_count.cnt,0) COM_Upload
from 
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='ITEMS' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) ITEMS_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='ITDESC' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) ITDESC_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='ITLIST' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by TRUNC(msup.ENQUEUE_DATETIME)) ITLIST_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='SPROMO' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by TRUNC(msup.ENQUEUE_DATETIME)) SPROMO_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='PMETHO' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by TRUNC(msup.ENQUEUE_DATETIME)) PMETHO_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='ITUDA' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by TRUNC(msup.ENQUEUE_DATETIME)) ITUDA_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='BCODES' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by TRUNC(msup.ENQUEUE_DATETIME)) BCODES_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='PCHNGE' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) PCHNGE_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='PO' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) PO_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='CLABEL' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) CLABEL_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='FABR' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) FABR_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='CLRCES' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) CLRCES_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='COM' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) COM_count,
   (select TRUNC(msup.ENQUEUE_DATETIME) ENQUEUE_DATETIME, count(msupl.process_seq) as cnt from ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl where msup.status ='P' and msup.process_seq = msupl.process_seq  and msup.TEMPLATE_ID='MID' and trunc(msup.ENQUEUE_DATETIME) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by TRUNC(msup.ENQUEUE_DATETIME)) MID_count,
   (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = ITEMS_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = ITDESC_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = ITLIST_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = SPROMO_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = PMETHO_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = ITUDA_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = BCODES_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = PCHNGE_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = PO_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = CLABEL_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = FABR_count.ENQUEUE_DATETIME(+)
 AND  calendar.c_date = COM_count.ENQUEUE_DATETIME(+) 
 AND  calendar.c_date = MID_count.ENQUEUE_DATETIME(+) 
 AND  calendar.c_date = CLRCES_count.ENQUEUE_DATETIME(+) 
order by calendar.c_date;

select * from MA_ASOS.MA_STG_UPLOAD_BOUNDED_ATTR;
select * from MA_ASOS.MA_STG_UPLOAD_PROCESS_IDS;


select msuba.* from 
    ma_asos.MA_STG_UPLOAD_PROCESS msup,ma_asos.MA_STG_UPLOAD_PROCESS_LINE msupl, MA_ASOS.MA_STG_UPLOAD_BOUNDED_ATTR msuba 
where msup.status ='P' and msup.process_seq = msupl.process_seq  and msuba.process_seq = msupl.process_seq
    and msup.TEMPLATE_ID='PO';
    
select * from ma_asos.MA_STG_UPLOAD_PROCESS;
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in (select process_seq from ma_asos.MA_STG_UPLOAD_PROCESS where TEMPLATE_ID='ITUDA');

select * from 
ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR ,  ma_asos.MA_STG_UPLOAD_PROCESS 
where TEMPLATE_ID='ITUDA' and trunc(ENQUEUE_DATETIME) = '21-APR-23')
and msup.status ='P' and msup.process_seq = msupl.process_seq  and msuba.process_seq = msupl.process_seq
;

select * from rms.uda;
select * from rms.uda_item_lov;

select ORDER_NO from ordhead oh where status ='A' and
    not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no)
    and rownum <= '500';


select * from ma_asos.ma_logs order by 1 desc;



select PROCESS_SEQ, TEMPLATE_ID, STATUS,        
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME
from ma_asos.MA_STG_UPLOAD_PROCESS 
    where TEMPLATE_ID='PGLPC' 
    --AND process_seq in ( '138273','138210','37558')
    order by PROCESS_SEQ desc;


select    distinct to_char(UPLOAD_DATETIME,'dd-mon-yy hh:mi:ss am') UPLOAD_DATETIME
 from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in 
    (select distinct process_seq from ma_asos.MA_STG_UPLOAD_PROCESS where TEMPLATE_ID='SPROMO'); 






select calendar.c_date,
       NVL(promo_dtl_start.cnt,0) promo_dtl_start,
       NVL(promo_dtl_end.cnt,0) promo_dtl_end,
       NVL(price_changes.cnt,0) price_changes,
       NVL(clearances.cnt,0) clearances,       
       NVL(clearance_resets.cnt,0) clearance_resets
  from (select TRUNC(START_DATE) START_DATE, count(1) cnt from rms.rpm_promo_dtl where state in ('3','5','6') and trunc(START_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(START_DATE)) promo_dtl_start,  
       (select TRUNC(end_date) end_date, count(1) cnt from rms.rpm_promo_dtl where state in ('3','5','6') and trunc(end_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(end_date)) promo_dtl_end,  
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance where state !='pricechange.state.worksheet' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) clearances,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_price_change where trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) price_changes,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance_reset where state !='pricechange.state.worksheet' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by trunc(effective_date)) clearance_resets,       
        (SELECT to_date(:begin_date, 'mm/dd/yyyy'   ) + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = promo_dtl_start.START_DATE(+)
   and calendar.c_date = promo_dtl_end.end_date(+)
   and calendar.c_date = price_changes.st_date(+)
   and calendar.c_date = clearances.st_date(+)
   and calendar.c_date = clearance_resets.st_date(+)
order by calendar.c_date;

