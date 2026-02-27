--Book Transfers: 


select 'ITL' as record_type, 'E' as action, 'Adjustment' as code, '+' as update_quantity_sign,'1' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'XX04021100' as reference_id,'RW' as reason_id,  'FC01' as site_id, 'Unlocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,1158535 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,lock_code, process_bo from skumar.inv_adj_data ORDER BY DBMS_RANDOM.RANDOM;

ALTER TABLE inv_adj_data ADD (lock_code varchar2(20), process_bo varchar2(2));
ALTER TABLE inv_adj_data ADD (sl_no number(5));
truncate table skumar.inv_adj_data;
insert into skumar.inv_adj_data select item,loc,null,null,null from rms.item_loc_soh where loc ='1001'and stock_on_Hand >'100' and rownum<= '3000';
Update skumar.inv_adj_data set sl_no = rownum;
Update skumar.inv_adj_data set LOCK_CODE = 'DMGD' where sl_no in (SELECT sl_no FROM  ( SELECT e.*, ROW_NUMBER() OVER(ORDER BY sl_no) rn FROM skumar.inv_adj_data e ) WHERE MOD(rn,2) <> 0); 
Update skumar.inv_adj_data set PROCESS_BO = 'Y' where LOCK_CODE is null; 
Update skumar.inv_adj_data set PROCESS_BO = 'N' where LOCK_CODE = 'DMGD'; 

select item,loc from inv_adj_data;

select * from item_loc_soh_pre;
select * from item_loc_soh_post;


select ITEM, ITEM_PARENT, LOC, AV_COST, UNIT_COST, STOCK_ON_HAND, SOH_UPDATE_DATETIME, IN_TRANSIT_QTY, PACK_COMP_INTRAN, PACK_COMP_SOH, TSF_RESERVED_QTY, PACK_COMP_RESV, TSF_EXPECTED_QTY, PACK_COMP_EXP, RTV_QTY, NON_SELLABLE_QTY, CUSTOMER_RESV, CUSTOMER_BACKORDER, PACK_COMP_CUST_RESV, PACK_COMP_CUST_BACK, LAST_UPDATE_DATETIME, FIRST_RECEIVED, LAST_RECEIVED, QTY_RECEIVED from item_loc_soh where item in (select item from skumar.inv_adj_data) and loc in ('1001','1002');


--drop table item_loc_soh_pre;
create table item_loc_soh_pre as
select ITEM, ITEM_PARENT, LOC, AV_COST, UNIT_COST, STOCK_ON_HAND, SOH_UPDATE_DATETIME, IN_TRANSIT_QTY, PACK_COMP_INTRAN, PACK_COMP_SOH, TSF_RESERVED_QTY, PACK_COMP_RESV, TSF_EXPECTED_QTY, PACK_COMP_EXP, RTV_QTY, NON_SELLABLE_QTY, CUSTOMER_RESV, CUSTOMER_BACKORDER, PACK_COMP_CUST_RESV, PACK_COMP_CUST_BACK, LAST_UPDATE_DATETIME, FIRST_RECEIVED, LAST_RECEIVED, QTY_RECEIVED from item_loc_soh where item in (select item from skumar.inv_adj_data) and loc in ('1001','1002');

create table item_loc_soh_post as
select ITEM, ITEM_PARENT, LOC, AV_COST, UNIT_COST, STOCK_ON_HAND, SOH_UPDATE_DATETIME, IN_TRANSIT_QTY, PACK_COMP_INTRAN, PACK_COMP_SOH, TSF_RESERVED_QTY, PACK_COMP_RESV, TSF_EXPECTED_QTY, PACK_COMP_EXP, RTV_QTY, NON_SELLABLE_QTY, CUSTOMER_RESV, CUSTOMER_BACKORDER, PACK_COMP_CUST_RESV, PACK_COMP_CUST_BACK, LAST_UPDATE_DATETIME, FIRST_RECEIVED, LAST_RECEIVED, QTY_RECEIVED from item_loc_soh where item in (select item from skumar.inv_adj_data) and loc in ('1001','1002');


