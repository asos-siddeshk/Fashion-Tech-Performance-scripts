SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_BUY_PRICE';

select * from dash_asos.DASH_BUY_PRICE;
select * from dash_asos.DASH_R_BUY_PRICE_A;
select * from dash_asos.DASH_R_BUY_PRICE_B;
select * from dash_asos.DASH_V_R_ITEM_NOT_LIVE;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_BUY_PRICE';    
select * from all_views where upper(view_name) like 'DASH_V_R_BUY_PRICE';    

SELECT ITEM,
	   LOC,
	   LOC_TYPE,
	   BUY_UNIT_RETAIL
	   FROM dash_asos.MA_V_ITEM_LOC_BUY_PRICE;