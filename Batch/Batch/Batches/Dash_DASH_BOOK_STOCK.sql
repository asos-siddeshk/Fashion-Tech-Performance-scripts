• WF.RD.DASH_ACT_STK_INTRA_DAY:completed in 0:30:49 secs

-- ./nb_refresh_result.ksh $UP DASH_BOOK_STOCK_DETAIL &


SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_BOOK_STOCK_DETAIL';

select * from dash_asos.DASH_BOOK_STOCK_DETAIL;
select * from dash_asos.DASH_R_BOOK_STOCK_DETAIL_A;
select * from dash_asos.DASH_R_BOOK_STOCK_DETAIL_B;
select * from dash_asos.DASH_V_R_BOOK_STOCK_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_BOOK_STOCK_DETAIL';    
select * from all_views where upper(view_name) like 'DASH_V_R_BOOK_STOCK_DTL';    

-- ./nb_refresh_result.ksh $UP DASH_BOOK_STOCK_TAB &

 
SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_BOOK_STOCK_TAB';

select * from dash_asos.DASH_BOOK_STOCK_TAB;
select * from dash_asos.DASH_R_BOOK_STOCK_TAB_A;
select * from dash_asos.DASH_R_BOOK_STOCK_TAB_B;
select * from dash_asos.DASH_V_R_BOOK_STOCK_TAB; -- 159

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_BOOK_STOCK_TAB';  
select * from all_views where upper(view_name) like 'DASH_V_R_BOOK_STOCK_TAB';    


-- ./nb_refresh_result.ksh $UP DASH_BOOK_STOCK_BUCKETS &


SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_BOOK_STOCK_BUCKETS';

select * from dash_asos.DASH_BOOK_STOCK_BUCKETS;
select * from dash_asos.DASH_R_BOOK_STOCK_BUCKETS_A;
select * from dash_asos.DASH_R_BOOK_STOCK_BUCKETS_B;
select * from dash_asos.DASH_V_R_BOOK_STOCK_BUCKETS; -- 159

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_BOOK_STOCK_BUCKETS';  
select * from all_views where upper(view_name) like 'DASH_V_R_BOOK_STOCK_BUCKETS';    
