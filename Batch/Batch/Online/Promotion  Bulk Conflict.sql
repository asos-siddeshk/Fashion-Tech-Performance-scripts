select loc,status,count(1) from rms.rpm_stage_item_loc group by loc,status;
select count(1) from rms.rpm_stage_item_loc;
select count(1) from rms.rpm_stage_item_loc_clean;
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS; -- 3000
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo group by PROMO_START_DATE order by 1;
select STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;  
select location,STATUS,count(1) from rms.rpm_stage_simple_promo group by location,STATUS;  

select * from rms.rpm_bulk_cc_pe order by 1 desc;
select * from rms.rpm_bulk_cc_pe where status != 'C' order by 1 desc;
select * from rms.rpm_bulk_cc_pe where PRICE_EVENT_TYPE = 'SP' order by 1 desc;
select status,count(1) from rms.rpm_bulk_cc_pe_thread group by status;
select status,count(1) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278' group by status;
select PRICE_EVENT_START_DATE,count(1) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278' group by PRICE_EVENT_START_DATE;
select * from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278';
select * from rms.RPM_PE_CC_LOCK;
select count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278'; --18K
select count(1) from rms.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='52344278'; --52K
select status,count(1) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278' group by status;
select BULK_CC_PE_ID, THREAD_NUMBER, sum(ITEM_LOC_COUNT) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278' group by BULK_CC_PE_ID, THREAD_NUMBER;
select BULK_CC_PE_ID, THREAD_NUMBER, PRICE_EVENT_ID,sum(ITEM_LOC_COUNT) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278' group by BULK_CC_PE_ID, THREAD_NUMBER,PRICE_EVENT_ID;
select BULK_CC_PE_ID, THREAD_NUMBER, PRICE_EVENT_ID,sum(ITEM_LOC_COUNT) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278' and status = 'I' group by BULK_CC_PE_ID, THREAD_NUMBER,PRICE_EVENT_ID;

select * from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52344278'; --244k
select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278'; --244k
select * from rms.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='52344278'; --244k

select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'PC') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'SP') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'CL') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'CL') group by location; --350k

select * from rms.rpm_zone_location where zone_id = '101';

select * from rms.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='52344278'  order by 1 desc;
select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278'  order by 1 desc;
select ITEM_PARENT,count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278' group by ITEM_PARENT order by 2 desc;

select * from rms.rpm_bulk_cc_pe_thread where item = '132946538';
select * from rms.rpm_bulk_cc_pe_item where item = '132946538';
select * from rms.rpm_bulk_cc_pe_location where PRICE_EVENT_ID = '374570744';

select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278';
select PRICE_EVENT_ID, ITEM, MERCH_LEVEL_TYPE,count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278' group by PRICE_EVENT_ID, ITEM, MERCH_LEVEL_TYPE;
select PRICE_EVENT_ID, ITEM,count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52344278' group by PRICE_EVENT_ID, ITEM;

select count(1) from rms.RPM_PRICE_PUBLISH_DATA where EVENT_FAMILY like 'PrmPrcChg'; --485957


select * from rms.rpm_clearance where item = '136643728';
select * from rms.rpm_price_change where item = '136643728';
select * from ma_asos.ma_price_change where item = '136643728';
select * from ma_asos.MA_RPM_PRICE_CHANGE_HIST where item = '136643728';
select * from rms.item_master where item_parent = '136643728';
select * from rms.rpm_future_retail where item in (select item from rms.item_master where item_parent = '136643728');
select * from rms.rpm_future_retail where item in (select item from rms.item_master where item_parent = '136643728' or item = '136643728');

select * from rms.rpm_batch_log where to_date = trunc ('08-OCT-19 10.12.47.413780000');


