select * from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt)) and RECEIVE_DATE is null ;
select count(1) from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt);

select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt)) and RECEIVE_DATE is not null ;
select count(1) from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt) and qty_received > '0';

select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt)) and RECEIVE_DATE is not null ;
select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt)) and RECEIVE_DATE is null ;

select * from rib_message where MESSAGE_NUM>'65989955' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM>'65989955' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM>'65989955' group by FAMILY order by 1 desc;

select count(1) from skumar.iwtreceipt;


select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt2whl)) and RECEIVE_DATE is not null 
union
select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt)) and RECEIVE_DATE is not null;    

select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt2whl)) and RECEIVE_DATE is null 
union
select count(1) from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt)) and RECEIVE_DATE is null;    
   

select from_loc,TO_LOC,count(1) from rms.shipment 
    where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.IWTDISPATH_BOTH)) and RECEIVE_DATE is not null 
group by from_loc,TO_LOC;    

select * from rib_message order by 1 desc;
select * from rib_message where MESSAGE_NUM>'65989735' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM>'65989735' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM>'65989735' group by FAMILY order by 1 desc;

select * from rib_message where MESSAGE_NUM = '65989735';
select * from rib_message_failure where MESSAGE_NUM = '65989735';

select * from shipsku sk where sk.carton = 'B8029360990';
select * from shipment where shipment = '381449278'; --RC42B80293606408029360640 --7 --RC42B8029360640118029360640
select * from shipsku where shipment = '381449278'; --RC42B80293606408029360640 --7 --RC42B8029360640118029360640


select FROM_LOC,count(1) from skumar.cust_tsf_upld group by FROM_LOC;
delete from iwtdispath where tsf_no not in (select tsf_no from tsfhead);
delete from iwtreceipt where tsf_no not in (select tsf_no from tsfhead);
delete from iwtdispath where tsf_no in (select tsf_no from tsfhead where status!= 'A');
delete from iwtreceipt where tsf_no in (select tsf_no from tsfhead where status!= 'A');
delete from iwtreceipt2Whl where tsf_no in (select tsf_no from tsfhead where status!= 'A');
delete from iwtreceipt2Whl where tsf_no in (select tsf_no from tsfhead where status!= 'A');

select count(1) from skumar.iwtreceipt;
select count(1) from skumar.iwtreceipt2Whl;
select count(1) from skumar.iwtreceipt;
select count(1) from skumar.iwtreceipt2Whl;


create table iwtreceipt1 as 
select * from skumar.iwtreceipt where rownum <= '4';
create table iwtreceipt2Whl1 as 
select * from skumar.iwtreceipt2Whl where rownum <= '4';

select count(1) from skumar.iwtreceipt2Whl;



select * from skumar.vpt_logs;
select * from skumar.IWTDISPATH_BOTH;
select * from tsfhead where tsf_no in (select tsf_no from iwtdispath);
select count(1)from tsfhead where tsf_no in (select tsf_no from iwtdispath);
select count(1) from tsfhead where tsf_no in (select tsf_no from iwtreceipt);

delete from skumar.iwtreceipt;
delete from skumar.iwtdispath;
select count(tsf_no) from iwtdispath where tsf_no in (select tsf_no from tsfhead where status= 'A');
select tsf_no  from iwtdispath;

select count(tsf_no) from iwtdispath where tsf_no in (select tsf_no from tsfhead where status = 'I' and to_loc in (select wh from wh where channel_id = '1'));
select count(tsf_no) from iwtdispath where tsf_no in (select tsf_no from tsfhead where status = 'I' and to_loc in (select wh from wh where channel_id = '2'));
select count(tsf_no) from iwtdispath where tsf_no in (select tsf_no from tsfhead where status = 'A' and to_loc in (select wh from wh where channel_id = '1'));
select count(tsf_no) from iwtdispath where tsf_no in (select tsf_no from tsfhead where status = 'A' and to_loc in (select wh from wh where channel_id = '2'));


drop table skumar.iwtreceipt2Whl;
create table skumar.iwtreceipt2Whl as 
select tsf_no from IWTDISPATH_BOTH where tsf_no in (select tsf_no from tsfhead where status = 'A' and to_loc in (select wh from wh where channel_id = '2'));
drop table skumar.iwtreceipt;
create table skumar.iwtreceipt as 
select tsf_no from IWTDISPATH_BOTH where tsf_no in (select tsf_no from tsfhead where status = 'A' and to_loc in (select wh from wh where channel_id = '1'));

drop table skumar.iwtdispath_both;
create table iwtdispath_both as 
select tsf_no from iwtreceipt
union
select tsf_no from iwtreceipt2Whl;


