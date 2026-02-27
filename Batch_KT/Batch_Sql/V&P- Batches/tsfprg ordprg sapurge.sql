 SELECT ssd.store_day_seq_no,
          TO_CHAR(ssd.business_date,'YYYYMMDD'),
          ssd.store,
          ssd.day,
          ROWIDTOCHAR(ssd.rowid)
     FROM sa_store_day ssd,
          sa_system_options sso,
          v_restart_store vrs
    WHERE ssd.business_date <= (TO_DATE('20190127','YYYYMMDD') - sso.days_before_purge)
      AND ((ssd.store_day_seq_no NOT IN (SELECT DISTINCT store_day_seq_no
                                           FROM sa_export_log
                                          WHERE status   = 'R'
                                            AND store    = ssd.store
                                            AND day      = ssd.day)
            AND (ssd.audit_status = 'A' AND ssd.data_status = 'F'))
           OR   (ssd.audit_status = 'U' AND ssd.data_status = 'R')
           OR   (ssd.data_status = 'G'))
          /* multi-threading: */
          ORDER BY ssd.store_day_seq_no;
          
          select days_before_purge from sa_system_options;
          
          


      SELECT s.edi_rev_days,
             s.repl_order_history_days,
             TO_CHAR(p.vdate,'YYYYMMDD'),
             pc.order_history_months,
             s.import_ind
        FROM system_options s,
             period p,
             purge_config_options pc;


  SELECT DISTINCT (oh.order_no)
         FROM ordhead oh,
              ordhead_rev ohr
        WHERE oh.status = 'C'
          AND ohr.order_no = oh.order_no
          AND (TO_DATE('20190128','YYYYMMDD') - 182) > NVL(oh.close_date, TO_DATE('20190128','YYYYMMDD'));


--ordprg
SELECT count(distinct(order_no)) FROM ordhead oh WHERE 
    ((0 < (NVL(MONTHS_BETWEEN(TO_DATE('20190128','YYYYMMDD'),oh.close_date),0) - '25')));   

--tsfprg
select count(1) from doc_purge_queue dp  where not exists (select 1 from rms.tsfhead th where th.tsf_no = dp.tsf_no) ;
   
   select count(1) from order_mfqueue;
   select count(1) from tsf_mfqueue;
   
select * from tsf_mfqueue;

select count(1) from doc_purge_queue dp  where not exists (select 1 from rms.tsfhead th where th.tsf_no = dp.tsf_no) ;

select * from rms.restart_bookmark where RESTART_NAME  in ('ordprg','sapurge','tsfprg');
select * from rms.restart_control where PROGRAM_NAME in ('ordprg','sapurge','tsfprg');
select * from rms.restart_program_history where RESTART_NAME  in ('ordprg','sapurge','tsfprg') order by START_TIME desc;
