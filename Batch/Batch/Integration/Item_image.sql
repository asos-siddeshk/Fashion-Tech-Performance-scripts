select ITEM, IMAGE_NAME,count(1) from item_image where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) group by ITEM, IMAGE_NAME;
select ITEM, count(1) from item_image ii where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) 
    and exists (select 1 from rms.item_master im where item_level = '1' and im.item = ii.item) group by ITEM;
    
select count(distinct item) from item_image ii where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) 
    and exists (select 1 from rms.item_master im where item_level = '1' and im.item = ii.item);

select count(distinct item) from item_image ii where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) 
    and exists (select 1 from rms.item_master im where im.item = ii.item);

select count(item) from item_image ii where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) 
    and exists (select 1 from rms.item_master im where im.item = ii.item);

select item from item_image ii where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) 
    and exists (select 1 from rms.item_master im where im.item = ii.item);

1693 -16:43

select 1727-1693 from dual;
select * from rms.rib_message where family = 'XItem';
select count(1) from rms.rib_message where family = 'XItem';
select THREAD_VALUE,count(1) from rib_message where family = 'XItem' group by THREAD_VALUE;


select * from item_image where item = '100489519';
select * from item_image_tl where item = '100489519';


select * from rms.rib_message;