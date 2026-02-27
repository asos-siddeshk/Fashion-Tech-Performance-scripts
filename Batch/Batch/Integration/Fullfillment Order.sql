select * from rib_message order by 1 desc;
select count(1) from rib_message where MESSAGE_NUM > '65989735';
select * from rib_message_failure where MESSAGE_NUM > '65989735' order by 1,2;

select rms.TRANSFER_NUMBER_SEQUENCE.nextval from dual; --8035685919
select rms.SHIPMENT_SEQUENCE.nextval from dual; --382784433
select rms.ORDCUST_SEQ.nextval from dual; --988267733

select PUBLISHED,Count(1)/5 from TRANSFERS_PUB_INFO where tsf_no > '8035685919' group  by PUBLISHED;
select * from tsfhead where tsf_no >= '8035685919' order by 1 desc;
select Count(1)/5 from tsfhead where tsf_no > '8035685919';
select TSF_TYPE,status,count(1) from tsfhead where tsf_no > '8035685919' group by TSF_TYPE,status;
select PUBLISHED,Count(1) from TRANSFERS_PUB_INFO where tsf_no > '8035685919' group  by PUBLISHED;
select count(1) from tsf_mfqueue;

select Count(1) from tsfhead where tsf_no > '8035685919';
select Count(1)/5 from tsfhead where tsf_no > '8035685919';
select count(1)/5 from ordcust where ORDCUST_NO >'990856398';
select count(1) from shipment  where shipment > '382852593'; 
select count(1)/5 from shipSKU  where shipment > '382852593';  

select th.TSF_TYPE,th.status,count(1) from tsfhead th, tsfdetail td where th.tsf_no > '8035685919' and th.tsf_no = td.tsf_no group by TSF_TYPE,status;
select td.item,th.status,count(1) from tsfhead th, tsfdetail td where th.tsf_no > '8035685919' and th.tsf_type = 'CO' and th.tsf_no = td.tsf_no group by item,status;

db.getCollection('exportedFulfilmentOrder').find({"_id":"38051758710"})

select DISTRO_NO,count(1) from shipsku where shipment > '381727518' group by DISTRO_NO having count(1) >2;

select * from shipsku where shipment > '381727518' and DISTRO_NO is null group by DISTRO_NO having count(1) >2;
select 242646/3 from dual;
select DISTRO_NO,count(1) from shipsku where shipment > '381727518' group by DISTRO_NO having count(1) >2;

select count(1)/3 from shipsku where shipment > '381727518';
select * from shipsku where shipment > '381727518';

select * from shipment where shipment in (select shipment from shipsku where distro_no in (select tsf_no from tsfhead where tsf_no > '7210415446'));
select count(1) from shipment where shipment in (select shipment from shipsku where distro_no in (select tsf_no from tsfhead where tsf_no > '7210415446'));
select count(1) from shipsku where distro_no in (select tsf_no from tsfhead where tsf_no > '7210415446');

select PUBLISHED,Count(1) from TRANSFERS_PUB_INFO where tsf_no > '7210415446' group  by PUBLISHED;
select count(1) from tsf_mfqueue; --
select * from TRANSFERS_PUB_INFO where tsf_no > '7210415446' order by 1 desc;

select FAMILY, TYPE,TOPIC_NAME,count(1) from rib_message group by FAMILY, TYPE,TOPIC_NAME;

select * from rib_message where MESSAGE_NUM >= '65989726' order by 1;
select * from rib_message_failure where MESSAGE_NUM >= '65989726' order by 1,2;

select * from ordcust where tsf_no ='8033220936'; --240261
select * from ordcust_detail where ORDCUST_NO in (select ORDCUST_NO from ordcust where tsf_no ='8033220936');
select * from tsfhead where TSF_NO in (select TSF_NO from ordcust where tsf_no ='8033220936');
select * from tsfdetail where TSF_NO in (select TSF_NO from ordcust where tsf_no ='8033220936');
select * from shipSKU where DISTRO_NO in (select TSF_NO from ordcust where tsf_no ='8033220936');
select * from shipment where shipment in (select distinct shipment from shipSKU where DISTRO_NO in (select TSF_NO from ordcust where tsf_no ='8033220936')) ;



