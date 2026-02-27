
Item: 2200006554165
Item: 2200006554172
Item: 2200006554189
Item: 2200006554196
Item: 2200006554202
Item: 2200006554219
Item: 2200006554226
Item: 2200006554233
Item: 2200006554240
Item: 2200006554257



--create table ITEM_EAN13 (item varchar2(25));
--GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.ITEM_EAN13 TO PSURENDRAN; 
--select * from ITEM_EAN13;
alter session set current_schema=rms;

set serveroutput on;
set timing on;

declare
O_error_message         VARCHAR2(200);
I_item_type             rms.ITEM_MASTER.ITEM_NUMBER_TYPE%TYPE := 'EAN13';
IO_item_no              rms.ITEM_MASTER.ITEM%type;

Items_count             number := 10; -- Change this value as per requirement

BEGIN

FOR i IN 1..Items_count LOOP
        If (rms.ITEM_NUMBER_TYPE_SQL.GET_NEXT(O_error_message,IO_item_no,I_item_type)= TRUE) then

				DBMS_OUTPUT.PUT_LINE('Item: '||IO_item_no);
            else 
                 DBMS_OUTPUT.PUT_LINE('Error_message'||O_error_message); 
        END IF;
END loop;

EXCEPTION
	  when OTHERS THEN
      dbms_output.put_line('Exception Block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
end;

