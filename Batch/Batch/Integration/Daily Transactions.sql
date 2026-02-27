drop table order_reprocess;

create table order_reprocess as
select * from ordhead oh where status!='C' 
    and oh.order_no in (select orderno from daily_poreceipt)
    and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no) and rownum <= '13000';

select * from daily_poreceipt;
delete from daily_poreceipt where orderno not in (select order_no from ordhead);


select * from ordhead 

desc ordhead;
create table daily_poreceipt( OrderNo NUMBER(12),	Status VARCHAR2(1)); 

select * from order_reprocess;

drop table shipment_del;
create table shipment_del as
select shipment FROM shipment where order_no in (select order_no from order_reprocess);


select * from all_constraints where constraint_name like 'SSKL_SHS_FK';


select * from SHIPSKU_LOC;




