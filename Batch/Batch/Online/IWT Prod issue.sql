truncate table tran_data_a;
truncate table tran_data_b;

select * from iwtitem;
select * from iwtitemvalid;

select * from tran_data;

SELECT 	ia.item,
			'201' as adjustment_reason_code,
			20 as unit_qty
      FROM skumar.iwtitem ia where exists (select 1 from rms.item_loc_soh ils where ils.item = ia.item);



Update item_loc_soh set stock_on_hand = '20',NON_SELLABLE_QTY ='10' where loc = '1015' and item in (select item from iwtitem);
Update item_loc_soh set stock_on_hand = '20',NON_SELLABLE_QTY ='10' where loc = '1015' and item not in (select item from iwtitem) and rownum <= '2500';


select ITEM, LOC, STOCK_ON_HAND, NON_SELLABLE_QTY from item_loc_soh where loc in( '1015','1001') and stock_on_hand = '20' and NON_SELLABLE_QTY ='10';


create table presnap as 
select * from item_loc_soh where loc in( '1015') and stock_on_hand = '20' and NON_SELLABLE_QTY ='10';

select * from item_loc_soh where loc = '1015' and stock_on_hand = '0' and item in (select item from iwtitem);


select * from item_loc_soh where loc = '1015' and stock_on_hand = '20' and item in (select item from iwtitem);
select * from item_master where item in (select item from iwtitem) and status != 'A';
select * from item_loc where loc = '1015' and  item in (select item from iwtitem) and status != 'A';




delete rib_message where MESSAGE_NUM >='90193692';
delete RIB_MESSAGE_ROUTING_INFO where MESSAGE_NUM >='90193692';
delete rib_message_failure where MESSAGE_NUM >='90193692';




select * from rib_message where ATTEMPT_COUNT <> MAX_ATTEMPTS;


select * from rms.tsfhead;

create table iwtitemvalid (item varchar2(25));
select * from iwtitem;
create table iwtitemvalidcheck (item varchar2(25));

select * from iwtitemvalid where item in (select item from item_master where item_level = tran_level);

select * from iwtitemvalid where item in (select item from item_master where item_level = tran_level);

select * from daily_purge;

select * from iwtitemvalid where item not in (select item from item_loc_soh);

select * from iwtitem where item in (select item from item_master where item_level = '1');
select * from iwtitem where item not in (select item from item_master where item_level = '2');

select * from iwtitem;
truncate table iwtitem;

select distinct item from skumar.iwtitemvalid iwt where not exists (select 1 from rms.item_loc_soh ils where ils.item = iwt.item and ils.loc = '1015');
select distinct item from skumar.iwtitemvalid iwt where not exists (select 1 from rms.item_loc_soh ils where ils.item = iwt.item);

delete from skumar.iwtitem iwt where not exists (select 1 from rms.item_loc_soh ils where ils.item = iwt.item);

select * from item_loc_soh where loc = '1015' and item in (select item from skumar.iwtitemvalid);
select * from item_loc_soh where loc = '1015' and item not in (select item from skumar.iwtitem);

Update item_loc_soh set stock_on_hand = '0',NON_SELLABLE_QTY ='0',IN_TRANSIT_QTY='0', TSF_RESERVED_QTY='0', TSF_EXPECTED_QTY='0' where loc = '1015' and item in (select item from iwtitem);
Update item_loc_soh set stock_on_hand = '0',NON_SELLABLE_QTY ='0',IN_TRANSIT_QTY='0', TSF_RESERVED_QTY='0', TSF_EXPECTED_QTY='0' where loc = '1001' and item in (select item from iwtitem);

select count (distinct item) from skumar.iwtitem iwt where not exists (select 1 from rms.item_loc_soh ils where ils.item = iwt.item and ils.loc = '1015');
select * from rms.tsfhead where tsf_no >  '8344900426' order by 1 desc;



create table iwtitemvalidcheck (item varchar2(25));
select * from iwtitemvalidcheck where item not in (select item from item_master where item_level = tran_level);

select * from iwtitemvalidcheck where item in (select item from iwtitemvalid);
select * from iwtitemvalidcheck where item not in (select item from item_loc_soh);

select * from item_master where item in (select item from iwtitemvalid);
select count(1) from item_loc_soh where item in (select item from iwtitemvalid) and loc = '1015';


