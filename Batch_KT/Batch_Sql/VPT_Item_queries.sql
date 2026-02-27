delete from ma_asos.MA_COMMODITY_CODES where COMMODITY_CODE ='4202929190' and PRODUCT_TYPE ='236';
Item Queries :

---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Fetch --------------------------------------------------------------------------
select * from item_master where item_parent in ('101263723','101220928');
select * from item_loc where item in ('101263723','101220928');


-- Item Mainatain
select distinct im.item from rms.item_master im 
--inner join rms.v_item_master vim 
--on vim.item=im.item inner join ma_asos.ma_v_item mvim on mvim.item=im.item 
inner join (select item from rms.item_loc_cfa_ext group by item having min(date_21)>'30-APR-22') dt on dt.item=im.item
--inner join rms.item_loc l on l.item=im.item
where 
--vim.division=1 and mvim.business_model=1and 
im.status ='A' and im.item_level ='1' and im.CREATE_DATETIME>='05-FEB-20' and im.item_desc = 'Item creation Perf Test'
--and l.clear_ind='N'
--and im.LAST_UPDATE_ID <>'RMS' 
    and not exists (select 1 from rms.daily_purge mgd where mgd.KEY_VALUE=im.item);
   ORDER BY im.last_update_datetime desc;



-- Mass Maintain
select div.div_name,dpt.dept_name,cl.class_name,mm.dept,count 
from mass_maintab mm
inner join division div on div.division=mm.div
inner join deps dpt on dpt.dept=mm.dept
inner join class cl on cl.class=mm.class and mm.dept=cl.dept;
select * from division;
select * from DEPS;
select * from class;
select * from all_tables where table_name like '%CLA%';
select vim.division as div,items.dept as dept,items.class as class, count(1)as count from rms.item_master items
inner join rms.v_item_master vim on vim.item=items.item_parent
--inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
--where vim.division =1
group by items.dept,items.class,vim.division--,mvim.business_model
having count(1) between 80 and 150;  

select * from rms.v_item_master;
select * from ma_asos.ma_v_item ;
select * from r;
	

-- Maintain Reference
select im1.item from rms.item_master im1
left join rms.item_master im2 on im1.item=im2.item_grandparent
where im1.create_datetime>='22-MAY-19' and im1.item_desc ='Item creation Perf Test' 
and im1.item_level ='1' 
and im2.item is null-- and im1.brand_name ='ASOS'
order by im1.create_datetime asc;  -- Fetch Items

select distinct bar.item from 
   (select LPAD(item, 13, '0') as Item from SKUMAR.ITEM_EAN13 
   where to_char(ITEM) not in (select item from rms.item_master)) bar
   left join   ma_asos.ma_stg_item_barcode stg on stg.ref_item=bar.item
   where stg.ref_item is null; --barcodes
      