create table item_loc_soh_post2 as
select ITEM, ITEM_PARENT, LOC, AV_COST, UNIT_COST, STOCK_ON_HAND, SOH_UPDATE_DATETIME, IN_TRANSIT_QTY, PACK_COMP_INTRAN, PACK_COMP_SOH, TSF_RESERVED_QTY, PACK_COMP_RESV, TSF_EXPECTED_QTY, PACK_COMP_EXP, RTV_QTY, NON_SELLABLE_QTY, CUSTOMER_RESV, CUSTOMER_BACKORDER, PACK_COMP_CUST_RESV, PACK_COMP_CUST_BACK, LAST_UPDATE_DATETIME, FIRST_RECEIVED, LAST_RECEIVED, QTY_RECEIVED from item_loc_soh where item in (select item from skumar.inv_adj_data) and loc in ('1001','1002');


select * from tsfhead where tsf_no > '8344902051' order by 1 desc; --8344902291

select count(distinct Item) from tsfdetail where tsf_no > '8344902051';
select ITEM, sum(TSF_QTY) from tsfdetail where tsf_no > '8344902051' group by item;
select count(1) from tsfdetail where tsf_no > '8344902051';

-- Duplicate 8344902051
select count(1) from tsfhead where tsf_no > '8344900451';
select * from tsfhead where tsf_no > '8344900451';

select * from tsfhead where tsf_no = '8344900915';
select * from tsfdetail where tsf_no = '8344900915';

select count(Item) from tsfdetail where tsf_no > '8344900451';

select count(distinct Item) from tsfdetail where tsf_no > '8344900451';
select tsf_no, count(1) from tsfdetail where tsf_no > '8344900451' group by tsf_no;
select * from shipsku where distro_no = '8344900491';


select * from rib_message where message_num > '90193673';
select * from rib_message_failure where message_num > '90193673';
select * from logger_logs where id > 682987633 and USER_NAME ! = 'MA_ASOS' order by id desc;

select item,count(1) from tran_data group by item;
select * from tran_data where item = '11381524';
select * from item_loc_soh where item = '11381524' and loc in ('1001','1002');


SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE 'TRAN%';
select * from logger_logs where id >= 682987513 and USER_NAME ! = 'MA_ASOS' order by id desc;

select * from logger_logs where id >= 682980513 and USER_NAME ! = 'MA_ASOS' order by id desc;


 
 
 
 
select * from inv_adj_data;
SELECT * FROM  ( SELECT e.*, ROW_NUMBER() OVER(ORDER BY sl_no) rn FROM inv_adj_data e ) WHERE MOD(rn,2) <> 1;


truncate table inv_adj_data;
insert into inv_adj_data select item,loc,null,null,null from rms.item_loc_soh where loc ='1001'and stock_on_Hand >'100' and rownum<= '40000';
 





select count(1)-0 from tran_data_b; --1608002
select count(1)-17763682 from tran_data_a; --17835733
select count(1)-17763682 from tran_data; --17835733
select count(1) from tran_data; --17835733


select TRAN_DATE, TRAN_CODE,location,count(1) from tran_data where trunc(TIMESTAMP) = trunc(sysdate) group by TRAN_DATE, TRAN_CODE,location; --17835733


select count(1)  from tran_data where trunc(TIMESTAMP) = trunc(sysdate) and location = '1011' ;


select 'ITL' as record_type, 'E' as action, 'Putaway' as code, '+' as update_quantity_sign,'2' as update_qty, 
    to_char (sysdate,'YYYYMMDDHHIISS') as dstamp,'ASOS' as client_id,item as sku_id,
    'IWTC1469126996734' as reference_id, 
    'ACODACOD' as reason_id, 
    'FC04' as site_id, 
    'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHIISS') as user_def_date_1,
    'Europe/London' as time_zone_name,
    812355 as config_id,to_char (sysdate,'YYYYMMDDHHIISS') as complete_dstamp,'AQL' as lock_code,
    'N' as process_bo 
    from rms.item_loc_soh where loc ='4001'and stock_on_Hand ='0' and rownum<= '100000';
    
    
    select TRAN_DATE,count(1) from tran_data group by TRAN_DATE;
    select TRAN_code,count(1) from tran_data_b group by TRAN_code;
    
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC03' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='3001'and stock_on_Hand ='0' and rownum<= '500000'

    select * from rib_message where message_num > 19767138 order by 1 desc;

  select * from inv_adj_data where loc ='1011';
  select * from inv_adj where trunc(CREATE_DATETIME) ='10-DEC-21' AND item in (select item from inv_adj_data where loc ='1011');

   select * from rms.tran_data where tran_code ='22';

 select * from rms.tran_data where item = '10000301';
 select * from rms.item_loc_soh where item = '10000301' AND loc ='1011';
 select * from inv_status_qty where item = '10000301';
 select * from INV_STATUS_CODES;  

 drop table inv_adj_data;
 create table inv_adj_data as select item,loc from rms.item_loc_soh where loc ='1001'and stock_on_Hand > '2' and rownum<= '700000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='1011'and stock_on_Hand >'2' and rownum<= '400000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='3001'and stock_on_Hand >'2' and rownum<= '200000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='3003'and stock_on_Hand >'2' and rownum<= '100000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='3004'and stock_on_Hand >'2' and rownum<= '100000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='4001'and stock_on_Hand >'2' and rownum<= '400000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='5001'and stock_on_Hand >'2' and rownum<= '100000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='5002'and stock_on_Hand >'2' and rownum<= '100000';
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='6001'and stock_on_Hand >'2' and rownum<= '100000'; --FC06
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='8001'and stock_on_Hand >'2' and rownum<= '100000'; --FC06
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='8002'and stock_on_Hand >'2' and rownum<= '100000'; --FC06
 insert into inv_adj_data select item,loc from rms.item_loc_soh where loc ='6002'and stock_on_Hand >'2' and rownum<= '100000'; --FC06

