select * from COST_SUSP_SUP_HEAD where COST_CHANGE between 2317669 and 2317673;
select * from COST_SUSP_SUP_DETAIL where COST_CHANGE between 2317669 and 2317673;

select csd.COST_CHANGE,csh.status,csh.active_date,csd.item
    from cost_susp_sup_detail csd, cost_susp_sup_head csh
    where csd.item in (select item from item_master where item ='100037518' or item_parent ='100037518')
    and csd.COST_CHANGE =csh.COST_CHANGE;
    
    
select csd.COST_CHANGE, csd.SUPPLIER, csd.ORIGIN_COUNTRY_ID, csd.ITEM,CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION'
            WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM
    from cost_susp_sup_detail csd,item_master im , cost_susp_sup_head csh where csh.status ='A' and csd.COST_CHANGE =csh.COST_CHANGE 
    and im.item = csd.item and im.item_level!= im.tran_level;
    
select item,count(1) from cost_susp_sup_detail csd, cost_susp_sup_head csh where  csh.status ='A' and csd.COST_CHANGE =csh.COST_CHANGE group by item;

select * from cost_susp_sup_detail csd, cost_susp_sup_head csh where  csh.status ='A' and csd.COST_CHANGE =csh.COST_CHANGE and csh.status ='A'
and item = '100029937';

select * from restart_control where program_name like 'sccext';
Update restart_control set num_threads ='16' where program_name like 'sccext';



update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;

select * from all_tables where table_name like '%REASON%';

select * from COST_CHG_REASON_TL;

SELECT * FROM v_restart_cost_chg rv,
             cost_susp_sup_head h
       WHERE h.status        = 'A'
         AND TRUNC(h.active_date) = TO_DATE('20240116', 'YYYYMMDD')
         AND rv.driver_value = h.cost_change
    ORDER BY h.cost_change;
    
    
select * from logger_logs order by 1 desc;

select status,count(1) from COST_SUSP_SUP_HEAD  group by status;
select ACTIVE_DATE,count(1) from COST_SUSP_SUP_HEAD where status = 'A' group by ACTIVE_DATE;

update cost_susp_sup_head h set status = 'R'
       WHERE h.status = 'A'
         AND TRUNC(h.active_date) = TO_DATE('20230227', 'YYYYMMDD') and rownum <= '200';

update cost_susp_sup_head h set status = 'R'
       WHERE h.status = 'A'
         AND cost_change  in ('19691110','19691109');


select * from COST_SUSP_SUP_DETAIL order by 1 desc;
select * from COST_SUSP_SUP_DETAIL where item = '101344368';

select * from COST_SUSP_SUP_HEAD where COST_CHANGE between 2317669 and 2317673;

select * from COST_SUSP_SUP_DETAIL where COST_CHANGE  in ( select COST_CHANGE  from COST_SUSP_SUP_HEAD h WHERE h.status = 'A' AND TRUNC(h.active_date) = TO_DATE('20230227', 'YYYYMMDD'));

select item,count(1) from COST_SUSP_SUP_DETAIL where COST_CHANGE  in ( select COST_CHANGE  from COST_SUSP_SUP_HEAD h WHERE h.status = 'A' AND TRUNC(h.active_date) = TO_DATE('20230227', 'YYYYMMDD')) group by item;

select * from item_supp_country_loc where item in (select item from item_master where item_parent ='100036503' or item ='100036503'); --7.38
select * from item_supp_country where item in (select item from item_master where item_parent ='100036503' or item ='100036503');
select * from price_hist where item in (select item from item_master where item_parent ='100036503' or item ='100036503');
select * from TRAN_DATA where item in (select item from item_master where item_parent ='100036503' or item ='100036503');

    
set SERVEROUTPUT ON;
set timing ON;

    DECLARE
  O_ERROR_MESSAGE VARCHAR2(255);
  I_COST_CHANGE NUMBER;
  I_COST_REASON NUMBER;
  v_Return BOOLEAN;
BEGIN
  O_ERROR_MESSAGE := NULL;
  I_COST_CHANGE := '2317669';
  I_COST_REASON := '4';

  v_Return := RMS.COST_EXTRACT_SQL.BULK_UPDATE_COSTS(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_COST_CHANGE => I_COST_CHANGE,
    I_COST_REASON => I_COST_REASON);
  
