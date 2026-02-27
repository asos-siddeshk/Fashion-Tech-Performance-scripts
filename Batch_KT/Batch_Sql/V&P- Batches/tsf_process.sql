exec system.killsession ('4077');


select tsf_type,status,COUNT(1) from rms.tsfhead GROUP BY tsf_type,status ORDER BY 1 desc;
select COUNT(1) from rms.tsfhead GROUP BY status ORDER BY 1 desc;
S	635533
I	63500
C	379194
A	937803

select count(1) from DOC_CLOSE_QUEUE; 
select distinct tran_date,count(1) from rms.tran_data group by tran_date order by 1; --310148
select distinct tran_date,count(1) from rms.if_tran_data group by tran_date order by 1; --315046
select distinct tran_code,count(1) from rms.tran_data group by tran_code order by 1; --315046

select * from if_errors;
Update rms.tsfhead th set status ='C',CLOSE_DATE =get_vdate  where status!='C' and tsf_no in (select UNIT_OF_WORK from if_errors);
delete from  if_errors;
delete from DOC_CLOSE_QUEUE where doc_type ='T' and doc in (select tsf_no from tsfhead where status ='C');           
commit;


INSERT INTO RMS.DOC_CLOSE_QUEUE
SELECT distinct tsf_no,'T' AS DOC_TYPE FROM RMS.TSFDETAIL 
    WHERE tsf_no  IN (select tsf_no FROM rms.tsfhead where STATUS='S'  AND tsf_no in
        (select distro_no from RMS.shipsku where DISTRO_TYPE='T')) 
        and RECEIVED_QTY >= ship_qty;


create table apprd_tsf as
select tsf_no from tsfhead th where status ='A' and not exists (select 1 from rms.shipsku sk where sk.distro_no = th.tsf_no) and rownum<= '1000000';


select count(1) from shipment; -- 41L --4112069
select count(1) from tsfhead; -- 41L --5817024
select count(1) from shipment where BOL_NO is not null; -- 3774576
select count(1) from shipment sh where BOL_NO is not null and exists (select 1 from shipsku sk where sh.shipment = sk.shipment); -- 3386831
select count(1) from shipment sh where BOL_NO is not null and not exists (select 1 from shipsku sk where sh.shipment = sk.shipment); --387747
select DISTINCT status,COUNT(1) from rms.tsfhead GROUP BY status ORDER BY 1 desc;
select * from DOC_CLOSE_QUEUE;
 -- 1. Shipment without skupsku - status I
drop table ship_rePro;
create table ship_rePro as
select shipment,bol_no from shipment sh where 
    BOL_NO is not null 
    and not exists (select 1 from shipsku sk where sh.shipment = sk.shipment) 
   -- and not exists (select 1 from ship_rePro sk2 where sh.shipment = sk2.shipment) 
    and status_code ='I';
    
    /*
set serveroutput on;
set timing on;

DECLARE

c_commit  NUMBER(10)     := 0;
l_SHIPMENT    skumar.ship_rePro.SHIPMENT%type;
l_BOL_NO      skumar.ship_rePro.BOL_NO%type;

CURSOR c_ship is
    select shipment,bol_no from skumar.ship_rePro sh where 
        not exists (select 1 from shipsku sk where sk.shipment = sh.shipment);
    
begin 
    
FOR i in c_ship Loop 
            l_shipment     :=i.shipment;
            l_bol_no     :=i.bol_no;
	
insert into shipsku (SHIPMENT, SEQ_NO, ITEM, DISTRO_NO, DISTRO_TYPE, CARTON, INV_STATUS, STATUS_CODE, QTY_RECEIVED, UNIT_COST, UNIT_RETAIL, QTY_EXPECTED)
                select l_shipment --l_shipment
                        ,td.TSF_SEQ_NO
                        ,td.ITEM
                       ,l_bol_no-- l_bol_no,
                        ,'T',
                        l_bol_no--,l_bol_no
                        ,'-1'
                        ,'A'
                        ,'0'
                        ,nvl(td.tsf_price,5)
                        ,nvl(td.tsf_price,7)
                        ,td.TSF_QTY
      from tsfdetail td where td.tsf_no = l_bol_no ;
      
   c_commit :=c_commit + 1;
       IF MOD(c_commit, 50000) = 0 THEN
        COMMIT;
       END IF;
end loop;

commit;
exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/ */

select status_code,count(1) from shipment where shipment in (select shipment from skumar.ship_rePro) group by status_code; --11908
select count(1) from doc_close_queue where doc_type ='T'; --11847


 -- 2. Shipment without skupsku - status R

