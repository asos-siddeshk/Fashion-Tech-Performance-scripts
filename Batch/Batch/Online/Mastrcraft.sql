select OWNER, TABLE_NAME,NUM_ROWS from all_tables where OWNER in('RMS','MA_ASOS','INT_ASOS','ITEMHUB_ASOS','ORACNV') AND NUM_ROWS >= '5000' order by 1,2;
select OWNER, TABLE_NAME,NUM_ROWS from all_tables where OWNER in('RMS','MA_ASOS','INT_ASOS','ITEMHUB_ASOS','ORACNV') AND NUM_ROWS >= '1000000' order by 1,2;


select count(1) from INT_ASOS.INT_AUTO_CORRECTION_LOG;
select count(1) from RMS.ALLOC_CHRG;
select count(1) from RMS.ALLOC_HEADER;

select * from RMS.ALLOC_CHRG;



select * from rms.item_master;
select * from rms.uda_values where uda_id = '105' and uda_value = '3';
select * from rms.uda where uda_id = '105';

select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE_A;

select * from all_tab_cols where column_name like '%BATCH%';

select * from rms.RMS_BATCH_STATUS;
select * from rms.CFA_ATTRIB_GROUP_SET;
select * from rms.CFA_ATTRIB;
select * from rms.CFA_ATTRIB_GROUP;
select * from all_tables where table_name like 'CFA%';
select * from all_views where view_name like '%PO%' and owner like 'RMS';
select * from rms.NB_V_TR_PO_OPT_ASN_PRTY;

select * from rms.NB_V_TR_PO_OPT_ASN_PRTY where po_priority  in ('2','3','1');

select distinct options from rms.NB_V_TR_PO_OPT_ASN_PRTY where po_priority  in ('2','3','1') and rownum <= '500';
select distinct OPTION_ID from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where PRODUCT_SELLING_MODEL ='AFS' and rownum <= '500';

select * from rms.NB_V_TR_PO_OPT_ASN_PRTY where po_priority is null and OPTIONS in (select distinct OPTION_ID from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where PRODUCT_SELLING_MODEL ='AFS');

select 






select distinct options from rms.NB_V_TR_PO_OPT_ASN_PRTY where po_priority  in ('2','3','1') and rownum <= '500';
select distinct OPTION_ID from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where PRODUCT_SELLING_MODEL ='AFS' and rownum <= '500';



/*-- Query to select the Items for Data subset activity
--Create a temporary table to store selected data from ITEM_MASTER and MA_ITEM_ATTRIBUTES  tables for Dept, Business model, buying group and buying subgroup combination. 
--Select ITEM, CLASS, DEPT, BUSINESS_MODEL,BUYING_GROUP, BUYING_SUBGROUP and BUYING_SET columns and assign row numbers within partitions.
--Select only the first 2 records within each partition.*/

-- Drop the temp table if it is already there
drop table DATASUBSET_ITEM_OP; 

--Create the temp table 
create table DATASUBSET_ITEM_OP as
with RANKED_ITEMS as (
select 
      im.ITEM, 
      im.DEPT, 
      im.CLASS, 
      BHR.BUSINESS_MODEL, 
      BHR.BUYING_GROUP, 
      BHR.BUYING_SUBGROUP, 
      BHR.BUYING_SET, 
      ROW_NUMBER() over (partition by im.DEPT, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP
      order by im.LAST_UPDATE_DATETIME desc) as ROW_NUM 
    from MA_ASOS.MA_ITEM_ATTRIBUTES BHR, RMS.ITEM_MASTER im
    where im.ITEM_LEVEL = '1' and im.ITEM = BHR.ITEM and STATUS = 'A')
    select * from  RANKED_ITEMS   where  ROW_NUM <= '1';

drop table DATASUBSET_ITEM_AFS_TR;
select * from DATASUBSET_ITEM_AFS_TR;
create table DATASUBSET_ITEM_AFS_TR as
    select distinct options as item from rms.NB_V_TR_PO_OPT_ASN_PRTY where po_priority  in ('2','3','1') and rownum <= '1000';
insert into DATASUBSET_ITEM_AFS_TR
    select distinct OPTION_ID from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where PRODUCT_SELLING_MODEL ='AFS' and rownum <= '1000';

