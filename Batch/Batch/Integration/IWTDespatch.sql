select tsf_no,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS DateCreatedUtc ,w1.WH_NAME_SECONDARY as FROM_LOC, w2.WH_NAME_SECONDARY as TO_LOC from rms.tsfhead th,rms.wh w1,rms.wh w2 where th.status='A' and th.FROM_LOC =w1.wh and th.TO_LOC =w2.wh and  th.tsf_no in (select tsf_no from skumar.iwtdispath);

select count(1) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);
select count(1) from shipment where shipment in (select shipment from shipsku where distro_no in (select tsf_no from skumar.iwtdispath));

select * from shipment where shipment in (select shipment from shipsku where distro_no in (select tsf_no from skumar.iwtdispath));

select * from rib_message where MESSAGE_NUM>'90193656'order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM>'90193656' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM>'90193656' group by FAMILY order by 1 desc;
select * from rib_message where FAMILY ='XTsf' and MESSAGE_NUM>'90193656' order by 1 desc;

select tsf_no,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS DateCreatedUtc ,w1.WH_NAME_SECONDARY as FROM_LOC, w2.WH_NAME_SECONDARY as TO_LOC from rms.tsfhead th,rms.wh w1,rms.wh w2 where th.status ='A' and th.FROM_LOC =w1.wh and th.TO_LOC =w2.wh and  th.tsf_no in (select tsf_no from skumar.iwtdispath);
select wh, WH_NAME, WH_NAME_SECONDARY, length(WH_NAME), length(WH_NAME_SECONDARY) from wh;

    "ns" : "iwtdespatch.publishedIWTDespatchDTHUB",
    "count" : 41555,  --49676
     "ns" : "iwtdespatch.publishedIWTDespatchRMS",
    "count" : 4185393,  -- 4193514
     "ns" : "iwtdespatch.publishedXTsfRMS",
    "count" : 246190, --249213
 Post:    

select 49676-41555 from dual;
select 4193514-4185393 from dual;
select 249213-246190 from dual;

    
    ASNOut(IWT Despatch)	
 -- 098b - 18,950

<?xml version="1.0" encoding="UTF-8"?>
<IWTDespatch xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="IWT Despatch.xsd">
    <DespatchAdvice>
        <DespatchingWarehouseId>FC01</DespatchingWarehouseId>
        <ReceivingWarehouseId>FC04</ReceivingWarehouseId>
        <DateCreatedUtc>2018-09-28T09:03:42Z</DateCreatedUtc>
        <Consignments>
            <Consignment dateDespatchedUtc="2018-09-28T09:03:42Z" vehicleId="7217070037">
                <Box id="4110265665">
                    <IwtAdvice id="T0047000025011" type="Manual">
                        <SkuItem id="6857928" quantity="5" />
                        <SkuItem id="6857928" quantity="5" />
                        <SkuItem id="6857928" quantity="5" />
                        <SkuItem id="6857928" quantity="5" />
                    </IwtAdvice>
                </Box>
                <Box id="8933961429">
                    <IwtAdvice id="T0047000025011" type="Manual">
                        <SkuItem id="6857928" quantity="5" />
                    </IwtAdvice>
                </Box>
            </Consignment>
        </Consignments>
    </DespatchAdvice>
</IWTDespatch>

7011549061	18-JUL-19	FC04	RC31

drop table iwtdispath2;
create table iwtdispath2 as
select tsf_no from tsfhead where 1=2;

begin
delete from iwtdispath;
insert into iwtdispath2
select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='1001' and rownum <= '1500'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no);

insert into iwtdispath
select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='3001' and rownum <= '1500'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no);

insert into iwtdispath
select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='4001' and rownum <= '1500'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no);

insert into iwtdispath
select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='6001' and rownum <= '500'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no);
end;
/
select * from wh;

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath TO rdatla; 

select count(distinct(shipment)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);
select count(distinct(shipment)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath_jb);


select th.TO_LOC, count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.TO_LOC;
select th.FROM_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.FROM_LOC;

select th.FROM_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath_jb) group by th.FROM_LOC;
select th.TO_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath_jb) group by th.TO_LOC;


select count(distinct(shipment)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath_jb);
select count(distinct(shipment)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);

select tsf_no,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS DateCreatedUtc ,w1.WH_NAME_SECONDARY as FROM_LOC, w2.WH_NAME_SECONDARY as TO_LOC 
from rms.tsfhead th,wh w1,wh w2 where th.FROM_LOC =w1.wh and th.TO_LOC =w2.wh 
and  th.tsf_no in (select tsf_no from skumar.iwtdispath);

select td.tsf_no,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS dateDespatchedUtc, 'V'||td.tsf_no as vehicleId,'B'||td.tsf_no as Boxid,
item as SkuItemid,TSF_QTY as quantity, 'T'||LPAD( w1.PHYSICAL_WH,3,0)||td.tsf_no as IwtAdvice_id
from rms.tsfdetail td,rms.tsfhead th, rms.wh w1 where td.tsf_no in (select tsf_no from skumar.iwtdispath) and td.tsf_no =th.tsf_no and th.TO_LOC =w1.wh;


