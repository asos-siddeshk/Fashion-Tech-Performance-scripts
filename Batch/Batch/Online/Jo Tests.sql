select * from rms.wh where STOCKHOLDING_IND= 'Y';
select item_level,count(1) from rms.item_master where item_level in ('1','2') group by item_level;
select * from store;
select * from all_views where view_name like '%PRIC%';
select * from all_tables where table_name like '%NTI%';

--Pricing Loc: 
select count(1) from ma_asos.MA_V_PRICING_LOC;
--Physical Loc: 
select * from rms.wh where STOCKHOLDING_IND= 'Y';
--Legal entities
select count(1) from TSF_ENTITY;
select * from rms.TSF_ENTITY;
--Option / SKU
select item_level,count(1) from rms.item_master where item_level in ('1','2') group by item_level;
--Transfers : 
select TSF_TYPE,count(1) from rms.tsfhead where status!='C' group by TSF_TYPE; 
9M open transfers
5087 - External 
1147 - Manual 	
9367610 - Customer order	
4235  - InterCompany	


select status,count(1) from rms.ordhead  group by status; 
425146 - Open POs
395272 - Open Allocations

select status,count(1) from rms.alloc_header  group by status; 

select trunc(ADJ_DATE),count(1) from rms.inv_adj group by trunc(ADJ_DATE) orDEr by b1 ;

