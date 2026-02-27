
Pricing Queries

---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------


--Create price
select im.item from rms.item_master im
inner join rms.v_item_master vim on vim.item=im.item inner join ma_asos.ma_v_item mvim on mvim.item=im.item
left join ma_asos.ma_price_change pc on im.item=pc.item where 
vim.division=1 and mvim.business_model=33 and 
im.status ='A' and im.item_level = '1'
and pc.item is null and im.short_desc not like '%Upload%'; --and im.check_uda_ind='N' 
and im.brand_name = 'ASOS';--and im.item=100531815
order by trunc(im.create_datetime) desc;

   
-- Maintain Price
select distinct items.item from ma_asos.ma_price_change items
--inner join rms.v_item_master vim on vim.item=items.item 
--inner join ma_asos.ma_v_item mvim on mvim.item=items.item 
left join (select distinct item from ma_asos.ma_price_change where STATUS='S' or STATUS='P' or status='E' ) PCS on PCS.item=items.item
where items.STATUS='W' and pcs.item is null and items.effective_Date>=trunc(sysdate)--and items.item='100000638'; 
minus
select distinct item from RPM_PRICE_CHANGE;

select * from ma_asos.ma_price_change where status='A'; item='103659482';
select * from dba_tables where table_name like '%PRICE%' and owner ='RMS';;
select * from RPM_PRICE_CHANGE where  item='103659482';


--mass price search
select status,division,group_no,dept,class,subclass,count(1) from PRICEMASSSEARCH group by status,division,group_no,dept,class,subclass;
select mm.skulist,mm.division-1 div_position,dpt.position dept_position
,cl.class_position,scl.subcls_position
from price_Mass_search mm
inner join dept_position dpt on dpt.dept=mm.dept
inner join class_position cl on cl.class=mm.class and mm.dept=cl.dept
inner join subclass_position scl on scl.class=mm.class and mm.dept=scl.dept and scl.subclass=mm.subclass;

select distinct sh.SKULIST, sh.SKULIST_DESC, DIVISION, DEPT, CLASS, SUBCLASS from rms.skulist_detail sd, rms.skulist_head sh, rms.v_item_master im
where sh.skulist = sd.skulist and sh. sKULIST_DESC like '%Mass%PCSearch%' and sd.item = im.item order by 3,4,5,6;

---copy Promotion
 SELECT pe.PROMO_EVENT_ID,p.promo_display_id
FROM rpm_promo p,
rpm_promo_event pe,
rpm_promo_comp pc,
rpm_promo_dtl pdtl,
rpm_promo_dtl_list_grp pdlg,
rpm_promo_dtl_list pdl,
rpm_promo_dtl_disc_ladder pddl
WHERE p.PROMO_EVENT_ID = pe.PROMO_EVENT_ID
and p.PROMO_EVENT_ID in ('58')
and p.promo_id = pc.promo_id
and pdtl.promo_comp_id = pc.promo_comp_id
and pdtl.promo_dtl_id = pdlg.promo_dtl_id
and pdlg.promo_dtl_list_grp_id = pdl.promo_dtl_list_grp_id
and pdl.promo_dtl_list_id = pddl.promo_dtl_list_id
AND pddl.change_type = 0 -- % off
and pdtl.state = 3 -- approved
and pc.type = 1 -- simple promotion
and rms.get_vdate < p.start_date
--and rownum <= '500'
GROUP BY pe.PROMO_EVENT_ID,pe.PROMO_EVENT_DISPLAY_ID,pc.promo_comp_id,pc.comp_display_id,pc.promo_id,p.promo_display_id
order by pe.PROMO_EVENT_ID,pe.PROMO_EVENT_DISPLAY_ID,pc.promo_comp_id,pc.comp_display_id,pc.promo_id,p.promo_display_id;



--Price Upload
--Price Upload 50 footwear
select distinct rpm.item from rms.RPM_FUTURE_RETAIL  rpm
 inner join rms.item_master i on i.item = rpm.item       
 left join ma_asos.ma_price_change pc on pc.item=rpm.item  
 where rpm.zone_id is null and i.item_level < i.tran_level and pc.item is null and rpm.dept=1050;

--Price Upload 100 woven top
select distinct rpm.item from rms.RPM_FUTURE_RETAIL  rpm
 inner join rms.item_master i on i.item = rpm.item       
 left join ma_asos.ma_price_change pc on pc.item=rpm.item  
 where rpm.zone_id is null and i.item_level < i.tran_level and pc.item is null and rpm.dept=1004;

--Price Upload 500 evening dress
select distinct rpm.item from rms.RPM_FUTURE_RETAIL  rpm
 inner join rms.item_master i on i.item = rpm.item       
 left join ma_asos.ma_price_change pc on pc.item=rpm.item  
 where rpm.zone_id is null and i.item_level < i.tran_level and pc.item is null and rpm.dept=1002;
 
--Price Upload 1000 outerwear
select distinct rpm.item  from rms.RPM_FUTURE_RETAIL  rpm
 inner join rms.item_master i on i.item = rpm.item       
 left join ma_asos.ma_price_change pc on pc.item=rpm.item  
 where rpm.zone_id is null and i.item_level < i.tran_level and pc.item is null and rpm.dept=2008;

--Price review/reco
select div.position ||','||buss.position||',' ||dpt.position||','||count ,dpt.DEPT,count  from pcreview_wocount mm
inner join dept_position dpt on dpt.dept=mm.dept
inner join biz_position buss on buss.business_model=mm.business_model
inner join div_position div on div.division=mm.division;


