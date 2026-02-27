select count(1) from SUPP_ASOS.sc_asnin  --2788
    where  CREATE_DATETIME >= to_date('24-MAR-2023 11.45', 'DD-MON-YYYY hh24:mi'); 





select count(*) from SUPP_ASOS.RAF_ASYNC_TASK; --81495678

select * from SUPP_ASOS.sc_supp_cfg;
select * from SUPP_ASOS.sc_system_options;

update SUPP_ASOS.sc_system_options set ASN_PUB_METHOD ='RIB';


select * from SUPP_ASOS.sc_event_message;
select count(1) from SUPP_ASOS.sc_event_message;
update SUPP_ASOS.sc_event_message set MAX_ATTEMPTS = MAX_ATTEMPTS+2;
update SUPP_ASOS.sc_event_message set ATTEMPT_COUNT ='4' where ATTEMPT_COUNT ='1';

select * from SUPP_ASOS.SC_EVENT_MESSAGE_FAILURE;


select * from SUPP_ASOS.SC_ORDER_LOCK;
delete from SUPP_ASOS.SC_ORDER_LOCK;
commit;

select * from all_tables where table_name like '%UPL%';
select * from SYSTEM_PRIVILEGE_MAP;
select * from TABLE_PRIVILEGE_MAP;
select * from USER_PRIVILEGE_MAP;


select ORDER_NO from SUPP_ASOS.ordhead oh where oh.status ='A' and oh.supplier = '1100000086' 
        and oh.CREATE_DATETIME >= to_date('15-MAR-2021 14:15', 'DD-MON-YYYY hh24:mi')
    and not exists (select 1 from SUPP_ASOS.SC_ASNIN_PO asp where  asp.PO_NBR = oh.order_no) order by 1; 

--2533 Create asn --

select STATUS,count(1) from SUPP_ASOS.sc_asnin group by status; --2788


select * from SUPP_ASOS.sc_asnin  --2788
    where  CREATE_DATETIME >= to_date('04-JUN-2021 09:15', 'DD-MON-YYYY hh24:mi'); 

--Amend asn ---- 1800
select count(*) from SUPP_ASOS.sc_asnin --520
    where  trunc(CREATE_DATETIME) <> trunc(LAST_UPDATE_DATETIME)
    and LAST_UPDATE_DATETIME >= to_date('04-MAR-2021 14:15', 'DD-MON-YYYY hh24:mi'); 


select order_no from supp_asos.ordhead where trunc(CREATE_DATETIME) = '22-OCT-2020';

db.getCollection('exportedRetailCashandSales').find({"_id":"19853000088286"})
db.getCollection('exportedASNIn').find({"_id":"12853107135400"})

select oh.order_no,oh.po_type,oh.MASTER_PO_NO,asp.ASN_NBR from supp_asos.ordhead oh, SUPP_ASOS.SC_ASNIN_PO asp where oh.master_po_no = '123543'
    and oh.order_no = asp.PO_NBR;

select * from supp_asos.alloc_header where order_no in (select order_no from supp_asos.ordhead oh  where oh.master_po_no = '123321');
select * from supp_asos.ordhead oh  where oh.master_po_no = '605864';

select * from supp_asos.SC_ASNIN_PO where ASN_NBR ='12853107135400';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='12853107135400';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='12853107135400';

select count(PO_NBR) from SUPP_ASOS.SC_ASNIN_PO  asp where  --CREATE_ID like 'PTESTUSER%' and
    not exists (select 1 from SUPP_ASOS.ordhead oh where oh.ORDER_NO = ASP.PO_NBR) ;    

select count(1) from SUPP_ASOS.SC_ORDER_LOCK;
select * from SUPP_ASOS.SC_ASNIN_PO asp where exists (select 1 from supp_asos.ordhead oh where oh.order_no = asp.PO_NBR);

