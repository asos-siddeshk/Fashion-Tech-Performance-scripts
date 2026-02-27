select * from item_master where item in ('134889565','134889566');


select * from all_synonyms where synonym_name like 'MA_RMS_ITEM_SEARCH_BASE';

select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE_A where item in ('134889565','134889566');
select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE_B where item in ('134889565','134889566');

select * from ma_asos.NB_REFRESH_CONFIG;
--NB_REFRESH_PROCESS_SQL.PROCESS
select * from ma_asos.MA_V_R_RMS_ITEM_SEARCH_BASE_F where item in ('134889565','134889566');
select * from ma_asos.MA_V_R_RMS_ITEM_SEARCH_BASE_F where item in ('134889565','134889566');
select * from ma_asos.MA_ITEM_ATTRIBUTES where item in ('134889565','134889566');
select * from ma_asos.ma_v_gold_seal_search where item in ('134889565','134889566');

MA_ITEM_ATTRIBUTES

     v_cfa_itm_pl_cre_g icfa,
       ma_v_gold_seal_search gs
select * from all_views where view_name like 'MA_V_R_RMS_ITEM_SEARCH_BASE_F';
select * from 


   SELECT TO_CHAR((period.vdate + 1), 'YYYYMMDD') INTO L_vdate
           FROM period;

            6	100000	10000
    select * from rms.doc_purge_queue;
   select min (CREATE_DATE) from rms.tsfhead; -- 31-AUG-20
   SELECT * FROM rms.nb_system_parameters WHERE func_area = 'MOM_MAINT';


select * from ordhead where order_no in (500031602468);
500031602469
500031602472
500031602473
500031602462
500031602463


