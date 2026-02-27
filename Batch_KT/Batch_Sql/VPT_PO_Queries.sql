--delete from rms.DAILY_PURGE;
--delete from rms.ORDHEAD_LOCK;

PO Queries

---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------

--PO Creation
select * from rms.item_master where status ='A' and item_level ='1'
and Item_DESC='Item creation Perf Test' and CREATE_DATETIME>='05-MAY-21'
and brand_name='ASOS'
order by create_datetime asc;

select distinct item_parent from item_master im 
left join ordloc ol on ol.item=im.item
where im.CREATE_DATETIME>='22-DEC-18' and ol.item is  null 
and item_desc = 'Item creation Perf Test';

select * from item_master where item='101428059';
select * from ordloc where item ='101039144';
select * from ordhead where master_po_no='22663261';
-- PO Update 10.71

select master_po_no from (
select oh.master_po_no,po_type,min(EARLIEST_SHIP_DATE) from rms.ordhead oh
inner join (
select oh.master_po_no from rms.ordhead oh
inner join (
select oh.master_po_no,min(EARLIEST_SHIP_DATE) ship_date
from rms.ordhead oh where oh.create_datetime>='10-MAR-22' and comment_desc = 'po create D' --and po_type='D'
group by oh.master_po_no) dat on dat.master_po_no=oh.master_po_no
and oh.earliest_ship_date=dat.ship_date and oh.po_type='D' 
inner join (select order_no,sum(qty_ordered) qty from rms.ordloc group by order_no  )ol on ol.order_no=oh.order_no
where ol.qty=70
minus
select distinct oh.master_po_no from rms.ordhead oh
inner join rms.shipment sh on sh.order_no=oh.order_no
where oh.create_datetime>='10-MAR-22' and comment_desc = 'po create D'
minus
select distinct oh.master_po_no from rms.ordhead oh
inner join rms.alloc_header sh on sh.order_no=oh.order_no
where oh.create_datetime>='10-MAR-22' and oh.comment_desc = 'po create D'
minus
select distinct master_po_no from rms.ordhead oh
where oh.create_datetime>='10-MAR-22' and oh.comment_desc  like '%PO Update%'
minus
select distinct master_po_no from (
select master_po_no, count(1) from rms.ordhead oh
where oh.create_datetime>='10-MAR-22' and comment_desc = 'po create D'
group by master_po_no,EARLIEST_SHIP_DATE having count(1)>1)
minus
select distinct oh.master_po_no from rms.ordhead oh
where oh.create_datetime>='10-MAR-22' and comment_desc = 'po create D' and status='C'
) oh2 on oh2.master_po_no=oh.master_po_no
group by oh.master_po_no,po_type) where po_type='D'  order by master_po_no desc;

-- PO Replenishment 
SELECT distinct rep.parent--,rep.item,rep.need_date,count(1)
-- ,supp.supplier 
FROM
    ma_asos.ma_v_replenishment rep
inner join rms.item_supp_country supp on supp.item=rep.parent
inner join rms.item_master im on im.item_parent=rep.parent 
where supp.supplier=1100000086 and rep.item_desc not like 
'%UploadTest%'; order by rep.parent desc; and rep.parent='101045324';-- group by rep.parent,rep.item,rep.need_date having count(1)>1;

--and im.diff_2!='ALLSIZES';
--and rep.qty_ordered = 3 and size_code ='W36L30';

select item from MA_ASOS.ma_v_repl where parent='123307015';
select * from ma_asos.ma_v_replenishment where parent='101392849';
select parent from(
select  parent,item,size_code, count (1) from ma_asos.ma_v_replenishment 
group by parent,item,size_code
having count(1)=1);

--Single po search
select unique master_po_no from rms.ordhead 
where CREATE_DATETIME>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi');

--PO Mass search
    select * from po_mass_search order by 1,2,3,4;
    
select  div.position,dpt.position--mm.division-1,mm.dept,dpt.position,cl.class_position,scl.subcls_position,mm.count 
from po_mass_search mm
inner join dept_position dpt on dpt.dept=mm.dept
inner join div_position div on div.division=mm.division
inner join class_position cl on cl.class=mm.class and mm.dept=cl.dept
inner join subclass_position scl on scl.class=mm.class and mm.dept=scl.dept and scl.subclass=mm.subclass
inner join biz_position buss on buss.business_model=mm.business_model
inner join buygrp_position buygrp on buygrp.business_model=mm.business_model and buygrp.buying_group=mm.buying_group
inner join buysubgrp_position buysub on buysub.business_model=mm.business_model and buysub.buying_group=mm.buying_group
and buysub.buying_subgroup=mm.buying_subgroup
inner join buyset_position buyset on buyset.business_model=mm.business_model and buyset.buying_group=mm.buying_group
and buyset.buying_subgroup=mm.buying_subgroup and buyset.buying_set=mm.buying_set;

select * from MA_ASOS.ma_buying_set;

create table buyset_position as
select BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,buying_set,
rank ()over (partition by BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP order by BUYING_set_NAME)-1 
buyset_position from MA_ASOS.ma_buying_set ;