-- Maintan Grouping 
select group_id from MA_ASOS.MA_GROUP_HEADER where group_id>=11990 and rownum<2001; -- for group id
select im.item from rms.item_master im where im.status ='A' and im.item_level ='1' and tran_level ='2'
and brand_name ='ASOS' and
		not exists (select 1 from MA_ASOS.ma_group_detail mgd where mgd.item =im.item) order by 1 desc; -- for items
        
       SELECT IM.ITEM, CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION' WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM,
        IM.DEPT PRODUCT_GROUP,d.dept_name PRODUCT_GROUP_DESC,IM.CLASS "CATEGORY",c.class_name CATEGORY_NAME,
        IM.SUBCLASS SUB_CATEGORY, s.sub_name SUB_CATEGORY_NAME,IM.BRAND_NAME BRAND,
        IM.ITEM_DESC ITEM_DESCRIPTION,IM.SHORT_DESC SHORT_DESCRIPTION,
        IM.DIFF_1 COLOUR,IM.DIFF_2 SIZE_GROUP,UDA_ATTRIB.SUPER_STYLE,
               UDA_ATTRIB.STYLE,UDA_ATTRIB.BUSINESS_MODEL,UDA_ATTRIB.BUYING_GROUP,
               UDA_ATTRIB.BUYING_SUBGROUP,UDA_ATTRIB.BUYING_SET,ISUP.SUPPLIER SUPPLIER_ID,
               S.SUP_NAME SUPPLIERSITENAME,ISUP.VPN SUPPLIERREF,ISC.ORIGIN_COUNTRY_ID COUNTRYOFMANUFACTURE,
               ISC.UNIT_COST UNITCOST,ISC.MIN_ORDER_QTY MINORDERQUANTITY,ISC.MAX_ORDER_QTY MAXORDERQUANTITY,
               ISC.SUPP_PACK_SIZE STORE_ORDER_MUL,ISUP.SUPP_DIFF_1 "SUPPLIER COLOR",NUMBER_11 "UNITS_PER_CARTON"
          FROM rms.ITEM_MASTER IM,
               (SELECT ITEM,
                       MAX(CASE WHEN UDA_ID = 1002 THEN UDA_TEXT END) SUPER_STYLE,
                       MAX(CASE WHEN UDA_ID = 1003 THEN UDA_TEXT END) STYLE,
                       MAX(CASE WHEN UDA_ID = 2010 THEN UDA_TEXT END) BUSINESS_MODEL,
                       MAX(CASE WHEN UDA_ID = 2020 THEN UDA_TEXT END) BUYING_GROUP,
                       MAX(CASE WHEN UDA_ID = 2030 THEN UDA_TEXT END) BUYING_SUBGROUP,
                       MAX(CASE WHEN UDA_ID = 2040 THEN UDA_TEXT END) BUYING_SET
                 FROM (SELECT ITEM,UDA_ID,
                              UDA_TEXT 
                         FROM rms.UDA_ITEM_FF 
                        WHERE UDA_ID IN (2010,2020,2030,2040,1002,1003))
                     GROUP BY ITEM) UDA_ATTRIB,
                 rms.ITEM_SUPPLIER ISUP,
                 rms.SUPS S,
                 rms.ITEM_SUPP_COUNTRY ISC,
                 rms.ITEM_SUPP_COUNTRY_CFA_EXT ISCCE,
                 rms.deps d,
                 rms.class c,
                 rms.subclass s
          WHERE IM.ITEM = UDA_ATTRIB.ITEM
            and im.dept=d.dept
            and im.class=c.class
            and d.dept=c.dept
            and im.subclass=s.subclass
            and d.dept =s.dept
            and c.class=s.class
            AND IM.INVENTORY_IND = 'Y'
            AND ISUP.ITEM = IM.ITEM
            AND ISUP.SUPPLIER = S.SUPPLIER
            AND ISUP.ITEM = ISC.ITEM
            AND ISUP.SUPPLIER = ISC.SUPPLIER
            AND ISCCE.GROUP_ID = '120100'
            AND ISCCE.ITEM = ISC.ITEM
            AND ISCCE.SUPPLIER = ISC.SUPPLIER
            AND ISCCE.ORIGIN_COUNTRY_ID = ISC.ORIGIN_COUNTRY_ID
            and IM.ITEM_LEVEL = 1 and d.dept=1051;
            AND (IM.ITEM > ( '100007560')
                 OR IM.ITEM_PARENT > ( '100007560'));
        ORDER BY TYPE_OF_ITEM;

--Item Gold/Blind Gold Seal:
select distinct im.item_parent from --rms.ordloc ol 
--inner join 
rms.item_master im --on ol.item=im.item
where 
im.CREATE_DATETIME>='28-APR-2022' and im.Item_DESC='Item creation Perf Test' and--and im.LAST_UPDATE_ID <>'RMS'
not exists (select null from rms.uda_item_lov uil where uda_id = '4001' and item =im.item and UDA_VALUE in('1','2'));
and exists (select item,count(1) from MA_ASOS.MA_ITEM_FABRIC_COMP fab where fab.item=im.item_parent group by item having count(1)=1)
order by im.item_parent;

---Bulk Blind gold seal
select * from rms.skulist_head where sKULIST_DESC like '%BulkGoldSeal%';
select skulist_Desc from skulist_head where SKULIST_DESC like 'BulkGoldSeal%';


-- Item UnGold Seal
select item from rms.item_master im
    where im.item_level ='1' and im.status ='A'  and im.Item_DESC='Item creation Perf Test'
    and exists (select 1 from rms.uda_item_lov uil where uda_id = '4001' and uda_value!='3' and im.item=uil.item)
     and not exists (select null from rms.uda_item_lov uil where uda_id = '4001' and item =im.item and UDA_VALUE ='3')
     and exists (select item,count(1) from MA_ASOS.MA_ITEM_FABRIC_COMP fab where fab.item=im.item group by item having count(1)=1)
     and not exists (select null from rms.shipsku
    where item in (select item from rms.item_master im1 where (im1.item_parent=im.item or im1.item=im.item)));




--item induction
select im1.item from rms.item_master im1 where item_level=1 and short_desc like '%UploadTest%'
and create_datetime>='30-NOV-20' and item_parent is null
and not exists (
select null from rms.item_master im2 where short_desc like '%UploadTest%'
and create_datetime>='30-NOV-20' and item_parent is not null and im2.item_parent=im1.item);

select im1.item from rms.item_master im1 where item_level=1 and short_desc like '%UploadForPO%'
and create_datetime>='30-NOV-20' and item_parent is null
and not exists (
select null from rms.item_master im2 where short_desc like '%UploadForPO%'
and create_datetime>='30-NOV-20' and item_parent is not null and im2.item_parent=im1.item);

select distinct short_desc from item_master where create_datetime>='16-AUG-22'; short_desc like '%UploadForPO%';


