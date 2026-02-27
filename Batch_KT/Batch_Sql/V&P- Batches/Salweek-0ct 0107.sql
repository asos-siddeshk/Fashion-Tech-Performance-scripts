

2049

exec system.killsession ('2852');
select * from all_tables where table_name like '%TRAN_DATA%';

select distinct tran_date,count(tran_date) from rms.tran_data group by tran_date order by 1; --315046


select * from all_tables whete table_name like '';
select distinct DATA_DATE from rms.daily_data;
select * from daily_data_temp;
select * from salweek_c_week where dept ='9999';
select distinct eow_date from week_data;

create table week_data_bk_30092018 as
select * from week_data;
select * from rms.daily_data where dept ='9999';
delete from rms.daily_data where dept ='9999';
delete  from salweek_c_week where dept ='9999';

salstage
--delete from tran_data_a;
select count(1) from rms.tran_data_a;
select count(1) from rms.tran_data_b;
select count(1) from rms.if_tran_data; 

select count(1) from if_tran_data where trunc(tran_date) ='07-OCT-18';

salapnd
select (select count(1) from rms.tran_data_history)-11966850 from dual; 
select count(1) from rms.tran_data_history; 

saldly:
--create table daily_data_bk_30092018 as select * from rms.daily_data;
select * from rms.daily_data;
select distinct data_date from rms.daily_data;
select * from DAILY_DATA_TEMP;
select * from DAILY_DATA_BACKPOST;

salweek

select EOW_DATE,count(1) from week_data group by EOW_DATE order by EOW_DATE desc; 

select * from SALWEEK_RESTART_DEPT where dept ='9999';
select * from SALWEEK_C_WEEK where dept ='9999';
select * from SALWEEK_C_DAILY where dept ='9999';
select * from week_data where EOW_DATE ='04-NOV-18';
select * from HALF_DATA_BUDGET where dept ='9999';

delete from daily_data where dept ='9999';
delete from week_data where dept ='9999';
delete from month_data where dept ='9999';


update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;
select * from period;


select * from RMS.DEAL_CALC_QUEUE;
select * from RMS.DEAL_QUEUE;
select * from deal_head;
select count(1) from rms.tran_data_a; 
select * from rms.period;
select distinct tran_date from rms.tran_data_a;
select distinct tran_date from rms.if_tran_data;
drop table if_tran_data_07Oct;
create table if_tran_data_14Oct as
select * from if_tran_data where trunc(tran_date) ='14-OCT-18';
truncate table if_tran_data;
insert into rms.if_tran_data select * from skumar.if_tran_data_07Oct;
commit;

insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '08-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_011018;
commit;
insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '09-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_021018;
commit;
insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '10-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_031018;
commit;
insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '11-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_041018;
commit;
insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '12-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_051018;
commit;
insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '13-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_061018;
commit;
insert into tran_data_a
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '14-OCT-2018', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC from TRAN_DATA_BK_071018;
commit;