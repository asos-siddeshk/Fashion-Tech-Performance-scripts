select * from RPM_STAGE_DELETED_ITEM_LOC;

insert into RPM_STAGE_DELETED_ITEM_LOC
select rpm_stage_deleted_item_loc_seq.nextval,item,loc,'N' from item_loc where  --item in ('100934229','100815227','100760148')   
--    or 
item_parent in ('100934229','100815227','100760148') 
                                                                                      and loc in ( select 20014 from dual 
                                                                                            union
                                                                                            select location from rpm_zone_location where zone_id in ('102','113'));

insert into RPM_STAGE_DELETED_ITEM_LOC
select rms.rpm_stage_deleted_item_loc_seq.nextval,item,loc,'N' from item_loc where  --item_parent in ('100851438','100146175')    
--or 
item_parent in ('100851438','100146175')    
                                                                                      and loc in (select location from rpm_zone_location where zone_id ='101');


--Active clr and promo

select * from item_loc where  item_parent in ('100851438','100146175') and loc in (1001,10001);


select * from rms.rpm_future_retail where action_date > '01-MAR-2020' and PRICE_CHANGE_ID is not null;
select * from rms.rpm_future_retail where action_date > '01-MAR-2020' and CLEARANCE_ID is not null;
select * from rms.rpm_future_retail where action_date > '01-MAR-2020' and CLEARANCE_ID is null and location = '113';

--Future
select * from rpm_zone_location where ZONE_ID= '113';
select * from RPM_ZONE_FUTURE_RETAIL where  item in (select item from item_master where item in ('100934229','100815227','100760148') or item_parent in ('100934229','100815227')) 
                                    and location in ('20014','102','113') order by ACTION_DATE,item,location;

select * from rpm_future_retail where  item in (select item from item_master where item in ('100934229','100815227','100760148') or item_parent in ('100934229','100815227')) 
                                    and location in ('20014','102','113') order by ACTION_DATE,item,location;
select * from rpm_item_loc where (item,loc) in (select item,loc from item_loc where  item_parent in ('100934229','100815227','100760148')   
                                                                                      and loc in ( select 20014 from dual 
                                                                                            union
                                                                                            select location from rpm_zone_location where zone_id in ('102','113'))) order by 1,2,3;


select * from rpm_promo_item_loc_expl where  item in (select item from item_master where item in ('100934229','100815227','100760148') or item_parent in ('100934229','100815227')) 
                                    and location in ('20014','102','113') order by item,location;


Active
select * from rpm_zone_location where zone_id ='101';

RPM_ZONE_FUTURE_RETAIL
select * from RPM_ZONE_FUTURE_RETAIL where  item in (select item from item_master where item in ('100851438','100146175') or item_parent in ('100851438','100146175'))
                                        and location in ('1001','10001','101') order by ACTION_DATE,item,location;

select * from rpm_future_retail where  item in (select item from item_master where item in ('100851438','100146175') or item_parent in ('100851438','100146175'))
                                        and location in ('1001','10001','101') order by ACTION_DATE,item,location;
select * from rpm_item_loc where (item,loc) in (select item,loc from item_loc where  item_parent in ('100851438','100146175')   
                                                                                      and loc in (select location from rpm_zone_location where zone_id ='101')) order by 1,2,3;
                                                                                      
select * from price_hist where (item,loc) in (select item,loc from item_loc where  item_parent in ('100851438','100146175')   
                                                                                      and loc in (select location from rpm_zone_location where zone_id ='101')) order by 1,2,3;



select * from item_loc where  item_parent in ('100851438','100146175') and loc in (1001,10001);

select * from item_master where item in ('100851438','100146175') or item_parent in ('100851438','100146175');


SELECT * FROM ALL_TAB_PARTITIONS WHERE TABLE_NAME lIKE 'ITEM_LOC';

select * from dba_source where text like '%RPM_ITEM_LOC_DELETION_SQL%';




select item,loc from item_loc where  item_parent in ('100934229','100815227','100760148')   
                                                                                      and loc in ( select 20014 from dual 
                                                                                            union
                                                                                            select location from rpm_zone_location where zone_id in ('102','113'))
                                                                                            
                                                                                            