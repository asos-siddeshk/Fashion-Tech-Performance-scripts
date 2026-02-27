--nb_refresh_result.ksh <alias> DASH_BLIND_GS_DTL
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_BLIND_GS_DTL';
select * from dash_asos.DASH_BLIND_GS_DTL;
select * from dash_asos.DASH_R_BLIND_GS_DTL_TAB_A;
select * from dash_asos.DASH_R_BLIND_GS_DTL_TAB_B;
select * from dash_asos.DASH_V_R_BLIND_GOLD_SEAL_DTL;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_BLIND_GS_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_BLIND_GOLD_SEAL_DTL';  
 
 
 -- nb_refresh_result.ksh <alias> DASH_GOLD_SEAL_DTL
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_GOLD_SEAL_DTL';
select * from dash_asos.DASH_GOLD_SEAL_DTL;
select * from dash_asos.DASH_R_GOLD_SEAL_DTL_TAB_A;
select * from dash_asos.DASH_R_GOLD_SEAL_DTL_TAB_B;
select * from dash_asos.DASH_V_R_GOLD_SEAL_DTL;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_GOLD_SEAL_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_GOLD_SEAL_DTL';  