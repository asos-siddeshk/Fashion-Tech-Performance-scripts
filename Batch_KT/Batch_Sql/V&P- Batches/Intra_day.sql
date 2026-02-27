select status,count(1) from rpm_bulk_cc_pe_thread group by status;
select count(1) from rpm_stage_item_loc; 
select * from rpm_stage_item_loc; 
select count(1) from rpm_stage_item_loc_clean; 
select STATUS,count(STATUS) from rpm_stage_item_loc group by STATUS; 
select LOC,count(LOC) from rpm_stage_item_loc group by LOC; 

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS; -- 3000
--insert into ma_asos.ma_stage_price_change  select * from ma_stage_price_change_bk ;
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
--insert into ma_asos.ma_stage_clearance select * from ma_stage_clearance_bk ;
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' group by PROMO_START_DATE order by 1;
select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;  --E	1119
--INSERT INTO ma_asos.ma_stage_simple_promo SELECT * FROM ma_stage_simple_promo_bk;

select  * from rms.rpm_stage_simple_promo;

exec system.killsession ('3778');

select * from PERIOD;
select * from rpm_bulk_cc_pe;
select * from rpm_bulk_cc_pe order by 1 desc;
select status,count(1) from rpm_bulk_cc_pe_thread group by status;
select * from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='13910732' order by 1 desc;
select PRICE_EVENT_START_DATE,count(1) from rpm_bulk_cc_pe_thread group by PRICE_EVENT_START_DATE;
select PRICE_EVENT_START_DATE,count(1) from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='13910732' group by PRICE_EVENT_START_DATE;
select * from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='13910732';
select status,count(1) from rpm_bulk_cc_pe_thread  group by status;
select * from rpm_bulk_cc_pe_item where BULK_CC_PE_ID in (select BULK_CC_PE_ID from rpm_bulk_cc_pe_thread where trunc(PRICE_EVENT_START_DATE) = '27-JAN-2019');
select count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='13910732'  order by 1 desc; --1 21 89 039
select count(1) from rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='13910732'  order by 1 desc;
select * from rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='13910732'  order by 1 desc;
select * from rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='13910732'  order by 1 desc;
select ITEM_PARENT,count(1) from rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='13910732' group by ITEM_PARENT order by 2 desc;
select ITEM_PARENT,count(1) from rpm_bulk_cc_pe_item group by ITEM_PARENT order by 2 desc;

select count(1) from rpm_bulk_cc_pe_item;
select 5037/1095 from dual;


select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  

select rzl.location, count(1) from ma_asos.ma_stage_clearance msc , skulist_detail sd, rpm_zone_location rzl
    where msc.skulist = sd.skulist
        and msc.ZONE_ID = rzl.zone_id
        group by rzl.location; --30000

select STATE, trunc(EFFECTIVE_DATE),rzl.location, count(1) from rpm_clearance msc , skulist_detail sd, rpm_zone_location rzl
    where msc.skulist = sd.skulist
        and msc.ZONE_ID = rzl.zone_id
        and msc.state in ('pricechange.state.approved','pricechange.state.executed')
        and msc.effective_date= '02-MAR-20'
        group by rzl.location,STATE, trunc(EFFECTIVE_DATE)
        order by trunc(EFFECTIVE_DATE);


select count(1) from rpm_clearance where trunc(EFFECTIVE_DATE)= '02-MAR-20'; --540
---Newitemloc

begin
delete rpm_stage_item_loc_clean; 
delete rpm_stage_item_loc; 
delete from ma_asos.ma_stage_price_change;
delete from ma_asos.ma_stage_simple_promo;
--insert into rms.rpm_stage_item_loc select * from new_item_loc_batch;
commit;
end;
/

--create table new_item_loc_batch as select * from rms.rpm_stage_item_loc;
select * from new_item_loc_batch;

begin
insert into rms.rpm_stage_item_loc select * from new_item_loc_batch;
commit;
end;
/


--create table overnight_item_loc_batch as select * from rms.rpm_stage_item_loc;

