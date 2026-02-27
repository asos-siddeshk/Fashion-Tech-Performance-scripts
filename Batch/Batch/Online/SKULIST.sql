select count(order_no) from rms.ordhead where CREATE_DATETIME>= to_date('22-SEP-2020 12:00', 'DD-MON-YYYY hh24:mi');
select count(1) from shipment where order_no in (select order_no from rms.ordhead where CREATE_DATETIME>= to_date('22-SEP-2020 12:00', 'DD-MON-YYYY hh24:mi'));


select * from uda_item_lov where item in (select item from skulist_detail where SKULIST = '150003') and uda_id = '4001';
select * from uda_item_lov where item in (select item from item_master where item_parent in (select item from skulist_detail where SKULIST = '150003')) and uda_id = '4001';

update uda_item_lov set UDA_VALUE = '2' where 
    item in (select item from item_master where item_parent in (select item from skulist_detail where SKULIST = '150003')) and uda_id = '4001';



MERGE INTO uda_item_lov e
    USING  (select item from item_master where item_parent in (select item from skulist_detail where SKULIST = '150003')) h
    ON (e.item = h.item and e.uda_id = '4001')
  WHEN MATCHED THEN
    UPDATE SET e.UDA_VALUE = '2'
  WHEN NOT MATCHED THEN
    INSERT (ITEM, UDA_ID, UDA_VALUE, CREATE_DATETIME, LAST_UPDATE_DATETIME, LAST_UPDATE_ID, CREATE_ID)
    VALUES (h.item,'4001','2',sysdate,sysdate,'PERF','PERF');

MERGE INTO uda_item_lov e
    USING  (select item from item_master where item_parent in (select item from skulist_detail where SKULIST = '150003')) h
    ON (e.item = h.item and e.uda_id = '4001')
  WHEN MATCHED THEN
    UPDATE SET e.UDA_VALUE = '2'
  WHEN NOT MATCHED THEN
    INSERT (ITEM, UDA_ID, UDA_VALUE, CREATE_DATETIME, LAST_UPDATE_DATETIME, LAST_UPDATE_ID, CREATE_ID)
    VALUES (h.item,'4001','2',sysdate,sysdate,'PERF','PERF');
    

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 500834011548 INTO last_used FROM dual;

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

create table optionlist_2209 (item varchar2(25));
select item from optionlist_2209;

select * from skulist_detail where SKULIST = '150003';

select * from skulist_head order by 1 desc ;
Select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where STATUS = 'U';

set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;

l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist              number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM             VARCHAR2(25);
l_date             date;

CURSOR c_itemlist is
select item from optionlist_2209;

BEGIN

   select sysdate-m into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'Clearance'||'-'||l_REF_NO;
		I_filename 		:= 'Clearance'||'-'||l_REF_NO;
        
FOR i in c_itemlist Loop 
            l_item     :=i.item;
					

insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);
		
     
           
       									   
 END LOOP;
       
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
END;
/


