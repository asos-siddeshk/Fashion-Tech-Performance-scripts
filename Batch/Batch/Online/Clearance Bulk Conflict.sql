select * from rms.rpm_stage_item_loc;
select status,count(1) from rms.rpm_stage_item_loc group by status;
select count(1) from rms.rpm_stage_item_loc_clean;
--insert into rms.rpm_stage_item_loc select * from new_item_loc_batch;
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS; -- 3000
--insert into ma_asos.ma_stage_price_change  select * from ma_stage_price_change_bk ;
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
--insert into ma_asos.ma_stage_clearance select * from ma_stage_clearance_bk ;
select PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo group by PROMO_START_DATE order by 1;
select ZONE_NODE_TYPE, ZONE_ID, LOCATION,count(1) from ma_asos.ma_stage_simple_promo group by ZONE_NODE_TYPE, ZONE_ID, LOCATION order by 1;
select PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo group by PROMO_START_DATE order by 1;
--INSERT INTO ma_asos.ma_stage_simple_promo SELECT * FROM ma_stage_simple_promo_bk;
select * from ma_asos.ma_stage_simple_promo;
select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;



select EFFECTIVE_DATE,zone_id,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE,zone_id order by 1;  
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1;  
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select  zone_id,status,count(1) from rms.rpm_stage_clearance group by zone_id,status order by 1,2;
delete from ma_asos.ma_stage_clearance;

select * from rms.rpm_bulk_cc_pe  order by 1 desc;
select * from rms.rpm_bulk_cc_pe where status != 'C' order by 1 desc;
select * from rms.rpm_bulk_cc_pe where PRICE_EVENT_TYPE = 'CL' order by 1 desc;
select * from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'CL';
select status,count(1) from rms.rpm_bulk_cc_pe_thread group by status;
select status,count(1) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026' group by status;
select PRICE_EVENT_START_DATE,count(1) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026' group by PRICE_EVENT_START_DATE;
select * from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026';
select * from rms.RPM_PE_CC_LOCK;
select * from rms.RPM_zone_location where zone_id = '102';
select count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026'; --18K
select count(1) from rms.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='52347026'; --52K
select status,count(1) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026' group by status;
select BULK_CC_PE_ID, THREAD_NUMBER, sum(ITEM_LOC_COUNT) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026' group by BULK_CC_PE_ID, THREAD_NUMBER;
select BULK_CC_PE_ID, THREAD_NUMBER, PRICE_EVENT_ID,sum(ITEM_LOC_COUNT) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026' group by BULK_CC_PE_ID, THREAD_NUMBER,PRICE_EVENT_ID;
select BULK_CC_PE_ID, THREAD_NUMBER, PRICE_EVENT_ID,sum(ITEM_LOC_COUNT) from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026' and status = 'I' group by BULK_CC_PE_ID, THREAD_NUMBER,PRICE_EVENT_ID;

select * from rms.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='52347026'; --244k
select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026'; --244k
select * from rms.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='52347026'; --244k

select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'PC') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'SP') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'CL') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'CL') group by location; --350k

select * from rms.rpm_zone_location where zone_id = '101';

select * from rms.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='52347026'  order by 1 desc;
select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026'  order by 1 desc;
select ITEM_PARENT,count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026' group by ITEM_PARENT order by 2 desc;
select ITEM_PARENT,count(1) from rpm_bulk_cc_pe_item group by 52347026 order by 2 desc;

select * from rms.rpm_bulk_cc_pe_thread where item = '132946538';
select * from rms.rpm_bulk_cc_pe_item where item = '132946538';
select * from rms.rpm_bulk_cc_pe_location where PRICE_EVENT_ID = '374570744';

select * from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026';
select PRICE_EVENT_ID, ITEM, MERCH_LEVEL_TYPE,count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026' group by PRICE_EVENT_ID, ITEM, MERCH_LEVEL_TYPE;
select PRICE_EVENT_ID, ITEM,count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='52347026' group by PRICE_EVENT_ID, ITEM;




select 'Clearance_Events_in_MA_clearance' phase,
       nvl(mssp.location, mssp.zone_id) "LOCATION",
       rz.name,
       count(*)
  from ma_asos.ma_stage_clearance mssp, rms.item_master im,
       rms.rpm_zone rz
where mssp.item = im.item
and    mssp.zone_id = rz.zone_id
group by nvl(mssp.location, mssp.zone_id),rz.name 
union
select 'Clearance_Events_in_RPM_STAGGING' phase,
       nvl(mssp.location, mssp.zone_id) "LOCATION",
       rz.name,
       count(*)
  from rms.rpm_stage_clearance mssp, rms.item_master im,
       rms.rpm_zone rz
where mssp.item = im.item
and    mssp.zone_id = rz.zone_id
group by nvl(mssp.location, mssp.zone_id),rz.name 
union
select 'Clearance_Events_in_RPM' phase,
       nvl(mssp.location, mssp.zone_id) "LOCATION",
       rz.name,
       count(*)
  from rms.rpm_clearance mssp, rms.item_master im,
       rms.rpm_zone rz
where mssp.item = im.item
and    mssp.zone_id = rz.zone_id
and     trunc(mssp.CREATE_DATE) = to_date('20240726', 'YYYYMMDD')
and     state = 'pricechange.state.approved'
group by nvl(mssp.location, mssp.zone_id),rz.name 
union
select 'Clearance_Events_in_RPM_Worksheet' phase,
       nvl(mssp.location, mssp.zone_id) "LOCATION",
       rz.name,
       count(*)
  from rms.rpm_clearance mssp, rms.item_master im,
       rms.rpm_zone rz
