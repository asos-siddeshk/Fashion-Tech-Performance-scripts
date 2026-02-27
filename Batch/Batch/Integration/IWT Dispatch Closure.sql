ETSOSTATUS
SOStatus
SOStatusCre

/home/oracle/Messages/Stock_Order_Status/asnout/14/
/home/oracle/Messages/Stock_Order_Status/asnout/17/

/home/oracle/Messages/Stock_Order_Status/asnout/17



select * from rib_message where MESSAGE_NUM>'11633518'order by 1 desc;
select count(1) from rib_message where MESSAGE_NUM>'11633518' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM>'11633518' group by FAMILY order by 1 desc;
select * from rib_message where FAMILY ='XTsf' and MESSAGE_NUM>'11633518' order by 1 desc;

    "ns" : "sostatus.exportedSOStatus",
    "count" : 31275,
    
    "ns" : "sostatus.publishedSOStatusRMS",
    "count" : 153,


<?xml version="1.0" encoding="UTF-8"?><IWTDespatchClosure>
  <DespatchClosure iwtAdviceId="T004105008">
    <DespatchingWarehouseId>FC01</DespatchingWarehouseId>
    <ReceivingWarehouseId>FC04</ReceivingWarehouseId>
    <DateCreatedUtc>2018-05-17T01:59:59+0100</DateCreatedUtc>
    <Summary>
      <SkuItem allocated="10" despatched="10" id="6744971" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="5993598" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="6500779" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="6580856" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="5797032" requested="10"/>
    </Summary>
  </DespatchClosure>
  <DespatchClosure iwtAdviceId="T0047001401715">
    <DespatchingWarehouseId>FC01</DespatchingWarehouseId>
    <ReceivingWarehouseId>FC04</ReceivingWarehouseId>
    <DateCreatedUtc>2018-05-17T01:59:59+0100</DateCreatedUtc>
    <Summary>
      <SkuItem allocated="10" despatched="10" id="6478243" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="6316850" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="6379016" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="6802887" requested="10"/>
      <SkuItem allocated="10" despatched="10" id="5500150" requested="10"/>
    </Summary>
  </DespatchClosure>
</IWTDespatchClosure>


embedded.0.properties
T0047271454074
db.getCollection('exportedSOStatus').find({"embedded.0.properties":"T0047271454074"})


select tsf_no from tsfhead th where tsf_type!='CO' and status ='S' -- and from_loc ='1001' and rownum <= '1000'
    and exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no);
  

select tsf_no from tsfhead th where tsf_type!='CO' and status ='S' and from_loc ='1001' and rownum <= '1000'
    and exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no and sk.QTY_RECEIVED < sk.QTY_EXPECTED);

  
select * from skumar.iwtdispath_cls;

drop table iwtdispath_cls;
create table iwtdispath_cls as
select tsf_no from tsfhead th where 1=2;

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO RCHANDEL;
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO rdatla; 


select *  from rms.tsfHEAD td
    where td.tsf_no in (select tsf_no from skumar.iwtdispath_cls) order by TSF_NO;
    
select *  from rms.tsfdetail td
    where td.tsf_no in (select tsf_no from skumar.iwtdispath_cls) order by TSF_NO;
    
select distinct 'T'||LPAD( w2.PHYSICAL_WH,3,0)||th.tsf_no as IwtAdvice_id, th.tsf_no, TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS DateCreatedUtc ,
    w1.WH_NAME_SECONDARY as FROM_LOC,w2.WH_NAME_SECONDARY as TO_LOC
    from rms.tsfhead th,rms.wh w1,rms.wh w2 
    where th.FROM_LOC =w1.wh and th.TO_LOC =w2.wh AND TH.STATUS ='S'
   and th.tsf_no in (select tsf_no from skumar.iwtdispath_cls) 
    order by th.tsf_no;

select td.TSF_NO,item as id,td.TSF_QTY as requested,td.SHIP_QTY as despatched,td.TSF_QTY as allocated from rms.tsfdetail td, rms.tsfhead th 
    where th.tsf_no in (select tsf_no from skumar.iwtdispath_cls) and th.status ='S' and td.tsf_no = th.tsf_no order by TSF_NO;


select count(1) from skumar.iwtdispath_cls;

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_cls TO rdatla; 

delete from skumar.iwtdispath_cls where tsf_no not in (select tsf_no from tsfhead);
delete from skumar.iwtdispath_cls where tsf_no in (select tsf_no from tsfhead where status !='A');
delete from skumar.iwtdispath_cls where tsf_no in (select distro_no from shipsku);
delete from skumar.iwtdispath_cls where tsf_no in (select tsf_no from tsfhead where status ='A' and from_loc ='3001') and rownum <= '7546';


select FROM_LOC,count(1)  from rms.tsfhead td
    where td.tsf_no in (select tsf_no from skumar.iwtdispath_cls) group by FROM_LOC;

