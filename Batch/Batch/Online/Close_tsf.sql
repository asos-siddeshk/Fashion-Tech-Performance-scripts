set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE VARCHAR2(255);
  O_CLOSED BOOLEAN;
  I_TSF_NO NUMBER;
  v_Return BOOLEAN;
   c_commit NUMBER(8)                     := 1;
  cursor c_tsf is
     select doc from rms.doc_close_queue d where doc_type ='T' ;
BEGIN 
for k in 0..10 loop 
for m in c_tsf loop
	I_TSF_NO := m.doc;
  v_Return := RMS.APPT_DOC_CLOSE_SQL.CLOSE_TSF(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    O_CLOSED => O_CLOSED,
    I_TSF_NO => I_TSF_NO);
    IF (v_Return) THEN 
delete from rms.DOC_CLOSE_QUEUE where doc = I_TSF_NO;
    ELSE
insert into rms.if_errors (PROGRAM_NAME,ERR_DATE,UNIT_OF_WORK,ERROR)values ('TSF_CLOSE',sysdate,I_TSF_NO,O_ERROR_MESSAGE);
  END IF;
   c_commit :=c_commit + 1;
       IF MOD(c_commit, 10) = 0 THEN
        COMMIT;
       END IF;
  end loop;
  commit;
end loop;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/ 