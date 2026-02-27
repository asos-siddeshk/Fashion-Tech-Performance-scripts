      SELECT TO_NUMBER(value_1)
        FROM nb_system_parameters
       WHERE func_area = 'AUTOPO'
         AND parameter = 'RELEASE_DAYS';
         
         
          SELECT DISTINCT oh.master_po_no
        FROM ordhead oh,
             alloc_header alh
       WHERE oh.po_type = 'A'
         AND oh.status = 'A'
         AND oh.order_no = alh.order_no
         AND alh.status = 'A'
         /* Unassgined allocations exist */
         AND NOT EXISTS (SELECT 'x'
                           FROM rms.v_cfa_alloc_detail_autopo_g alc_apo
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
                        AND NOT EXISTS (SELECT 'X' FROM rms.v_cfa_ship_dates_g sp_cfa WHERE sp_cfa.shipment = sp.shipment AND sp_cfa.auto_po_outstd_close_ind = 'Y')
                        AND (EXISTS (SELECT 'X' FROM rms.int_receipt_close_head rch WHERE rch.shipment = sp.shipment)
                               OR
                             EXISTS (SELECT 'X' FROM shipment sp2 WHERE sp.shipment = sp2.shipment AND (receive_date + 2) < SYSDATE)
                            )
                     );
                     
                     





 SELECT DISTINCT oh.order_no
        FROM ordhead oh,
             alloc_header alh
       WHERE oh.po_type = 'A'
         AND oh.status = 'A'
         AND oh.master_po_no = TO_NUMBER( '20684539')
         AND oh.order_no = alh.order_no
         AND alh.status = 'A'
         /* Unassgined allocations exist */
         AND NOT EXISTS (SELECT 'x'
                           FROM v_cfa_alloc_detail_autopo_g alc_apo
                          WHERE alc_apo.alloc_no = alh.alloc_no
                            AND alc_apo.auto_po_shipment IS NOT NULL)
          AND EXISTS (SELECT 'X'
                       FROM shipment sp,
                            shipsku sk
                      WHERE sp.status_code = 'R'
                        AND sp.order_no = oh.order_no
                        AND sp.shipment = sk.shipment
                        AND sk.item = alh.item
                        AND NVL(sk.qty_received, 0) > NVL(sk.qty_expected, 0)
                        AND NOT EXISTS (SELECT 'X' FROM rms.v_cfa_ship_dates_g sp_cfa WHERE sp_cfa.shipment = sp.shipment AND sp_cfa.auto_po_outstd_close_ind = 'Y')
                        AND (EXISTS (SELECT 'X' FROM rms.int_receipt_close_head rch WHERE rch.shipment = sp.shipment)
                               OR
                             EXISTS (SELECT 'X' FROM shipment sp2 WHERE sp.shipment = sp2.shipment AND (receive_date + 2) < SYSDATE)
                            )
                     );
                            
select  order_no,status from ordhead where order_no in (50001194669);
select  * from ordhead where order_no in (50001194669);
select * from ordloc where order_no in (50001194669);
select * from shipment where order_no in (50001194669);
select STATUS_CODE,count(1) from shipment where order_no in (50001194669) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50001194669));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (50001194669));             
                
                
                   