select * from rms.vat_item where item in ('3616414315981','12034072','101349757') order by 1,2,3;

select * from rms.item_master where item_level > tran_level and item = '195242134962';
select * from rms.future_cost where item in ('12034072','101349757','195242134962');



    SELECT *
        FROM nb_system_parameters
       WHERE func_area = 'AUTOPO'
         AND parameter = 'RELEASE_DAYS';

select * from v_cfa_alloc_detail_autopo_g;

   SELECT DISTINCT oh.master_po_no
        FROM ordhead oh,
             alloc_header alh
       WHERE oh.po_type = 'A'
         AND oh.status IN ('A','C')
         AND oh.order_no = alh.order_no
         AND alh.status = 'A'
         /* Unassgined allocations exist */
         AND NOT EXISTS (SELECT 'x'
                           FROM v_cfa_alloc_detail_autopo_g alc_apo
                          WHERE alc_apo.alloc_no = alh.alloc_no
                            AND alc_apo.auto_po_shipment IS NOT NULL)
         /* Over-receipt not processed */
         AND EXISTS (SELECT 'X'
                       FROM shipment sp,
                            shipsku sk
                      WHERE sp.status_code = 'R'
                        AND sp.order_no = oh.order_no
                        AND sp.shipment = sk.shipment
                        AND sk.item = alh.item
                        AND NVL(sk.qty_received, 0) > NVL(sk.qty_expected, 0)
                        AND NOT EXISTS (SELECT 'X' FROM v_cfa_ship_dates_g sp_cfa WHERE sp_cfa.shipment = sp.shipment AND sp_cfa.auto_po_outstd_close_ind = 'Y')
                        AND (EXISTS (SELECT 'X' FROM int_receipt_close_head rch WHERE rch.shipment = sp.shipment)
                               OR
                             EXISTS (SELECT 'X' FROM shipment sp2 WHERE sp.shipment = sp2.shipment AND (receive_date + :release_days) < SYSDATE)
                            )
                     );

select * from v_cfa_ship_dates_g;

  SELECT DISTINCT oh.order_no
        FROM ordhead oh,
             alloc_header alh
       WHERE oh.po_type = 'A'
         AND oh.status IN ('A','C')
         AND oh.master_po_no = TO_NUMBER(:ps_master_po_no)
         AND oh.order_no = alh.order_no
         AND alh.status = 'A'
         /* Unassgined allocations exist */
         AND NOT EXISTS (SELECT 'x'
                           FROM v_cfa_alloc_detail_autopo_g alc_apo
                          WHERE alc_apo.alloc_no = alh.alloc_no
                            AND alc_apo.auto_po_shipment IS NOT NULL)
         /* Over-receipt not processed shipments exist*/
         AND EXISTS (SELECT 'X'
                       FROM shipment sp,
                            shipsku sk
                      WHERE sp.status_code = 'R'
                        AND sp.order_no = oh.order_no
                        AND sp.shipment = sk.shipment
                        AND sk.item = alh.item
                        AND NVL(sk.qty_received, 0) > NVL(sk.qty_expected, 0)
                        AND NOT EXISTS (SELECT 'X' FROM v_cfa_ship_dates_g sp_cfa WHERE sp_cfa.shipment = sp.shipment AND sp_cfa.auto_po_outstd_close_ind = 'Y')
                        AND (EXISTS (SELECT 'X' FROM int_receipt_close_head rch WHERE rch.shipment = sp.shipment)
                               OR
                             EXISTS (SELECT 'X' FROM shipment sp2 WHERE sp.shipment = sp2.shipment AND (receive_date + :release_days) < SYSDATE)
                            )
                     );




select * from ordhead where order_no in (500016479378);
select * from ordloc where order_no = '500024299062';

select * from alloc_header where order_no = '500024299062';
select * from alloc_detail where alloc_no in (select alloc_no from alloc_header where order_no in (500029007698,500030120259,500018223145,500018223604,500030120108,500030149178));


 SELECT *
        FROM nb_system_parameters
       WHERE func_area = 'AUTOPO'
         AND parameter = 'RELEASE_DAYS';


