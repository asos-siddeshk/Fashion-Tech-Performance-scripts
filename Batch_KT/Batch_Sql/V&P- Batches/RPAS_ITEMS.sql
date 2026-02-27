create table check_1(optionid varchar2(25));
truncate table check_1;
drop table check_1;
select count(1) from check_1;

	DELETE FROM check_1
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM check_1
		GROUP BY optionid);			

select im.ITEM Option_item,im.item_desc item_description , --uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
   mv.BUSINESS_MODEL, mv.BUSINESS_MODEL_NAME, mv.BUYING_GROUP, mv.BUYING_GROUP_NAME, mv.BUYING_SUBGROUP, 
   mv.BUYING_SUBGROUP_NAME, mv.BUYING_SET, mv.BUYING_SET_NAME, mpv.*
 from (select item,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set
               from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2030','2020','2040'))                
             group by item) uda_attrib,
         rms.v_item_master im,
         ma_asos.MA_V_BUYERARCHY mv,
         V_MERCH_HIERARCHY mpv
  where im.item = uda_attrib.item
    and mv.BUSINESS_MODEL ='2' and mv.BUYING_GROUP='157' and mpv.dept = '1014'
   and mv.item = im.item
   and im.DIVISION = mpv.division
   and im.GROUP_NO= mpv.group_no
   and im.DEPT= mpv.dept
   and im.CLASS = mpv.class
   and im.SUBCLASS= mpv.subclass;
   
   
   select * from uda where uda_id ='1';
  
   select mv.BUSINESS_MODEL, mv.BUSINESS_MODEL_NAME, mv.BUYING_GROUP, mv.BUYING_GROUP_NAME, mv.BUYING_GROUP_KEY,mv.BUYING_SUBGROUP, 
   mv.BUYING_SUBGROUP_NAME, mv.BUYING_SUBGROUP_KEY, mv.BUYING_SET, mv.BUYING_SET_NAME, mv.BUYING_SET_KEY 
    from ma_asos.MA_V_BUYERARCHY mv;
   
   select * from ma_asos.MA_V_PRODUCT_HIERARCHY;
   select * from all_views where view_name like '%HIERAR%';
   
   select * from division;
   select * from V_MERCH_HIERARCHY;