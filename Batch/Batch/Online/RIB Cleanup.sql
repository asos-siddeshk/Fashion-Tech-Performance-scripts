create table Del_rib_msg as
      select message_num from RIB_MESSAGE rm ;
    
set serveroutput on;
set timing on;
 
DECLARE
 l_MESSAGE_NUM             rms.RIB_MESSAGE.MESSAGE_NUM%type;
 COUNTER_COMMIT            NUMBER(8)     := 0;

    cursor cur_dept is --16991
		select MESSAGE_NUM from Del_rib_msg;

BEGIN
for k in cur_dept loop
  l_MESSAGE_NUM := k.MESSAGE_NUM;
  
 delete from RIB_MESSAGE_ROUTING_INFO where MESSAGE_NUM =l_MESSAGE_NUM;
 delete from RIB_MESSAGE_FAILURE where MESSAGE_NUM =l_MESSAGE_NUM;
 delete from RIB_MESSAGE where MESSAGE_NUM =l_MESSAGE_NUM;

    COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 100) = 0 THEN
				COMMIT;
			   END IF;
end loop;
 commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