select * from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.IWTDISPATH_BOTH));    

select * from shipsku sk where shipment = '381449268';
select * from rms.shipment where shipment ='381449268';

select * from rms.shipment where bol_no ='';


select count(distinct CARTON) as Boxid from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt2whl);
select count(distinct CARTON) as Boxid from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt);


select distinct CARTON as Boxid,sk.distro_no as tsf_no, sk.ITEM, sk.QTY_EXPECTED as quantity from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt) order by CARTON;

select FROM_LOC, TO_LOC,count(1) from tsfhead where status = 'A' and tsf_no in (select tsf_no from iwtreceipt) group by FROM_LOC, TO_LOC;
select FROM_LOC, TO_LOC,count(1) from tsfhead where status = 'A' and tsf_no in (select tsf_no from iwtreceipt2Whl) group by FROM_LOC, TO_LOC;



select * from iwtreceipt 
union
select * from iwtreceipt2Whl;


select distinct CARTON as Boxid,sk.distro_no as tsf_no, sk.ITEM, sk.QTY_EXPECTED as quantity from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt) order by CARTON;
select distinct th.tsf_no,BOL_NO as Consignment, TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' as dateReceivedUtc, w.WH_NAME_SECONDARY as ReceivingWarehouseId from  rms.shipment sh, rms.shipsku sk, rms.tsfhead th, rms.wh w where th.tsf_no = sk.distro_no and sh.shipment = sk.shipment and sh.TO_LOC = w.wh and th.tsf_no in (select tsf_no from skumar.iwtreceipt) order by 1;


select distinct CARTON as Boxid,sk.distro_no as tsf_no, sk.ITEM, sk.QTY_EXPECTED as quantity from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt2Whl) order by CARTON;
select distinct th.tsf_no,BOL_NO as Consignment, TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' as dateReceivedUtc, w.WH_NAME_SECONDARY as ReceivingWarehouseId from  rms.shipment sh, rms.shipsku sk, rms.tsfhead th, rms.wh w where th.tsf_no = sk.distro_no and sh.shipment = sk.shipment and sh.TO_LOC = w.wh and th.tsf_no in (select tsf_no from skumar.iwtreceipt2Whl) order by 1;

select * from iwtreceipt where tsf_no in (select tsf_no from tsfhead where status = 'S'); 

select * from iwtreceipt where tsf_no in (select tsf_no from tsfhead where status = 'S' and to_loc in (select wh from wh where channel_id = '2'));



select th.TO_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtreceipt) group by th.TO_LOC;
select th.FROM_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtreceipt) group by th.FROM_LOC;


<?xml version="1.0" encoding="UTF-8"?>
<IWTReceipt xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xsi:noNamespaceSchemaLocation="IWT Receipt.xsd">
    <Receipt>
        <ReceivingWarehouseId>FC03</ReceivingWarehouseId>
        <Consignments>
            <Consignment id="51130471461534982400" dateReceivedUtc="2018-01-08T11:58:47Z">
                <Box id="7641796325"/>
            <Consignments>
    </Receipt>
</IWTReceipt>

select count(1) from rms.tsfHEAD td
    where td.tsf_no in (select tsf_no from skumar.iwtreceipt);

-- drop table iwtreceipt;
-- 
create table iwtreceipt as
    select tsf_no from tsfhead where 1=2;

select tsf_no from skumar.iwtreceipt where tsf_no between 7000578813 and 7000578821;

select count(1) from rms.tsfHEAD td where td.tsf_no in (select tsf_no from skumar.iwtreceipt);
select FROM_LOC,count(1) from rms.tsfHEAD td where td.tsf_no in (select tsf_no from skumar.IWTDISPATH_BOTH) group by FROM_LOC;

insert into iwtreceipt
select * from( 
    select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='1001' 
        and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no ) and rownum <= '10');

select * from rms.wh;

delete from skumar.iwtdispath;
delete from skumar.iwtreceipt;

drop table iwtreceipt;
create table iwtreceipt as
select tsf_no from tsfhead th where 1=2;

select * from iwtreceipt;

select FROM_LOC,count(1) from rms.tsfHEAD td where td.tsf_no in (select tsf_no from skumar.IWTDISPATH_BOTH) group by FROM_LOC;

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtreceipt TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtreceipt TO RMS; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtreceipt2Whl TO RMS; 

select count(1) from skumar.iwtreceipt;
update rms.shipsku sk set CARTON = CARTON where sk.distro_no in (select tsf_no from skumar.iwtreceipt);


