
select count(1) from order_mfqueue;
select count(1) from tsf_mfqueue; --1144070
select count(1) from alloc_mfqueue;

delete from alloc_mfqueue;
delete from alloc_mfqueue;
delete from item_mfqueue;

truncate table item_mfqueue;


select status,COUNT(1) from rms.ordhead GROUP BY status ORDER BY 1 desc;
select close_date,COUNT(1) from rms.ordhead GROUP BY close_date ORDER BY 1 ;

select  count(1) from ordhead oh where status ='A' and not exists (select 1 from rms.ordloc sh where sh.order_no = oh.order_no ); -- 114k
select  count(1) from ordhead oh where status ='A' and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no ); -- 114k
select  count(1) from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no and sh.status_code ='I'); --30k
select  count(1) from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no and sh.status_code ='R'); --54k

select doc_type,COUNT(1) from RMS.DOC_CLOSE_QUEUE GROUP BY doc_type ORDER BY 1 desc;
select doc_type,COUNT(1) from DOC_CLOSE_QUEUE_BACKUP GROUP BY doc_type ORDER BY 1 desc;


select status,COUNT(1) from rms.tsfhead GROUP BY status ORDER BY 1 desc;
select status,count(1) from rms.alloc_header group by status ORDER BY 1 desc;
select DISTINCT CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;


select * from ordhead oh where status ='A' 
        and not exists (select 1 from rms.shipment where order_no = oh.order_no) 
        and rownum <= '3';

select * from restart_program_status where program_name like 'docclose';
select * from rms.restart_bookmark where restart_name like 'docclose';
select * from restart_control where program_name like 'docclose';

update rms.restart_program_status set program_status= 'ready for start' where program_name like 'docclose';
delete from rms.restart_bookmark where restart_name like 'docclose';

-- run doclose after script of receiving
-- delete tran_data- 9999 records
select status,COUNT(1) from rms.ordhead GROUP BY status ORDER BY 1 desc;


select distinct item,location,count_as from (
select ol.item,ol.location,count(1) as count_as from ordloc ol, ordhead oh 
where ol.order_no =  oh.order_no and oh.status ='A' 
    group by ol.item,ol.location having count(1) > '50');


select  order_no,status from ordhead where order_no in (18800024732);
select  * from ordhead where order_no in (18800024732);
select * from ordloc where order_no in (18800024732);
select * from shipment where order_no in (18800024732);
select STATUS_CODE,count(1) from shipment where order_no in (18800024732) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (18800024732));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (18800024732));
select * from DOC_CLOSE_QUEUE where doc in (18800024732);
select * from item_loc_soh where (item,loc) in (select item,location from ordloc where order_no in (18800024732));
select * from tran_data where ref_no_1 in (18800024732);


select DISTINCT CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;
select DISTINCT status,COUNT(1) from rms.ordhead  GROUP BY status ORDER BY 1 desc;
select DISTINCT status,COUNT(1) from rms.ordhead  where order_no in (select order_no from skumar.order_pro) GROUP BY status ORDER BY 1 desc;
select * from ordhead where order_no in (select order_no from skumar.order_pro);
select * from ordloc where order_no in (select order_no from skumar.order_pro);
select distinct order_no from ordloc where order_no in (select order_no from skumar.order_pro) ;
select distinct order_no  from ordsku where order_no in (select order_no from skumar.order_pro);
select DISTINCT order_no from shipment where order_no in (select order_no from skumar.order_pro);
select * from shipment where order_no in (select order_no from skumar.order_pro) and STATUS_CODE <> 'R';
select * from shipsku where shipment in (select shipment from shipment where order_no in (select order_no from skumar.order_pro));
select count(1) from DOC_CLOSE_QUEUE where doc in (select order_no from skumar.order_pro);
select * from item_loc_soh where (item,loc) in (select item,location from ordloc where order_no in (select order_no from skumar.order_pro));
select count(1) from tran_data where ref_no_1 in (select order_no from skumar.order_pro) order by item,location,tran_code;


select * from DOC_CLOSE_QUEUE;

insert into DOC_CLOSE_QUEUE
select order_no,'P' from skumar.order_pro where rownum <= '6000';


select order_no,'P' from skumar.order_pro where rownum <= '6000';

drop table order_pro;  
create table order_pro as
select * from ordhead where status!='C' and order_no not in (select distinct order_no from ordloc );

select * from doc_close_queue where doc in (select order_no from order_pro);
select * from doc_close_queue where doc in (select order_no from order_pro);

select * from ordhead where status!='C' and order_no in (select distinct order_no from ordloc where QTY_ORDERED ='0');