drop table ship_rePro2r;
create table ship_rePro2r as
select shipment,bol_no from shipment sh where 
    BOL_NO is not null 
    and not exists (select 1 from shipsku sk where sh.shipment = sk.shipment) 
    and not exists (select 1 from ship_rePro2r sk2 where sh.shipment = sk2.shipment) 
    and status_code ='R';
    
    
select status_code,count(1) from shipment where shipment in (select shipment from skumar.ship_rePro2r) group by status_code;



select * from shipment where shipment in (select shipment from skumar.ship_rePro2r);

select * from shipsku where shipment in (select shipment from skumar.ship_rePro2r);
 Update shipsku set QTY_RECEIVED = 0   where shipment in (select shipment from skumar.ship_rePro2r);

insert into doc_close_queue select bol_no,'T' from skumar.ship_rePro2r;


update rms.restart_program_status set program_status= 'ready for start' where  RESTART_NAME like 'docclose';;
delete from rms.restart_bookmark where RESTART_NAME like 'docclose';
select * from rms.restart_bookmark order by 1 ;

select * from skumar.tsf_del;
select count(1) from doc_close_queue;
select status,count(1) from rms.tsfhead th group by status;
/*I	77152
C	18865770
A	944474
S	299037*/
    
select * from rms.tsfhead where status ='S';
select * from rms.tsfhead where tsf_no in ('7027923313');
select * from rms.tsfdetail where tsf_no in ('7027923313');

select * from rms.shipment where shipment in (select shipment from rms.shipSKU where DISTRO_NO in ('7027923313'));
select * from rms.shipSKU where DISTRO_NO in ('7027923313');
select * from rms.shipSKU_loc where shipment in (select shipment from rms.shipSKU where DISTRO_NO in ('7027923313'));

select * from rms.DOC_CLOSE_QUEUE where doc in ('7027923313');
select * from rms.item_loc_soh where  (item,loc) in (select ITEM, LOCATION from rms.tran_data where ref_no_1 in ('7027923313'));
select * from rms.tran_data where ref_no_1 in ('7027923313') order by item,location,tran_code;


alter session set current_schema=rms;
 -- Docclose
set serveroutput on;
set timing on;

DECLARE
  O_ERROR_MESSAGE VARCHAR2(255);
  O_CLOSED BOOLEAN;
  I_TSF_NO NUMBER;
  v_Return BOOLEAN;
  
  cursor c_tsf is
	select doc from doc_close_queue where doc_type ='T' and rownum<='10' and doc ='7000675148';
  
  
BEGIN 

for m in c_tsf loop
	I_TSF_NO := m.doc;
	
  v_Return := RMS.APPT_DOC_CLOSE_SQL.CLOSE_TSF(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    O_CLOSED => O_CLOSED,
    I_TSF_NO => I_TSF_NO);

IF (v_Return) THEN 
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'Success: ' ||I_TSF_NO);
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'Failure : ' ||I_TSF_NO);
	  DBMS_OUTPUT.PUT_LINE('O_ERROR_MESSAGE = ' || O_ERROR_MESSAGE);
  END IF;

  end loop;
  commit;
  
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/


-- Delete transfers

set SERVEROUTPUT ON;
set timing ON;
Declare 
   L_error_message RTK_ERRORS.RTK_TEXT%TYPE;
  
   cursor C_GET_TSF is 
     select tsh.tsf_no,
            tsh.status, 
            tsh.tsf_type
       from tsfhead tsh
      where status ='I' and rownum <= '100000' order by 1;

Begin 
for m in 0..0 loop
   for rec in C_GET_TSF loop      
      if TRANSFER_SQL.DELETE_CANCELLED_TSF(L_error_message,
                                           rec.tsf_no,
                                           NULL,
                                           rec.status,
                                           rec.tsf_type) = FALSE then
                                           
        insert into skumar.tsf_del values (rec.tsf_no,L_error_message);
      else 
        insert into skumar.tsf_del values (rec.tsf_no,'S');
      end if;   
   end loop;
    commit;
      end loop;
   commit;
   
end;   
/
truncate table tsf_del;
update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_program_status where program_name like 'docclose' order by 1 ;
select * from restart_control where program_name like 'docclose';
select status,COUNT(1) from rms.tsfhead GROUP BY status ORDER BY 1 desc;
S	1231834
I	24097
C	288267
A	2843702
select count(1) from DOC_CLOSE_QUEUE;
select distinct tran_date,count(1) from rms.tran_data group by tran_date order by 1; --315046
select distinct tran_code,count(1) from rms.tran_data group by tran_code order by 1; --315046
select * from if_errors;


