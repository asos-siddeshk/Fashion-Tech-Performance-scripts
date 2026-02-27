/* Shipment

select * from ordhead where trunc(written_date);

insert into skumar.order_process values ('500060005806');
select * from shipment where order_no = '500060005806';

*/
alter session set current_schema=rms;


SET SERVEROUTPUT ON;
SET timing ON;

DECLARE

  counter               NUMBER(10)                    := 0;
  c_commit  	        NUMBER(5)                     := 0;
  
  
  
  O_status_code     varchar2(1);
  O_error_message   varchar2(300);
  I_message_type    varchar2(30) := 'asnincre';
  l_date date;  

	L_RIB_ASNInDesc_REC 	"RIB_ASNInDesc_REC";
	L_RIB_ASNInPO_TBL 		"RIB_ASNInPO_TBL";
	L_RIB_ASNInPO_REC 		"RIB_ASNInPO_REC" 		:= NULL;
	L_RIB_ASNInItem_TBL 	"RIB_ASNInItem_TBL";
	L_RIB_ASNInItem_REC 	"RIB_ASNInItem_REC" 	:= NULL;
	
  CURSOR ship_ord
  IS
   select order_no,loc_type,location,supplier,not_after_date from
    ( SELECT DISTINCT oh.order_no,
                    ol.loc_type,
                    ol.location,
					oh.supplier,
                    oh.not_after_date
    FROM            rms.ordhead oh, rms.ordloc ol                    
    WHERE           oh.order_no=ol.order_no 
            and oh.status not in ('C','S','W')
         and     oh.order_no in (select order_no from skumar.order_process)
        and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no));
   
      
  CURSOR ship_items(i_ord ordhead.order_no%TYPE)
  IS
    SELECT   ol.item,
             ol.qty_ordered --QTY_ORDERED-OL.QTY_RECEIVED AS 
    FROM     rms.ordloc ol
    WHERE    ol.order_no = i_ord;

  l_order_no   			rms.ordhead.order_no%type;
  l_loc_type   			rms.ordloc.loc_type%type;
  l_location   			rms.ordloc.location%type;
  l_location1           rms.ordloc.location%type;
  l_NOT_AFTER_DATE      rms.ordhead.NOT_AFTER_DATE%type;
  L_vendor  	        rms.ordhead.supplier%type;
  l_item			  	rms.ordloc.item%type;
  L_qty_ordered		  	rms.ordloc.qty_ordered%type;
  
  
BEGIN

select vdate into l_date from rms.period;

	FOR i IN ship_ord LOOP
	
			l_order_no  := i.order_no;
			l_loc_type  := i.loc_type;
			l_location  := i.location;
			l_vendor := i.supplier;
            l_NOT_AFTER_DATE := i.NOT_AFTER_DATE;
			
	        select physical_wh into l_location1 from rms.wh where wh =l_location;
        
			L_RIB_ASNInItem_REC := "RIB_ASNInItem_REC"('0',null,null,null,null,null,null,null,null,null);
			L_RIB_ASNInItem_TBL := "RIB_ASNInItem_TBL"();
    
	FOR k IN ship_items(l_order_no) LOOP
	
			l_qty_ordered  := 	k.qty_ordered;
			l_item  		:= 	k.item;

            L_RIB_ASNInItem_REC.rib_oid 		:=	'0';
      		L_RIB_ASNInItem_REC.final_location 	:=	l_location1;
			L_RIB_ASNInItem_REC.item_id 		:=	l_item;
			L_RIB_ASNInItem_REC.unit_qty 		:=	l_qty_ordered;
			L_RIB_ASNInItem_REC.priority_level 	:=	NULL;
			L_RIB_ASNInItem_REC.vpn 			:=	NULL;
			L_RIB_ASNInItem_REC.order_line_nbr 	:=	NULL;
			L_RIB_ASNInItem_REC.lot_nbr 		:=	NULL;
			L_RIB_ASNInItem_REC.ref_item 		:=	NULL;
			L_RIB_ASNInItem_REC.distro_nbr 		:=	NULL;

			L_RIB_ASNInItem_TBL.EXTEND();
			L_RIB_ASNInItem_TBL(L_RIB_ASNInItem_TBL.COUNT) := L_RIB_ASNInItem_REC;

		END LOOP;
	
		
			
			L_RIB_ASNInPO_REC 	:= 	"RIB_ASNInPO_REC"(null,null,null,null,null,null);
            L_RIB_ASNInPO_TBL 	:= 	"RIB_ASNInPO_TBL"();---changed 
		
			L_RIB_ASNInPO_REC.po_nbr 			:= l_order_no;
			L_RIB_ASNInPO_REC.doc_type 			:= 'P';
			L_RIB_ASNInPO_REC.not_after_date 	:= l_NOT_AFTER_DATE;
			L_RIB_ASNInPO_REC.comments 			:= 'Shipment'||l_order_no;
			L_RIB_ASNInPO_REC.ASNInCtn_TBL 		:= NULL;
			L_RIB_ASNInPO_REC.ASNInItem_TBL		:= L_RIB_ASNInItem_TBL;
			
			
			L_RIB_ASNInPO_TBL.EXTEND();
			L_RIB_ASNInPO_TBL(L_RIB_ASNInPO_TBL.COUNT) := L_RIB_ASNInPO_REC; 
			
			
			 L_RIB_ASNInDesc_REC := "RIB_ASNInDesc_REC"( 0 -- rib_oid number
															, 0 -- schedule_nbr number
															, 'N'-- auto_receive varchar2
															, l_location1-- to_location varchar2
															, l_loc_type-- to_loc_type varchar2
															, null-- to_store_type varchar2
															, null-- to_stockholding_ind varchar2
															, null-- from_location varchar2
															, null-- from_loc_type varchar2
															, null-- from_store_type varchar2
															, null-- from_stockholding_ind varchar2
															, l_order_no||555577-- asn_nbr varchar2
															, 'P'-- asn_type varchar2
															, null-- container_qty number
															, null-- bol_nbr varchar2
															, l_date-- shipment_date date
															, l_date-- est_arr_date date
															, null-- ship_address1 varchar2
															, null-- ship_address2 varchar2
															, null-- ship_address3 varchar2
															, null-- ship_address4 varchar2
															, null-- ship_address5 varchar2
															, null-- ship_city varchar2
															, null-- ship_state varchar2
															, null-- ship_zip varchar2
															, null-- ship_country_id varchar2
															, null-- trailer_nbr varchar2
															, null-- seal_nbr varchar2
															, null-- carrier_code varchar2
															, null-- carrier_service_code varchar2
															, l_vendor-- vendor_nbr varchar2--- changed
															, null -- ship_pay_method varchar2
															, L_RIB_ASNInPO_TBL -- ASNInPO_TBL "RIB_ASNInPO_TBL"
															);
	 
      rms.RMSSUB_ASNIN.CONSUME(O_status_code ,o_error_message ,L_RIB_ASNInDesc_REC ,i_message_type);
      
                 if O_status_code = 'E' then 
				 
          INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ENTITY_FROM_LOC,ERROR)
               VALUES ('PO_SHIPMENT','PO','FAILED',l_order_no, O_status_code,null,O_error_message);
                 
            else    
         INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ENTITY_FROM_LOC,ERROR)
               VALUES ('PO_SHIPMENT','PO','SUCCESS',l_order_no, O_status_code,null,O_error_message);
          END IF;
			
				  
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