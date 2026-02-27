exec system.killsession ('2494');
select *  from   v$sql  where  sql_id = '7tjzwykh2t07p';

select count(1) from rms.rpm_stage_item_loc;
select count(1) from rms.rpm_stage_item_loc_clean;

select * from RPM_NIL_ROLLUP_THREAD;

---reclsdly---
select * from  rms.RECLASS_HEAD;--94 records with vdate as 1 oct
select * from  rms.RECLASS_item;--45k
--------------------------------------
--ordrev--
select count(1) from rms.ordhead_rev;--173052
select count(1) from rms.ordsku_rev;--983399
select count(1) from rms.ordloc_rev;--983399

---repl-----
--rilmaint--
select count(1) from RMS.REPL_ITEM_LOC_UPDATES;--24
select count(1) from rms.repl_item_loc;--2249

---sitmain-----
select count(1) from RMS.SIT_HEAD;--14094
select * from RMS.SIT_DETAIL;--14094
select * from RMS.SIT_EXPLODE;--4760476

select STATUS_UPDATE_DATE,count(STATUS_UPDATE_DATE) from RMS.SIT_DETAIL group by STATUS_UPDATE_DATE;
02-OCT-18               3525
30-SEP-18               1850
16-SEP-18               5422
01-OCT-18               3297

---nb_dlyprg---
  select * from ma_asos.ma_stg_item_head ;--3386
  select * from         ma_asos.ma_stg_item_size;--3142
  select * from         ma_asos.ma_stg_item_barcode; --3033

select * from ma_asos.ma_stg_item_head where LAST_UPDATE_DATETIME<='23-SEP-18';--total:3770-3330-last_update_datetime as vdate-7
select * from ma_asos.ma_stg_item_size where LAST_UPDATE_DATETIME<='23-SEP-18';--3313(total)
select * from ma_asos.ma_stg_item_barcode where LAST_UPDATE_DATETIME<='23-SEP-18' ;--3142(total)  
  
---nb_inactive_styles----
I               4046
A              659478
select status,count(status) from ma_asos.ma_styles group by status;

 
--nb_prg_pricing----
select count(1) from  ma_asos.ma_price_change;--155146--effective_date-vdate-7-100 records

-----nb_buyrarchy_reclass----
select * from ma_asos.ma_stg_item_buy_hier_reclass where process_status='N' and effective_date='01-OCT-18';--255

--nb_man_tsf_upload:
select count(1) from INT_ASOS.int_stg_man_tsf_upld;                       --7110                     
select * from INT_ASOS.int_stg_man_tsf_upld where status='S' and create_datetime='23-SEP-18' and process_datetime='23-SEP-18';--1000

--nb_sizeprof_upld---
int_asos.int_pl_sizprof_head_upld_stg
int_asos.int_pl_sizprof_head_upld_stg

select count(1) from int_asos.int_pl_sizprof_head_upld_stg where status='U';--60
select count(1) from int_asos.int_pl_sizprof_detail_upld_stg where status='U';--60
select count(1) from int_asos.int_pl_sizprof_head_upld_stg where status='P';--434
select count(1) from int_asos.int_pl_sizprof_detail_upld_stg where status='P';--434

---nb_itemlist_upload----
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where status='U';--3k
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG;--older records present¬2l

--nb_partner_upload----
select count(1) from RMS.PARTNER;--365
select count(1) from RMS.ADDR;--43204
select count(1) from  RMS.PARTNER_CFA_EXT;--686
select * from int_asos.INT_RMS_PARTNER_UPLD_STG ;--755(655 U+100P)

---nb_export_item_restrictions---
select count(1)  from int_asos.INT_ITEM_REST_EVENT_DNLD_STG;--130k records present

------rplatupd----------
select count(1) from rms.REPL_ATTR_UPDATE_HEAD ;--246400
select count(1) from rms.REPL_ATTR_UPDATE_item;--246400
select count(1) from rms.REPL_ATTR_UPDATE_loc;--246400
select count(1) from rms.repl_item_loc;--2945
select count(1) from rms.repl_results;--10065

---deals-----
select count(1) from  rms.DEAL_HEAD;--263--including older deals

---ma_item_rules_expl-----
select count(1) from ma_asos.ma_ship_rest_rule_mfqueue;--1851

----nb_export_item_groupings_purge-----
select count(1) from int_asos.INT_ITEM_GROUP_EVENT_DNLD_STG;--101184

------nb_orphans----------
updated the SOH as '-1' for 150k items in rms.item_loc_soh table for loc 1001 and vdate as 30 sept

----vatdlxpl----
select * from rms.vat_code_rates;--390
ATGS       01-OCT-18               23            17-OCT-18               PTUSER
ATGS       30-SEP-18               21            15-OCT-18               PTUSER

----rplathistprg-----
select count(1) from  rms.REPL_ATTR_UPD_HIST ;--122024
update rms.REPL_ATTR_UPD_HIST set activate_date=(select add_months(rms.period.vdate,-12) from rms.period) where rownum<=50000 ;--50k records backdated to retention week for rplathistprg batch to process the records


