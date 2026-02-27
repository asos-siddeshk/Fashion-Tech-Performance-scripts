
SELECT distinct tmp_store_day_seq_no,
             tmp_seq_no,
             tmp_store,
             tmp_day,
             tmp_business_date,
             tmp_data_status,
             tmp_rowid
        FROM
        (SELECT TO_CHAR( sd.store_day_seq_no ) tmp_store_day_seq_no,
                TO_CHAR( el.seq_no ) tmp_seq_no,
                TO_CHAR( sd.store ) tmp_store,
                TO_CHAR( sd.day ) tmp_day,
                TO_CHAR(sd.business_date, 'YYYYMMDD') tmp_business_date,
                sd.data_status tmp_data_status,
                ROWIDTOCHAR(el.rowid) tmp_rowid
           FROM sa_store_day sd, sa_export_log el, v_restart_store vrs
          WHERE sd.store_day_seq_no = el.store_day_seq_no
            AND sd.store = el.store
            AND sd.day = el.day
            AND sd.store_status IN ('W','C') /* Worksheet or Closed       */
            AND sd.data_status IN ('P','F')  /* Partially or Fully loaded */
            AND el.system_code = 'RPAS'
            AND el.status = 'R'                   /* 'R'eady to be exported    */
            AND vrs.driver_value = sd.store

      UNION ALL

         SELECT distinct TO_CHAR( sd.store_day_seq_no ) tmp_store_day_seq_no,
                TO_CHAR( el.seq_no ) tmp_seq_no,
                TO_CHAR( sd.store ) tmp_store,
                TO_CHAR( sd.day ) tmp_day,
                TO_CHAR(sd.business_date, 'YYYYMMDD') tmp_business_date,
                sd.data_status tmp_data_status,
                ROWIDTOCHAR(el.rowid) tmp_rowid
           FROM sa_store_day sd, sa_export_log el, sa_tran_head th, v_restart_store vrs
          WHERE sd.store_day_seq_no = el.store_day_seq_no
            AND sd.store_day_seq_no = th.store_day_seq_no
            AND sd.store = el.store
            AND sd.store = th.store
            AND sd.day = el.day
            AND sd.day = th.day
            AND th.status = 'D'
            AND sd.store_status IN ('W','C')
            AND sd.data_status IN ('R')
            AND el.system_code = 'RPAS'
            AND el.status = 'R'
            AND vrs.driver_value = sd.store ) temp
       ORDER BY tmp_store_day_seq_no, tmp_store, tmp_business_date;
       



273000401
273000402
273000403

272000403
272000401
272000402

SELECT * FROM sa_export_log where STORE_DAY_SEQ_NO in ('272000401','272000402','272000403') and system_code = 'RPAS';
SELECT * FROM sa_export_log where STORE_DAY_SEQ_NO in ('273000401','273000402','273000403') and system_code = 'RPAS';

Insert into sa_export_log (STORE,DAY,STORE_DAY_SEQ_NO,SYSTEM_CODE,SEQ_NO,STATUS,DATETIME) values (10004,8,272000403,'RPAS',1,'R',null);
Insert into sa_export_log (STORE,DAY,STORE_DAY_SEQ_NO,SYSTEM_CODE,SEQ_NO,STATUS,DATETIME) values (10001,8,272000401,'RPAS',1,'R',null);
Insert into sa_export_log (STORE,DAY,STORE_DAY_SEQ_NO,SYSTEM_CODE,SEQ_NO,STATUS,DATETIME) values (10003,8,272000402,'RPAS',1,'R',null);

SELECT * FROM sa_exported where STORE_DAY_SEQ_NO in ('14000001','14000002','14000003') and system_code = 'RPAS';
SELECT * FROM sa_error_impact where system_code = 'RPAS' and ERROR_CODE ='SKU_NOT_FOUND';

select * from sa_error se where STORE_DAY_SEQ_NO in ('14000001','14000002','14000003') and ERROR_CODE ='SKU_NOT_FOUND'
    and not exists (select 1 from sa_error se2 where STORE_DAY_SEQ_NO in ('14000001','14000002','14000003') and ERROR_CODE! ='SKU_NOT_FOUND' and se2.TRAN_SEQ_NO = se.TRAN_SEQ_NO)
    and exists (select 1 from RMS.SA_TRAN_HEAD th where  th.TRAN_SEQ_NO = se.TRAN_SEQ_NO);

