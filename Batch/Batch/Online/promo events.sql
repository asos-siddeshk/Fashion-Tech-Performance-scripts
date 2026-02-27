/*select * from rms.rpm_promo_event;

delete from rpm_promo_event where promo_event_id  >= '70';

select * from all_sequences where sequence_name like 'RPM_PROMO%';
select * from period;
RPM_PROMO_EVENT_DISPLAY_ID_SEQ
select rms.RPM_PROMO_EVENT_DISPLAY_ID_SEQ.nextval from dual;
select rms.RPM_PROMO_EVENT_SEQ.nextval from dual;
*/

set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
 l_START_DATE       rms.rpm_promo_event.START_DATE%type := '01-JAN-24';
 l_END_DATE         rms.rpm_promo_event.END_DATE%type   := '31-DEC-25';
  l_promo_ev        rms.rpm_promo_event.PROMO_EVENT_ID%type;
l_promo_ev_d        rms.rpm_promo_event.PROMO_EVENT_DISPLAY_ID%type;
   
 
BEGIN

for k in 0..0 loop        

    select rms.RPM_PROMO_EVENT_DISPLAY_ID_SEQ.nextval  into l_promo_ev_d from dual;
    select rms.RPM_PROMO_EVENT_SEQ.nextval into l_promo_ev from dual;

 Insert into rms.rpm_promo_event (PROMO_EVENT_ID,PROMO_EVENT_DISPLAY_ID,DESCRIPTION,THEME,START_DATE,END_DATE,LOCK_VERSION,CUST_ATTR_ID) 
      values (l_promo_ev,l_promo_ev_d,'Promotion_PT_'||l_promo_ev_d,'PERFORMANCE',l_START_DATE,l_END_DATE,null,null);

end loop;
 
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/


select * from RPM_PROMO_EVENT;


select PROMO_EVENT_ID,count(1) from rpm_promo group by PROMO_EVENT_ID order by 1;

select PROMO_EVENT_ID,count(1) from rpm_promo group by PROMO_EVENT_ID order by 1;

select PROMO_EVENT_ID,count(1) from rpm_promo where promo_event_id is not null group by PROMO_EVENT_ID order by 1;

select PROMO_EVENT_ID from (select PROMO_EVENT_ID,count(1) from rpm_promo where promo_event_id is not null group by PROMO_EVENT_ID having count(1)>9);
select 611/7 from dual;

set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
  l_promo_ev       rms.rpm_promo_event.PROMO_EVENT_ID%type;
   
    
      cursor cur_dept is
          select PROMO_EVENT_ID from (select PROMO_EVENT_ID,count(1) from rpm_promo where promo_event_id is not null group by PROMO_EVENT_ID having count(1)>9);
 
BEGIN

  for j in 0..88 loop

  for k in cur_dept loop
  
    l_promo_ev := k.PROMO_EVENT_ID;
    
    
        update rpm_promo set PROMO_EVENT_ID = 
                    (select PROMO_EVENT_ID from rpm_promo_event where 
                        PROMO_EVENT_ID not in (select distinct PROMO_EVENT_ID from rpm_promo where PROMO_EVENT_ID is not null) and rownum <= '1')
                where PROMO_EVENT_ID = l_promo_ev and rownum <= '7';


end loop;

end loop;
commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