begin
delete rpm_stage_item_loc_clean; 
delete rpm_stage_item_loc; 
insert into rms.rpm_stage_item_loc select * from overnight_item_loc_batch;
delete from ma_asos.ma_stage_price_change;
insert into ma_asos.ma_stage_price_change  select * from ma_stage_price_change_bk ;
delete from ma_asos.ma_stage_clearance ;
insert into ma_asos.ma_stage_clearance select * from ma_stage_clearance_bk ;
delete from ma_asos.ma_stage_simple_promo;
INSERT INTO ma_asos.ma_stage_simple_promo SELECT * FROM ma_stage_simple_promo_bk;
delete from ma_asos.ma_ship_rest_rule_mfqueue;
insert into ma_asos.ma_ship_rest_rule_mfqueue select * from ma_ship_rest_rule_mfqueue_bk;
commit;
end;
/
select * from overnight_item_loc_batch;
insert into rms.rpm_stage_item_loc select * from overnight_item_loc_batch;

update rpm_stage_item_loc set STATUS ='N'
select * from rpm_stage_item_loc; --
select * from rpm_stage_item_loc_clean; --
drop table overnight_item_loc_batch;

select count(1) from rpm_stage_item_loc; --
select count(1) from rpm_stage_item_loc_clean; --
select count(1) from rpm_stage_item_loc_bk; --6295624
select count(1) from overnight_item_loc_batch;
select count(1) from intra_item_loc_batch;
select count(1) from new_item_loc_batch;

create table intra_item_loc_batch as select * from rms.rpm_stage_item_loc;
delete from rms.rpm_stage_item_loc;


begin
insert into rpm_stage_item_loc 
select * from rpm_stage_item_loc_bk rl where not exists  (select 1 from rpm_stage_item_loc nil where nil.STAGE_ITEM_LOC_ID = rl.STAGE_ITEM_LOC_ID) and rownum <= ' 1000000';
delete from rpm_stage_item_loc_bk rl where exists ( select 1 from rpm_stage_item_loc nil where nil.STAGE_ITEM_LOC_ID = rl.STAGE_ITEM_LOC_ID);
  commit;
end;
/


begin
insert into rpm_stage_item_loc 
select * from rpm_stage_item_loc_bk rl where not exists 
    (select 1 from rpm_stage_item_loc nil where nil.STAGE_ITEM_LOC_ID = rl.STAGE_ITEM_LOC_ID) and rownum <= '100000';
delete from rpm_stage_item_loc_bk rl where exists ( select 1 from skumar.rpm_stage_item_loc nil where nil.STAGE_ITEM_LOC_ID = rl.STAGE_ITEM_LOC_ID);
commit;
end;
/


begin
insert into skumar.rpm_stage_item_loc_bk 
select * from rms.rpm_stage_item_loc rl where not exists 
    (select 1 from skumar.rpm_stage_item_loc_bk nil where nil.STAGE_ITEM_LOC_ID = rl.STAGE_ITEM_LOC_ID);
delete from rpm_stage_item_loc rl where exists ( select 1 from skumar.rpm_stage_item_loc_bk nil where nil.STAGE_ITEM_LOC_ID = rl.STAGE_ITEM_LOC_ID);
commit;
end;
/


select * from rpm_stage_item_loc;

--delete from rms.rpm_stage_item_loc where rownum <= '10000' order by 1;
select count(1) from rms.rpm_stage_item_loc_clean;


--- Price Changes

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE ='A' group by EFFECTIVE_DATE order by 1;   
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE ='W' group by EFFECTIVE_DATE order by 1;   
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS; -- 3000
select  EFFECTIVE_DATE,count(1) from rms.rpm_stage_price_change group by EFFECTIVE_DATE;
delete from rms.rpm_stage_price_change where status ='N';
delete from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE)> ='10-JAN-20';
select * from rpm_price_change where price_change_id in (select price_change_id from rpm_stage_price_change);
select * from ma_asos.ma_stage_price_change where status ='N';
select EFFECTIVE_DATE,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '01-MAR-20' and '30-MAR-20' and state ='pricechange.state.approved' group by EFFECTIVE_DATE; -- 5008
select state,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '01-MAR-20' and '30-MAR-20' group by state; -- 5008
select RIB_TYPE,count(1) from rpm_price_event_payload group by RIB_TYPE;
select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='RegPrcChg' and PUBLISH_STATUS ='0';

