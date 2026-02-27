select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS; -- 3000

select  * from rms.rpm_stage_price_change where STATUS = 'E'; -- 3000

979968
848642

select * from rms.rpm_batch_control where program_name like '%In%';
select * from rms.rpm_batch_control where program_name like '%Con%';`

select 1760246/(1760246+68364) from dual;

select count(1) from rms.item_master where item_level= '2'; --10.8M --10835255
select count(1) from rms.item_loc where loc = '20015'; --12.7M

select status,count(1) from rms.rpm_stage_item_loc group by status;
select count(1) from rms.rpm_item_loc where loc = '20015'; 
select count(1) from rms.rpm_item_loc where zone_id = '114'; --12.7M, select count(1) from rms.rpm_zone_future_retail where zone = '114'; --9.8m --10833271

select count(1) from rms.rpm_zone_future_retail where zone = '114'; --9.8m --10833271

select * from rms.rpm_zone_future_retail where zone = '114'; --200k, 

select * from rms.rpm_item_zone_price where zone_id = '114'; --200k, 
select * from rms.rpm_item_zone_price where item = '6272852'; --12304699
select * from rms.item_loc where item = '7381949'; --12304699
select * from rms.price_hist where item = '7381949' and loc in ('20010','20015'); --12304699
select * from rms.rpm_zone_future_retail where item = '11773698'; --12304699
select * from rms.item_loc where item_parent = '100013987' and loc in ('20010','20015'); --12304699

select count(1) from rpm_zone_future_retail where zone = '114'; --12304699
select count(1) from rpm_zone_future_retail where zone = '114'; --49, 40049, 50049, 210k, 


select * from rpm_item_zone_price where zone_id = '115'; --56,  1 4M
select * from item_loc where item = '128841734';
select * from rpm_future_retail where item = '128841609';

select * from rpm_item_zone_price where item = '128841734';
select * from rpm_item_zone_price where item = '128841734';
select * from item_loc where item = '128841609';
select * from item_master where item = '128841734';

select status,count(1) from rms.rpm_stage_item_loc group by status;
select * from rms.rpm_stage_item_loc_clean;
select THREAD_NUM,count(1) from rms.rpm_stage_item_loc_clean GROUP by THREAD_NUM;
select LOCATION,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location = '114' group by status,LOCATION;


select LOCATION,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where status != 'C' group by status,LOCATION;
select THREAD_NUMBER,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location = '114' group by THREAD_NUMBER,status ;
select LOCATION, THREAD_NUMBER, STATUS from rms.RPM_NIL_ROLLUP_THREAD group by LOCATION, THREAD_NUMBER, STATUS;


select THREAD_NUMBER,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location = '114' group by THREAD_NUMBER,status ;

select * from rms.rpm_batch_log where LOG_TIME >= to_date('11-AUG-2023 20.00', 'DD-MON-YYYY hh24:mi') 
-- and module like '%37%'
order by LOG_TIME desc;



select * from rms.rpm_batch_bookmark;
select * from rms.rpm_batch_control where program_name like '%In%';
select * from rms.rpm_batch_control where program_name like '%Con%';`
select * from rms.rpm_batch_control where program_name like '%New%';`

select * from rms.rpm_bulk_cc_pe order by 1 desc;
select status,count(1) from rms.rpm_bulk_cc_pe_thread group by status;
select * from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='45657689' order by 1 desc;
select PRICE_EVENT_START_DATE,count(1) from rpm_bulk_cc_pe_thread group by PRICE_EVENT_START_DATE;
select PRICE_EVENT_START_DATE,count(1) from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='45657689' group by PRICE_EVENT_START_DATE;
select * from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='45657689';
select status,count(1) from rms.rpm_bulk_cc_pe_thread  group by status;
select * from rpm_bulk_cc_pe_item where BULK_CC_PE_ID in (select BULK_CC_PE_ID from rpm_bulk_cc_pe_thread where trunc(PRICE_EVENT_START_DATE) = '27-JAN-2019');
select count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='45657689'  order by 1 desc; --71 92 703
select * from rms.RPM_PE_CC_LOCK;
select count(1) from rms.rpm_bulk_cc_pe_item; --14.4M records 

select count(1) from rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='45657689'  order by 1 desc;
select * from rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='45657689'  order by 1 desc;
select * from rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='45657689'  order by 1 desc;
select ITEM_PARENT,count(1) from rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='45657689' group by ITEM_PARENT order by 2 desc;
select ITEM_PARENT,count(1) from rpm_bulk_cc_pe_item group by ITEM_PARENT order by 2 desc;