select * from rms.item_master im1 where 
item_level=1 and 
item_desc like '%UploadTest%'
and create_datetime>='25-JUL-22' order by create_datetime desc; and item_parent is null
and not exists (
  
  
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------
---------------------------------------------------------------------------------------- Validate --------------------------------------------------------------------------



-- Item Creation
--create table PFItem as
select  *  from rms.item_master where status ='A' and item_level ='1' and 
CREATE_DATETIME>=to_date('21-May-2025 12:00', 'DD-MON-YYYY hh24:mi')and --Item_DESC like '%Item create PF 4K 7JUL2022%';
Item_DESC='Item creation Perf Test'; and item ='118702285';
select count(*) from rms.item_master where status ='A' and item_level ='1' and CREATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi')
and Item_DESC='Item creation Perf Test';;

select * from rms.item_master where ITEM_PARENT='133916151';

select count(*) from rms.item_master where status ='A' 
and item_level ='1' --and Item_DESC='Item creation Perf Test'
and CREATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi');
346,645,

-- Item Maintain
select * from rms.item_master where status ='A' and item_level ='1' and LAST_UPDATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi')
and item_desc ='Item creation Perf Test Edit'
order by LAST_UPDATE_DATETIME desc;
select count(*) from rms.item_master where status ='A' and item_level ='1' and LAST_UPDATE_DATETIME>='06-APR-20' order by LAST_UPDATE_DATETIME desc;
31,91

-- Mass Maintenance
select * from rms.item_master where status ='A' and item_level ='1' and ITEM_DESC like '%Perf Testing%OCT%' 
and LAST_UPDATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi');
4,92

-- Maintain reference
select * from rms.item_master where item in ('2200000984197','2200000877291','2200001014374','2200000955111','2200000971401') and LAST_UPDATE_DATETIME>='14-JAN-19'; and ITEM_GRANDPARENT ='';
select count(*) from rms.item_master where item_number_type like '%EAN13%' 
and LAST_UPDATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi'); order by LAST_UPDATE_DATETIME desc; 
185,237

-- Maintain Grouping:
select unique group_id from MA_ASOS.ma_group_detail where LAST_UPDATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi'); 
select * from MA_ASOS.ma_group_detail where LAST_UPDATE_DATETIME>='06-APR-20'; 
10,27

-- Item Reclassify:
select count(*) from ma_asos.MA_STG_ITEM_BUY_HIER_RECLASS where LAST_UPDATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi') order by last_update_datetime desc;
75,130

-- Item Gold Seal
select uil.item from rms.uda_item_lov uil 
inner join rms.item_master im on uil.item=im.item
where uda_id = '4001' and im.item_level=1 
and ITEM_DESC ='Item creation Perf Test' 
and uil.create_datetime>=to_date('23-JUN-2020 02:00', 'DD-MON-YYYY hh24:mi')
 and UDA_VALUE ='2'; -- gold

 select * from rms.uda_item_lov where item=123268371;
-- Item Blind Gold Seal
select * from rms.uda_item_lov uil 
inner join rms.item_master im on uil.item=im.item
where uda_id = '4001' and im.item_level=1 and im.Item_DESC='Item creation Perf Test' 
and uil.create_datetime>=to_date('23-JUN-2021 02:00', 'DD-MON-YYYY hh24:mi') and UDA_VALUE ='1'; -- blind gold seal
965,674


-- Item Bulk Blind Gold Seal
select distinct process_seq from ma_asos.ma_item_mass_mnt_process 
where create_datetime >=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi');
298,797

-- Item UnGold
select uil.* from rms.uda_item_lov uil 
inner join rms.item_master im on uil.item=im.item
where uda_id = '4001' and im.item_level=1 
and uil.create_datetime>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi') and UDA_VALUE ='3' ; 
select uil.* from rms.uda_item_lov uil;

--Item Upload
select * from rms.item_master where status ='A' 
and item_level ='1' 
--and upper(Item_DESC) like '%UPLOAD%'-- and item_desc <>'UploadTest7Sku'
and CREATE_DATETIME>=to_date('06-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi');
15,38

--Item induction
select * from rms.item_master where status ='A'  and item_desc ='UploadTest7Sku'
and CREATE_DATETIME>=to_date('23-JUN-2022 02:00', 'DD-MON-YYYY hh24:mi');


select  vim.item,vim.division,mvim.business_model,mvim.dept,count(im.item)  from item_master im
inner join rms.v_item_master vim on vim.item=im.item
inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
where
im.item_level=1
group by vim.item,vim.division,mvim.business_model,mvim.dept;

select  im.item from item_master im
inner join rms.v_item_master vim on vim.item=im.item
inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
where
im.item_level=1 and vim.division='2' and mvim.business_model='6' and mvim.dept='2054';




