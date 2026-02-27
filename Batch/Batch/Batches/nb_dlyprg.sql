-- UPL
    select distinct (upl.process_seq) -- 71
      from ma_asos.ma_system_options so,
           ma_asos.ma_stg_upload_process_line upl
     where upl.upload_datetime <= rms.get_vdate - so.ma_item_purge_days
     order by process_seq asc;

select ma_item_purge_days from ma_asos.ma_system_options;
select * from ma_asos.ma_stg_upload_process_line;
select process_seq,count(1) from ma_asos.ma_stg_upload_process_line group by process_seq;

Update ma_asos.ma_stg_upload_process_line set upload_datetime = rms.get_vdate - 2 where trunc(UPLOAD_DATETIME) = '27-FEB-22';

--Item
select LAST_UPDATE_DATETIME,count(1) from ma_asos.ma_stg_item_head group by LAST_UPDATE_DATETIME order by 1 ;
select LAST_UPDATE_DATETIME,count(1) from ma_asos.ma_stg_item_size group by LAST_UPDATE_DATETIME order by 1 ;

select count(1) from ma_asos.ma_stg_item_size ;


select count(distinct (h.item)) --4220
    from ma_asos.ma_stg_item_head h,
         ma_asos.ma_stg_item_size s,
         ma_asos.ma_stg_item_barcode b,
         ma_asos.ma_system_options so
   where h.item = s.option_id(+)
     and s.sku_id = b.sku_id(+)
     and h.last_update_datetime < rms.get_vdate - so.ma_item_purge_days
     and (s.last_update_datetime is null or s.last_update_datetime < (rms.get_vdate - so.ma_item_purge_days))
     and (b.last_update_datetime is null or b.last_update_datetime < (rms.get_vdate - so.ma_item_purge_days))
   group by h.item;

select * from ma_asos.ma_stg_item_head where last_update_datetime < get_vdate - so.ma_item_purge_days;

update ma_asos.ma_stg_item_head set LAST_UPDATE_DATETIME = rms.get_vdate - 8 where rownum<='500';


-- rms dele

select distinct t.item
    from (
            select h.item
              from ma_asos.ma_item_restrictions h
             where not exists (select 1
                                 from item_master
                                where item = h.item)
             union
            select f.item
              from ma_asos.ma_item_fabric_comp f
             where not exists (select 1
                                 from item_master
                                where item = f.item)
             union
            select g.item
              from ma_asos.ma_group_detail g
             where not exists (select 1
                                 from item_master
                                where item = g.item)
             union
            select p.item
              from ma_asos.ma_item_pub_info p
             where not exists (select 1
                                 from item_master
                                where item = p.item)
             union
            select p.item
              from ma_asos.ma_item_attributes p
             where not exists (select 1
                                 from item_master
                                where item = p.item)
    ) t
    where not exists (select 1
                        from ma_asos.ma_stg_item_head
                       where item   = t.item
                         and status = 'W');

--Price --

  SELECT pc.trans_id,
         pc.price_change_id
    FROM ma_asos.ma_price_change pc,
         rpm_system_options so
   WHERE pc.status = 'W'
     AND pc.effective_date < (get_vdate - so.reject_hold_days_pc_clear)
   GROUP BY pc.trans_id,
            pc.price_change_id;

select reject_hold_days_pc_clear from rpm_system_options;


----Cost change
select retention_of_rejected_cost_chg,vdate from system_options, period;
select * from ma_asos.ma_cost_change;

  SELECT c.trans_id,
         c.cost_change_id
    FROM ma_asos.ma_cost_change c,
         system_options so
   WHERE c.status = 'W'
     AND c.effective_date < (get_vdate - so.retention_of_rejected_cost_chg)
   GROUP BY c.trans_id,
            c.cost_change_id;

 select * from ma_asos.ma_cost_change;

 update ma_asos.ma_cost_change set effective_date = (get_vdate - 100) where status ='W' and rownum<='1000';
            
            
            
-- Orders

  select count(o.master_order_no)
    from ma_asos.ma_stg_order o,
         ma_asos.ma_system_options so
   where (
          o.create_datetime < get_vdate - so.po_purge_days
          and
          (o.status = 'W' or o.status = 'S')
         )
      or o.status = 'A';
 select po_purge_days from ma_asos.ma_system_options;

 Update ma_asos.ma_stg_order set create_datetime = get_vdate -31 where status in ('W','S') and rownum<='800';
 
 
 -- Recomendations 
   select to_number(value_1) as days --180
    from nb_system_parameters
   where func_area = 'RECOMMENDATIONS'
     and parameter = 'PURGE_DAYS';


select distinct p.order_rec_no as order_no
    from ma_asos.ma_order_rec_head_stg p
   where p.create_datetime < get_vdate - 30;
   
   update  ma_asos.ma_order_rec_head_stg set CREATE_DATETIME = get_vdate - 31 where rownum<='800';
   
-- Logs

  select so.ma_logs_purge_days
    from ma_asos.ma_system_options so;

select * from ma_asos.ma_logs
   where trunc(log_ts) < get_vdate - 7;
 
 select trunc(LOG_TS),count(1) from ma_asos.ma_logs group by trunc(LOG_TS) order by 1;
 
 --select DATE_SUB(LOG_TS INTERVAL '1' DAY) from ma_asos.ma_logs;
  
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
 l_LOG_TS           date ;

BEGIN
for m in 0..0 loop        
for k in 0..20 loop        
--select sysdate into l_LOG_TS from dual;        
select vdate into l_LOG_TS from period;
        
 insert into ma_asos.ma_logs
  select MA_ASOS.MA_LOG_SEQ.nextval,MA_ID, LOG_LEVEL, PROGRAM_NAME, l_LOG_TS -k,
  LOG_USER, MSG_CODE, AUX_1, AUX_2, AUX_3, AUX_4, AUX_5, BACKTRACE_DESC, SESS_SID, SESS_ID, SESS_USER, DB_INSTANCE, DB_INSTANCE_NAME, USER_HOST, USER_IP_ADDRESS, OS_USER, APP_USER, AUX_6
  from ma_asos.ma_logs where trunc(log_ts) ='07-JAN-24';
  
end loop;
 end loop;
 commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
 
 
 
 select *
    from ma_asos.ma_stg_item_buy_hier_reclass r
   where r.process_status = 'N';
 
 
 