create table e2e_exclude (DEPARTMENT NUMBER(4),BUYING_GROUP NUMBER(4)) ;
ALTER TABLE e2e_exclude add (subclass NUMBER(4),class NUMBER(4));

select distinct e.DEPARTMENT, s.CLASS, s.SUBCLASS, mbg.BUYING_GROUP
    from skumar.e2e_exclude e cross join ma_asos.ma_buying_group mbg 
        ,rms.subclass s 
    where e.DEPARTMENT ='1001' and s.dept = e.department  
    and e.BUYING_GROUP!= mbg.BUYING_GROUP order by 1,4;


select * from skumar.e2e_exclude s where s.DEPARTMENT ='1001';
select * from skumar.E2E_itemS_INFO s where s.PRODUCT_GROUP ='1001';

select * from skumar.E2E_itemS_INFO;
select count(1) from skumar.E2E_itemS_INFO;
select PRODUCT_GROUP, BUYING_GROUP,count(1) from skumar.E2E_itemS_INFO group by PRODUCT_GROUP, BUYING_GROUP order by PRODUCT_GROUP, BUYING_GROUP;
select PRODUCT_GROUP,count(1) from skumar.E2E_itemS_INFO group by PRODUCT_GROUP order by PRODUCT_GROUP;
select distinct department from skumar.e2e_exclude;
select distinct dept from rms.item_master;
select distinct PRODUCT_GROUP from skumar.E2E_itemS_INFO;

    delete from skumar.E2E_itemS_INFO  where 
        (PRODUCT_GROUP, BUYING_GROUP) in (select DEPARTMENT, BUYING_GROUP from skumar.e2e_exclude s) ;
    
    select PRODUCT_GROUP, BUYING_GROUP,count(1) from skumar.E2E_itemS_INFO  where 
        (PRODUCT_GROUP, BUYING_GROUP) in (select DEPARTMENT, BUYING_GROUP from skumar.e2e_exclude s) group by PRODUCT_GROUP, BUYING_GROUP;
    
    
    
    
    
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.E2E_itemS_INFO TO LCHAU; --truncate table skumar.E2E_itemS_INFO;

      
select s.DEPT, s.CLASS, s.SUBCLASS, e.BUYINGGROUP from rms.subclass s,skumar.e2e_exclude e where s.dept = e.DEPARTMENT and s.dept ='1001' and s.class ='10';
select dept,class,subclass,count(1) from rms.item_master where item_level ='1' group by dept,class,subclass;
select dept,class,subclass,count(1) from rms.item_master where item_level ='2' group by dept,class,subclass order by dept,class,subclass;
select dept,count(1) from rms.item_master where item_level ='2' group by dept order by dept;

set serveroutput on;
set timing on;
 