select * from tsfdetail where tsf_no in (select tsf_no from skumar.iwtdispath_cls);

select count(distinct(tsf_no))  from tsfdetail where tsf_no in (select tsf_no from skumar.iwtdispath_cls);
select count(distinct(tsf_no)) from  tsfdetail where tsf_no in (select tsf_no from skumar.iwtdispath_cls) and TSF_QTY = SHIP_QTY;


select * from rms.shipment where shipment ='112891440';
select * from rms.shipsku where distro_no ='7271454073';
select * from rms.tsfdetail where tsf_no ='7271454073';
select * from rms.tsfhead where tsf_no ='7271454073';

select * from item_loc_soh where item ='7564476' and loc in ('1001','3001');
select * from rib_message where message_num> '632987' order by 1 desc;

select * from rib_message order by 1 desc;

select * from rib_message where message_num > '11633443' ;
select * from rib_message_failure where message_num= '11633460' ;

--Caused by: com.retek.rib.binding.exception.RIBIntegrationException: Exception while processing request: Error from {call RMSSUB_SOSTATUS.CONSUME(?,?,?,?)}: [E] Both customer order number and fulfill order number must be defined for customer order transfer 7030772029. - Nested exception: - com.retek.rib.collab.RibAPIException: Error from {call RMSSUB_SOSTATUS.CONSUME(?,?,?,?)}: [E] Both customer order number and 

DELETE FROM iwtdispath_cls;


 --- Transfers d
alter session set current_schema=rms;

set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 500;
  counter               NUMBER(10)                    := 0;
  c_commit  	        NUMBER(5)                     := 5;
  O_status_code         varchar2(1);
  O_error_message       varchar2(300);
  l_delivery_date       rms.tsfhead.delivery_date%type;
  L_tsf_no              rms.tsfhead.tsf_no%type;
  n_from_loc            rms.tsfhead.from_loc%TYPE       := '4001';
  n_to_loc              rms.tsfhead.to_loc%TYPE         ;
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
    select 	wh2.wh 
	from 	rms.wh wh1, rms.wh wh2 
	where 	wh1.org_unit_id!=wh2.org_unit_id and wh1.wh = n_from_loc
    ORDER BY dbms_random.value; 
 

  CURSOR cur_item IS    
    select im.item, '8' as tsf_qty
    from rms.item_master im, rms.item_loc_soh ils
    where im.status ='A' 
            and im.item_level = im.tran_level 
            and ils.item=im.item 
            and (ils.stock_on_hand - ils.non_sellable_qty - ils.tsf_reserved_qty) > '50'
            and ils.loc = n_from_loc
            and rownum<= 7
            ORDER BY DBMS_RANDOM.VALUE;
  
BEGIN


select vdate INTO l_delivery_date from rms.period;

 WHILE counter <> num_rec LOOP
 
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
            L_RIB_XTsfDesc_REC.comment_desc   := 'DISPACHCLOSURE';
            L_RIB_XTsfDesc_REC.XTsfDtl_TBL    := l_RIB_XTsfDtl_TBL;

     
   
         RMS.RMSSUB_XTSF.CONSUME(O_status,O_error_message,L_RIB_XTsfDesc_REC,I_MESSAGE_TYPE);

           IF O_status_code = 'E' then 
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','FAILED',L_tsf_no, O_status_code,O_error_message);
                 
            else  
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','SUCCESS',L_tsf_no,O_status_code,O_error_message);
			INSERT INTO SKUMAR.iwtdispath_cls (tsf_no) values (L_tsf_no) ;   
            
        END IF;   
            
              
             counter   := counter + 1;
                IF MOD(counter, c_commit) = 0 THEN
                  COMMIT;
                END IF;

    END LOOP;
    END LOOP;
    
    commit;
    
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/


--- Shipment 
alter session set current_schema=rms;


SET SERVEROUTPUT ON;
SET timing ON;

DECLARE
  counter               NUMBER(10)                    := 0;
  c_commit  	        NUMBER(10)                     := 0;
  
  O_status_code     varchar2(1);
  O_error_message   varchar2(300);
  I_message_type    varchar2(10):= 'asnoutcre';
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
    and 	not exists (select 1 from rms.shipsku sh where sh.distro_no=th.tsf_no)
	and 	exists (select 1 from SKUMAR.iwtdispath_cls where tsf_no =th.tsf_no) order by 1);


CURSOR tsfship_item(i_tsf_no rms.tsfhead.tsf_no%type)
IS    
			select td.item, 
					td.tsf_qty -5 as tsf_qty
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
                L_RIB_ASNOutCtn_REC.container_id          :=      l_tsf_no; 
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
															, l_tsf_no	-- asn_nbr varchar2							---*---
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
   
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/  
 