T0178028600369


select * from tsfhead where tsf_no ='7008600392';
select * from wh;


select * from rib_message  order by 1 desc;
select * from rib_message where MESSAGE_NUM >'11633476' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM >'11633476' order by 1 desc;



select * from rms.tsfhead th where status ='A' and tsf_type!='CO'
and not exists (select 1 from rms.shipsku sk where sk.distro_no = th.tsf_no) and rownum <= '10';

select * from rms.tsfhead where tsf_no in ('7008624933');
select * from rms.tsfdetail where tsf_no in ('7008624933');
select * from rms.shipment where shipment in (select shipment from rms.shipSKU where DISTRO_NO in ('7008624933'));
select * from rms.shipSKU where DISTRO_NO in ('7008624933');

select * from rib_message where MESSAGE_NUM>'632237' order by 1 desc;
select * from rib_message where MESSAGE_NUM ='632237' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM ='632237' order by 1 desc;

7008584678
select * from tsfhead where tsf_no in ('7027923126');
select * from tsfdetail where tsf_no in ('7027923126');
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in ('7027923126'));
select * from shipSKU where DISTRO_NO in ('7027923126');
select * from doc_close_queue where doc in ('7027923126');

select * from rib_message where MESSAGE_NUM>'65952330'order by 1 desc;
select count(1) from rib_message where MESSAGE_NUM>'65952330' order by 1 desc;
select FAMILY,count(1) from rib_message where MESSAGE_NUM>'65952330' group by FAMILY order by 1 desc;
select * from rib_message where FAMILY ='XTsf' and MESSAGE_NUM>'65952330' order by 1 desc;

select * from rib_message where MESSAGE_NUM>'65952330' order by 1 desc;
select * from rib_message where MESSAGE_NUM ='632237' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM ='632237' order by 1 desc;


select * from rib_message where MESSAGE_NUM ='11633463' order by 1 desc;
select * from rib_message_failure where MESSAGE_NUM ='11633463' order by 1 desc;
select * from rib_message where id = '5009143386';

select * from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);

select count (distinct (distro_no)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);
select count (distinct (distro_no)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath_jb);

select * from iwtdispath_jb;
select * from iwtdispath_jb;

T000000130011737


--drop table iwtdispath_jb;
create table iwtdispath_jb as
select tsf_no from tsfhead  where 1=2; 


select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='1001' and rownum <= '2200'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no)
    and not exists (select 1 from iwtdispath ski where ski.tsf_no =th.tsf_no);

insert into iwtdispath_jb
select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='3001' and rownum <= '1500'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no)
    and not exists (select 1 from iwtdispath ski where ski.tsf_no =th.tsf_no);

insert into iwtdispath_jb
select tsf_no from tsfhead th where tsf_type!='CO' and status ='A' and from_loc ='4001' and rownum <= '1500'
    and not exists (select 1 from shipsku sk where sk.distro_no =th.tsf_no)
    and not exists (select 1 from iwtdispath ski where ski.tsf_no =th.tsf_no);

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_jb TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_jb TO sshastry; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath_jb TO sshastry; 

CREATE SEQUENCE manujobber_seq
  MINVALUE 1
  START WITH 111111111
  INCREMENT BY 1
  CACHE 2;

select manujobber_seq.nextval from dual;

desc iwtdispath_jb;

ALTER TABLE iwtdispath_jb 
ADD (
    jobid NUMBER(12));
 
select * from skumar.iwtdispath_jb;
 
set serveroutput on;
set timing on;
declare
l_tsf_no rms.tsfhead.tsf_no%type;
l_exists rms.tsfhead.tsf_no%type;
l_job_id rms.tsfhead.tsf_no%type;
CURSOR cur_dept IS
  select tsf_no from skumar.iwtdispath_jb where JOBID is null;
  
cursor c_reclass (l_tsf_no rms.tsfhead.tsf_no%type) is
         select 1 from rms.tsfhead where tsf_no = l_tsf_no;

Begin
for k in cur_dept loop
   l_tsf_no := k.tsf_no;
 select '5'||skumar.manujobber_seq.nextval into l_job_id from dual;

   open c_reclass(l_job_id);
   fetch c_reclass into l_exists;
      if c_reclass%NOTFOUND then
     update skumar.iwtdispath_jb set JOBID = l_job_id where tsf_no = l_tsf_no;
  end if;
close c_reclass;
end loop;

EXCEPTION
WHEN OTHERS THEN
 dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


select ij.jobid as tsf_no,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS DateCreatedUtc ,
    w1.WH_NAME_SECONDARY as FROM_LOC, w2.WH_NAME_SECONDARY as TO_LOC 