select oh.order_no,oh.MASTER_PO_NO,asp.ASN_NBR from supp_asos.ordhead oh, SUPP_ASOS.SC_ASNIN_PO asp 
    where oh.master_po_no = '617267' and oh.order_no = asp.PO_NBR(+);

select oh.order_no,oh.MASTER_PO_NO,asp.ASN from supp_asos.ordhead oh, SUPP_ASOS.shipment asp 
    where oh.master_po_no = '617267' and oh.order_no = asp.order_no(+);


select * from supp_asos.SC_ASNIN_PO where ASN_NBR ='12853001201223';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='12853001201223';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='12853001201223';

exec system.killsession ('2');

SELECT SUPP_ASOS.SC_ASN_SEQ.nextval FROM dual;


set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  VARCHAR2(25);
  curr_seq   VARCHAR2(25);
BEGIN
  SELECT 53151001023 INTO last_used FROM dual;

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

set SERVEROUTPUT ON;
set timing on;
DECLARE
  l_date   supp_asos.ordhead.PICKUP_DATE%type := '29-MAY-2021';

BEGIN

]Update supp_asos.ordhead set PICKUP_DATE = l_date,EARLIEST_SHIP_DATE =l_date,LATEST_SHIP_DATE = l_date+1,
    NOT_BEFORE_DATE=l_date+2,NOT_AFTER_DATE=l_date+3 where order_no in 
        (select distinct po_nbr from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%'
--    and exists (select 1 from SUPP_ASOS.ordhead oh where oh.status ='A' and asp.PO_NBR = oh.order_no and oh.order_no between 50000831767 and 50000899259)
    and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR and sa.SHIPMENT_DATE >'28-MAY-2020'));
    
update supp_asos.SC_ASNIN set SHIPMENT_DATE =l_date, EST_ARR_DATE =l_date where asn_nbr in 
(select distinct asn_nbr from supp_asos.SC_ASNIN_PO where CREATE_ID like 'PTESTUSER%' and PO_NBR in 
    (select distinct po_nbr from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%'
--    and exists (select 1 from SUPP_ASOS.ordhead oh where oh.status ='A' and asp.PO_NBR = oh.order_no and oh.order_no between 50000831767 and 50000899259)
    and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR and sa.SHIPMENT_DATE >'28-MAY-2020')));
    
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


select * from SUPP_ASOS.ordhead oh where oh.status ='A' and oh.supplier = '1100000086' 
    and not exists (select 1 from SUPP_ASOS.SC_ASNIN_PO asp where  CREATE_ID like 'PTESTUSER%'  and asp.PO_NBR = oh.order_no) order by 1; 


select order_no,status,PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_handover_start,
        LATEST_SHIP_DATE as  expected_handover_end,
        NOT_BEFORE_DATE as expected_shipment_date,
        NOT_AFTER_DATE as expected_Delivery_date
 from supp_asos.ordhead where  status ='A' and PICKUP_DATE is null;
    
select * from supp_asos.ordhead where order_no ='500004285000' ;
select * from supp_asos.ordloc where order_no ='50004614282';
select * from supp_asos.shipment where  order_no ='50000831767';
select * from supp_asos.shipsku where shipment ='23586410';





       select distinct ASN_NBR from supp_asos.SC_ASNIN_PO where PO_NBR in 
                (select distinct PO_NBR from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%' 
                            and exists (select 1 from SUPP_ASOS.ordhead oh where asp.PO_NBR = oh.order_no) 
                            and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR))
            and rowid not in
                (SELECT MIN(rowid)
            FROM supp_asos.SC_ASNIN_PO where PO_NBR in (select distinct PO_NBR from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%' 
            and exists (select 1 from SUPP_ASOS.ordhead oh where  asp.PO_NBR = oh.order_no ) 
            and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR))
                GROUP BY PO_NBR);

500900416382 with 2 ASNS: 12852244401507, 12852244401533

