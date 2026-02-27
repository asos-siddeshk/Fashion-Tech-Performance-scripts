select * from ma_asos.ma_logs ORDER BY 1 desc;

select * from ordhead where master_po_no ='642577';
select * from alloc_header where order_no in (select order_no from ordhead where master_po_no ='642577');
select * from alloc_detail where alloc_no in (select alloc_no from alloc_header where order_no in (select order_no from ordhead where master_po_no ='642577'));
select * from ordloc where order_no in (select order_no from ordhead where master_po_no ='642577');
select * from shipment where order_no in (select order_no from ordhead where master_po_no ='642577');
select * from shipsku where shipment in (select shipment from shipment where order_no in (select order_no from ordhead where master_po_no ='642577'));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (select order_no from ordhead where master_po_no ='642577'));


select * from item_master where item_parent ='101464785';
update ordhead set PICKUP_DATE = '04-MAR-2020' where master_po_no ='642577';

        select *
        from ma_asos.ma_order_mfqueue
        where order_no in (select order_no from ordhead where master_po_no ='642577');
        select * from ;

MA_ORDER_UTILS_SQL.DEQUEUE_PO_MASS_MNT_CALLBACK
MA_ORDERS_SQL.PROCESS_QUEUE_RECORD
MA_ORDER_UTILS_SQL.DEQUEUE_PO_MASS_MNT_CALLBACK

select * from svc_process_tracker order by 1 desc;;
select * from RMS.SVC_ORDHEAD where master_po_no ='642577' order by 1 desc;




ERROR_ORDER_PUB_PROCESS_REC # 3867503|The quantity ordered cannot fall below the expected quantity for shipments and appointments, which is %s1.
The quantity ordered cannot fall below the expected quantity for shipments and appointments, which is %s1.
select * from ma_asos.ma_errors;
select * from rtk_errors;

SHIP_APPT_QTY	The quantity ordered cannot fall below the expected quantity for shipments and appointments, which is %s1.
select * from dba_source where text like '%SHIP_APPT_QTY%';


      select * --NVL(SUM(NVL(shs.qty_expected, 0)), 0) qty_expected
              from shipsku shs,
                     shipment shp
             where shs.shipment = shp.shipment
                and shp.order_no = '501052906976';
                
    select * --, NVL(SUM(NVL(DECODE(ah.status, 'AC', ad.qty_received, ad.qty_appointed), 0)), 0)
        from appt_detail ad,
             appt_head ah
       where ad.appt = ah.appt
         and ad.doc_type = 'P'
         and ad.doc = '501052906976';