drop table order_pro;
create table order_pro as
--select distinct order_no from shipment where order_no in (select order_no from ordhead where status ='A') and STATUS_CODE ='R';
--select order_no from rms.ordhead oh where not exists (select 1 from ordloc ol where ol.order_no = oh.order_no) and status ='A';
--select order_no from rms.ordhead oh where status ='A' and exists (select 1 from ordloc ol where ol.order_no = oh.order_no and CANCEL_CODE is not null and rownum<='1');
--select ORDER_NO from ordhead oh where status ='C' and close_date is null;
select ORDER_NO from ordhead oh where status ='A' and oh.order_no in (select distinct order_no from ordloc ol where (ol.item,ol.location) in (select item,location from ordloc_clean)) 
    and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no);

drop table ordloc_clean;
create table ordloc_clean as   
    select distinct item,location,count_as from (
    select ol.item,ol.location,count(1) as count_as from ordloc ol, ordhead oh 
    where ol.order_no =  oh.order_no and oh.status ='A' 
    group by ol.item,ol.location having count(1) > '10');

select * from ordloc_clean;
select * from order_pro;

select distinct item,location,count_as from (
    select ol.item,ol.location,count(1) as count_as from ordloc ol, ordhead oh 
    where ol.order_no =  oh.order_no and oh.status ='A' 
    group by ol.item,ol.location);
    
-- Cancel orders

SET SERVEROUTPUT ON;
SET timing ON;
DECLARE
   o_error_message VARCHAR2(200) := NULL;
   v_cancel_code VARCHAR2(1) := 'A';
   v_cancel_id VARCHAR2(30) := 'FORCECLR';
   v_alloc_close_ind VARCHAR2(200);
   v_return BOOLEAN := FALSE;

   le_error EXCEPTION;

   Cursor C_GET_DATA IS
    SELECT order_no
         ,status
         ,otb_eow_date
     FROM ordhead oh
    WHERE status != 'C' 
        and  order_no  in (select order_no from skumar.order_pro);
      --  and status ='A' and ORIG_APPROVAL_ID ='ORACNV';
      --  and exists (select 1 from rms.ordloc ol where oh.order_no = ol.order_no and ol.QTY_CANCELLED is not null and rownum <= '1') ;
      /* and order_no  in (SELECT oh.order_no
                         FROM ordhead oh
                        WHERE TRUNC(oh.not_after_date) < '26-DEC-18'
                          AND oh.status IN ('W', 'A')); */


BEGIN

   FOR rec in C_GET_DATA

   LOOP

      IF rec.otb_eow_date IS NULL THEN
         UPDATE ordhead
            SET otb_eow_date = get_vdate()
          WHERE order_no = rec.order_no;
      END IF;
     
      v_return := ORDER_STATUS_SQL.CANCEL_ALL(o_error_message,
                                              rec.order_no,
                                              v_cancel_code,
                                              v_cancel_id,
                                              v_alloc_close_ind);

      --DBMS_OUTPUT.PUT_LINE('o_error_message = ' || o_error_message);

      IF (v_return) THEN 

         UPDATE ordhead
            SET status = 'C',
                close_date = get_vdate
          WHERE order_no = rec.order_no;
      ELSE
         DBMS_OUTPUT.PUT_LINE('v_return = ' || 'ERROR WAS ENCOUNTERED');
         RAISE le_error;
      END IF;

   END LOOP;

   COMMIT;

   EXCEPTION
      WHEN le_error THEN
         DBMS_OUTPUT.PUT_LINE('something happened error');
         ROLLBACK;

      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error was encountered: '||TO_CHAR(SQLCODE)||': '||SQLERRM);
         ROLLBACK;

END;
/


drop table order_pro;
create table order_pro as
select distinct order_no from shipment where order_no in (select order_no from ordhead where status ='A') and STATUS_CODE ='R';

select doc_type,count(1) from doc_close_queue group by DOC_TYPE;
select count(1) from order_mfqueue;

delete from DOC_CLOSE_QUEUE;
insert into DOC_CLOSE_QUEUE
select * from doc_close_queue_bk bk;

drop table doc_close_queue_bk;
create table doc_close_queue_bk as
select * from doc_close_queue;


select count(1) from doc_close_queue;


select count(1) from order_mfqueue;
delete from order_mfqueue;

SELECT status, count(1)  FROM ordhead oh WHERE order_no  in (select order_no from skumar.order_pro) group by status;
  
select status,COUNT(1) from rms.ordhead GROUP BY status ORDER BY 1 desc; 
update ordhead set close_date ='27-JAN-19' where status ='C' and close_date  is null;
delete from order_mfqueue;
    
select CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;

   select vdate -37 from period; --27

set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
 l_vdate           rms.period.vdate%type ;
   

BEGIN
 select vdate-6 into l_vdate from period; --27
for k in 0..3 loop
      
 Update rms.ordhead set CLOSE_DATE =l_vdate-k where status ='C' and trunc(CLOSE_DATE)='01-MAR-20' and rownum<='5000';
 delete from order_mfqueue;
  
end loop;
commit;
 
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