select * from DATASUBSET_ITEM_OP;
insert into DATASUBSET_ITEM_OP 
select im.ITEM, im.DEPT, im.class, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET, 2 as row_num 
        from MA_ASOS.MA_ITEM_ATTRIBUTES BHR, RMS.ITEM_MASTER im where im.ITEM = BHR.ITEM and  im.ITEM in (select ITEM from DATASUBSET_ITEM_AFS_TR);
        

-- Drop the subset table if already exits
drop table DATASUBSET_ITEM; 


--Create a new datasubset_item table by selecting relevant data from ITEM_MASTER where ITEM is in the temporary table ITEM_MASTER_TEMP (Level 1 items)
create table DATASUBSET_ITEM as  select im.ITEM,im.ITEM_level, im.DEPT, im.class, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET  
        from MA_ASOS.MA_ITEM_ATTRIBUTES BHR, RMS.ITEM_MASTER im where im.ITEM = BHR.ITEM and  im.ITEM in (select ITEM from DATASUBSET_ITEM_OP);
        
-- Append additional rows to the datasubset_item table,where ITEM_PARENT is in the temporary table ITEM_MASTER_TEMP (Level 2 items)        
insert into DATASUBSET_ITEM select im.ITEM,im.ITEM_level, im.DEPT, im.class, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET  
        from MA_ASOS.MA_ITEM_ATTRIBUTES BHR, RMS.ITEM_MASTER im where im.ITEM = BHR.ITEM and  im.ITEM_PARENT in (select ITEM from DATASUBSET_ITEM_OP);
        
-- Append additional rows to the datasubset_item table, where ITEM_GRANDPARENT is in the temporary table ITEM_MASTER_TEMP (Level 3 items)      
insert into DATASUBSET_ITEM select im.ITEM,im.ITEM_level, im.DEPT, im.class, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET  
        from MA_ASOS.MA_ITEM_ATTRIBUTES BHR, RMS.ITEM_MASTER im where im.ITEM = BHR.ITEM(+) and  im.ITEM_GRANDPARENT in (select ITEM from DATASUBSET_ITEM_OP);


select item_level,DEPT, CLASS, BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET,count(1) 
    from DATASUBSET_ITEM group by item_level,DEPT, CLASS, BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET;


drop table DATASUBSET_ORDER;
create table DATASUBSET_ORDER as 
    select ORDER_NO,MASTER_PO_NO from RMS.ORDHEAD where ORDER_NO in (select ORDER_NO from RMS.ORDSKU  where ITEM in (select ITEM from DATASUBSET_ITEM)) and STATUS != 'C' ;
delete from DATASUBSET_ORDER
    where ORDER_NO in (select ORDER_NO from RMS.ORDSKU  where ITEM not in (select ITEM from DATASUBSET_ITEM));


select * from rms.NB_V_TR_PO_OPT_ASN_PRTY where po_priority  in ('2','3','1') and options in (select ITEM from DATASUBSET_ITEM);
select * from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where PRODUCT_SELLING_MODEL ='AFS' and option_id in (select ITEM from DATASUBSET_ITEM);
select * from INT_ASOS.INT_PL_INVENTORY_DNLD_STG where option_id in (select ITEM from DATASUBSET_ITEM);



