• WF.RD.DASH_ACT_STK_INTRA_DAY:completed in 0:30:49 secs
• JOBP.DASH_OPTION_INTRA_DAY:completed in 0:24:23 secs
• WF.RD.DASH_INTRA_DAY:completed in 0:44:30 secs
• WF.RD.DASH_TSF_DISC_INTRA_DAY:completed in 0:00:06 secs
• WF.RD.DASH_PO_INTRA_DAY:completed in 0:07:56 secs
• WF.RD.DASH_PRICE_INTRA_DAY:completed in 0:33:31 secs

 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_RECLASS_DTL';


select * from dash_asos.DASH_ITEM_RECLASS_DTL;
select * from dash_asos.DASH_R_ITEM_RECLASS_TAB_A;
select * from dash_asos.DASH_R_ITEM_RECLASS_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_RECLASS_DTL;

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_RECLASS_BASE';

select * from dash_asos.DASH_RECLASS_BASE;
select * from dash_asos.DASH_R_RECLASS_BASE_A;
select * from dash_asos.DASH_R_RECLASS_BASE_B;
select * from dash_asos.DASH_V_R_RECLASS_BASE;

update dash_asos.reclass_error_log set RECLASS_DATE ='27-JAN-2019'; -- RMS update
 
 select * from dash_asos.reclass_error_log;
 
 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_RECLASS_BASE';
    
select * from dash_asos.DASH_BOOK_STOCK_DETAIL;

select OWNER, OBJECT_NAME, OBJECT_TYPE from all_objects where upper(object_name) like 'DASH_RECLASS_BASE';    

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_RECLASS_BASE';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_RECLASS_DTL';    

select * from all_views where upper(view_name) like 'DASH_V_R_RECLASS_BASE';
select * from all_mviews where upper(mview_name) like 'DASH_ITEM_RECLASS_DTL';
   
   