select * from rms.item_mfqueue;

select BOL_NO as consignment, sysdate as DateClosedUtc , w.WH_NAME_SECONDARY as ReceivingWarehouseId from shipment sh,wh w 
    where sh.to_loc  ='1' and sh.to_loc =w.wh and sh.order_no is null and sh.status_code ='R' and rownum <= '1000' order by w.WH_NAME_SECONDARY;
    
 BAM-DTHUB-RIWTSV-099c   
    
<?xml version="1.0" encoding="UTF-8"?><IWTConsignmentClosure>
  <ConsignmentClosure>
    <ReceivingWarehouseId>FC04</ReceivingWarehouseId>
    <DateClosedUtc>2018-04-21T13:28:39Z</DateClosedUtc>
    <Consignments>
      <Consignment id="IET27311524126451"/>
      <Consignment id="IET15421524125736"/>
      <Consignment id="IET36031524126956"/>
    </Consignments>
  </ConsignmentClosure>
</IWTConsignmentClosure>



create table iwtreceiptclosure as 
select distinct sk.carton as box_id, sh.BOL_NO as consignment, TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS DateClosedUtc , 
        w.WH_NAME_SECONDARY as ReceivingWarehouseId from rms.shipment sh,rms.shipsku sk, wh w 
    where sh.to_loc  ='1' and sh.to_loc =w.wh and sh.shipment =sk.shipment and
    sh.order_no is null and sh.status_code ='R' and rownum <= '3000' order by w.WH_NAME_SECONDARY;
    
    
    
<IWTConsignmentClosure xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="IWT Consignment Closure.xsd">
                <ConsignmentClosure>
                                <ReceivingWarehouseId>FC01</ReceivingWarehouseId>
                                <DateClosedUtc>2018-06-28T08:42:03+01:00</DateClosedUtc>
                                <Consignments>
                                                <Consignment id="IWTC1529932797311">
                                                                <Missing>
                                                                                <Box id="9800197559" />
                                                                </Missing>
                                                </Consignment>
                                </Consignments>
                </ConsignmentClosure>
</IWTConsignmentClosure>


select count(1) from rms.INT_RECEIPT_CLOSE_HEAD;
select count(1) from rms.INT_RECEIPT_CLOSE_HEAD where trunc(LAST_UPDATE_DATETIME) ='02-AUG-19' or trunc(CREATE_DATETIME) ='02-AUG-19';
select count(1) from rms.INT_RECEIPT_CLOSE_HEAD where trunc(LAST_UPDATE_DATETIME) ='02-AUG-19';

drop table iwtreceiptclosure;
drop table iwtreceiptclosure_t;

create table iwtreceiptclosure_t as
select tsf_no from rms.tsfhead where status ='C' and TSF_TYPE='IC' and FROM_LOC='1001' and rownum <= '1000';
insert into iwtreceiptclosure_t
select tsf_no from rms.tsfhead where status ='C' and TSF_TYPE='MR' and FROM_LOC='1011' and rownum <= '1000';
insert into iwtreceiptclosure_t
select tsf_no from rms.tsfhead where status ='C' and TSF_TYPE='MR' and FROM_LOC='1014' and rownum <= '1000';

select * from rms.tsfhead where status ='C' and TSF_TYPE='MR' and FROM_LOC='1011' and rownum <= '1000';

delete from skumar.iwtreceiptclosure_t where rownum <= '200';

create table iwtreceiptclosure as 
select distinct sk.carton as box_id, sh.BOL_NO as consignment, TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS DateClosedUtc,
w.WH_NAME_SECONDARY as ReceivingWarehouseId 
 from rms.shipment sh,rms.shipsku sk,rms.wh w where sh.to_loc =w.wh and sh.shipment =sk.shipment 
 and sk.distro_no in (select tsf_no from skumar.iwtreceiptclosure_t);

select * from iwtreceiptclosure_t;

select * from iwtreceiptclosure;


select count(1) from INT_ASOS.INT_RECEIPT_CLOSE_HEAD;
select count(1) from INT_ASOS.INT_RECEIPT_CLOSE_DETAIL;
select DISTINCT SHIPMENT from INT_ASOS.INT_RECEIPT_CLOSE_HEAD;
select DISTINCT SHIPMENT from INT_ASOS.INT_RECEIPT_CLOSE_DETAIL;

select * from skumar.iwtreceiptclosure;

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtreceiptclosure TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtreceiptclosure TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtreceiptclosure TO rdatla; 

    
delete from INT_ASOS.INT_RECEIPT_CLOSE_DETAIL where shipment in (
select distinct sh.shipment from shipment sh where  sh.BOL_NO in (select consignment from skumar.iwtreceiptclosure));
delete from INT_ASOS.INT_RECEIPT_CLOSE_HEAD where shipment in (
select distinct sh.shipment from shipment sh  where sh.BOL_NO in (select consignment from skumar.iwtreceiptclosure));


--validations
select count(1) from INT_ASOS.INT_RECEIPT_CLOSE_HEAD where shipment in 
    (select distinct sh.shipment from shipment sh where sh.BOL_NO in (select consignment from skumar.iwtreceiptclosure));
select count(1) from INT_ASOS.INT_RECEIPT_CLOSE_DETAIL where shipment in 
    (select distinct sh.shipment from shipment sh where sh.BOL_NO in (select consignment from skumar.iwtreceiptclosure));

select * from INT_ASOS.INT_RECEIPT_CLOSE_HEAD where shipment in 
    (select distinct sh.shipment from shipment sh where sh.BOL_NO in (select consignment from skumar.iwtreceiptclosure));

select * from INT_ASOS.INT_RECEIPT_CLOSE_HEAD where shipment ='545853';
select * from INT_ASOS.INT_RECEIPT_CLOSE_DETAIL where shipment ='545853';

select distinct CREATE_ID from rms.INT_RECEIPT_CLOSE_HEAD;

select * from rib_message where message_num > 633100 order by 1 desc;
select * from RIB_MESSAGE_FAILURE where message_num = 633100;
select * from rib_message where message_num = 633100;