select * from all_tables where OWNER like 'SKUMAR';
select * from IF_TRAN_DATA_BK_RETEN;

select * from TRAN_DATA_a;
select * from TRAN_DATA_b;

select count(1) from TRAN_DATA; --5306958


select * from PERIOD; --09-MAY-21

select distinct tran_date,count(1) from IF_TRAN_DATA_BK_RETEN where tran_date!='08-MAY-21' group by tran_date order by 1; --8058150
select distinct tran_code,count(1) from IF_TRAN_DATA_BK_RETEN where tran_date!='08-MAY-21' group by tran_code order by 1; --8058150

select distinct tran_date,count(1) from IF_TRAN_DATA_BK_RETEN group by tran_date order by 1; --8058150
select distinct tran_code,count(1) from IF_TRAN_DATA_BK_RETEN group by tran_code order by 1; --315046


select distinct tran_date,count(1) from TRAN_DATA_b group by tran_date order by 1; --8058150
select distinct tran_code,count(1) from TRAN_DATA_b group by tran_code order by 1; --8058150

select distinct tran_date,count(1) from TRAN_DATA group by tran_date order by 1; --8058150
select distinct tran_code,count(1) from TRAN_DATA group by tran_code order by 1; --315046

--create table tran_data_bk as  select * from tran_data_b;

insert into tran_data_a (ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, TRAN_DATE, TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC, POS_TRAN_ID, SALES_PROCESS_ID)
SELECT 
ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION,'08-MAY-21',TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TRAN_DATA_TIMESTAMP as TIMESTAMP, REF_PACK_NO, null as TOTAL_COST_EXCL_ELC,null,null  FROM IF_TRAN_DATA_BK_RETEN
where TRAN_DATE!='08-MAY-21' and tran_code in ('30','31','32','33','37','38');

insert into tran_data_a (ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, TRAN_DATE, TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC, POS_TRAN_ID, SALES_PROCESS_ID)
SELECT 
ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION,'08-MAY-21',TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TRAN_DATA_TIMESTAMP as TIMESTAMP, REF_PACK_NO, null as TOTAL_COST_EXCL_ELC,null,null  FROM IF_TRAN_DATA_BK_RETEN
where TRAN_DATE!='08-MAY-21' and tran_code in ('22','25','20');

insert into tran_data_b (ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, TRAN_DATE, TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC, POS_TRAN_ID, SALES_PROCESS_ID)
SELECT 
ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION,'09-MAY-21',TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TRAN_DATA_TIMESTAMP as TIMESTAMP, REF_PACK_NO, null as TOTAL_COST_EXCL_ELC,null,null  FROM IF_TRAN_DATA_BK_RETEN
where TRAN_DATE='08-MAY-21' and tran_code in ('20','87');


select * from tran_data_codes;


set serveroutput on;
set timing on;
DECLARE
l_inv_date date;

BEGIN
select vdate into l_inv_date from period;

insert into rms.inv_adj
    select  ITEM,INV_STATUS,LOC_TYPE,LOCATION,ADJ_QTY ,REASON,l_inv_date,PREV_QTY,USER_ID ,ADJ_WEIGHT ,ADJ_WEIGHT_UOM,CREATE_ID ,l_inv_date 
        from rms.inv_adj inv1 where trunc(adj_date) = '08-MAY-21';

insert into rms.inv_status_qty
    select  ITEM, INV_STATUS, LOC_TYPE, LOCATION, QTY, l_inv_date, l_inv_date, LAST_UPDATE_ID 
        from rms.inv_status_qty inv1 where trunc(CREATE_DATETIME) = '08-MAY-21';
commit;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


commit;

create table del_tsf as 
select distinct ref_no_1 from tran_data_b where tran_code  in ('30','32','37','38');


drop table del_tsf1; 
create table del_tsf1 as 
select * from del_tsf where rownum <= '50000';
select * from del_tsf1;

begin
delete from tran_data_b where ref_no_1 in (select ref_no_1 from del_tsf1);
delete from del_tsf where ref_no_1 in (select ref_no_1 from del_tsf1);
commit;
end;
/