where mssp.item = im.item
and    mssp.zone_id = rz.zone_id
and     trunc(mssp.CREATE_DATE) = to_date('20240726', 'YYYYMMDD')
and     state = 'pricechange.state.worksheet'
group by nvl(mssp.location, mssp.zone_id),rz.name 
union
select 'Clearance_Events_in_RPM_Conflict_checking' phase,
       nvl(mssp.location, mssp.zone_id) "LOCATION",
       rz.name,
       count(*)
  from rms.rpm_clearance mssp, rms.item_master im,
       rms.rpm_zone rz
where mssp.item = im.item
and    mssp.zone_id = rz.zone_id
and     trunc(mssp.CREATE_DATE) = to_date('20240726', 'YYYYMMDD')
and     state = 'pricechange.state.conflictChecking'
group by nvl(mssp.location, mssp.zone_id),rz.name 
order by 1,2;




select * from rms.rpm_bulk_cc_pe_item;
select * from rms.rpm_bulk_cc_pe_location;
select * from rms.rpm_bulk_cc_pe_thread;



select * from asosbackup.rpm_bulk_cc_pe_item_24_JUL_24 WHERE bulk_cc_pe_id = '52317022';
select * from asosbackup.rpm_bulk_cc_pe_location_24_JUL_24 WHERE bulk_cc_pe_id = '52317022';
select * from asosbackup.rpm_bulk_cc_pe_thread_24_JUL_24  WHERE bulk_cc_pe_id = '52317022';
select * from asosbackup.rpm_bulk_cc_pe_24_jul_24 WHERE bulk_cc_pe_id = '52317022';



               
SELECT /*+ USE_HASH(il, rc) */ IL.price_event_id,IL.item,IL.location,
                               Rowidtochar(RC.rowid)
FROM   (SELECT /*+ ORDERED */ RBCPI.price_event_id,
                              RBCPI.item,
                              RBCPL.location,
                              RBCPL.zone_node_type
        FROM   rms.rpm_bulk_cc_pe_thread RBCPT,
               rms.rpm_bulk_cc_pe_item RBCPI,
               rms.rpm_bulk_cc_pe_location RBCPL
        WHERE  RBCPT.bulk_cc_pe_id = '52317022'
               AND RBCPT.parent_thread_number = '1'
               AND RBCPT.thread_number = '48'
               AND RBCPI.bulk_cc_pe_id = RBCPT.bulk_cc_pe_id
               AND RBCPI.price_event_id = RBCPT.price_event_id
               AND RBCPI.merch_level_type = '6'
               AND RBCPL.itemloc_id = RBCPI.itemloc_id
               AND RBCPL.price_event_id = RBCPI.price_event_id
               AND RBCPL.bulk_cc_pe_id = RBCPI.bulk_cc_pe_id
               AND RBCPL.zone_node_type IN ( '0','2' )) IL,
       rms.rpm_clearance_reset RC
WHERE  RC.item = IL.item
       AND RC.location = IL.location
       and rc.state    != 'pricechange.state.executed'
       AND ( RC.effective_date IS NULL
              OR RC.effective_date >= '29-JUL-24'); 

  select  /*+ USE_HASH(il,rc) */
             rms.OBJ_NUM_STR_STR_REC(il.price_event_id,
                                 ROWIDTOCHAR(rc.rowid),
                                 NULL)
        from (select /*+ ORDERED */
                     rbcpi.price_event_id,
                     rbcpi.item,
                     rbcpl.location,
                     rbcpl.zone_node_type
                from table(cast(I_price_event_ids as OBJ_NUMERIC_ID_TABLE)) ids,
                     rms.rpm_bulk_cc_pe_thread rbcpt,
                     rms.rpm_bulk_cc_pe_item rbcpi,
                     rms.rpm_bulk_cc_pe_location rbcpl
               where rbcpt.price_event_id       = VALUE(ids)
                 and rbcpt.bulk_cc_pe_id        = I_bulk_cc_pe_id
                 and rbcpt.parent_thread_number = I_pe_sequence_id
                 and rbcpt.thread_number        = I_thread_number
                 and rbcpi.bulk_cc_pe_id        = rbcpt.bulk_cc_pe_id
                 and rbcpi.price_event_id       = rbcpt.price_event_id
                 and rbcpi.merch_level_type     = RPM_CONSTANTS.ITEM_MERCH_TYPE
                 and rbcpl.itemloc_id           = rbcpi.itemloc_id
                 and rbcpl.price_event_id       = rbcpi.price_event_id
                 and rbcpl.bulk_cc_pe_id        = rbcpi.bulk_cc_pe_id
                 and rbcpl.zone_node_type       IN (RPM_CONSTANTS.ZONE_NODE_TYPE_STORE,
                                                    RPM_CONSTANTS.ZONE_NODE_TYPE_WAREHOUSE)
                 and NVL(rbcpi.chunk_number, 0) = I_chunk_number) il,
             rms.rpm_clearance_reset rc
       where rc.item      = il.item
         and rc.location  = il.location
         and rc.state    != RPM_CONSTANTS.PC_EXECUTED_STATE_CODE
         and (   rc.effective_date is NULL
              or rc.effective_date >= LP_vdate)
         for update of rc.clearance_id nowait;
         
         
         