• WF.RD.DASH_INTAKE

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

• WF.RD.DASH_ACT_STK_INTRA_DAY
    DASH_ALLOC_DTL
    
      SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ALLOC_DTL';
    
    select * from dash_asos.DASH_ALLOC_DTL;
    select * from dash_asos.DASH_R_ALLOC_DTL_A;
    select * from dash_asos.DASH_R_ALLOC_DTL_B;
    select * from dash_asos.DASH_V_R_ALLOC_DTL;
    
    select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_REPLN_DTL';    
    select * from all_views where upper(view_name) like 'DASH_V_R_ALLOC_DTL';
    
    NB_TSFDTL_REFRESH 
        
        SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_TSF_DTL';
              
        select * from dash_asos.DASH_TSF_DTL;
        select * from dash_asos.DASH_R_ALLOC_DTL_A;
        select * from dash_asos.DASH_R_ALLOC_DTL_B;
        select * from dash_asos.DASH_V_R_ALLOC_DTL;
        
        select * from all_synonyms where upper(SYNONYM_NAME) like 'NB_TSFDTL_REFRESH';    
        select * from all_views where upper(view_name) like 'DASH_V_R_ALLOC_DTL';




NB_ALLOC_REFRESH 



•WF.RD.DASH_OPTION_INTRA_DAY
•WF.RD.DASH_INTRA_DAY
•WF.RD.DASH_TSF_DISC_INTRA_DAY
•WF.RD.DASH_PO_INTRA_DAY
•WF.RD.DASH_PRICE_INTRA_DAY
•WF.RD.DASH_BLIND_GOLD_SEAL
•WF.RD.DASH_PRICE_CONFLICT