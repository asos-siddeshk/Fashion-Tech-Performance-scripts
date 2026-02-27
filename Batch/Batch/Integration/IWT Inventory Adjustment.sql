select 'ITL' as record_type, 'E' as action, 'Putaway' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHIISS') as dstamp,
'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'IWTISSUE' as reason_id, 'FC04' as site_id, 'UnLocked'
as lock_status,to_char (sysdate,'YYYYMMDDHHIISS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHIISS') as complete_dstamp,
'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='4001'
and stock_on_Hand ='0' and rownum<= '100';


select 'ITL' as record_type, 'E' as action, 'Putaway' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHIISS') as dstamp,
'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'IWTISSUE' as reason_id, 'FC03' as site_id, 'UnLocked'
as lock_status,to_char (sysdate,'YYYYMMDDHHIISS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHIISS') as complete_dstamp,
'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='3001'
and stock_on_Hand ='0' and rownum<= '100';

select 'ITL' as record_type, 'E' as action, 'Putaway' as code, '+' as update_quantity_sign,'2' as update_qty, to_char (sysdate,'YYYYMMDDHHIISS') as dstamp,
'ASOS' as client_id,item as sku_id,'IWTC1469126996734' as reference_id, 'IWTISSUE' as reason_id, 'FC01' as site_id, 'UnLocked'
as lock_status,to_char (sysdate,'YYYYMMDDHHIISS') as user_def_date_1,'Europe/London' as time_zone_name,812355 as config_id,to_char (sysdate,'YYYYMMDDHHIISS') as complete_dstamp,
'AQL' as lock_code,'N' as process_bo from rms.item_loc_soh where loc ='1001'
and stock_on_Hand ='0' and rownum<= '100';

select * from wh;