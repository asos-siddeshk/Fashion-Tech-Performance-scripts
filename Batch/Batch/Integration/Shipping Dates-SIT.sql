  SELECT ' INT_CFAKeyDesc_REC(''' || KEY_COL || ''',' ||
          CASE DATA_TYPE
            WHEN 'VARCHAR2' THEN
             (KEY_COL || ',NULL,NULL)')
            WHEN 'NUMBER' THEN
             ('NULL,' || KEY_COL || ',NULL)')
            WHEN 'DATE' THEN
             ('NULL,NULL,' || KEY_COL || ')')
          END KEY_DESC
     FROM CFA_EXT_ENTITY_KEY
    WHERE BASE_RMS_TABLE = 'SHIPMENT'
    ORDER BY KEY_NUMBER ASC;

        

 select INT_CFAKeyDesc_REC('SHIPMENT',NULL,SHIPMENT,NULL) from dual;
 
 select * from partner;
 select * from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no and sh.status_code ='I');
 
select  * from ordhead where order_no in (50001284331);
select * from ordhead_cfa_ext where order_no in (50001284331); --0200000000001022 --30-APR-19	13-FEB-19

select * from ordloc where order_no in (50001284331);
select * from shipment where order_no in (50001284331); --0200000000018195
select * from shipment where asn in ('0200000000035035'); --0200000000018195
select * from nb_shipment_cfa_ext where shipment in (select shipment from shipment where order_no in (50001284331));
select STATUS_CODE,count(1) from shipment where order_no in (50001284331) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50001284331));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (50001284331));
 
 
select distinct sh.asn,sh.order_no,date_23    actual_ship_date,
                      date_22    carrier_booking_date,
                      date_21    effective_ship_date,
                      date_24    fc_booking_date,
                      varchar2_1 fc_booking_ref,
                      date_25    lastupdate_carrier_bookingdate,
                      varchar2_2 auto_po_outstd_close_ind
  from rms.shipment sh, rms.shipsku sk, rms.nb_shipment_cfa_ext nbs, rms.ordhead oh
  where sh.shipment=sk.shipment
        and sk.shipment=nbs.shipment
        and sh.order_no=oh.order_no
        --and nbs.group_id='1010100'
        and sh.asn='0200000000035035';
 

select * from nb_shipment_cfa_ext where date_23 is not null order by 1 desc; 
 
 