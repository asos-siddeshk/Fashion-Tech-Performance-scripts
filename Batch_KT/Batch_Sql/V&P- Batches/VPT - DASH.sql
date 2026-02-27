./nb_refresh_result.ksh $UP DASH_BOOK_STOCK_DETAIL &
./nb_refresh_result.ksh $UP DASH_BOOK_STOCK_TAB &
./nb_refresh_result.ksh $UP DASH_BOOK_STOCK_BUCKETS &


select * from all_synonyms where SYNONYM_NAME like 'DASH_ACTION_ASN';

select * from dash_asos.ordhead where order_no ='50001052819';
select * from dash_asos.ordloc where order_no ='50001052819';
select * from dash_asos.ordloc where order_no ='50001052819';

select * from dash_asos.DASH_ACTION_ASN;

select * from dash_asos.DASH_R_ACTION_ASN_DTL_A;
select * from dash_asos.DASH_R_ACTION_ASN_DTL_B;

select * from all_mviews where mview_NAME like 'DASH_R_ACTION_ASN_DTL_A';
select * from all_tables where table_NAME like 'DASH_R_ACTION_ASN_DTL_A';
select * from all_tables where table_NAME like 'DASH_R_ACTION_ASN_DTL_B';


select * from dash_asos.DASH_ITEM_NOT_LIVE_DTL;

select * from all_synonyms where SYNONYM_NAME like 'DASH_ITEM_NOT_LIVE_DTL';

select * from dash_asos.DASH_R_ITEM_NOT_LIVE_TAB_A;
select * from dash_asos.DASH_R_ITEM_NOT_LIVE_TAB_B;

select * from dash_asos.DASH_ITEM_NOT_LIVE_DTL;

select item,loc,DATE_21, DATE_22 from dash_asos.item_loc_cfa_ext where item= '100017758';
select * from item_loc where item= '100017758';



DASH_REFRESH_PROCESS_SQL.PROCESS



 SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_NOT_LIVE_DTL';
    
   
select * from all_synonyms where SYNONYM_NAME like 'DASH_ITEM_NOT_LIVE_DTL';
select * from all_views where view_NAME like 'DASH_V_R_ITEM_NOT_LIVE';

 SELECT * FROM dash_asos.DASH_ITEM_NOT_LIVE_DTL;   
 SELECT * FROM dash_asos.DASH_V_R_ITEM_NOT_LIVE;   

    
SELECT * FROM  dash_asos.DASH_V_R_BOOK_STOCK_DTL; -- 0
SELECT * FROM  dash_asos.DASH_V_R_BOOK_STOCK_TAB; --159
SELECT * FROM  dash_asos.DASH_V_R_BOOK_STOCK_BUCKETS; --10
SELECT * FROM  dash_asos.DASH_V_R_TSF_DTL; --0
SELECT * FROM  dash_asos.DASH_V_R_TSF_MST; -- 128
SELECT * FROM  dash_asos.DASH_V_R_ALLOC_DTL;  -- 58
SELECT * FROM  dash_asos.DASH_V_R_BUY_PRICE; -- 144 
SELECT * FROM  dash_asos.DASH_V_R_ORD_SUB_RSLT; -- 270
SELECT * FROM  dash_asos.DASH_V_R_ORD_WRKSHT_RSLT;
SELECT * FROM  dash_asos.DASH_V_R_ORD_REVISION_MST;
SELECT * FROM  dash_asos.DASH_V_R_ORD_RECOM_DTL;
SELECT * FROM  dash_asos.DASH_V_R_FACT_CORREC_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ACTION_ASN_DTL;
SELECT * FROM  dash_asos.DASH_V_R_P_CARR_BOOK_DTL;
SELECT * FROM  dash_asos.DASH_V_R_PEND_FC_BOOK_DTL;
SELECT * FROM  dash_asos.DASH_V_R_PEND_RECEIPT_DTL;
SELECT * FROM  dash_asos.DASH_V_R_PEND_SHIP_DTL;
SELECT * FROM  dash_asos.DASH_V_R_TSF_DISC_HEAD;
SELECT * FROM  dash_asos.DASH_V_R_TSF_DISC_BOX;
SELECT * FROM  dash_asos.DASH_V_R_TSF_DISC_SKU;
SELECT * FROM  dash_asos.DASH_V_R_BLIND_GOLD_SEAL_DTL;
SELECT * FROM  dash_asos.DASH_V_R_GOLD_SEAL_DTL;
SELECT * FROM  dash_asos.DASH_V_R_REG_PC_DTL;
SELECT * FROM  dash_asos.DASH_V_R_PROMO_PC_DTL;
SELECT * FROM  dash_asos.DASH_V_R_CLR_PC_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_CC_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_COM_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_PROD_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_NOT_LIVE;
SELECT * FROM  dash_asos.DASH_V_R_REG_PA_DTL;
SELECT * FROM  dash_asos.DASH_V_R_PROMO_PA_DTL;
SELECT * FROM  dash_asos.DASH_V_R_CLR_PA_DTL;
SELECT * FROM  dash_asos.DASH_V_R_CLR_PA_FILTER;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_RECLASS_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_REPLN_DTL;
SELECT * FROM  dash_asos.DASH_V_R_MISSING_EAN_DTL;
SELECT * FROM  dash_asos.DASH_V_R_INTAKE_ITEM_DTL;
SELECT * FROM  dash_asos.DASH_V_R_INTAKE_ITEM;
SELECT * FROM  dash_asos.DASH_V_R_INTAKE_BASE;
SELECT * FROM  dash_asos.DASH_V_R_RECLASS_BASE;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_ATS;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_WH_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_OPT_DTL;
SELECT * FROM  dash_asos.DASH_V_R_ITEM_STATUS_SUB;