select count(1) from ordauto_po;
select count(1) from ordhead where order_no in (select order_no from ordauto_po);
select count(1) from alloc_header where order_no in (select order_no from ordauto_po); -- 69K
select status,po_type,count(1) from ordhead where order_no in (select order_no from ordauto_po) group by status,po_type;



select count(1) from ordauto_po;
select count(1) from ordhead where order_no in (select order_no from ordauto_po);
select count(1) from alloc_header where order_no in (select order_no from ordauto_po); -- 69K

Select oh.* from ordhead oh where  oh.order_no in (select order_no from ordauto_po) and status = 'C';
Select * from alloc_header where order_no in (select order_no from ordauto_po);


select * from ohol_before where  order_no in (select order_no from ordauto_po) and status = 'A';
select distinct order_no from ohol_after where order_no in (select order_no from ohol_before where  order_no in (select order_no from ordauto_po) and status = 'A') and status = 'A';
select * from Ahad_before;
select * from Ahad_after;


select * from period;

select * from restart_control where PROGRAM_NAME like 'ord%';
 -- ordautcl	Delete / close POs	NONE	1	Y	T	1000	10	3

Create table ohol_before as 
Select oh.ORDER_NO, SUPPLIER, WRITTEN_DATE, NOT_BEFORE_DATE, NOT_AFTER_DATE, OTB_EOW_DATE, EARLIEST_SHIP_DATE, LATEST_SHIP_DATE, CLOSE_DATE, STATUS, ORIG_APPROVAL_DATE, ORIG_APPROVAL_ID, VENDOR_ORDER_NO, PO_TYPE, CURRENCY_CODE, PICKUP_DATE, CREATE_DATETIME, MASTER_PO_NO, LAST_UPDATE_DATETIME, 
ol.ITEM, ol.LOCATION, ol.LOC_TYPE, UNIT_RETAIL, QTY_ORDERED, QTY_PRESCALED, QTY_RECEIVED, LAST_RECEIVED, LAST_ROUNDED_QTY, LAST_GRP_ROUNDED_QTY, QTY_CANCELLED, CANCEL_CODE, CANCEL_DATE, CANCEL_ID, UNIT_COST, UNIT_COST_INIT, ESTIMATED_INSTOCK_DATE
from ordhead oh, ordloc ol where ol.order_no = oh.order_no;

Create table Ahad_before as 
Select ah.ALLOC_NO, ORDER_NO, WH, ITEM, STATUS, ALLOC_DESC, PO_TYPE, ALLOC_METHOD, RELEASE_DATE, CLOSE_DATE, 
    TO_LOC, QTY_TRANSFERRED, QTY_ALLOCATED, QTY_PRESCALED, QTY_DISTRO, QTY_SELECTED, QTY_CANCELLED, QTY_RECEIVED, QTY_RECONCILED
from alloc_header ah,alloc_detail ad where ah.alloc_no = ad.alloc_no ;

Create table ohol_after as 
Select oh.ORDER_NO, SUPPLIER, WRITTEN_DATE, NOT_BEFORE_DATE, NOT_AFTER_DATE, OTB_EOW_DATE, EARLIEST_SHIP_DATE, LATEST_SHIP_DATE, CLOSE_DATE, STATUS, ORIG_APPROVAL_DATE, ORIG_APPROVAL_ID, VENDOR_ORDER_NO, PO_TYPE, CURRENCY_CODE, PICKUP_DATE, CREATE_DATETIME, MASTER_PO_NO, LAST_UPDATE_DATETIME, 
ol.ITEM, ol.LOCATION, ol.LOC_TYPE, UNIT_RETAIL, QTY_ORDERED, QTY_PRESCALED, QTY_RECEIVED, LAST_RECEIVED, LAST_ROUNDED_QTY, LAST_GRP_ROUNDED_QTY, QTY_CANCELLED, CANCEL_CODE, CANCEL_DATE, CANCEL_ID, UNIT_COST, UNIT_COST_INIT, ESTIMATED_INSTOCK_DATE
from ordhead oh, ordloc ol where ol.order_no = oh.order_no;

