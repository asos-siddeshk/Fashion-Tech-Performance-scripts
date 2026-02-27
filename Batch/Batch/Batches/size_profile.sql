
select * from rms.period;

select * FROM int_asos.INT_PL_SIZPROF_DETAIL_UPLD_STG
   WHERE LAST_UPDATETIME + 180 < GET_VDATE()
     AND STATUS = 'P';

select * FROM int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG
   WHERE LAST_UPDATETIME + 180 < GET_VDATE()
     AND STATUS = 'P';



select * from int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);
select * from int_asos.INT_PL_SIZPROF_DETAIL_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);

select * from all_views where view_name like '%PLANNING%';
select * from ma_asos.MA_V_PLANNING where trunc(UPLOAD_CREATE_DATE) = '26-OCT-20';

  select * from ma_asos.MA_SIZE_PROFILE_head;  
  select * from ma_asos.MA_SIZE_PROFILE_DETAIL;

select * from 
delete from int_asos.int_pl_sizprof_head_upld_stg;
delete from int_asos.int_pl_sizprof_detail_upld_stg;

  
---------------------------- Purge ----------------  

  select CREATE_DATETIME,count(1) from int_asos.int_pl_sizprof_head_upld_stg group by CREATE_DATETIME order by 1 desc;
select * from int_asos.int_pl_sizprof_head_upld_stg;
select * from int_asos.int_pl_sizprof_detail_upld_stg;
  
 
  
SET serveroutput ON;
SET timing ON;

DECLARE
l_date           date;
P_size_profile           int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.size_profile%type;
p_size_profile_desc      int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.size_profile_desc%type; 
p_size_group             int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.size_group%type;
p_size_code             int_asos.INT_PL_SIZPROF_DETAIL_UPLD_STG.SIZE_CODE%type;
-- p_percentile             int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.percentile%type;
p_history_weight         int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.history_weight%type; 
p_location               int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.location%type; 
p_business_model         int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.business_model%type;
p_buying_group           int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.buying_group%type;
p_buying_subgroup        int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.buying_subgroup%type;
p_buying_set             int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.buying_set%type;   
p_product_group          int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.product_group%type; 
p_category               int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.category%type; 
p_subcategory            int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.subcategory%type;
p_brand                  int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.brand%type;
p_status                 int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.status%type;
p_filename				 int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.filename%type;														

CURSOR c_wh IS
select wh from rms.wh where STOCKHOLDING_IND ='Y';


CURSOR c_upload IS
select skumar.custom_sizprof_seq.nextval as size_profile,
		  1 as PERCENTILE,
          7 as history_weight,
		ITEM, 
		size_group, 
		size_code,
		PRODUCT_GROUP, 
		CATEGORY, 
		SUBCATEGORY, BRAND, BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET from (
SELECT distinct IM.ITEM,
        im.diff_2 as size_group,
        '1A' as size_code,
       IM.DEPT as PRODUCT_GROUP,
       IM.CLASS as CATEGORY,
       IM.SUBCLASS as SUBCATEGORY, 
       IM.BRAND_NAME as BRAND, 
       UDA_ATTRIB.BUSINESS_MODEL,
       UDA_ATTRIB.BUYING_GROUP,        
       UDA_ATTRIB.BUYING_SUBGROUP,
       UDA_ATTRIB.BUYING_SET
  FROM ITEM_MASTER IM, 
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = 2010 THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = 2020 THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = 2030 THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = 2040 THEN UDA_TEXT END) BUYING_SET
         FROM (SELECT ITEM,UDA_ID,UDA_TEXT FROM UDA_ITEM_FF  WHERE UDA_ID IN (2010,2020,2030,2040))
             GROUP BY ITEM) UDA_ATTRIB
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
    and im.item_level ='1' 
    and im.status ='A'
     and im.dept ='1057' 
    and exists (select 1 from rms.diff_group_detail dgd where dgd.DIFF_GROUP_ID = im.diff_2)) where rownum<='200';

	
