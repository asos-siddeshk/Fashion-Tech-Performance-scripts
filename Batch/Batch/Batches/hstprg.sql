select EOW_DATE,count(1) from rms.subclass_sales_hist group by EOW_DATE order by 1; --17 JUn
select EOW_DATE,count(1) from rms.class_sales_hist group by EOW_DATE order by 1; --JUn
select EOW_DATE,count(1) from rms.dept_sales_hist group by EOW_DATE order by 1; --17
select DATA_DATE,count(1) from rms.DAILY_SALES_DISCOUNT group by DATA_DATE order by 1; --06-MAY-16	06-JUN-18
select EOW_DATE,count(1) from rms.item_diff_loc_hist group by EOW_DATE order by 1; --02-NOV-16	1232001
select EOW_DATE,count(1) from rms.item_parent_loc_hist group by EOW_DATE order by 1; --02-NOV-16	182729
select EOW_DATE,count(1) from rms.item_loc_hist group by EOW_DATE order by 1; 


select EOM_DATE,count(1) from rms.subclass_sales_hist_mth group by EOM_DATE order by 1; 
select EOM_DATE,count(1) from rms.class_sales_hist_mth group by EOM_DATE order by 1; 
select EOM_DATE,count(1) from rms.dept_sales_hist_mth group by EOM_DATE order by 1;
select EOM_DATE,count(1) from rms.item_diff_loc_hist_mth group by EOM_DATE order by 1; 
select EOM_DATE,count(1) from rms.item_parentloc_hist_mth group by EOM_DATE order by 1; 
select EOM_DATE,count(1) from rms.item_loc_hist_mth group by EOM_DATE order by 1; 





select * from DAILY_SALES_DISCOUNT;




insert into DAILY_SALES_DISCOUNT
select ITEM, STORE, PROM_TYPE,DATA_DATE, TRAN_TYPE, SALES_QTY, SALES_RETAIL, DISCOUNT_AMT, EXPECTED_RETAIL, ACTUAL_RETAIL, PROMOTION, GROSS_PROFIT_AMT, PROM_COMPONENT
from DAILY_SALES_DISCOUNT 
where trunc(DATA_DATE)='31-OCT-18' and
item not in (SELECT ITEM FROM rms.DAILY_SALES_DISCOUNT  ilh1 WHERE  ilh1.DATA_DATE='16-DEC-18');


insert into rms.item_Loc_hist ilh1   
select ilh2.ITEM, ilh2.LOC,ilh2.LOC_TYPE,'16-DEC-18' AS EOW_DATE,1, 12, 2018, ilh2.SALES_TYPE, ilh2.SALES_ISSUES,ilh2.VALUE, ilh2.GP, ilh2.STOCK, ilh2.RETAIL, ilh2.AV_COST, ilh2.CREATE_DATETIME, ilh2.LAST_UPDATE_DATETIME, ilh2.LAST_UPDATE_ID, ilh2.DEPT, ilh2.CLASS, ilh2.SUBCLASS
from rms.item_loc_hist ilh2 WHERE ilh2.eow_date='17-JUN-18' AND 
ilh2.ITEM NOT IN (SELECT ITEM FROM rms.item_loc_hist  ilh1 WHERE  ilh1.eow_date='16-DEC-18') and rownum <='500000'; 
commit;

select EOW_DATE,count(1) from item_diff_loc_hist group by EOW_DATE order by 1;
select EOW_DATE,count(1) from item_parent_loc_hist group by EOW_DATE order by 1;
select EOW_DATE,count(1) from item_loc_hist group by EOW_DATE order by 1;

select EOM_DATE,count(1) from subclass_sales_hist_mth group by EOM_DATE order by 1; 
select EOM_DATE,count(1) from class_sales_hist_mth group by EOM_DATE order by 1; 
select EOM_DATE,count(1) from dept_sales_hist_mth group by EOM_DATE order by 1;
select EOM_DATE,count(1) from item_diff_loc_hist_mth group by EOM_DATE order by 1;
select EOM_DATE,count(1) from item_parentloc_hist_mth group by EOM_DATE order by 1;
select EOM_DATE,count(1) from item_loc_hist_mth group by EOM_DATE order by 1;


select * from item_Loc_hist;

insert into rms.item_Loc_hist ilh1   
select ilh2.ITEM, ilh2.LOC,ilh2.LOC_TYPE,'16-DEC-18' AS EOW_DATE,1, 12, 2018, ilh2.SALES_TYPE, ilh2.SALES_ISSUES,ilh2.VALUE, ilh2.GP, ilh2.STOCK, ilh2.RETAIL, ilh2.AV_COST, ilh2.CREATE_DATETIME, ilh2.LAST_UPDATE_DATETIME, ilh2.LAST_UPDATE_ID, ilh2.DEPT, ilh2.CLASS, ilh2.SUBCLASS
from rms.item_loc_hist ilh2 WHERE ilh2.eow_date='17-JUN-18' AND 
ilh2.ITEM NOT IN (SELECT ITEM FROM rms.item_loc_hist  ilh1 WHERE  ilh1.eow_date='16-DEC-18') and rownum <='500000'; 
commit;