delete from skumar.iwtreceipt where tsf_no not in (select tsf_no from tsfhead);
delete from skumar.iwtreceipt where tsf_no in (select tsf_no from tsfhead where status ='I');
delete from skumar.iwtreceipt where tsf_no in (select distro_no from shipsku);

select FROM_LOC,count(1) from rms.tsfHEAD td
    where td.tsf_no in (select tsf_no from skumar.iwtreceipt) group by FROM_LOC;
    

select * from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt2whl));    
select * from rms.shipment where shipment in (select shipment from shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt));    

select count(distinct CARTON) as Boxid from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt);
    
    
select  distinct th.tsf_no,BOL_NO as Consignment, TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' as dateReceivedUtc, w.WH_NAME_SECONDARY as ReceivingWarehouseId 
    from  rms.shipment sh, rms.shipsku sk, rms.tsfhead th, rms.wh w where th.tsf_no = sk.distro_no and sh.shipment = sk.shipment and sh.TO_LOC = w.wh and
    th.tsf_no in (select tsf_no from skumar.iwtreceipt) order by 1 ;
select distinct CARTON as Boxid,sk.distro_no as tsf_no from rms.shipsku sk where sk.distro_no in (select tsf_no from skumar.iwtreceipt) order by CARTON;




select * from skumar.iwtreceipt; --B70005790563

db.getCollection('exportedIwtReceipt').find({})
db.getCollection('exportedIwtReceipt').find({"consignmentId":"V7271445307"})

select * from rib_message;
-- Validations 
select  distinct sh.status_code,BOL_NO as Consignment, TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' as dateReceivedUtc, w.WH_NAME_SECONDARY as ReceivingWarehouseId 
    from  rms.shipment sh, rms.shipsku sk, rms.tsfhead th, rms.wh w where th.tsf_no = sk.distro_no and sh.shipment = sk.shipment and sh.TO_LOC = w.wh and
    th.tsf_no in (select tsf_no from skumar.iwtreceipt) and sh.status_code!='I';

select count(1) from doc_close_queue where doc in (select tsf_no from skumar.iwtreceipt) and doc_type ='T';

select sh.status_code,count(1)
    from  rms.shipment sh, rms.shipsku sk, rms.tsfhead th where th.tsf_no = sk.distro_no and sh.shipment = sk.shipment  
    and  th.tsf_no in (select tsf_no from skumar.iwtreceipt) group by sh.status_code ;

select * from tsfhead where tsf_no in ('7000578813','7000578817','7000578821');
select * from tsfdetail where tsf_no in ('7000578813','7000578817','7000578821');
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in ('7000578813','7000578817','7000578821'));
select * from shipSKU where DISTRO_NO in ('7000578813','7000578817','7000578821');

select * from rib_message  order by 1 desc;
select * from rib_message where MESSAGE_NUM >'11633443' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM >'11633443' order by 1 desc;

select th.TO_LOC, count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtreceipt) group by th.TO_LOC;
select th.FROM_LOC, count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtreceipt) group by th.FROM_LOC;

select th.TO_LOC, count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtreceipt2Whl) group by th.TO_LOC;
select th.FROM_LOC, count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtreceipt2Whl) group by th.FROM_LOC;


delete from skumar.iwtreceipt where tsf_no not in (select tsf_no from tsfhead);
delete from skumar.iwtreceipt where tsf_no in (select tsf_no from tsfhead where status ='I');
delete from skumar.iwtreceipt where tsf_no in (select distro_no from shipsku);
delete from skumar.iwtreceipt2Whl where tsf_no not in (select tsf_no from tsfhead);
delete from skumar.iwtreceipt2Whl where tsf_no in (select tsf_no from tsfhead where status ='I');
delete from skumar.iwtreceipt2Whl where tsf_no in (select distro_no from shipsku);






alter session set current_schema=rms;

