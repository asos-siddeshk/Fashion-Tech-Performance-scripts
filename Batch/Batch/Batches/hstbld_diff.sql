--hstbld--
select * from rms.subclass_sales_hist where trunc(EOW_DATE) ='02-DEC-18' order by 1,2,3,4;
select * from rms.class_sales_hist where trunc(EOW_DATE) ='02-DEC-18' order by 1,2,3;
select * from rms.dept_sales_hist where trunc(EOW_DATE) ='02-DEC-18' order by 1,2;
--hstbld_diff W--
select * from rms.item_diff_loc_hist where EOW_DATE ='02-DEC-18';
select * from rms.item_parent_loc_hist where EOW_DATE ='02-DEC-18';

set SERVEROUTPUT ON;
set timing ON;
  DECLARE
        L_return_code   varchar2(5)   := null;
        L_error_message varchar2(255) := null;
        L_vdate         date          := null;
        L_mode          varchar2(1)   := 'W';
      BEGIN

         L_vdate := TO_DATE('20181202', 'YYYYMMDD');

         if not HSTBLD_DIFF_PROCESS.DIFF_PROCESS(L_return_code,
                                                 L_error_message,
                                                 L_vdate,
                                                 L_mode) THEN
           dbms_output.put_line('Error'||L_error_message);
         end if;
   dbms_output.put_line('Success '||L_error_message);
   commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

--hstbldmnth
select EOM_DATE,count(1) from item_loc_hist_mth group by EOM_DATE; 
select  * from item_loc_hist_mth;
set serveroutput on;
set timing on;
declare 
L_date date;
begin
for k in 0..15 loop
      insert into item_loc_hist_mth
        select ITEM, '02-DEC-18', '02-DEC-18', LAST_UPDATE_ID, LOC, LOC_TYPE, '02-DEC-18', MONTH_454, YEAR_454,'R', SALES_ISSUES, VALUE, GP, STOCK, RETAIL, AV_COST
        from item_loc_hist_mth where loc_type ='S' and rownum<='50000' and trunc(EOM_DATE) ='28-OCT-18'
         and (ITEM, LOC) not in (select item,loc from item_loc_hist_mth where trunc(EOM_DATE) ='02-DEC-18');
 commit;
end loop;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

select * from item_loc_hist_mth where trunc(EOM_DATE) ='02-DEC-18';

select * from rms.subclass_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.class_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.dept_sales_hist_mth where trunc(EOM_DATE) ='02-DEC-18';
--hstbld_diff M--
select * from rms.item_diff_loc_hist_mth  where trunc(EOM_DATE) ='02-DEC-18';
select * from rms.item_parentloc_hist_mth  where trunc(EOM_DATE) ='02-DEC-18';


 -- MOnth --- 

set SERVEROUTPUT ON;
set timing ON;
  DECLARE
        L_return_code   varchar2(5)   := null;
        L_error_message varchar2(255) := null;
        L_vdate         date          := null;
        L_mode          varchar2(1)   := 'M';
      BEGIN

         L_vdate := TO_DATE('20181202', 'YYYYMMDD');

         if not HSTBLD_DIFF_PROCESS.DIFF_PROCESS(L_return_code,
                                                 L_error_message,
                                                 L_vdate,
                                                 L_mode) THEN
           dbms_output.put_line('Error'||L_error_message);
         end if;
   dbms_output.put_line('Success '||L_error_message);
   commit;
   
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

