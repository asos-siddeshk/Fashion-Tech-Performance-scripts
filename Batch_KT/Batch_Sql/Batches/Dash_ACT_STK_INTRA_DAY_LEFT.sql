 -- nb_refresh_result.ksh <alias> DASH_ALLOC_DTL

select count(1) from  dash_asos.DASH_V_R_ITEM_REPLN_SUM;--925



 SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ALLOC_DTL';

select * from dash_asos.DASH_ALLOC_DTL;
select * from dash_asos.DASH_R_ALLOC_DTL_A;
select * from dash_asos.DASH_R_ALLOC_DTL_B;
select * from dash_asos.DASH_V_R_ALLOC_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ALLOC_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ALLOC_DTL';   

-- nb_refresh_result.ksh <alias> DASH_TSF_DTL
 SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_TSF_DTL';

select * from dash_asos.DASH_TSF_DTL;
select * from dash_asos.DASH_R_TSF_DTL_A;
select * from dash_asos.DASH_R_TSF_DTL_B;
select * from dash_asos.DASH_V_R_TSF_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_TSF_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ALLOC_DTL'; 

-- nb_refresh_result.ksh <alias> DASH_TSF_MST


 SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_TSF_MST';

select * from dash_asos.DASH_TSF_MST;
select * from dash_asos.DASH_R_TSF_MST_A;
select * from dash_asos.DASH_R_TSF_DTL_B;
select * from dash_asos.DASH_V_R_TSF_MST;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_TSF_MST';    
select * from all_views where upper(view_name) like 'DASH_V_R_ALLOC_DTL'; 