set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 300;
  counter               NUMBER(10)                    := 0;

  O_status_code         varchar2(1);
  O_error_message       varchar2(300);
  l_delivery_date       rms.tsfhead.delivery_date%type;
  L_tsf_no              rms.tsfhead.tsf_no%type;
  k_tsf_no              rms.tsfhead.tsf_no%type    ;
  n_from_loc            rms.tsfhead.from_loc%TYPE      := '1001';
  n_to_loc              rms.tsfhead.to_loc%TYPE;
  n_from_loc_type       rms.tsfhead.from_loc_type%TYPE  := 'W';
  L_return_code         VARCHAR2(20);
  O_status              VARCHAR2(20);
  I_MESSAGE_TYPE        VARCHAR2(20) := 'xtsfcre';
  
   TYPE ITEM_REC IS RECORD
    (item rms.tsfdetail.item%TYPE,
     tsf_qty rms.tsfdetail.tsf_qty%TYPE);
    
  TYPE ITEM_INFO IS TABLE OF ITEM_REC;
  P_ITEM_REC ITEM_INFO; 

  L_RIB_XTsfDesc_REC  "RIB_XTsfDesc_REC";
  l_RIB_XTsfDtl_TBL   "RIB_XTsfDtl_TBL";
  l_RIB_XTsfDtl_REC   "RIB_XTsfDtl_REC";
  M_TSFHEAD_REC       "RIB_XTsfDtl_REC";
  
  CURSOR cur_wh IS 	
    select 	wh2.wh from rms.wh wh1, rms.wh wh2 
  	where 	wh1.org_unit_id!=wh2.org_unit_id and wh1.wh = n_from_loc and wh2.channel_id ='2'
    ORDER BY dbms_random.value; 
 

  CURSOR cur_item IS    
   select im.ITEM_ID, '1' as tsf_qty
    from skumar.cust_tsf_upld im 
      where FROM_LOC= n_from_loc 
          and QUANTITY >= '50'
          AND not exists (select 1 from rms.tsfdetail td, tsfhead th where th.tsf_no >= k_tsf_no and th.tsf_no = td.tsf_no and td.item = im.item_id and th.from_loc= n_from_loc)
          AND rownum<= 7 ORDER BY DBMS_RANDOM.VALUE;
  
BEGIN

select vdate INTO l_delivery_date from rms.period;
select rms.TRANSFER_NUMBER_SEQUENCE.nextval into k_tsf_no from dual;


 WHILE counter < num_rec LOOP
  
       for i in cur_wh loop
            n_to_loc := i.wh;
    
                l_RIB_XTsfDtl_REC  := "RIB_XTsfDtl_REC"(null,null,null);
			    l_RIB_XTsfDtl_TBL := "RIB_XTsfDtl_TBL"();
								
		    open cur_item;
            fetch cur_item BULK COLLECT INTO P_ITEM_REC;
            close cur_item;
		
		FOR i IN 1..P_ITEM_REC.COUNT LOOP
        
		l_RIB_XTsfDtl_REC.rib_oid     := 0;	   
		l_RIB_XTsfDtl_REC.item        := P_ITEM_REC(i).item;
        l_RIB_XTsfDtl_REC.tsf_qty	  := P_ITEM_REC(i).tsf_qty;
            
			l_RIB_XTsfDtl_TBL.EXTEND();
			l_RIB_XTsfDtl_TBL(l_RIB_XTsfDtl_TBL.COUNT) := l_RIB_XTsfDtl_REC;
			
        END LOOP;
            
            RMS.NEXT_TRANSFER_NUMBER (L_tsf_no,L_return_code,O_error_message);
            L_RIB_XTsfDesc_REC  := "RIB_XTsfDesc_REC"(0,null,null,null,null,null,null,null,null,null,null,null,null);
	
			L_RIB_XTsfDesc_REC.rib_oid        := 0;
            L_RIB_XTsfDesc_REC.tsf_no         := L_tsf_no;
            L_RIB_XTsfDesc_REC.from_loc_type  := n_from_loc_type;
            L_RIB_XTsfDesc_REC.from_loc       := n_from_loc;
            L_RIB_XTsfDesc_REC.to_loc_type    := n_from_loc_type;
            L_RIB_XTsfDesc_REC.to_loc         := n_to_loc;
            L_RIB_XTsfDesc_REC.delivery_date  := l_delivery_date;
            L_RIB_XTsfDesc_REC.dept           := null;
            L_RIB_XTsfDesc_REC.routing_code   := null;
            L_RIB_XTsfDesc_REC.freight_code   := null;
            L_RIB_XTsfDesc_REC.tsf_type       := 'IC';
            L_RIB_XTsfDesc_REC.status         := 'A';
            L_RIB_XTsfDesc_REC.user_id        := 'PTUSER';
            L_RIB_XTsfDesc_REC.comment_desc   := 'IWTRECEIPT';
            L_RIB_XTsfDesc_REC.XTsfDtl_TBL    := l_RIB_XTsfDtl_TBL;

     
   
         RMS.RMSSUB_XTSF.CONSUME(O_status,O_error_message,L_RIB_XTsfDesc_REC,I_MESSAGE_TYPE);

           IF O_status_code = 'E' then 
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','FAILED',L_tsf_no, O_status_code,O_error_message);
                 
            else  
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','SUCCESS',L_tsf_no,O_status_code,O_error_message);

			INSERT INTO SKUMAR.iwtreceipt2Whl (tsf_no) values (L_tsf_no) ;   
            
        END IF;   

     counter   := counter + 1;
    END LOOP;
    commit;
    END LOOP;
    
  --commit;
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END; 
/


