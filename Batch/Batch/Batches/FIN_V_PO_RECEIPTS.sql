select * from all_views where view_name like 'FIN_V_PO_RECEIPTS';
--NB_FIN_GL_PO_REFRESH

select * from FIN_ASOS.FIN_V_PO_RECEIPTS;

select * from FIN_ASOS.FIN_V_PO_RECEIPTS 
    where item in ('117763405','115895965','119594383','119594386','114957178','114266714','114266715','114266712','114266713','114266713','117730662','117730649','117730655','117730652','119594382','11519112 ','114939124','114957085','114957085','114957083','114957087','114957086','115077904');

select * from fin_asos.FIN_SYSTEM_PARAMETERS
    where func_area    = 'PO_RECEIPTS'
    AND parameter    = 'DAYS_TO_FETCH';

update fin_asos.FIN_SYSTEM_PARAMETERS set value_1 ='365'
    where func_area    = 'PO_RECEIPTS'
    AND parameter    = 'DAYS_TO_FETCH';

select * from dash_asos.ITEM_MASTER;

select * from dash_asos.uda_item_lov where uda_id = '105' AND uda_value = '3';

SELECT tdh.tran_date                      tran_date,
       tdh.post_date                      post_date,
       tdh.item                           item,
       im.item_desc                       item_desc,
       tdh.units                          units,
       olc.unit_cost                      unit_cost,
       ohe.currency_code                  currency_code,
       tdh.location                       location,
       ohe.supplier                       supplier,
       s.sup_name                         supplier_name,
       tdh.ref_no_1                       order_no,
       shp.asn                            asn,
       mia.buying_group                   buying_group,
       mbg.buying_group_name              buying_group_name,
       im.dept                            prod_grp,
       d.dept_name                        prod_grp_name,
       shp.receive_date                   first_receipt_date,
       tdh.item || '-' || im.item_parent  external_item_number,
       wh.channel_id
  FROM dash_asos.TRAN_DATA_HISTORY tdh,
       fin_asos.FIN_SYSTEM_PARAMETERS fdp,
       dash_asos.ITEM_MASTER im,
       dash_asos.DEPS d,
       dash_asos.MA_ITEM_ATTRIBUTES mia,
       dash_asos.MA_BUYING_GROUP mbg,
       dash_asos.ORDLOC olc,
       dash_asos.ORDHEAD ohe,
       dash_asos.SUPS s,
       dash_asos.SHIPMENT shp,
       dash_asos.WH
 WHERE tdh.tran_code    = '20'
   AND tdh.post_date    >= TRUNC(sysdate) - to_number('365')
   AND fdp.func_area    = 'PO_RECEIPTS'
   AND fdp.parameter    = 'DAYS_TO_FETCH'
   AND tdh.item         = im.item
   AND im.dept          = d.dept
   AND im.item          = mia.item
   AND mia.buying_group = mbg.buying_group
   AND tdh.ref_no_1     = olc.order_no
   AND im.item          = olc.item
   AND tdh.location     = olc.location
   AND olc.order_no     = ohe.order_no
   AND ohe.supplier     = s.supplier
   AND tdh.ref_no_2     = shp.shipment(+)
   AND wh.wh            = tdh.location
   AND im.item          NOT IN (SELECT item
                                  FROM dash_asos.UDA_ITEM_LOV
                                 WHERE uda_id    = '105'
                                   AND uda_value = '3');