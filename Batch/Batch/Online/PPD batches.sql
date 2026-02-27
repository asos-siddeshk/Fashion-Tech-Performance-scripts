select status,COUNT(1) from rms.tsfhead GROUP BY status ORDER BY 1 desc;
select tsf_type,status,COUNT(1) from rms.tsfhead GROUP BY tsf_type,status;
select status,COUNT(1) from rms.ordhead GROUP BY status ORDER BY 1 desc; -- 250k
select * from RMS.SA_STORE_DAY order by 2,3;

select * from MV_SUBCLASS_LOC_HIST  where EOW_DATE= ''

 7366675
12002767

   SELECT doc_type, count(1)
       FROM rms.doc_close_queue
      group by doc_type;

select * from rms.tsfhead order by 1 desc;
select * from rms.sa_total_head;

select * from rms.tran_data_history ;
select TRAN_DATE,count(1) from rms.tran_data_history group by TRAN_DATE;
select TRAN_DATE,count(1) from rms.tran_data_history where trunc(POST_DATE)= '06-JUN-20' group by TRAN_DATE;

select location,TRAN_CODE,count(1) from rms.tran_data_history where trunc(tran_date)= '06-JUN-20' group by location,TRAN_CODE;


select * from system_variables;

16-JUN-20	7411649
17-JUN-20	6917002
18-JUN-20	6901281
19-JUN-20	7676758
20-JUN-20	4795245
21-JUN-20	3527748
22-JUN-20	6574558
23-JUN-20	5899548

-- Open Transfers 12M  (In VPT 2M open transfers)
-- Open PO's 250k  (In VPT it was 100k) 
-- ReSA Totals in 36 (In VPT had 12 totals configured, also RMS & ReSA GL configurations had issues)


select * from RMS.SA_STORE_DAY order by 2,3;


select SYSTEM_CODE,count(1) from 
    rms.sa_exported where EXP_DATETIME  between to_date('06-JUN-2020 01:12', 'DD-MON-YYYY hh24:mi')
        and to_date('06-JUN-2020 01:21', 'DD-MON-YYYY hh24:mi') group by SYSTEM_CODE;
        
        
        


select * from 
    rms.sa_exported where EXP_DATETIME  between to_date('06-JUN-2020 01:12', 'DD-MON-YYYY hh24:mi')
        and to_date('06-JUN-2020 01:21', 'DD-MON-YYYY hh24:mi');

select STORE_DAY_SEQ_NO,SYSTEM_CODE,count(1) from 
    rms.sa_exported where EXP_DATETIME  between to_date('06-JUN-2020 01:01', 'DD-MON-YYYY hh24:mi')
        and to_date('06-JUN-2020 01:30', 'DD-MON-YYYY hh24:mi') group by STORE_DAY_SEQ_NO,SYSTEM_CODE order 1,2;
    
select * from rms.sa_export_log where DATETIME  between to_date('06-JUN-2020 01:00', 'DD-MON-YYYY hh24:mi')
        and to_date('06-JUN-2020 01:30', 'DD-MON-YYYY hh24:mi');

select * from rms.MV_SUBCLASS_LOC_HIST;
select * from rms.MV_SUBCLASS_LOC_HIST where trunc(EOW_DATE)= '06-JUN-2020';

        
select * from RMS.SA_STORE_DAY order by 2,3;
        
123000003	RPAS	25399
124000003	RPAS	230000
124000002	RPAS	48706
124000001	RPAS	287868
123000002	RPAS	75
123000001	RPAS	18466

select count(1) from ma_asos.MA_R_PRICES; --81519630

select * from all_tab_partitions where table_name like 'TRAN_DATA_B';
select * from all_tab_partitions where table_name like 'TRAN_DATA_A';
