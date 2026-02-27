
select * from all_tables where table_name like '%NB_HIST%';
 select * from NB_HIST_SA_STORE_DAY;
 select * from SA_STORE_DAY; --09-AUG-22


SELECT distinct ssd.store_day_seq_no,
          TO_CHAR(ssd.business_date,'YYYYMMDD'),
          ssd.store,
          ssd.day,
          ROWIDTOCHAR(ssd.rowid)
     FROM sa_store_day ssd,
          sa_system_options sso,
          v_restart_store vrs
    WHERE ssd.business_date <= (TO_DATE('20230208','YYYYMMDD') - sso.days_before_purge)
      AND ((ssd.store_day_seq_no NOT IN (SELECT DISTINCT store_day_seq_no
                                           FROM sa_export_log
                                          WHERE status   = 'R'
                                            AND store    = ssd.store
                                            AND day      = ssd.day)
            AND (ssd.audit_status = 'A' AND ssd.data_status = 'F'))
           OR   (ssd.audit_status = 'U' AND ssd.data_status = 'R')
           OR   (ssd.data_status = 'G'))
 ORDER BY ssd.store_day_seq_no;
 
update SA_SYSTEM_OPTIONS set DAY_POST_SALE= '30';--200
update SA_SYSTEM_OPTIONS set DAYS_BEFORE_PURGE= '183'; --280
update SA_SYSTEM_OPTIONS set CHECK_DUP_MISS_TRAN= 'Y'; 


select STORE_DAY_SEQ_NO,count(1) from RMS.SA_TRAN_HEAD where 
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('02-JAN-19')) group by STORE_DAY_SEQ_NO;
select STORE_DAY_SEQ_NO,count(1) from RMS.SA_TRAN_HEAD where 
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('03-JAN-19')) group by STORE_DAY_SEQ_NO;
 
  update sa_system_options set DAYS_BEFORE_PURGE ='10',CHECK_DUP_MISS_TRAN ='N'; --762
 select * from sa_system_options;
 select * from sa_store_day order by 2;
   
   
begin
   Update sa_store_day set STORE_STATUS ='C', STORE_CLOSED_DATETIME =BUSINESS_DATE,DATA_STATUS ='F',AUDIT_STATUS ='A',
                   AUDIT_CHANGED_DATETIME =BUSINESS_DATE, FILES_LOADED =OMS_FILES_LOADED 
                   where business_date in ('29-SEP-19') and store_status <> 'C';   
   Update sa_export_log set STATUS ='E', DATETIME ='29-SEP-19' where STATUS <> 'E' and STORE_DAY_SEQ_NO in 
                (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('29-SEP-19'));
   update sa_tran_head set ERROR_IND ='N' where ERROR_IND ='Y' and STORE_DAY_SEQ_NO in 
                (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('29-SEP-19'));
   update sa_tran_head set ERROR_IND ='N' where ERROR_IND ='Y' and STORE_DAY_SEQ_NO in 
                (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('29-SEP-19'));
commit;
end ;
/