BEGIN

for m in 0..1 loop 
  select vdate+6-m into l_date from rms.period;

    for k in c_wh loop 
        p_location :=  k.wh;


        FOR sizprof  IN c_upload LOOP
        
                p_size_profile         :=  sizprof.size_profile;   
                p_size_group           :=  sizprof.size_group;
                p_size_code            :=  sizprof.size_code;
                p_history_weight       :=  sizprof.history_weight;  
                p_business_model       :=  sizprof.business_model;  
                p_buying_group         :=  sizprof.buying_group;  
                p_buying_subgroup      :=  sizprof.buying_subgroup;  
                p_buying_set           :=  sizprof.buying_set;  
                p_product_group        :=  sizprof.product_group;  
                p_category             :=  sizprof.category;  
                p_subcategory          :=  sizprof.subcategory;  
        p_brand                :=  sizprof.brand;  


INSERT INTO  int_asos.int_pl_sizprof_head_upld_stg(size_profile,
                                                size_profile_desc,
                                                size_group,
                                                history_weight,
                                                location,
                                                business_model,
                                                buying_group,
                                                buying_subgroup,
                                                buying_set,
                                                product_group,
                                                category,
                                                subcategory,
                                                brand,
                                                status,
                                                filename,  
                                                create_datetime,
                                                last_updatetime
											)
						VALUES				(   p_size_profile,           
                                                'Profile_desc'||p_size_profile,     
                                                p_size_group,             
                                                p_history_weight,        
                                                p_location,               
                                                p_business_model,         
                                                p_buying_group,           
                                                p_buying_subgroup,        
                                                p_buying_set,             
                                                p_product_group,          
                                                p_category,               
                                                p_subcategory,            
                                                p_brand,                  
                                                'P',                 
                                                'Profile_filename'||p_size_profile,     
                                                l_date,
                                                l_date );

INSERT INTO  int_asos.int_pl_sizprof_detail_upld_stg(size_profile    ,
														size_code       ,
														percentile      ,
														status          ,
														filename        ,
														create_datetime ,
														last_updatetime )
														
								values                (p_size_profile,
														p_size_code,
														'1',
														'P',
														'Profile_filename'||p_size_profile,  
														l_date,
														l_date);
	END LOOP;
	END LOOP;
    END LOOP;
    commit;
    
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


  
  -------------------------------New Unprocessed-------------
  
  
  select CREATE_DATETIME,count(1) from int_asos.int_pl_sizprof_head_upld_stg group by CREATE_DATETIME;
  
select * from int_asos.int_pl_sizprof_head_upld_stg where status ='U';
select * from int_asos.int_pl_sizprof_detail_upld_stg where 
    SIZE_PROFILE not in (select SIZE_PROFILE from int_asos.int_pl_sizprof_head_upld_stg where status ='U');
  
  
  
  
  
SET serveroutput ON;
SET timing ON;

DECLARE
l_date           date;
P_size_profile           int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.size_profile%type;
p_size_profile_desc      int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.size_profile_desc%type; 
p_size_group             int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.size_group%type;
p_size_code             int_asos.INT_PL_SIZPROF_DETAIL_UPLD_STG.SIZE_CODE%type;
-- p_percentile             int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.percentile%type;
p_history_weight         int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.history_weight%type; 
p_location               int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.location%type; 
p_business_model         int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.business_model%type;
p_buying_group           int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.buying_group%type;
p_buying_subgroup        int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.buying_subgroup%type;
p_buying_set             int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.buying_set%type;   
p_product_group          int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.product_group%type; 
p_category               int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.category%type; 
p_subcategory            int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.subcategory%type;
p_brand                  int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.brand%type;
p_status                 int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.status%type;
p_filename				 int_asos.INT_PL_SIZPROF_HEAD_UPLD_STG.filename%type;														

CURSOR c_wh IS
select wh from rms.wh where STOCKHOLDING_IND ='Y';


CURSOR c_upload IS

