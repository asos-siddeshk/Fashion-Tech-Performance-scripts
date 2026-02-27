 SELECT ro.order_no,
             oh.pre_mark_ind,
             ro.rowid,
             s.edi_po_chg,
             oh.status
        FROM rev_orders ro,
             ordhead oh,
             sups s                                  
       WHERE ro.order_no = oh.order_no 
         AND oh.supplier = s.supplier              
         AND (oh.status = 'A' OR oh.status = 'C') 
    ORDER BY ro.order_no;
    
select * from rms.rev_orders; 
delete from rev_orders; 
    
set serveroutput on;
set timing on;

BEGIN  

insert into rms.rev_orders
select order_no from rms.ordhead oh where status in ('A') and
	not exists (select 1 from rms.rev_orders ro where ro.order_no =oh.order_no)
and rownum<=14000; 

insert into rms.rev_orders
select order_no from rms.ordhead oh where status in ('C') and
	not exists (select 1 from rms.rev_orders ro where ro.order_no =oh.order_no)
and rownum<=1000; 
commit;

exception	
when others then
dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
end;
/