select * from WH;

select count(1) from inv_adj_data; --1608002
select count(1) from inv_adj_data; --1608002

select inv.loc,count(1),wh.WH_NAME_SECONDARY from inv_adj_data inv, wh where wh.wh = inv.loc group by inv.loc,wh.WH_NAME_SECONDARY;

select count(1) from inv_adj; --387227939
select count(1) from rms.nb_hist_inv_adj; --809 059 546


select * from all_tables where table_name like '%INV_A%'; 
delete from tran_data_a where trunc(TRAN_DATE) >= '21-FEB-2022';
delete from tran_data_b where trunc(TRAN_DATE) >= '21-FEB-2022';
--776M


select count(1) from tran_data where trunc(TRAN_DATE) >= '22-FEB-2022';
select LOCATION,count(1) from tran_data where trunc(TRAN_DATE)>='22-FEB-2022' group by LOCATION;



select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC01' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='1001'and stock_on_Hand ='0' and rownum<= '1000000';
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC03' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='3001'and stock_on_Hand ='0' and rownum<= '500000';
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC04' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHIISS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='4001'and stock_on_Hand ='0' and rownum<= '1000000';    
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'RC11' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='1011' and stock_on_Hand ='0' and rownum<= '500000';
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'FC06' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='6001' and stock_on_Hand ='0' and rownum<= '500000';


    select * from inv_adj where trunc(CREATE_DATETIME) = '08-DEC-21' AND item = '6210138';


    select * from inv_adj where trunc(ADJ_DATE) = '07-NOV-21';
    
    select * from item_loc_soh where item = '6210138';



select * from ALL_DB_LINKS;
select * from ribaq.ETINVADJUSTTABLE@to_rib;

DELETE from inv_aj_vol;
select * from inv_aj_vol;
create table inv_aj_vol (SYSSTAMP date,COUNT_MSG number(5));
insert into skumar.inv_aj_vol select systimestamp,count(1) from ribaq.ETINVADJUSTTABLE@to_rib;
select * from inv_aj_vol;

begin
for i in 0..6000 loop
 sys.dbms_lock.sleep(15);
 insert into skumar.inv_aj_vol 
 select systimestamp,count(1) from ribaq.ETINVADJUSTTABLE@to_rib;
commit;
end loop;
end;
/



select * from item_loc_soh where loc = '6001' and item = '110384226';
select * from tran_data where TRAN_DATE >='17-MAR-2023' and item = '110384226';


select * from tran_data where TRAN_DATE >='17-MAR-2023';
select * from tran_data where TRAN_DATE >='17-MAR-2023' and item = '130111034';
select count(1) from tran_data where TRAN_DATE >='17-MAR-2023';

select LOCATION,count(1) from tran_data where TRAN_DATE >='17-MAR-2023' group by LOCATION;
select LOCATION,count(1) from tran_data where TRAN_DATE >='17-MAR-2023' group by LOCATION;

select to_char(SYSSTAMP,'dd-mon-yy hh:mi:ss am') SYSSTAMP,COUNT_MSG from inv_aj_vol;


