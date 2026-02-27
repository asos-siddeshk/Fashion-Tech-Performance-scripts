select * from all_tables where table_name like '%LIMIT%';

select * from MA_ASOS.MA_PO_APPROVAL_LIMIT_HEAD;
0	499
1	9999
2	99999
3	2000000
Update MA_ASOS.MA_PO_APPROVAL_LIMIT_HEAD set APPROVAL_LIMIT = '99999999999';
select * from MA_ASOS.MA_PO_APPROVAL_LIMIT_DETAIL;

select * from dba_source where text like '%ma_po_approval_limit_detail%';

select * from rms.sec_user;
select * from rms.sec_user_role;
select * from rms.rtk_role_privs;

select PROCESS_SEQ, TEMPLATE_ID, STATUS,        
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME
from ma_asos.MA_STG_UPLOAD_PROCESS 
   -- where TEMPLATE_ID='ITUDA' 
    --AND 
--    where process_seq in (466239,465176,464405,467156,464340)
    order by PROCESS_SEQ desc;

select * from ma_asos.ma_logs order by 1 desc;
select * from all_tables where table_name like '%UPLOAD%' and OWNER = 'MA_ASOS';;


select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq  in ('542233');
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq= '542233'; 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS where process_seq= '542233';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '542233';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '542233';
select * from ma_asos.MA_STG_UPLOAD_ZONE_CONF;



select * from ma_asos.MA_BARCODE_UPLOAD_Q_TBL;
select * from ma_asos.MA_STG_ITEM_UDA_UPLOAD;
select * from ma_asos.MA_STG_ITEM_UPLOAD;
select * from ma_asos.MA_STG_UPLOAD_BIZ_VALIDATIONS;
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR;
select * from ma_asos.MA_STG_UPLOAD_POST_BIZ_VAL;
select * from ma_asos.MA_STG_UPLOAD_PROCESS;
select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS;
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE;
select * from ma_asos.MA_STG_UPLOAD_TEMPLATE_CONFIG;
select * from ma_asos.MA_STG_UPLOAD_TEMPLATE_SQL;
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR;
select * from ma_asos.MA_STG_UPLOAD_UNBOUND_TYPES;
select * from ma_asos.MA_STG_UPLOAD_ZONE_CONF;
select * from ma_asos.MA_UPLOAD_RULE_QUERY;

select PROCESS_SEQ,count(1) from 
    ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in ( select PROCESS_SEQ  from 
        ma_asos.MA_STG_UPLOAD_PROCESS  where status! = 'P' and TEMPLATE_ID in ('ITUDA') )
    group by PROCESS_SEQ;  -- 300



select * from all_tables where table_name like '%THRE%' and owner like 'MA_ASOS';
select * from all_tables where table_name like '%THRE%' and owner like 'MA_ASOS';

select * from Ma_asos.MA_PRICE_EVENT_THRESHOLD;



select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS;
update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');

--drop table new_item_loc_batch ;
create table new_item_loc_batch as select * from rms.rpm_stage_item_loc;
delete from rms.rpm_stage_item_loc;
insert into rms.rpm_stage_item_loc select * from new_item_loc_batch;


SELECT ITEM_PARENT,dept,count(1) FROM ITEM_MASTER IM
    WHERE EXISTS (SELECT 1 FROM ma_asos.MA_STG_UPLOAD_PROCESS_IDS  MID 
                                                where process_seq  >= '138291' 
                                                AND MID.BUSINESS_OBJ_ID = IM.ITEM_PARENT) group by item_parent,dept;

SELECT distinct ITEM,dept FROM ITEM_MASTER IM
    WHERE EXISTS (SELECT 1 FROM ma_asos.MA_STG_UPLOAD_PROCESS_IDS  MID 
                                                where process_seq  >= '138291' 
                                                AND MID.BUSINESS_OBJ_ID = IM.ITEM);
                                                

select DIVISION, GROUP_NO, mv.DEPT, CLASS, SUBCLASS from ma_asos.ma_v_dept mv,ma_asos.ma_v_subclass ms where mv.DEPT= ms.DEPT
 ANd class = '1' and subclass = '1';

update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');
drop table uda_item_defaults_bk;
create table uda_item_defaults_bk as select * from rms.uda_item_defaults ;
delete from rms.uda_item_defaults;
insert into uda_item_defaults select * from uda_item_defaults_bk ;

update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' 
 where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');

select * from uda_item_lov;

select * from ma_asos.ma_size_profile_head where PRODUCT_GROUP='1006' AND CATEGORY= '5' AND SUBCATEGORY='1'
       AND BUSINESS_MODEL='2' AND  BUYING_GROUP='151';

   
   select * from ALL_TAB_COLUMNS where column_name like 'SIZE_GROUP';
   select * from int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG where SIZE_GROUP= '6190';
   
   
   select * from int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG where SIZE_GROUP= '6190';
   select * from int_asos.INT_PL_SIZPROF_DETAIL_UPLD_STG where SIZE_PROFILE= '1010151206190';

  select * from ma_asos.MA_SIZE_PROFILE_head where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');
  select * from ma_asos.MA_SIZE_PROFILE_DETAIL where SIZE_PROFILE  in ('4010151206190','3010151206190','1010151206190');
1010151206190
3010151206190
4010151206190


update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');

select * from ma_asos.Ma_errors where ma_error_text like 'Size Curve %';

   select * from ma_asos.MA_STG_UPLOAD_PROCESS order by 1 desc;


select * from ma_asos.ma_logs where trunc(LOG_TS) = trunc(sysdate) order by 1 desc;


select PROCESS_SEQ, TEMPLATE_ID, STATUS,        
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME
from ma_asos.MA_STG_UPLOAD_PROCESS 
    where TEMPLATE_ID like '%UDA%' 
    --AND process_seq in ( '138273','138210','37558')
    order by PROCESS_SEQ desc;