db.getCollection('exportedFulfilmentOrder').find({})
db.getCollection('exportedTransfers').find({_id:"transfers_8033220933_exported"})
db.getCollection('exportedFulfilmentOrder').find({_id:"38040788044"})
db.getCollection('exportedFulfilmentTransfers').find({_id:"1000034266897"})

FulfillOrderServiceProviderImp.createFulfilOrdColDesc

--stockallocation and completion queries
select * from (select distinct orderid from SKUMAR.ordfullfillment order by ORDERID);
select * from (select distinct ORDERID, WLOCATION, STOCKREFERENCE from SKUMAR.ordfullfillment order by ORDERID);
select * from (select distinct ORDERID,SKU, QUANTITY,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS.ff2\"Z\"') AS timestamp from SKUMAR.ordfullfillment order by ORDERID);



select count(1) from ordcust where ORDCUST_NO > '987257683';
select count(1) from tsfhead where tsf_no >= '7265222970';
select count(1) from shipment  where shipment > '802479';
select count(1) from shipSKU where shipment > '802479';


select * from tsfhead where tsf_no > '7002943944';
select * from shipment  where shipment > '112983935';
select * from shipSKU  where shipment > '112983935';


select count(1) from ordcust where tsf_no > '7002943944'; --240261
select count(1) from ordcust_detail where ORDCUST_NO in (select ORDCUST_NO from ordcust where tsf_no > '7002943944');
select count(1) from tsfhead where TSF_NO in (select TSF_NO from ordcust where tsf_no > '7002943944');
select count(1) from tsfdetail where TSF_NO in (select TSF_NO from ordcust where tsf_no > '7002943944');
select count(1) from shipSKU where DISTRO_NO in (select TSF_NO from ordcust where tsf_no > '7002943944');
select count(1) from shipment where shipment in (select distinct shipment from shipSKU where DISTRO_NO in (select TSF_NO from ordcust where tsf_no > '7002943944')) ;
select count(1) from tran_data;
select count(1) from if_tran_data;

select count(1) from tsfhead where tsf_no > '7003730609';
select count(1) from shipment where shipment > '762244';
select count(1) from ordcust where ORDCUST_NO >'1405270';

select * from shipSKU where DISTRO_NO in (select TSF_NO from ordcust where tsf_no > '7002943944');
select *  from shipment where shipment in (select distinct shipment from shipSKU where DISTRO_NO in (select TSF_NO from ordcust where tsf_no > '7002943944')) ;

--stockallocation and completion queries:
select * from (select distinct orderid from SKUMAR.ordfullfillment order by ORDERID);
select * from (select distinct ORDERID, WLOCATION, STOCKREFERENCE from SKUMAR.ordfullfillment order by ORDERID);
select * from (select distinct ORDERID,SKU, QUANTITY,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS.ff2\"Z\"') AS timestamp from SKUMAR.ordfullfillment order by ORDERID);


select * from item_master where item in (select distinct sku from ordfullfillment) and item_level != tran_level;
select * from item_master where item in (select distinct sku from ordfullfillment) and item_level = tran_level and item_level = '1';



drop table ordfullfillment;
create table ordfullfillment as select * from CASHANDSALES_ALL_CHK;

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.ordfullfillment TO PSURENDRAN;
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.ordfullfillment TO SHARATHKUMAR; 

select * from ordfullfillment ;


select distinct sku from ordfullfillment where sku not in (select item from item_master );  --13291
select distinct sku from ordfullfillment where sku  in (select item from item_master where item_level != tran_level); 381

drop table offfskurl;
create table offfskurl as
select * from (
select distinct item from item_loc_soh ils where stock_on_hand >= '1001' and loc = '1001'
    and not exists (select 1 from skumar.ordfullfillment offf where offf.sku = ils.item) ) where rownum <= '13672';


create table offfskurl (item varchar2(25),sku varchar2(25));

ALTER TABLE ordfullfillment  ADD itemcp varchar2(25);

MERGE INTO ordfullfillment s1 USING offfskurl s2 ON (s1.sku = s2.sku) 
    WHEN MATCHED THEN UPDATE SET s1.itemcp = s2.item;


--drop table offfskurl;

select * from offfskurl;
select * from ordfullfillment where ITEMCP is not null;
update ordfullfillment set sku = ITEMCP where ITEMCP is not null;




select * from ordfullfillment;



--stockallocation and completion queries:
select * from (select distinct orderid from SKUMAR.ordfullfillment order by ORDERID);
select * from (select distinct ORDERID, WLOCATION, STOCKREFERENCE from SKUMAR.ordfullfillment order by ORDERID);
select * from (select distinct ORDERID,SKU, QUANTITY,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS.ff2\"Z\"') AS timestamp from SKUMAR.ordfullfillment
    order by ORDERID);




select table_name,NUM_ROWS from all_tables where lower(table_name) in ('ordcust','tsfhead') and owner like 'RMS';

select SOURCE_LOC_ID as WH, FULFILL_LOC_ID as Store,count(1) as Count_item from ordcust where ORDCUST_NO >='105004' group by SOURCE_LOC_ID, FULFILL_LOC_ID;


select count(1) from ordcust where ORDCUST_NO >'345267';
select count(1) from tsfhead where tsf_no in (select TSF_NO from ordcust where ORDCUST_NO >'345267');

select * from ordcust order by 1 desc;

select * from ordcust where CREATE_DATETIME>=to_date('23-APR-2020 13:45', 'DD-MON-YYYY hh24:mi') order by 1;

select * from ordcust where trunc(CREATE_DATETIME)= trunc(sysdate) order by 1;
select *  from ordcust_detail where ORDCUST_NO ='25853396';

select * from ordcust where tsf_no in ('7002943944');
select * from ordcust_detail where ORDCUST_NO  in (95001);
select * from rms.tsfhead where tsf_no in ('7002943944');
select * from rms.tsfdetail where tsf_no in ('7002943944');
select * from rms.shipment where shipment in (select shipment from rms.shipSKU where DISTRO_NO in ('7002943944'));
select * from rms.shipSKU where DISTRO_NO in ('7002943944');
select * from rms.shipSKU_loc where shipment in (select shipment from rms.shipSKU where DISTRO_NO in ('7002943944'));
select * from rms.DOC_CLOSE_QUEUE where doc in ('7002943944');
select * from rms.item_loc_soh where  (item,loc) in (select ITEM, LOCATION from rms.tran_data where ref_no_1 in ('7002943944'));
select * from rms.tran_data where ref_no_1 in ('7002943944') order by item,location,tran_code;




select * from ordcust where trunc(CREATE_DATETIME) = '15-OCT-19';

drop table ordcustitem ;
create table ordcustitem as select distinct sku as item from ordfullfillment;
    

select * from item_loc_soh where AV_COST is null; 
select * from item_loc_soh where item in (select distinct item from ordcustitem) and loc in ('10001');

Update item_loc_soh set AV_COST = unit_cost where item in (select item from ordcustitem) and AV_COST is null and loc in ('10001'); 
Update item_loc_soh set AV_COST = unit_cost where item in (select item from ordcustitem) and AV_COST is null and loc in ('30001');
Update item_loc_soh set AV_COST = unit_cost where item in (select item from ordcustitem) and AV_COST is null and loc in ('40001');

select * from item_loc_soh where item in (select distinct item from ordcustitem) and loc in ('1001');
select * from item_loc_soh where item in (select distinct item from ordcustitem) and loc in ('3001');
select * from item_loc_soh where item in (select distinct item from ordcustitem) and loc in ('4001');



select FAMILY, TYPE,TOPIC_NAME,count(1) from rib_message  group by FAMILY, TYPE,TOPIC_NAME;
select FAMILY, TYPE,TOPIC_NAME,count(1) from rib_message where trunc(NEXT_ATTEMPT_TIME) = '17-FEB-20' group by FAMILY, TYPE,TOPIC_NAME;
select * from rib_message rm where family ='SOStatus' ;


 -- 1.  2770 - Messages with Average cost null -- Corrected Item loc soh av_cost = unit_cost
select * from rib_message rm where family ='ASNOut' 
    and exists (select 1 from rib_message_failure rmf where rm.MESSAGE_NUM= rmf.MESSAGE_NUM and rmf.DESCRIPTION like '%Average cost%') ;

update  rib_message rm set MAX_ATTEMPTS = ATTEMPT_COUNT+1 where family ='ASNOut' and ATTEMPT_COUNT = MAX_ATTEMPTS
    and exists (select 1 from rib_message_failure rmf where rm.MESSAGE_NUM= rmf.MESSAGE_NUM and rmf.DESCRIPTION like '%Average cost%') ;


begin 
Update item_loc_soh set AV_COST = unit_cost where AV_COST is null and item ='3090079';
commit;
end;
/

select * from rib_failures where DESCRIPTION like '%Average cost%';

SELECT
  SUBSTR( DESCRIPTION, 145, 10 ) 
FROM
  rib_failures where DESCRIPTION like '%Average cost%';

select * from item_loc_soh where  item ='3090079';


select * from rib_message order by 1 desc;


select FAMILY, TYPE,TOPIC_NAME,count(1) from rib_message where trunc(NEXT_ATTEMPT_TIME) = '15-OCT-19' group by FAMILY, TYPE,TOPIC_NAME;
select * from rib_message where trunc(NEXT_ATTEMPT_TIME) = '15-OCT-19' order by 1;
select * from rib_message where trunc(NEXT_ATTEMPT_TIME) = '15-OCT-19' and id like '70%' ;

select * from rib_message where message_num between 638998 and 639000;
select * from rib_message_failure where message_num between 638998 and 639000;

-- 2. Error from {call RMSSUB_ASNOUT.CONSUME(?,?,?,?)}: [E] Invalid input parameter I_carton, passed as NULL, expected NOT NULL.
  
select * from ordcust where FULFILL_ORDER_NO in ('12100788044');
select * from ordcust_detail where ORDCUST_NO  in (select ORDCUST_NO from ordcust where FULFILL_ORDER_NO in ('12100788044'));
select * from tsfhead where tsf_no ='7199115510';
select * from tsfdetail where tsf_no ='7199115510';
select * from shipsku where distro_no ='7199115510';
select * from shipment where shipment in (select shipment from shipsku where distro_no ='7199115510');



Case 1. 2770 - ASNOUT Messages had items with Average cost null -- Corrected Item loc soh av_cost = unit_cost for the location
Case 2. 3 - Messages with  Error from {call RMSSUB_ASNOUT.CONSUME(?,?,?,?)}: [E] Invalid input parameter I_carton, passed as NULL, expected NOT NULL.
        All 3 messages are from the same 12100788044

select * from ordcust where CUSTOMER_ORDER_NO in ('12100788044');
select * from ordcust_detail where ORDCUST_NO  in (select ORDCUST_NO from ordcust where CUSTOMER_ORDER_NO in ('12100788044'));
select * from tsfhead where tsf_no ='7199215510';
select * from tsfdetail where tsf_no ='7199215510';
select * from shipsku where distro_no ='7199215510';
select * from shipment where shipment in (select shipment from shipsku where distro_no ='7199215510');
select * from shipment where shipment >'27881007';



select FAMILY, TYPE,TOPIC_NAME,count(1) from rib_message  group by FAMILY, TYPE,TOPIC_NAME;



select * from tsfhead where tsf_no > '';

select * from ordcust where ORDCUST_NO > '40756007';
select * from ordcust_detail where ORDCUST_NO > '40756007';


select * from shipment where shipment > '50948537';
select  * from shipment where shipment > '50948609';
select  shipment,count(1) from shipsku where shipment > '50948537' group by shipment having count(1) <> 3;

select * from rib_message order by 1;
select count(1) from rms.item_loc_soh where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('1001') and STOCK_ON_HAND <= '1000';
select count(1) from rms.item_loc_soh where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('3001') and STOCK_ON_HAND <= '1000';
select count(1) from rms.item_loc_soh where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('4001') and STOCK_ON_HAND <= '1000';
select count(1) from rms.item_loc_soh where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('6001') and STOCK_ON_HAND <= '1000';




update rms.item_loc_soh set STOCK_ON_HAND = '25000' where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('1001') and STOCK_ON_HAND <= '25000';
update rms.item_loc_soh set STOCK_ON_HAND = '25000' where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('3001') and STOCK_ON_HAND <= '25000';
update rms.item_loc_soh set STOCK_ON_HAND = '25000' where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('4001') and STOCK_ON_HAND <= '25000';
update rms.item_loc_soh set STOCK_ON_HAND = '25000' where item in (select distinct sku from skumar.CASHANDSALES_2022) and loc in ('6001') and STOCK_ON_HAND <= '25000';


select * from skumar.ordfullfillment where sku='510';
select * from item_master where item ='510';

    select count(1) from (select distinct sku as item_id
            from skumar.ordfullfillment odf 
            where  exists (select 1 from rms.item_loc_soh ils where ils.loc = '4001' and ils.STOCK_ON_HAND <= '1000' and ils.item = odf.sku)); 

delete from skumar.VPT_LOGS;   

alter session set current_schema=rms;

set serveroutput on;
set timing on;

DECLARE
  c_commit  	        NUMBER(5)                     := 100;
  O_status_code         varchar2(1);
  O_error_message       varchar2(300);
  L_return_code         VARCHAR2(20);
  O_status              VARCHAR2(20);
  L_date                date;
  I_MESSAGE_TYPE        VARCHAR2(20) := 'invadjustcre';
  l_loc                 rms.wh.wh%type;
  l_adj_qty             rms.inv_adj.adj_qty%type := '10';
  l_dept                rms.subclass.dept%type;
  l_class               rms.subclass.class%type;  
  l_subclass            rms.subclass.subclass%type;
  l_adjustment_reason_code rms.inv_adj.reason%type := '201';
  
   TYPE ITEM_REC IS RECORD
    (item_id 				rms.inv_adj.item%type,
	 adjustment_reason_code rms.inv_adj.reason%type,
     unit_qty               rms.inv_adj.adj_qty%type);
    
  TYPE ITEM_INFO IS TABLE OF ITEM_REC;
    P_ITEM_REC ITEM_INFO; 

  l_RIB_InvAdjustDtl_REC   "RIB_InvAdjustDtl_REC";
  l_RIB_InvAdjustDtl_TBL   "RIB_InvAdjustDtl_TBL";
  l_RIB_InvAdjustDesc_REC  "RIB_InvAdjustDesc_REC";
  	
  CURSOR cur_wh IS 	
    select 	distinct wh2.wh 
        from 	rms.wh wh1, rms.wh wh2 
        where 	wh1.org_unit_id=wh2.org_unit_id and wh1.wh=wh2.wh and wh1.wh in ('4001','1001','3001');

  CURSOR cur_item (l_loc rms.wh.wh%type) IS    
    select * from (select distinct sku as item_id,
           l_adjustment_reason_code as adjustment_reason_code,
           l_adj_qty as unit_qty
        from skumar.ordfullfillment odf where 
            exists (select 1 from rms.item_loc_soh ils where ils.loc = l_loc and ils.STOCK_ON_HAND <= l_adj_qty and ils.item = odf.sku)) 
                where rownum <= '5000';

BEGIN

  
 select vdate into L_date from rms.period;

     for j in 0..10 loop
     for i in cur_wh loop
         L_loc := i.wh;
		 l_RIB_InvAdjustDtl_REC    := "RIB_InvAdjustDtl_REC"(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		 l_RIB_InvAdjustDtl_TBL	 := "RIB_InvAdjustDtl_TBL"();

		    open cur_item (L_loc);
            
            fetch cur_item BULK COLLECT INTO P_ITEM_REC;
            close cur_item;

		FOR i IN 1..P_ITEM_REC.COUNT LOOP
        
		l_RIB_InvAdjustDtl_REC.item_id  		             := P_ITEM_REC(i).item_id;
		l_RIB_InvAdjustDtl_REC.adjustment_reason_code 		 := P_ITEM_REC(i).adjustment_reason_code;
        l_RIB_InvAdjustDtl_REC.unit_qty 		             := P_ITEM_REC(i).unit_qty;
        l_RIB_InvAdjustDtl_REC.user_id  		             := 'PTUSER';
        l_RIB_InvAdjustDtl_REC.create_date   		         := L_date;
        l_RIB_InvAdjustDtl_REC.InvAdjustUin_TBL              := null;
        l_RIB_InvAdjustDtl_REC.from_disposition              := null;
        l_RIB_InvAdjustDtl_REC.to_disposition                := 'ATS';
            
		l_RIB_InvAdjustDtl_TBL.EXTEND();
		l_RIB_InvAdjustDtl_TBL(l_RIB_InvAdjustDtl_TBL.COUNT) := l_RIB_InvAdjustDtl_REC;
		
        END LOOP; 
		
		l_RIB_InvAdjustDesc_REC := "RIB_InvAdjustDesc_REC"(0,null,null);
        
        l_RIB_InvAdjustDesc_REC.rib_oid :=0;
        l_RIB_InvAdjustDesc_REC.dc_dest_id:= L_loc ;
        l_RIB_InvAdjustDesc_REC.InvAdjustDtl_TBL :=l_RIB_InvAdjustDtl_TBL;


         RMS.RMSSUB_INVADJUST.CONSUME (O_status_code,O_error_message,l_RIB_InvAdjustDesc_REC,I_message_type);

             IF O_status_code = 'E' then 
          
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,ENTITY_FROM_LOC,STATUS,ERROR)
              VALUES ('INVADJ_AVAIL','ATS','FAIL',null,L_loc,O_status_code,O_error_message);
           ELSE              
			 INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,ENTITY_FROM_LOC,STATUS,ERROR)
				 VALUES ('INVADJ_AVAIL','ATS','PASS',null,L_loc,O_status_code,null);
         
         END IF;  

        c_commit :=c_commit + 1;
       IF MOD(c_commit,9) = 0 THEN
        COMMIT;
       END IF;
 
    end loop;
    end loop;
	commit;
		
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/

select count(1) from skumar.VPT_LOGS;


select * from ordcust where ORDCUST_NO >'15000013';

select CUSTOMER_ORDER_NO,count(1) from ordcust where ORDCUST_NO >'15000013' group by CUSTOMER_ORDER_NO having count(1)>1;
select EXT_REF_NO,count(1) from tsfhead where tsf_no > '7210415446' group by EXT_REF_NO having count(1)>1;



select rms.TRANSFER_NUMBER_SEQUENCE.nextval from dual; --8035685919
select * from all_sequences where sequence_name like '%TRANSFER_NUMBER_SEQUENCE%';

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
 SELECT 8031600368 INTO last_used FROM dual; --7051315644
  LOOP
    SELECT rms.TRANSFER_NUMBER_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
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


 --- Customer order 
select rms.ORDCUST_SEQ.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 988257683 INTO last_used FROM dual; --

LOOP
    SELECT rms.ORDCUST_SEQ.NEXTVAL INTO curr_seq FROM dual;
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

select rms.SHIPMENT_SEQUENCE.nextval from dual;
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
  SELECT 382717517 INTO last_used FROM dual; --

LOOP
    SELECT rms.SHIPMENT_SEQUENCE.NEXTVAL INTO curr_seq FROM dual;
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
