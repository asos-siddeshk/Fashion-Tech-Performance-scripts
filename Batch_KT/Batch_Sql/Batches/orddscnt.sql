select count(1) from rms.deal_calc_queue;
select count(1) from rms.deal_calc_queue; -- 26941
delete from rms.deal_calc_queue where order_no in (select order_no from ordhead where supplier ='1100000086');
select count(1) from rms.deal_calc_queue; -- 26941


select SUPPLIER,count(SUPPLIER) from rms.ordhead where order_no in (select order_no from rms.deal_calc_queue) group by SUPPLIER;



select SUPPLIER,count(SUPPLIER) from rms.ordhead where  order_no in (select order_no from deal_calc_queue_bk) group by SUPPLIER order by 2 desc;

drop table deal_calc_queue_bk;
create table deal_calc_queue_bk as
select * from deal_calc_queue;
delete from deal_calc_queue;

select * from deal_calc_queue_bk;

insert into deal_calc_queue_bk
select * from deal_calc_queue where order_no in (select order_no from ordhead where supplier  in (1100000086));

delete from deal_calc_queue where order_no in (select order_no from ordhead where supplier in ()) and rownum <= '85000';

insert into deal_calc_queue 
select * from deal_calc_queue_bk where order_no in (select order_no from ordhead where supplier  in (1100000086)  and rownum <= '5000');


insert into deal_calc_queue 
select * from deal_calc_queue_bk where order_no in (select order_no from ordhead where supplier  in (1100000086,1100000767,1100001734,1100001186,1100000119,1100000952,1100000716,1100001071,1100001424,1100000234,1100000968));
delete from deal_calc_queue_bk where order_no in (select order_no from ordhead where supplier  in (1100001722,1100000767,1100001734,1100001186,1100000119,1100000952,1100000716,1100001071,1100001424,1100000234,1100000968));

insert into deal_calc_queue 
    select * from deal_calc_queue_bk where order_no in (select order_no from ordhead where supplier  in (1100000086) and rownum<='1231');

delete from deal_calc_queue_bk where order_no in (select order_no from deal_calc_queue);


create table oder_to_pro as
select SUPPLIER,count(1) as counts from rms.ordhead oh where status ='A' group by SUPPLIER;

select * from oder_to_pro;

select * from ordhead where supplier in (select supplier from oder_to_pro where counts between 1000 and 2500) and status ='A';

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.oder_to_pro TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.perf_rpm_fut_sp sp TO RDATLA; 


