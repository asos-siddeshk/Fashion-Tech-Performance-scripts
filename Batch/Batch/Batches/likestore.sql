GRANT SELECT,INSERT,UPDATE,DELETE ON ma_fpz_param TO SKUMAR; 


select * from all_source where text like '%PROCESS_NB_STG_IL%';

select count(1) from itemloc_mfqueue;
select LOC,PUB_STATUS,count(1) from rms.nb_stg_item_loc group by LOC,PUB_STATUS;
select PUB_STATUS,count(1) from rms.nb_stg_item_loc_cfa_ext group by PUB_STATUS;
select ID, PROCESS, MSG_TYPE, MSG, to_char(CREATE_DATETIME,'DD-MON-YY hh:mi:ss am') ENQUEUE_DATETIME  from rms.nb_fpz_log order by id desc;

 select * from rms.ma_fpz_param;
      
select * from logger_logs;

select * from rms.nb_stg_item_loc;
select * from rms.nb_stg_item_loc_cfa_ext;

GRANT SELECT,INSERT,UPDATE,DELETE ON nb_fpz_log TO SKUMAR; 
GRANT SELECT,INSERT,UPDATE,DELETE ON nb_stg_item_loc TO SKUMAR; 
GRANT SELECT,INSERT,UPDATE,DELETE ON nb_stg_item_loc_cfa_ext TO SKUMAR; 

