select * from all_sequences where sequence_name like '%ASN%';

select SUPP_ASOS.SC_ASN_SEQ.nextval from dual; --676643

50008242332

select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '29156';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq= '29156';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '29156';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '29156';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '29156';




select * from supp_asos.ordhead where order_no ='50008242332' ;
select * from supp_asos.ordloc where order_no ='50008242332';
select * from supp_asos.shipment where  order_no ='50008242332';
select * from supp_asos.shipsku where shipment ='23586410';


select * from supp_asos.SC_ASNIN_PO where ASN_NBR ='0100000000555385';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='0100000000555385';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='0100000000555385';






set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  VARCHAR2(25);
  curr_seq   VARCHAR2(25);
BEGIN
  SELECT 6663817 INTO last_used FROM dual;

  LOOP
    SELECT SUPP_ASOS.SC_ASN_SEQ.nextval INTO curr_seq FROM dual;
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