select * from sa_error_impact;

select * from RMS.SA_TRAN_HEAD where  TRAN_SEQ_NO =65290967; ---531.25
select * from RMS.SA_TRAN_ITEM where  TRAN_SEQ_NO =65290967; --531.2476
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO =65290967; --531.2476
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO =65290967; --531.2476
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO =65290967; --531.2476
select * from RMS.sa_error where TRAN_SEQ_NO =65290967; --531.2476
select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec where se.store_day_seq_no ='14000003' 
    and se.ERROR_CODE =sec.ERROR_CODE and TRAN_SEQ_NO =65290967;

select * from item_master where item ='101431126';

select * from tran_newitem where TRAN_TYPE! ='RETURN';

drop table tran_newitem;
--create table tran_newitem as
 SELECT TO_CHAR( h.tran_seq_no ) as tran_seq_no ,
             LTRIM(TO_CHAR( h.rev_no ), '0') as rev_no,
             TO_CHAR( h.tran_datetime, 'YYYYMMDDHH24MISS') as tran_datetime,
             NVL(h.tran_type,' ') as tran_type,
             NVL(h.sub_tran_type,' ') as sub_tran_type,
             NVL(h.ref_no2,' ') as ref_no2,
             NVL(h.ref_no4,' ') as ref_no4
        FROM sa_tran_head h
       WHERE h.STORE_DAY_SEQ_NO in ('14000001','14000002','14000003')
         AND h.tran_type IN ('RETURN')
         AND (h.status = 'P'
              AND NOT EXISTS            /* and no errors for the transaction. */
                 (SELECT er.tran_seq_no
                    FROM sa_error er, sa_error_impact ei
                   WHERE h.tran_seq_no = er.tran_seq_no
                     AND h.store = er.store
                     AND h.day = er.day
                     AND er.error_code = ei.error_code
                     AND ei.system_code = 'RPAS'
                     AND er.hq_override_ind != 'Y'))
         AND h.status = 'P'
         AND NOT EXISTS
             (SELECT e.store_day_seq_no
                FROM sa_exported e
               WHERE h.store_day_seq_no = e.store_day_seq_no
                 AND h.store = e.store
                 AND h.day = e.day
                 AND h.tran_seq_no = e.tran_seq_no
                 AND e.system_code = 'RPAS') ;
       
       SELECT ITEM,
           DLV_COUNTRY,
           WH,
           BUSINESS_DATE,
           SALES_GROUP,
           SALES_TYPE,
           CASE
             WHEN ('N' = 'Y') THEN
              SALES_QTY * -1
             ELSE
              SALES_QTY
           END,
           CASE
             WHEN ('N' = 'Y') THEN
              SALES_RETAIL * -1
             ELSE
              SALES_RETAIL
           END,
           SALES_TAX,
           SALES_COST,
           STORE_DAY_SEQ_NO,
           TRAN_SEQ_NO,
           ITEM_SEQ_NO,
           DISCOUNT_SEQ_NO,
           RMS_PROMO_TYPE,
           DISC_TYPE,
           REV_NO
     FROM (SELECT NVL(TI.ITEM, TI.NON_MERCH_ITEM) AS ITEM,
           'DE' AS DLV_COUNTRY,
           ST.DEFAULT_WH AS WH,
           '20190127' AS BUSINESS_DATE,
           (
           SELECT NVL(LISTAGG(SALE_TYPE, '+') WITHIN GROUP(ORDER BY SALE_TYPE),
           'REGULAR') AS SALE_GROUP
            from (SELECT DISTINCT CASE
                          WHEN RMS_PROMO_TYPE = 9999 THEN
                           'RPM'
                          WHEN RMS_PROMO_TYPE = 1004 THEN
                           DISC_TYPE
                          ELSE
                           DISC_TYPE
                        End AS SALE_TYPE
          FROM sa_tran_disc
         WHERE STORE = TO_NUMBER('10004')
           AND DAY = TO_NUMBER('27')
           AND TRAN_SEQ_NO = TO_NUMBER('60574825')
           AND ITEM_SEQ_NO = TI.ITEM_SEQ_NO)
           ) AS SALES_GROUP, 
           'TOTAL' AS SALES_TYPE,
           CASE
             WHEN (TI.CATCHWEIGHT_IND = 'Y' AND TI.STANDARD_UOM = 'EA') THEN
               TI.STANDARD_QTY
             ELSE
               TI.QTY
           END AS SALES_QTY,
           CASE
             WHEN (TI.CATCHWEIGHT_IND = 'Y' AND TI.STANDARD_UOM = 'EA') THEN
               TI.STANDARD_UNIT_RETAIL
             ELSE
               TI.UNIT_RETAIL
           END AS SALES_RETAIL,
           TI.TOTAL_IGTAX_AMT AS SALES_TAX,
           NVL(TO_NUMBER(TI.REF_NO5)/10000, 0) AS SALES_COST,
           '14000003' STORE_DAY_SEQ_NO,
           TI.TRAN_SEQ_NO,
           TI.ITEM_SEQ_NO,
           0 DISCOUNT_SEQ_NO,
           ' ' RMS_PROMO_TYPE,
           ' ' DISC_TYPE,
           0 REV_NO
      FROM SA_TRAN_ITEM TI,
           STORE ST
     WHERE TI.STORE       = ST.STORE
       AND TI.TRAN_SEQ_NO = TO_NUMBER('60574825'));