truncate table iwtitemvalid;




SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE 'LOGG%';
select * from logger_logs where id > 683177475 order by id desc;




select ITEM, TSF_QTY,INV_STATUS, SHIP_QTY,count(1) from rms.tsfdetail where tsf_no = '5130011738' group by ITEM, TSF_QTY,INV_STATUS, SHIP_QTY;

select * from rib_message order by 1 desc;

select * from rib_message where MESSAGE_NUM >='90193657'order by 1 ;
select * from rib_message_failure where MESSAGE_NUM>='90193657' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM >='90193657' group by FAMILY order by 1 desc;
select * from rib_message where FAMILY ='XTsf' and MESSAGE_NUM>='90193657' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM ='90194621';

select count(1) from item_loc_soh where item in (select item from iwtitemvalid) and loc = '1015';

select * from tran_data where item = '4856289';
select ITEM, LOC, STOCK_ON_HAND, IN_TRANSIT_QTY, NON_SELLABLE_QTY from item_loc_soh where loc  in ('1001','1015') and item in ('4856289');
select * from item_loc_soh where loc  in ('1001','1015') and item in ('4856289');
select * from rms.tsfdetail where tsf_no = '5130011738' ;
select item,sum(tsf_qty),sum(SHIP_QTY) from rms.tsfdetail where tsf_no = '5130011738' and item in ('4856289') group by item; -- 11998

select * from rms.tsfdetail where tsf_no = '5130011738' and item in ('4856289'); -- 11998
select * from rms.tsfdetail where tsf_no = '5130011738'; -- 11998
select sum(tsf_qty),sum(SHIP_QTY) from rms.tsfdetail where tsf_no = '5130011738'; -- 12996
select count(distinct(carton)) from rms.shipsku where distro_no = '5130011738';
select sum(QTY_EXPECTED) from rms.shipsku where distro_no = '5130011738'; --12996
select * from rms.shipsku where distro_no = '5130011738'; --12996
select count(1) from rms.shipment where shipment in (select shipment from rms.shipsku where distro_no = '5130011738');

select * from rms.tsfhead where tsf_no = '5130011738'; 
select count(1) from rms.tsfhead where tsf_no = '5130011738';
select count(1) from rms.tsfdetail where tsf_no = '5130011738';
select * from rms.tsfdetail where tsf_no = '5130011738' and TSF_QTY <> SHIP_QTY; -- 11998
select count(1) from rms.tsfdetail where tsf_no = '5130011738' and TSF_QTY <> SHIP_QTY;
select * from rms.tsfdetail where tsf_no = '5130011738' and TSF_QTY <> SHIP_QTY;
select count(distinct(carton)) from rms.shipsku where distro_no = '5130011738';
select sum(QTY_EXPECTED) from rms.shipsku where distro_no = '5130011738'; --12996
select * from rms.shipsku where distro_no = '5130011738'; --12996
select count(1) from rms.shipment where shipment in (select shipment from rms.shipsku where distro_no = '5130011738');

select * from tran_data where item = '133643110' order by TIMESTAMP desc;

select * from rib_message where MESSAGE_NUM >'90193656'order by 1 ;
select * from rib_message where IN_QUEUE != '0';
select * from rib_message where MESSAGE_NUM >'90193656'order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM>'90193656' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM >'90193656' group by FAMILY order by 1 desc;
select * from rib_message where FAMILY ='XTsf' and MESSAGE_NUM>'90193656' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM ='90193672';

select * from rib_message order by 1 desc;
select * from rms.NB_RTSA_LOG where trunc(ERROR_TIMESTAMP) >= '28-MAY-24';

select PROGRAM_NAME, LOG_MESSAGE, BUSINESS_ID, COMMENT_DESC, 
to_char(ERROR_TIMESTAMP,'DD-MON-RRRR HH24:MI:SS am') ERROR_TIMESTAMP,
to_char(ACTION_TIMESTAMP,'DD-MON-RRRR HH24:MI:SS am') ACTION_TIMESTAMP, MESSAGE_DATA
from rms.NB_RTSA_LOG 
--where trunc(ERROR_TIMESTAMP) >= '01-MAY-24' 
ORDER BY ACTION_TIMESTAMP desc;