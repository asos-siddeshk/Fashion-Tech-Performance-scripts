--nb_refresh_result.ksh <alias> DASH_ITEM_STATUS_CC_DTL

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_STATUS_CC_DTL';
select * from dash_asos.DASH_ITEM_STATUS_CC_DTL;
select * from dash_asos.DASH_R_ITEM_STATUS_CC_TAB_A;
select * from dash_asos.DASH_R_ITEM_STATUS_CC_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_STATUS_CC_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_STATUS_CC_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_STATUS_CC_DTL';  


DASH_ITEM_STATUS_PROD_DTL
select * from dash_asos.ADD_TYPE_MODULE;


 -- nb_refresh_result.ksh <alias> DASH_ITEM_STATUS_COM_DTL

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_STATUS_COM_DTL';
select * from dash_asos.DASH_ITEM_STATUS_COM_DTL;
select * from dash_asos.DASH_R_ITEM_STATUS_COM_TAB_A;
select * from dash_asos.DASH_R_ITEM_STATUS_COM_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_STATUS_COM_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_STATUS_COM_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_STATUS_COM_DTL'; 


 -- nb_refresh_result.ksh <alias> DASH_ITEM_STATUS_PROD_DTL
 
  SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_STATUS_PROD_DTL';

select * from dash_asos.DASH_ITEM_STATUS_PROD_DTL;
select * from dash_asos.DASH_R_ITEM_STATUS_PROD_TAB_A;
select * from dash_asos.DASH_R_ITEM_STATUS_PROD_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_STATUS_PROD_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_STATUS_PROD_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_STATUS_PROD_DTL'; 


-- nb_refresh_result.ksh <alias> DASH_ITEM_STATUS_OPT_DTL

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_STATUS_OPT_DTL';
select * from dash_asos.DASH_ITEM_STATUS_OPT_DTL;
select * from dash_asos.DASH_R_ITEM_STATUS_OPT_TAB_A;
select * from dash_asos.DASH_R_ITEM_STATUS_OPT_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_STATUS_OPT_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_STATUS_OPT_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_STATUS_OPT_DTL';  

-- nb_refresh_result.ksh <alias> DASH_ITEM_STATUS_SUB

 SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_STATUS_SUB';

select * from dash_asos.DASH_ITEM_STATUS_SUB;
select * from dash_asos.DASH_R_ITEM_STATUS_SUB_A;
select * from dash_asos.DASH_R_ITEM_STATUS_SUB_B;
select * from dash_asos.DASH_V_R_ITEM_STATUS_SUB;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_STATUS_SUB';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_STATUS_SUB';

             
            insert into int_asos.int_item_pim_event_stg 
            select item,'SampleReceived',vdate -1,'INT_ASOS',vdate,null,null
            from item_master im , period p where item_level ='1' and status ='A' 
                and not exists (select 1 from int_asos.int_item_pim_event_stg iip where iip.item = im.item) and rownum <= '5000';
            insert into int_asos.int_item_pim_event_stg 
            select item,'CopyPublished',vdate-1,'INT_ASOS',vdate,null,null
            from item_master im , period p where item_level ='1' and status ='A' 
                and not exists (select 1 from int_asos.int_item_pim_event_stg iip where iip.item = im.item) and rownum <= '6000';
            insert into int_asos.int_item_pim_event_stg 
            select item,'ClassificationPublished',vdate-2,'INT_ASOS',vdate,null,null
            from item_master im , period p where item_level ='1' and status ='A' 
                and not exists (select 1 from int_asos.int_item_pim_event_stg iip where iip.item = im.item) and rownum <= '7000';
            insert into int_asos.int_item_pim_event_stg 
            select item,'MediaComplete',vdate-2,'INT_ASOS',vdate,null,null
            from item_master im , period p where item_level ='1' and status ='A' 
                and not exists (select 1 from int_asos.int_item_pim_event_stg iip where iip.item = im.item) and rownum <= '8000';
    
    
-- nb_refresh_result.ksh <alias> DASH_MISSING_EAN_DTL

 SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_MISSING_EAN_DTL';

select distinct ITEM,BUYING_GROUP, BUSINESS_MODEL, BUYING_SUBGROUP, BUYING_SET from dash_asos.DASH_R_MISSING_EAN_TAB_B;


select * from dash_asos.DASH_MISSING_EAN_DTL where BUSINESS_MODEL='1';
select * from dash_asos.DASH_R_MISSING_EAN_TAB_A;
select * from dash_asos.DASH_R_MISSING_EAN_TAB_B;
select * from dash_asos.DASH_V_R_MISSING_EAN_DTL; --101303022

select * from dash_asos.DASH_V_R_MISSING_EAN_DTL where item =  '101303022';

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_MISSING_EAN_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_MISSING_EAN_DTL';