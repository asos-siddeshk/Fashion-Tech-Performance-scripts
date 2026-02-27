select trunc(CREATE_DATETIME),count(1) from SUPP_ASOS.SC_ASNIN_PO  asp
            where  CREATE_ID like 'PTESTUSER%' 
    and exists (select 1 from SUPP_ASOS.ordhead oh where oh.status ='C' and asp.PO_NBR = oh.order_no) 
            group by trunc(CREATE_DATETIME);

select * from SUPP_ASOS.SC_ASNIN_PO asp where CREATE_ID like 'PTESTUSER%' 
    and exists (select 1 from SUPP_ASOS.ordhead oh where oh.status ='A' and asp.PO_NBR = oh.order_no and oh.supplier = '1100000086')
    and asp.PO_NBR between 50000831767 and 50000894597;            
            
select trunc(CREATE_DATETIME),count(1) from SUPP_ASOS.sc_asnin 
    where  trunc(CREATE_DATETIME) between '01-NOV-2018' and '30-NOV-2018' group by trunc(CREATE_DATETIME);
    
select * from SUPP_ASOS.sc_asnin where  trunc(CREATE_DATETIME) >= '26-NOV-2019'; 

    select order_no, supplier, sn.close_date
            from 
                (select oh.order_no,oh.supplier,oh.close_date from supp_asos.ordhead oh where  oh.status ='C' 
                            and exists (select 1 from supp_asos.shipment sh where sh.order_no= oh.order_no)) sn  where 
                not exists (select 1 from supp_asos.SC_ASNIN_PO sap where sap.PO_NBR= sn.order_no) and rownum <= '50' order by 1;

select * from supp_asos.ordhead where order_no ='50004574001';
select * from supp_asos.ordloc where order_no ='50004574001';
select * from supp_asos.shipment where  order_no ='50004574001';
select * from supp_asos.shipsku where shipment ='70132';

select * from supp_asos.SC_ASNIN_PO where PO_NBR ='50004574001';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='0128000000151437';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='0128000000151437';

select * from supp_asos.ordhead oh where oh.close_date is not null and oh.status ='C' 
    and not exists (select 1 from supp_asos.SC_ASNIN_PO sap where sap.PO_NBR = oh.order_no) and order_no ='50000722671';


select * from all_constraints where constraint_name like 'PK_SC_ASNIN';



select * from all_sequences where sequence_name like '%ASN%';

select SUPP_ASOS.SC_ASN_SEQ.nextval from dual;
select * from supp_asos.SC_ASNIN order by ASN_NBR desc; 
    desc supp_asos.ordhead;
    
select * from supp_asos.SC_ASNIN where CREATE_ID like 'PTESTUSER%' and trunc(CREATE_DATETIME) = '21-JAN-20' ;


delete from supp_asos.SC_ASNIN_PO where ASN_NBR not in (select ASN_NBR from supp_asos.SC_ASNIN_ITEM );
delete from supp_asos.SC_ASNIN  where ASN_NBR not in (select ASN_NBR from supp_asos.SC_ASNIN_ITEM );

delete from supp_asos.SC_ASNIN  where ASN_NBR not in (select ASN_NBR from supp_asos.SC_ASNIN_PO );
delete from supp_asos.SC_ASNIN_ITEM  where ASN_NBR not in (select ASN_NBR from supp_asos.SC_ASNIN_PO );

delete from supp_asos.SC_ASNIN_PO  where ASN_NBR not in (select ASN_NBR from supp_asos.SC_ASNIN );
delete from supp_asos.SC_ASNIN_ITEM  where ASN_NBR not in (select ASN_NBR from supp_asos.SC_ASNIN );


select trunc(CREATE_DATETIME),count(1) from SUPP_ASOS.sc_asnin where  trunc(CREATE_DATETIME) between '01-AUG-2018' and '30-OCT-2018' group by trunc(CREATE_DATETIME) order by 1;


select count(1) from supp_asos.SC_ASNIN where trunc(CREATE_DATETIME) between '01-AUG-2018' and '30-OCT-2018';
select count(1) from supp_asos.SC_ASNIN_PO  where ASN_NBR in 
    (select ASN_NBR from supp_asos.SC_ASNIN where trunc(CREATE_DATETIME) between '01-AUG-2018' and '30-OCT-2018');
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR in 
    (select ASN_NBR from supp_asos.SC_ASNIN where trunc(CREATE_DATETIME) between '01-AUG-2018' and '30-OCT-2018');