select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '439796';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq= '439796'; 
select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS where process_seq= '439796';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '438883';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '438883';


select * from svc_item_lov;





select * from item_Master where item in (select BUSINESS_OBJ_ID from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '37541')
union
select * from item_Master where item_parent in (select BUSINESS_OBJ_ID from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '37541');


select * from ma_asos.MA_ORDER_REC_HEAD_STG where option_id in (select BUSINESS_OBJ_ID from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '37526');
select * from ma_asos.MA_ORDER_REC_DETAIL_STG where ORDER_REC_NO in (select ORDER_REC_NO from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'P' and option_id in (select BUSINESS_OBJ_ID from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '37526')); 




select * from ma_asos.ma_buying_set where BUSINESS_MODEL ='2' and BUYING_GROUP ='151' and BUYING_SUBGROUP = '1' and buying_set = '1';
select * from ma_asos.ma_buying_set where BUSINESS_MODEL ='2' and BUYING_GROUP ='151' and BUYING_SUBGROUP = '1' and buying_set = '1';


select * from ma_asos.ma_logs where trunc(LOG_TS) = trunc(sysdate) order by 1 desc;

select * from  rtk_errors where rtk_text like 'Invalid%'; INV_UDA_FOR_TYPE

select * from all_tables where table_name like '%ERROR%' and owner like 'RMS';

select ORDER_NO from ordhead oh where status ='A' and PICKUP_DATE >='25-MAR-22'
and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no)
and rownum <= '1000';



select * from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'U' and option_id ='114940595';
select * from ma_asos.MA_ORDER_REC_DETAIL_STG where ORDER_REC_NO in (select ORDER_REC_NO from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'U' and option_id ='114940595'); 


select * from diff_group_head where diff_group_id in ('2000');
select * from diff_group_head where diff_group_id in ('4000');
select * from diff_group_detail where diff_group_id in ('6190');


select * from ma_asos.ma_stg_ordloc_discount;


 select PROCESS_SEQ, TEMPLATE_ID, STATUS,UPLOAD_USER,     
       to_char(ENQUEUE_DATETIME,'dd-mon-yy hh:mi:ss am') ENQUEUE_DATETIME,
       to_char(DEQUEUE_START_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_START_DATETIME,
       to_char(DEQUEUE_END_DATETIME,'dd-mon-yy hh:mi:ss am') DEQUEUE_END_DATETIME
 from ma_asos.MA_STG_UPLOAD_PROCESS 
where         TEMPLATE_ID in ('ITUDA')    and 
        ENQUEUE_DATETIME>= to_date('22-NOV-2023 09:00', 'DD-MON-YYYY hh24:mi')
    --AND process_seq in ( '138652','138210','37558')
    order by PROCESS_SEQ desc;

select ms.PROCESS_SEQ,TEMPLATE_ID,UPLOAD_USER,
status,count(1) as Upload_counts from 
    ma_asos.MA_STG_UPLOAD_PROCESS_LINE msu , ma_asos.MA_STG_UPLOAD_PROCESS ms 
        where ms.process_seq  = msu.PROCESS_SEQ  --and status = 'P' --and TEMPLATE_ID in ('ITUDA') 
        and ms.ENQUEUE_DATETIME>= to_date('22-NOV-2023 07:00', 'DD-MON-YYYY hh24:mi')
    group by ms.PROCESS_SEQ,UPLOAD_USER,TEMPLATE_ID,status;  -- 300


select PROCESS_SEQ,count(1) from 
    ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq in ( select PROCESS_SEQ  from 
        ma_asos.MA_STG_UPLOAD_PROCESS  where status = 'P' --and TEMPLATE_ID in ('ITUDA') 
            and ENQUEUE_DATETIME>= to_date('22-NOV-2023 09:00', 'DD-MON-YYYY hh24:mi'))
    group by PROCESS_SEQ;  -- 300

select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '522552';


select * from ma_asos.ma_logs order by 1 desc;

select * from ma_asos.ma_logs where trunc(LOG_TS) = trunc(sysdate) order by 1 desc;

select * from MA_ASOS.MA_STG_ITEM_HEAD where item ='100322803' or ITEM_PARENT ='100322803' or ITEM_grand_PARENT ='100322803';

select * from ITEM_MASTER where item ='101175978' or ITEM_PARENT ='101175978' or ITEM_grandPARENT ='101175978';


select * from ITEM_MASTER where ITEM_LEVEL= '3';
select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '138733';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq= '138733';  -- 200

select * from ma_asos.MA_STG_UPLOAD_PROCESS_IDS where process_seq= '138715';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '138715';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '138715';


select order_no,status,NOT_BEFORE_DATE, NOT_AFTER_DATE, EARLIEST_SHIP_DATE, LATEST_SHIP_DATE,PICKUP_DATE from ordhead 
   where order_no in (select ATTR_2 from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq>= '138767')
   order by 1;

select ORDER_NO,PICKUP_DATE,master_po_no from ordhead oh where status ='A' and PICKUP_DATE >='04-APR-22' 
  and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no)
   and rownum <= '1000'
   order by 3;


select * from(
 select im.item from item_master_op im)
        where rownum <= '5000';

IPPT	Threshold to number of lines in the upload of Item PIM Product Type	500
ITDESC	Threshold to number of lines in the upload of Item Descriptions template	500


  select u.uda_id
    from ma_asos.ma_uda_conf u
   where u.uda_type = 'PIM_PRODUCT_TYPE';

  select *
    from ma_asos.ma_v_upload_ippt c;
  
  select * from dba_source where text like '%ITDESC%' and owner like 'MA_ASOS';
  
  
  