select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('a2vm8cv6wj548') and s.snap_id = SQL.snap_id
and s.begin_interval_time> TO_date('31-JUL-2023 9:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time< TO_date('1-AUG-2023 21:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;



select * from logger_logs where id > = '578538296' order by 1 desc;
select * from all_sequences where sequence_name like '%LOGGER%';
--delete rpm_stage_item_loc where loc!='20015';--- 10449622 (9:54) 10640816(10:26)
select * from vat_region;

select * from item_exp_head;
select * from cost_zone_group;
select * from cost_zone_group_loc;
select count(1) from item_loc where loc='20010';  -- 12304550

select count(1) from item_supp_country_loc where loc='20015';       -- 11985179, 12522508, 13016695, 13303368, 13531335
select count(1) from future_cost where location='20015      ';            -- 10004039, 10519614, 11013801, 11300474, 11528441
select count(1) from item_loc where loc='20015';                    -- 10835952, 11335952, 11822984, 12097984,  12299549
select count(1) from item_loc_soh where loc='20015';                -- 9012087, 9495688, 9982720, 10257720, 10459285
select count(1) from price_hist where loc='20015';                  -- 10835923, 11335923, 11822955, 12097955, 12299520
select count(1) from rpm_stage_item_loc where loc='20015';          -- 10835952(11:00) 11335952 (12:40)  11560952 (1:19) 11822984 (2:17) 12097984 (3:24) 12256325(16.38), 12299549
select count(1) from rpm_stage_item_loc_clean where loc='20015';          -- 10835952(11:00) 11335952 (12:40)  11560952 (1:19) 11822984 (2:17) 12097984 (3:24) 12256325(16.38), 12299549

select count(1) from RPM_future_cost where location='20015';        -- 9015709, 9499311, 10261343, 10462908
select count(1) from RPM_zone_future_retail where zone in ('114'); 
select count(1) from RPM_item_zone_price where zone_id in ('114');
select count(1) from RPM_item_zone_price where item = '101227551' and zone_id in ('121','114');

--12M records
update rms.rpm_stage_item_loc set status = 'E';
update rms.rpm_stage_item_loc set status = 'N' where rownum <= '1000000' and status = 'E';
delete from rms.rpm_stage_item_loc_clean;

select im.dept,im.item_level,count(ril.loc) from rms.item_master im,rpm_stage_item_loc ril where ril.status = 'N' and im.item = ril.item  group by im.dept,im.item_level order by 1;

select STATUS,count(STATUS) from rms.rpm_stage_item_loc group by STATUS;  --E, 9467988
select STATUS,loc,count(STATUS) from rms.rpm_stage_item_loc group by STATUS,loc; 
select LOC,count(LOC) from rpm_stage_item_loc_clean group by LOC; 
select count(1) from rpm_stage_item_loc_clean;
select STATUS,count(STATUS) from rms.rpm_stage_item_loc group by STATUS; 

--NIL - Batch run with status as N
select count(1) from RPM_future_retail where location in ('20015','114');  --106583, 258228, 410879, 555568, 711530   ,859574, 1077707, 1275113, 1457533, 1646482
select count(1) from RPM_item_loc where loc in ('20015','114');         --589802, 1513055, 2427808, 3315159, 4212325  ,5088583,6010671, 7009719, 8009457, 9009457, 

select * from RPM_zone_future_retail where zone in ('114'); 
select * from RPM_item_zone_price where zone_id in ('114');

select * from rpm_zone_location order by 1 desc;
select * from rpm_zone order by 2 desc;
select * from store;

select * from rpm_future_retail where location = '20015' order by action_date;

select * from rms.tmp_item_loc;


select * from tran_data where location = '20015';

select count(1) from tran_data where trunc(TIMESTAMP)>= '18-MAY-23';

select count(1) from rpm_stage_item_loc;
select count(1) from RPM_EVENT_ITEMLOC;
select count(1) from EMER_PRICE_HIST; --607400
select count(1) from rpm_stage_item_loc_clean where loc='20015'; 


select * from rpm_stage_item_loc;


780k sku locations

select * from rpm_clearance where location = '20015';
select * from rpm_promo_zone_location where zone_id = '111'; --

select * from rpm_future_retail where location = '20015' order by action_date;


select * from rpm_zone_location;
select * from rpm_zone;



select count(1) from rpm_stage_item_loc where loc='20015';
select count(1) from item_loc where loc='20015';
select * from deal_item_loc_explode;
--400k options skus ranging completed in 15 mins. 

select item_level,count(1) from item_master group by item_level;

select count(1) from item_loc where loc='20015';
select count(1) from item_loc where loc='20015';

alter trigger "RMS"."EC_TABLE_ITL_AIUDR" disable;
alter trigger "RMS"."EC_TABLE_RIL_AIUDR" disable;


desc rpm_zone_location;

select * from rpm_zone_location where location = '20015';
Update rpm_zone_location set zone_id ='121' where location = '20015';
select * from rpm_zone_location where zone_id = '111';
select * from rpm_zone where zone_id = '111';

            insert into rpm_stage_item_loc (stage_item_loc_id,
                    item,
                    loc,
                    loc_type,
                    selling_unit_retail,
                    selling_uom,
                    status,
                    create_date)
            select rpm_stage_item_loc_seq.nextval,
                    item,
                    20015 as loc,
                    loc_type,
                    regular_selling_unit_retail,
                    selling_uom,
                    'N',
                    sysdate from item_loc where loc = '20010';
                    

select * from rms.rpm_stage_item_loc;

update rms.rpm_stage_item_loc set status = 'E';
update rms.rpm_stage_item_loc set status = 'N' where rownum <= '1000000' and status = 'E';


select STATUS,count(STATUS) from rms.rpm_stage_item_loc group by STATUS; 
select STATUS,loc,count(STATUS) from rms.rpm_stage_item_loc group by STATUS,loc; 
select LOC,count(LOC) from rpm_stage_item_loc_clean group by LOC; 

select * from rms.rpm_stage_item_loc where status = 'N';
select * from rpm_item_loc where (item,loc) in (select item,loc from rms.rpm_stage_item_loc where status = 'N');


select im.dept,count(ril.loc) from rms.item_master im,rpm_stage_item_loc ril where ril.status = 'N' and im.item = ril.item  group by im.dept order by 1;
select im.dept,ril.loc,count(1) from rms.item_master im,rpm_stage_item_loc ril where  im.item = ril.item  group by im.dept,ril.loc order by 1;


select * from RPM_future_retail where location in ('20015','121','114'); 
select * from RPM_item_loc where loc in ('20015','121'); 

--121	114
select * from item_master where item = '11279071';


select * from RPM_zone_future_retail where zone in ('121','114');
select * from RPM_item_zone_price where item = '101227551';

select * from RPM_future_retail where item = '101227551';
select count(1) from RPM_item_loc where loc = '20015';

select * from rpm_zone;
select * from rpm_zone_location where location = '20015';
121	114	2	Ireland
select * from RPM_future_retail where location in ('20015','114'); 
select * from RPM_item_loc where loc in ('20015','114'); 

select * from all_tables where table_name like '%HISTORY%' and owner like 'RMS';

RPM_NEW_ITEM_LOC_SQL.ROLLUP_NIL_DATA

select * from RPM_BATCH_RUN_HISTORY where trunc(log_datetime) = '24-MAY-23' order by 1 desc;






select STATUS,count(STATUS) from rms.rpm_stage_item_loc group by STATUS; 

select * from item_supp_country_loc where loc in ('20015','20010') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 
select * from item_loc_soh where loc in ('20015','20010') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 
select * from rpm_future_cost where location in ('20015','20010') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 
select * from future_cost where location in ('20015','20010') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 
select * from item_loc where loc in ('20015','20010') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 
select * from price_hist where loc in ('20015','20010') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 
select * from rpm_future_retail where location in ('111','20010','114','20015') and item in (select item from item_master where item ='130203815' or item_parent = '130203815'); 

select * from item_master where item ='130203815' or item_parent = '130203815' or item_grandparent = '130203815';

select * from item_supp_country_loc where loc='20015' and item = '10331800'; 
select * from future_cost where location='20015'; 
select * from item_loc where loc='20015' and clear_ind = 'Y';  
select * from item_loc where loc='20010' and clear_ind = 'Y';  
select * from item_loc_soh where loc='20015';  
select * from price_hist where loc='20015';  
select * from rpm_stage_item_loc where loc='20015'; 
select * from RPM_future_cost where location='20015';  
select * from RPM_zone_future_retail where zone in ('114');
select * from RPM_item_zone_price where zone_id in ('114');
select * from RPM_item_zone_price where item = '101227551' and zone_id in ('121','114');
select * from RPM_item_zone_price where item = '130203815';

select count(1) from rms.item_loc where clear_ind = 'Y' and loc = '20010';  
select count(1) from rms.item_loc where clear_ind = 'Y' and loc = '20010';  

select * from item_loc where clear_ind = 'Y' and loc = '20005';  