from rms.tsfhead th,wh w1,wh w2, skumar.iwtdispath_jb ij where th.FROM_LOC =w1.wh and th.TO_LOC =w2.wh 
and  th.tsf_no = ij.tsf_no;

select ij.jobid as tsf_no, TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS')||'Z' AS dateDespatchedUtc, 
   'V'||ij.jobid as vehicleId,'B'||ij.jobid as Boxid, item as SkuItemid,TSF_QTY as quantity,
  'T'||LPAD( w1.PHYSICAL_WH,3,0)||ij.jobid  as IwtAdvice_id
from rms.tsfdetail td,rms.tsfhead th, rms.wh w1, skumar.iwtdispath_jb ij
where td.tsf_no = ij.tsf_no and td.tsf_no =th.tsf_no and th.TO_LOC =w1.wh;

select * from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);
select * from shipsku where distro_no in (select tsf_no from skumar.iwtdispath_jb);

select * from tsfhead where tsf_no in (select tsf_no from skumar.iwtdispath_jb);
select * from tsfhead where tsf_no in (select jobid from skumar.iwtdispath_jb);


select FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE, count(1) from rib_message where MESSAGE_NUM>'637426' group by FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE;

select count(distinct(shipment)) from shipsku where distro_no in (select jobid from skumar.iwtdispath_jb);
select count (distinct (distro_no)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);


select * from tsfhead where tsf_no in ('7008588136');
select * from tsfdetail where tsf_no in ('7008588136');
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in ('7008588136'));
select * from shipSKU where DISTRO_NO in ('7008588136');
select * from doc_close_queue where doc in ('7008588136');

select * from rib_message order by 1 desc;

select FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE, count(1) from rib_message where trunc(PUBLISH_TIME)>= '08-NOV-21' group by FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE;

select * from rib_message where MESSAGE_NUM>'49076488' order by 1 desc;

select FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE, count(1) from rib_message where MESSAGE_NUM>'49076488' group by FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE;
select FAMILY,count(1) from rib_message where MESSAGE_NUM>'49076488' group by FAMILY order by 1 desc;
select * from rib_message where FAMILY ='XTsf' and MESSAGE_NUM>'49076488' order by 1 desc;


RMSSUB_ASNOUT.CONSUME(?,?,?,?)}: [E] The From and To Location must not be a warehouse for Externally Generated Transfers. 
From Location: 4; To Location: 1; Program Name: RMSSUB_ASNOUT.VALIDATE_TSF.

Error from {call RMSSUB_ASNOUT.CONSUME(?,?,?,?)}: [E] Invalid cost/retail combination passed to function STKLEDGR_SQL.BUILD_TRAN_DATA_INSERT. 
Notify System Administrator.



select th.TO_LOC, th.FROM_LOC, count(1) from rms.tsfhead th where th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.TO_LOC,th.FROM_LOC;

select th.from_loc,th.TO_LOC, count(1) from rms.tsfhead th where th.status = 'A' and  th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.TO_LOC,th.from_LOC order by 1,2;
select  count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtdispath);
select  count(1) from rms.tsfhead th where th.status! = 'A' and th.tsf_no in (select tsf_no from skumar.iwtdispath);

select th.from_loc,th.TO_LOC, count(1) from rms.tsfhead th where th.status = 'A' and  th.tsf_no in (select tsf_no from skumar.iwtdispath) group by th.TO_LOC,th.from_LOC order by 1,2;
select  count(1) from rms.tsfhead th where th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtdispath);
select  count(1) from rms.tsfhead th where th.status != 'A' and th.tsf_no in (select tsf_no from skumar.iwtdispath);
select  td.item,count(1) from tsfdetail td, rms.tsfhead th where th.tsf_no = td.tsf_no and th.status = 'A' and th.tsf_no in (select tsf_no from skumar.iwtdispath) group by td.item order by 2 desc;
delete from iwtdispath where tsf_no in (select tsf_no from tsfhead where status!= 'A');
delete from iwtdispath where tsf_no in (select tsf_no from tsfhead where status!= 'A');


delete from iwtdispath;
delete from VPT_LOGS;
delete from cust_tsf_upld where cust_tsf_upld.quantity <= '50';

select count(1) from VPT_LOGS;
select * from VPT_LOGS;

select rms.TRANSFER_NUMBER_SEQUENCE.nextval from dual; --8032600430

    select 	wh2.wh from rms.wh wh1, rms.wh wh2 
  	where 	wh1.org_unit_id=wh2.org_unit_id and wh1.wh = '1001'
    ORDER BY dbms_random.value; 


alter session set current_schema=rms;

set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 2100;
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
  	where 	wh1.org_unit_id!=wh2.org_unit_id and wh1.wh = n_from_loc
    ORDER BY dbms_random.value; 
 

  CURSOR cur_item IS    
   select im.ITEM_ID, '1' as tsf_qty
    from skumar.cust_tsf_upld im 
      where FROM_LOC= n_from_loc 
          and QUANTITY >= '20'
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