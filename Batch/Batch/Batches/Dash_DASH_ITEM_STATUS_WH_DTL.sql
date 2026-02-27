nb_refresh_result.ksh <alias> DASH_ITEM_STATUS_WH_DTL


 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'FIN_MV_NEW_VAT_ITEM';


select * from dash_asos.DASH_ITEM_STATUS_WH_DTL;
select * from dash_asos.DASH_R_ITEM_STATUS_WH_A;
select * from dash_asos.DASH_R_ITEM_STATUS_WH_B;
select * from dash_asos.DASH_V_R_ITEM_STATUS_WH_DTL;



select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_STATUS_WH_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_STATUS_WH_DTL';   