/*

drop table DATASUBSET_ITEM_OP;
create table DATASUBSET_ITEM_OP as
with ranked_items as (
SELECT 
      im.ITEM, 
      im.DEPT, 
      im.CLASS, 
      BHR.BUSINESS_MODEL, 
      BHR.BUYING_GROUP, 
      BHR.BUYING_SUBGROUP, 
      BHR.BUYING_SET, 
      ROW_NUMBER() OVER (PARTITION BY im.DEPT, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP
      ORDER BY im.LAST_UPDATE_DATETIME desc) AS row_num 
    FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, rms.Item_master im
    WHERE im.ITEM_LEVEL = '1' and im.item = bhr.item AND STATUS = 'A')
    select * from  ranked_items   WHERe  row_num <= '2';

drop table datasubset_item; 
create table datasubset_item as  SELECT im.ITEM, im.DEPT, im.CLASS, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET  
        FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, rms.Item_master im WHERE im.item = bhr.item AND  im.item in (select item from DATASUBSET_ITEM_OP);

insert into datasubset_item SELECT im.ITEM, im.DEPT, im.CLASS, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET  
        FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, rms.Item_master im WHERE im.item = bhr.item AND  im.ITEM_PARENT in (select item from DATASUBSET_ITEM_OP);
        
insert into datasubset_item SELECT im.ITEM, im.DEPT, im.CLASS, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP,  BHR.BUYING_SET  
        FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, rms.Item_master im WHERE im.item = bhr.item(+) AND  im.ITEM_GRANDPARENT in (select item from DATASUBSET_ITEM_OP);

drop table DATASUBSET_ORDER;
create table DATASUBSET_ORDER as 
Select order_no,MASTER_PO_NO from RMS.ORDHEAD where Order_no in (select order_no from RMS.ordsku  where item in (Select item from RMS.DATASUBSET_ITEM)) and status != 'C' ;

Select * from RMS.ORDHEAD where Order_no in (select order_no from RMS.ordsku  where item in (Select item from RMS.DATASUBSET_ITEM)) and status != 'C' ;

drop table DATASUBSET_ALLOC;
create table DATASUBSET_ALLOC as 
Select alloc_no from RMS.ALLOC_HEADER where item in (Select item from RMS.DATASUBSET_ITEM) and STATUS!= 'C';


drop table DATASUBSET_SHIPMENT;
create table DATASUBSET_SHIPMENT as 
  Select distinct shipment,asn as asn_nbr, BOL_NO as distro_no from RMS.SHIPMENT where Order_no in (select order_no from skumar.DATASUBSET_ORDER);
insert into DATASUBSET_SHIPMENT
  select distinct shipment,null as asn_nbr, distro_no from shipsku sk where sk.distro_no in (select alloc_no from skumar.DATASUBSET_ALLOC);


Select distinct shipment,asn as asn_nbr, null as distro_no from RMS.SHIPMENT where Order_no in (select order_no from skumar.DATASUBSET_ORDER);

select * from skumar.DATASUBSET_SHIPMENT;
    
select * froim 45152201388047

select * from DATASUBSET_SHIPMENT;

select * from das.shipment where shipment in (select shipment from DATASUBSET_SHIPMENT);


select * from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023';
select * from rms.RPM_CLEARANCE_CUST_ATTR where CUST_ATTR_ID in (select CUST_ATTR_ID from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023');
select * from rms.RPM_CLEARANCE_reset where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023';
select * from rms.RPM_FUTURE_RETAIL where clearance_id in (select clearance_id from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023');
select * from rms.RPM_MERCH_LIST_DETAIL;  
select * from rms.RPM_MERCH_LIST_HEAD where PRICE_EVENT_ID not in (select clearance_id from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023');



select * from rms.RPM_PROMO
select * from rms.RPM_PROMO_COMP
select * from rms.RPM_PROMO_DTL
select * from rms.RPM_PROMO_DTL_CUST_ATTR
select * from rms.RPM_PROMO_DTL_DISC_LADDER
select * from rms.RPM_PROMO_DTL_LIST
select * from rms.RPM_PROMO_DTL_LIST_GRP
select * from rms.RPM_PROMO_DTL_MERCH_NODE
select * from rms.RPM_PROMO_ITEM_LOC_EXPL
select * from rms.RPM_PROMO_ZONE_LOCATION













create table addr_bk as select * from addr;
create table sups_bk as select * from sups;
delete from sups where KEY_VALUE_1  in ('2001240001','1000004834');
delete from addr where KEY_VALUE_1  in ('2001240001','1000004834');
*/


select a.KEY_VALUE_1, a.MODULE, a.CONTACT_PHONE, b.CONTACT_PHONE from addr a, addr_bk b where a.KEY_VALUE_1 = b.KEY_VALUE_1  AND a.MODULE ='SUPP'; 
select * from all_constraints where constraint_name like 'POU_SUP_FK';
select * from PARTNER_ORG_UNIT;


select * from all_tables where table_name like '%DATA%';



select * from skumar.BSINGH_ITEM_MASTER;

select * from rpm_future_retail where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from RPM_CLEARANCE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from RPM_CLEARANCE_RESET where item in (select item from skumar.BSINGH_ITEM_MASTER);