alter session set current_schema=rms;

set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 20;
  counter               NUMBER(10)                    := 0;

  O_status_code         varchar2(1);
  O_error_message       varchar2(300);
  l_delivery_date       rms.tsfhead.delivery_date%type;
  L_tsf_no              rms.tsfhead.tsf_no%type;
  k_tsf_no              rms.tsfhead.tsf_no%type    ;
  n_from_loc            rms.tsfhead.from_loc%TYPE      := '1001';
  n_to_loc              rms.tsfhead.to_loc%TYPE;
  n_from_loc_type       rms.tsfhead.from_loc_type%TYPE  := 'W';
  L_return_code         VARCHAR2(20);
  O_status              VARCHAR2(20);
  I_MESSAGE_TYPE        VARCHAR2(20) := 'xtsfcre';
  
   TYPE ITEM_REC IS RECORD
    (item rms.tsfdetail.item%TYPE,
     tsf_qty rms.tsfdetail.tsf_qty%TYPE);
    
  TYPE ITEM_INFO IS TABLE OF ITEM_REC;
  P_ITEM_REC ITEM_INFO; 

  L_RIB_XTsfDesc_REC  "RIB_XTsfDesc_REC";
  l_RIB_XTsfDtl_TBL   "RIB_XTsfDtl_TBL";
  l_RIB_XTsfDtl_REC   "RIB_XTsfDtl_REC";
  M_TSFHEAD_REC       "RIB_XTsfDtl_REC";
  
  CURSOR cur_wh IS 	
    select 	wh2.wh from rms.wh wh1, rms.wh wh2 
  	where 	wh1.org_unit_id!=wh2.org_unit_id and wh1.wh = n_from_loc and wh2.channel_id ='1'
    ORDER BY dbms_random.value; 
 

  CURSOR cur_item IS    
   select im.ITEM_ID, '1' as tsf_qty
    from skumar.cust_tsf_upld im 
      where FROM_LOC= n_from_loc 
          and QUANTITY >= '50'
          AND not exists (select 1 from rms.tsfdetail td, tsfhead th where th.tsf_no >= k_tsf_no and th.tsf_no = td.tsf_no and td.item = im.item_id and th.from_loc= n_from_loc)
          AND rownum<= 7 ORDER BY DBMS_RANDOM.VALUE;
  
BEGIN

select vdate INTO l_delivery_date from rms.period;
select rms.TRANSFER_NUMBER_SEQUENCE.nextval into k_tsf_no from dual;


 WHILE counter < num_rec LOOP
  
       for i in cur_wh loop
            n_to_loc := i.wh;
    
                l_RIB_XTsfDtl_REC  := "RIB_XTsfDtl_REC"(null,null,null);
			    l_RIB_XTsfDtl_TBL := "RIB_XTsfDtl_TBL"();
								
		    open cur_item;
            fetch cur_item BULK COLLECT INTO P_ITEM_REC;
            close cur_item;
		
		FOR i IN 1..P_ITEM_REC.COUNT LOOP
        
		l_RIB_XTsfDtl_REC.rib_oid     := 0;	   
		l_RIB_XTsfDtl_REC.item        := P_ITEM_REC(i).item;
        l_RIB_XTsfDtl_REC.tsf_qty	  := P_ITEM_REC(i).tsf_qty;
            
			l_RIB_XTsfDtl_TBL.EXTEND();
			l_RIB_XTsfDtl_TBL(l_RIB_XTsfDtl_TBL.COUNT) := l_RIB_XTsfDtl_REC;
			
        END LOOP;
            
            RMS.NEXT_TRANSFER_NUMBER (L_tsf_no,L_return_code,O_error_message);
            L_RIB_XTsfDesc_REC  := "RIB_XTsfDesc_REC"(0,null,null,null,null,null,null,null,null,null,null,null,null);
	
			L_RIB_XTsfDesc_REC.rib_oid        := 0;
            L_RIB_XTsfDesc_REC.tsf_no         := L_tsf_no;
            L_RIB_XTsfDesc_REC.from_loc_type  := n_from_loc_type;
            L_RIB_XTsfDesc_REC.from_loc       := n_from_loc;
            L_RIB_XTsfDesc_REC.to_loc_type    := n_from_loc_type;
            L_RIB_XTsfDesc_REC.to_loc         := n_to_loc;
            L_RIB_XTsfDesc_REC.delivery_date  := l_delivery_date;
            L_RIB_XTsfDesc_REC.dept           := null;
            L_RIB_XTsfDesc_REC.routing_code   := null;
            L_RIB_XTsfDesc_REC.freight_code   := null;
            L_RIB_XTsfDesc_REC.tsf_type       := 'IC';
            L_RIB_XTsfDesc_REC.status         := 'A';
            L_RIB_XTsfDesc_REC.user_id        := 'PTUSER';
            L_RIB_XTsfDesc_REC.comment_desc   := 'IWTRECEIPT';
            L_RIB_XTsfDesc_REC.XTsfDtl_TBL    := l_RIB_XTsfDtl_TBL;

     
   
         RMS.RMSSUB_XTSF.CONSUME(O_status,O_error_message,L_RIB_XTsfDesc_REC,I_MESSAGE_TYPE);

           IF O_status_code = 'E' then 
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','FAILED',L_tsf_no, O_status_code,O_error_message);
                 
            else  
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','SUCCESS',L_tsf_no,O_status_code,O_error_message);

			INSERT INTO SKUMAR.iwtreceipt (tsf_no) values (L_tsf_no) ;   
            
        END IF;   

     counter   := counter + 1;
    END LOOP;
    commit;
    END LOOP;
    
  --commit;
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END; 
/