Update rms.tsfhead th set status ='C',CLOSE_DATE =get_vdate
    where status!='C' and tsf_no in (select UNIT_OF_WORK from if_errors);
delete from  if_errors;

update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
./prepost $UP docclose pre
echo $?
./docclose $UP &


delete from DOC_CLOSE_QUEUE where doc in (select tsf_no from tsfhead where status ='C');           
                
delete from DOC_CLOSE_QUEUE;
insert into DOC_CLOSE_QUEUE
    select tsf_no,'T' from tsfhead t where status='S' and rownum<='500' and not exists (select 1 from DOC_CLOSE_QUEUE d where d.doc=t.tsf_no)order by 1 ; 

select * from tsfhead where tsf_no in (select doc from DOC_CLOSE_QUEUE);
select status,count(1) from tsfhead where tsf_no in (select doc from DOC_CLOSE_QUEUE) group by status;
select tsf from tsfdetail where tsf_no in (select doc from DOC_CLOSE_QUEUE);
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in (select doc from DOC_CLOSE_QUEUE));
select status_code,count(1) from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in (select doc from DOC_CLOSE_QUEUE)) group by status_code;
select count(1) from shipSKU where DISTRO_NO in (select doc from DOC_CLOSE_QUEUE);
select * from shipSKU_loc where shipment in (select shipment from shipSKU where DISTRO_NO in (select doc from DOC_CLOSE_QUEUE));
select * from DOC_CLOSE_QUEUE where doc in (select doc from DOC_CLOSE_QUEUE);
select * from item_loc_soh where  (item,loc) in (select ITEM, LOCATION from tran_data where ref_no_1 in (select doc from DOC_CLOSE_QUEUE));
select * from tran_data where ref_no_1 in (select doc from DOC_CLOSE_QUEUE) order by item,location,tran_code;
--insert into DOC_CLOSE_QUEUE values (7000000003,'T');

select count(1) from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in (select doc from DOC_CLOSE_QUEUE));

Update rms.tsfhead th set status ='C',CLOSE_DATE =get_vdate
    where status ='S' --and tsf_no in (select doc from DOC_CLOSE_QUEUE)
        and not exists (select 1 from rms.shipsku sk where sk.distro_no = th.tsf_no);
commit;
    
drop table bol_del;
 create table bol_del as
select BOL_NO,count(1) as count  from shipment where shipment in 
  (select distinct shipment from shipSKU where DISTRO_NO in (select doc from DOC_CLOSE_QUEUE)) group by BOL_NO having count(1) >=2;

select * from tsfhead where tsf_no in (select BOL_NO from bol_del);
select * from tsfdetail where tsf_no in (select BOL_NO from bol_del);
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in (select BOL_NO from bol_del));
select * from shipSKU where DISTRO_NO in (select BOL_NO from bol_del) ;

create table shipment_del as
select shipment FROM shipment where bol_no in (select BOL_NO from bol_del)
		and rowid not in
		(SELECT MIN(rowid)
		FROM shipment where bol_no in (select BOL_NO from bol_del)
		GROUP BY BOL_NO);	


set SERVEROUTPUT ON;
set timing ON;
  DECLARE
        O_ERROR_MESSAGE VARCHAR2(255);
        O_CLOSED BOOLEAN;
        I_TSF_NO NUMBER;
        v_Return BOOLEAN;
        L_return_code   varchar2(5)   := null;
        L_error_message varchar2(255) := null;
        l_tsf_id        rms.doc_close_queue.doc%type;
        p_shipment      rms.shipment.shipment%type;
        c_commit  	        NUMBER(8)                     := 0;

        cursor c_shipment is
            select shipment from SHIPMENT_DEL;            
   
   
     BEGIN
              FOR k in c_shipment loop 
                    EXIT WHEN c_shipment%NOTFOUND;
                    p_shipment                   := k.shipment;  
                   delete from SHIPSKU_LOC where shipment =p_shipment;
                    delete from shipsku where shipment =p_shipment;
                    delete from shipment where shipment =p_shipment;

       c_commit :=c_commit + 1;
       IF MOD(c_commit, 50) = 0 THEN
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



begin
delete from shipment where shipment not in (select distinct shipment from shipsku);
commit;
end;
/
