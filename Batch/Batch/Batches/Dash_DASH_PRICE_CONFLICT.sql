select  * from dash_asos.DASH_REG_PA_DTL dash
 inner join  dash_asos.v_item_master im  on im.item=dash.item
 where im.division ='1' and dash.business_model='1';


 -- nb_refresh_result.ksh <alias> DASH_REG_PA_DTL DASH_REG_PA_DTL
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_REG_PA_DTL';
select * from dash_asos.DASH_REG_PA_DTL;
select * from dash_asos.DASH_R_REG_PA_DTL_A;
select * from dash_asos.DASH_R_REG_PA_DTL_B; --18745

select count(1) from dash_asos.DASH_V_R_REG_PA_DTL; --22792

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_REG_PC_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_REG_PA_DTL'; 

select * from dash_asos.DASH_PC_LOC_TMP;

select distinct dash.item from dash_asos.DASH_REG_PA_DTL dash
    inner join  dash_asos.v_item_master im  on im.item=dash.item
    where im.division =1 and dash.business_model=1 ;

select  distinct dash.item from dash_asos.DASH_REG_PA_DTL dash
    inner join  dash_asos.v_item_master im  on im.item=dash.item;

select * from dash_asos.DASH_PC_LOC_TMP;

 -- nb_refresh_result.ksh <alias> DASH_REG_PC_DTL
 
 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_REG_PC_DTL';

select * from dash_asos.DASH_REG_PC_DTL;
select * from dash_asos.DASH_R_REG_PC_DTL_A;
select * from dash_asos.DASH_R_REG_PC_DTL_B; --18745
select * from dash_asos.DASH_V_R_REG_PC_DTL; --22790



select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_REG_PC_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_REG_PC_DTL'; 

 -- nb_refresh_result.ksh <alias> DASH_PROMO_PC_DTL

 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_PROMO_PC_DTL';

select * from dash_asos.DASH_PROMO_PC_DTL;
select * from dash_asos.DASH_R_PROMO_PC_DTL_A;
select * from dash_asos.DASH_R_PROMO_PC_DTL_B;
select * from dash_asos.DASH_V_R_PROMO_PC_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_PROMO_PC_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_REG_PC_DTL'; 


--nb_refresh_result.ksh <alias> DASH_CLR_PC_DTL


 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_CLR_PC_DTL';

select * from dash_asos.DASH_CLR_PC_DTL;
select * from dash_asos.DASH_R_CLR_PC_DTL_A;
select * from dash_asos.DASH_R_CLR_PC_DTL_B;
select * from dash_asos.DASH_V_R_CLR_PC_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_CLR_PC_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_CLR_PC_DTL'; 
