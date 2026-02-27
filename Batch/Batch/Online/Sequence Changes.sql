select skumar.CASHANDSALES_SlNO.nextval from dual;


select * from ma_asos.ma_price_event_threshold; --50000	50000	100000

select seq.nextval S from dual;
alter sequence seq increment by -&inc minvalue 0;
alter sequence seq increment by v_seq;
alter sequence seq increment by 1;

insert into seq_modify values ('MA_ITEM_MFSEQUENCE') ;
delete from  seq_modify where sequence_name like 'MA_ITEM_MFSEQUENCE';

select * from all_sequences where sequence_name in (select sequence_name from seq_modify);
select * from all_sequences where sequence_name like 'ITEM%' and SEQUENCE_OWNER like 'RMS' order by 1,2;

--select * from MA_ITEM_MFSEQUENCE;
 

DELETE FROM seq_modify
    WHERE rowid not in
		(SELECT MIN(rowid)
		FROM seq_modify
		GROUP BY SEQUENCE_NAME);	
        
select * from all_sequences where sequence_name in (select sequence_name from seq_modify);


CASHANDSALES_SlNO
--- Items
select CASHANDSALES_SlNO.nextval from dual;

desc item_Master;

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  VARCHAR2(25);
  curr_seq   VARCHAR2(25);
BEGIN
  SELECT 5386339 INTO last_used FROM dual;
  
  LOOP
    SELECT CASHANDSALES_SlNO.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

--- Items
select rms.ITEM_SEQUENCE.nextval from dual;



desc item_Master;

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  VARCHAR2(25);
  curr_seq   VARCHAR2(25);
BEGIN
  SELECT 106893374 INTO last_used FROM dual;
  
  LOOP
    SELECT ITEM_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

--- Allocations

select * from all_sequences where sequence_name in (select sequence_name from seq_modify);

select ALLOC_ORDER_SEQUENCE.nextval from dual;
desc Alloc_header;

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(10);
  curr_seq   NUMBER(10);
BEGIN
  SELECT 1025371073 INTO last_used FROM dual;

  LOOP
    SELECT ALLOC_ORDER_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


 --- Master Orders

select * from all_sequences where sequence_name in (select sequence_name from seq_modify);

insert into seq_modify
select sequence_name from all_sequences where sequence_name like '%MASTER%';

select * from all_sequences where SEQUENCE_OWNER like '%MA_ASOS%';

select ma_asos.MA_MASTER_ORDER_SEQ.nextval from dual; --195356

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 30531445 INTO last_used FROM dual;
 LOOP
    SELECT ma_asos.MA_MASTER_ORDER_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

select ORDER_SEQUENCE.NEXTVAL from dual;

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 500070025791 INTO last_used FROM dual;

  LOOP
    SELECT ORDER_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

-- Transfers

select * from all_sequences where sequence_name in (select sequence_name from seq_modify);
select * from all_sequences where SEQUENCE_OWNER like '%MA_ASOS%';

select rms.TRANSFER_NUMBER_SEQUENCE.nextval from dual;
select * from all_sequences where sequence_name like '%TRANSFER_NUMBER_SEQUENCE%';

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
 SELECT 8028600368 INTO last_used FROM dual; --7051315644
  LOOP
    SELECT rms.TRANSFER_NUMBER_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


 --- Customer order 
select rms.ORDCUST_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 989257761 INTO last_used FROM dual; --

LOOP
    SELECT rms.ORDCUST_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;

END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

select rms.SHIPMENT_SEQUENCE.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 112983935 INTO last_used FROM dual; --

LOOP
    SELECT rms.SHIPMENT_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;

END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

select rms.CORESVC_COSTCHG_PSEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 6000 INTO last_used FROM dual; --7051315644

  LOOP
    SELECT rms.RECLASS_NO_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/



select * from all_sequences where sequence_name like 'RPM%PROMO%' and SEQUENCE_OWNER like 'RMS' order by 1,2;
SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE '%CLE%' and SEQUENCE_OWNER like 'RMS';
SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE '%PRI%' and SEQUENCE_OWNER like 'RMS';


RPM_CLEARANCE_SEQ
RPM_PRICE_CHANGE_DISPLAY_SEQ	35738903
RPM_PRICE_CHANGE_SEQ	        31997311


select rms.RPM_PRICE_CHANGE_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 35738903 INTO last_used FROM dual; --7051315644

  LOOP
    SELECT rms.RPM_PRICE_CHANGE_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/



-- Clearance

select rms.RPM_CLEARANCE_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 323381920 INTO last_used FROM dual; --7051315644

  LOOP
    SELECT rms.RPM_CLEARANCE_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


RPM_PROMO_COMP_DISPLAY_ID_SEQ
RPM_PROMO_COMP_SEQ
RPM_PROMO_DETAIL_DISPLAY_SEQ
RPM_PROMO_DISPLAY_ID_SEQ
RPM_PROMO_DTL_SEQ
RPM_PROMO_SEQ


select rms.RPM_PROMO_DISPLAY_ID_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 65446581 INTO last_used FROM dual; 

  LOOP
    SELECT rms.RPM_PROMO_DISPLAY_ID_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

select rms.RPM_PROMO_DETAIL_DISPLAY_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 65446581 INTO last_used FROM dual; 

  LOOP
    SELECT rms.RPM_PROMO_DETAIL_DISPLAY_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


select rms.RPM_PROMO_COMP_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 89396 INTO last_used FROM dual; 

  LOOP
    SELECT rms.RPM_PROMO_COMP_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/



select rms.RPM_PROMO_COMP_DISPLAY_ID_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 89396 INTO last_used FROM dual; 

  LOOP
    SELECT rms.RPM_PROMO_COMP_DISPLAY_ID_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

select rms.RPM_PROMO_DTL_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 65446582 INTO last_used FROM dual; 

  LOOP
    SELECT rms.RPM_PROMO_DTL_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


select rms.RPM_PROMO_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 79930 INTO last_used FROM dual; --7051315644

  LOOP
    SELECT rms.RPM_PROMO_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


             select ma_asos.ma_stage_rpm_promo_id_seq.nextval into l_stage_id from dual;
             select ma_asos.ma_promo_comp_seq.nextval into l_stage_promo_comp_id from dual;
                select ma_asos.ma_stage_rpm_promo_id_seq.nextval into l_stage_simple_promo_id from dual;
                select ma_asos.ma_process_id_seq.nextval into l_stage_process_id from dual;
                select ma_asos.ma_rpm_message_seq.nextval into l_message_seq_id from dual;
                select ma_asos.ma_injector_process_id_seq.nextval into l_process_id from dual;


select ma_asos.ma_injector_process_id_seq.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 62945232 INTO last_used FROM dual; --7051315644

  LOOP
    SELECT ma_asos.ma_rpm_message_seq.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/
