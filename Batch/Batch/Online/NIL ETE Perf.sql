select status,count(1) from rms.rpm_stage_item_loc group by status; --11 155 732 -- 1M
select * from rms.rpm_stage_item_loc where ERROR_MSG is not null;
select count(1) from rms.rpm_stage_item_loc_clean ;
select THREAD_NUM,count(1) from rms.rpm_stage_item_loc_clean group by THREAD_NUM;

select count(1) from rms.item_loc where (item,loc) in (select item,loc from rms.rpm_stage_item_loc_clean);        -- 412184

select * from rms.rpm_item_loc where (item,loc) in (select item,loc from rms.rpm_stage_item_loc_clean);           -- 412184
select * from rms.rpm_future_retail where (item,location) in (select item,loc from rms.rpm_stage_item_loc_clean); -- 407194


select * from rms.rpm_future_retail where item in( select item from rms.item_master where item = '101135538' or item_parent = '101135538') 
    and location in ('114','20015');
select * from rms.rpm_promo_item_loc_expl where item = '101135538';
select * from rms.rpm_promo_item_loc_expl where item = '101135538';

select * from rms.RPM_CHUNK_CC_TASK order by 1 desc; --10735134
select * from rms.RPM_NIL_BULKCCPE_PROCESS_ID order by 1 desc; --10735134

select status,count(1) from rms.rpm_bulk_cc_pe_thread group by status;

select * from all_tables where table_name like '%CHUNK%';

select * from rms.RPM_BATCH_RUN_HISTORY where trunc(LOG_DATETIME) = '04-AUG-2023' order by 1 desc;

select * from rms.RPM_NIL_ROLLUP_THREAD;

select * from rms.RPM_CHUNK_CC_TASK;
select * from rms.RPM_TASK order by 1 desc;


select status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location in ('114','20015') group by status;

select status,thread_number,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location in ('114','20015') group by status,thread_number;
select status,thread_number,count(*) from rms.RPM_NIL_ROLLUP_THREAD where  status != 'C' and location in ('114','20015') group by status,thread_number;

select * from rms.RPM_NIL_ROLLUP_THREAD where status != 'C' and location != '114';



select * from rms.rpm_batch_control;

select * from rms.rpm_nil_bulkccpe_process_id;
select * from rms.RPM_NIL_ROLLUP_THREAD where status != 'C' and location = '114';
select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID not in (select BULK_CC_PE_ID from rms.rpm_nil_bulkccpe_process_id);
select * from rms.rpm_bulk_cc_pe_item;
select * from rms.rpm_bulk_cc_pe;
select count(1) from rms.rpm_stage_item_loc_clean ;

select * from rms.logger_logs where id >= '540047242' order by 1 desc;

select * from all_Sequences where sequence_name like '%LOGGER%';
select LOCATION,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD group by status,LOCATION;

select count(1) from rms.RPM_NIL_ROLLUP_THREAD; --178741

com.retek.rpm.batch.NewItemLocBatch	32	5000
com.retek.rpm.batch.NewItemLocRollUpBatch	8	5000	 

com.retek.rpm.batch.NewItemLocBatch	16	50000
com.retek.rpm.batch.NewItemLocRollUpBatch	8	5000

select status,count(1) from rms.rpm_stage_item_loc group by status; --11 155 732 -- 1M
select count(1) from rms.rpm_stage_item_loc_clean ;
select THREAD_NUM,count(1) from rms.rpm_stage_item_loc_clean group by THREAD_NUM;
select * from rms.rpm_stage_item_loc_clean where thread_num = '21';

select * from rms.rpm_batch_log where LOG_TIME >= to_date('11-AUG-2023 13.00', 'DD-MON-YYYY hh24:mi') 
-- and module like '%37%'
order by LOG_TIME ;

select * from rms.RPM_NIL_ROLLUP_THREAD where thread_number = '60';

select * from rms.rpm_batch_bookmark;
select * from rms.rpm_batch_control where program_name like '%In%';
select * from rms.rpm_batch_control where program_name like '%Con%';`
select * from rms.rpm_batch_control where program_name like '%New%';`

select LOCATION,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD group by status,LOCATION;
select THREAD_NUMBER,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location = '114' group by THREAD_NUMBER,status ;
select LOCATION, THREAD_NUMBER, STATUS from rms.RPM_NIL_ROLLUP_THREAD group by LOCATION, THREAD_NUMBER, STATUS;
select LOCATION,status,count(*) from rms.RPM_NIL_ROLLUP_THREAD where location = '114' group by status,LOCATION;

select count(1) from rms.RPM_future_retail where location in ('20015','114');   --200790, 595634 , 436533
select count(1) from rms.rpm_item_loc where loc = '20015';                      --907296, 1327007, 1469791
