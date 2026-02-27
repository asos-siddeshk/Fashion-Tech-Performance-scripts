select *
    from ma_asos.nb_system_parameters s
   where s.func_area in ('IMA_THRESHOLDS','PMA_THRESHOLDS','POMA_THRESHOLDS','PROMO_THRESHOLDS','UPLD_THRESHOLDS')
    and parameter like '%CL%';
select * from MA_ASOS.MA_PO_APPROVAL_LIMIT_HEAD;

5000 / Upload limit

update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='PO';
Update MA_ASOS.MA_PO_APPROVAL_LIMIT_HEAD set APPROVAL_LIMIT = '99999999999';


 select PROCESS_SEQ, TEMPLATE_ID, STATUS,UPLOAD_USER,     
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME,
       DEQUEUE_END_DATETIME-DEQUEUE_START_DATETIME diff
 from ma_asos.MA_STG_UPLOAD_PROCESS ms
where         TEMPLATE_ID in ('PO')    --and
    --       ENQUEUE_DATETIME>= to_date('17-JAN-2024 07:00', 'DD-MON-YYYY hh24:mi')
     --and      status= 'E'   
    --AND process_seq in ( '138652','138210','37558')
    and exists (select 1 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR msua where msua.process_seq = ms.process_seq and msua.ATTR_1 = 'Cancel' )
        --and msua.ATTR_2 in (select to_char(order_no) from rms.ordhead where master_po_no = '22924674'))
    order by PROCESS_SEQ desc;
    
delete from ordhead_lock where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543731));


select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq  in (561138);
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in (561138); 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS where process_seq in (561138);
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (561138);

select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where attr_2 in (select to_char(order_no) from rms.ordhead where master_po_no = '22924674');
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq in (543737);


select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where attr_2 in (select to_char(order_no) from rms.ordhead where master_po_no = '22924674') order by 1,2;

select status,count(1) from rms.ordhead where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543739,543738,543737,543736,543735,543734,543730,543729)) group by status;

select * from rms.ordloc where order_no in (select order_no from rms.ordhead where status = 'C' and order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543739,543738,543737,543736,543735,543734,543730,543729)));

select status,count(1) from ordhead where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543739,543738,543737,543736,543735,543734,543730,543729)) group by status;

select count(distinct(ATTR_2)) from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543739,543738,543737,543736,543735,543734,543730,543729); 
select ATTR_2,count(1) from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543739,543738,543737,543736,543735,543734,543730,543729) group by ATTR_2 having count(1) >1; 

select count(1) from rms.ordhead_lock; --1.6m records 

select order_no from rms.ordhead where master_po_no = '22878574';

select order_no from rms.ordhead oh where status = 'A' --and rownum <= '500' 
        and exists (select 1 from rms.alloc_header ah where ah.order_no = oh.order_no and ah.status !='C')
        and exists (select 1 from rms.ordloc ol where ol.order_no = oh.order_no and ol.CANCEL_CODE is null) 
        and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no);

select *  from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR msa where msa.ATTR_2  = oh.order_no);

PO with alloc & no shipments & no cancel
PO with no alloc & no shipments & no cancel
PO with alloc & not shipments & cancel