Update rms.tran_data_b set TRAN_DATE ='01-MAR-20'  where TRAN_DATE!='01-MAR-20';
Update rms.tran_data_a set TRAN_DATE ='01-MAR-20' where TRAN_DATE!='01-MAR-20';


select * from rms.period;
select distinct tran_date,count(1) from rms.tran_data_b group by tran_date order by 1; --8058150
select distinct tran_code,count(1) from rms.tran_data_a group by tran_code order by 1; --315046

drop table tran_data_bk ;

create table tran_data_bk as   select * from rms.tran_data_b; 

delete from rms.tran_data_b where tran_code in ('34','36');

select * from tran_data_bk;

update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;

select * from rms.restart_bookmark;
select * from rms.restart_program_status;


select * from rms.tran_data where dept ='9999';

/home/oracle/custom/inv_adj

cd /home/siddeshk
date
cp INV_ADJ_AVAIL.sql /home/oracle/custom/Nov11_1month
cp INV_ADJ_UNAVAIL_1.sql /home/oracle/custom/Nov11_1month
cp INV_ADJ_UNAVAIL_2.sql /home/oracle/custom/Nov11_1month
cp INV_ADJ_UNAVAIL_3.sql /home/oracle/custom/Nov11_1month
cp INV_ADJ_UNAVAIL_4.sql /home/oracle/custom/Nov11_1month
cp INV_ADJ_UNAVAIL_5.sql /home/oracle/custom/Nov11_1month
date
cd /home/oracle/custom/Nov11_1month

cd /home/siddeshk
date
cp TSF_SHIPMENT.sql /home/oracle/custom/Nov11_1month
date
cd /home/oracle/custom/Nov11_1month


cd /home/siddeshk
date
cp Sales_10004.sql /home/oracle/custom/Nov11_1month
cp Sales_10003.sql /home/oracle/custom/Nov11_1month
cp Sales_10001.sql /home/oracle/custom/Nov11_1month
date
cd /home/oracle/custom/Nov11_1month





truncate table SKUMAR.VPT_LOGS;

drop table tran_data_bk ;

create table tran_data_bk as  
select * from rms.tran_data_b; 
select * from  tran_data_b;

--salstage
select distinct TRAN_DATE from rms.tran_data_A;
select * from rms.tran_data_b;
select count(1) from rms.if_tran_data;
select * from rms.if_tran_data;
--salpand
select count(1) from rms.tran_data_history;
--saldly
select * from rms.daily_data;
select * from rms.week_data;
select DATA_DATE,count(1) from rms.daily_data group by DATA_DATE order by 1;
select EOW_DATE,count(1) from rms.week_data group by EOW_DATE;
select * from rms.week_data where EOW_DATE ='21-OCT-18' ;
select * from rms.week_data where EOW_DATE ='14-OCT-18' ;


delete from rms.daily_data where dept ='9999';



--salweek
select * from rms.week_data;
--salmnth
select * from rms.month_data;

select count(1) from rms.tran_data where trunc(tran_date)='30-SEP-18'; -- 5500000, 3000000
select count(1) from rms.tran_data_b where trunc(tran_date)!='30-SEP-18'; -- 5659678 -8178593
select count(1) from rms.tran_data_a where trunc(tran_date)!='30-SEP-18'; -- 5659678 -8178593

drop table tran_data_bk;
select distinct location,count(location) from skumar.tran_data_bk where trunc(tran_date)='30-SEP-18' and tran_code ='1';

create table tran_data_a;
select * from tran_data_a;
delete from rms.tran_data_a where dept ='9999';
delete from rms.tran_data_b where trunc(tran_date)>='01-OCT-18';

select count (1) from rms.tran_data_a;
select count (1) from rms.tran_data_b; --10010966

select distinct tran_code,count(tran_code) from rms.tran_data group by tran_code order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data group by tran_date order by 1; --315046
select distinct tran_code,count(tran_code) from rms.tran_data where trunc(tran_date)='29-FEB-20' group by tran_code order by 1;