select EOW_DATE,count(1) from item_loc_hist group by EOW_DATE order by 1;

set serveroutput on;
set timing on;
declare
c_commit number(10):= '0';

l_EOW_DATE                rms.item_loc_hist.EOW_DATE%type;

cursor c_template is    
    select EOW_DATE from item_loc_hist_eow where eow_date in ( '03-JUN-18','01-JUL-18','08-JUL-18','15-JUL-18',
    '22-JUL-18','29-JUL-18','05-AUG-18','12-AUG-18','19-AUG-18','26-AUG-18','02-SEP-18','09-SEP-18','16-SEP-18',
    '23-SEP-18','30-SEP-18','07-OCT-18','14-OCT-18','10-JUN-18');
             
begin

for i in c_template loop
		l_EOW_DATE                    :=i.EOW_DATE;

insert into rms.item_Loc_hist ilh1   
 select ilh2.ITEM, ilh2.LOC,ilh2.LOC_TYPE,l_EOW_DATE AS EOW_DATE,ilh2.WEEK_454, ilh2.MONTH_454, ilh2.YEAR_454, ilh2.SALES_TYPE, ilh2.SALES_ISSUES,ilh2.VALUE, ilh2.GP, ilh2.STOCK, ilh2.RETAIL, ilh2.AV_COST, ilh2.CREATE_DATETIME, ilh2.LAST_UPDATE_DATETIME, ilh2.LAST_UPDATE_ID, ilh2.DEPT, ilh2.CLASS, ilh2.SUBCLASS
from rms.item_loc_hist ilh2 WHERE ilh2.eow_date='28-OCT-18' AND 
    ilh2.ITEM NOT IN (SELECT ITEM FROM rms.item_loc_hist  ilh1 WHERE  ilh1.eow_date=l_EOW_DATE) and rownum <='500000'; 

c_commit :=c_commit + 1;
       IF MOD(c_commit, 3) = 0 THEN
        COMMIT;
       END IF;
end loop;
COMMIT;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/




drop table sales_eow;
create table sales_eow as
  select today as DATA_DATE,
        next_day(today,'SUN') as EOW_DATE 
    from (select date '2018-06-11'+level today from dual connect by level<=229);  

select distinct EOW_DATE from sales_eow;



select EOW_DATE,count(1) from subclass_sales_hist group by EOW_DATE order by 1;
select EOW_DATE,count(1) from class_sales_hist group by EOW_DATE order by 1;
select EOW_DATE,count(1) from dept_sales_hist group by EOW_DATE order by 1;
select EOW_DATE,count(1) from item_diff_loc_hist group by EOW_DATE order by 1;
select EOW_DATE,count(1) from item_parent_loc_hist group by EOW_DATE order by 1;


set SERVEROUTPUT ON;
set timing ON;
declare
c_commit number(10):= '0';
l_DATA_DATE                rms.daily_data.DATA_DATE%type;
l_EOW_DATE                rms.daily_data.EOW_DATE%type;

cursor c_template is    
   --select distinct EOW_DATE from sales_eow where EOW_DATE!='02-DEC-18' order by 1;   
    select '16-DEC-18' as EOW_DATE from dual;
begin
for i in c_template loop
		l_EOW_DATE                    :=i.EOW_DATE;

insert into subclass_sales_hist
    select DEPT, CLASS, SUBCLASS, STORE, l_EOW_DATE, WEEK_454, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from subclass_sales_hist where EOW_DATE ='02-DEC-18';

insert into class_sales_hist
  select  DEPT, CLASS, STORE, l_EOW_DATE, WEEK_454, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from class_sales_hist where EOW_DATE ='02-DEC-18';

insert into dept_sales_hist
  select DEPT, STORE, l_EOW_DATE, WEEK_454, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from dept_sales_hist where EOW_DATE ='02-DEC-18';
    
insert into item_diff_loc_hist
  select ITEM, DIFF_ID, LOCATION, LOC_TYPE, l_EOW_DATE, SALES_TYPE, WEEK_454, MONTH_454, YEAR_454, SALES, VALUE, GP, STOCK, RETAIL, AV_COST
    from item_diff_loc_hist where  EOW_DATE ='02-DEC-18';

insert into item_parent_loc_hist
   select ITEM, LOCATION, LOC_TYPE, l_EOW_DATE, SALES_TYPE, WEEK_454, MONTH_454, YEAR_454, SALES, VALUE, GP, STOCK, RETAIL, AV_COST 
    from rms.item_parent_loc_hist where EOW_DATE ='02-DEC-18'; 
    
    
end loop;
    commit;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/