SELECT /*+ ORDERED */
       'RMS' as item_source,
       IM.ITEM,
       IM.ITEM_NUMBER_TYPE,
       IM.FORMAT_ID,
       IM.PREFIX,
       IM.ITEM_PARENT,
       IM.ITEM_GRANDPARENT,
       IM.PACK_IND,
       IM.ITEM_LEVEL,
       IM.TRAN_LEVEL,
       IM.ITEM_AGGREGATE_IND,
       IM.DIFF_1 colour,
       IM.DIFF_1_AGGREGATE_IND,
       IM.DIFF_2 "SIZE",
       IM.DIFF_2_AGGREGATE_IND,
       IM.DIFF_3,
       IM.DIFF_3_AGGREGATE_IND,
       IM.DIFF_4,
       IM.DIFF_4_AGGREGATE_IND,
       NB_GET_DIVISION(im.dept) DIVISION,
       IM.DEPT,
       IM.CLASS,
       LPAD(TO_CHAR(IM.DEPT), 4, '0') || LPAD(TO_CHAR(IM.CLASS), 4, '0') CATEGORY_KEY,
       IM.SUBCLASS,
       LPAD(TO_CHAR(IM.DEPT), 4, '0') || LPAD(TO_CHAR(IM.CLASS), 4, '0') || LPAD(TO_CHAR(IM.SUBCLASS), 4, '0') SUB_CATEGORY_KEY,
       IM.STATUS,
       IM.ITEM_DESC item_description,
       IM.ITEM_DESC_SECONDARY,
       IM.SHORT_DESC item_short_description,
       IM.DESC_UP,
       IM.PRIMARY_REF_ITEM_IND,
       IM.COST_ZONE_GROUP_ID,
       IM.STANDARD_UOM,
       IM.UOM_CONV_FACTOR,
       IM.PACKAGE_SIZE,
       IM.PACKAGE_UOM,
       IM.MERCHANDISE_IND,
       IM.STORE_ORD_MULT,
       IM.FORECAST_IND,
       IM.ORIGINAL_RETAIL,
       IM.MFG_REC_RETAIL,
       IM.RETAIL_LABEL_TYPE,
       IM.RETAIL_LABEL_VALUE,
       IM.HANDLING_TEMP,
       IM.HANDLING_SENSITIVITY,
       IM.CATCH_WEIGHT_IND,
       IM.WASTE_TYPE,
       IM.WASTE_PCT,
       IM.DEFAULT_WASTE_PCT,
       IM.CONST_DIMEN_IND,
       IM.SIMPLE_PACK_IND,
       IM.CONTAINS_INNER_IND,
       IM.SELLABLE_IND,
       IM.ORDERABLE_IND,
       IM.PACK_TYPE,
       IM.ORDER_AS_TYPE,
       IM.COMMENTS,
       IM.ITEM_SERVICE_LEVEL,
       IM.GIFT_WRAP_IND,
       IM.SHIP_ALONE_IND,
       IM.CHECK_UDA_IND,
       IM.ITEM_XFORM_IND,
       IM.INVENTORY_IND,
       IM.ORDER_TYPE,
       IM.SALE_TYPE,
       IM.DEPOSIT_ITEM_TYPE,
       IM.CONTAINER_ITEM,
       IM.DEPOSIT_IN_PRICE_PER_UOM,
       IM.AIP_CASE_TYPE,
       IM.CATCH_WEIGHT_TYPE,
       IM.PERISHABLE_IND,
       IM.SOH_INQUIRY_AT_PACK_IND,
       IM.NOTIONAL_PACK_IND,
       IM.CATCH_WEIGHT_UOM,
       IM.PRODUCT_CLASSIFICATION,
       IM.BRAND_NAME,
       IM.ALC_ITEM_TYPE,
       IM.CURR_SELLING_UNIT_RETAIL,
       IM.CURR_SELLING_UOM,
       MIA.BUSINESS_MODEL,
       MIA.BUYING_GROUP,
       LPAD(MIA.BUSINESS_MODEL, 4, '0') || LPAD(MIA.BUYING_GROUP, 4, '0') BUYING_GROUP_KEY,
       MIA.BUYING_SUBGROUP,
       LPAD(MIA.BUSINESS_MODEL, 4, '0') || LPAD(MIA.BUYING_GROUP, 4, '0') || LPAD(MIA.BUYING_SUBGROUP, 4, '0') BUYING_SUBGROUP_KEY,
       MIA.BUYING_SET,
       LPAD(MIA.BUSINESS_MODEL, 4, '0') || LPAD(MIA.BUYING_GROUP, 4, '0') || LPAD(MIA.BUYING_SUBGROUP, 4, '0') || LPAD(MIA.BUYING_SET, 4, '0') BUYING_SET_KEY,
       decode(im.item_level, 1, im.diff_2, 2, i2.diff_2) size_group,
       isup.supplier supplier,
       isup.vpn supplier_reference,
       isup.supp_diff_1 supplier_colour,
       icfa.colour_group_id colour_group,
       icfa.place_of_creation,
       gs.gold_seal,
       gs.gold_seal_desc,
       gs.gold_seal_date,
       mia.style,
       mia.super_style,
       nvl(unfinished_product.uda_value, 0) unfinished_product,
       nvl(price_establishment.uda_value, 0) price_establishment,
       pim_product_type.uda_value as pim_product_type,
       im.create_datetime,
       im.create_id,
       im.last_update_datetime,
       im.last_update_id,
       (select cl.diff_group_desc
          from diff_group_head cl
         where cl.diff_group_id = icfa.colour_group_id) as colour_group_desc,
       (select dif.diff_desc
          from diff_ids dif
         where dif.diff_id = IM.DIFF_1) as colour_desc,
       (select difg.diff_group_desc
          from diff_group_head difg
         where difg.diff_group_id = decode(im.item_level, 1, im.diff_2,
                                    2, i2.diff_2)) as size_group_desc,
       (select difsize.diff_desc
          from diff_ids difsize
         where difsize.diff_id =IM.DIFF_2) as size_desc,
       (select dept_name from deps where dept = im.dept ) product_group_desc,
       (select div_name from division where division = NB_GET_DIVISION(im.dept)) division_desc,
       (select class_name from class where dept = im.dept and class = im.class) category_desc,
       (select sub_name from subclass where dept = im.dept and class = im.class and subclass = im.subclass) sub_category_desc,
       (select cd.code_desc
          from code_detail cd
         where cd.code_type = 'ITPC'
           and cd.code      = icfa.place_of_creation) as place_of_creation_desc,
       (select uv.uda_value_desc
          from uda_values uv
         where uv.uda_value = pim_product_type.uda_value
           and uv.uda_id    = (select uda_id
                                 from ma_uda_conf
                                where uda_type = 'PIM_PRODUCT_TYPE')) as pim_product_type_desc,
       (select cd.code_desc
          from code_detail cd
         where cd.code_type = 'MAIS'
           and cd.code      = im.status) status_desc,
       (select st.style_desc
          from ma_styles st
         where st.style = mia.style) style_desc,
       (select sst.super_style_desc
          from ma_superstyles sst
         where sst.super_style = mia.super_style
           and sst.division    = NB_GET_DIVISION(im.dept)) as super_style_desc,
       (select b.brand_description
          from brand b
         where b.brand_name = im.brand_name) as brand_desc,
        (select bm.business_model_name
          from ma_business_model bm
         where bm.business_model = mia.business_model) as business_model_name,
       (select bg.buying_group_name
          from ma_buying_group bg
         where bg.buying_group = mia.buying_group) as buying_group_name,
       (select bsg.buying_subgroup_name
          from ma_buying_subgroup bsg
         where bsg.buying_group    = mia.buying_group
           and bsg.buying_subgroup = mia.buying_subgroup) as buying_subgroup_name,
       (select bs.buying_set_name
          from ma_buying_set bs
         where bs.buying_group    = mia.buying_group
           and bs.buying_subgroup = mia.buying_subgroup
           and bs.buying_set      = mia.buying_set) as buying_set_name,
       auto_ean.uda_value as auto_ean,
       case
         when im.item_level < im.tran_level then
           isup.supplier
           || '|' ||
           regexp_replace(upper(isup.vpn), ' |[^A-Za0-9]+', '')
           || '|' ||
           (select isc.origin_country_id
              from item_supp_country isc
             where isc.item                = im.item
               and isc.supplier            = isup.supplier
               and isc.primary_country_ind = 'Y')
           || '|' ||
           icfa.colour_group_id
           || '|' ||
           LPAD(MIA.BUSINESS_MODEL, 4, '0') || LPAD(MIA.BUYING_GROUP, 4, '0') || LPAD(MIA.BUYING_SUBGROUP, 4, '0') || LPAD(MIA.BUYING_SET, 4, '0')
         else
           null
       end as duplication_key -- supplier|vpn|origin_country_id|colour_group_id|buying_set_key
  FROM ITEM_MASTER        IM,
       item_supplier isup,
       MA_ITEM_ATTRIBUTES MIA,
       ITEM_MASTER        I2,
       v_cfa_itm_pl_cre_g icfa,
       ma_v_gold_seal_search gs,
       (select item, uda_value
                      from MA_UIL_SEARCH_TMP
                     where uda_id = (select uda_id
                                       from ma_uda_conf
                                      where uda_type = 'UNFINISHED_PRODUCT')) unfinished_product,
        (select item, uda_value
                     from MA_UIL_SEARCH_TMP where uda_id = (select uda_id
                                       from ma_uda_conf
                                      where uda_type = 'PRICE_ESTABLISHMENT')) price_establishment,
        (select item, uda_value
                  from MA_UIL_SEARCH_TMP
                 where uda_id = (select uda_id
                                   from ma_uda_conf
                                  where uda_type = 'PIM_PRODUCT_TYPE')) pim_product_type,
        (select item,
                uda_value
           from uda_item_lov
          where uda_id = (select uda_id
                            from ma_uda_conf
                           where uda_type = 'AUTO_EAN')) auto_ean
  WHERE IM.ITEM                 = MIA.ITEM
    AND im.item_parent          = i2.item(+)
    and im.item                 = isup.item
    and isup.primary_supp_ind   = 'Y'
    and im.item_level          <= im.tran_level
    and im.item                 = icfa.item(+)
    and im.item                 = gs.item(+)
    and im.status               = 'A'
    and im.item                 = unfinished_product.item(+)
    and im.item                 = price_establishment.item(+)
    and im.item                 = pim_product_type.item(+)
    and im.item                 = auto_ean.item(+)"