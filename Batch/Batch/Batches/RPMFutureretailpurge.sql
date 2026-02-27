select count(1) from rpm_future_retail;                 --152877404 
select count(1) from rpm_promo_item_loc_expl;           --39996760
select count(1) from RPM_ZONE_FUTURE_RETAIL;            --157158281

select count(1) from RPM_PRICE_CHANGE ;                 -- 18988
select count(1) from RPM_CLEARANCE ;                    --23292301
select count(1) from RPM_CLEARANCE_RESET ;              --144222410

select count(1) from rms.RPM_PROMO;                     --15098
select count(1) from rms.RPM_PROMO_COMP ;               --27606
select count(1) from rms.RPM_PROMO_DTL ;                --47755141
select count(1) from rms.RPM_PROMO_DTL_LIST_GRP ;       --47755141
select count(1) from rms.RPM_PROMO_DTL_LIST ;           --47755141
select count(1) from rms.RPM_PROMO_DTL_MERCH_NODE ;     --47755141
select count(1) from rms.RPM_PROMO_ZONE_LOCATION ;      --47755141
select count(1) from rms.RPM_PROMO_DTL_DISC_LADDER ;    --47755141

select count(1) from RPM_MERCH_LIST_HEAD ;              --24749
select count(1) from RPM_MERCH_LIST_DETAIL ;            --32417
select count(1) from RPM_PEIL_DEPT_CLASS_SUBCLASS ;     --32417
select count(1) from RPM_CONFLICT_CHECK_RESULT ;        --20397775
select count(1) from RPM_CON_CHECK_ERR ;                --6329891
select count(1) from RPM_CON_CHECK_ERR_DETAIL ;         --2660852
select count(1) from RPM_BATCH_RUN_HISTORY ;            --20310407
select count(1) from RPM_SYSTEM_OPTIONS ;
select count(1) from RPM_CLEARANCE_PAYLOAD ;            --84403
select count(1) from RPM_BATCH_RUN_HISTORY ;            --20310407
select count(1) from RPM_BULK_CC_TASK ;                 --7875
select count(1) from RPM_TASK ;                         --8068


RFR Purge
RPM Purge
Promo Arch

Update rpm_system_options set clearance_hist_months = '87';
Update rpm_system_options set promotion_hist_months = '6';


Post: 
select * from period;
select count(1) from rpm_future_retail;                 --140k

Update rpm_system_options set clearance_hist_months = '60';


Post: 
select 152877404-140000 from dual;
select 152737404-152721494 from dual; --15910

select count(1) from rpm_future_retail;                 --152721494
select count(1) from rpm_promo_item_loc_expl;           --39996760
select count(1) from RPM_ZONE_FUTURE_RETAIL;            --157158281

select count(1) from RPM_PRICE_CHANGE;                  --18988
select count(1) from RPM_CLEARANCE ;                    --23292301
select count(1) from RPM_CLEARANCE_RESET ;              --144222410

select count(1) from rms.RPM_PROMO;                     --14899
select count(1) from rms.RPM_PROMO_COMP ;               --25132
select count(1) from rms.RPM_PROMO_DTL ;                --39522371
select count(1) from rms.RPM_PROMO_DTL_LIST_GRP ;       --39522371
select count(1) from rms.RPM_PROMO_DTL_LIST ;           --39522371
select count(1) from rms.RPM_PROMO_DTL_MERCH_NODE ;     --39522371
select count(1) from rms.RPM_PROMO_ZONE_LOCATION ;      --39522371
select count(1) from rms.RPM_PROMO_DTL_DISC_LADDER ;    --39522371

select count(1) from RPM_MERCH_LIST_HEAD ;              --24749
select count(1) from RPM_MERCH_LIST_DETAIL ;            --32417
select count(1) from RPM_PEIL_DEPT_CLASS_SUBCLASS ;     --1933
select count(1) from RPM_CONFLICT_CHECK_RESULT ;        --20397775
select count(1) from RPM_CON_CHECK_ERR ;                --6329891
select count(1) from RPM_CON_CHECK_ERR_DETAIL ;         --2660852
select count(1) from RPM_BATCH_RUN_HISTORY ;            --19752397
select count(1) from RPM_SYSTEM_OPTIONS ;
select count(1) from RPM_CLEARANCE_PAYLOAD ;            --84403
select count(1) from RPM_BULK_CC_TASK ;                 --7875
select count(1) from RPM_TASK ;                         --8068



PURGE_BATCH 
FUTURE_RETAIL_PURGE_BATCH 
PROMOTION_ARCHIVE_BATCH






--2M  Options * 15 Zone's.. 
select * from rpm_clearance where effective_date > '14-APR-16' and effective_date < '14-MAY-16';
select CLEARANCE_ID, STATE, ITEM, ZONE_ID, EFFECTIVE_DATE, CHANGE_TYPE, CHANGE_PERCENT from rpm_clearance where item = '101271526';
select * from rpm_future_retail where future_retail_id < 5000 and future_retail_id > 2000;                 --152877404 
select ITEM, DEPT, CLASS, SUBCLASS, LOCATION, ACTION_DATE, SELLING_RETAIL, CLEAR_RETAIL, CLEAR_RETAIL_CURRENCY, SIMPLE_PROMO_RETAIL, SIMPLE_PROMO_RETAIL_CURRENCY, CLEARANCE_ID, CLEAR_MKDN_INDEX, CLEAR_START_IND from rpm_future_retail 
    where item = '100796686' and zone_node_type ='1' order by item,location,action_date;