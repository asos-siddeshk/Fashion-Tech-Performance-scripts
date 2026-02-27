select * from ordhead where order_no in (select order_no from skumar.order_pro);
select status,count(1) from ordhead where order_no in (select order_no from skumar.order_pro) group by status;
select distinct order_no from ordloc ol where order_no in (select order_no from skumar.order_pro) ;
select distinct order_no  from ordsku where order_no in (select order_no from skumar.order_pro);
select DISTINCT order_no from shipment where order_no in (select order_no from skumar.order_pro);
select * from shipment where order_no in (select order_no from skumar.order_pro) and status_code <>'R';
select * from shipsku where shipment in (select shipment from shipment where order_no in (select order_no from skumar.order_pro) and status_code <>'R');
select * from DOC_CLOSE_QUEUE where doc in (select order_no from skumar.order_pro);
select * from item_loc_soh where (item,loc) in (select item,location from ordloc where order_no in (select order_no from skumar.order_pro));
select * from tran_data where ref_no_1 in (select order_no from skumar.order_pro);

drop table order_pro;
create table order_pro as
    select order_no from ordhead oh where exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no and STATUS_CODE='I');
    
select ASN,count(1) from shipment where order_no in (select order_no from skumar.order_pro) and status_code <> 'R' group by ASN having count(1)>2;

Update shipment set asn= order_no||7585,COMMENTS= rownum 
    where order_no in (select order_no from skumar.order_pro) and asn like '12321';
    
select * from shipment where order_no in (select order_no from skumar.order_pro) and status_code <> 'R';
select count(1) from DOC_CLOSE_QUEUE where doc in (select order_no from skumar.order_pro);


SELECT a.*
FROM shipment a
JOIN (SELECT ORDER_NO, COUNT(1)
    FROM shipment where order_no in (select order_no from skumar.order_pro)
    GROUP BY  ORDER_NO
    HAVING count(*) >= 1) b
ON  a.ORDER_NO = b.ORDER_NO
ORDER BY a.ORDER_NO,a.shipment;


  select distinct asn, count(1) from shipment where order_no in (select order_no from skumar.order_pro) group by asn having count(1) >2;
  
  select * from shipment where order_no in (select order_no from skumar.order_pro) and status_code <>'R' and asn like '12321';
  
select * from  del_asn;


set SERVEROUTPUT ON;
set timing ON;
  
declare
  o_error_message varchar2(255);
  i_asn rms.shipment.ASN%type;
  v_return boolean;
  
       cursor c_get_asn is
         select ASN from shipment where order_no in (select order_no from skumar.order_pro) and status_code <>'R';


begin
  
  
   FOR cust_ma in c_get_asn Loop
		i_asn			:= cust_ma.ASN; 
       
        o_error_message := null;

        Update rms.shipment set SHIP_ORIGIN ='6' where order_no in (select order_no from skumar.order_pro) and STATUS_CODE='I' and asn = i_asn;        

          v_return := rms.asn_sql.delete_asn(o_error_message => o_error_message,
                    i_asn => i_asn);
  
        if (v_return) then 
            insert into skumar.del_asn (asn,errors) values (i_asn,o_error_message);
            else
            insert into skumar.del_asn (asn,errors) values (i_asn,'S');
        end if;

        end loop;

commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
