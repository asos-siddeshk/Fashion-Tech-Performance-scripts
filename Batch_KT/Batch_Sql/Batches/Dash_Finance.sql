

 SELECT * FROM fin_asos.FIN_REFRESH_CONFIG where RESULT_SYNONYM like 'FIN_MV_LATE_TRANSACTIONS';

select * from FIN_ASOS.FIN_MV_LATE_TRANSACTIONS;
select * from FIN_ASOS.FIN_R_LATE_TRANSACTIONS_B;
select * from FIN_ASOS.FIN_R_LATE_TRANSACTIONS_A;
select * from FIN_ASOS.FIN_V_LATE_TRANSACTIONS;
select * from FIN_ASOS.period;

select * from FIN_ASOS.code_detail where code_type  = 'GLRT';

select * from all_synonyms where upper(SYNONYM_NAME) like 'FIN_MV_LATE_TRANSACTIONS';    
select * from all_views where upper(view_name) like 'fin_v_prod_hier'; 
select TEXT from all_views where upper(view_name) like 'FIN_V_NEW_VAT_ITEM'; 
select * from all_tables where table_name like 'TRAN%';



select * from das.tran_data_history;


SELECT * FROM fin_asos.FIN_REFRESH_CONFIG where RESULT_SYNONYM like 'FIN_MV_NEW_VAT_ITEM';

select * from FIN_ASOS.FIN_MV_NEW_VAT_ITEM;
select * from FIN_ASOS.FIN_R_NEW_VAT_ITEM_A;
select * from FIN_ASOS.FIN_R_NEW_VAT_ITEM_B;
select * from FIN_ASOS.FIN_V_NEW_VAT_ITEM;
select * from FIN_ASOS.period;
select TEXT from all_views where upper(view_name) like 'FIN_V_NEW_VAT_ITEM'; 



select * from FIN_ASOS.FIN_SYSTEM_PARAMETERS  fsp1


SELECT fph.div_name           division,
       fph.dept_name          prod_group,
       fph.class_name         category,
       fph.sub_name           sub_category,
       iem.item_parent        option_id,
       iem.item               sku,
       iem.item_desc          description,
       s.supplier             supplier,
       s.sup_name             supplier_name,
       isc.origin_country_id  origin_country_id,
       vtc.vat_code_desc      vat_code,
       vti.vat_rate           vat_rate,
       vtr.vat_region_name    vat_region,
       vti.active_date        active_date,
       iem.create_datetime    create_date
  FROM dash_asos.ITEM_MASTER            iem,
       FIN_ASOS.FIN_V_PROD_HIER        fph,
       dash_asos.VAT_ITEM               vti,
       dash_asos.VAT_REGION             vtr,
       dash_asos.VAT_CODES              vtc,
       dash_asos.ITEM_SUPP_COUNTRY      isc,
       dash_asos.SUPS                   s,
       FIN_ASOS.FIN_SYSTEM_PARAMETERS  fsp1
 WHERE iem.item_level             = iem.tran_level
   AND iem.dept                   = fph.dept
   AND iem.class                  = fph.class
   AND iem.subclass               = fph.subclass
   AND vti.item                   = iem.item
   AND fsp1.func_area             = 'SKU_VAT_RATE'
   AND fsp1.parameter             = 'NEW_ITEM_PERIOD'
   AND trunc(iem.create_datetime) >= to_date(sysdate-229) - to_number(fsp1.value_1)
   AND vti.vat_code               = vtc.vat_code
   AND vti.vat_region             = vtr.vat_region
   AND vtr.vat_region_name        NOT IN ((SELECT value_1
                                             FROM FIN_ASOS.FIN_SYSTEM_PARAMETERS
                                            WHERE func_area = 'SKU_VAT_RATE'
                                              AND parameter = 'IGNORE_REGIONS'))
   AND iem.item                   = isc.item
   AND isc.supplier               = s.supplier
   AND isc.primary_supp_ind       = 'Y'
   AND isc.primary_country_ind    = 'Y';