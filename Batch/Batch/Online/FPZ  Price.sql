select * from price_hist where loc in ('20015','20010','20016')    
and item in (select item from item_master where item = '100013987' or item_parent = '100013987') order by loc,item desc;

select * from item_loc where loc in ('20015','20010','20016') 
and item in (select item from item_master where item = '100013987' or item_parent = '100013987') order by loc,item desc;


    item in (select item from item_master where item = '101361448' or item_parent = '111483496') order by loc,item desc;

    item in (select item from item_master where item = '101361448' or item_parent = '111483496') order by loc,item;
    

select count(1) from rpm_event_itemloc;
select * from rpm_clearance order by 1 desc;
101361448
101347120
101320480
111483496
106603432
select * from rpm_price_change order by 1 desc;
    
    
-- On Clearance
select * from rms.item_loc where item = '7381952' and loc in ('20015','20010');  -- On Clearance
select * from rms.price_hist where item = '7381952' and loc in ('20015','20010') order by item,loc,action_date;

 

-- On Clearance & Promo
select * from rms.item_loc where item = '10006932' and loc in ('20015','20010');  
select * from rms.price_hist where item = '10006932' and loc in ('20015','20010') order by item,loc,action_date;
select * from rms.rpm_future_retail where item = '101029455' and location in (111,114,'20015','20010');  -- Initial raning with Clr price

 

-- On Promo 
select * from rms.item_loc where item = '10027086' and loc in ('20015','20010');  -- Has promo, no clr 
select * from rms.price_hist where item = '10027086' and loc in ('20015','20010') order by item,loc,action_date;
select * from rms.rpm_future_retail where item = '101033029' and location in (111,114,'20015','20010');  --Not available for new location





select count(1) from rpm_item_zone_price where zone_id = '114'; --12304699

select count(1) from rpm_zone_future_retail where zone = '114'; --12304699
select count(1) from rpm_zone_future_retail where zone = '114'; --49, 40049, 50049, 210k, 


select * from rpm_item_zone_price where zone_id = '115'; --56,  1 4M
select * from item_loc where item = '128841734';
select * from rpm_future_retail where item = '128841609';

select * from rpm_item_zone_price where item = '128841734';
select * from rpm_item_zone_price where item = '128841734';
select * from item_loc where item = '128841609';
select * from item_master where item = '128841734';


select item_level,count(1) from item_master where item in (select item from rpm_item_zone_price where zone_id = '114') group by item_level; 


desc rpm_zone;