select count(1) from rms.ordhead where CREATE_DATETIME>= to_date('22-DEC-2020 10:30', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%';

select count(1) from alloc_header where order_no in 
    (select order_no from rms.ordhead where CREATE_DATETIME>= to_date('22-DEC-2020 10:30', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%');
    
select loc,count(1) from rms.ITEM_loc group by loc;

select * from rms.ITEM_MFQUEUE ;
select * from rms.ITEMloc_MFQUEUE ;


select * from rms.raf_notification order by 1 desc;


select * from item_master_op;

drop table item_master_op;
create table item_master_op as 
select ITEM, DEPT, CLASS, SUBCLASS, STATUS, ITEM_LEVEL, TRAN_LEVEL
    from rms.item_master im where im.item_level = '1' and im.status = 'A';
    
    
select * from item_master_op;
select * from option_item_counts;

create table option_item_counts as 
select im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET, count(1) as count_options
    from v_item_master im, ma_asos.ma_v_item ma,item_master_op op where op.item = ma.item and im.item = ma.item 
    group by im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET;

 select * from ma_asos.ma_v_item;



select im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET
    from v_item_master im, ma_asos.ma_v_item ma,item_master_op op where op.item = ma.item and im.item = ma.item ;
    

 select * from option_item_counts where COUNT_OPTIONS > 120 order by COUNT_OPTIONS;


select * from skulist_head where trunc(CREATE_DATE) >= '25-NOV-20';
select * from skulist_head where trunc(CREATE_DATE) >= '26-OCT-20' order by 1 desc;
select skulist,count(1) from skulist_detail where skulist in (select skulist from skulist_head where trunc(CREATE_DATE) >= '26-jan-20') 
--having count(1) 
    group by skulist order by 1 desc;
select skulist,count(1) from skulist_detail group by skulist;

select * from ma_asos.MA_V_GOLD_SEAL where item in (select item from skulist_detail where skulist = '150199');

select * from skulist_head where SKULIST_DESC like '%Price%';

select * from ma_asos.MA_STG_UPLOAD_PROCESS order by 1 desc;
select * from rms.raf_notification order by 1 desc;
select * from rms.raf_notification where CREATED_BY not like 'PTESTUSER%' order by 1 desc;
select * from rms.raf_notification where CREATED_BY like 'JOANNEPOWELL' order by 1 desc;

select PROCESS_SEQ, TEMPLATE_ID, STATUS,        
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME
from ma_asos.MA_STG_UPLOAD_PROCESS 
    --where TEMPLATE_ID='ITEMS' 
    order by PROCESS_SEQ desc;

select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '6385';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq = '6385';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '6385';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '6385';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '6385';

select PROCESS_SEQ, ITEM, STATUS, ERROR_MESSAGE, ERROR_MESSAGE_DETAIL,
       to_char(CREATE_DATETIME,'dd-mon-yy hh:mi:ss am') CREATE_DATETIME ,         
       to_char(LAST_UPDATE_DATETIME,'dd-mon-yy hh:mi:ss am') LAST_UPDATE_DATETIME,
        CREATE_ID, LAST_UPDATE_ID
from ma_asos.ma_item_mass_mnt_process 
where PROCESS_SEQ in ('12566')  
  --  and status = 'P'
    order by LAST_UPDATE_DATETIME desc;


select * from all_tables where table_name like '%NB_%';

select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;

Update ma_asos.MA_PRICE_EVENT_THRESHOLD set PRICE_CHANGE_LOCS='10', CLEARANCE_LOCS='10', SIMPLE_PROMO_LOCS='5000', COMPLEX_PROMO_LOCS='10', CLEARANCE_RESET_LOCS='10';
Update ma_asos.MA_PRICE_EVENT_THRESHOLD set SIMPLE_PROMO_LOCS='5000';

select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%THR%';
select * from rms.NB_SYSTEM_PARAMETERS where PARAMETER like '%SEA%'; 
--3500
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='SPROMO';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='CLRCES';

select PROCESS_SEQ, STATUS, ERROR_MESSAGE, ERROR_MESSAGE_DETAIL,
       to_char(CREATE_DATETIME,'dd-mon-yy hh:mi:ss am') CREATE_DATETIME ,         
       to_char(LAST_UPDATE_DATETIME,'dd-mon-yy hh:mi:ss am') LAST_UPDATE_DATETIME,
        CREATE_ID, LAST_UPDATE_ID
from ma_asos.MA_ITEM_LOC_MASS_MNT_PROCESS --where PROCESS_SEQ in ('84') 
    order by LAST_UPDATE_DATETIME desc;

select * from ma_asos.MA_ITEM_LOC_MASS_MNT_HEADER;

MA_MASS_MNT_JOB_12547_10
MA_MASS_MNT_JOB_12548_5

select * from ma_asos.MA_ITEM_LOC_MASS_MNT_REPL_DAYS;


select * from ma_asos.ma_item_mass_mnt_process  mmp 
        where create_datetime >=to_date('27-JAN-2020 14:00', 'DD-MON-YYYY hh24:mi')
        and exists (select 1 from ma_asos.MA_ITEM_MASS_MNT_HEADER mmh where mmh.PROCESS_SEQ = mmp.PROCESS_SEQ and mmh.gold_seal ='1');
        
select uil.* from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='1')
    where uil.item in (select item from skulist_detail where skulist = '2733024' )
   --  and uil.UDA_VALUE ='1' 
    and uil.uda_id = '4001' ; -- Blindgold
    
    
select * from hts where hts ='4202929190';

select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '37386';


select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '37386';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq= '37386';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '37386';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '37386';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '37386';

select u.* from ma_asos.ma_rule_set_uda m, uda u where m.uda_id = u.uda_id and rule_set like '%GOLD_SEAL%' and dept ='1001' and class ='6';
select * from uda;

DENIM WASH COLOUR
COUNTER SEASONAL
PRODUCT TYPE
FIT
PIM REFINING STYLE
PATTERN
PRICE BANDING
FABRIC TYPE
SUSTAINABLE FIBRES
ECO EDIT
DENIM RIP
FLOW
PRODUCT CLASSIFICATION
STYLE 
WEBSITE GENDER
 

select PROCESS_SEQ, ITEM, STATUS, ERROR_MESSAGE, ERROR_MESSAGE_DETAIL,
       to_char(CREATE_DATETIME,'dd-mon-yy hh:mi:ss am') CREATE_DATETIME ,         
       to_char(LAST_UPDATE_DATETIME,'dd-mon-yy hh:mi:ss am') LAST_UPDATE_DATETIME,
        CREATE_ID, LAST_UPDATE_ID
from ma_asos.ma_item_mass_mnt_process 
 --where PROCESS_SEQ in ('6800') 
   -- and status = 'P'
    order by LAST_UPDATE_DATETIME desc;


select * from shipment where order_NO IN (SELECT ORDER_NO FROM ORDHEAD WHERE MASTER_PO_NO IN ('29000494'));

SELECT * FROM RIB_MESSAGE ORDER BY 1 DESC;

SELECT * FROM DIFF_ids WHERE DIFF_ID IN ('2000','1000');


SELECT * FROM DIFF_GROUP_HEAD WHERE DIFF_GROUP_ID IN ('2000','1000','3064');


SELECT * FROM DIFF_GROUP_HEAD WHERE DIFF_GROUP_ID IN ('2000','1000','3064');
SELECT * FROM DIFF_GROUP_DETAIL WHERE DIFF_GROUP_ID IN ('2000','1000','3064');


SELECT * FROM DIFF_GROUP_HEAD WHERE DIFF_GROUP_DESC LIKE '%One%';
SELECT * FROM DIFF_GROUP_HEAD WHERE DIFF_GROUP_ID IN ('3132','3133');
SELECT * FROM DIFF_GROUP_DETAIL WHERE DIFF_GROUP_ID IN ('3132','3133');



select  * from option_item_counts;



set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;
l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist           number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM              VARCHAR2(25);
l_date              date;
l_DEPT              rms.subclass.dept%type;
l_CLASS             rms.subclass.class%type;
l_SUBCLASS          rms.subclass.subclass%type;
l_Count             number(4);


CURSOR c_dept is 
select DEPT, CLASS, SUBCLASS, counts from (
select DEPT, CLASS, SUBCLASS,count(distinct(PRICE_CHANGE_ID))  as counts
    from pricemasssearch_a group by DEPT, CLASS, SUBCLASS having count( distinct (PRICE_CHANGE_ID)) > 2000 order by count(distinct(PRICE_CHANGE_ID))
    ) where rownum<= '5';

CURSOR c_itemlist (l_DEPT rms.subclass.dept%type,l_CLASS rms.subclass.class%type,l_SUBCLASS rms.subclass.subclass%type) is
    select distinct item  from pricemasssearch_a where DEPT=l_DEPT and class=l_CLASS and SUBCLASS =l_SUBCLASS;
    
    
BEGIN
for m in c_dept loop 
    
    l_DEPT      :=  m.DEPT;
    l_CLASS     :=  m.CLASS;
    l_SUBCLASS  :=  m.SUBCLASS;
    l_Count     :=  m.Counts;

   select sysdate into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'Mass APCSearch '||'-'||l_Count||'-'||l_REF_NO;
		I_filename 		:= 'Mass APCSearch '||'-'||l_Count||'-'||l_REF_NO;

FOR i in c_itemlist (l_DEPT, l_CLASS , l_SUBCLASS)  Loop 
            l_item     :=i.item;


insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);


 END LOOP;
 END LOOP;

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/




select im.item_parent as option_id, oh.order_no, oh.master_po_no
    from item_master im, ordsku ol, ordhead oh
    where im.item = ol.item 
    and ol.order_no = oh.order_NO 
    and oh.master_po_no in ('500786','500788','500797','500799','500785','500787','500798');


    
select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%UPLD_THRESHOLDS%';    
select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%IMA_THRESHOLDS%';
select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%POMA_THRESHOLDS%';
select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%PMA_THRESHOLDS%';
select * from rms.NB_SYSTEM_PARAMETERS where PARAMETER like '%SEA%'; 

select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%THRESHOLDS%';

update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='ITEMS';

--last
select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%UPLD_THRESHOLDS%';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='ITEMS';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='SPROMO';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='UPLD_THRESHOLDS' and PARAMETER='CLRCES';
--Now
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_ILMM';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1000' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_DLT';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1000' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_GS';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1000' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_MM';

update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '500' where FUNC_AREA='POMA_THRESHOLDS' and PARAMETER='POMA_SEARCH_SELECTALL_DLT';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '500' where FUNC_AREA='POMA_THRESHOLDS' and PARAMETER='POMA_SEARCH_SELECTALL_DLTREC';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '100' where FUNC_AREA='POMA_THRESHOLDS' and PARAMETER='MASSMAINT_SELECTALL';

--DASH UI
update DASH_ASOS.DASH_SYSTEM_PARAMETERS set VALUE_1= '50' where FUNC_AREA='PO_THRESHOLD' and PARAMETER='PO_REC_MAXRECS';
update DASH_ASOS.DASH_SYSTEM_PARAMETERS set VALUE_1= '100' where FUNC_AREA='PO_THRESHOLD' and PARAMETER='COMMITMENT_MAXRECS';
update DASH_ASOS.DASH_SYSTEM_PARAMETERS set VALUE_1= '100' where FUNC_AREA='PO_THRESHOLD' and PARAMETER='ACT_ASN_MAXRECS';

select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%POMA_THRESHOLDS%';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='POMA_THRESHOLDS' and PARAMETER='PO_SEARCH_MAXRECS';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='POMA_THRESHOLDS' and PARAMETER='POMA_SEARCH_SELECTALL_DLTREC';


select * from rms.NB_SYSTEM_PARAMETERS where FUNC_AREA like '%IMA_THRESHOLDS%';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '5000' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='OPTION_POPUP_SELECTALL';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_DLT';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_GS';
update rms.NB_SYSTEM_PARAMETERS set VALUE_1= '1500' where FUNC_AREA='IMA_THRESHOLDS' and PARAMETER='ITEM_SEARCH_SELECT_MM';