select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'RegPrcChg'; --329210


select loc,count(1) from (
select * from rpm_item_loc where (item,loc) in (select item,location from rms.rpm_price_change where EFFECTIVE_DATE ='02-MAR-20' and state ='pricechange.state.approved'))
group by loc; --20006	108319



--- Clearances
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N'  group by EFFECTIVE_DATE order by 1;  
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' and MESSAGE_TYPE ='A' group by EFFECTIVE_DATE order by 1;  
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' and MESSAGE_TYPE!='A' group by EFFECTIVE_DATE order by 1;  
select * from rms.rpm_stage_clearance ;
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select STATE,count(1) from rpm_clearance where clearance_id in (select clearance_id from clrtest31) group by STATE;
delete from rms.rpm_stage_clearance where status ='A' and rownum <='700';
delete from ma_asos.ma_stage_clearance;
update ma_asos.ma_stage_clearance set EFFECTIVE_DATE = '09-MAY-21' where rownum <= '600';
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '01-MAR-20' and '30-MAR-20'  and state ='pricechange.state.approved' group by EFFECTIVE_DATE order by 1; -- 5008
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '01-MAR-20' and '30-MAR-20'  and state!='pricechange.state.approved' group by EFFECTIVE_DATE order by 1; -- 5008
select state,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '01-MAR-20' and '30-MAR-20' group by state; -- 5008
select * from rms.rpm_stage_clearance where status ='E';
select RIB_TYPE,count(1) from rpm_price_event_payload group by RIB_TYPE;
select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='ClrPrcChg' and PUBLISH_STATUS ='1';
select * from RPM_CLEARANCE_PAYLOAD;
select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'ClrPrcChg';

select * from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'ClrPrcChg';


select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  

select rzl.location, count(1) from ma_asos.ma_stage_clearance msc , skulist_detail sd, rpm_zone_location rzl
    where msc.skulist = sd.skulist
        and trunc(effective_date) = '01-MAR-20'
        and msc.ZONE_ID = rzl.zone_id
        group by rzl.location; --30000

select loc,count(1) from (
select * from item_loc where (item,loc) in (select sd.item,rzl.location from ma_asos.ma_stage_clearance msc , skulist_detail sd, rpm_zone_location rzl
    where msc.skulist = sd.skulist
        and trunc(effective_date) = '01-MAR-20'
        and msc.ZONE_ID = rzl.zone_id)
union
select * from item_loc where (ITEM_PARENT,loc) in (select sd.item,rzl.location from ma_asos.ma_stage_clearance msc , skulist_detail sd, rpm_zone_location rzl
    where msc.skulist = sd.skulist
        and trunc(effective_date) = '01-MAR-20'
        and msc.ZONE_ID = rzl.zone_id)) group by loc;


select * from period;



