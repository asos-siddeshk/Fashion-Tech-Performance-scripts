/*
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.VPT_LOGS TO PSURENDRAN; 

select count(1) from inv_adj; 
truncate table VPT_LOGS;

select INV_STATUS, COUNT(1) from inv_STATUS_QTY GROUP  BY INV_STATUS; 
SELECT  * FROM INV_STATUS_CODES;

select count(1) from inv_adj where ADJ_DATE = '15-JAN-24';  --433827
select * from inv_adj where ADJ_DATE = '15-JAN-24';  --1682618207

select location,count(distinct(item)) from inv_adj group by location; 
select item,count(1) from inv_adj group by item; 
select item,location,count(1) from inv_adj where location = '1001' group by item,location;

select loc,count(1) from item_loc_soh where STOCK_ON_HAND < '0' group by loc;

drop table neg_stock;
create table neg_stock as 
select loc,item from item_loc_soh where STOCK_ON_HAND < '0' and LOC_TYPE='W' and 1=2;
select * from neg_stock;

select loc,count(1) from neg_stock group by loc;



drop table skumar.neg_stock;
create table skumar.neg_stock as select loc,item from item_loc_soh where STOCK_ON_HAND < '0' and LOC_TYPE='W'  and rownum <= '500' and loc = '1001';
truncate table skumar.VPT_LOGS;

select * from VPT_LOGS;
select loc,count(1) from neg_stock group by loc;

drop table skumar.neg_stock;
create table skumar.neg_stock as 
select loc,item from item_loc_soh where 
    STOCK_ON_HAND < '0' and LOC_TYPE='W'  and rownum <= '10000';
    
    and item_parent in  (select item from item_master where brand_name ='TWISTED TA' and item_level ='1');



create table skumar.neg_stock as 
select loc,item from item_loc_soh where STOCK_ON_HAND <= '0' and LOC_TYPE='W'  and rownum <= '300' and loc = 1001;

delete from skumar.neg_stock;
insert into skumar.neg_stock (select loc,item from item_loc_soh where STOCK_ON_HAND < '0' and LOC_TYPE='W'  and rownum <= '300' and loc = '1001');



*/

--create table ma_stage_simple_promo_bk_PEE as select distinct item from ma_asos.ma_stage_simple_promo where status='N';

select * from VPT_LOGS;
truncate table skumar.VPT_LOGS;

select count(1) from tran_data;  --95,81,049
select count(1) from inv_adj where ADJ_DATE = '15-JAN-24';  --498227
select count(1) from inv_adj where ADJ_DATE = '20-NOV-23';  --498227
select min(adj_date) from inv_adj; --30-NOV-21
alter session set current_schema=rms;
set serveroutput on;
set timing on;

DECLARE
  counter               NUMBER(10)                    := 0;
  c_commit  	        NUMBER(5)                     := 0;

  O_status_code         varchar2(1);
  O_error_message       varchar2(300);
  L_return_code         VARCHAR2(20);
  O_status              VARCHAR2(20);
  L_date                date;
  I_MESSAGE_TYPE        VARCHAR2(20) := 'invadjustcre';
  l_loc                 rms.wh.wh%type;
  l_adj_qty             rms.inv_adj.adj_qty%type := '200';
  
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
     select distinct wh2.wh  from rms.wh wh1, rms.wh wh2  where wh1.org_unit_id!=wh2.org_unit_id and wh1.wh!=wh2.wh AND WH2.WH IN ('1001','3001','4001','6001');
  
  CURSOR cur_item (l_loc rms.item_loc_soh.loc%type) IS    
    SELECT 	im.item,
			'201' as adjustment_reason_code
            ,l_adj_qty as unit_qty
      FROM skumar.NEG_STOCK im
     WHERE im.loc= l_loc;

BEGIN

FOR K IN 0..50 LOOP
    select vdate into L_date from rms.period;
 
     for i in cur_wh loop
         L_loc := i.wh;

    delete from skumar.neg_stock;
    insert into skumar.neg_stock (select loc,item from item_loc_soh where STOCK_ON_HAND <= '0' and LOC_TYPE='W'  and rownum <= '200' and loc = L_loc);

		 l_RIB_InvAdjustDtl_REC     := "RIB_InvAdjustDtl_REC"(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		 l_RIB_InvAdjustDtl_TBL	    := "RIB_InvAdjustDtl_TBL"();

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
        l_RIB_InvAdjustDtl_REC.to_disposition               := 'ATS';
		
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
              VALUES ('INVADJ_AVAIL','ATS','FAIL',null,L_loc,O_status_code,null);
           ELSE 
			 INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,ENTITY_FROM_LOC,STATUS,ERROR)
				 VALUES ('INVADJ_AVAIL','ATS','PASS',null,L_loc,O_status_code,null);
         END IF;  
		
    COMMIT;

END LOOP;
END LOOP;
commit;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/
