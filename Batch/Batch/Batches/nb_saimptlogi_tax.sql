	delete FROM NB_SA_TRAN_DISC_TAX_TEMP
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM NB_SA_TRAN_DISC_TAX_TEMP
		GROUP BY STORE_DAY_SEQ_NO,TRAN_SEQ_NO,ITEM,ITEM_SEQ_NO);


delete FROM NB_SA_TRAN_ITEM_TAX_TEMP
WHERE rowid not in
(SELECT MIN(rowid)
FROM NB_SA_TRAN_ITEM_TAX_TEMP
GROUP BY STORE_DAY_SEQ_NO,TRAN_SEQ_NO,ITEM,ITEM_SEQ_NO);

SELECT * FROM NB_SA_TRAN_DISC_TAX_TEMP;



select SYSTEM_CODE,STORE_DAY_SEQ_NO,count(1) from sa_exported where trunc(EXP_DATETIME)= trunc(sysdate) group by SYSTEM_CODE,STORE_DAY_SEQ_NO order by 1,2;

select SYSTEM_CODE,STORE_DAY_SEQ_NO,count(1) from sa_exported group by SYSTEM_CODE,STORE_DAY_SEQ_NO order by 1,2;

select item from item_master im
where item_level ='2' and status ='A' and rownum <= '100' 
and not exists (select 1 from rms.daily_purge dp where dp.KEY_VALUE = im.item)
and exists (select 1 from rms.rpm_item_loc ril where ril.item= im.item);

select item from rpm_price_change rpc where effective_date ='28-JAN-19' and state = 'pricechange.state.approved' and rownum <= '1' order by 1 desc;

SELECT * FROM nb_system_parameters WHERE parameter = 'TRAN_TYPE';


 SELECT currency_cost_dec,
             currency_rtl_dec
             FROM store st,
                  currencies c
            WHERE st.currency_code = c.currency_code;




 SELECT distinct tmp_store_day_seq_no,
             tmp_seq_no,
             tmp_store,
             tmp_day,
             tmp_business_date,
             tmp_rowid
        FROM (SELECT TO_CHAR(sd.store_day_seq_no) tmp_store_day_seq_no,
                     TO_CHAR(el.seq_no) tmp_seq_no,
                     TO_CHAR(sd.store) tmp_store,
                     TO_CHAR(sd.day) tmp_day,
                     TO_CHAR(sd.business_date, 'YYYYMMDD') tmp_business_date,
                     ROWIDTOCHAR(el.rowid) tmp_rowid
                FROM sa_store_day sd,
                     sa_export_log el,
                     v_restart_store vrs
               WHERE sd.store_day_seq_no = el.store_day_seq_no
                 AND sd.store = el.store
                 AND sd.day = el.day
                 AND sd.store_status IN ('W', 'C') /* Worksheet or Closed       */
                 AND sd.data_status IN ('P','F')  /* Partially or Fully loaded */
                 AND el.system_code  = 'RMS'
                 AND el.status       = 'R'    /* 'R'eady to be exported */
                 AND vrs.driver_value = sd.store) temp
       ORDER BY tmp_store_day_seq_no,
                tmp_store,
                tmp_business_date;


SELECT h.tran_seq_no,
             h.rev_no,
             h.store,
             h.tran_type,
             NVL( h.sub_tran_type, ' '),
             TO_CHAR( h.tran_datetime, 'YYYYMMDD'),
             NVL( h.ref_no1, '-1'),
             NVL( h.ref_no3, ' '),
             NVL( h.ref_no4, ' '),
             h.status
        FROM sa_tran_head h,
            NB_SYSTEM_PARAMETERS np
       WHERE h.store_day_seq_no = TO_NUMBER('24000201')
         AND h.tran_type = np.value_1
         AND NVL(h.sub_tran_type,'X') = NVL(np.value_2,'X')
         AND np.func_area = 'VAT_ON_SALES'
         AND np.parameter = 'TRAN_TYPE'
         AND h.rtlog_orig_sys || h.tran_process_sys != 'OMS' || 'POS'
         AND (h.status = 'P'
              AND NOT EXISTS                 /* and no errors for the transaction. */
                 (SELECT er.tran_seq_no
                    FROM sa_error er, sa_error_impact ei
                   WHERE h.tran_seq_no = er.tran_seq_no
                     AND h.store = er.store
                     AND h.day = er.day
                     AND er.error_code = ei.error_code
                     AND ei.system_code = 'RMS'
                     AND er.hq_override_ind != 'Y'))
         AND NOT EXISTS
                (SELECT e.store_day_seq_no
                   FROM sa_exported e
                  WHERE h.store_day_seq_no = e.store_day_seq_no
                    AND h.store = e.store
                    AND h.day = e.day
                    AND h.tran_seq_no = e.tran_seq_no
                    AND e.system_code = 'RMS');

        select * from sa_tran_item where item ='4009400' and day ='27' and store ='10003';
        select * from sa_tran_disc;
        
        select * from item_loc_soh where item ='4009400' and loc ='10003';
        select * from item_loc where item ='4009400' and loc ='10003';
        
select * from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO =110186252; ---531.25
select * from RMS.SA_TRAN_ITEM where  TRAN_SEQ_NO =110186252; --531.2476
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO =110186252;
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO =110186252; ---531.2476
select * from RMS.SA_TRAN_PAYMENT where  TRAN_SEQ_NO =110186252;
select * from RMS.sa_error where  TRAN_SEQ_NO =110186252;
select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec where se.ERROR_CODE =sec.ERROR_CODE and TRAN_SEQ_NO =110186252;