Create table Ahad_after as 
Select ah.ALLOC_NO, ORDER_NO, WH, ITEM, STATUS, ALLOC_DESC, PO_TYPE, ALLOC_METHOD, RELEASE_DATE, CLOSE_DATE, 
    TO_LOC, QTY_TRANSFERRED, QTY_ALLOCATED, QTY_PRESCALED, QTY_DISTRO, QTY_SELECTED, QTY_CANCELLED, QTY_RECEIVED, QTY_RECONCILED
from alloc_header ah,alloc_detail ad where ah.alloc_no = ad.alloc_no ;


Select * from ordhead oh, ordloc ol where ol.order_no = oh.order_no and oh.order_no in (select order_no from ordauto_po);
Select * from alloc_header ah,alloc_detail ad where ah.alloc_no = ad.alloc_no and ah.order_no in (select order_no from ordauto_po);


     SELECT ord_appr_close_delay,
             ord_part_rcvd_close_delay,
             ord_worksheet_clean_up_delay,
             ord_auto_close_part_rcvd_ind,
             TO_CHAR(vdate,'YYYYMMDD')
        FROM system_options,
             period;


update PROCUREMENT_UNIT_OPTIONS set ord_appr_close_delay = '180', ord_part_rcvd_close_delay = '180';

select * from all_views where lower(view_name) like 'system_options';

select count(1) from order_mfqueue;
select count(1) from alloc_mfqueue;


select distinct ob.ORDER_NO, ob.CLOSE_DATE, ob.STATUS as ob_status,oa.status as oa_status
from ohol_before ob,
     ohol_after oa
where     oa.order_no = ob.order_no and ob.STATUS <>  oa.STATUS
           and ob.order_no in (select order_no from ordauto_po);
      



Select * from ordhead oh, ordloc ol where ol.order_no = oh.order_no and oh.order_no in (500029333021,
500029460913,
500026902360,
500029434253);

Select * from alloc_header ah,alloc_detail ad where ah.alloc_no = ad.alloc_no and ah.order_no in (select distinct order_no from ohol_after where order_no in (select order_no from ohol_before where  order_no in (select order_no from ordauto_po) and status = 'A') and status = 'C');;



select distinct
    order_no
from ordhead
where order_no in ( select order_no
                      from ohol_before
                      where order_no not in (select order_no from ordauto_po) and 
                      status = 'A')
      and status = 'C';
 
 select * from ohol_after;
 
Select *
from alloc_header ah,
     alloc_detail ad
where ah.alloc_no = ad.alloc_no
      and ah.status = 'C'
      and ah.order_no in ( select distinct
                                 order_no
                             from ohol_after
                             where order_no in ( select distinct order_no
                                                   from ohol_before
                                                   where order_no not in (select order_no from ordauto_po))
                                   and status = 'C'
                                   and trunc(LAST_UPDATE_DATETIME)= '03-APR-24');;



select count(1) from ohol_before;
select count(1) from ohol_after;

select count(1) from Ahad_after;
select count(1) from Ahad_before;


select count(1) from ohol_after;
select count(1) from Ahad_after;

select count(1) from Ahad_after_0401;




1. Number of PO's closed. -- 14,187
2. Number of Allocation's closed. --18,056 
2. Number of PO's closed shared from Jo. --60 PO's
2. Number of Allocation's closed shared from Jo. -- 596 Line items.
2. Number of Allocation's not closed, PO's closed shared from Jo. -- 39,663 Line items.
3. Additional PO's & Allocations closed by setting change. --14,127 PO's.
4. Batch run times with the change.  -- Less than 5 mins  (3k allocations, 28k order updates)
5. Vol of messages flowing to RIS.   -- 