DECLARE

        COUNTER_COMMIT  NUMBER(8)     := 1000;
   l_dept                	rms.subclass.dept%type; 
   l_loc                	rms.wh.wh%type := '1001'; 
   l_class                	rms.subclass.class%type; 
   l_subclass               rms.subclass.subclass%type; 
   l_BUYINGGROUP            skumar.e2e_exclude.BUYING_GROUP%type; 


    
	 cursor cur_dept is
        select s.DEPT, s.CLASS, s.SUBCLASS, e.BUYING_GROUP 
                from rms.subclass s,skumar.e2e_exclude e 
                where s.dept = e.DEPARTMENT;
    
 BEGIN   
    

    for k in cur_dept loop
      l_dept := k.dept;
      l_class := k.class;
      l_subclass := k.subclass;
      l_BUYINGGROUP := k.BUYING_GROUP;
      
 insert into skumar.E2E_itemS_INFO
   select uda_attrib.legacy_style_id ,uda_attrib.style_id,im.ITEM SKUITEM , im.ITEM_parent Option_item,im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
  'SKU' as TYPE_OF_ITEM,ils.selling_unit_retail as selling_unit_retail,(iids.stock_on_hand- (iids.tsf_reserved_qty+ iids.rtv_qty + iids.non_sellable_qty + iids.customer_resv + iids.customer_backorder)) as stock_on_hand,
  im.brand_name BRAND, im.item_desc item_description, im.division,im.group_no,im.dept PRODUCT_GROUP,im.class "CATEGORY",im.subclass SUB_CATEGORY,
  uda_attrib.super_style,uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
  from (select item,
               max(case when uda_id = '1002' then uda_text end) super_style,
               max(case when uda_id = '1003' then uda_text end) style_id,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set,
               max(case when uda_id = '1001' then uda_text end) legacy_style_id
         from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2030','2020','2040','1002','1003','1001'))                
             group by item) uda_attrib,
     rms.v_item_master im
    left outer join rms.item_loc_soh iids on iids.loc = l_loc and iids.item = im.item
    left outer join rms.item_loc ils on ils.loc = l_loc and ils.item = im.item
  where im.item = uda_attrib.item
    and im.item_level = im.tran_level
    and im.status ='A' 
    and im.dept =l_dept
    and im.class =l_class
    and im.subclass =l_subclass
    and uda_attrib.buying_group!=l_BUYINGGROUP
    and  (greatest(iids.stock_on_hand, 0) - (greatest(iids.tsf_reserved_qty, 0) + greatest(iids.rtv_qty, 0) + greatest(iids.non_sellable_qty, 0) + greatest(iids.customer_resv, 0) + greatest(iids.customer_backorder, 0)) > 1)
        and not exists (select 1 from skumar.E2E_itemS_INFO eii where eii.skuitem =im.item);      
      
           	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
                END IF;	
      END LOOP; 

COMMIT;

for k in cur_dept loop
      l_dept := k.dept;
      l_class := k.class;
      l_subclass := k.subclass;
      l_BUYINGGROUP := k.BUYING_GROUP;
    
    delete from skumar.E2E_itemS_INFO where PRODUCT_GROUP =l_dept  and CATEGORY = l_class  and SUB_CATEGORY=l_subclass and BUYING_GROUP = l_BUYINGGROUP;
           	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
			   END IF;	
    end loop;
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/