1500 POs -- 9000 = Messages received in RIB AND RIS - 140k messaages.

        
select status,count(1) from ordhead where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737)) group by status;
select order_no,status from ordhead where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737));
    select * from ordloc where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737));;
    select * from shipment where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737));;
    select ALLOC_NO, ORDER_NO, STATUS from alloc_header where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737));;
    select * from shipsku where shipment in (select shipment from shipment where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737)));
    select * from shipsku where DISTRO_NO in (select alloc_no from alloc_header where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737)));
    
    select * from rms.order_mfqueue;
    select count(1) from order_mfqueue;
    
    select * FROM rms.logger_logs where TIME_STAMP >= to_date('20-FEB-2024 08:00', 'DD-MON-YYYY hh24:mi') order by 1 desc;
    select count(1) FROM rms.logger_logs where TIME_STAMP >= to_date('24-JAN-2024 15:00', 'DD-MON-YYYY hh24:mi') order by 1; --7063
    
    select * FROM ma_asos.ma_logs where LOG_TS >= to_date('20-FEB-2024 08:00', 'DD-MON-YYYY hh24:mi') order by LOG_TS desc;

    select order_no,status from rms.ordhead where order_no in (500029313199);
    select ORDER_NO, ITEM, LOCATION, QTY_ORDERED, QTY_RECEIVED, QTY_CANCELLED, CANCEL_CODE, CANCEL_DATE,QTY_RECEIVED-QTY_ORDERED from rms.ordloc where order_no in (500029313199);
    select * from rms.shipment where order_no in (500029313199);;
    select ALLOC_NO, ORDER_NO, STATUS from rms.alloc_header where order_no in (500029313199);;
    select SHIPMENT, SEQ_NO, ITEM, QTY_RECEIVED, QTY_EXPECTED,QTY_RECEIVED - QTY_EXPECTED  from rms.shipsku where shipment in (select shipment from rms.shipment where order_no in (500029313199));
    select SHIPMENT, SEQ_NO, ITEM, DISTRO_NO, DISTRO_TYPE, CARTON, QTY_RECEIVED, QTY_EXPECTED,QTY_RECEIVED - QTY_EXPECTED from rms.shipsku where DISTRO_NO in (select alloc_no from rms.alloc_header where order_no in (500029313199));

select ol.ORDER_NO, ol.ITEM, ol.LOCATION, ol.QTY_ORDERED, ol.QTY_RECEIVED, ol.QTY_CANCELLED, ol.CANCEL_CODE, ol.CANCEL_DATE,ol.QTY_RECEIVED - ol.QTY_ORDERED as Difference, 
        case when ol.QTY_RECEIVED > ol.QTY_ORDERED then 'Over received' else 'Under received' end as result
        from rms.ordloc ol, rms.ordhead oh 
        where ol.order_no = oh.order_no 
            and oh.order_no in (500029313199);
--            and oh.order_no  in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq in (543737));
--            and oh.status = 'A' ;
--           and ol.QTY_ORDERED <> ol.QTY_RECEIVED;
 
 
  select PROCESS_SEQ, TEMPLATE_ID, STATUS,UPLOAD_USER,     
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME,
       DEQUEUE_END_DATETIME-DEQUEUE_START_DATETIME diff
 from ma_asos.MA_STG_UPLOAD_PROCESS ms
where         TEMPLATE_ID in ('PO')   
--     and      status!= 'E'
  and ENQUEUE_DATETIME>= to_date('17-JAN-2024 07:00', 'DD-MON-YYYY hh24:mi')
  and exists (select 1 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR msua where msua.process_seq = ms.process_seq and msua.ATTR_1 = 'Cancel')
    order by PROCESS_SEQ desc;
    
    
    
Few errors noticed during the tests: 

Tried to process 3500 PO's with 7 uploads, only 2000 PO's were cancelled. 4 uploads were aborted.
In logger logs - warning -- Table lock in RIB mfqueue tables. -  sql_lib.create_msg message:@0TABLE_LOCKED@1ORDER_MFQUEUE@2500030562048
In logger logs - warning -- From Deal Supplier cost calculations -  sql_lib.create_msg message:@0NO_ORDER_ITEM@
?Sample PO- 500029291449 The PO Amend Cancel is aborting without giving any errors while processing some PO's which has under received / over received ASN's. After the process is aborted, partial records are processed.
MA_ASOS.MA_ORDER_UTILS_SQL", line 18450 -> ORA-00060: deadlock detected while waiting for resource
Large vol of approved PO's records left in Microapp staging tables.
During processing, looks like many orders locked in ordhead_lock tables for processing but never released after job's completes/aborts, we were facing errors while reprocessing.


select count(MASTER_ORDER_NO) from ma_asos.ma_stg_order where status ='A';
    select * FROM rms.logger_logs where trunc(TIME_STAMP) =trunc(sysdate) order by TIME_STAMP desc;
    select * FROM ma_asos.ma_logs where trunc(LOG_TS) =trunc(sysdate) order by LOG_TS desc;