select skumar.custom_sizprof_seq.nextval as size_profile,
		  1 as PERCENTILE,
          7 as history_weight,
		ITEM, 
		size_group, 
		size_code,
		PRODUCT_GROUP, 
		CATEGORY, 
		SUBCATEGORY, BRAND, BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET from (
SELECT distinct IM.ITEM,
        im.diff_2 as size_group,
        '1A' as size_code,
       IM.DEPT as PRODUCT_GROUP,
       IM.CLASS as CATEGORY,
       IM.SUBCLASS as SUBCATEGORY, 
       IM.BRAND_NAME as BRAND, 
       UDA_ATTRIB.BUSINESS_MODEL,
       UDA_ATTRIB.BUYING_GROUP,        
       UDA_ATTRIB.BUYING_SUBGROUP,
       UDA_ATTRIB.BUYING_SET
  FROM ITEM_MASTER IM, 
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = 2010 THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = 2020 THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = 2030 THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = 2040 THEN UDA_TEXT END) BUYING_SET
         FROM (SELECT ITEM,UDA_ID,UDA_TEXT FROM UDA_ITEM_FF  WHERE UDA_ID IN (2010,2020,2030,2040))
             GROUP BY ITEM) UDA_ATTRIB
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
    and im.item_level ='1' 
    and im.status ='A'
     --and im.dept ='1057' 
    and exists (select 1 from rms.diff_group_detail dgd where dgd.DIFF_GROUP_ID = im.diff_2)
    and not exists (select 1 from int_asos.int_pl_sizprof_detail_upld_stg dd where dd.size_code = im.diff_2)
    ) where rownum<='15';

	
BEGIN

for m in 0..10 loop 
select vdate+1+m into l_date from rms.period;

    for k in c_wh loop 
        p_location :=  k.wh;


        FOR sizprof  IN c_upload LOOP
        
                p_size_profile         :=  sizprof.size_profile;   
                p_size_group           :=  sizprof.size_group;
                p_size_code            :=  sizprof.size_code;
                p_history_weight       :=  sizprof.history_weight;  
                p_business_model       :=  sizprof.business_model;  
                p_buying_group         :=  sizprof.buying_group;  
                p_buying_subgroup      :=  sizprof.buying_subgroup;  
                p_buying_set           :=  sizprof.buying_set;  
                p_product_group        :=  sizprof.product_group;  
                p_category             :=  sizprof.category;  
                p_subcategory          :=  sizprof.subcategory;  
        p_brand                :=  sizprof.brand;  


INSERT INTO  int_asos.int_pl_sizprof_head_upld_stg(size_profile,
                                                size_profile_desc,
                                                size_group,
                                                history_weight,
                                                location,
                                                business_model,
                                                buying_group,
                                                buying_subgroup,
                                                buying_set,
                                                product_group,
                                                category,
                                                subcategory,
                                                brand,
                                                status,
                                                filename,  
                                                create_datetime,
                                                last_updatetime
											)
						VALUES				(   p_size_profile,           
                                                'Profile_desc'||p_size_profile,     
                                                p_size_group,             
                                                p_history_weight,        
                                                p_location,               
                                                p_business_model,         
                                                p_buying_group,           
                                                p_buying_subgroup,        
                                                p_buying_set,             
                                                p_product_group,          
                                                p_category,               
                                                p_subcategory,            
                                                p_brand,                  
                                                'U',                 
                                                'Profile_filename'||p_size_profile,     
                                                l_date,
                                                l_date );

INSERT INTO  int_asos.int_pl_sizprof_detail_upld_stg(size_profile    ,
														size_code       ,
														percentile      ,
														status          ,
														filename        ,
														create_datetime ,
														last_updatetime )
														
								values                (p_size_profile,
														p_size_code,
														'1',
														'U',
														'Profile_filename'||p_size_profile,  
														l_date,
														l_date);
	END LOOP;
	END LOOP;
    END LOOP;
    commit;
    
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/