select EOM_DATE,count(1) from subclass_sales_hist_mth group by EOM_DATE; 
select EOM_DATE,count(1) from class_sales_hist_mth group by EOM_DATE; 
select EOM_DATE,count(1) from dept_sales_hist_mth group by EOM_DATE; 
select EOM_DATE,count(1) from item_diff_loc_hist_mth group by EOM_DATE; 
select EOM_DATE,count(1) from item_parentloc_hist_mth group by EOM_DATE; 
select EOM_DATE,count(1) from item_loc_hist_mth group by EOM_DATE; 

select * from rms.subclass_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.class_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.dept_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.item_diff_loc_hist_mth  where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.item_parentloc_hist_mth  where trunc(EOM_DATE) ='02-DEC-18';
select * from item_loc_hist_mth where trunc(EOM_DATE) ='02-DEC-18';



select EOM_DATE,count(1) from subclass_sales_hist_mth group by EOM_DATE order by 1 ;  
select EOM_DATE,count(1) from class_sales_hist_mth group by EOM_DATE order by 1 ; 
select EOM_DATE,count(1) from dept_sales_hist_mth group by EOM_DATE order by 1 ;  


select * from rms.subclass_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.class_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.dept_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';

set SERVEROUTPUT ON;
set timing ON;
declare
c_commit number(10):= '0';
l_EOW_DATE                rms.daily_data.EOW_DATE%type;

cursor c_template is    
    select distinct EOW_DATE from sales_eow where eow_date!='02-DEC-18';

begin
for i in c_template loop
		l_EOW_DATE                    :=i.EOW_DATE;

insert into subclass_sales_hist_mth
  select DEPT, CLASS, SUBCLASS, STORE, l_EOW_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from rms.subclass_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
insert into class_sales_hist_mth
select DEPT, CLASS, STORE, l_EOW_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from rms.class_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
insert into dept_sales_hist_mth
select DEPT, STORE, l_EOW_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP
from rms.dept_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';

end loop;
commit;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/


insert into dept_sales_hist_mth
select DEPT, 10001, EOM_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP
    from dept_sales_hist_mth where STORE ='10004';
insert into dept_sales_hist_mth
select DEPT, 10003, EOM_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP
    from dept_sales_hist_mth where STORE ='10004';

insert into class_sales_hist_mth
select DEPT, CLASS, 10001, EOM_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from rms.class_sales_hist_mth where STORE ='10004';
insert into class_sales_hist_mth
select DEPT, CLASS, 10003, EOM_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from rms.class_sales_hist_mth where STORE ='10004';
    
insert into subclass_sales_hist_mth
select DEPT, CLASS, SUBCLASS, 10001, EOM_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from rms.subclass_sales_hist_mth where STORE ='10004';
insert into subclass_sales_hist_mth
select DEPT, CLASS, SUBCLASS, 10003, EOM_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES, VALUE, GP, PLAN_SALES
    from rms.subclass_sales_hist_mth where STORE ='10004';
    
    
    
select EOM_DATE,count(1) from item_diff_loc_hist_mth group by EOM_DATE order by 1 ; 
select EOM_DATE,count(1) from item_parentloc_hist_mth group by EOM_DATE order by 1 ; 
select EOM_DATE,count(1) from item_loc_hist_mth group by EOM_DATE order by 1 ; 


set SERVEROUTPUT ON;
set timing ON;
declare
c_commit number(10):= '0';
l_EOW_DATE                rms.daily_data.EOW_DATE%type;

cursor c_template is    
    select distinct EOW_DATE from sales_eow where eow_date in ('08-JUL-18','05-AUG-18','02-SEP-18','30-SEP-18');

begin
for i in c_template loop
		l_EOW_DATE                    :=i.EOW_DATE;

    insert into item_loc_hist_mth
    select ITEM, l_EOW_DATE, l_EOW_DATE, LAST_UPDATE_ID, LOC, LOC_TYPE, l_EOW_DATE, MONTH_454, YEAR_454, SALES_TYPE, SALES_ISSUES, VALUE, GP, STOCK, RETAIL, AV_COST
    from rms.item_loc_hist_mth where trunc(EOM_DATE) ='02-DEC-18' and loc in (select store from store);  

    insert into item_parentloc_hist_mth
    select ITEM, LOCATION, LOC_TYPE, l_EOW_DATE, SALES_TYPE, MONTH_454, YEAR_454, SALES, VALUE, GP, STOCK, RETAIL, AV_COST
    from rms.item_parentloc_hist_mth where trunc(EOM_DATE) ='02-DEC-18' and location in (select store from store);  
    
    insert into item_diff_loc_hist_mth
    select ITEM, DIFF_ID, LOCATION, LOC_TYPE, l_EOW_DATE, SALES_TYPE, MONTH_454, YEAR_454, SALES, VALUE, GP, STOCK, RETAIL, AV_COST
    from rms.item_diff_loc_hist_mth where trunc(EOM_DATE) ='02-DEC-18' and location in (select store from store);  
    
end loop;
commit;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/
