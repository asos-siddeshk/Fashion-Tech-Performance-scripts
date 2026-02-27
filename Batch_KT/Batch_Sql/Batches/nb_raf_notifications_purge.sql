.               
select *
from SUPP_ASOS.RAF_NOTIFICATION_TYPE_B;


Insert into SUPP_ASOS.RAF_NOTIFICATION_TYPE_B (NOTIFICATION_TYPE,CREATED_BY,CREATE_DATE,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATE_LOGIN,APPLICATION_CODE,RETENTION_DAYS,OBJECT_VERSION_NUMBER,NOTIFICATION_TYPE_CODE)
values (299,'Notification Sys',to_timestamp('02-FEB-18 05.40.58.804341000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('02-FEB-18 05.40.58.804341000 PM','DD-MON-RR HH.MI.SSXFF AM'),'Notification Sys','Notification Sys','PO_MAIL_NOTIFICATION',-1,null,'All Notifications');



select email_po_retention_days,
 email_asn_retention_days
from SUPP_ASOS.sc_system_options; --30


SC_RAF_ASYNC_TASK_PKG
RAF_NOTIFICATION_TASK_PKG
select * from SUPP_ASOS.raf_async_task where application_code  = 'PO_MAIL_NOTIFICATION';

select trunc(LAST_UPDATE_DATE),count(1) from SUPP_ASOS.raf_async_task where application_code  != 'PO_MAIL_NOTIFICATION' group by trunc(LAST_UPDATE_DATE) 
    order by 1 desc;

       select count(1)
    from SUPP_ASOS.raf_async_task 
   where application_code        = 'PO_MAIL_NOTIFICATION'
     and trunc(last_update_date) < sysdate - 20;
     
select * from SUPP_ASOS.raf_async_task where application_code  = 'PO_MAIL_NOTIFICATION' and trunc(LAST_UPDATE_DATE) ='24-JAN-19';

select * from all_sequences where sequence_name like '%TASK%';
select SUPP_ASOS.RAF_ASYNC_TASK_ID_SEQ.nextval,systimestamp-1 from dual;


set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0; 

BEGIN
  
for k in 0..21 loop    

insert into SUPP_ASOS.raf_async_task 
select SUPP_ASOS.RAF_ASYNC_TASK_ID_SEQ.nextval, 'PO_MAIL_NOTIFICATION'
        ,TASK_DESC, TASK_CONTEXT, STATUS, TASK_COMMAND_CLASS_NAME, 
        systimestamp-k, 
        systimestamp-k, 
        systimestamp-k, 
        PROCESS_ERROR_TXT, 
        CREATED_BY, 
        systimestamp-k, 
        LAST_UPDATED_BY, 
        systimestamp-k,
        OBJECT_VERSION_NUMBER
   from SUPP_ASOS.raf_async_task where application_code        = 'PO_MAIL_NOTIFICATION'
     and trunc(last_update_date) < sysdate - 20;

commit;
end loop;
commit;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


select trunc(LAST_UPDATE_DATE),count(1) from SUPP_ASOS.raf_async_task where application_code  = 'PO_MAIL_NOTIFICATION' group by trunc(LAST_UPDATE_DATE) 
    order by 1 desc;



begin 
  
for k in 0..30 loop 
delete from SUPP_ASOS.raf_async_task where application_code  = 'NOTIFICATION_SYSTEM' and rownum <= '100000';
commit;
end loop;
commit;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/