IF (v_Return) THEN 
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'FALSE');
    DBMS_OUTPUT.PUT_LINE('O_ERROR_MESSAGE = ' || O_ERROR_MESSAGE);
  END IF;
 EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/


select * from COST_SUSP_SUP_HEAD where COST_CHANGE between 2317669 and 2317673;
select * from COST_SUSP_SUP_DETAIL where COST_CHANGE between 2317669 and 2317673;



Update cost_susp_sup_head h set status ='R'
       WHERE h.status        = 'A'
         AND TRUNC(h.active_date) = TO_DATE('20190128', 'YYYYMMDD') and rownum <= '12337';

delete FROM cost_event_cost_chg where COST_CHANGE in (SELECT d.COST_CHANGE FROM cost_susp_sup_head d where status!='A');     
delete from cost_event where EVENT_TYPE ='CC' and COST_EVENT_PROCESS_ID not in (select COST_EVENT_PROCESS_ID from cost_event_cost_chg);


select COST_EVENT_PROCESS_ID from cost_event_cost_chg;

delete FROM cost_event_cost_chg where COST_CHANGE in (SELECT d.COST_CHANGE FROM cost_susp_sup_head d where status!='A');     
delete from cost_event where EVENT_TYPE ='CC' and COST_EVENT_PROCESS_ID not in (select COST_EVENT_PROCESS_ID from cost_event_cost_chg);


delete FROM cost_event_cost_chg where COST_CHANGE in (SELECT d.COST_CHANGE
        FROM cost_susp_sup_head d where status ='A');
    

delete from cost_event where EVENT_TYPE ='CC' and COST_EVENT_PROCESS_ID not in (select COST_EVENT_PROCESS_ID from cost_event_cost_chg);

delete from cost_event where EVENT_TYPE ='CC' and COST_EVENT_PROCESS_ID not in (select COST_EVENT_PROCESS_ID from cost_event_cost_chg);
delete from cost_event where EVENT_TYPE ='CC' and COST_EVENT_PROCESS_ID not in (select COST_EVENT_PROCESS_ID from cost_event_cost_chg);
delete from cost_event where EVENT_TYPE ='D' and COST_EVENT_PROCESS_ID not in (select COST_EVENT_PROCESS_ID from cost_event_deal);


 --fcthread   
    SELECT count(ce.cost_event_process_id)
    FROM cost_event ce,
             cost_event_run_type_config cec,
             (SELECT ced.cost_event_process_id cost_event_process_id,
                     ced.deal_id key_value
                FROM cost_event_deal ced
              UNION ALL
              SELECT cecc.cost_event_process_id cost_event_process_id,
                     cecc.cost_change key_value
                FROM cost_event_cost_chg cecc 
             ) cekv
       WHERE NVL(ce.override_run_type,cec.event_run_type) = 'BATCH'
         AND cec.event_type = ce.event_type
         AND ce.rowid not in (SELECT ce1.rowid
                              FROM cost_event ce1,
                                   cost_event_result cer
                             WHERE ce1.cost_event_process_id = cer.cost_event_process_id)
         AND cekv.cost_event_process_id(+) = ce.cost_event_process_id
    ORDER BY ce.cost_event_process_id;
      
select * from cost_event_result where status!='C' order by 1 desc;
              
          delete from cost_event where cost_event_process_id  in ( select cost_event_process_id from cost_event_deal );
         delete from cost_event_deal;
         
         
         
--fcexec    
drop table cost_event_check;

--create table cost_event_check as 
      SELECT distinct ce.cost_event_process_id
        FROM cost_event_result cer,
             cost_event_run_type_config cec,        
             cost_event ce
       WHERE NVL(ce.override_run_type,cec.event_run_type) = 'BATCH'
         AND cec.event_type = ce.event_type
         AND cer.cost_event_process_id = ce.cost_event_process_id
           AND 
                (     cer.status = 'N' 
                  AND cer.attempt_num = 0 )
              AND not exists (SELECT 'x'	 	 
                                FROM cost_event_result cer2	 	 
                               WHERE cer2.cost_event_process_id	= cer.cost_event_process_id 	 
                                 AND cer2.thread_id = cer.thread_id
                                 AND cer2.attempt_num > cer.attempt_num);