select * from pcreview_wocount;
select * from ma_Asos.ma_business_model order by 1;   
--create table pcreview as
--create table pcreview_wocount as
select  vim.division,mvim.business_model,mvim.dept,count(im.item) count
from item_master im
inner join rms.v_item_master vim on vim.item=im.item
inner join ma_asos.ma_v_item mvim on mvim.item=vim.item 
where  
im.item_level=1
group by vim.division,mvim.business_model,mvim.dept
having count(im.item)<200;

--SiddeshQuery
select vim.division,mvim.business_model,mvim.BUYING_GROUP, mvim.BUYING_SUBGROUP, mvim.BUYING_SET,mvim.dept, count(im.item)  from item_master im
    inner join rms.v_item_master vim on vim.item=im.item
    inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
where im.item_level=1 and im.status ='A' and im.dept not in ('1006')
    group by vim.division,mvim.business_model,mvim.BUYING_GROUP, mvim.BUYING_SUBGROUP, mvim.BUYING_SET,mvim.dept
        having count(1) between 100 and 250;


--Create Cost change

select im.item from rms.item_master im
inner join rms.v_item_master vim on vim.item=im.item inner join ma_asos.ma_v_item mvim on mvim.item=im.item 
left join 
ma_asos.ma_cost_change pc on im.item=pc.item where vim.division=1 and mvim.business_model=33 and im.status ='A' and im.item_level = '1' 
and pc.item is null and im.check_uda_ind='N' and im.class<>1;
order by trunc(im.create_datetime) desc;

-- Search Price
select distinct pc.item, bm.business_model,bm.division,bm.product_group from ma_asos.ma_price_change pc
inner join ma_asos.ma_v_option_search bm on pc.item=bm.item
where 
--pc.Status='S' and 
bm.business_model=1 and bm.division=1;
order by pc.CREATE_DATETIME desc;  
select distinct item from ma_asos.ma_price_change;

--search cost
select distinct item from cost_susp_sup_detail;

select * from dba_tables where table_name like '%COST%' and owner like 'MA_ASOS';

--Upload Brand Conversion
select * from RMS.BRAND a
left join ma_asos.MA_PRICING_RULES_METHOD b on a.brand_name=b.brand_name
where b.brand_name is null;--FETCH

select * from ma_asos.MA_PRICING_RULES_METHOD where brand_name like 'ADAM DUFFY';
select * from all_tab_columns where table_name like '%MA_PRICING_METHODS%';
select brand from ma_asos.MA_PRICE_ZONE_METHOD;
select * from ma_asos.zones_tbl;

select * from skumar.item_master_op; order by 1 desc;
select item,zone_id from skumar.item_master_op, ma_asos.ma_pricing_defaults ma order by 1,2;
select * from item_master where item in ('100000003','118722365');
select item from item_master where diff_1 is null;

------simple promo-----
select PROMO_DISPLAY_ID, COMP_DISPLAY_ID, rp.CURRENCY_CODE,START_DATE, END_DATE, ZONE_ID 
from rms.rpm_promo rp, rms.rpm_promo_comp rpc, period p, rpm_zone rz where rp.promo_id = rpc.promo_id
and START_DATE <= p.vdate
and END_DATE >= p.vdate
and rz.currency_code = rp.CURRENCY_CODE --and zone_id=100 
order by end_date desc;
and PROMO_DISPLAY_ID=187910;

 select *
    from rpm_promo p where trunc(end_Date)>'13-JUL-22' order by end_date desc;
   where p.promo_display_id = 187910;

select * from period;
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------



-- Create price
select * from ma_asos.ma_price_change where /*item in ('100082410','100082412','100082430','100082823') and*/ 
--Status='P' and 
CREATE_DATETIME>=to_date('26-NOV-21 02:00', 'DD-MON-YYYY hh24:mi') order by CREATE_DATETIME desc;
select count(distinct TRANS_ID) from ma_asos.ma_price_change where Status='S' and CREATE_DATETIME>=to_date('26-NOV-21 02:00', 'DD-MON-YYYY hh24:mi');
select count(*) from ma_asos.ma_price_change where Status='S' and CREATE_DATETIME>=to_date('26-NOV-21 12:00', 'DD-MON-YYYY hh24:mi');

-- Maintain Price
select * from ma_asos.ma_price_change where /*item in ('100142555') and*/ Status='P' and LAST_UPDATE_DATETIME>='26-NOV-21'order by LAST_UPDATE_DATETIME desc;
select count(*) from ma_asos.ma_price_change where /*item in ('100142555') and*/ Status='P' and LAST_UPDATE_DATETIME>=to_date('26-NOV-21 02:00', 'DD-MON-YYYY hh24:mi') order by LAST_UPDATE_DATETIME desc;


--Price Upload
select distinct trans_id from ma_asos.ma_price_change where create_datetime >='10-MAY-2019'
 and place_of_creation='U';
 
 --Copy Promotion
 select * from ma_asos.ma_stage_simple_promo  where last_update_datetime >='22-JUN-2022' order by last_update_datetime desc;


select  im.item from item_master im
inner join rms.v_item_master vim on vim.item=im.item
inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
where
im.item_level=1 and vim.division='2' and mvim.business_model='6' and mvim.dept='2054';

--Upload Brand Conversion
select * from ma_asos.MA_PRICING_RULES_METHOD -- verify


