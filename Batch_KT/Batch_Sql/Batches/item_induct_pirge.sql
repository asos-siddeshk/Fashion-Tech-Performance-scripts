select * from rms.sups where supplier in (1100000086,1100001188,1000000020,1000000086,1000001188);

select * from ma_asos.ma_logs where trunc(LOG_TS) = trunc(sysdate) order by LOG_TS  desc;

select * from all_Sequences where sequence_name like 'LOGGER%';

select * from logger_logs where id BETWEEN 133526977 and 133546977 order by 1 desc;
select * from coresvc_po_err;
select * from coresvc_po_err where PROCESS_ID = '844584' ;

select * from CORESVC_ITEM_ERR;
select * from all_tables where table_name like 'CORE%ERR'


/*
---------------------------Batch name:itm_indctn_purge----------------------------------
2.Records to be updated in RMS.svc_process_tracker tables								:RMS.svc_process_tracker. 
3.Batch execution 														:RMS.svc_process_tracker via Automic.
--------------------------------------------------------------------------------------------------
*/

set serveroutput on;
set timing on;

declare
begin
for i in 1 .. 9000 ---- change the valume wise records here 
loop    
insert into RMS.svc_process_tracker(
							 PROCESS_ID,
							 PROCESS_DESC ,
                             PROCESS_DESTINATION,
                             STATUS,
							 TEMPLATE_KEY,
							 ACTION_TYPE ,
							 ACTION_DATE,
                             USER_ID ) 
values(
							RMS.SVC_CUSTORDSUB_ID_SEQ.nextval,
							'XORDER',
                            'STG',
                            'PS',
							'RMSSUB_XITEM',
                            'U',
                            SYSDATE,
                            'PTUSER'
							); 
  END LOOP;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/

---driving cursor query-----

 select proc_data_retention_days
        from system_options;
        
        
         select process_id --262266
        from svc_process_tracker
       where ((status = 'PS' and
              process_destination in ('RMS','S9T'))
          or (status = 'PE' and
              action_date < (SYSDATE - 7)))
         and (template_key in (select template_key
                                from s9t_template
                               where template_type in (select code
                                                         from code_detail
                                                        where code_type = 'IS9T'))
          or template_key ='RMSSUB_XITEM');
          
          


select  spt.process_id
        from  rms.svc_process_tracker spt
       where  status = 'PS'
         and  process_destination ='STG'
         and  template_key ='RMSSUB_XITEM'
         and  not exists ( select 'x' from  rms.sVC_PROCESS_ITEMS s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_COUNTRY s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_MASTER s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_MASTER_TL s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_SUPPLIER s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_SUPPLIER_TL s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_SUPP_COUNTRY s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_SUPP_COUNTRY_DIM s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.svc_item_supp_country_loc s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_SUPP_MANU_COUNTRY s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_PACKITEM s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.svc_xitem_rizp_locs s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.svc_xitem_rizp s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_SEASONS s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_UDA_ITEM_DATE s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_UDA_ITEM_FF s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_UDA_ITEM_LOV s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_VAT_ITEM s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_IMAGE s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.SVC_ITEM_IMAGE_TL s WHERE s.process_id = spt.process_id
                         union all
                           select 'x' from  rms.svc_process_chunks s WHERE s.process_id = spt.process_id);


deleting  from tables:
-------------------------------
select *  from svc_process_tracker;

select count(1) from svc_process_items;

PURGE_SVC_ITEM_TABLES
CORESVC_ITEM.PURGE_SVC_ITEM_TABLES


select * from SVC_PROCESS_ITEMS;
select count(distinct (PROCESS_ID)) from SVC_PROCESS_ITEMS;
select * from rms.sups where supplier in (1100000086,1100001188,1000000020,1000000086,1000001188);


set serveroutput on;
set timing on;
 
DECLARE
COUNTER_COMMIT  NUMBER(8)     := 1;
O_error_message varchar(255);
 
cursor C_GET_PROC_ID_PURGE is
        select distinct PROCESS_ID from SVC_PROCESS_ITEMS where rownum <= '30000' order by 1;
    L_proc_id_purg_tbl   NUM_TAB;

BEGIN

  if C_GET_PROC_ID_PURGE%ISOPEN then
      close C_GET_PROC_ID_PURGE;
   end if;
   open C_GET_PROC_ID_PURGE;

   LOOP
      fetch C_GET_PROC_ID_PURGE BULK COLLECT INTO L_proc_id_purg_tbl LIMIT 1000;
      EXIT 
        WHEN L_proc_id_purg_tbl is NULL or L_proc_id_purg_tbl.COUNT = 0;

      if L_proc_id_purg_tbl is NOT NULL and L_proc_id_purg_tbl.COUNT > 0 then
         if ITEM_INDUCT_SQL.DELETE_PROCESSES(O_error_message,
                                             L_proc_id_purg_tbl) = FALSE then
         
          dbms_output.put_line('Error'||O_error_message);
         
         end if;
         
             COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 300) = 0 THEN
				COMMIT;
			   END IF;	
        end if;
         
   END LOOP;
   close C_GET_PROC_ID_PURGE;

    commit;
  
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