select * from MA_ASOS.MA_BRANDED_RECOMMENDED_PRICE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_CLEARANCE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_CLEARANCE_RESET where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_COST_CHANGE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_COST_CONFLICT_CHECK where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_GROUP_DETAIL where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_GROUP_HEADER where GROUP_ID in (select GROUP_ID from MA_ASOS.MA_GROUP_DETAIL where item in (select item from skumar.BSINGH_ITEM_MASTER));

select * from MA_ASOS.MA_GROUP_TYPE ; 
select * from MA_ASOS.MA_ITEMSUP_PUB_INFO where item in (select item from skumar.BSINGH_ITEM_MASTER);

select * from MA_ASOS.MA_ITEM_ATTRIBUTES where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_ITEM_AUTO_EAN where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_ITEM_FABRIC_COMP where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_ITEM_FABRIC_COMP_TEMP where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_ITEM_RESTRICTIONS where item in (select item from skumar.BSINGH_ITEM_MASTER);

select * from all_sequences where sequence_name like '%REST%' and SEQUENCE_OWNER like 'MA_ASOS';

select * from MA_ASOS.MA_ITEM_ZONES_PRICE where OPTION_ID in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_PH_RIL_TMP  where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_PRICE_CHANGE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_PRICE_CONFLICT_CHECK where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_RMS_ITEM_SEARCH_BASE_A where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_RMS_ITEM_SEARCH_BASE_B where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_RPM_PRICE_CHANGE_HIST where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_R_PRICES_A where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_R_PRICES_B where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_BARCODE where OPTION_ID in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_BUY_HIER_RECLASS where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_COMMODITY_CODES where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_COM_TEMP where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_HEAD where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_LOC_REPL_DAY where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_RANGE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_SIZE where OPTION_ID in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_SUP where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_UDA where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_ITEM_UDA_TEMP where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_NEW_BUY_HIER where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STG_PACK_ITEM where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_STYLES where PRIMARY_COLOUR_ID in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_UID_SEARCH_TMP where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from MA_ASOS.MA_UIL_SEARCH_TMP where item in (select item from skumar.BSINGH_ITEM_MASTER);


select * from all_tables where table_name like 'NB_ACTIVE_SKUS';

