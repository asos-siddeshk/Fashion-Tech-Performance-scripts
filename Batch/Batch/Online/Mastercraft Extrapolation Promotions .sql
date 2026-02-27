select * from RMS.RPM_PROMO_DTL_CUST_ATTR_LABEL;
select * from RMS.RPM_PROMO_COMP_CUST_ATTR_LABEL;
select * from RMS.RPM_PROMO_CUST_ATTR_LABEL;



-- check the query 
select * from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23';
select * from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23');
select * from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23'));
select * from RMS.RPM_PROMO_DTL_LIST_GRP_hist where promo_dtl_id            in (select promo_dtl_id  from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23')));
select * from RMS.RPM_PROMO_DTL_LIST_hist where PROMO_DTL_LIST_GRP_ID       in (select PROMO_DTL_LIST_GRP_ID from RMS.RPM_PROMO_DTL_LIST_GRP_hist where promo_dtl_id in (select promo_dtl_id  from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23'))));
select * from RMS.RPM_PROMO_DTL_MERCH_NODE_hist where promo_dtl_id          in (select promo_dtl_id  from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23')));
select * from RMS.RPM_PROMO_ZONE_LOCATION_hist where promo_dtl_id           in (select promo_dtl_id  from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23')));
select * from RMS.RPM_PROMO_DTL_DISC_LDR_HIST where promo_dtl_list_id       in (select promo_dtl_list_id from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23')));
select * from RMS.RPM_PROMO_ITEM_LOC_EXPL where promo_dtl_id                in (select promo_dtl_id  from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23')));
select * from RMS.RPM_PROMO_DTL_CUST_ATTR where CUST_ATTR_ID                in (select CUST_ATTR_ID from RMS.RPM_PROMO_DTL_hist where PROMO_COMP_ID in ( select PROMO_COMP_ID from RMS.RPM_PROMO_COMP_hist where promo_id in (select Promo_id from RMS.RPM_PROMO_hist where start_date >= '01-OCT-23' and end_date <= '30-OCT-23')));



select * from RMS.RPM_FUTURE_RETAIL where (item,trunc(action_date)) in (select ITEM, trunc(DETAIL_START_DATE) from RMSSUB3.RPM_PROMO_ITEM_LOC_EXPL where promo_id ='67937')
union
select * from RMS.RPM_FUTURE_RETAIL where (item,trunc(action_date)) in (select ITEM, trunc(DETAIL_END_DATE+1) from RMSSUB3.RPM_PROMO_ITEM_LOC_EXPL where promo_id ='67937');







insert into RMS.RPM_PROMO select * from RMS_SSET.RPM_PROMO_hist;
insert into RMS.RPM_PROMO_COMP select * from RMS_SSET.RPM_PROMO_COMP_HIST;



insert into RMS.RPM_PROMO_DTL (PROMO_DTL_ID            ,
PROMO_COMP_ID           ,
PROMO_DTL_DISPLAY_ID    ,
IGNORE_CONSTRAINTS      ,
APPLY_TO_CODE           ,
START_DATE              ,
END_DATE                ,
APPROVAL_DATE           ,
CREATE_DATE             ,
CREATE_ID               ,
APPROVAL_ID             ,
STATE                   ,
ATTRIBUTE_1             ,
ATTRIBUTE_2             ,
ATTRIBUTE_3             ,
EXCEPTION_PARENT_ID     ,
FROM_LOCATION_MOVE      ,
PRICE_GUIDE_ID          ,
THRESHOLD_ID            ,
TIMEBASED_DTL_IND       ,
CANCEL_IL_PROMO_DTL_IND ,
SYS_GENERATED_EXCLUSION ,
DISCOUNT_LIMIT          ,
CUST_ATTR_ID            ,
MAN_TXN_EXCL_EXISTS     ,
MAN_TXN_EXCLUSION       ) 
select PROMO_DTL_ID            ,
PROMO_COMP_ID           ,
PROMO_DTL_DISPLAY_ID    ,
IGNORE_CONSTRAINTS      ,
APPLY_TO_CODE           ,
START_DATE              ,
END_DATE                ,
APPROVAL_DATE           ,
CREATE_DATE             ,
CREATE_ID               ,
APPROVAL_ID             ,
STATE                   ,
ATTRIBUTE_1             ,
ATTRIBUTE_2             ,
ATTRIBUTE_3             ,
EXCEPTION_PARENT_ID     ,
FROM_LOCATION_MOVE      ,
PRICE_GUIDE_ID          ,
THRESHOLD_ID            ,
TIMEBASED_DTL_IND       ,
CANCEL_IL_PROMO_DTL_IND ,
SYS_GENERATED_EXCLUSION ,
DISCOUNT_LIMIT          ,
CUST_ATTR_ID            ,
0,
0 from RMS_SSET.RPM_PROMO_DTL_hist;


insert into RMS.RPM_PROMO_ZONE_LOCATION select * from RMS_SSET.RPM_PROMO_ZONE_LOCATION_hist;
select * from all_constraints where constraint_name like 'DLG_RRD_FK';

select * from RPM_PROMO_DTL_LIST_GRP;

insert into RMS.RPM_PROMO_DTL_LIST_GRP select * from RMS_SSET.RPM_PROMO_DTL_LIST_GRP;
insert into RMS.RPM_PROMO_DTL_LIST select * from RMS_SSET.RPM_PROMO_DTL_LIST_hist;
insert into RMS.RPM_PROMO_DTL_MERCH_NODE select * from RMS_SSET.RPM_PROMO_DTL_MERCH_NODE_hist;
insert into RMS.RPM_PROMO_DTL_DISC_LADDER select * from RMS_SSET.RPM_PROMO_DTL_DISC_LDR_HIST;

insert into RMS.RPM_FUTURE_RETAIL select * from RMS_SSET.RPM_FUTURE_RETAIL;
insert into rms.RPM_PROMO_ITEM_LOC_EXPL select * from RMS_SSET.RPM_PROMO_ITEM_LOC_EXPL;


select * from period;
O_error_msg


select * from all_tables where table_name like 'RPM%DISC%';

select * from RMS_SSET.RPM_PROMO_comp_hist where promo_id in ('67759','67817','67827','67950','67977','67991','67997');
select distinct promo_id from RMS.RPM_PROMO_comp where promo_comp_id in (select promo_comp_id from RMS_SSET.RPM_PROMO_comp_hist where promo_id in ('67759','67817','67827','67950','67977','67991','67997'));

select * from RPM_PROMO_dtl where promo_comp_id in (select promo_comp_id from RPM_PROMO_comp where promo_id in ('67759','67817','67827','67950','67977','67991','67997'));


desc RPM_PROMO_dtl;
desc RPM_PROMO_dtl_hist;

select * from RPM_PROMO_hist;


select distinct promo_id from RMS.RPM_PROMO_COMP rpch where  exists (select 1 from RMS_SSET.RPM_PROMO_hist rpc where rpc.promo_id= rpch.promo_id);
select distinct PROMO_COMP_ID from RMS_SSET.RPM_PROMO_DTL_hist rpch where exists (select 1 from RMS_SSET.RPM_PROMO_COMP_HIST rpc where rpc.PROMO_COMP_ID= rpch.PROMO_COMP_ID);


