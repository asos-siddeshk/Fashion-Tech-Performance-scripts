exec system.killsession ('4293');
exec system.killsession ('4805');
exec system.killsession ('4195');
exec system.killsession ('4902');
exec system.killsession ('4396');
exec system.killsession ('4492');
exec system.killsession ('4600');
exec system.killsession ('4700');

select ITEM, count(1) from int_asos.NB_STOCK_BUCKETS_EOD where loc = '3001' group by ITEM having count(1) >2;

select count(1) from int_asos.INT_ITEM_LOC_BUY_PRICE_EOD;
select * from int_asos.NB_STOCK_BUCKETS_EOD where loc = '3001';

SELECT * FROM int_asos.INT_ITEM_LOC_BUY_PRICE_EOD where loc = '3001'; 
        
SELECT * FROM int_asos.INT_ITEM_LOC_BUY_PRICE_EOD where item = '101549516';

   INSERT INTO int_asos.INT_ITEM_LOC_BUY_PRICE_EOD
     (ITEM,
      LOC,
      LOC_TYPE,
      BUY_UNIT_RETAIL)
   SELECT /*+ FULL(IL) */
          UI.ITEM,
          '3001',
          'W',
          nvl(NIL.CURRENT_SELLING_RETAIL, IL.REGULAR_UNIT_RETAIL)
     FROM int_asos.ITEM_LOC IL,
          int_asos.INT_ITEM_PRICE_EST UI,
          int_asos.ITEM_MASTER IM,
          int_asos.NB_ITEM_LOC_RETAIL NIL
    WHERE IL.LOC             = '20009'
      AND IL.ITEM            = UI.ITEM
      AND IL.ITEM            = IM.ITEM
      AND IM.ITEM_LEVEL      = IM.TRAN_LEVEL
      AND IL.ITEM            = NIL.ITEM(+)
      AND IL.LOC             = NIL.LOC(+)
      AND UI.PRICE_UDA_VALUE = 0;


   SELECT /*+ FULL(IL) */
          UI.ITEM,
          '3001',
          'W',
          nvl(NIL.CURRENT_SELLING_RETAIL, IL.REGULAR_UNIT_RETAIL)
     FROM int_asos.ITEM_LOC IL,
          int_asos.INT_ITEM_PRICE_EST UI,
          int_asos.ITEM_MASTER IM,
          int_asos.NB_ITEM_LOC_RETAIL NIL
    WHERE IL.LOC             = '20009'
      AND IL.ITEM            = UI.ITEM
      AND IL.ITEM            = IM.ITEM
      AND IM.ITEM_LEVEL      = IM.TRAN_LEVEL
      AND IL.ITEM            = NIL.ITEM(+)
      AND IL.LOC             = NIL.LOC(+)
      AND UI.PRICE_UDA_VALUE = 0 
     AND exists (select 1 from int_asos.INT_ITEM_LOC_BUY_PRICE_EOD iibp where iibp.item = UI.ITEM AND iibp.loc = '3001');


     SELECT UI.ITEM,
          '3001',
          'W',
            IL.OUTLET_PRICE
     FROM int_asos.V_CFA_IL_OUTLET_G IL,
          int_asos.INT_ITEM_PRICE_EST UI,
          int_asos.ITEM_MASTER IM
     WHERE IL.LOC = '20009'
     AND   IL.ITEM = UI.ITEM
     AND   IL.ITEM = IM.ITEM
     AND   IM.ITEM_LEVEL = IM.TRAN_LEVEL
     AND   UI.PRICE_UDA_VALUE = 1
     AND exists (select 1 from int_asos.INT_ITEM_LOC_BUY_PRICE_EOD iibp where iibp.item = UI.ITEM AND iibp.loc = '3001');

	SELECT LOC_TYPE,
		       PRICING_LOC
		FROM ma_asos.MA_V_PRICING_LOC
		WHERE LOC = 3001;
        
select * from int_asos.NB_STOCK_BUCKETS_EOD;
select * from int_asos.NB_ITEM_LOC_RETAIL;
select * from ITEM_LOC whr ITEM = '' ;

10000003

slcy 


   INSERT INTO INT_ITEM_LOC_BUY_PRICE_EOD
     (ITEM,
      LOC,
      LOC_TYPE,
      BUY_UNIT_RETAIL)
   SELECT /*+ FULL(IL) */
          UI.ITEM,
          I_loc,
          l_loc_type,
          nvl(NIL.CURRENT_SELLING_RETAIL, IL.REGULAR_UNIT_RETAIL)
     FROM ITEM_LOC IL,
          INT_ITEM_PRICE_EST UI,
          ITEM_MASTER IM,
          NB_ITEM_LOC_RETAIL NIL
    WHERE IL.LOC             = l_pricing_loc
      AND IL.ITEM            = UI.ITEM
      AND IL.ITEM            = IM.ITEM
      AND IM.ITEM_LEVEL      = IM.TRAN_LEVEL
      AND IL.ITEM            = NIL.ITEM(+)
      AND IL.LOC             = NIL.LOC(+)
      AND UI.PRICE_UDA_VALUE = 0;

   INSERT INTO INT_ITEM_LOC_BUY_PRICE_EOD
     (ITEM,
      LOC,
      LOC_TYPE,
      BUY_UNIT_RETAIL)
     SELECT UI.ITEM,
            I_loc,
            l_loc_type,
            IL.OUTLET_PRICE
     FROM V_CFA_IL_OUTLET_G IL,
          INT_ITEM_PRICE_EST UI,
          ITEM_MASTER IM
     WHERE IL.LOC = l_pricing_loc
     AND   IL.ITEM = UI.ITEM
     AND   IL.ITEM = IM.ITEM
     AND   IM.ITEM_LEVEL = IM.TRAN_LEVEL
     AND   UI.PRICE_UDA_VALUE = 1;

    select * from int_asos.INT_ITEM_PRICE_EST;

    select item,count(1) from int_asos.INT_ITEM_PRICE_EST group by item having count(1) >1;


nb_ilbp_eod_refresh_90~20210114185248~process~~105~RET-0105: generic stored procedure error~INTERNAL STORED FUNCTION FAILED: 
INT_ILBP_EOD_SQL.POPULATE_TABLE:  DUPLICATE IN INT_ITEM_LOC_BUY_PRICE_EOD, FOR VALUE: 3001