--shipment 
alter session set current_schema=rms;

SET SERVEROUTPUT ON;
SET timing ON;

DECLARE
  counter               NUMBER(10)                    := 0;
  c_commit  	        NUMBER(10)                     := 0;
  
  O_status_code     varchar2(1);
  O_error_message   varchar2(300);
  I_message_type    varchar2(10):= 'asnoutcre';
  l_asn         varchar2(25);
  l_date 			date;  
  i 				number;
  k 				number;

	L_RIB_ASNOutDesc_REC		"RIB_ASNOutDesc_REC";
	L_RIB_ASNOutDistro_TBL 		"RIB_ASNOutDistro_TBL";
	L_RIB_ASNOutDistro_REC 		"RIB_ASNOutDistro_REC";
	L_RIB_ASNOutCtn_TBL 		"RIB_ASNOutCtn_TBL";
	L_RIB_ASNOutCtn_REC  		"RIB_ASNOutCtn_REC"	; --:= NULL; 	
	L_RIB_ASNOutItem_TBL 		"RIB_ASNOutItem_TBL";
	L_RIB_ASNOutItem_REC		"RIB_ASNOutItem_REC";--:= NULL;
    
    
    l_RIB_ASNOutUIN_TBL         "RIB_ASNOutUIN_TBL"  := null;
    l_RIB_ASNOutUIN_REC         "RIB_ASNOutUIN_REC"  := null;
    
    
  CURSOR tsfship
  IS
	select tsf_no,from_loc_type,to_loc_type,from_loc,to_loc from (
	SELECT     distinct th.tsf_no,
				th.from_loc_type,
				th.to_loc_type,
				th.from_loc,
				th.to_loc
	FROM      rms.tsfhead th
	WHERE     th.status     = 'A'
    and 	not exists (select 1 from rms.shipsku sh where sh.distro_no=th.tsf_no));
	and 	exists (select 1 from SKUMAR.iwtdispath_both where tsf_no =th.tsf_no) order by 1);

CURSOR tsfship_item(i_tsf_no rms.tsfhead.tsf_no%type)
IS    
			select td.item, 
					td.tsf_qty  as tsf_qty
			from rms.tsfdetail td 
			where td.tsf_no=i_tsf_no;
			

  l_tsf_no   			rms.tsfhead.tsf_no%type;
  l_tsf_qty				rms.tsfdetail.tsf_qty%type;
  l_from_loc_type		rms.tsfhead.from_loc_type%type;
  l_from_loc            rms.tsfhead.from_loc%type;
  l_to_loc              rms.tsfhead.to_loc%type;
  l_to_loc_type			rms.tsfhead.to_loc_type%type;
  l_ship_qty	 	    rms.tsfdetail.ship_qty%type;
  l_item			  	rms.item_master.item%type;  
  
BEGIN


