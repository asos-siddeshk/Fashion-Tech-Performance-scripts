-- nb_refresh_result.ksh <alias> DASH_ORD_SUB

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ORD_SUB';
select * from dash_asos.DASH_ORD_SUB;
select * from dash_asos.DASH_R_ORD_SUB_RSLT_A;
select *  from dash_asos.DASH_R_ORD_SUB_RSLT_B;
select * from dash_asos.DASH_V_R_ORD_SUB_RSLT;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_BUY_PRICE';    
select * from all_views where upper(view_name) like 'DASH_V_R_ORD_SUB_RSLT'; 

-- nb_refresh_result.ksh <alias> DASH_ORD_REC

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ORD_REC';
select * from dash_asos.DASH_ORD_REC;
select * from dash_asos.DASH_R_ORD_RECOM_DTL_A;
select *  from dash_asos.DASH_R_ORD_RECOM_DTL_B;
select * from dash_asos.DASH_V_R_ORD_RECOM_DTL;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ORD_REC';    
select * from all_views where upper(view_name) like 'DASH_V_R_ORD_RECOM_DTL'; 



 -- nb_refresh_result.ksh <alias> DASH_ORD_REV
 
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ORD_REV';
select * from dash_asos.DASH_ORD_REV;
select * from dash_asos.DASH_R_ORD_REVISION_MST_A;
select *  from dash_asos.DASH_R_ORD_REVISION_MST_B;
select * from dash_asos.DASH_V_R_ORD_RECOM_DTL;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ORD_REV';    
select * from all_views where upper(view_name) like 'DASH_V_R_ORD_REVISION_MST';  
 
 -- nb_refresh_result.ksh <alias> DASH_ORD_WRKSHT

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ORD_WRKSHT';
select * from dash_asos.DASH_ORD_WRKSHT;
select * from dash_asos.DASH_R_ORD_WRKSHT_RSLT_A;
select *  from dash_asos.DASH_R_ORD_WRKSHT_RSLT_B;
select * from dash_asos.DASH_V_R_ORD_WRKSHT_RSLT;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ORD_WRKSHT';    
select * from all_views where upper(view_name) like 'DASH_V_R_ORD_WRKSHT_RSLT';  
 