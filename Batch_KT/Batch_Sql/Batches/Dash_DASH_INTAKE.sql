 -- nb_refresh_result.ksh <alias> DASH_INTAKE_BASE
 
  SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_INTAKE_BASE';

select * from dash_asos.DASH_INTAKE_BASE;
select * from dash_asos.DASH_R_INTAKE_BASE_A;
select * from dash_asos.DASH_R_INTAKE_BASE_B;
select * from dash_asos.DASH_V_R_INTAKE_BASE;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_INTAKE_BASE';    
select * from all_views where upper(view_name) like 'DASH_V_R_INTAKE_BASE';  


 -- nb_refresh_result.ksh <alias> DASH_INTAKE_ITEM


  SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_INTAKE_ITEM';

select * from dash_asos.DASH_INTAKE_ITEM;
select * from dash_asos.DASH_R_INTAKE_ITEM_A;
select * from dash_asos.DASH_R_INTAKE_ITEM_B;
select * from dash_asos.DASH_V_R_INTAKE_ITEM;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_INTAKE_ITEM';    
select * from all_views where upper(view_name) like 'DASH_V_R_INTAKE_ITEM';  

-- nb_refresh_result.ksh <alias> DASH_INTAKE_ITEM_DTL




  SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_INTAKE_ITEM_DTL';

select * from dash_asos.DASH_INTAKE_ITEM_DTL;
select * from dash_asos.DASH_R_INTAKE_ITEM_DTL_A;
select * from dash_asos.DASH_R_INTAKE_ITEM_DTL_B;
select * from dash_asos.DASH_V_R_INTAKE_ITEM_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_INTAKE_ITEM_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_INTAKE_ITEM_DTL';  



nb_refresh_result.ksh <alias> DASH_ITEM_REPLN_DTL

  SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_REPLN_DTL';

select * from dash_asos.DASH_ITEM_REPLN_DTL;
select * from dash_asos.DASH_R_ITEM_REPLN_TAB_A;
select * from dash_asos.DASH_R_ITEM_REPLN_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_REPLN_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_REPLN_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_REPLN_DTL';