/*
-- SKU's and Stock using item_loc_soh

select uda_attrib.legacy_style_id ,uda_attrib.style_id,im.ITEM SKUITEM , im.ITEM_parent Option_item,im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
  case when im.item_level = 1 then 'OPTION' when im.item_level = 2 then 'SKU' end TYPE_OF_ITEM,
   ils.selling_unit_retail as selling_unit_retail,(iids.stock_on_hand- (iids.tsf_reserved_qty+ iids.rtv_qty + iids.non_sellable_qty + iids.customer_resv + iids.customer_backorder)) as stock_on_hand,
  im.brand_name BRAND, im.item_desc item_description, im.division,im.group_no,im.dept PRODUCT_GROUP,im.class "CATEGORY",im.subclass SUB_CATEGORY,
  uda_attrib.super_style,uda_attrib.style,uda_attrib.super_style_id, uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
  from (select item,
               max(case when uda_id = '1002' then uda_text end) super_style,
               max(case when uda_id = '1003' then uda_text end) style,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set,
               max(case when uda_id = '1001' then uda_text end) legacy_style_id,
               max(case when uda_id = '1002' then uda_text end) super_style_id,
               max(case when uda_id = '1003' then uda_text end) style_id
         from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2030','2020','2040','1002','1003','1001'))                
             group by item) uda_attrib,
    rms.v_item_master im
    left outer join rms.item_loc_soh iids on iids.loc = '1001' and iids.item = im.item
    left outer join rms.item_loc ils on ils.loc = '1001' and ils.item = im.item
  where im.item = uda_attrib.item
    and uda_attrib.buying_group!='100' --Buyrarchyhierarchy
    and im.dept = '1001'  --Merchandise hierarchy
    and im.item_level = im.tran_level
    and im.status ='A' 
    and  (greatest(iids.stock_on_hand, 0) - (greatest(iids.tsf_reserved_qty, 0) + greatest(iids.rtv_qty, 0) + greatest(iids.non_sellable_qty, 0) + greatest(iids.customer_resv, 0) + greatest(iids.customer_backorder, 0)) > 10) --Grater than 10
  order by uda_attrib.legacy_style_id,TYPE_OF_ITEM;   


/*
  --Daily tables
 select uda_attrib.legacy_style_id ,uda_attrib.style_id,im.ITEM, im.ITEM_parent Option_item,im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
  case when im.item_level = 1 then 'OPTION' when im.item_level = 2 then 'SKU' end TYPE_OF_ITEM,
  iids.sku_id,  iids.buy_price as selling_unit_retail,(iids.tradeable_stock_units+iids.intake_units+iids.tsf_in_units+iids.alloc_in_units) - (iids.non_tradeable_units + iids.non_saleable_units + iids.tsf_out_units + iids.alloc_out_units) as stock_on_hand,
  im.brand_name BRAND, im.item_desc item_description, im.division,im.group_no,im.dept PRODUCT_GROUP,im.class "CATEGORY",im.subclass SUB_CATEGORY,
  uda_attrib.super_style,uda_attrib.style,uda_attrib.super_style_id, uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
  from (select item,
               max(case when uda_id = '1002' then uda_text end) super_style,
               max(case when uda_id = '1003' then uda_text end) style,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set,
               max(case when uda_id = '1001' then uda_text end) legacy_style_id,
               max(case when uda_id = '1002' then uda_text end) super_style_id,
               max(case when uda_id = '1003' then uda_text end) style_id
         from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2030','2020','2040','1002','1003','1001'))                
             group by item) uda_attrib,
    rms.v_item_master im
    left outer join int_asos.int_pl_inventory_dnld_stg iids on iids.fc_id = '1001' and iids.sku_id = im.item
  where im.item = uda_attrib.item
    and uda_attrib.buying_group!='100'
    and im.dept = '1001'
    and im.item_level = im.tran_level
    and im.status ='A'
   -- and im.item_parent ='100135017'
  order by uda_attrib.legacy_style_id,TYPE_OF_ITEM; 

create table E2E_itemS_INFO as
  select uda_attrib.legacy_style_id ,uda_attrib.style_id,im.ITEM SKUITEM , im.ITEM_parent Option_item,im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
  'SKU' as TYPE_OF_ITEM,ils.selling_unit_retail as selling_unit_retail,(iids.stock_on_hand- (iids.tsf_reserved_qty+ iids.rtv_qty + iids.non_sellable_qty + iids.customer_resv + iids.customer_backorder)) as stock_on_hand,
  im.brand_name BRAND, im.item_desc item_description, im.division,im.group_no,im.dept PRODUCT_GROUP,im.class "CATEGORY",im.subclass SUB_CATEGORY,
  uda_attrib.super_style,uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
  from (select item,
               max(case when uda_id = '1002' then uda_text end) super_style,
               max(case when uda_id = '1003' then uda_text end) style_id,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set,
               max(case when uda_id = '1001' then uda_text end) legacy_style_id
         from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2030','2020','2040','1002','1003','1001'))                
             group by item) uda_attrib,
    rms.v_item_master im
    left outer join rms.item_loc_soh iids on iids.loc = '1001' and iids.item = im.item
    left outer join rms.item_loc ils on ils.loc = '1001' and ils.item = im.item
  where im.item = uda_attrib.item
    and im.item_level = im.tran_level
    and im.status ='A' 
    and im.dept ='1001'
    and im.class ='10'
    and im.subclass ='9999'
    and uda_attrib.buying_group!='100'
    and  (greatest(iids.stock_on_hand, 0) - (greatest(iids.tsf_reserved_qty, 0) + greatest(iids.rtv_qty, 0) + greatest(iids.non_sellable_qty, 0) + greatest(iids.customer_resv, 0) + greatest(iids.customer_backorder, 0)) > 1);      
 
  
   -- ALternative Options, SKU's and Stock 
/* 
 select --uda_attrib.legacy_style_id,uda_attrib.style_id,
 im.ITEM, im.ITEM_parent Option_item,im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
   case when im.item_level = 1 then 'OPTION' when im.item_level = 2 then 'SKU' end TYPE_OF_ITEM,
    iids.buy_price as selling_unit_retail,(iids.tradeable_stock_units+iids.intake_units+iids.tsf_in_units+iids.alloc_in_units) - 
    (iids.non_tradeable_units + iids.non_saleable_units + iids.tsf_out_units + iids.alloc_out_units) as stock_on_hand,
    im.brand_name BRAND, im.item_desc item_description, --im.division,im.group_no, 
    im.dept PRODUCT_GROUP,im.class "CATEGORY",im.subclass SUB_CATEGORY
   -- uda_attrib.super_style_id,uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
   from ma_asos.MA_V_BUYERARCHY im
    left outer join int_asos.int_pl_inventory_dnld_stg iids on iids.fc_id = '1001' and iids.sku_id = im.item
  where --im.item = uda_attrib.item
    --and 
    im.dept in ('1001')    
    and im.BUYING_GROUP !='100'
   --   and (im.item_parent= '100525040' or im.item= '100525040') -- not exists
  order by TYPE_OF_ITEM; 
  
  select * from ma_asos.MA_V_BUYERARCHY ;

  
  
 -- Options, SKU's and Stock 
 
 select uda_attrib.legacy_style_id ,uda_attrib.style_id,im.ITEM, im.ITEM_parent Option_item,im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
  case when im.item_level = 1 then 'OPTION' when im.item_level = 2 then 'SKU' end TYPE_OF_ITEM,
  iids.sku_id,  iids.buy_price as selling_unit_retail,(iids.tradeable_stock_units+iids.intake_units+iids.tsf_in_units+iids.alloc_in_units) - (iids.non_tradeable_units + iids.non_saleable_units + iids.tsf_out_units + iids.alloc_out_units) as stock_on_hand,
  im.brand_name BRAND, im.item_desc item_description, im.division,dn.div_name,im.group_no, g.group_name, im.dept PRODUCT_GROUP,d.dept_name  product_group_desc,im.class "CATEGORY", c.class_name category_name, im.subclass SUB_CATEGORY, s.sub_name sub_category_name, uda_attrib.super_style,        
  uda_attrib.style,uda_attrib.super_style_id, uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
  from (select item,
               max(case when uda_id = '1002' then uda_text end) super_style,
               max(case when uda_id = '1003' then uda_text end) style,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set,
               max(case when uda_id = '1001' then uda_text end) legacy_style_id,
               max(case when uda_id = '1002' then uda_text end) super_style_id,
               max(case when uda_id = '1003' then uda_text end) style_id
         from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2030','2040','1002','1003','1001')
                or (uda_id = '2020' and uda_text!='100'))                
             group by item) uda_attrib,
    rms.deps d,
    rms.class c,
    rms.subclass s,
    rms.groups g,
    rms.division dn,
    rms.v_item_master im
    left outer join int_asos.int_pl_inventory_dnld_stg iids on iids.fc_id = '1001' and iids.sku_id = im.item
  where im.item = uda_attrib.item
    and im.division = dn.division
    and im.division = g.division
    and im.group_no = g.group_no
    and d.group_no = g.group_no
    and im.dept=d.dept
    and d.dept =c.dept
    and d.dept =s.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=s.class
    and im.dept in ('1001')
   --   and im.dept in ('1058','1101','1109','1150','1154','1157','1158','2054','2055','2056','2104','2115','2150','2151','2154','2155','2156','2157','2158','2159')
   --   and im.item in ('8246752','7251633','7820712','7695587','7820711','7820713')
   --   and (im.item_parent= '100525040' or im.item= '100525040') -- not exists
  order by uda_attrib.legacy_style_id,TYPE_OF_ITEM; 



SELECT * FROM RMS.uda_item_ff WHERE uda_text LIKE '1427466';
SELECT * FROM RMS.ITEM_MASTER WHERE ITEM = '100732476';


 -- SKU's & Stock
select uda_attrib.legacy_style_id ,uda_attrib.style_id,im.item_parent as option_id, im.diff_1 COLOUR,im.diff_2 SIZE_GROUP,
  case when im.item_level = 1 then 'OPTION' when im.item_level = 2 then 'SKU' end TYPE_OF_ITEM,
  item_stock.*,im.brand_name BRAND, im.item_desc item_description, 
   im.division,dn.div_name,im.group_no, g.group_name, im.dept PRODUCT_GROUP,d.dept_name  product_group_desc,im.class "CATEGORY",
    c.class_name category_name, im.subclass SUB_CATEGORY, s.sub_name sub_category_name, uda_attrib.super_style,        
    uda_attrib.style,uda_attrib.super_style_id, uda_attrib.business_model, uda_attrib.buying_group, uda_attrib.buying_subgroup, uda_attrib.buying_set
  from rms.v_item_master im,
       (select item,
               max(case when uda_id = '1002' then uda_text end) super_style,
               max(case when uda_id = '1003' then uda_text end) style,
               max(case when uda_id = '2010' then uda_text end) business_model,
               max(case when uda_id = '2020' then uda_text end) buying_group,
               max(case when uda_id = '2030' then uda_text end) buying_subgroup,
               max(case when uda_id = '2040' then uda_text end) buying_set,
               max(case when uda_id = '1001' then uda_text end) legacy_style_id,
               max(case when uda_id = '1002' then uda_text end) super_style_id,
              max(case when uda_id = '1003' then uda_text end) style_id
         from (select item,uda_id,
                      uda_text 
                 from rms.uda_item_ff 
                where uda_id in ('2010','2020','2030','2040','1002','1003','1001'))
             group by item) uda_attrib,
    (select sku_id,  buy_price as selling_unit_retail, 
        (tradeable_stock_units+intake_units+tsf_in_units+alloc_in_units)-(non_tradeable_units + non_saleable_units + tsf_out_units + alloc_out_units) as stock_on_hand
        from int_asos.int_pl_inventory_dnld_stg
        where fc_id = '1001' ) item_stock,
    rms.deps d,
    rms.class c,
    rms.subclass s,
    rms.groups g,
    rms.division dn
  where im.item = uda_attrib.item
     and im.item = item_stock.sku_id
     and item_stock.stock_on_hand > '1'
    and im.division = dn.division
    and im.division = g.division
    and im.group_no = g.group_no
    and d.group_no = g.group_no
    and im.dept=d.dept
    and d.dept =c.dept
    and d.dept =s.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=s.class
    and im.dept in ('1058','1101','1109','1150','1154','1157','1158','2054','2055','2056','2104','2115','2150','2151','2154','2155','2156','2157','2158','2159')
   -- im.dept in ('1154','1157','1158','2115','2154','2155','2157') --180 -- iTEMS NOT IN tom eXCEL
   -- im.dept in ('1058','1101','1109','1150','1154','1157','1158','2054','2055','2056','2104','2115','2150','2151','2154','2155','2156','2157','2158','2159')
   -- and (im.item_parent= '100123335' or im.item= '100123335')
  order by DIVISION, GROUP_NO, PRODUCT_GROUP, CATEGORY, SUB_CATEGORY,TYPE_OF_ITEM; 

 --1154, 1157, 1158, 2115, 2154, 2155, 2157

select * from all_tables where table_name like '%UDA%' and owner like 'RMS';
select * from rms.item_Master where item IN ('4534133');

select * from ma_asos.MA_STG_ITEM_BARCODE where option_id ='100013161';
select * from ma_asos.MA_STG_ITEM_HEAD where item ='100013161';
select * from ma_asos.MA_STG_ITEM_RANGE where item ='100013161';
select * from ma_asos.MA_STG_ITEM_SIZE where option_id ='100013161';
select * from ma_asos.MA_STG_ITEM_SUP where item ='100013161';
select * from ma_asos.MA_STG_ITEM_UDA where item ='100013161';
select * from ma_asos.MA_STG_ITEM_COMMODITY_CODES where item ='100013161';
select * from ma_asos.MA_STG_ITEM_LOC_REPL_DAY where item ='100013161';



select * from rms.ITEM_EXP_DETAIL where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_EXP_HEAD where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_HTS where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_IMPORT_ATTR where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_LOC where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_LOC_CFA_EXT where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_LOC_SOH where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_MASTER where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_MASTER_CFA_EXT where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_REPL_DAY where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPPLIER where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPPLIER_CFA_EXT where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPP_COUNTRY where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPP_COUNTRY_CFA_EXT where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPP_COUNTRY_DIM where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPP_COUNTRY_LOC where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPP_COUNTRY_LOC_CFA_EXT where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.ITEM_SUPP_MANU_COUNTRY where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');

select * from rms.UDA_ITEM_DATE where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.UDA_ITEM_FF where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');
select * from rms.UDA_ITEM_LOV where item in (select item from rms.item_master where item ='100013161' or item_parent ='100013161' or item_grandparent ='100013161');


select * from rms.uda;
select * from rms.uda_values where uda_id ='94' order by 2;

select * from all_tables where table_name like 'CFA%';

select * from rms.CFA_ATTRIB;
select * from rms.CFA_ATTRIB_GROUP;
select * from rms.CFA_ATTRIB_GROUP_LABELS;
select * from rms.CFA_ATTRIB_GROUP_SET;
select * from rms.CFA_ATTRIB_GROUP_SET_LABELS;
select * from rms.CFA_ATTRIB_LABELS;
select * from rms.CFA_EXT_ENTITY;
select * from rms.CFA_EXT_ENTITY_KEY;
select * from rms.CFA_EXT_ENTITY_KEY_LABELS;
select * from rms.CFA_REC_GROUP;
select * from rms.CFA_REC_GROUP_LABELS;


 -- Working for Items and Stock
SELECT 
    UDA_ATTRIB.LEGACY_STYLE_ID ,UDA_ATTRIB.SUPER_STYLE_ID,UDA_ATTRIB.STYLE_ID,IM.ITEM,IM.ITEM_parent as Option_item, 
    ITEM_STOCK.STOCK_ON_HAND, ITEM_RETAIL.selling_unit_retail,
    CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION' WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM
     ,im.DIVISION,dn.DIV_NAME,im.GROUP_NO, g.GROUP_NAME, IM.DEPT PRODUCT_GROUP,d.dept_name  PRODUCT_GROUP_DESC,IM.CLASS "CATEGORY",c.class_name CATEGORY_NAME, IM.SUBCLASS SUB_CATEGORY, s.sub_name SUB_CATEGORY_NAME,IM.BRAND_NAME BRAND, IM.ITEM_DESC ITEM_DESCRIPTION,IM.SHORT_DESC SHORT_DESCRIPTION, IM.DIFF_1 COLOUR,IM.DIFF_2 SIZE_GROUP,UDA_ATTRIB.SUPER_STYLE,        UDA_ATTRIB.STYLE,UDA_ATTRIB.BUSINESS_MODEL,UDA_ATTRIB.BUYING_GROUP,        UDA_ATTRIB.BUYING_SUBGROUP,UDA_ATTRIB.BUYING_SET
  FROM rms.v_ITEM_MASTER IM,
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = '1002' THEN UDA_TEXT END) SUPER_STYLE,
               MAX(CASE WHEN UDA_ID = '1003' THEN UDA_TEXT END) STYLE,
               MAX(CASE WHEN UDA_ID = '2010' THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = '2020' THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = '2030' THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = '2040' THEN UDA_TEXT END) BUYING_SET,
               MAX(CASE WHEN UDA_ID = '1001' THEN UDA_TEXT END) LEGACY_STYLE_ID,
               MAX(CASE WHEN UDA_ID = '1002' THEN UDA_TEXT END) SUPER_STYLE_ID,
               MAX(CASE WHEN UDA_ID = '1003' THEN UDA_TEXT END) STYLE_ID
         FROM (SELECT ITEM,UDA_ID,
                      UDA_TEXT 
                 FROM rms.UDA_ITEM_FF 
                WHERE UDA_ID IN ('2010','2020','2030','2040','1002','1003','1001'))
             GROUP BY ITEM) UDA_ATTRIB,
    (SELECT ils.ITEM,((ils.stock_on_hand + IN_TRANSIT_QTY + tsf_expected_qty) - (TSF_RESERVED_QTY + NON_SELLABLE_QTY)) as stock_on_hand
        from rms.item_loc_soh ils
            where ils.loc ='1001') ITEM_STOCK,
    (SELECT ils.ITEM,ils.selling_unit_retail
            from rms.item_loc  ils
        where ils.loc ='20001' ) ITEM_RETAIL, 
    rms.deps d,
    rms.class c,
    rms.subclass s,
    rms.groups g,
    rms.division dn
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
     and IM.ITEM = ITEM_STOCK.ITEM
     and IM.ITEM = ITEM_RETAIL.ITEM
    -- and ITEM_STOCK.stock_on_hand > '10'
    and im.division = dn.division
    and im.division = g.division
    and im.GROUP_NO = g.GROUP_NO
    and d.GROUP_NO = g.GROUP_NO
    and im.dept=d.dept
    and d.dept =c.dept
    and d.dept =S.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=S.class
    and im.dept in ('2159') --1058,1101,1109,1150,1154,1157,1158,2054,2055,2056,2104,2115,2150,2151,2154,2155,2156,2157,2158,2159
   
  ORDER BY DIVISION, GROUP_NO, PRODUCT_GROUP, CATEGORY, SUB_CATEGORY,TYPE_OF_ITEM; 
  
  
  
  
-- Lee Extract -- Items available and not available

SELECT UDA_ATTRIB.PRODUCT_ID as LEGACY_STYLE_ID, ITEM_STOCK.STOCK_ON_HAND, ITEM_RETAIL.selling_unit_retail,
IM.ITEM, CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION' WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM, 
IM.ITEM_parent as Option_ITEM,
IM.BRAND_NAME BRAND, IM.ITEM_DESC ITEM_DESCRIPTION,did.DIFF_DESC COLOUR,did2.DIFF_DESC SIZE_GROUP
,UDA_ATTRIB.SUPER_STYLE,UDA_ATTRIB.STYLE,UDA_ATTRIB.BUSINESS_MODEL,UDA_ATTRIB.BUYING_GROUP,UDA_ATTRIB.BUYING_SUBGROUP,UDA_ATTRIB.BUYING_SET,
im.DIVISION,dn.DIV_NAME,im.GROUP_NO, g.GROUP_NAME, IM.DEPT PRODUCT_GROUP,d.dept_name  PRODUCT_GROUP_DESC,IM.CLASS "CATEGORY",
c.class_name CATEGORY_NAME, IM.SUBCLASS SUB_CATEGORY, s.sub_name SUB_CATEGORY_NAME 
  FROM rms.v_ITEM_MASTER IM,
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = '1002' THEN UDA_TEXT END) SUPER_STYLE,
               MAX(CASE WHEN UDA_ID = '1003' THEN UDA_TEXT END) STYLE,
               MAX(CASE WHEN UDA_ID = '2010' THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = '2020' THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = '2030' THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = '2040' THEN UDA_TEXT END) BUYING_SET,
               MAX(CASE WHEN UDA_ID = '1001' THEN UDA_TEXT END) PRODUCT_ID
         FROM (SELECT ITEM,UDA_ID,
                      UDA_TEXT 
                 FROM rms.UDA_ITEM_FF 
                WHERE UDA_ID IN ('2010','2020','2030','2040','1002','1003')
                 or ( UDA_ID in ('1001')  
                 -- Not available 
                 and uda_text in ('1427466')))
             GROUP BY ITEM) UDA_ATTRIB,
      (SELECT ils.ITEM,((ils.stock_on_hand + IN_TRANSIT_QTY + tsf_expected_qty) - (TSF_RESERVED_QTY + NON_SELLABLE_QTY)) as stock_on_hand
        from rms.item_loc_soh ils
            where ils.loc ='1001') ITEM_STOCK,
         (SELECT ils.ITEM,ils.selling_unit_retail
            from rms.item_loc  ils
        where ils.loc ='20001') ITEM_RETAIL,
        rms.deps d,
         rms.class c,
         rms.subclass s,
         rms.groups g,
         rms.division dn,
         rms.diff_ids did,
         rms.diff_ids did2
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
    and IM.ITEM = ITEM_STOCK.ITEM
    and UDA_ATTRIB.PRODUCT_ID is not null
    and IM.ITEM = ITEM_RETAIL.ITEM
   --  and ITEM_STOCK.stock_on_hand > '10'
    and im.division = dn.division
    and im.division = g.division
    and im.GROUP_NO = g.GROUP_NO
    and d.GROUP_NO = g.GROUP_NO
    and im.dept=d.dept
    and im.diff_1 = did.DIFF_ID
    and im.diff_2 = did2.DIFF_ID
    and d.dept =c.dept
    and d.dept =S.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=S.class
    and im.status ='A'
   -- and im.dept in ('2151')
   -- and im.item_level in ('1')
    and im.sellable_ind ='Y'
   --   and (im.item_parent= '100180958' or im.item= '100180958') -- not exists
   --  and (im.item_parent= '100316071' or im.item= '100316071') -- exists
  ORDER BY 1,4;

select * from rms.item_master where item ='7339427';
select ITEM, LOC,DATE_21 as AVAILABLE_SELL_DATE, DATE_22 as GOLIVE_DATE from rms.item_loc_cfa_ext 
where GROUP_ID = '110100' and item in (select item from rms.item_master where item_parent ='100270491' and item ='100270491'); 


-- Basic Items info
SELECT 
    UDA_ATTRIB.LEGACY_STYLE_ID ,UDA_ATTRIB.SUPER_STYLE_ID,UDA_ATTRIB.STYLE_ID,IM.ITEM, CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION' WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM
, im.DIVISION,dn.DIV_NAME,im.GROUP_NO, g.GROUP_NAME, IM.DEPT PRODUCT_GROUP,d.dept_name  PRODUCT_GROUP_DESC,IM.CLASS "CATEGORY",c.class_name CATEGORY_NAME, IM.SUBCLASS SUB_CATEGORY, s.sub_name SUB_CATEGORY_NAME,IM.BRAND_NAME BRAND, IM.ITEM_DESC ITEM_DESCRIPTION,IM.SHORT_DESC SHORT_DESCRIPTION, IM.DIFF_1 COLOUR,IM.DIFF_2 SIZE_GROUP,UDA_ATTRIB.SUPER_STYLE,        UDA_ATTRIB.STYLE,UDA_ATTRIB.BUSINESS_MODEL,UDA_ATTRIB.BUYING_GROUP,        UDA_ATTRIB.BUYING_SUBGROUP,UDA_ATTRIB.BUYING_SET
  FROM rms.v_ITEM_MASTER IM,
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = '1002' THEN UDA_TEXT END) SUPER_STYLE,
               MAX(CASE WHEN UDA_ID = '1003' THEN UDA_TEXT END) STYLE,
               MAX(CASE WHEN UDA_ID = '2010' THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = '2020' THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = '2030' THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = '2040' THEN UDA_TEXT END) BUYING_SET,
               MAX(CASE WHEN UDA_ID = '1001' THEN UDA_TEXT END) LEGACY_STYLE_ID,
               MAX(CASE WHEN UDA_ID = '1002' THEN UDA_TEXT END) SUPER_STYLE_ID,
               MAX(CASE WHEN UDA_ID = '1003' THEN UDA_TEXT END) STYLE_ID
         FROM (SELECT ITEM,UDA_ID,
                      UDA_TEXT 
                 FROM rms.UDA_ITEM_FF 
                WHERE UDA_ID IN ('2010','2020','2030','2040','1002','1003','1001'))
             GROUP BY ITEM) UDA_ATTRIB,
        rms.deps d,
         rms.class c,
         rms.subclass s,
         rms.groups g,
         rms.division dn
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
    and im.division = dn.division
    and im.division = g.division
    and im.GROUP_NO = g.GROUP_NO
    and d.GROUP_NO = g.GROUP_NO
    and im.dept=d.dept
    and d.dept =c.dept
    and d.dept =S.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=S.class
   -- and im.dept ='1057' -- and d.dept_name like '%Jewellery%'
    and (im.item_parent= '100774286' or im.item= '100774286')
  ORDER BY DIVISION, GROUP_NO, PRODUCT_GROUP, CATEGORY, SUB_CATEGORY,TYPE_OF_ITEM;   

*/