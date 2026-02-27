dELETE from int_asos.INT_RECEIPT_CLOSE_DETAIL where shipment in 
 (SELECT shipment from int_asos.int_receipt_close_head  irch where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21'); 
dELETE from int_asos.int_receipt_close_head  irch where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21';


SELECT * from int_asos.int_receipt_close_head irch where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21';
SELECT * from int_asos.INT_RECEIPT_CLOSE_DETAIL;

begin
dELETE from int_asos.INT_RECEIPT_CLOSE_DETAIL where shipment in (SELECT shipment from int_asos.int_receipt_close_head  irch where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21'); 
dELETE from int_asos.int_receipt_close_head where shipment in 
(SELECT shipment from int_asos.int_receipt_close_head  irch 
    where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21'); 
commit;
end;
/
dELETE from int_asos.int_receipt_close_head irch where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21';

dELETE from int_asos.int_receipt_close_head  irch where  irch.shipment  BETWEEN  '54960699' AND '198646367' AND trunc(CLOSE_DATE)='10-NOV-21';  


    SELECT NEW ma_shipsku_obj(shipment => shipment,
                              seq_no   => seq_no,
                              item     => item) shipment
      FROM (SELECT shp.shipment,
                   shps.seq_no,
                   shps.item
      FROM shipment shp,
           ordhead ohe,
       shipsku shps
     WHERE shp.order_no = ohe.order_no
       AND shps.shipment = shp.shipment
       AND shp.status_code = 'R'
       AND shp.invc_match_status = 'U'
       AND (TRUNC(shp.receive_date) = TRUNC('20211110') - '7'
            OR EXISTS
            (SELECT 1
               FROM int_asos.int_receipt_close_head padex
              WHERE shp.shipment = padex.shipment
                AND TRUNC(padex.close_date) <= TRUNC('20211110')))
       AND EXISTS (SELECT 1
                     FROM nb_shipsku_rev shkrev,
                         shipsku shk
                    WHERE shkrev.shipment (+) =  shk.shipment
                      AND shkrev.item     (+) =  shk.item
                      AND shkrev.seq_no   (+) =  shk.seq_no
                      AND shk.shipment        =  shp.shipment
                      AND shk.item            =  shps.item
                      AND shk.seq_no          =  shps.seq_no
                      AND shkrev.rev_no (+)   = 0
                      AND NVL(shkrev.qty_expected,shk.qty_expected) > NVL(shk.qty_received, 0))
       AND ((ohe.po_type = 'A' AND
         NOT EXISTS (SELECT 1
                           FROM v_cfa_alloc_detail_autopo_g cfa_dtl,
                                v_cfa_alloc_header_autopo_g cfa_hdr
                          WHERE cfa_dtl.auto_po_shipment = shp.shipment
                            AND cfa_dtl.alloc_no = cfa_hdr.alloc_no
                            AND NVL(cfa_hdr.auto_po_alloc_release_ind,'N') <> 'Y'
                            AND ROWNUM < 2)) OR NOT EXISTS (SELECT 1
                                                              FROM v_cfa_alloc_detail_autopo_g cfa_dtl
                                                             WHERE cfa_dtl.auto_po_shipment = shp.shipment
                                                               AND ROWNUM < 2)))
     WHERE MOD(shipment, 2) + 1 = 2;



 select *     FROM nb_system_parameters s
     WHERE s.func_area = 'CANCEL_BALANCE'
       AND s.parameter = v_parameter;