select inv.loc,count(1),wh.WH_NAME_SECONDARY from inv_adj_data inv, wh where wh.wh = inv.loc group by inv.loc,wh.WH_NAME_SECONDARY;
select to_char(SYSSTAMP,'dd-mon-yy hh:mi:ss am') SYSSTAMP,COUNT_MSG from inv_aj_vol;
select wh, WH_NAME, WH_NAME_SECONDARY, length(WH_NAME), length(WH_NAME_SECONDARY) from wh;


Regular
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC01' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='1001' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC03' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='3001' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'FC06' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='6001' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'ACODACOD' as reason_id, 'FC04' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHIISS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='4001' ;    
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'RC11' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='1011' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'P020' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='5001' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'P019' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='8001' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'P005' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='3003' ;

Wholesale
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'P005' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='3004' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'P020' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='5002' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'P019' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='8002' ;
select 'ITL' as record_type, 'E' as action, 'Inv UnLock' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHMMSS') as dstamp,'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id,'ACODACOD' as reason_id,  'FC06' as site_id, 'UnLocked'as lock_status,to_char (sysdate,'YYYYMMDDHHMMSS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHMMSS') as complete_dstamp,'AQL' as lock_code,'N' as process_bo from skumar.inv_adj_data where loc ='6002' ;

FC01	1001	700000
FC03	3001	200000
FC06	6001	100000
FC04	4001	400000
RC11	1011	43324
P020	5001	21399
P019	8001	21385
P005	3003	21385

P005	3004	21170
P020	5002	26511
P019	8002	26479
FC06	6002	26349




select distinct LOCATION,item from tran_data where TRAN_DATE >='17-MAR-2023' group by LOCATION,item;
select LOCATION,count(1) from tran_data where TRAN_DATE >='17-MAR-2023' group by LOCATION;

select to_char(SYSSTAMP,'dd-mon-yy hh:mi:ss am') SYSSTAMP,COUNT_MSG from inv_aj_vol order by 1 desc;
select inv.loc,count(1),wh.WH_NAME_SECONDARY from inv_adj_data inv, wh where wh.wh = inv.loc group by inv.loc,wh.WH_NAME_SECONDARY;


delete from tran_data_a;
delete from tran_data_b;
commit;

select LOCATION,count(1) from tran_data group by LOCATION;
DELETE from inv_aj_vol;
select * from inv_aj_vol;

select to_char(SYSSTAMP,'dd-mon-yy hh:mi:ss am') SYSSTAMP,COUNT_MSG from inv_aj_vol order by 1;
drop table item_loc_inv_adj;
create table item_loc_inv_adj as select distinct LOCATION,item from tran_data group by LOCATION,item;

select count(1) from item_loc_inv_adj;
select location,count(1) from item_loc_inv_adj group by location;



select to_char(SYSSTAMP,'dd-mon-yy hh:mi:ss am') SYSSTAMP,COUNT_MSG from inv_aj_vol order by 1;
drop table item_loc_inv_adj;
create table item_loc_inv_adj as select distinct LOCATION,item from tran_data where TRAN_DATE >='17-MAR-2023' group by LOCATION,item;

select count(1) from item_loc_inv_adj;
select location,count(1) from item_loc_inv_adj group by location;

select count(1)/2 from tran_data where TRAN_DATE >='17-MAR-2023';
select LOCATION,count(1) from tran_data where TRAN_DATE >='17-MAR-2023' group by LOCATION;

select to_char(SYSSTAMP,'dd-mon-yy hh:mi:ss am') SYSSTAMP,COUNT_MSG from inv_aj_vol order by 1;



delete from tran_data_a where TRAN_DATE >='17-MAR-2023';
delete from tran_data_b where TRAN_DATE >='17-MAR-2023';


select ITEM, LOC, STOCK_ON_HAND, IN_TRANSIT_QTY, TSF_RESERVED_QTY, TSF_EXPECTED_QTY, NON_SELLABLE_QTY from item_loc_soh where item in (select item from skumar.inv_adj_data) and loc in ('1001','1002') order by item,loc;

select item,count(1) from tran_data group by item;
select * from tran_data where item = '11380967';
select * from item_loc_soh where item = '11380967' and loc in ('1001','1002');
select * from tsfhead where tsf_no > '8344900451' order by 1 desc; --8344902291
select * from tsfdetail where tsf_no > '8344900451' and item = '11380967';