select * from supp_asos.ordhead where order_no in (select order_no from supp_asos.ordloc);
select * from supp_asos.ordloc where order_no not in (select order_no from supp_asos.ordhead);
select PO_NBR, count(1) from supp_asos.SC_ASNIN_PO group by PO_NBR having count(PO_NBR) >1;



set serveroutput on;
set timing on;
DECLARE

    o_error_message     VARCHAR2(255) := NULL;
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_asn_num           supp_asos.SC_ASNIN.ASN_NBR%type;
    l_order_no          supp_asos.SC_ASNIN_PO.PO_NBR%type;
    l_close_date        supp_asos.ordhead.close_date%type;
    l_supplier          supp_asos.ordhead.supplier%type;
    
    cursor c_ord is
	 	    select order_no, supplier, close_date
            from 
                (select oh.order_no,oh.supplier,oh.close_date from supp_asos.ordhead oh where  oh.status ='C' and 
                        oh.close_date between '01-AUG-2018' and '30-OCT-2018'
                        and exists (select 1 from supp_asos.shipment sh where sh.order_no= oh.order_no)) sn  where 
                            not exists (select 1 from supp_asos.SC_ASNIN_PO sap where sap.PO_NBR= sn.order_no)                
             --and rownum <= '30000' 
             order by 1;

BEGIN    

FOR k in c_ord loop
    l_order_no      :=  k.order_no;
    l_supplier      :=  k.supplier;
    l_close_date    :=  k.close_date;
       
         select  SUPP_ASOS.SC_ASN_SEQ.nextval||l_order_no into l_asn_num from dual;
            
                insert into supp_asos.SC_ASNIN (TO_LOCATION, ASN_NBR, ASN_TYPE, CONTAINER_QTY, BOL_NBR, SHIPMENT_DATE, EST_ARR_DATE, CARRIER_CODE, VENDOR_NBR, STATUS, CREATE_ID, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME)
                select DECODE(LOCATION, '1001', '1',
                            '4001', '4',
                            '3001', '3') to_loc,
                     l_asn_num,
                     0,1,
                     l_asn_num,
                     l_close_date,
                     l_close_date-1,
                     1,
                     l_supplier,
                     'A',
                     'PTESTUSER',
                     l_close_date-1,
                     'PTESTUSER',
                     l_close_date-1                     
                from supp_asos.ordloc oh
                where oh.order_no = l_order_no and rownum<='1';
             
                insert into supp_asos.SC_ASNIN_PO(ASN_NBR, PO_NBR, CREATE_ID, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME )
                values (l_asn_num,
                l_order_no,
                'PTESTUSER',
                l_close_date-1,
                'PTESTUSER',
                l_close_date-1);
                
                insert into supp_asos.SC_ASNIN_ITEM(ASN_NBR, PO_NBR, FINAL_LOCATION, ITEM_ID, UNIT_QTY, VPN, ORDER_LINE_NBR, DISTRO_NBR, CREATE_ID, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME)
                select  l_asn_num,
                order_no,
                LOCATION,
                ITEM,
                QTY_ORDERED,
                'PTUSER',
                rownum,
                null,
                'PTESTUSER',
                l_close_date-1,
                'PTESTUSER',
                l_close_date-1
                from supp_asos.ordloc oh
                where oh.order_no =l_order_no;
                
     counter   := counter + 1; 
		    c_commit :=c_commit + 1;
       IF MOD(c_commit, 100) = 0 THEN
        COMMIT;
       END IF;
	   
   END LOOP;
commit;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_asn_num           supp_asos.SC_ASNIN.ASN_NBR%type;
    
    cursor c_ord is
	select distinct ASN_NBR from supp_asos.SC_ASNIN_PO where PO_NBR in ();

BEGIN    

FOR k in c_ord loop
    l_asn_num    :=  k.ASN_NBR;
       
delete from supp_asos.SC_ASNIN_ITEM  where ASN_NBR = l_asn_num;
delete from supp_asos.SC_ASNIN  where ASN_NBR = l_asn_num;
delete  from supp_asos.SC_ASNIN_PO where ASN_NBR = l_asn_num;

     counter   := counter + 1; 
		    c_commit :=c_commit + 1;
       IF MOD(c_commit, 50) = 0 THEN
        COMMIT;
       END IF;
	   
   END LOOP;
commit;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/