select * from INT_ASOS.INT_AUTO_CORRECTION_LOG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_AUTO_CORRECTION_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_EXT_DIFGRP_UPLD; 
select * from INT_ASOS.INT_FACET_EVENT_DNLD_STG;
select * from INT_ASOS.INT_ITEMLOC_LFC_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_GROUP_EVENT_DNLD_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_LOC_BUY_PRICE_EOD where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_LOC_PRICE_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_LOC_SOH_AU_A where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_LOC_SOH_AU_B where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_LOC_SOH_AU_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_LOC_SOH_AU_TMP  where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_ONQ_UDA where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_PIM_EVENT_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_PRICE_EST where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_REST_EVENT_DNLD_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_ITEM_REST_PUB_INFO where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_MA_FACTORY_SUPP_UPLD_STG ;
select * from INT_ASOS.INT_ORG_UNIT_VAT_REGION_XREF;
select * from INT_ASOS.INT_PE_CLEARANCE_STG where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_PE_CLEARANCE_STG_HIST where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_PE_CLR_CUST_ATTR_HIST where STAGE_CUST_ATTR_ID in (select STAGE_CUST_ATTR_ID from INT_ASOS.INT_PE_CLEARANCE_STG_HIST where item in (select item from skumar.BSINGH_ITEM_MASTER));
select * from INT_ASOS.INT_PE_CLR_CUST_ATTR_STG where STAGE_CUST_ATTR_ID in (select STAGE_CUST_ATTR_ID from INT_ASOS.INT_PE_CLEARANCE_STG_HIST where item in (select item from skumar.BSINGH_ITEM_MASTER));
select * from INT_ASOS.INT_PE_FILE_UPLD;
select * from INT_ASOS.INT_PE_ONL_UPLD;
select * from INT_ASOS.INT_PE_ONL_UPLD_HIST;
select * from INT_ASOS.INT_PE_PCCL_UPLD;
select * from INT_ASOS.INT_PE_PCCL_UPLD_HIST;
select * from INT_ASOS.INT_PE_PRICE_CHANGE_STG;
select * from INT_ASOS.INT_PE_PRICE_CHANGE_STG_HIST;
select * from INT_ASOS.INT_PE_PRICE_RECON;
select * from INT_ASOS.INT_PE_PRICE_RECON_HIST;
select * from INT_ASOS.INT_PE_PROMO_RECON;
select * from INT_ASOS.INT_PE_PROMO_RECON_HIST;
select * from INT_ASOS.INT_PE_PROM_DTL_CUST_ATTR_HIST;
select * from INT_ASOS.INT_PE_PROM_DTL_CUST_ATTR_STG;
select * from INT_ASOS.INT_PE_PROM_UPLD;
select * from INT_ASOS.INT_PE_PROM_UPLD_HIST;
select * from INT_ASOS.INT_PE_SIMPLE_PROMO_STG;
select * from INT_ASOS.INT_PE_SIMPLE_PROMO_STG_HIST;
select * from INT_ASOS.INT_PE_XREF_CLEARANCE;
select * from INT_ASOS.INT_PE_XREF_PRICE_CHANGE;
select * from INT_ASOS.INT_PE_XREF_PRICE_ZONE;
select * from INT_ASOS.INT_PE_XREF_PROMO;
select * from INT_ASOS.INT_PE_XREF_PROMO_DTL;
select * from INT_ASOS.INT_PL_ITEMLIST_UPLD_STG;
select * from INT_ASOS.INT_PL_SIZPROF_DETAIL_UPLD_STG;
select * from INT_ASOS.INT_PL_SIZPROF_HEAD_UPLD_STG;
select * from INT_ASOS.INT_PL_STYLE_XREF;
select * from INT_ASOS.INT_RMS_FACTORY_EXT_UPLD_STG;
select * from INT_ASOS.INT_RMS_PARTNER_UPLD_STG;
select * from INT_ASOS.INT_SALES_EXPORT_CONFIG;
select * from INT_ASOS.INT_SHR_XREF_COUNTRY_CODE;
select * from INT_ASOS.INT_TCKT_HIER_FILTER_TMP;
select * from INT_ASOS.INT_TCKT_ITEM_STAGE where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_TCKT_SUPP_XREF ;
select * from INT_ASOS.INT_TCKT_SUPS_STAGE;
select * from INT_ASOS.INT_VAT_ITEM  where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_WAC_SNAP_A where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_WAC_SNAP_B where item in (select item from skumar.BSINGH_ITEM_MASTER);
select * from INT_ASOS.INT_WAC_SNAP_DNLD where item in (select item from skumar.BSINGH_ITEM_MASTER);






CREATE TABLE ITEM_MASTER_TEMP AS (
  SELECT *
  FROM (
    SELECT item.ITEM, item.SUBCLASS, item.CLASS, item.DEPT,
      ROW_NUMBER() OVER (
        PARTITION BY item.DEPT, item.CLASS, item.SUBCLASS
        ORDER BY item.ITEM
      ) AS row_num
    FROM RMS.ITEM_MASTER item 
    WHERE ITEM_LEVEL = 1 AND STATUS = 'A'
  ) ranked_items
  WHERE ranked_items.row_num <= 5);

 
drop table datasubset_item;

CREATE TABLE datasubset_item AS (
  SELECT * FROM RMS.ITEM_MASTER 
  WHERE ITEM IN (SELECT item FROM ITEM_MASTER_TEMP)
);

 

INSERT INTO datasubset_item 
SELECT * FROM RMS.ITEM_MASTER WHERE ITEM_PARENT IN (SELECT item FROM ITEM_MASTER_TEMP);

 

INSERT INTO datasubset_item 
SELECT * FROM RMS.ITEM_MASTER WHERE ITEM_GRANDPARENT IN (SELECT item FROM ITEM_MASTER_TEMP);

 

DROP TABLE ITEM_MASTER_TEMP;

select * from skumar.datasubset_item;

select * from rpm_future_retail where item in (select item from skumar.datasubset_item);
select * from RPM_CLEARANCE where item in (select item from skumar.datasubset_item);
select * from RPM_CLEARANCE_RESET where item in (select item from skumar.datasubset_item);

