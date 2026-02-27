--delete from cust_tsf_upld;
delete from VPT_LOGS;

select FROM_LOC,count(1) from skumar.cust_tsf_upld group by FROM_LOC;
select * from cust_tsf_upld;


set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE varchar2(255) := NULL;
  O_AVAILABLE number(20,4) := NULL;
  l_ITEM rms.item_loc.item%type;
  l_LOC  rms.item_loc.item%type;
  l_LOC_TYPE varchar2(1):= 'W';
  v_Return  BOOLEAN;

  CURSOR C_ITEMLOC IS
    SELECT item,loc FROM ITEM_LOC_soh ils WHERE LOC_TYPE ='W' and loc ='6001' and stock_on_hand>='0' and rownum<='10000'
     AND not Exists (sElEct 1 from skumar.cust_tsf_upld ctu whErE ctu.ITEM_ID = ils.itEm and  ctu.from_loc= ils.loc);    

BEGIN

for i in C_ITEMLOC loop
 l_item := i.item;
 l_loc  := i.loc;
 
  v_Return := RMS.ITEMLOC_QUANTITY_SQL.GET_LOC_CURRENT_AVAIL(O_ERROR_MESSAGE => O_ERROR_MESSAGE,
                                O_AVAILABLE => O_AVAILABLE,
                                I_ITEM => l_ITEM,
                                I_LOC => l_LOC,
                                I_LOC_TYPE => l_LOC_TYPE);
	IF (v_Return) THEN 
		insert into skumar.cust_tsf_upld (item_id,from_loc,to_loc,quantity) values (l_item,l_loc,null,O_AVAILABLE);
	ELSE
		insert into skumar.cust_tsf_upld (item_id,from_loc,to_loc,error) values (l_item,l_loc,null,O_ERROR_MESSAGE);
	   END IF;

	end loop;

commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


select STATUS, ENTITY_FROM_LOC,count(1)	from VPT_LOGS group by STATUS, ENTITY_FROM_LOC; 


    select count(1) from 
      (select distinct ITEM_ID from skumar.cust_tsf_upld odf 
        where  FROM_LOC= '6001' and
           exists (select 1 from rms.item_loc_soh ils where ils.loc = '6001' and ils.STOCK_ON_HAND <= '10000' and ils.item = odf.ITEM_ID));


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
  l_adj_qty             rms.inv_adj.adj_qty%type := '10000';
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
    select 	wh1.wh 
        from 	rms.wh wh1 
        where 	wh1.wh in ('6001'); --('1001','4001','3001','6001');

  CURSOR cur_item (l_loc rms.wh.wh%type) IS    
    select * from 
      (select distinct ITEM_ID,
           l_adjustment_reason_code as adjustment_reason_code,
           l_adj_qty as unit_qty
        from skumar.cust_tsf_upld odf 
        where  FROM_LOC= l_loc and
           exists (select 1 from rms.item_loc_soh ils where ils.loc = l_loc and ils.STOCK_ON_HAND <= '10000' and ils.item = odf.ITEM_ID)) 
                where rownum <= '50';

BEGIN  

 select vdate into L_date from rms.period;

     for k in 0..50 loop
     for j in 0..20 loop
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

    end loop;
	commit;
    end loop;
	commit;
    end loop;
	commit;
		
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/



select rms.TRANSFER_NUMBER_SEQUENCE.nextval from dual;
select * from all_sequences where sequence_name like '%TRANSFER_NUMBER_SEQUENCE%';

set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  NUMBER(12);
  curr_seq   NUMBER(12);
BEGIN
 SELECT 7271445306 INTO last_used FROM dual; --7051315644
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

delete from SKUMAR.VPT_LOGS ;

delete from TRAN_DATA_a where GL_REF_NO= '201';
delete from TRAN_DATA_b where GL_REF_NO= '201';
commit;


select distinct im.ITEM_ID from skumar.cust_tsf_upld im ;

select th.TO_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.TO_LOC;
select th.FROM_LOC,TSF_TYPE, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.FROM_LOC,TSF_TYPE;
select th.from_loc,td.item,count(1) from rms.tsfdetail td, tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) and th.tsf_no = td.tsf_no  group by th.from_loc,item;

--alter session set current_schema=rms;

set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 1500;
  counter               NUMBER(10)                    := 0;

  O_status_code         varchar2(1);
  O_error_message       varchar2(300);
  l_delivery_date       rms.tsfhead.delivery_date%type;
  L_tsf_no              rms.tsfhead.tsf_no%type;
  k_tsf_no              rms.tsfhead.tsf_no%type        := '7271431293';
  n_from_loc            rms.tsfhead.from_loc%TYPE      := '4001';
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
  	where 	wh1.org_unit_id!=wh2.org_unit_id and wh1.wh = n_from_loc  AND wh2.wh in ('3001','1001')
    ORDER BY dbms_random.value; 
 

  CURSOR cur_item IS    
   select im.ITEM_ID, '3' as tsf_qty
    from skumar.cust_tsf_upld im 
      where FROM_LOC= n_from_loc 
          AND not exists (select 1 from rms.tsfdetail td, tsfhead th where th.tsf_no >= k_tsf_no and
                    th.tsf_no = td.tsf_no and td.item = im.item_id and th.from_loc= n_from_loc)
          AND rownum<= 7 ORDER BY DBMS_RANDOM.VALUE;
  
BEGIN

select vdate INTO l_delivery_date from rms.period;

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
            L_RIB_XTsfDesc_REC.comment_desc   := 'IWTDISPATCH';
            L_RIB_XTsfDesc_REC.XTsfDtl_TBL    := l_RIB_XTsfDtl_TBL;

     
   
         RMS.RMSSUB_XTSF.CONSUME(O_status,O_error_message,L_RIB_XTsfDesc_REC,I_MESSAGE_TYPE);

           IF O_status_code = 'E' then 
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','FAILED',L_tsf_no, O_status_code,O_error_message);
                 
            else  
			
            INSERT INTO SKUMAR.VPT_LOGS (ENTITY,ENTITY_TYPE,STATUS_CODE,ENTITY_ID,STATUS,ERROR)
               VALUES ('TSF','IC','SUCCESS',L_tsf_no,O_status_code,O_error_message);

			INSERT INTO SKUMAR.iwtdispath (tsf_no) values (L_tsf_no) ;   
            
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


    select count(1) from 
      (select distinct ITEM_ID
        from skumar.cust_tsf_upld odf 
        where  FROM_LOC= '1001' and
           exists (select 1 from rms.item_loc_soh ils where ils.loc = '1001' and ils.STOCK_ON_HAND <= '10000' and ils.item = odf.ITEM_ID)) ;

select th.TO_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.TO_LOC;
select th.FROM_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.FROM_LOC;

select * from TRAN_DATA;
select count(1) from TRAN_DATA;
delete from TRAN_DATA_a where GL_REF_NO= '201';
delete from TRAN_DATA_b where GL_REF_NO= '201';


   select count(im.ITEM_ID)
    from skumar.cust_tsf_upld im 
      where FROM_LOC=  '1001' 
          AND not exists (select 1 from rms.tsfdetail td, tsfhead th where th.tsf_no >= '7267646472' and th.tsf_no = td.tsf_no and td.item = im.item_id and th.from_loc= '1001');