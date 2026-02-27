select * from rms.ordhead where MASTER_PO_NO ='20679837';
select * from rms.ordloc where order_no in (select order_no from rms.ordhead where MASTER_PO_NO ='20679837');

select * from shipment where order_no in (select order_no from rms.ordhead where MASTER_PO_NO ='20679837');
select * from shipment where order_no in (select order_no from rms.ordhead where MASTER_PO_NO ='20679837');
select * from rms.ordhead where MASTER_PO_NO ='20679852';

drop table missing_ship;

create table missing_ship as

select distinct(order_no) from ordloc ol where ol.QTY_RECEIVED is not null and not exists 
    (select 1 from rms.shipment sh where sh.order_no = ol.order_no);
 

select * from doc_close_queue where doc_type ='P' and doc not in (select order_no from skumar.missing_ship);
 
select * from ordloc where order_no in (select order_no from skumar.missing_ship) order by 1,2;
select * from shipment where order_no in (select order_no from skumar.missing_ship) order by 1,2;
select * from shipsku where shipment in (select shipment from shipment where order_no in (select order_no from skumar.missing_ship));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (select order_no from skumar.missing_ship));


Update shipment set status_code = 'R',receive_date ='27-JAN-19' where order_no in (select order_no from skumar.missing_ship);
Update shipsku set STATUS_CODE ='A',QTY_RECEIVED = QTY_EXPECTED where shipment in (select shipment from shipment where order_no in (select order_no from skumar.missing_ship));
Update shipsku_loc set QTY_RECEIVED= QTY_EXPECTED where shipment in (select shipment from shipment where order_no in (select order_no from skumar.missing_ship));

select * from shipment where order_no in ( '50000948997','50001169848');
select * from shipsku where shipment in (25291062, 25302152);
select * from shipsku_loc where shipment in (25291062, 25302152);
select * from SHIPMENT_PUB_INFO where shipment = '22407645';