select * from MA_ASOS.ma_buying_subgroup where business_model=1 and buying_group=128 order by buying_subgroup_name;

    

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d where dept=1001 group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 500 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d --where dept=1001 
    group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 1000 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d --where dept=1001 
    group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 2000 order by count(distinct(order_no));*/

-- PO Planning
select * from  SKUMAR.ITEM_PO_PLAN3 pl
where  exists(select * from ma_asos.ma_v_planning where rec_source='P' and option_id=pl.item_parent);

select  * from ma_asos.ma_v_planning where option_id=105613238; rec_source='P' and qty_ordered=100 and order_level=1 ; and size_profile=5498;

select option_id--,cnt 
from (
select option_id,count(1) cnt from ma_asos.ma_v_planning where rec_source='P' and order_level=1 and  item_desc ='Item creation Perf Test'
and handover_date>'20-OCT-20'
 group by option_id); order by cnt desc;


-- PO upload
select item_parent from (
select distinct rms.im.item_parent,trunc(im.create_datetime) dt from rms.item_master  im
inner join rms.v_item_master vim on vim.item=im.item_parent
where 
im.item_desc like '%UploadTest7Sku%' and im.create_datetime>='04-JAN-19' and im.item_parent is not null )
where exists(select null from ma_asos.ma_v_planning where rec_source='U' and option_id=item_parent
and QTY_ORDERED=70 and po_type='D' and not_before_Date > sysdate 
and final_dest=1001)
order by dt;

select distinct item_desc from rms.item_master where item_desc like '%UploadTest%';
select * from ma_asos.ma_v_planning where option_id='118725871';
select * from ma_asos.ma_v_planning where --not_before_Date is null and
rec_source='U' --and size_profile is null 
and item_desc like '%UploadTest7Sku%'
and QTY_ORDERED=70 and po_type='D' and not_before_Date > sysdate;

--20PO 
select item from item_master where upper(item_desc) like 'ITEM%CREATION%%SKU%'
and status ='A' and item_level ='1';

--Po Amend upload
select oh.order_no from rms.ordhead oh where status ='A' and PICKUP_DATE !='27-JAN-22'
and oh.comment_desc not like '%reate%'
and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no)
and rownum <= '500' and length(oh.order_no)>=12;

---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------

select * from rms.shipment where ASN='0128000000025322'; order_no='50001170067';


-- PO Creation:
select order_no from rms.ordhead  where CREATE_DATETIME>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi');
and import_country_id = 'DE' and rownum<10001
order by CREATE_DATETIME ;
select count(1) from rms.ordhead where CREATE_DATETIME>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi')
order by CREATE_DATETIME desc;
select distinct comment_desc from rms.ordhead where CREATE_DATETIME>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi');
order by CREATE_DATETIME desc;;
select count(order_no) from ordhead oh where oh.order_no > '500950411206'
    and  exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no);
select * from shipment where order_no in(500950411210,500950411211,500950411212,500950411213,500950411214);


-- PO Update
select count(*) from rms.ordhead oh where LAST_UPDATE_DATETIME>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi') 
and comment_Desc like '%[REASON_CODE%'; 

select * from rms.ordloc ol
inner join rms.ordhead oh on ol.order_no=oh.order_no where LAST_UPDATE_DATETIME>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi') 
--oh.MASTER_PO_NO='20344336'
and comment_Desc like '%PO%Update%'; 
 order by LAST_UPDATE_DATETIME desc; 
 
 select * from ordhead where master_po_no='90005'; and po_type='D';
 select * from shipment where order_no='500000285975';
 select * from alloc_header where order_no='500000285975';

 
-- PO Replenishment 
select * from rms.ordhead where last_update_datetime>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi')
and create_datetime<>last_update_datetime
and comment_Desc like '%PO Replenishment%' order by last_update_datetime desc; 

select * from maordhead where master_po_no='25619337';

--PO Mass Search
select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 20 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 50 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 100 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 150 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 250 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 500 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 1000 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no))
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 2000 order by count(distinct(order_no));

-- PO Planning
select count(*) from rms.ordhead where last_update_datetime>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi')
--and trunc(create_datetime)<>trunc(last_update_datetime)
and comment_Desc like '%PO Planning%';

--PO upload
select count(distinct master_po_no) from rms.ordhead where last_update_datetime>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi') and create_datetime<>last_update_datetime
and comment_Desc like '%Po Upload%'; 
select * from ordhead where last_update_datetime>='29-JAN-21' and create_datetime<>last_update_datetime
and comment_Desc like '%Po Upload%' order by last_update_datetime desc;

select * from rms.ordhead where last_update_datetime>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi');
--and trunc(create_datetime)<>trunc(last_update_datetime)
and comment_Desc like '%20%';

select count(*) from rms.ordhead where last_update_datetime>=to_date('17-AUG-2022 02:00', 'DD-MON-YYYY hh24:mi')
--and trunc(create_datetime)<>trunc(last_update_datetime)
and comment_Desc like '%PO Creation 100%';


=======================================================================================================================================================================


select distinct MASTER_ORDER_NO from ma_asos.ma_stg_sizing_sku where OPTION_ID in
    (select OPTION_ID from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and trunc(CREATE_DATETIME)> = '06-APR-20');
