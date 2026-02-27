select ssd.store_day_seq_no
        from sa_store_day ssd
       where exists (select 1
                       from sa_error se
                      where se.error_code = 'TRAN_OUT_BAL'
                        and se.store_day_seq_no = ssd.store_day_seq_no
                        and se.store = ssd.store
                        and se.day = ssd.day
                        and rownum < 2);
                        
NB_SAIMPTLOG_SQL.FIX_TRAN_OUT_BAL;

select  * from sa_error where error_code ='ASOS_TRAN_OUT_TOLERANCE';


select *
        from nb_system_parameters nsp
       where nsp.func_area = 'RESA_ROUNDING'
         and nsp.parameter = 'TOLERANCE';

  select *
        from nb_system_parameters nsp
       where nsp.func_area = 'RESA_ROUNDING'
         and nsp.parameter = 'ROUNDING_TENDER';
         
         
         
select * from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000003 and TRAN_SEQ_NO =65198606; ---531.25
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000003) and TRAN_SEQ_NO =65198606; --531.2476
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000003) and TRAN_SEQ_NO =65198606;
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000003) and TRAN_SEQ_NO =65198606; ---531.2476
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000003) and TRAN_SEQ_NO =65198606;
select * from RMS.sa_error where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000003) and TRAN_SEQ_NO =65198606;
select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec where se.store_day_seq_no ='14000003' and se.ERROR_CODE =sec.ERROR_CODE and TRAN_SEQ_NO =65198606;

  S:-00000000000014087100 T:-00000000000007003056
  
  select * from sa_store _price_hist_temp;
  
select se.tran_seq_no,ssd.store_day_seq_no,
             se.day,
             se.store,
             se.error_seq_no,
             sth.tran_type,
             sth.sub_tran_type,
             sth.rev_no
        from sa_store_day ssd,
             sa_tran_head sth,
             sa_error se
       where ssd.store_day_seq_no = se.store_day_seq_no
         and ssd.store_day_seq_no = sth.store_day_seq_no
         and ssd.day = se.day
         and ssd.day = sth.day
         and ssd.store = se.store
         and ssd.store = sth.store
         and sth.tran_seq_no = se.tran_seq_no
    --     and ssd.store_day_seq_no = I_store_day_seq_no
         and se.error_code = 'TRAN_OUT_BAL';