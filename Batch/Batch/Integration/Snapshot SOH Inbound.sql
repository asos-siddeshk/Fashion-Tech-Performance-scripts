select * from all_tables where owner like 'SKUMAR';

SELECT TABLESPACE_NAME, FILE_NAME FROM DBA_DATA_FILES
  ORDER BY TABLESPACE_NAME;
  
  select * from NB_INV_STATUS_QTY_SNAP;
  select * from NB_INV_STATUS_QTY_SNAP;
  
  (SELECT isq.item,
               isq.location loc,
               SUM(DECODE(isc.inv_status_code, 'AQL', isq.qty, 0))   AS AQL,
               SUM(DECODE(isc.inv_status_code, 'REPRO', isq.qty, 0)) AS REPRO,
               SUM(DECODE(isc.inv_status_code, 'TRBL', isq.qty, 0))  AS TRBL,
               SUM(DECODE(isc.inv_status_code, 'UNAV', isq.qty, 0))  AS UNAV,
               SUM(DECODE(isc.inv_status_code, 'INCUB', isq.qty, 0)) AS INCUB
          FROM NB_INV_STATUS_QTY_SNAP isq,
               INV_STATUS_CODES isc
         WHERE isc.inv_status = isq.inv_status
         GROUP BY item) inv_status;
         
         
select * from all_mviews where mview_name like 'NB_MV_STOCK_BUCKETS_EOD';

  select * from 
 (  SELECT item,
               location loc,               
               SUM(DECODE(isc.inv_status_code, 'AQL', isq.qty, 0))   AS AQL,
               SUM(DECODE(isc.inv_status_code, 'REPRO', isq.qty, 0)) AS REPRO,
               SUM(DECODE(isc.inv_status_code, 'TRBL', isq.qty, 0))  AS TRBL,
               SUM(DECODE(isc.inv_status_code, 'UNAV', isq.qty, 0))  AS UNAV,
               SUM(DECODE(isc.inv_status_code, 'INCUB', isq.qty, 0)) AS INCUB
          FROM rms.NB_INV_STATUS_QTY_SNAP isq,
               rms.INV_STATUS_CODES isc
         WHERE isc.inv_status = isq.inv_status
         and location ='1001' --3001,4001
         GROUP BY item,
                  location
                  order by item,location) where rownum <= '1000'; --100000, 500000,


select FILENAME,count(1) from int_asos.int_ext_stock_snapshot_stg where trunc(CREATE_DATETIME) = trunc(sysdate) group by FILENAME;
select * from int_asos.int_ext_stock_snapshot_stg where trunc(CREATE_DATETIME) = trunc(sysdate);

delete from int_asos.int_ext_stock_snapshot_stg where trunc(CREATE_DATETIME) = trunc(sysdate);


Sku_ID,Location_ID,Location_Type,Floor,Quantity,Lock_Status,Lock_Code,Lock_Time,Stock_Status_Item,Warehouse_ID
10000,,,,5,AQL,,,Stock held by AQL,FC01
10001,,,,5,CUSTOMERQA,,,Stock held by Customer Reservce,FC01
10002,,,,5,PREQAHOLD,,,PREQAHOLD,FC01

FC01- 10L
FC03-5L
FC04-5L

1 - AQL  - AQL	    'Stock held by AQL' -- 200000
3 - TRBL - DMGD	    'Stock is damaged' -- 200000
2 - RPRO - EXTREWORK'Stock for External Recprocessing' -- 200000
4 - UNAV - EXPD	    'Stock has expired due to insufficient shelf-life' -- 200000
5 - INCB - INCUB	'Stock held by INCB' -- 200000

select * from int_asos.INT_EXT_STOCK_SNAPSHOT_STG  order by CREATE_DATETIME;


    select * from (SELECT item,
               location loc,               
               SUM(isq.qty)   AS Quantity,
               'DMGD'  Lock_Status,
               'Stock is damaged'  Stock_Status_Item,
                wh.WH_NAME_SECONDARY Warehouse_ID               
          FROM rms.NB_INV_STATUS_QTY_SNAP isq,
               rms.INV_STATUS_CODES isc,
               rms.wh
         WHERE isc.inv_status = isq.inv_status and isq.INV_STATUS ='3' and isq.qty> '0'
         and isq.location ='1001' and isq.location = wh.wh
         group by item,location,wh.WH_NAME_SECONDARY) where rownum<= '200000';


select * from int_asos.NB_ITEM_LOC_SOH_SNAP;
select * from int_asos.NB_INV_STATUS_QTY_SNAP;

select * from int_asos.MV_STOCK_SNAPSHOT_DISCREPANCY order by TS_RMS desc;

select * from all_views where view_name like '%SNAP%' and owner like 'INT_ASOS';
select * from all_mviews where mview_name like '%SNAP%' and owner like 'INT_ASOS';
-- select * from all_mviews where mview_name like '%SNAP%' and owner like 'RMS';


select * from int_asos.INT_EXT_STOCK_SNAPSHOT_STG order by CREATE_DATETIME desc;
     
        
      desc int_asos.INT_EXT_STOCK_SNAPSHOT_STG ;
        
        
        