select * from supp_asos.SC_ASNIN_PO where ASN_NBR ='20053106233974';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='20053106233974';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='20053106233974';
select * from supp_asos.shipment where  asn ='20053106233974';

db.getCollection('exportedPurchaseOrder').find({})

db.getCollection('exportedbaseproduct').find({"ItemNo":"106893375"})
db.getCollection('exportedItemLocation').find({"OptionItemID":"106893375"})

select * from rms.item_master where status ='A' and item_level ='1' and Item_DESC LIKE '%Item creation Perf Test%'
        and CREATE_DATETIME>= to_date('28-MAY-2021 12.59', 'DD-MON-YYYY hh24:mi');


set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_asn_num           supp_asos.SC_ASNIN.ASN_NBR%type;
    
    cursor c_ord is
       select distinct ASN_NBR from supp_asos.SC_ASNIN_PO where PO_NBR in 
                (select distinct PO_NBR from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%' 
                            and exists (select 1 from SUPP_ASOS.ordhead oh where asp.PO_NBR = oh.order_no) 
                            and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR))
            and rowid not in
                (SELECT MIN(rowid)
            FROM supp_asos.SC_ASNIN_PO where PO_NBR in (select distinct PO_NBR from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%' 
            and exists (select 1 from SUPP_ASOS.ordhead oh where asp.PO_NBR = oh.order_no ) 
            and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR))
                GROUP BY PO_NBR);

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


500004285000		

select distinct 'PTESTUSER225',oh.supplier,'Y','Y','Y','Y'
    from SUPP_ASOS.ordhead oh
    where trunc(oh.ORIG_APPROVAL_DATE) >= '02-MAR-2019'
        and oh.status = 'A'
        and oh.supplier = '1100000086'
        and oh.ORIG_APPROVAL_ID like 'PTESTUSER%'


select distinct 'PTESTUSER225',oh.supplier,'Y','Y','Y','Y'
    from SUPP_ASOS.ordhead oh
    where trunc(oh.ORIG_APPROVAL_DATE) >= '02-MAR-2019'
        and oh.status = 'A'
        and oh.supplier = '1100000086'
        and oh.ORIG_APPROVAL_ID like 'PTESTUSER%'
        and not exists (select 1 from SUPP_ASOS.SC_SUPP_USERS_CFG sg where sg.SUPP_ID= oh.supplier and username like 'PTESTUSER225');
        
        
select * from SUPP_ASOS.SC_SUPP_USERS_CFG where USERNAME like 'PTESTUSER300%';
select USERNAME,count(1) from SUPP_ASOS.SC_SUPP_USERS_CFG where USERNAME like 'SKUMAR%' group by USERNAME;
select USERNAME,count(1) from SUPP_ASOS.SC_SUPP_USERS_CFG where USERNAME like 'PTESTUSER%' group by USERNAME;

delete from SUPP_ASOS.SC_SUPP_USERS_CFG where USERNAME like 'PTESTUSER%' and SUPP_ID = '1100005074';

set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_supplier          supp_asos.SC_SUPP_USERS_CFG.USERNAME%type;
    l_supp          supp_asos.SC_SUPP_USERS_CFG.USERNAME%type;  
Begin 

for supnum in 300.. 350 loop        

select 'PTESTUSER'||supnum into l_supplier from dual;

insert into SUPP_ASOS.SC_SUPP_USERS_CFG
select distinct l_supplier,oh.supplier,'Y','Y','Y','Y'
    from SUPP_ASOS.ordhead oh
    where trunc(oh.ORIG_APPROVAL_DATE) >= '02-MAR-2019'
        and oh.status = 'A'
        and oh.supplier = '1100000952' --1100000952 & 1100004710
        --and oh.ORIG_APPROVAL_ID like 'PTESTUSER%'
        and not exists (select 1 from SUPP_ASOS.SC_SUPP_USERS_CFG sg where sg.SUPP_ID= oh.supplier and username =l_supplier);

END LOOP;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/
