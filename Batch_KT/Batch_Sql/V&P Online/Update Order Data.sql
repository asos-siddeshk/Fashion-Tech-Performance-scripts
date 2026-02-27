create table ordupd_s as
select master_po_no,count(1) as counts from ordhead oh where status = 'A' 
    and not exists (select 1 from rms.shipment sh where Sh.order_no = oh.order_no )
group by master_po_no ;


select * from ordupd_s where counts  = '3';

select  order_no,status from ordhead where order_no in (select order_no from ordhead where master_po_no ='20689193');
select  * from ordhead where order_no in (select order_no from ordhead where master_po_no ='20689193');
select * from ordloc where order_no in (select order_no from ordhead where master_po_no ='20689193');
select * from shipment where order_no in (select order_no from ordhead where master_po_no ='20689193');



select distinct oh.master_po_no
from rms.ordhead oh
        inner join  rms.ordloc ol on ol.order_no=oh.order_no
        left join rms.shipment sh on sh.order_no=ol.order_no
where oh.create_datetime>='04-FEB-19' and comment_desc = ' PO Create' and sh.order_no is null 
    group by ol.order_no,oh.master_po_no
    having sum(ol.qty_ordered)<>sum(nvl(ol.qty_received,0));
    
    
select * from ordhead where master_po_no in ('21057867');
select * from ordloc where order_no in (select order_no from ordhead where master_po_no in ('21057867'));
select * from shipment where order_no in (select order_no from ordhead where master_po_no in ('21057867'));

drop table ord_up;
create table ord_up as
select order_no,oh.MASTER_PO_NO from ordhead oh where oh.status ='A' ;

select order_no,oh.MASTER_PO_NO from ordhead oh where oh.status ='A' ;


    select * from shipment where order_no in (select order_no from ordhead where master_po_no in ('20638980')); 



select * from skumar.ord_up;




select MASTER_PO_NO from ord_up group by MASTER_PO_NO having count(MASTER_PO_NO) ='1'; --518
select MASTER_PO_NO from ord_up group by MASTER_PO_NO having count(MASTER_PO_NO) ='2'; --55457
select MASTER_PO_NO from ord_up group by MASTER_PO_NO having count(MASTER_PO_NO) ='3' order by 1; --199
select MASTER_PO_NO from ord_up group by MASTER_PO_NO having count(MASTER_PO_NO) >'3' order by 1; --102

select * from shipment where asn is not null and order_no in (select order_no from ord_up);
select * from shipment where asn is not null and order_no in (select order_no from ord_up);




drop table ord_up;
create table ord_up as
select order_no,oh.MASTER_PO_NO from ordhead oh where oh.status ='A' ;


select * from ordhead where 
    MASTER_PO_NO in (select MASTER_PO_NO from ordupdqty);

select order_no, count(1) from ordsku where order_no in (select order_no from ordhead where 
    MASTER_PO_NO in (select MASTER_PO_NO from ordupdqty)) group by order_no;

create table ordupdqty as
select MASTER_PO_NO,count(1) as count from ord_up group by MASTER_PO_NO having count(1)  ='3';


GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.pro_alloc TO rdatla; 


select order_no, count(1) from ordsku where order_no in (select order_no from ordhead where 
    MASTER_PO_NO in (select MASTER_PO_NO from ordupdqty)) group by order_no;

set SERVEROUTPUT ON;
set timing ON;
  
declare
  o_error_message           varchar2(255);
  i_order_no               rms.ordhead.order_no%type;
  i_MASTER_PO_NO           rms.ordhead.MASTER_PO_NO%type;
  v_return                  boolean;
  l_exists                  rms.item_master.item_parent%type;
    
    cursor c_get_asn is
         select distinct MASTER_PO_NO from ord_up;

    cursor c_reclass (i_MASTER_PO_NO rms.ordhead.MASTER_PO_NO%type) is
           select 1 from shipment where order_no in (select order_no from ordhead where master_po_no = i_MASTER_PO_NO); 

begin
  
  
   FOR k in c_get_asn Loop
    i_MASTER_PO_NO			:= k.MASTER_PO_NO; 
        
        
   
   open c_reclass(i_MASTER_PO_NO);
   
   fetch c_reclass into l_exists;
    
        if c_reclass%FOUND then
            delete from ord_up where MASTER_PO_NO = i_MASTER_PO_NO;
     
        end if;
    close c_reclass;      
    
    end loop;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