select * from RPM_promo_dtl_merch_node where item in (select item from skumar.datasubset_item);

select * from RPM_price_change where item in (select item from skumar.datasubset_item);

create table datasubset_order as
select distinct order_no from ordloc where item in (select item from skumar.datasubset_item);

drop table datasubset_order;

select * from rms.datasubset_item;
select * from skumar.datasubset_order;

HVR 
DB_LINK

select * from rms.datasubset_item@BD_LINK (ASOS/Wholesale)

(subset)RMS - ASOS
(subset)RMS - Wholesale

select * from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023';
select * from rms.RPM_CLEARANCE_CUST_ATTR where CUST_ATTR_ID in (select CUST_ATTR_ID from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023');
select * from rms.RPM_CLEARANCE_reset where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023';
select * from rms.RPM_FUTURE_RETAIL where clearance_id in (select clearance_id from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023');
select * from rms.RPM_MERCH_LIST_DETAIL;  
select * from rms.RPM_MERCH_LIST_HEAD where PRICE_EVENT_ID not in (select clearance_id from rms.RPM_CLEARANCE where effective_date BETWEEN '01-MAR-2023' and '31-MAR-2023');
select * from rms.RPM_PROMO
select * from rms.RPM_PROMO_COMP
select * from rms.RPM_PROMO_DTL
select * from rms.RPM_PROMO_DTL_CUST_ATTR
select * from rms.RPM_PROMO_DTL_DISC_LADDER
select * from rms.RPM_PROMO_DTL_LIST
select * from rms.RPM_PROMO_DTL_LIST_GRP
select * from rms.RPM_PROMO_DTL_MERCH_NODE
select * from rms.RPM_PROMO_ITEM_LOC_EXPL
select * from rms.RPM_PROMO_ZONE_LOCATION

select * from MA_ASOS.MA_V_BUYERARCHY;

  
Select * from (  SELECT 
      bhr.ITEM, 
      BHR.BUSINESS_MODEL, 
      BHR.BUYING_GROUP, 
      BHR.BUYING_SUBGROUP, 
      BHR.BUYING_SET, 
      ROW_NUMBER() OVER (PARTITION BY BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP, BHR.BUYING_SET
   ORDER BY bhr.LAST_UPDATE_DATETIME desc) AS row_num 
    FROM MA_ASOS.MA_V_BUYERARCHY BHR
    WHERE bhr.ITEM_LEVEL = '1' AND STATUS = 'A') ranked_items  
    WHERe ranked_items.row_num <= '3';


with ranked_items as (
SELECT 
      im.ITEM, 
      im.DEPT, 
      im.CLASS, 
      BHR.BUSINESS_MODEL, 
      BHR.BUYING_GROUP, 
      BHR.BUYING_SUBGROUP, 
      BHR.BUYING_SET, 
      ROW_NUMBER() OVER (PARTITION BY im.DEPT, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP  
      ORDER BY im.LAST_UPDATE_DATETIME desc) AS row_num 
    FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, Item_master im
    WHERE im.ITEM_LEVEL = '1' and im.item = bhr.item AND STATUS = 'A')
    select * from  ranked_items   WHERe  row_num <= '1';

select * from MA_ASOS.MA_ITEM_ATTRIBUTES bhr where not exists (select 1 from rms.item_master im WHERE im.ITEM_LEVEL = '1' and im.item = bhr.item AND STATUS = 'A' );

select * from rms.item_master bhr where not exists (select 1 from MA_ASOS.MA_ITEM_ATTRIBUTES im WHERE im.item = bhr.item ) and bhr.ITEM_LEVEL = '1' AND bhr.STATUS = 'A' ;





drop table DATASUBSET_ITEM;
create table DATASUBSET_ITEM_OP as
with ranked_items as (
SELECT 
      im.ITEM, 
      im.DEPT, 
      im.CLASS, 
      BHR.BUSINESS_MODEL, 
      BHR.BUYING_GROUP, 
      BHR.BUYING_SUBGROUP, 
      BHR.BUYING_SET, 
      ROW_NUMBER() OVER (PARTITION BY im.DEPT, BHR.BUSINESS_MODEL, BHR.BUYING_GROUP, BHR.BUYING_SUBGROUP
      ORDER BY im.LAST_UPDATE_DATETIME desc) AS row_num 
    FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, rms.Item_master im
    WHERE im.ITEM_LEVEL = '1' and im.item = bhr.item AND STATUS = 'A')
    select * from  ranked_items   WHERe  row_num <= '2';

drop table DATASUBSET_ITEM;
create table DATASUBSET_ITEM as
select  im.ITEM, 
      im.DEPT, 
      
      
      
      im.CLASS, 
      BHR.BUSINESS_MODEL, 
      BHR.BUYING_GROUP, 
      BHR.BUYING_SUBGROUP, 
      BHR.BUYING_SET 
    FROM MA_ASOS.MA_ITEM_ATTRIBUTES BHR, rms.Item_master im
    WHERE im.item = bhr.item and (im.item in ( select item from skumar.DATASUBSET_ITEM_OP) or im.item_parent in ( select item from skumar.DATASUBSET_ITEM_OP) 
        or im.item_grandparent in ( select item from skumar.DATASUBSET_ITEM_OP));

Select item_level,count(1) from RMS.item_master where item in (Select item from RMS.DATASUBSET_ITEM) and STATUS!= 'C';


create table DATASUBSET_ORDER as 
Select order_no from RMS.ORDHEAD where Order_no in (select order_no from RMS.ordsku  where item in (Select item from RMS.DATASUBSET_ITEM)) and status != 'C' ;

create table DATASUBSET_ALLOC as 
Select alloc_no from RMS.ALLOC_HEADER where item in (Select item from RMS.DATASUBSET_ITEM) and STATUS!= 'C';

select * from DATASUBSET_ORDER;
select * from DATASUBSET_ALLOC;

GRANT SELECT,INSERT,UPDATE,DELETE ON DATASUBSET_ALLOC TO RMS; 
GRANT SELECT,INSERT,UPDATE,DELETE ON DATASUBSET_ORDER TO RMS; 
GRANT SELECT,INSERT,UPDATE,DELETE ON DATASUBSET_ITEM TO RMS; 




select MESSAGE_TYPE, count(1) from rms.ITEM_MFQUEUE group by MESSAGE_TYPE;

truncate table rms.ITEM_MFQUEUE;
select count(1) from rms.ITEM_MFQUEUE;

select * from rms.ITEM_pub_info where published!= 'Y';

select OWNER, TABLE_NAME,count(1) from all_indexes where owner in ('RMS','INT_ASOS','MA_ASOS') group by OWNER, TABLE_NAME order by 1,2;


select CREATION_DATE,CREATION_USER,STATUS, MASTER_ORDER_NO,count(1) from MA_ASOS.MA_PO_HISTORY group by CREATION_DATE, CREATION_USER,STATUS, MASTER_ORDER_NO having count(1) >1;

DELETE FROM MA_ASOS.MA_PO_HISTORY WHERE rowid not in (SELECT MIN(rowid) FROM MA_ASOS.MA_PO_HISTORY GROUP BY CREATION_DATE,CREATION_USER,STATUS, MASTER_ORDER_NO);

select * from ma_asos.MA_GROUP_HEADER;
delete from ma_asos.MA_GROUP_HEADER_temp;
select * from ma_asos.MA_ITEM_RESTRICTIONS;


MA_ASOS	MA_GROUP_DETAIL
MA_ASOS	MA_GROUP_HEADER
MA_ASOS	MA_PRICE_CHANGE
MA_ASOS	MA_PRICE_CONFLICT_CHECK
MA_ASOS	MA_STG_ORDER
RMS	NB_KEY_MAP_GL
RMS	NB_SHIPMENT_CFA_EXT
RMS	RPM_FUTURE_RETAIL
RMS	SHIPSKU
RMS	SUPS


select * from all_indexes where table_name like 'MA_ITEMSUP_PUB_INFO';






select * from dba_constraints where STATUS != 'ENABLED' and owner in ('RMS','INT_ASOS','MA_ASOS') and r_owner = 'RMS';
select owner, table_name, constraint_name, status from dba_constraints where r_owner='MA_ASOS' and status = 'DISABLED' order by 1,2,3;


Insert into ma_asos.NB_REFRESH_CONFIG (ID_SEQ,RESULT_SYNONYM,RESULT_TABLE_A,RESULT_TABLE_B,SOURCE_VIEW,PREPROCESS_PROCEDURE,AREA,THREADABLE,NUM_THREADS,THREADING_COL,THREADING_SQL,CREATE_ID,CREATE_DATETIME,LAST_UPDATE_ID,LAST_UPDATE_DATETIME) values (4,'MA_R_PRICES','MA_R_PRICES_A','MA_R_PRICES_B','MA_V_R_PRICES','MA_PREPARE_PH_TMP','MA_R_PRICES','Y',16,'LOC','SELECT STORE threading_column FROM ma_v_pricing_stores','MA_ASOS',to_date('08-NOV-22','DD-MON-RR'),'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'));
Insert into ma_asos.NB_REFRESH_CONFIG (ID_SEQ,RESULT_SYNONYM,RESULT_TABLE_A,RESULT_TABLE_B,SOURCE_VIEW,PREPROCESS_PROCEDURE,AREA,THREADABLE,NUM_THREADS,THREADING_COL,THREADING_SQL,CREATE_ID,CREATE_DATETIME,LAST_UPDATE_ID,LAST_UPDATE_DATETIME) values (5,'MA_RMS_ITEM_SEARCH_BASE','MA_RMS_ITEM_SEARCH_BASE_A','MA_RMS_ITEM_SEARCH_BASE_B','MA_V_R_RMS_ITEM_SEARCH_BASE_F','MA_PREPARE_UI_TMP','ITEM_SEARCH','N',null,null,null,'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'),'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'));
Insert into ma_asos.NB_REFRESH_CONFIG (ID_SEQ,RESULT_SYNONYM,RESULT_TABLE_A,RESULT_TABLE_B,SOURCE_VIEW,PREPROCESS_PROCEDURE,AREA,THREADABLE,NUM_THREADS,THREADING_COL,THREADING_SQL,CREATE_ID,CREATE_DATETIME,LAST_UPDATE_ID,LAST_UPDATE_DATETIME) values (6,'MA_PE_PRICE_CHANGE','MA_R_PE_PRICE_CHANGE_A',null,'MA_V_R_PE_PRICE_CHANGE',null,'PRICE_EVENT','N',null,null,null,'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'),'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'));
Insert into ma_asos.NB_REFRESH_CONFIG (ID_SEQ,RESULT_SYNONYM,RESULT_TABLE_A,RESULT_TABLE_B,SOURCE_VIEW,PREPROCESS_PROCEDURE,AREA,THREADABLE,NUM_THREADS,THREADING_COL,THREADING_SQL,CREATE_ID,CREATE_DATETIME,LAST_UPDATE_ID,LAST_UPDATE_DATETIME) values (7,'MA_PE_CLEARANCE','MA_R_PE_CLEARANCE_A',null,'MA_V_R_PE_CLEARANCE',null,'PRICE_EVENT','N',null,null,null,'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'),'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'));
Insert into ma_asos.NB_REFRESH_CONFIG (ID_SEQ,RESULT_SYNONYM,RESULT_TABLE_A,RESULT_TABLE_B,SOURCE_VIEW,PREPROCESS_PROCEDURE,AREA,THREADABLE,NUM_THREADS,THREADING_COL,THREADING_SQL,CREATE_ID,CREATE_DATETIME,LAST_UPDATE_ID,LAST_UPDATE_DATETIME) values (8,'MA_PE_PROMOTION','MA_R_PE_PROMOTION_A',null,'MA_V_R_PE_PROMOTION',null,'PRICE_EVENT','N',null,null,null,'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'),'MA_ASOS',to_date('08-NOV-22','DD-MON-RR'));


select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE_A;
select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE_B;
select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE;

exec dbms_mview.refresh('MV_CURRENCY_CONVERSION_RATES');
exec dbms_mview.refresh('MV_LOC_PRIM_ADDR');
exec dbms_mview.refresh('MV_LOC_SOB');
nb_refresh_result.ksh   $UP MA_RMS_ITEM_SEARCH_BASE &



select master_po_no,count(1) from rms.ordhead where status = 'A' group by master_po_no having count(1) > 50;


22628487
22627494
22855878
22736921
22717516
22671853
22566793