--- Promotions 
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' group by PROMO_START_DATE order by 1;
select trunc(START_DATE),count(1) from rms.rpm_promo_dtl where START_DATE between '01-MAR-20' and '30-MAR-20' and state ='3' group by trunc(START_DATE) order by 1;
select state,count(1) from rms.rpm_promo_dtl where START_DATE between '01-MAR-20' and '30-MAR-20' group by state order by 1;
select START_DATE,count(1) from rms.rpm_promo_dtl where START_DATE between '01-MAR-20' and '30-MAR-20' and state !='3' group by START_DATE order by 1;
select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;  --E	1119
delete from rpm_stage_simple_promo;
delete from ma_asos.ma_stage_simple_promo where trunc(PROMO_START_DATE) = '02-AUG-20';`

select PROMO_START_DATE,count(1) from rms.rpm_stage_simple_promo group by PROMO_START_DATE order by 1;
Update rms.rpm_stage_simple_promo set STAGE_ID =rownum,status='N' where status in ('E','N');
delete from rms.rpm_stage_simple_promo where status in ('A','W');
delete from ma_asos.ma_stage_simple_promo where status ='N' and trunc(PROMO_START_DATE) ='02-AUG-20';
select * from rms.rpm_stage_simple_promo where status in ('E');
select RIB_TYPE,count(1) from rpm_price_event_payload group by RIB_TYPE;
select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='PrmPrcChg' and PUBLISH_STATUS ='0';
select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'PrmPrcChg'; --47 108 092

select ITEM, LOCATION from ma_asos.ma_stage_simple_promo where status ='N' and trunc(PROMO_START_DATE) ='02-MAR-20';


--Post -- intra day
--Pre -- overnight
 -- Outlet
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1;   
-- Reprice 
select count(1) from ma_asos.ma_reprice_process_control; --659993
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1;   

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1;   
select EFFECTIVE_DATE,count(1) from ma_asos.ma_price_change group by EFFECTIVE_DATE order by 1;   

--Post -- overnight
"C_DATE"	"PC_COUNT"	"PROMO_COUNT_START"	"PROMO_ACT_CNT_END"	"PROMO_APR_CNT_END"	"CLEARANCE_COUNT"	"CR_COUNT"

select calendar.c_date,
       NVL(price_change_count.cnt,0) pc_count,
       NVL(promo_cnt_start.cnt,0) promo_count_start,
       NVL(promo_act_cnt_end.cnt,0) promo_act_cnt_end,
       NVL(promo_apr_cnt_end.cnt,0) promo_apr_cnt_end,
       NVL(clearance_count.cnt,0) clearance_count,       
       NVL(clearance_reset_count.cnt,0) clearance_reset_count
  from (select TRUNC(start_date) st_date, count(1) cnt from rms.rpm_promo_dtl where state = '3' and trunc(start_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(start_date)) promo_cnt_start,
       (select TRUNC(end_date) end_date, count(1) cnt from rms.rpm_promo_dtl where state = '5' and trunc(end_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(end_date)) promo_act_cnt_end,  
       (select TRUNC(end_date) end_date, count(1) cnt from rms.rpm_promo_dtl where state = '3' and trunc(end_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(end_date)) promo_apr_cnt_end,  
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance where state = 'pricechange.state.approved' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) clearance_count,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_price_change where state = 'pricechange.state.approved' and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by trunc(effective_date)) price_change_count,
       (select trunc(effective_date) st_date, count(1) cnt from rms.rpm_clearance_reset where state = 'pricechange.state.approved'and trunc(effective_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy')  group by trunc(effective_date)) clearance_reset_count,       
        (SELECT to_date(:begin_date, 'mm/dd/yyyy'   ) + ROWNUM - 1 c_date
         FROM dual
         CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') 
                        - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = promo_cnt_start.st_date(+)
   and calendar.c_date = promo_act_cnt_end.end_date (+)
   and calendar.c_date = promo_apr_cnt_end.end_date (+)
   and calendar.c_date = price_change_count.st_date(+)
   and calendar.c_date = clearance_count.st_date(+)
   and calendar.c_date = clearance_reset_count.st_date(+)
order by calendar.c_date;


---Newitemloc

select count(1) from rms.rpm_stage_item_loc;
delete from rms.rpm_stage_item_loc;
select count(1) from rms.rpm_stage_item_loc_clean;

truncate table rpm_stage_item_loc;

begin
insert into rpm_stage_item_loc
select * from rpm_stage_item_loc_bk_12202018  where 
    STAGE_ITEM_LOC_ID not in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc) and rownum <= '723129';
commit;
end;
/

begin
insert into rpm_stage_item_loc_bk_12202018 
select * from rpm_stage_item_loc where STAGE_ITEM_LOC_ID not in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc_bk_12202018);
commit;
end;
/

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.rpm_stage_item_loc_bk_12202018 TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.rpm_stage_item_loc_bk_12202018 TO rdatla; 

truncate table rpm_stage_item_loc;

--delete from rms.rpm_item_loc where (item,loc) in (select item,loc from skumar.rpm_stage_item_loc_bk_12202018);
--delete from rpm_future_retail where (item,location) in (select item,loc from rpm_stage_item_loc_bk_12202018);
--commit;

select count(1) from rpm_stage_item_loc_bk_12202018;

select count(1) from rms.rpm_stage_item_loc;
delete from rms.rpm_stage_item_loc;
select count(1) from rms.rpm_stage_item_loc_clean;


begin
insert into rpm_stage_item_loc
select * from rpm_stage_item_loc_bk_12202018  where STAGE_ITEM_LOC_ID not in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc) and rownum <= '734129';
commit;
end;
/
*/

begin
delete from rpm_stage_item_loc  where (ITEM, LOC) in (select ITEM, LOC from rpm_item_loc);
delete from rpm_stage_item_loc  where (ITEM, LOC) not in (select ITEM, LOC from item_loc);
commit;
end;
/


select count(1) from rpm_stage_item_loc_bk_12202018;

select count(1) from rms.emer_price_hist;

select COUNT(1) from rms.rpm_event_itemloc;
select MESSAGE_DATE, count(1) from RMS.RPM_ITEM_MODIFICATION group by MESSAGE_DATE;

create table RPM_ITEM_MODIFICATION_bk as 
select * from RPM_ITEM_MODIFICATION;

delete from RPM_ITEM_MODIFICATION;

delete  from rms.RPM_ITEM_MODIFICATION where old_dept is null  or OLD_CLASS is null or OLD_SUBCLASS is null;

begin
delete from RMS.RPM_ITEM_MODIFICATION;
commit;
end;
/


select count(1) from rms.rpm_event_itemloc;
select * from rpm_batch_control;
delete from rms.rpm_event_itemloc where SELLING_UNIT_RETAIL is null;

select PRICE_CHG_TYPE,count(1) from rms.rpm_event_itemloc group by PRICE_CHG_TYPE;

select * from rpm;

--Price change  --
select count(1) from ma_asos.ma_stage_price_change; --14218
select count(1) from ma_stage_price_change_bk; --14218
select count(1) from ma_asos.ma_price_change; --404935
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N'  group by EFFECTIVE_DATE order by 1; 
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status!='N'  group by EFFECTIVE_DATE order by 1; 
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE ='A' group by EFFECTIVE_DATE order by 1; 
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE! ='A' group by EFFECTIVE_DATE order by 1; 
--delete from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE! ='A';
select * from ma_asos.ma_stage_price_change where status ='N' ;
select * from ma_asos.ma_stage_price_change where MESSAGE_TYPE! ='A';
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS;
select  STATUS,count(1) from rms.rpm_stage_price_change where error_message is not null group by STATUS;
select  * from rms.rpm_stage_price_change where error_message is not null;
select  STATUS,count(1) from rms.rpm_stage_price_change where error_message is null group by STATUS;
select  EFFECTIVE_DATE,count(1) from rms.rpm_stage_price_change group by EFFECTIVE_DATE;
select state,count(1) from rpm_price_change where EFFECTIVE_DATE between '23-DEC-18' and '26-DEC-18' group by state; --47741  / 46755 /52168
select EFFECTIVE_DATE,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '23-DEC-18' and '26-DEC-18' and state ='pricechange.state.approved' group by EFFECTIVE_DATE; 


select state,count(1) from rpm_price_change where EFFECTIVE_DATE between '23-DEC-18' and '10-MAY-21' group by state; --47741  / 46755 /52168

select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='RegPrcChg' and PUBLISH_STATUS ='0';
select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'RegPrcChg';
select count(1) from rms.RPM_PRICE_PUBLISH_DATA;
select * from rms.RPM_PRICE_PUBLISH_DATA;
-- clearance --
  
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N'  group by EFFECTIVE_DATE order by 1;  
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' and MESSAGE_TYPE ='A' group by EFFECTIVE_DATE order by 1; 
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' and MESSAGE_TYPE!='A' group by EFFECTIVE_DATE order by 1; 
--delete from ma_asos.ma_stage_clearance where status ='N' and MESSAGE_TYPE! ='A';
select * from ma_asos.ma_stage_clearance where status ='N' and MESSAGE_TYPE!='A';
select * from ma_asos.ma_stage_clearance where  status ='N' and MESSAGE_TYPE ='A';

select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS; -- A	3000/N	45723
select  EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance group by EFFECTIVE_DATE;
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select  STATUS,count(1) from rms.rpm_stage_clearance where error_message is not null group by STATUS;
select  STATUS,count(1) from rms.rpm_stage_clearance where error_message is null group by STATUS;
select  * from rms.rpm_stage_clearance where error_message is not null;
select  EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance group by EFFECTIVE_DATE;
select state,count(1) from rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '31-DEC-18' group by state;  --282376 / 279530 /  
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '31-DEC-18' and state ='pricechange.state.approved' group by EFFECTIVE_DATE order by 1; --

select state,count(1) from rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '10-MAY-21' group by state; --47741  / 46755 /52168

select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='ClrPrcChg' and PUBLISH_STATUS ='0';
select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'ClrPrcChg';


select * from ma_stage_simple_promo_bk;

drop table ma_stage_simple_promo_bk;
create table ma_stage_simple_promo_bk as
select * from ma_asos.ma_stage_simple_promo where item in (1725792,1738473);
delete from ma_stage_simple_promo_bk where item in (1725792,1738473);
delete from ma_asos.ma_stage_simple_promo where item not in (1725792,1738473);
select * from rpm_con_check_err;
select * from ma_asos.ma_stage_simple_promo where item in (1725792,1738473);
select * from rpm_stage_simple_promo where item in (1725792,1738473);
select * from rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo);
select * from rpm_con_check_err where REF_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo);
select * from rpm_con_check_err_detail where CON_CHECK_ERR_ID
    in (select CON_CHECK_ERR_ID from rpm_con_check_err where REF_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo));


select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo group by PROMO_START_DATE order by 1; 
-- promotions --update ma_asos.ma_stage_simple_promo set STAGE_ID= rownum where status ='N' and MESSAGE_TYPE ='A';
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' group by PROMO_START_DATE order by 1;  --13-NOV-18	7704,16-NOV-18	7008
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' and MESSAGE_TYPE='A' group by PROMO_START_DATE order by 1; 
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' and MESSAGE_TYPE!='A' group by PROMO_START_DATE order by 1; 
\
delete from ma_asos.ma_stage_simple_promo where status ='N' and MESSAGE_TYPE!='A' and rownum <= '7000';
--delete from ma_asos.ma_stage_simple_promo where status ='N' and MESSAGE_TYPE!='A';
select * from ma_asos.ma_stage_simple_promo;
delete from rpm_stage_simple_promo where status ='N' and MESSAGE_TYPE!='A' and rownum <= '7000';
select  PROMO_START_DATE,count(1) from rms.rpm_stage_simple_promo where status ='N' group by PROMO_START_DATE;
select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS; --rpm_stage_simple_promo
delete  from rpm_stage_simple_promo where status ='A' and rownum <='7000';
select  STATUS,count(1) from rms.rpm_stage_simple_promo where error_message is null group by STATUS;
select  * from rms.rpm_stage_simple_promo where STATUS ='A';
select  * from rms.rpm_stage_simple_promo where STATUS ='E';
select  PROMO_START_DATE,count(1) from rms.rpm_stage_simple_promo group by PROMO_START_DATE;
select state,count(1) from rpm_promo_dtl where START_DATE between '23-DEC-18' and '26-DEC-18' group by state; --18415 /18554 /226
select  * from rms.rpm_stage_simple_promo where STATUS ='A' and PROMO_DTL_ID  in (select PROMO_DTL_ID from rpm_promo_dtl where state ='0');
select START_DATE,count(1) from rpm_promo_dtl where START_DATE between '23-DEC-18' and '26-DEC-18' and state ='3' group by START_DATE order by 1; --
select state,count(1) from rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo where status ='A') group by state;

select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='PrmPrcChg' and PUBLISH_STATUS ='0';
select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'PrmPrcChg'; --47 108 092


-- clearance reset --
select status,count(1) from rms.rpm_stage_clearance_reset group by status;
select count(1) from rms.rpm_stage_clearance_reset;
select count(1) from rms.rpm_stage_clearance_reset where status ='E' and ERROR_MESSAGE is not null;
select distinct EFFECTIVE_DATE from rms.rpm_stage_clearance_reset where ERROR_MESSAGE is null;
select * from rms.rpm_stage_clearance_reset where status ='N' and ERROR_MESSAGE is null;
select * from RPM_CON_CHECK_ERR order by 1 desc;
select count(1) from rms.rpm_stage_clearance_reset where status ='W' and ERROR_MESSAGE is not null;
select count(1) from rms.rpm_stage_clearance_reset where status ='A';
delete from rms.rpm_stage_clearance_reset where status ='F';

select * from rms.RPM_PRICE_EVENT_PAYLOAD where PUBLISH_STATUS ='1';
select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'ClrPrcChg';

set SERVEROUTPUT ON;
set timing ON;
execute rms.rpm_nightly_batch_cleanup_sql.pre ();
execute rms.rpm_nightly_batch_cleanup_sql.post ();

delete from ma_asos.ma_stage_price_change where status ='N' and EFFECTIVE_DATE in ('29-JAN-19','31-JAN-19','08-APR-19','30-APR-19','25-MAY-19','01-JUN-19');
delete from ma_asos.ma_stage_clearance where status ='N';
delete from ma_asos.ma_stage_simple_promo where status ='N';
delete from rms.rpm_stage_simple_promo;
delete from rms.rpm_stage_price_change;
delete from rms.rpm_stage_clearance;


truncate table ma_asos.ma_stage_price_change;
truncate table ma_asos.ma_stage_clearance;
truncate table ma_asos.ma_stage_simple_promo;

truncate table rms.rpm_stage_simple_promo;
truncate table rms.rpm_stage_price_change;
truncate table rms.rpm_stage_clearance;
truncate table rpm_stage_item_loc;
truncate table rpm_stage_item_loc_clean;
truncate table emer_price_hist;
truncate table daily_purge;



begin
delete from ma_asos.ma_stage_price_change where status ='N';
delete from ma_asos.ma_stage_clearance where status ='N';
delete from ma_asos.ma_stage_simple_promo where status ='N';
delete from rms.rpm_stage_simple_promo;
delete from rms.rpm_stage_price_change;
delete from rms.rpm_stage_clearance;
delete from rpm_stage_item_loc;
delete from rpm_stage_item_loc_clean;
delete from emer_price_hist;
delete from rpm_price_publish_data;
delete from RPM_PRICE_EVENT_PAYLOAD;
commit;
end ;
/





-- raf_notification purge
-- email purge
-- fifglporefresh
-- Auto PO 




cd /orabin/app/oracle/product/retail/batch/external/data/out
rm nb_rms2dw_soh_*


select count(1) from RPM_ITEM_MODIFICATION;
select * from RPM_location_move;
select * from RPM_EVENT_ITEMLOC;

select vdate from period;
select status,count(1) from rpm_bulk_cc_pe_thread group by status;

select * from restart_program_status where program_status='completed';
--Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where program_status='completed';
--delete from rms.restart_bookmark;
select * from rms.restart_bookmark;

select * from rms.restart_program_status where program_name like ('%dlyprg%') ;
select * from restart_program_history where restart_name like '%saplgen%' order by 3 desc;
select * from rms.restart_program_status where program_status='completed';
select * from rms.restart_control where program_name like 'saimptlogfin';
--update restart_control set NUM_THREADS='1' where program_name like 'saimptlogfin';
Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where PROGRAM_name ='dtesys';
select * from rms.restart_bookmark where restart_name like 'salapnd';

select * from RMS.sa_STORE_DAY WHERE BUSINESS_DATE >= '10-NOV-21' order by 2,3 ;
select * from sa_tran_head order by update_datetime desc;


/*
Insert into restart_program_status 
(RESTART_NAME,THREAD_VAL,START_TIME,PROGRAM_NAME,PROGRAM_STATUS,RESTART_FLAG,RESTART_TIME,FINISH_TIME,CURRENT_PID,CURRENT_OPERATOR_ID,ERR_MESSAGE,CURRENT_ORACLE_SID,CURRENT_SHADOW_PID) 
values ('saimptlogfin',2,to_date('26-AUG-21 13:19:58','DD-MON-RR'),'saimptlogfin','ready for start',null,null,to_date('26-AUG-21 13:27:23','DD-MON-RR'),null,null,null,null,null);

Insert into restart_program_status 
(RESTART_NAME,THREAD_VAL,START_TIME,PROGRAM_NAME,PROGRAM_STATUS,RESTART_FLAG,RESTART_TIME,FINISH_TIME,CURRENT_PID,CURRENT_OPERATOR_ID,ERR_MESSAGE,CURRENT_ORACLE_SID,CURRENT_SHADOW_PID) 
values ('saimptlogfin',3,to_date('26-AUG-21 13:19:58','DD-MON-RR'),'saimptlogfin','ready for start',null,null,to_date('26-AUG-21 13:27:23','DD-MON-RR'),null,null,null,null,null);
*/

select * from sa_exported where store_day_Seq_no in ('273000401','273000402','273000403') and system_code='RMS' order by exp_datetime desc;

select * from v_sa_total order by update_Datetime desc;

select vdate from period;


select * from int_asos.INT_AUTO_CORRECTION_STG where loc='1011' and snap_id='1903';

select * from INT_ASOS.INT_AUTO_CORRECTION_LOG where DAY_DATE= '10-MAY-21';
select * from INT_ASOS.INT_BATCH_QUEUE order by create_date desc;

select * from int_asos.nb_system_parameters where func_area = 'NB_STOCK_ADJUST' AND parameter = 'LOCATION_LEVEL_THRESHOLD';

select * from nb_system_parameters where FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';

update nb_system_parameters set value_2 = TO_DATE('2021-11-09 04:00:16','YYYY-MM-DD HH:mi:ss')
WHERE FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';

select * from rms.sa_balance_group;

select * from NB_SYSTEM_PARAMETERS where FUNC_AREA = 'WAC_SNAPSHOT';

select * from rms.period;
select * from system_variables;

select distinct(half_no) from rms.MONTH_DATA_BUDGET;
select distinct(half_no) from rms.HALF_DATA;
select distinct(half_no) from rms.HALF_DATA_BUDGET;





/*
Insert into SYSTEM_VARIABLES (LAST_EOM_HALF_NO,LAST_EOM_MONTH_NO,LAST_EOM_DATE,NEXT_EOM_DATE,LAST_EOM_START_HALF,LAST_EOM_END_HALF,LAST_EOM_START_MONTH,LAST_EOM_MID_MONTH,LAST_EOM_NEXT_HALF_NO,LAST_EOM_DAY,LAST_EOM_WEEK,LAST_EOM_MONTH,LAST_EOM_YEAR,LAST_EOM_WEEK_IN_HALF,LAST_EOM_DATE_UNIT,NEXT_EOM_DATE_UNIT,LAST_EOW_DATE,LAST_EOW_DATE_UNIT,NEXT_EOW_DATE_UNIT,LAST_CONT_ORDER_DATE) 
values (20221,5,to_date('23-JAN-22','DD-MON-RR'),to_date('27-FEB-22','DD-MON-RR'),
to_date('30-AUG-21','DD-MON-RR'),to_date('27-FEB-22','DD-MON-RR'),to_date('27-DEC-21','DD-MON-RR'),
to_date('15-JAN-22','DD-MON-RR'),20222,7,4,1,2022,21,to_date('27-FEB-22','DD-MON-RR'),
to_date('27-MAR-22','DD-MON-RR'),to_date('27-FEB-22','DD-MON-RR'),to_date('27-FEB-22','DD-MON-RR'),to_date('06-MAR-22','DD-MON-RR'),null);

	
*/

select distinct(half_no), month_no from rms.MONTH_DATA group by half_no;

select * from calendar where year_454='2022';
select
case
when p.vdate = s.LAST_EOM_START_HALF then 'Y'
when ((p.vdate = s.LAST_EOM_END_HALF+1) and p.vdate = (p.end_454_half+1)) then 'Y'
else 'N'
end
from period p,
system_variables s;



select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21';
select * from INT_ASOS.INT_BATCH_QUEUE where batch_name='nb_stock_snapshot';


select * from v$database;   