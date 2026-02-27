    select * FROM rms.logger_logs where trunc(TIME_STAMP) =trunc(sysdate) order by TIME_STAMP desc;
    select * FROM ma_asos.ma_logs where trunc(LOG_TS) =trunc(sysdate) order by LOG_TS desc;
    
select * from rms.ordhead where MASTER_PO_NO in (select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A';
select * from rms.ordsku where order_no in (select order_no from rms.ordhead where MASTER_PO_NO in (select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A');
select * from rms.ordloc where order_no in (select order_no from rms.ordhead where MASTER_PO_NO in (select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A');
select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2';

select * from int_asos.INT_PO_COMMITMENT_GTT;

select * from int_asos.INT_CMT_ORDERED_GTT;
select * from int_asos.INT_PO_COMMITMENT_GTT;
select * from int_asos.INT_PO_COMMITMENT; --1.4M 

select count(1) from int_asos.INT_PO_COMMITMENT; --1.4M 

select distinct master_po_no from int_asos.INT_PO_COMMITMENT_GTT where MASTER_PO_NO not in (select MASTER_PO_NO from po_commit_po);
select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2' and DRIVER_VALUE not in (select MASTER_PO_NO from po_commit_po);


select * from po_commit_po;

Update ordhead set status ='C' where MASTER_PO_NO not in (select MASTER_PO_NO from po_commit_po);

set serveroutput on;
set timing on;
      DECLARE
              error_message     VARCHAR(255) := NULL;
      BEGIN
         if INT_ASOS.INT_PO_COMMITMENT_SQL.POPULATE_RESULT_TABLE( 
                          2,
                          error_message) = FALSE
          THEN
        dbms_output.put_line('Failed: '||error_message);
          ELSE
          dbms_output.put_line('Passed');
          
          END IF;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/
      
      
drop table po_commit;
create table po_commit as 
 SELECT  GTT.*,
           NVL(MVB_FIRST_LOC.BUY_UNIT_RETAIL, 0) BUY_UNIT_RETAIL_FIRST_LOC,
           NVL(MVB_FINAL_LOC.BUY_UNIT_RETAIL, 0) BUY_UNIT_RETAIL_FINAL_LOC,
           WH.CURRENCY_CODE  CURRENCY_CODE_FINAL,
           WH2.CURRENCY_CODE CURRENCY_CODE_FIRST,
           OH.CURRENCY_CODE  ORDER_CURRENCY
      FROM int_asos.INT_PO_COMMITMENT_GTT GTT,
           WH,
           WH WH2,
           ORDHEAD OH,
           rms.INT_MV_ITEM_LOC_BUY_PRICE_EOD MVB_FIRST_LOC,
           rms.INT_MV_ITEM_LOC_BUY_PRICE_EOD MVB_FINAL_LOC
     WHERE WH.WH = GTT.FINAL_LOC
       AND WH2.WH = GTT.FIRST_LOC
       AND OH.ORDER_NO = GTT.ORDER_NO
       AND GTT.ITEM = MVB_FIRST_LOC.ITEM (+)
       AND GTT.FIRST_LOC = MVB_FIRST_LOC.LOC (+)
       AND GTT.ITEM = MVB_FINAL_LOC.ITEM (+)
       AND GTT.FINAL_LOC = MVB_FINAL_LOC.LOC (+);
       
       
       
       select * from po_commit;
       
       
       
       
       select * from ordhead where MASTER_PO_NO in (select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A';


select * from int_asos.INT_CMT_ALLOCATED_GTT;
select * from int_asos.INT_CMT_ORDERED_GTT;
select * from int_asos.INT_CMT_PO_SHIPPED_FINAL_GTT;
select * from int_asos.INT_CMT_PO_SHIPPED_FIRST_GTT;
select * from int_asos.INT_CMT_PO_RCVD_FIRST_GTT;
select * from int_asos.INT_CMT_PO_RCVD_FINAL_GTT;
select * from int_asos.INT_CMT_ALC_RCVD_FINAL_GTT;
select * from int_asos.INT_CMT_ALC_SHIPPED_FIRST_GTT;
select * from int_asos.INT_CMT_ALC_RECEIVED_GTT;

--- GTT insert


/* 

INSERT INTO int_asos.INT_CMT_ALLOCATED_GTT
    SELECT GREATEST(oh.not_after_date, GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(alloc.in_store_date, GET_VDATE) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           ALLOC.TO_LOC FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           ALLOC.ALLOC_NO,
           NULL ASN,
           ALLOC.QTY_ALLOCATED UNITS,
           'N' CARRIER_BOOKED_IND,
           'N' FC_BOOKED_IND,
           CASE
             WHEN alloc.in_store_date < GET_VDATE THEN
              'Y'
             WHEN alloc.in_store_date >= GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   in_store_date,
                   qty_allocated,
                   qty_distro,
                   qty_cancelled
              FROM alloc_header ah, alloc_detail al
             WHERE ah.alloc_no = al.alloc_no
               AND AH.STATUS = 'A'
               AND ah.order_no IS NOT NULL) ALLOC
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OL.location = wh.wh
       AND OH.ORDER_NO = ALLOC.ORDER_NO
       AND OL.ITEM = ALLOC.ITEM
       AND OL.LOCATION = ALLOC.WH;

  -- Ordered quantities to First Dest only
  INSERT INTO int_asos.INT_CMT_ORDERED_GTT
    SELECT GREATEST(OH.NOT_AFTER_DATE, GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(OH.NOT_AFTER_DATE, GET_VDATE) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           WH.WH FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           NULL ALLOC_NO,
           NULL ASN,
           OL.QTY_ORDERED - NVL(ALLOC.UNITS, 0) UNITS,
           'N' CARRIER_BOOKED_IND,
           'N' FC_BOOKED_IND,
           CASE
             WHEN OH.NOT_AFTER_DATE < GET_VDATE THEN
              'Y'
             WHEN OH.NOT_AFTER_DATE >= GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT EXPECTED_DATE_FIRST_LOC,
                   EXPECTED_DATE_FINAL_LOC,
                   ITEM,
                   FIRST_LOC,
                   --FINAL_LOC,
                   ORDER_NO,
                   MASTER_PO_NO,
                   ASN,
                   SUM(UNITS) UNITS,
                   CARRIER_BOOKED_IND,
                   FC_BOOKED_IND,
                   OVERDUE_IND
              FROM int_asos.INT_CMT_ALLOCATED_GTT
             GROUP BY EXPECTED_DATE_FIRST_LOC,
                      EXPECTED_DATE_FINAL_LOC,
                      ITEM,
                      FIRST_LOC,
                      --FINAL_LOC,
                      ORDER_NO,
                      MASTER_PO_NO,
                      ASN,
                      CARRIER_BOOKED_IND,
                      FC_BOOKED_IND,
                      OVERDUE_IND) ALLOC
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = ALLOC.ORDER_NO(+)
       AND OL.ITEM = ALLOC.ITEM(+)
       AND OL.LOCATION = ALLOC.FIRST_LOC(+)
       AND ol.qty_ordered - NVL(ALLOC.UNITS, 0) <> 0
    UNION ALL
    SELECT EXPECTED_DATE_FIRST_LOC,
           EXPECTED_DATE_FINAL_LOC,
           ITEM,
           FIRST_LOC,
           FINAL_LOC,
           ORDER_NO,
           MASTER_PO_NO,
           ALLOC_NO,
           ASN,
           UNITS,
           CARRIER_BOOKED_IND,
           FC_BOOKED_IND,
           OVERDUE_IND
      FROM int_asos.INT_CMT_ALLOCATED_GTT;

  -- Shipped shipments for split and auto for first destination intended to final
  INSERT INTO int_asos.INT_CMT_PO_SHIPPED_FINAL_GTT
    SELECT      -- Booked with FC
           CASE WHEN NVL2(ALLOC.FC_BOOKING_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(ALLOC.FC_BOOKING_DATE, GET_VDATE)
                -- Booked with Carrier and Not with FC
                WHEN NVL2(ALLOC.FC_BOOKING_DATE, 'Y', 'N') = 'N' AND
                     NVL2(ALLOC.ACTUAL_SHIP_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(ALLOC.ACTUAL_SHIP_DATE + NVL(tsit_matrix.total_days, 0), GET_VDATE)
                -- Not booked with Carrier or FC
                ELSE GREATEST(NVL(ALLOC.EST_ARR_DATE, OH.NOT_AFTER_DATE), GET_VDATE)
           END AS EXPECTED_DATE_FIRST_LOC,
                -- Booked with FC
           CASE WHEN NVL2(ALLOC.FC_BOOKING_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(ALLOC.FC_BOOKING_DATE , GET_VDATE) + NVL(tport_matrix.days, 0)
                -- Booked with Carrier and Not with FC
                WHEN NVL2(ALLOC.FC_BOOKING_DATE, 'Y', 'N') = 'N' AND
                     NVL2(ALLOC.ACTUAL_SHIP_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(ALLOC.ACTUAL_SHIP_DATE + NVL(tsit_matrix.total_days, 0) + NVL(tport_matrix.days, 0), GET_VDATE + NVL(tport_matrix.days, 0))
                -- Not booked with Carrier or FC
                ELSE GREATEST(NVL(ALLOC.EST_ARR_DATE, OH.NOT_AFTER_DATE), GET_VDATE) + NVL(tport_matrix.days, 0)
           END AS EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           ALLOC.TO_LOC FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           ALLOC.ALLOC_NO,
           ALLOC.ASN ASN,
           ALLOC.QTY_EXPECTED UNITS,
           NVL2(ALLOC.ACTUAL_SHIP_DATE, 'Y', 'N') AS CARRIER_BOOKED_IND,
           NVL2(ALLOC.FC_BOOKING_DATE, 'Y', 'N') AS FC_BOOKED_IND,
           CASE
             WHEN ALLOC.FC_BOOKING_DATE IS NOT NULL AND
                  ALLOC.FC_BOOKING_DATE  + NVL(tport_matrix.days, 0) < GET_VDATE THEN
               'Y'
             WHEN ALLOC.FC_BOOKING_DATE IS NULL AND
                  ALLOC.ACTUAL_SHIP_DATE IS NOT NULL AND
                  ALLOC.ACTUAL_SHIP_DATE + NVL(tsit_matrix.total_days, 0) + NVL(tport_matrix.days, 0) < GET_VDATE THEN
               'Y'
             WHEN NVL(alloc.est_arr_date, oh.not_after_date) +
                  NVL(tport_matrix.days, 0) < GET_VDATE THEN
               'Y'
             ELSE
               'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (
            --Auto PO
            SELECT ah.alloc_no,
                    ah.order_no,
                    ah.wh,
                    ah.item,
                    al.to_loc,
                    sh.est_arr_date,
                    qty_allocated,
                    qty_distro,
                    qty_allocated            qty_expected,
                    qty_cancelled,
                    cfa_ext.AUTO_PO_SHIPMENT SHIPMENT,
                    cfa_ext.AUTO_PO_ASN_NBR  ASN,
                    sh_cfa_ext.ACTUAL_SHIP_DATE,
                    sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header                ah,
                    alloc_detail                al,
                    V_CFA_ALLOC_DETAIL_AUTOPO_G cfa_ext,
                    shipsku                     sk,
                    shipment                    sh,
                    V_CFA_SHIP_DATES_G          sh_cfa_ext,
                    wh
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh.wh
               and wh.physical_wh = sh.to_loc
               and sh.shipment = sk.shipment
               AND sh.order_no = ah.order_no
               AND AH.STATUS = 'A'
               AND ah.order_no IS NOT NULL
               AND cfa_ext.alloc_no = al.alloc_no
               AND sh.asn = cfa_ext.AUTO_PO_ASN_NBR
               AND cfa_ext.to_loc = al.to_loc
               AND sh.shipment = cfa_ext.AUTO_PO_SHIPMENT
               AND sh.shipment = sh_cfa_ext.shipment (+)
            UNION ALL
            --Split PO
            SELECT ah.alloc_no,
                    ah.order_no,
                    ah.wh,
                    ah.item,
                    al.to_loc,
                    sh.est_arr_date,
                    qty_allocated,
                    qty_distro,
                    sk.qty_expected,
                    qty_cancelled,
                    cfa_ext.DISTRO_NBR SHIPMENT,
                    sh.ASN             ASN,
                    sh_cfa_ext.ACTUAL_SHIP_DATE,
                    sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header            ah,
                    alloc_detail           al,
                    V_CFA_SHIPSKU_DISTRO_G cfa_ext,
                    shipsku                sk,
                    shipment               sh,
                    V_CFA_SHIP_DATES_G     sh_cfa_ext,
                    wh
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh.wh
               and wh.physical_wh = sh.to_loc
               and sh.shipment = sk.shipment
               AND AH.STATUS = 'A'
               AND sh.order_no = ah.order_no
               AND ah.order_no IS NOT NULL
               AND cfa_ext.shipment = sk.shipment
               and cfa_ext.seq_no = sk.seq_no
               and cfa_ext.item = sk.item
               and cfa_ext.distro_nbr = ah.alloc_no
               and sh.shipment = sh_cfa_ext.shipment (+)) ALLOC,
           ma_asos.MA_TRANSIT_MATRIX tsit_matrix,
           ma_asos.MA_TRNSP_TRANSIT_MATRIX tport_matrix
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = ALLOC.ORDER_NO
       AND OL.ITEM = ALLOC.ITEM
       AND OL.LOCATION = ALLOC.WH
       AND OH.lading_port = tsit_matrix.shipping_point (+)
       AND ALLOC.wh = tsit_matrix.receiving_point (+)
       AND OH.ship_method = tsit_matrix.shipping_method (+)
       AND OH.partner1 = tsit_matrix.freight_forwarder (+)
       AND tport_matrix.shipping_wh(+) = ALLOC.WH
       AND tport_matrix.receiving_wh(+) = ALLOC.TO_LOC;

  -- Shipped items for First Dest only
  INSERT INTO int_asos.INT_CMT_PO_SHIPPED_FIRST_GTT
    SELECT      -- Booked with FC
           CASE WHEN NVL2(SHIP.FC_BOOKING_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(SHIP.FC_BOOKING_DATE, GET_VDATE)
                -- Booked with Carrier and Not with FC
                WHEN NVL2(SHIP.FC_BOOKING_DATE, 'Y', 'N') = 'N' AND
                     NVL2(SHIP.ACTUAL_SHIP_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(SHIP.ACTUAL_SHIP_DATE + NVL(tsit_matrix.total_days, 0), GET_VDATE)
                -- Not booked with Carrier or FC
                ELSE GREATEST(NVL(SHIP.EST_ARR_DATE, OH.NOT_AFTER_DATE), GET_VDATE)
           END AS EXPECTED_DATE_FIRST_LOC,
                -- Booked with FC
           CASE WHEN NVL2(SHIP.FC_BOOKING_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(SHIP.FC_BOOKING_DATE, GET_VDATE)
                -- Booked with Carrier and Not with FC
                WHEN NVL2(SHIP.FC_BOOKING_DATE, 'Y', 'N') = 'N' AND
                     NVL2(SHIP.ACTUAL_SHIP_DATE, 'Y', 'N') = 'Y' THEN
                  GREATEST(SHIP.ACTUAL_SHIP_DATE + NVL(tsit_matrix.total_days, 0), GET_VDATE)
                -- Not booked with Carrier or FC
                ELSE GREATEST(NVL(SHIP.EST_ARR_DATE, OH.NOT_AFTER_DATE), GET_VDATE)
           END AS EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           WH.WH FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           NULL,
           SHIP.ASN ASN,
           SHIP.QTY_EXPECTED - NVL(SHP2.UNITS, 0) UNITS,
           NVL2(SHIP.ACTUAL_SHIP_DATE, 'Y', 'N') AS CARRIER_BOOKED_IND,
           NVL2(SHIP.FC_BOOKING_DATE, 'Y', 'N') AS FC_BOOKED_IND,
           CASE
             WHEN SHIP.FC_BOOKING_DATE IS NOT NULL AND
                  SHIP.FC_BOOKING_DATE < GET_VDATE THEN
               'Y'
             WHEN SHIP.FC_BOOKING_DATE IS NULL AND
                  SHIP.ACTUAL_SHIP_DATE IS NOT NULL AND
                  SHIP.ACTUAL_SHIP_DATE + NVL(tsit_matrix.total_days, 0) < GET_VDATE THEN
               'Y'
             WHEN NVL(SHIP.est_arr_date, oh.not_after_date) < GET_VDATE THEN
               'Y'
             ELSE
               'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT SUM(NVL(qty_expected, 0)) QTY_EXPECTED,
                   SUM(NVL(qty_received, 0)) QTY_RECEIVED,
                   SH.asn,
                   SH.order_no,
                   SH.to_loc,
                   SK.item,
                   SH.shipment,
                   SH.EST_ARR_DATE,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM shipment           SH,
                   shipsku            SK,
                   V_CFA_SHIP_DATES_G sh_cfa_ext
             WHERE SH.shipment = SK.shipment
               AND SH.order_no IS NOT NULL
               AND sh.shipment = sh_cfa_ext.shipment (+)
             GROUP BY SH.asn,
                      SH.order_no,
                      SH.to_loc,
                      SK.item,
                      SH.shipment,
                      SH.EST_ARR_DATE,
                      sh_cfa_ext.ACTUAL_SHIP_DATE,
                      sh_cfa_ext.FC_BOOKING_DATE) SHIP,
           ma_asos.MA_TRANSIT_MATRIX tsit_matrix,
           int_asos.INT_CMT_PO_SHIPPED_FINAL_GTT SHP2
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = SHIP.ORDER_NO
       AND OL.ITEM = SHIP.ITEM
       AND WH.PHYSICAL_WH = SHIP.TO_LOC
       AND OH.ORDER_NO = SHP2.ORDER_NO(+)
       AND OH.MASTER_PO_NO = SHP2.MASTER_PO_NO(+)
       AND WH.WH = SHP2.FIRST_LOC(+)
       AND OL.ITEM = SHP2.ITEM(+)
       AND SHIP.ASN = SHP2.ASN(+)
       AND OH.lading_port = tsit_matrix.shipping_point (+)
       AND OL.location = tsit_matrix.receiving_point (+)
       AND OH.ship_method = tsit_matrix.shipping_method (+)
       AND OH.partner1 = tsit_matrix.freight_forwarder (+);

  --- Received quantity on First Dest
  INSERT INTO int_asos.INT_CMT_PO_RCVD_FIRST_GTT
    SELECT GREATEST(NVL(SHIP.EST_ARR_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(NVL(SHIP.EST_ARR_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           WH.WH FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           NULL,
           SHIP.ASN ASN,
           SHIP.QTY_RECEIVED UNITS,
           'N' AS CARRIER_BOOKED_IND,
           'N' AS FC_BOOKED_IND,
           CASE
             WHEN SHIP.EST_ARR_DATE < GET_VDATE THEN
              'Y' -- Do we need this?
             WHEN SHIP.EST_ARR_DATE >= GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT SUM(Nvl(qty_expected, 0)) QTY_EXPECTED,
                   SUM(Nvl(qty_received, 0)) QTY_RECEIVED,
                   SH.asn,
                   SH.order_no,
                   SH.to_loc,
                   SK.item,
                   SH.shipment,
                   NVL(EST_ARR_DATE, GET_VDATE) EST_ARR_DATE,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM shipment           SH,
                   shipsku            SK,
                   V_CFA_SHIP_DATES_G sh_cfa_ext
             WHERE SH.shipment = SK.shipment
               AND SH.order_no IS NOT NULL
               AND NVL(SK.QTY_RECEIVED, 0) <> 0
               AND sh.shipment = sh_cfa_ext.shipment (+)
             GROUP BY SH.asn,
                      SH.order_no,
                      SH.to_loc,
                      SK.item,
                      SH.shipment,
                      NVL(EST_ARR_DATE, GET_VDATE),
                      sh_cfa_ext.ACTUAL_SHIP_DATE,
                      sh_cfa_ext.FC_BOOKING_DATE) SHIP
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = SHIP.ORDER_NO
       AND OL.ITEM = SHIP.ITEM
       AND WH.PHYSICAL_WH = SHIP.TO_LOC;

  -- Received quantities on First Dest of auto and split POs
  INSERT INTO int_asos.INT_CMT_PO_RCVD_FINAL_GTT
    SELECT GREATEST(NVL(alloc.EST_ARR_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(NVL(alloc.EST_ARR_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           ALLOC.TO_LOC FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           ALLOC.ALLOC_NO,
           ALLOC.ASN ASN,
           ALLOC.qty_received UNITS,
           'N' AS CARRIER_BOOKED_IND,
           'N' AS FC_BOOKED_IND,
           CASE
             WHEN NVL(alloc.EST_ARR_DATE, GET_VDATE) < GET_VDATE THEN
              'Y'
             WHEN NVL(alloc.EST_ARR_DATE, GET_VDATE) >= GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   EST_ARR_DATE,
                   qty_allocated,
                   qty_distro,
                   sk.qty_received,
                   qty_cancelled,
                   cfa_ext.AUTO_PO_SHIPMENT SHIPMENT,
                   cfa_ext.AUTO_PO_ASN_NBR  ASN,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header                ah,
                   alloc_detail                al,
                   V_CFA_ALLOC_DETAIL_AUTOPO_G cfa_ext,
                   shipsku                     sk,
                   shipment                    sh,
                   V_CFA_SHIP_DATES_G          sh_cfa_ext,
                   wh
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh.wh
               and wh.physical_wh = sh.to_loc
               and sh.shipment = sk.shipment
               AND AH.STATUS = 'A'
               AND ah.order_no IS NOT NULL
               AND sh.order_no = ah.order_no
               AND cfa_ext.alloc_no = al.alloc_no
               AND sh.asn = cfa_ext.AUTO_PO_ASN_NBR
               AND NVL(sk.qty_received, 0) <> 0
               AND cfa_ext.to_loc = al.to_loc
               AND sh.shipment = cfa_ext.AUTO_PO_SHIPMENT
               AND sh.shipment = sh_cfa_ext.shipment (+)
            UNION ALL
            SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   EST_ARR_DATE,
                   qty_allocated,
                   qty_distro,
                   sk.qty_received,
                   qty_cancelled,
                   cfa_ext.shipment SHIPMENT,
                   sh.ASN           ASN,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header           ah,
                   alloc_detail           al,
                   V_CFA_SHIPSKU_DISTRO_G cfa_ext,
                   shipsku                sk,
                   shipment               sh,
                   V_CFA_SHIP_DATES_G     sh_cfa_ext,
                   wh
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh.wh
               and wh.physical_wh = sh.to_loc
               and sh.shipment = sk.shipment
               AND AH.STATUS = 'A'
               AND sh.order_no = ah.order_no
               AND ah.order_no IS NOT NULL
               AND NVL(sk.qty_received, 0) <> 0
               AND cfa_ext.shipment = sk.shipment
               and cfa_ext.seq_no = sk.seq_no
               and cfa_ext.item = sk.item
               and cfa_ext.distro_nbr = ah.alloc_no
               AND sh.shipment = sh_cfa_ext.shipment (+)) ALLOC
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = ALLOC.ORDER_NO
       AND OL.ITEM = ALLOC.ITEM
       AND OL.LOCATION = ALLOC.WH;

  -- Received quantities on First Dest of auto and split POs
  INSERT INTO int_asos.INT_CMT_ALC_RCVD_FINAL_GTT
    SELECT GREATEST(NVL(alloc.RECEIVE_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(NVL(alloc.RECEIVE_DATE, GET_VDATE), GET_VDATE) + NVL(tport_matrix.days, 0) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           ALLOC.TO_LOC FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           ALLOC.ALLOC_NO,
           ALLOC.ASN ASN,
           ALLOC.qty_received UNITS,
           'N' AS CARRIER_BOOKED_IND,
           'N' AS FC_BOOKED_IND,
           CASE
             WHEN NVL(ALLOC.RECEIVE_DATE, GET_VDATE) < GET_VDATE THEN
              'Y'
             WHEN NVL(ALLOC.RECEIVE_DATE, GET_VDATE) + NVL(tport_matrix.days, 0) >=
                  GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   SH.RECEIVE_DATE,
                   qty_allocated,
                   qty_distro,
                   CASE
                     WHEN sk.qty_received >= qty_allocated THEN
                      qty_allocated
                     ELSE
                      sk.qty_received
                   END AS qty_received,
                   qty_cancelled,
                   cfa_ext.AUTO_PO_SHIPMENT SHIPMENT,
                   cfa_ext.AUTO_PO_ASN_NBR ASN,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header                ah,
                   alloc_detail                al,
                   V_CFA_ALLOC_DETAIL_AUTOPO_G cfa_ext,
                   shipsku                     sk,
                   shipment                    sh,
                   V_CFA_SHIP_DATES_G          sh_cfa_ext,
                   wh
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh.wh
               and wh.physical_wh = sh.to_loc
               and sh.shipment = sk.shipment
               AND AH.STATUS = 'A'
               AND sh.order_no = ah.order_no
               AND ah.order_no IS NOT NULL
               AND cfa_ext.alloc_no = al.alloc_no
               AND sh.asn = cfa_ext.AUTO_PO_ASN_NBR
               AND NVL(sk.qty_received, 0) <> 0
               AND cfa_ext.to_loc = al.to_loc
               AND sh.shipment = cfa_ext.AUTO_PO_SHIPMENT
               AND sh.shipment = sh_cfa_ext.shipment (+)
            UNION ALL
            SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   SH.RECEIVE_DATE,
                   qty_allocated,
                   qty_distro,
                   sk.qty_received,
                   qty_cancelled,
                   cfa_ext.distro_nbr SHIPMENT,
                   sh.ASN             ASN,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header           ah,
                   alloc_detail           al,
                   V_CFA_SHIPSKU_DISTRO_G cfa_ext,
                   shipsku                sk,
                   shipment               sh,
                   V_CFA_SHIP_DATES_G     sh_cfa_ext,
                   wh
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh.wh
               and wh.physical_wh = sh.to_loc
               and sh.shipment = sk.shipment
               AND AH.STATUS = 'A'
               AND sh.order_no = ah.order_no
               AND ah.order_no IS NOT NULL
               AND NVL(sk.qty_received, 0) <> 0
               AND cfa_ext.shipment = sk.shipment
               and cfa_ext.seq_no = sk.seq_no
               and cfa_ext.item = sk.item
               and cfa_ext.distro_nbr = ah.alloc_no
               AND sh.shipment = sh_cfa_ext.shipment (+)) ALLOC,
           ma_asos.MA_TRNSP_TRANSIT_MATRIX tport_matrix
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = ALLOC.ORDER_NO
       AND OL.ITEM = ALLOC.ITEM
       AND OL.LOCATION = ALLOC.WH
       AND tport_matrix.shipping_wh(+) = ALLOC.WH
       AND tport_matrix.receiving_wh(+) = ALLOC.TO_LOC;

  -- Shipped Allocations on Final Dest
  INSERT INTO int_asos.INT_CMT_ALC_SHIPPED_FIRST_GTT
    SELECT GREATEST(NVL(alloc.SHIP_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(NVL(alloc.SHIP_DATE, GET_VDATE) + NVL(matrix.days, 0),
                    GET_VDATE) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           ALLOC.TO_LOC FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           ALLOC.ALLOC_NO,
           NULL ASN,
           ALLOC.qty_expected UNITS,
           'N' AS CARRIER_BOOKED_IND,
           'N' AS FC_BOOKED_IND,
           CASE
             WHEN alloc.SHIP_DATE < GET_VDATE THEN
              'Y'
             WHEN alloc.SHIP_DATE >= GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   SH.SHIP_DATE,
                   qty_allocated,
                   qty_distro,
                   sk.qty_expected,
                   qty_cancelled,
                   SH.SHIPMENT,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header        ah,
                   alloc_detail        al,
                   shipsku             sk,
                   shipment            sh,
                   V_CFA_SHIP_DATES_G  sh_cfa_ext,
                   wh                  wh1,
                   wh                  wh2
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh1.wh
               and wh1.physical_wh = sh.from_loc
               and sh.shipment = sk.shipment
               and wh2.physical_wh = sh.to_loc
               and wh2.wh = al.to_loc
               AND AH.STATUS = 'A'
               AND ah.order_no IS NOT NULL
               AND sk.distro_no = al.alloc_no
               AND sh.shipment = sh_cfa_ext.shipment (+)) ALLOC,
           ma_asos.MA_TRNSP_TRANSIT_MATRIX matrix
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = ALLOC.ORDER_NO
       AND OL.ITEM = ALLOC.ITEM
       AND OL.LOCATION = ALLOC.WH
       AND matrix.shipping_wh(+) = ALLOC.WH
       AND matrix.receiving_wh(+) = ALLOC.TO_LOC;

  -- Received Allocations on Final Dest
  INSERT INTO int_asos.INT_CMT_ALC_RECEIVED_GTT
    SELECT GREATEST(NVL(alloc.SHIP_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FIRST_LOC,
           GREATEST(NVL(alloc.SHIP_DATE, GET_VDATE), GET_VDATE) EXPECTED_DATE_FINAL_LOC,
           OL.ITEM ITEM,
           WH.WH FIRST_LOC,
           ALLOC.TO_LOC FINAL_LOC,
           OH.ORDER_NO ORDER_NO,
           OH.MASTER_PO_NO MASTER_PO_NO,
           ALLOC.ALLOC_NO,
           NULL ASN,
           ALLOC.qty_received UNITS,
           'N' AS CARRIER_BOOKED_IND,
           'N' AS FC_BOOKED_IND,
           CASE
             WHEN alloc.SHIP_DATE < GET_VDATE THEN
              'Y'
             WHEN alloc.SHIP_DATE >= GET_VDATE THEN
              'N'
           END AS OVERDUE_IND
      FROM ordhead oh,
           int_asos.INT_V_RESTART_ORDER restart,
           ordloc ol,
           wh,
           (SELECT ah.alloc_no,
                   ah.order_no,
                   ah.wh,
                   ah.item,
                   al.to_loc,
                   SH.SHIP_DATE,
                   qty_allocated,
                   qty_distro,
                   sk.qty_received,
                   qty_cancelled,
                   SH.SHIPMENT,
                   sh_cfa_ext.ACTUAL_SHIP_DATE,
                   sh_cfa_ext.FC_BOOKING_DATE
              FROM alloc_header        ah,
                   alloc_detail        al,
                   shipsku             sk,
                   shipment            sh,
                   V_CFA_SHIP_DATES_G  sh_cfa_ext,
                   wh                  wh1,
                   wh                  wh2
             WHERE ah.alloc_no = al.alloc_no
               and sk.item = ah.item
               and ah.wh = wh1.wh
               and wh1.physical_wh = sh.from_loc
               and sh.shipment = sk.shipment
               and wh2.physical_wh = sh.to_loc
               and wh2.wh = al.to_loc
               AND AH.STATUS = 'A'
               AND ah.order_no IS NOT NULL
               AND sk.distro_no = al.alloc_no
               AND sh.shipment = sh_cfa_ext.shipment (+)) ALLOC
     WHERE OH.status = 'A'
       AND OL.order_no = OH.order_no
       AND OL.location = wh.wh
       AND restart.driver_value = OH.MASTER_PO_NO
       AND restart.thread_val = '2'
       AND OH.ORDER_NO = ALLOC.ORDER_NO
       AND OL.ITEM = ALLOC.ITEM
       AND OL.LOCATION = ALLOC.WH; 

--Merge

  --Outstanding unshipped quantity to First Destination and Final Destination
  INSERT INTO int_asos.INT_PO_COMMITMENT_GTT (STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         COMMITMENT_UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND)
  SELECT '1' STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         UNITS - SHIPPED_UNITS_FIRST - SHIPPED_UNITS_FINAL UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND
    FROM (SELECT ORD.EXPECTED_DATE_FIRST_LOC,
                 ORD.EXPECTED_DATE_FINAL_LOC,
                 ORD.ITEM,
                 ORD.FIRST_LOC,
                 ORD.FINAL_LOC,
                 ORD.ORDER_NO,
                 ORD.MASTER_PO_NO,
                 ORD.ALLOC_NO,
                 ORD.ASN,
                 ORD.UNITS,
                 SUM(NVL(SHP.UNITS, 0)) SHIPPED_UNITS_FIRST,
                 SUM(NVL(SHP2.UNITS, 0)) SHIPPED_UNITS_FINAL,
                 ORD.CARRIER_BOOKED_IND,
                 ORD.FC_BOOKED_IND,
                 ORD.OVERDUE_IND
            FROM int_asos.INT_CMT_ORDERED_GTT          ORD,
                 int_asos.INT_CMT_PO_SHIPPED_FIRST_GTT SHP,
                 int_asos.INT_CMT_PO_SHIPPED_FINAL_GTT SHP2
           WHERE ORD.ORDER_NO = SHP.ORDER_NO(+)
             AND ORD.ITEM = SHP.ITEM(+)
             AND ORD.FINAL_LOC = SHP.FINAL_LOC(+)
             AND ORD.FIRST_LOC = SHP.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP.MASTER_PO_NO(+)
             AND ORD.ORDER_NO = SHP2.ORDER_NO(+)
             AND ORD.ITEM = SHP2.ITEM(+)
             AND ORD.ALLOC_NO = SHP2.ALLOC_NO(+)
             AND ORD.FINAL_LOC = SHP2.FINAL_LOC(+)
             AND ORD.FIRST_LOC = SHP2.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP2.MASTER_PO_NO(+)
           GROUP BY ORD.EXPECTED_DATE_FIRST_LOC,
                    ORD.EXPECTED_DATE_FINAL_LOC,
                    ORD.ITEM,
                    ORD.FIRST_LOC,
                    ORD.FINAL_LOC,
                    ORD.ORDER_NO,
                    ORD.MASTER_PO_NO,
                    ORD.ALLOC_NO,
                    ORD.UNITS,
                    ORD.ASN,
                    ORD.CARRIER_BOOKED_IND,
                    ORD.FC_BOOKED_IND,
                    ORD.OVERDUE_IND)
   WHERE (UNITS - SHIPPED_UNITS_FIRST - SHIPPED_UNITS_FINAL) > 0;

  --Outstanding quantity against First and Final Destination based on the unreceived shipped quantity
  INSERT INTO int_asos.INT_PO_COMMITMENT_GTT(STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         COMMITMENT_UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND)
  SELECT '2' STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         SHIPPED_UNITS - RECEIVED_UNITS UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND
    FROM (SELECT ORD.EXPECTED_DATE_FIRST_LOC,
                 ORD.EXPECTED_DATE_FINAL_LOC EXPECTED_DATE_FINAL_LOC,
                 ORD.ITEM,
                 ORD.FIRST_LOC,
                 ORD.FINAL_LOC,
                 ORD.ORDER_NO,
                 ORD.MASTER_PO_NO,
                 NULL ALLOC_NO,
                 ORD.ASN,
                 ORD.UNITS SHIPPED_UNITS,
                 SUM(NVL(SHP.UNITS, 0)) RECEIVED_UNITS,
                 SUM(NVL(SHP2.UNITS, 0)) SHIPPED_FINAL_UNITS,
                 ORD.CARRIER_BOOKED_IND,
                 ORD.FC_BOOKED_IND,
                 ORD.OVERDUE_IND
            FROM int_asos.INT_CMT_PO_SHIPPED_FIRST_GTT ORD,
                 int_asos.INT_CMT_PO_RCVD_FIRST_GTT    SHP,
                 int_asos.INT_CMT_PO_SHIPPED_FINAL_GTT SHP2
           WHERE ORD.ORDER_NO = SHP.ORDER_NO(+)
             AND ORD.ITEM = SHP.ITEM(+)
             AND ORD.FINAL_LOC = SHP.FINAL_LOC(+)
             AND ORD.FIRST_LOC = SHP.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP.MASTER_PO_NO(+)
             AND ORD.ASN = SHP.ASN(+)
             AND ORD.ORDER_NO = SHP2.ORDER_NO(+)
             AND ORD.ITEM = SHP2.ITEM(+)
             AND ORD.FIRST_LOC = SHP2.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP2.MASTER_PO_NO(+)
             AND ORD.ASN = SHP2.ASN(+)
           GROUP BY ORD.EXPECTED_DATE_FIRST_LOC,
                    ORD.EXPECTED_DATE_FINAL_LOC,
                    ORD.ITEM,
                    ORD.FIRST_LOC,
                    ORD.FINAL_LOC,
                    ORD.ORDER_NO,
                    ORD.MASTER_PO_NO,
                    NULL,
                    ORD.ASN,
                    ORD.UNITS,
                    ORD.CARRIER_BOOKED_IND,
                    ORD.FC_BOOKED_IND,
                    ORD.OVERDUE_IND)
   WHERE SHIPPED_UNITS - RECEIVED_UNITS > 0
  UNION ALL
  SELECT '2',
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         SHIPPED_UNITS - RECEIVED_UNITS UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND
    FROM (SELECT ORD.EXPECTED_DATE_FIRST_LOC,
                 ORD.EXPECTED_DATE_FINAL_LOC,
                 ORD.ITEM,
                 ORD.FIRST_LOC,
                 ORD.FINAL_LOC,
                 ORD.ORDER_NO,
                 ORD.MASTER_PO_NO,
                 ORD.ALLOC_NO,
                 ORD.ASN,
                 ORD.UNITS SHIPPED_UNITS,
                 SUM(NVL(SHP.UNITS, 0)) RECEIVED_UNITS,
                 ORD.CARRIER_BOOKED_IND,
                 ORD.FC_BOOKED_IND,
                 ORD.OVERDUE_IND
            FROM int_asos.INT_CMT_PO_SHIPPED_FINAL_GTT ORD,
                 int_asos.INT_CMT_PO_RCVD_FINAL_GTT    SHP
           WHERE ORD.ORDER_NO = SHP.ORDER_NO(+)
             AND ORD.ITEM = SHP.ITEM(+)
             AND ORD.FINAL_LOC = SHP.FINAL_LOC(+)
             AND ORD.FIRST_LOC = SHP.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP.MASTER_PO_NO(+)
             AND ORD.ASN = SHP.ASN(+)
           GROUP BY ORD.EXPECTED_DATE_FIRST_LOC,
                    ORD.EXPECTED_DATE_FINAL_LOC,
                    ORD.ITEM,
                    ORD.FIRST_LOC,
                    ORD.FINAL_LOC,
                    ORD.ORDER_NO,
                    ORD.MASTER_PO_NO,
                    ORD.ALLOC_NO,
                    ORD.ASN,
                    ORD.UNITS,
                    ORD.CARRIER_BOOKED_IND,
                    ORD.FC_BOOKED_IND,
                    ORD.OVERDUE_IND)
   WHERE (SHIPPED_UNITS - RECEIVED_UNITS) > 0;

  --Pending Allocation Out (for first destination only)
  INSERT INTO int_asos.INT_PO_COMMITMENT_GTT(STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         PENDING_ALLOC_OUT_UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND)
  SELECT '3' STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FIRST_LOC,
         ITEM,
         FIRST_LOC,
         FIRST_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         -1 * (SHIPPED_UNITS - RECEIVED_UNITS) UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         'N'
    FROM (SELECT ORD.EXPECTED_DATE_FIRST_LOC,
                 ORD.EXPECTED_DATE_FINAL_LOC,
                 ORD.ITEM,
                 ORD.FIRST_LOC,
                 ORD.FINAL_LOC FINAL_LOC,
                 ORD.ORDER_NO,
                 ORD.MASTER_PO_NO,
                 ORD.ALLOC_NO,
                 NULL ASN,
                 ORD.UNITS SHIPPED_UNITS,
                 SUM(NVL(SHP.UNITS, 0)) RECEIVED_UNITS,
                 ORD.CARRIER_BOOKED_IND,
                 ORD.FC_BOOKED_IND,
                 ORD.OVERDUE_IND
            FROM int_asos.INT_CMT_ALC_RCVD_FINAL_GTT    ORD,
                 int_asos.INT_CMT_ALC_SHIPPED_FIRST_GTT SHP
           WHERE ORD.ORDER_NO = SHP.ORDER_NO(+)
             AND ORD.ITEM = SHP.ITEM(+)
             AND ORD.FINAL_LOC = SHP.FINAL_LOC(+)
             AND ORD.FIRST_LOC = SHP.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP.MASTER_PO_NO(+)
           GROUP BY ORD.EXPECTED_DATE_FIRST_LOC,
                    ORD.EXPECTED_DATE_FINAL_LOC,
                    ORD.ITEM,
                    ORD.FIRST_LOC,
                    ORD.FINAL_LOC,
                    ORD.ORDER_NO,
                    ORD.MASTER_PO_NO,
                    ORD.ALLOC_NO,
                    NULL,
                    ORD.UNITS,
                    ORD.CARRIER_BOOKED_IND,
                    ORD.FC_BOOKED_IND,
                    ORD.OVERDUE_IND)
   WHERE (SHIPPED_UNITS - RECEIVED_UNITS) > 0;

  --Pending Allocation In (for final destination only)
  INSERT INTO int_asos.INT_PO_COMMITMENT_GTT(STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         PENDING_ALLOC_IN_UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND)
  SELECT '4' PART,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         SHIPPED_UNITS - RECEIVED_UNITS UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         'N'
    FROM (SELECT ORD.EXPECTED_DATE_FIRST_LOC,
                 ORD.EXPECTED_DATE_FINAL_LOC,
                 ORD.ITEM,
                 ORD.FIRST_LOC,
                 ORD.FINAL_LOC,
                 ORD.ORDER_NO,
                 ORD.MASTER_PO_NO,
                 ORD.ALLOC_NO,
                 NULL ASN,
                 ORD.UNITS SHIPPED_UNITS,
                 SUM(NVL(SHP.UNITS, 0)) RECEIVED_UNITS,
                 ORD.CARRIER_BOOKED_IND,
                 ORD.FC_BOOKED_IND,
                 ORD.OVERDUE_IND
            FROM int_asos.INT_CMT_ALC_RCVD_FINAL_GTT    ORD,
                 int_asos.INT_CMT_ALC_SHIPPED_FIRST_GTT SHP
           WHERE ORD.ORDER_NO = SHP.ORDER_NO(+)
             AND ORD.ITEM = SHP.ITEM(+)
             AND ORD.FINAL_LOC = SHP.FINAL_LOC(+)
             AND ORD.FIRST_LOC = SHP.FIRST_LOC(+)
             AND ORD.MASTER_PO_NO = SHP.MASTER_PO_NO(+)
           GROUP BY ORD.EXPECTED_DATE_FIRST_LOC,
                    ORD.EXPECTED_DATE_FINAL_LOC,
                    ORD.ITEM,
                    ORD.FIRST_LOC,
                    ORD.FINAL_LOC,
                    ORD.ORDER_NO,
                    ORD.MASTER_PO_NO,
                    ORD.ALLOC_NO,
                    NULL,
                    ORD.UNITS,
                    ORD.CARRIER_BOOKED_IND,
                    ORD.FC_BOOKED_IND,
                    ORD.OVERDUE_IND)
   WHERE (SHIPPED_UNITS - RECEIVED_UNITS) > 0;

  --Union All In Transit (for final destination only)
  INSERT INTO int_asos.INT_PO_COMMITMENT_GTT(STEP,
         EXPECTED_DATE_FIRST_LOC,
         EXPECTED_DATE_FINAL_LOC,
         ITEM,
         FIRST_LOC,
         FINAL_LOC,
         ORDER_NO,
         MASTER_PO_NO,
         ALLOC_NO,
         ASN,
         IN_TRANSIT_UNITS,
         CARRIER_BOOKED_IND,
         FC_BOOKED_IND,
         OVERDUE_IND)
    SELECT '5' PART,
           EXPECTED_DATE_FIRST_LOC,
           EXPECTED_DATE_FINAL_LOC,
           ITEM,
           FIRST_LOC,
           FINAL_LOC,
           ORDER_NO,
           MASTER_PO_NO,
           ALLOC_NO,
           ASN,
           SHIPPED_UNITS - RECEIVED_UNITS UNITS,
           CARRIER_BOOKED_IND,
           FC_BOOKED_IND,
           'N'
      FROM (SELECT ORD.EXPECTED_DATE_FIRST_LOC,
                   ORD.EXPECTED_DATE_FINAL_LOC,
                   ORD.ITEM,
                   ORD.FIRST_LOC,
                   ORD.FINAL_LOC,
                   ORD.ORDER_NO,
                   ORD.MASTER_PO_NO,
                   ORD.ALLOC_NO,
                   ORD.ASN,
                   ORD.UNITS SHIPPED_UNITS,
                   SUM(NVL(SHP.UNITS, 0)) RECEIVED_UNITS,
                   ORD.CARRIER_BOOKED_IND,
                   ORD.FC_BOOKED_IND,
                   ORD.OVERDUE_IND
              FROM int_asos.INT_CMT_ALC_SHIPPED_FIRST_GTT ORD,
                   int_asos.INT_CMT_ALC_RECEIVED_GTT      SHP
             WHERE ORD.ORDER_NO = SHP.ORDER_NO(+)
               AND ORD.ITEM = SHP.ITEM(+)
               AND ORD.FINAL_LOC = SHP.FINAL_LOC(+)
               AND ORD.ALLOC_NO = SHP.ALLOC_NO
               AND ORD.FIRST_LOC = SHP.FIRST_LOC(+)
               AND ORD.MASTER_PO_NO = SHP.MASTER_PO_NO(+)
             GROUP BY ORD.EXPECTED_DATE_FIRST_LOC,
                      ORD.EXPECTED_DATE_FINAL_LOC,
                      ORD.ITEM,
                      ORD.FIRST_LOC,
                      ORD.FINAL_LOC,
                      ORD.ORDER_NO,
                      ORD.MASTER_PO_NO,
                      ORD.ALLOC_NO,
                      ORD.ASN,
                      ORD.UNITS,
                      ORD.CARRIER_BOOKED_IND,
                      ORD.FC_BOOKED_IND,
                      ORD.OVERDUE_IND)
     WHERE (SHIPPED_UNITS - RECEIVED_UNITS) > 0;
*/



select * from dba_source where text like '%UOM_NOT_EXIST%';


         select * from elc_comp where comp_id in ('TRSPRT','HNDLGUK'); --EA
         select * from alloc_chrg where PER_COUNT_UOM is not null;
         select * from alloc_chrg where PER_COUNT_UOM is not null and ALLOC_NO in (select ALLOC_NO from rms.alloc_header where order_no in (select order_no from ordhead where MASTER_PO_NO in 
(select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A'));
         
         create table alloc_chrg_null as
         select * from alloc_chrg where PER_COUNT_UOM is null;
         select * from alloc_chrg_null; --HNDLGUK
              select * from alloc_chrg where PER_COUNT_UOM is not null;
         Update alloc_chrg set PER_COUNT=1, PER_COUNT_UOM='EA' where PER_COUNT_UOM is  null;