drop table tran_newitem2;
create table tran_newitem2 as
select rownum as sl_no,item from item_master im where item_level =tran_level  and status ='A' and tran_level ='2'
    and not exists (select 1 from sa_tran_item si where si.item  = im.item) 
    and not exists (select 1 from daily_purge di where di.KEY_VALUE  = im.item) and rownum <= '300000';

select * from tran_newitem2;


set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           skumar.tran_newitem.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    l_ITEM_SEQ_NO       rms.SA_TRAN_ITEM.ITEM_SEQ_NO%type := 5;
cursor c_custord is
    select TRAN_SEQ_NO from tran_newitem where TRAN_TYPE! ='RETURN' and rownum <='300000';

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;


insert into SA_TRAN_ITEM
select STORE,DAY,TRAN_SEQ_NO,l_ITEM_SEQ_NO,ITEM_STATUS,ITEM_TYPE,ti.item,REF_ITEM,NON_MERCH_ITEM,VOUCHER_NO,DEPT,CLASS,
        SUBCLASS,QTY,UNIT_RETAIL,SELLING_UOM,OVERRIDE_REASON,ORIG_UNIT_RETAIL,STANDARD_ORIG_UNIT_RETAIL,TAX_IND,ITEM_SWIPED_IND,ERROR_IND,
        DROP_SHIP_IND,WASTE_TYPE,WASTE_PCT,PUMP,RETURN_REASON_CODE,SALESPERSON,EXPIRATION_DATE,STANDARD_QTY,STANDARD_UNIT_RETAIL,STANDARD_UOM,
        REF_NO5,REF_NO6,REF_NO7,REF_NO8,UOM_QUANTITY,CATCHWEIGHT_IND,SELLING_ITEM,CUSTOMER_ORDER_LINE_NO,MEDIA_ID,UNIT_RETAIL_VAT_INCL,
        TOTAL_IGTAX_AMT,UNIQUE_ID,CUST_ORDER_NO,CUST_ORDER_DATE,FULFILL_ORDER_NO,NO_INV_RET_IND,RETURN_WH,SALES_TYPE,RETURN_DISPOSITION 
    from SA_TRAN_ITEM sti, tran_newitem2 ti where  TRAN_SEQ_NO = l_TRAN_SEQ_NO and rownum <='1' and ti.sl_no =  l_counter;

     l_counter := l_counter+1;

     	IF MOD(l_counter, 10000) = 0 THEN
                commit;
			   END IF;	
	end loop;                         
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/

    
select * from tran_newitem;

select * from SA_TRAN_ITEM where ITEM_SEQ_NO in ('4','5') and day ='27';
    
select * from sa_tran_item_rev where tran_seq_no in (select TRAN_SEQ_NO from tran_newitem);
