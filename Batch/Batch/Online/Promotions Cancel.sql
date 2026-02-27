select * from rms.RPM_PRICE_EVENT_PAYLOAD where rib_family ='PrmPrcChg'; --52557603
select * from rms.RPM_PRICE_PUBLISH_DATA;



select state, count(1) from rms.rpm_promo_dtl where  promo_comp_id in (select distinct PROMO_COMP_ID from rms.rpm_promo_dtl where state in ('8','9')) group by state;

select * from rms.rpm_promo_comp where PROMO_COMP_ID in (select distinct PROMO_COMP_ID from rms.rpm_promo_dtl where state in ('8','9'));
select count(1) from rms.rpm_promo_dtl where state in ('8','9') ;
select distinct PROMO_COMP_ID from rms.rpm_promo_dtl where state in ('8','9') ;

select * from rms.rpm_bulk_cc_pe;
select * from rms.rpm_bulk_cc_pe order by 1 desc; --51805704
select * from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'SP';
select status,count(1) from rms.rpm_bulk_cc_pe_thread group by status;
select BULK_CC_PE_ID,status,count(1) from rms.rpm_bulk_cc_pe_thread group by BULK_CC_PE_ID,status order by 1 desc;
select * from rms.RPM_PE_CC_LOCK;
select count(1) from rms.rpm_bulk_cc_pe_item; --244k
select count(1) from rms.rpm_bulk_cc_pe_location; --244k
select BULK_CC_PE_ID,location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'SP') group by BULK_CC_PE_ID,location order by 1 desc; --350k
select location,count(1) from rms.rpm_bulk_cc_pe_location where bulk_cc_pe_id in (select BULK_CC_PE_ID from rms.rpm_bulk_cc_pe_thread where PRICE_EVENT_TYPE = 'SP') group by location; --350k
select * from rms.rpm_bulk_cc_pe_location; --350k

SELECT task_id,                
       status        ,         
       description   ,         
       owner         ,         
       to_char(date_published,'dd-mon-yy hh:mi:ss am') date_published ,         
       to_char(process_start_date,'dd-mon-yy hh:mi:ss am') process_start_date,
       to_char(process_end_date,'dd-mon-yy hh:mi:ss am') process_end_date,
       command_class          ,
       parent_task_id 
  FROM rms.rpm_task --where Description like '%1351317%' and rownum <= 500
ORDER BY task_id desc;

select * from all_tables where table_name like 'RPM_%THREAD%';



select * from rms.RPM_BULK_CC_PE_CHUNK;
select * from rms.RPM_BULK_CC_TASK;
select * from rms.RPM_BULK_CC_PE_LOCATION;
select * from rms.RPM_BULK_CC_PE_ITEM;
select * from rms.RPM_BULK_CC_PE_ITEM_GTT;
select * from rms.RPM_BULK_CC_PE;
select * from rms.RPM_BULK_CC_PE_THREAD;
select * from rms.RPM_ITEMLOC_THREAD;

select node.item,
       NVL(rzl.location, rzl.zone_id) loc,rp.promo_id, rp.promo_display_id, comp.PROMO_COMP_ID, comp.comp_display_id, 
       dtl.promo_dtl_id,dtl.promo_dtl_display_id, dtl.start_date, dtl.end_date,
       dsc.change_type, NVL(dsc.change_percent, dsc.change_amount) discount, dtl.price_guide_id,
       decode(dtl.state, 0, 'worksheet', 1, 'rejected', 2, 'submitted', 3, 'approved', 
                         4, 'cancelled', 5, 'active', 6, 'complete', 7, 'conflict checking', 8, 'pending', 9, 'cancel pending','n/a') state,
   --    DECODE(expl.promo_dtl_id, null, 'NO', 'YES') flowed,
       dtl.create_id, to_char(dtl.approval_date, 'DD/Mon/YYYY: HH24:MM:SS') approval_date,
       dtl.approval_id, to_char(dtl.create_date, 'DD/Mon/YYYY: HH24:MM:SS') create_date
from rms.rpm_promo_dtl dtl,
     rms.rpm_promo_dtl_merch_node node,
     rms.rpm_promo_zone_location rzl,
     rms.rpm_promo_dtl_list_grp grp,
     rms.rpm_promo_dtl_list lst,
     rms.rpm_promo_dtl_disc_ladder dsc,
     rms.rpm_promo_comp comp,
     rms.rpm_promo rp,
     rms.item_master im,
     rms.rpm_promo_item_loc_expl expl
where node.promo_dtl_id = dtl.promo_dtl_id
and rzl.promo_dtl_id = dtl.promo_dtl_id
and node.promo_dtl_id = rzl.promo_dtl_id
and grp.promo_dtl_id = dtl.promo_dtl_id
and lst.promo_dtl_list_grp_id = grp.promo_dtl_list_grp_id
and lst.promo_dtl_list_id = dsc.promo_dtl_list_id
and comp.promo_comp_id = dtl.promo_comp_id
and rp.promo_id = comp.promo_id
and im.item = node.item
--and im.item = '100267247'
and rp.promo_display_id in ('194097')
and dtl.promo_dtl_id = expl.promo_dtl_id(+)
order by node.item, rzl.location, approval_date desc, dtl.start_date;

select node.item, decode(item_level, tran_level, 'SKU', 'Option') item_type,
       NVL(rzl.location, rzl.zone_id) loc, rp.promo_display_id, comp.comp_display_id,
       dtl.promo_dtl_display_id, dtl.start_date, dtl.end_date,
       dsc.change_type, NVL(dsc.change_percent, dsc.change_amount) discount, dtl.price_guide_id,
       decode(dtl.state, 0, 'worksheet', 1, 'rejected', 2, 'submitted', 3, 'approved', 
                         4, 'cancelled', 5, 'active', 6, 'complete', 7, 'conflict checking', 8, 'pending', 9, 'cancel pending','n/a') state,
       dtl.create_id, to_char(dtl.approval_date, 'DD/Mon/YYYY: HH24:MM:SS') approval_date,
       dtl.approval_id, to_char(dtl.create_date, 'DD/Mon/YYYY: HH24:MM:SS') create_date
from rms.rpm_promo_dtl dtl,
     rms.rpm_promo_dtl_merch_node node,
     rms.rpm_promo_zone_location rzl,
     rms.rpm_promo_dtl_list_grp grp,
     rms.rpm_promo_dtl_list lst,
     rms.rpm_promo_dtl_disc_ladder dsc,
     rms.rpm_promo_comp comp,
     rms.rpm_promo rp,
     rms.item_master im
where node.promo_dtl_id = dtl.promo_dtl_id
and rzl.promo_dtl_id(+) = dtl.promo_dtl_id
and node.promo_dtl_id = rzl.promo_dtl_id
and grp.promo_dtl_id = dtl.promo_dtl_id
and lst.promo_dtl_list_grp_id = grp.promo_dtl_list_grp_id
and lst.promo_dtl_list_id = dsc.promo_dtl_list_id
and comp.promo_comp_id = dtl.promo_comp_id
and rp.promo_id = comp.promo_id
and im.item = node.item
and comp.promo_comp_id in ('86565')
order by node.item, rzl.location, approval_date desc, dtl.start_date;


select * from rms.rpm_promo_dtl where state in ('8','9');
select * from rms.item_master where item_parent = '100988079';
select * from rms.rpm_zone_location where zone_id = '104';