select distinct tran_date,count(tran_date) from rms.tran_data where tran_code ='25' group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data where tran_code ='22' group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data where tran_code ='1' group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data where tran_code in ('30','32','37','38') group by tran_date order by 1; --315046
select distinct tran_date,count(tran_date) from rms.tran_data where tran_code in ('20') group by tran_date order by 1; --315046
select distinct location,count(location) from rms.tran_data where trunc(tran_date)>='16-OCT-18' group by location order by 1;
select distinct tran_code,count(tran_code) from rms.tran_data where trunc(tran_date)='16-OCT-18' group by tran_code order by 1;
select distinct tran_code,count(tran_code) from rms.tran_data where trunc(tran_date)!='14-OCT-18' group by tran_code order by 1;
select dept,class,subclass,location,count(location) from rms.tran_data group by dept,class,subclass,location order by dept,class,subclass,location;

select count (1) from rms.tran_data;
select count (1) from rms.tran_data_a;
select count (1) from rms.tran_data_b;

/*
insert into rms.tran_data_b select *  from rms.tran_data_a;
truncate table tran_data_a;
commit;
Update rms.tran_data_b set TRAN_DATE ='01-MAR-20'  where TRAN_DATE!='01-MAR-20';
Update rms.tran_data_a set TRAN_DATE ='01-MAR-20' where TRAN_DATE!='01-MAR-20';
*/
select * from period;

insert into tran_data_a
SELECT ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '08-OCT-18', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC  FROM tran_data_bk_011018;
insert into tran_data_a
SELECT ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '09-OCT-18', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC  FROM tran_data_bk_021018;
insert into tran_data_a
SELECT ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '10-OCT-18', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC  FROM tran_data_bk_031018;
insert into tran_data_a
SELECT ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '11-OCT-18', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC  FROM tran_data_bk_041018;
insert into tran_data_a
SELECT ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '12-OCT-18', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC  FROM tran_data_bk_051018;
insert into tran_data_a
SELECT ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, '13-OCT-18', TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO, TOTAL_COST_EXCL_ELC  FROM tran_data_bk_061018; -13


SELECT count(1)  FROM tran_data_bk_071018; --14

select distinct DEPT, CLASS, SUBCLASS from rms.tran_data where dept ='9999' group by DEPT, CLASS, SUBCLASS order by 1,2,3;
select distinct DEPT, CLASS, SUBCLASS from tran_data where class ='9999' group by DEPT, CLASS, SUBCLASS order by 1,2,3;
select distinct DEPT, CLASS, SUBCLASS from tran_data where subclass ='9999' group by DEPT, CLASS, SUBCLASS order by 1,2,3;

select * from rms.subclass where (DEPT) in (select distinct DEPT from tran_data where subclass ='9999') order by 1,2,3;
select * from rms.subclass where dept ='1053';



Update tran_data_b set DEPT='1001', CLASS ='1', SUBCLASS ='1' where dept ='9999';
Update tran_data_b set CLASS ='1', SUBCLASS ='1' where class ='9999' and dept in (2052,2053,2054,2056,2101,2102,2103,2105,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1050,1051,1052,1054,1057,1060,1114,2001,2002,2003,2004,2005,2006,2007,2008,2010,2011,2012,2013,2014,2050);
Update tran_data_b set CLASS ='1', SUBCLASS ='1' where class ='9999' and dept in (1001,1003,1014);
Update tran_data_b set CLASS ='1', SUBCLASS ='1' where class ='9999' and dept in (2001,1053,1061,2113);
Update tran_data_b set CLASS ='3', SUBCLASS ='1' where class ='9999' and dept in (2051,2108);
Update tran_data_b set CLASS ='3', SUBCLASS ='1' where class ='9999' and dept in (2111);
Update tran_data_b set SUBCLASS ='1' where subclass ='9999' and dept in (1001,1002,1009,1052,1057,1061,2001,2002,2003,2004,2005,2007,2009,2010,2011,2013,2014,2016,2050,2101);
Update tran_data_b set SUBCLASS ='1' where subclass ='9999' and dept in (1007,1053,1060,1062,2006,2008,1051,1063,2053,2054,2051);
Update tran_data_b set SUBCLASS ='1' where subclass ='9999' and dept in (2102,2111,2113);
delete from rms.daily_data where dept ='9999';

