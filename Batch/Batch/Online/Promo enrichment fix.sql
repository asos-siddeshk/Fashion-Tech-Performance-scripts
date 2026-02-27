select * from rpm_promo_cust;

select * from int_asos.int_v_promo_attrib where promo_id ='64183';

select * from all_views where lower(view_name) ='int_v_promo_attrib';

"SELECT P.PROMO_ID,
       DECODE(NVL(ATR.VARCHAR2_1,'N'),'N','N','Y') LOCAL_TIME_ACTIVE
FROM RPM_PROMO P,
     RPM_PROMO_CUST_ATTR ATR
WHERE P.CUST_ATTR_ID = ATR.CUST_ATTR_ID(+)";

select * from RPM_PROMO order by 1;
select * from RPM_PROMO where promo_id >='59945' order by 1; 
select * from RPM_PROMO_CUST_ATTR;

insert into RPM_PROMO_CUST_ATTR (CUST_ATTR_ID) values (select CUST_ATTR_ID from rpm_promo);


set SERVEROUTPUT ON;
set timing on;
DECLARE
BEGIN
  
for k in 1..5000 loop 

insert into RPM_PROMO (PROMO_ID, PROMO_DISPLAY_ID, NAME,CURRENCY_CODE, START_DATE, END_DATE, CUST_ATTR_PROMO_COMP_IND, CUST_ATTR_PROMO_DTL_IND)
    select PROMO_ID-k, PROMO_DISPLAY_ID-k, NAME,CURRENCY_CODE, START_DATE, END_DATE, CUST_ATTR_PROMO_COMP_IND, CUST_ATTR_PROMO_DTL_IND 
    from rpm_promo where promo_id ='64408';

end loop; 
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/