select vdate into l_date from rms.period;

	FOR i IN tsfship LOOP
	
			l_tsf_no  		  := i.tsf_no;
			l_from_loc_type   := i.from_loc_type;
			l_to_loc_type     := i.to_loc_type;

            select PHYSICAL_WH into l_from_loc from rms.wh where wh = i.from_loc;
            select PHYSICAL_WH into l_to_loc from rms.wh where wh = i.to_loc;
            select w.WH_NAME_SECONDARY ||'B'||l_tsf_no||l_tsf_no into l_asn from wh w where wh = i.to_loc;
             
			           
	l_RIB_ASNOutUIN_REC := "RIB_ASNOutUIN_REC"('0',null);
	l_RIB_ASNOutUIN_TBL := "RIB_ASNOutUIN_TBL"();
    
    l_RIB_ASNOutUIN_TBL.EXTEND();
    l_RIB_ASNOutUIN_TBL(l_RIB_ASNOutUIN_TBL.COUNT) := l_RIB_ASNOutUIN_REC; 
    
    
    L_RIB_ASNOutItem_REC := "RIB_ASNOutItem_REC"(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
	L_RIB_ASNOutItem_TBL := "RIB_ASNOutItem_TBL"();
    
	FOR k IN tsfship_item(l_tsf_no) LOOP
  
			l_item  		:= 	k.item;
			l_tsf_qty       := 	k.tsf_qty;
			
			L_RIB_ASNOutItem_REC.item_id 					:=	l_item;
			L_RIB_ASNOutItem_REC.unit_qty 					:=	l_tsf_qty;
			L_RIB_ASNOutItem_REC.gross_cost 				:=	NULL;
			L_RIB_ASNOutItem_REC.priority_level 			:=	NULL;
			L_RIB_ASNOutItem_REC.order_line_nbr 			:=	NULL;
			L_RIB_ASNOutItem_REC.lot_nbr 					:=	NULL;
			L_RIB_ASNOutItem_REC.final_location 			:=	NULL;
			L_RIB_ASNOutItem_REC.from_disposition 			:=	NULL;
			L_RIB_ASNOutItem_REC.to_disposition 			:=	NULL;
			L_RIB_ASNOutItem_REC.voucher_number 			:=	NULL;
			L_RIB_ASNOutItem_REC.voucher_expiration_date 	:=	NULL;
			L_RIB_ASNOutItem_REC.container_qty 				:=	1;
			L_RIB_ASNOutItem_REC.comments 					:=	NULL;
			L_RIB_ASNOutItem_REC.unit_cost 					:=	NULL;
			L_RIB_ASNOutItem_REC.base_cost 					:=	NULL;
			L_RIB_ASNOutItem_REC.weight 					:=	NULL;
			L_RIB_ASNOutItem_REC.weight_uom 				:=	NULL;
            L_RIB_ASNOutItem_REC.ASNOutUIN_TBL              :=	l_RIB_ASNOutUIN_TBL;

			L_RIB_ASNOutItem_TBL.EXTEND();
			L_RIB_ASNOutItem_TBL(L_RIB_ASNOutItem_TBL.COUNT) := L_RIB_ASNOutItem_REC;

		END LOOP;

            L_RIB_ASNOutCtn_REC := "RIB_ASNOutCtn_REC"(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
            L_RIB_ASNOutCtn_TBL := "RIB_ASNOutCtn_TBL"();      

                L_RIB_ASNOutCtn_REC.final_location        :=      null; 
                L_RIB_ASNOutCtn_REC.container_id          :=      'B'||l_tsf_no; 
                L_RIB_ASNOutCtn_REC.container_weight      :=      null; 
                L_RIB_ASNOutCtn_REC.container_length      :=      null; 
                L_RIB_ASNOutCtn_REC.container_width       :=      null; 
                L_RIB_ASNOutCtn_REC.container_height      :=      null; 
                L_RIB_ASNOutCtn_REC.container_cube        :=      null; 
                L_RIB_ASNOutCtn_REC.expedite_flag         :=      null; 
                L_RIB_ASNOutCtn_REC.in_store_date         :=      null; 
                L_RIB_ASNOutCtn_REC.tracking_nbr          :=      null; 
                L_RIB_ASNOutCtn_REC.freight_charge        :=      null; 
                L_RIB_ASNOutCtn_REC.master_container_id   :=      null; 
                L_RIB_ASNOutCtn_REC.ASNOutItem_TBL        :=      L_RIB_ASNOutItem_TBL;
                L_RIB_ASNOutCtn_REC.comments              :=      'Shipment: '||l_tsf_no; 
                L_RIB_ASNOutCtn_REC.weight                :=      null; 
                L_RIB_ASNOutCtn_REC.weight_uom            :=      null; 
                L_RIB_ASNOutCtn_REC.carrier_shipment_nbr  :=      null; 
                L_RIB_ASNOutCtn_REC.original_item_id      :=      null; 
       

			L_RIB_ASNOutCtn_TBL.EXTEND();
			L_RIB_ASNOutCtn_TBL(L_RIB_ASNOutCtn_TBL.COUNT) := L_RIB_ASNOutCtn_REC; 
            
             
			L_RIB_ASNOutDistro_TBL 	:= 	"RIB_ASNOutDistro_TBL"();
			L_RIB_ASNOutDistro_REC 	:= 	"RIB_ASNOutDistro_REC"('0',null,null,null,null,null,null,null);

			L_RIB_ASNOutDistro_REC.rib_oid           		:='0';
			L_RIB_ASNOutDistro_REC.distro_nbr 				:= l_tsf_no;
			L_RIB_ASNOutDistro_REC.distro_doc_type 			:= 'T';
			L_RIB_ASNOutDistro_REC.cust_order_nbr 			:= null;
			L_RIB_ASNOutDistro_REC.fulfill_order_nbr 		:= null;
			L_RIB_ASNOutDistro_REC.consumer_direct			:= null; 
			L_RIB_ASNOutDistro_REC.ASNOutCtn_TBL		    := L_RIB_ASNOutCtn_TBL;

			L_RIB_ASNOutDistro_TBL.EXTEND();
			L_RIB_ASNOutDistro_TBL(L_RIB_ASNOutDistro_TBL.COUNT) := L_RIB_ASNOutDistro_REC; 

                
                
			      L_RIB_ASNOutDesc_REC := "RIB_ASNOutDesc_REC"( 0 		-- rib_oid number
															, null 		-- schedule_nbr number
															, 'N'		-- auto_receive varchar2
															, l_to_loc  -- to_location varchar2						--*---
															, l_to_loc_type-- to_loc_type varchar2
															, null		-- to_store_type varchar2
															, null		-- to_stockholding_ind varchar2
															, l_from_loc-- from_location varchar2
															, l_from_loc_type-- from_loc_type varchar2
															, null		-- from_store_type varchar2
															, null		-- from_stockholding_ind varchar2
															, l_asn	-- asn_nbr varchar2							---*---
															, null		-- asn_type varchar2						---*---
															, 1		    -- container_qty number
															, l_tsf_no 	-- bol_nbr varchar2
															, l_date	-- shipment_date date
															, l_date	-- est_arr_date date
															, null		-- ship_address1 varchar2
															, null		-- ship_address2 varchar2
															, null		-- ship_address3 varchar2
															, null		-- ship_address4 varchar2
															, null		-- ship_address5 varchar2
															, null		-- ship_city varchar2
															, null		-- ship_state varchar2
															, null		-- ship_zip varchar2
															, null		-- ship_country_id varchar2
															, null		-- trailer_nbr varchar2
                                                            ,null		--seal_nbr
                                                            ,null		--transshipment_nbr
															,L_RIB_ASNOutDistro_TBL -- L_RIB_ASNOutDistro_TBL "RIB_ASNOutDistro_TBL"
															,'Shipment: '||l_tsf_no		--comments
															,1 		    --carrier_code
															,null		--carrier service code
															);
	 
      rms.RMSSUB_ASNOUT.CONSUME(O_status_code ,o_error_message ,L_RIB_ASNOutDesc_REC ,i_message_type);
             
               IF O_status_code = 'E' then 
           INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ENTITY_FROM_LOC,ERROR)
               VALUES ('TRANSFER_SHIPMENT','TRANSFER','FAILED',L_tsf_no, O_status_code,null,O_error_message);
                 
            else    
         INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ENTITY_FROM_LOC,ERROR)
               VALUES ('TRANSFER_SHIPMENT','TRANSFER','SUCCESS',L_tsf_no, O_status_code,null,O_error_message);
          END IF;
		
	    c_commit :=c_commit + 1;
       IF MOD(c_commit, 5) = 0 THEN
        COMMIT;
       END IF;
         
   END LOOP;
   COMMIT;
   
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/  
 
set serveroutput on;
set timing on;

 DECLARE

l_ITEM  rms.item_master.item%type;
l_t_no  rms.tsfhead.tsf_no%type;
 sl_no               NUMBER(10)                    := 1;
 
cursor C_dept is
            select * from skumar.iwtdispath_both;

cursor C_item (l_t_no  rms.tsfhead.tsf_no%type) is
	select item from rms.shipsku sk where sk.distro_no = l_t_no;
	
 
BEGIN

    for k in C_dept loop 
    l_t_no := k.tsf_no;
    
    for i in C_item(l_t_no) loop 
        l_item :=i.item;

        update rms.shipsku sk set CARTON = CARTON||sl_no where sk.distro_no =l_t_no and sk.item =l_item ;
        sl_no   := sl_no + 1;

    END LOOP;
    sl_no := 1;

END LOOP;
commit;

EXCEPTION

when OTHERS THEN

  dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);

ROLLBACK;
END;
/