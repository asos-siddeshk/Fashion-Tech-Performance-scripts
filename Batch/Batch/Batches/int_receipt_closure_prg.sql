SELECT * from rms.INT_RECEIPT_CLOSE_HEAD;

/*                                         
---------------------------Batch name:RMS.int_receipt_closure_purge----------------------------------

1.Bulk inserted the records to the tables								      :INT_RECEIPT_CLOSE_HEAD (Transaction volume:*** records)
2.PL/SQL script execution that will insert the records to the staging table   :INT_RECEIPT_CLOSE_HEAD
3.Batch execution 															  :RMS.int_receipt_closure_purge via Automic&Putty.
----------------------------------------------------------------------------------------------*/
--alter session set current_schema=rms;

set serveroutput on;
set timing on;

begin

insert into int_asos.INT_RECEIPT_CLOSE_HEAD
    select SHIPMENT,
            ASN, 
            ORDER_NO, 
            BOL_NO, 
            TO_LOC as LOC,
            sysdate -180,
            'PTUSERPRG',
            sysdate -180,
            'PTUSERPRG',
             sysdate -180
        from rms.shipment where status_code ='R' and RECEIVE_DATE is not null  and order_no is not null and rownum <='2000';


exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/

/* TESTING;
-------
SELECT * from rms.INT_RECEIPT_CLOSE_HEAD;  */

