exec system.killsession ('2859');
select distinct tran_date,count(tran_date) from rms.tran_data group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data_a group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data_b group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.if_tran_data group by tran_date order by 1; --315046
commit;
select distinct tran_code,count(tran_code) from rms.tran_data where trunc(tran_date)='02-DEC-18' group by tran_code order by 1;
select distinct location,count(location) from rms.tran_data_a where trunc(tran_date)='02-DEC-18' group by location order by 1;
select distinct location,count(location) from rms.tran_data_b where trunc(tran_date)='02-DEC-18' group by location order by 1;
select * from rms.tran_data_a where trunc(tran_date)='22-JAN-19';
select * from rms.if_tran_data;
select doc_type,count(1) from rms.DOC_CLOSE_QUEUE group by doc_type;
delete from rms.tran_data_a where dept='9999';
delete from rms.daily_data where dept ='9999';
commit;

select count(1) from rms.tran_data_a where dept='9999' or class='9999' or subclass='9999';
select distinct tran_code,count(1) from rms.tran_data_b where dept='9999' or class='9999' or subclass='9999' group by tran_code;
select distinct location from rms.tran_data_b where trunc(tran_date)='02-DEC-18';

update rms.tran_data_a set TRAN_DATE = '30-DEC-18' where trunc(tran_date)<'30-DEC-18';
update rms.tran_data_b set TRAN_DATE = '20-JAN-19' where trunc(tran_date)!='20-JAN-19';
commit;
/*insert into rms.tran_data_b select *  from rms.tran_data_a; 
commit;
select * from rms.tran_data_b where trunc(tran_date)!='02-DEC-18'; */

cd /home/siddeshk
cp *.sql /home/oracle/custom/Day_scripts
cd /home/oracle/custom/Day_scripts

select * from rms.tsfhead where trunc(CREATE_DATE) like '02-DEC-18';
select distinct ENTITY_TYPE,count(ENTITY_TYPE) from SKUMAR.VPT_LOGS group by ENTITY_TYPE;
select distinct ENTITY,count(ENTITY) from SKUMAR.VPT_LOGS group by ENTITY;
select distinct ENTITY,count(ENTITY) from SKUMAR.VPT_LOGS where status ='E' group by ENTITY;
select * from SKUMAR.VPT_LOGS where ENTITY ='PO_SHIPMENT' and status ='E';
select * from SKUMAR.VPT_LOGS where ENTITY ='PO_RECEIPTS' and status ='E' ;
select * from SKUMAR.VPT_LOGS where ENTITY ='ALLOC_RECEIPTS' and status ='E' ;
select * from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_RECEIPTS';
select * from SKUMAR.VPT_LOGS where ENTITY ='INVADJ_UNAVAIL';
select * from SKUMAR.VPT_LOGS where ENTITY ='INVADJ_AVAIL';

select * from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_SHIPMENT' and STATUS='E';

--to- reprocess
select distinct ENTITY_ID from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_SHIPMENT' and STATUS='E' and error like '%ITEM_LOC_SOH%';
select * from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_SHIPMENT';
select * from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_SHIPMENT' and STATUS='S';
select * from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_SHIPMENT' and STATUS='E';
--to- reprocess
select distinct ENTITY_ID from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_RECEIPTS' and STATUS='E';



select distinct ENTITY_FROM_LOC, count(ENTITY_FROM_LOC) from SKUMAR.VPT_LOGS where ENTITY ='INVADJ_AVAIL' group by ENTITY_FROM_LOC;





/* Transfers failed and re-process

drop table transfer_update_A;
create table transfer_update_A as
select tsf_no,from_loc_type,to_loc_type,from_loc,to_loc from (
SELECT     distinct th.tsf_no,
        th.from_loc_type,
        th.to_loc_type,
        th.from_loc,
        th.to_loc
FROM      rms.tsfhead th
WHERE     th.status !    = 'A' and th.to_loc_type ='W'
and 	not exists (select 1 from rms.shipment sh where sh.bol_no=th.tsf_no) 
and 	not exists (select 1 from SKUMAR.VPT_LOGS where ENTITY ='TRANSFER_SHIPMENT' and ENTITY_ID =th.tsf_no) order by 1);

select * from tsfhead where tsf_no in (select tsf_no from transfer_update_A) and status ='I';
UPdate tsfhead set status ='A' where tsf_no in (select tsf_no from transfer_update_A) and status ='I';
*/
217

exec system.killsession ('217');

select count(1) from rms.deal_calc_queue; -- 7758
select SUPPLIER,count(SUPPLIER) from rms.ordhead where order_no in (select order_no from rms.deal_calc_queue) group by SUPPLIER;
select distinct tran_code,count(tran_code) from rms.tran_data where trunc(tran_date)='02-DEC-18' and tran_code ='20' group by tran_code order by 1;


select * from rms.logger_logs where rownum<= '30' order by 1 desc;


select * from rms.item_loc_hist;


select * from rpm_location_move;

select count(1) from TRAN_DATA_DEC02;
select distinct tran_code,count(tran_code) from TRAN_DATA_a group by tran_code order by 1;
select distinct tran_code,count(tran_code) from TRAN_DATA_DEC02 group by tran_code order by 1;
select * from all_tables where table_name like 'TRAN_DATA%';


begin 
insert into tran_data_a
select * from TRAN_DATA_DEC02 td where td.tran_code in (25,29,30,32,37,38,44,70,87);
    commit;
    
end;
/