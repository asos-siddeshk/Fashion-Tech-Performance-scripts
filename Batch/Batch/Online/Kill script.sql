
select * from v$session;
 select distinct b.sid from v$locked_object a ,v$session b,dba_objects c
                where b.sid = a.session_id and b.status= 'ACTIVE' and b.USERNAME = 'RPM'
                and a.object_id = c.object_id order by b.status; 




    
    



set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
  l_promo_ev       number (10);
   
    
      cursor cur_dept is
                     select distinct b.sid from v$locked_object a ,v$session b,dba_objects c
                            where b.sid = a.session_id and b.status= 'ACTIVE' and b.USERNAME = 'RPM'
                            and a.object_id = c.object_id order by b.status; 
 
BEGIN

for i in 0..10 loop
  for k in cur_dept loop
  
    l_promo_ev := k.sid;

    system.killsession (l_promo_ev);

 sys.dbms_lock.sleep(2);
end loop;
commit;

end loop;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
