select im2.dept,im2.class,im2.subclass,count(1) from item_master_op im2 
                       where dept ='1004'
                group by im2.dept,im2.class,im2.subclass having count(1) >50;      
        

select * from(
select im.item, ma.ZONE_GROUP_ID, ma.ZONE_ID, null as location, 12 as reason_code, '28-APR-21' as Effective_Date , 2 as Change_type, il.SELLING_UNIT_RETAIL+2 as Change_Amount, null as Change_Percent
    from item_master_op im,item_loc il, ma_asos.MA_PRICING_DEFAULTS ma 
    where im.item = il.item 
        and im.dept ='2008'
        and not exists (select 1 from ma_asos.ma_price_change mpc where mpc.item = im.item)
        and il.loc = ma.store) where rownum <= '1000';


        
1004 --50   --trunc(EFFECTIVE_DATE) = '25-APR-21'
1006 --100  --trunc(EFFECTIVE_DATE) = '26-APR-21'
1001 --500  --trunc(EFFECTIVE_DATE) = '27-APR-21'
2008 --1000 --trunc(EFFECTIVE_DATE) = '28-APR-21'

begin
delete  from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) >='31-MAR-20' and status = 'P';
delete  from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE) >='31-MAR-20';
delete  from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) between '25-APR-21' and '28-APR-21';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1004') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1006') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1001') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2008') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1004') and status = 'S' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1006') and status = 'S' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1001') and status = 'S' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2051') and status = 'S' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1004') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1006') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1001') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2051') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1004') and status = 'S' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1006') and status = 'S' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1001') and status = 'S' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2051') and status = 'S' and PLACE_OF_CREATION = 'U';
commit;
end;
/

select * from ma_asos.ma_price_change where PLACE_OF_CREATION = 'U';
update  ma_asos.ma_price_change set PLACE_OF_CREATION = 'M' where PLACE_OF_CREATION = 'U' ;
 
 
 select * from rms.item_master im
    inner join rms.v_item_master vim on vim.item=im.item inner join ma_asos.ma_v_item mvim on mvim.item=im.item
        left join
        ma_asos.ma_price_change pc on im.item=pc.item where vim.division=1 and mvim.business_model=1 and im.status ='A' and im.item_level = '1'
    and pc.item is null and im.check_uda_ind='N' and im.dept<>1063
order by trunc(im.create_datetime) desc;

   select dept,class,subclass,counta from (  
    select im.dept,im.class,im.subclass,count(1) as counta from rms.item_master im  where item_level ='1' and status ='A' 
        group by im.dept,im.class,im.subclass having count(1) > 2000);

select distinct im.item,2 as "Zone Group", rz.zone_id  from item_master  im, rpm_zone rz 
    where im.item_level ='1' and im.dept ='2003' and class='1' and subclass ='1'
    and not exists ( select 1 from ma_asos.ma_price_change pc where pc.item=im.item ) and rownum <= '3500';
    
update  ma_asos.ma_price_change set PLACE_OF_CREATION = 'M' where item in (select item from item_master where dept = '2003');

select distinct item from item_master where dept = '2003' and item in (select item from ma_asos.ma_price_change) and item_level = '1';


begin
delete  from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) = '25-APR-20' or trunc(EFFECTIVE_DATE) ='25-JAN-20';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2003') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1004') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2008') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1002') and status = 'W' and PLACE_OF_CREATION = 'M';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1050') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1004') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '2008') and status = 'W' and PLACE_OF_CREATION = 'U';
delete from ma_asos.ma_price_change where item in (select item from item_master where dept = '1002') and status = 'W' and PLACE_OF_CREATION = 'U';
commit;
end;
/

select dept,count(1) from item_master where item in 
    (select distinct item from ma_asos.ma_price_change ) 
    group by dept;

select * from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) = '25-APR-20' or trunc(EFFECTIVE_DATE) ='25-JAN-20';


select * from ma_asos.ma_price_change where trunc(EFFECTIVE_DATE) = '25-APR-20' or trunc(EFFECTIVE_DATE) ='25-JAN-20';

select CREATE_ID, STATUS,EFFECTIVE_DATE,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME) = trunc(sysdate) 
    group by CREATE_ID, STATUS,EFFECTIVE_DATE order by 1;


