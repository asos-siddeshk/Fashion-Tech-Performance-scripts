select * from sa_system_options;
select STORE_DAY_SEQ_NO,count(1) from sa_tran_head group by STORE_DAY_SEQ_NO;
select * from sa_store_day ;

update sa_system_options set DAYS_BEFORE_PURGE = '25';

SELECT distinct ssd.store_day_seq_no,
          TO_CHAR(ssd.business_date,'YYYYMMDD'),
          ssd.store,
          ssd.day,
          ROWIDTOCHAR(ssd.rowid)
     FROM sa_store_day ssd,
          sa_system_options sso
    WHERE ssd.business_date <= (TO_DATE('20210508','YYYYMMDD') - sso.days_before_purge)
      AND ((ssd.store_day_seq_no NOT IN (SELECT DISTINCT store_day_seq_no
                                           FROM sa_export_log
                                          WHERE status   = 'R'
                                            AND store    = ssd.store
                                            AND day      = ssd.day)
            AND (ssd.audit_status = 'A' AND ssd.data_status = 'F'))
           OR   (ssd.audit_status = 'U' AND ssd.data_status = 'R')
           OR   (ssd.data_status = 'G'))
 ORDER BY ssd.store_day_seq_no;
 
 
 select * from nb_key_map_gl;
 
       SELECT TO_CHAR(p.vdate - so.tran_data_retained_days_no,'YYYYMMDD')
        FROM period p,
             system_options so;
        
        SELECT TO_CHAR(p.vdate - sso.days_before_purge,'YYYYMMDD')
        FROM period p,
             sa_system_options sso;
             
select * FROM nb_key_map_gl nk
                     WHERE ((nk.processed_date < TO_DATE('20161226','YYYYMMDD')
                       AND reference_trace_type in ('GIT','GID','GIM'))
                       OR (nk.processed_date < TO_DATE('20190102','YYYYMMDD')
                       AND reference_trace_type in ('GSA')));