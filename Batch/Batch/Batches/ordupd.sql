select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select * from ma_asos.ma_stage_price_change where effective_date ='15-JAN-24';
select * from ma_asos.ma_price_change where effective_date ='15-JAN-24';


 WITH phist AS
              (select item, 10 as unit_retail, LOCATION as loc, effective_date as action_date from ma_asos.ma_price_change where effective_date ='15-JAN-24')
       SELECT distinct 'S',
              oh.order_no,
              oh.currency_code,
              '0' pack_no,
              TO_CHAR(oh.otb_eow_date, 'YYYYMMDD'),
              oh.order_type,
              oh.status,
              NVL(ph.unit_retail,0) - NVL(ol.unit_retail, 0),
              NVL(ol.qty_ordered, 0) - NVL(ol.qty_received, 0),
              ph.item,
              ol.loc_type,
              ol.location,
              0 pack_qty,
              NVL(ph.unit_retail, 0),
              ROWIDTOCHAR(ol.rowid) ol_rowid
         FROM ordloc ol,
              ordhead oh,              
              phist ph
        WHERE oh.order_no    = ol.order_no
          AND ph.item        = ol.item
        --  and ol.item ='4923712'
       --   AND ol.location    = TO_NUMBER(:ps_drive_location)
       and ol.location = ph.loc
          AND oh.status      in ('W', 'S', 'A');
          
select * from rpm_price_change where effective_date ='15-JAN-24' and ZONE_NODE_TYPE ='2';
select * from period;          
select * from emer_price_hist;