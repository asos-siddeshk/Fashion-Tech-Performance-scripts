--update restart_control set NUM_THREADS='3' where program_name like 'saimptlogfin';

select STORE, SYSTEM_CODE,STORE_DAY_SEQ_NO, count(1) from sa_exported where 
STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE = '09-MAY-21')
group by  STORE, SYSTEM_CODE,STORE_DAY_SEQ_NO
order by  STORE, SYSTEM_CODE,STORE_DAY_SEQ_NO;

select TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD where
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('10-NOV-21'))
    group by TRAN_TYPE, SUB_TRAN_TYPE order by 1,2;

select * from RMS.sa_STORE_DAY WHERE BUSINESS_DATE > '03-MAY-21' order by 2,3 ;
select distinct(error_code) from rms.sa_error;

--update sa_STORE_DAY set DATA_STATUS= 'P' where STORE_DAY_SEQ_NO  in ('273000401','273000402','273000403');


select * from sa_export_log where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE >= '09-MAY-21');


select ERROR_CODE,count(1) from RMS.sa_error 
where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE >= '09-MAY-21')
 group by ERROR_CODE;


select * from RMS.sa_error_codes;  


select count(1) from sa_tran_head where TRAN_SEQ_NO > '125000001'; --226208
select * from RMS.sa_error where TRAN_SEQ_NO > '125000001' order by TRAN_SEQ_NO desc; 
select ERROR_CODE,count(1) from RMS.sa_error where TRAN_SEQ_NO > '125000001' group by ERROR_CODE;

select sd.BUSINESS_DATE,st.store,st.STORE_DAY_SEQ_NO,st.TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD st, SA_STORE_DAY sd where 
    st.STORE_DAY_SEQ_NO = sd.STORE_DAY_SEQ_NO and sd.BUSINESS_DATE = ('09-MAY-2021')
    group by sd.BUSINESS_DATE,st.store,st.STORE_DAY_SEQ_NO,st.TRAN_TYPE order by 1,2;


select * from all_tables where table_name like '%LOCK%';
--delete from SA_STORE_DAY_READ_LOCK;
--delete from SA_STORE_DAY_WRITE_LOCK;

select * from SA_STORE_DAY_READ_LOCK;
select * from SA_STORE_DAY_WRITE_LOCK;

select * from SA_SYSTEM_OPTIONS;

--update SA_SYSTEM_OPTIONS set DAY_POST_SALE= '200';--30
--update SA_SYSTEM_OPTIONS set DAYS_BEFORE_PURGE= '184'; --184
--update SA_SYSTEM_OPTIONS set CHECK_DUP_MISS_TRAN= 'N'; 

/*sudo su - oracle
cat env.sh
cd /orabin/app/oracle/product/retail/batch
. ./batch.profile
cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin
./sastdycr $UP 20190829
./sastdycr $UP 20190828
./sastdycr $UP 20190827
./sastdycr $UP 20190826
./sastdycr $UP 20190825
./sastdycr $UP 20190824
./sastdycr $UP 20190823
./sastdycr $UP 20190822
*/

 -- Update sa_store_day set FILES_LOADED = '1',OMS_FILES_LOADED='1' where FILES_LOADED is null;

/*
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET/*.* /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/
mv RTLOG_10001_20200227_20200229193154.dat  RTLOG_10001_20200226_20200229193154.dat
mv RTLOG_10001_20200227_20200302053050.dat  RTLOG_10001_20200226_20200302053050.dat
mv RTLOG_10001_20200227_20200302173100.dat  RTLOG_10001_20200226_20200302173100.dat
mv RTLOG_10001_20200227_20200302190105.dat  RTLOG_10001_20200226_20200302190105.dat
mv RTLOG_10003_20200227_20200302003407.dat  RTLOG_10003_20200226_20200302003407.dat
mv RTLOG_10003_20200227_20200302010249.dat  RTLOG_10003_20200226_20200302010249.dat
mv RTLOG_10003_20200227_20200302151509.dat  RTLOG_10003_20200226_20200302151509.dat
mv RTLOG_10003_20200227_20200302160546.dat  RTLOG_10003_20200226_20200302160546.dat
mv RTLOG_10003_20200227_20200302180821.dat  RTLOG_10003_20200226_20200302180821.dat
mv RTLOG_10003_20200227_20200302183520.dat  RTLOG_10003_20200226_20200302183520.dat
mv RTLOG_10003_20200227_20200302193528.dat  RTLOG_10003_20200226_20200302193528.dat
mv RTLOG_10003_20200227_20200302201051.dat  RTLOG_10003_20200226_20200302201051.dat
mv RTLOG_10003_20200227_20200302220816.dat  RTLOG_10003_20200226_20200302220816.dat
mv RTLOG_10003_20200227_20200302233351.dat  RTLOG_10003_20200226_20200302233351.dat
mv RTLOG_10004_20200227_20200302080656.dat  RTLOG_10004_20200226_20200302080656.dat
mv RTLOG_10004_20200227_20200302113609.dat  RTLOG_10004_20200226_20200302113609.dat
mv RTLOG_10004_20200227_20200302143618.dat  RTLOG_10004_20200226_20200302143618.dat
mv RTLOG_10004_20200227_20200302151044.dat  RTLOG_10004_20200226_20200302151044.dat
mv RTLOG_10004_20200227_20200302190751.dat  RTLOG_10004_20200226_20200302190751.dat
mv RTLOG_10004_20200227_20200302200624.dat  RTLOG_10004_20200226_20200302200624.dat
mv RTLOG_10004_20200227_20200302213848.dat  RTLOG_10004_20200226_20200302213848.dat
sed -i 's/20200227/20200226/g' RTLOG_10001_20200226_20200229193154.dat
sed -i 's/20200227/20200226/g' RTLOG_10001_20200226_20200302053050.dat
sed -i 's/20200227/20200226/g' RTLOG_10001_20200226_20200302173100.dat
sed -i 's/20200227/20200226/g' RTLOG_10001_20200226_20200302190105.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302003407.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302010249.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302151509.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302160546.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302180821.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302183520.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302193528.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302201051.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302220816.dat
sed -i 's/20200227/20200226/g' RTLOG_10003_20200226_20200302233351.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302080656.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302113609.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302143618.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302151044.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302190751.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302200624.dat
sed -i 's/20200227/20200226/g' RTLOG_10004_20200226_20200302213848.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10001_20200226_20200229193154.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10001_20200226_20200302053050.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10001_20200226_20200302173100.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10001_20200226_20200302190105.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302003407.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302010249.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302151509.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302160546.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302180821.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302183520.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302193528.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302201051.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302220816.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10003_20200226_20200302233351.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302080656.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302113609.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302143618.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302151044.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302190751.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302200624.dat
sed -i 's/JAN27/JAN26/g' RTLOG_10004_20200226_20200302213848.dat


*/

select * from sa_tran_head ;
select * from all_Sequences where sequence_name like '%TRAN%';

select * from all_tables where table_name like '%LOCK%';

select SYSTEM_CODE,STORE_DAY_SEQ_NO,count(1) from sa_exported group by SYSTEM_CODE,STORE_DAY_SEQ_NO;

select ERROR_CODE,count(1) from RMS.sa_error where STORE_DAY_SEQ_NO in 
    (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-FEB-20')) group by ERROR_CODE;

select * from sa_exported EXP_DATETIME;

select * from sa_tran_head where ERROR_IND = 'Y';

--delete SA_STORE_DAY_READ_LOCK;
--delete SA_STORE_DAY_WRITE_LOCK;

/*
    
UPDATE skumar.CASHANDSALES_ALL      SET
INVOICEREFERENCE = replace(INVOICEREFERENCE,'MAY013','JUN04'),
PAYMENTREFERENCE = replace(PAYMENTREFERENCE,'MAY013','JUN04'),
ORDERID = replace(ORDERID,'MAY013','JUN04'),
ORDERREFERENCE = replace(ORDERREFERENCE,'MAY013','JUN04'),
USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'MAY013','JUN04'),
STOCKREFERENCE = replace(STOCKREFERENCE,'135','604'),
IDORCONVERSIONID = replace(IDORCONVERSIONID,'135','604');
commit;
*/
select count (distinct ORDERID) from CASHANDSALES_ALL;
select distinct STOCKREFERENCE from CASHANDSALES_ALL;
select * from CASHANDSALES_ALL;



select * from skumar.CASHANDSALES_ALL;
select * from skumar.CASHANDSALES_ALL_DAY;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL_2 ;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL_3 ;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL_4 ;

select * from RMS.SA_TRAN_HEAD; --4263170 -
select count(1) from RMS.SA_TRAN_HEAD; --798889 -
select (select count(1) from RMS.SA_TRAN_HEAD)-479797 from dual; --  Intra day

select STORE_DAY_SEQ_NO,count(1) from RMS.SA_TRAN_HEAD  group by STORE_DAY_SEQ_NO;
select TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD group by TRAN_TYPE, SUB_TRAN_TYPE;

select STORE_DAY_SEQ_NO,TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD group by STORE_DAY_SEQ_NO,TRAN_TYPE, SUB_TRAN_TYPE;
select * from SA_TRAN_HEAD;


       NVL(EU_ST_SPLORD_cnt.cnt,0) EU_ST_SPLORD_cnt as Billed_Sale,       
       NVL(EU_ST_ORDINT_cnt.cnt,0) EU_ST_ORDINT_cnt as Liability,       
       NVL(EU_ST_ORDCMP_cnt.cnt,0) EU_ST_ORDCMP_cnt as Shipped_Sale,       



select calendar.c_date,
       NVL(EU_Transactions.cnt,0) EU_Transactions,
       NVL(EU_Billed_Sale.cnt,0) EU_Billed_Sale,       
       NVL(EU_Liability.cnt,0) EU_Liability,       
       NVL(EU_Shipped_Sale.cnt,0) EU_Shipped_Sale,       
       NVL(EU_REFUND.cnt,0) EU_REFUND,
       NVL(EU_RETURN.cnt,0) EU_RETURN
from
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Transactions,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='REFUND' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_REFUND,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='RETURN' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_RETURN,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDINT' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Liability,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='SALE'  and SUB_TRAN_TYPE= 'ORDCMP' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Shipped_Sale,
  (select ss.BUSINESS_DATE,count(sth.TRAN_SEQ_NO) cnt from SA_TRAN_HEAD sth, SA_store_Day ss where ss.STORE = '10004' and  TRAN_TYPE='SPLORD' and sth.STORE_DAY_SEQ_NO= ss.STORE_DAY_SEQ_NO and trunc(BUSINESS_DATE) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by ss.BUSINESS_DATE) EU_Billed_Sale,
  (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date FROM dual CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
 where calendar.c_date = EU_Transactions.BUSINESS_DATE(+)
and calendar.c_date = EU_REFUND.BUSINESS_DATE(+)
and calendar.c_date = EU_RETURN.BUSINESS_DATE(+)
and calendar.c_date = EU_Liability.BUSINESS_DATE(+)
and calendar.c_date = EU_Shipped_Sale.BUSINESS_DATE(+)
and calendar.c_date = EU_Billed_Sale.BUSINESS_DATE(+)
order by calendar.c_date;


select ERROR_CODE,count(1) from RMS.sa_error 
where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE = '09-MAY-21')
 group by ERROR_CODE;

select TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD where
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('09-MAY-21'))
    group by TRAN_TYPE, SUB_TRAN_TYPE order by 1,2;

select store,TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD where ERROR_IND ='N' and
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('09-MAY-21'))
    group by store,TRAN_TYPE, SUB_TRAN_TYPE order by 1,2;
    
select sd.BUSINESS_DATE,st.store,st.STORE_DAY_SEQ_NO,st.TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD st, SA_STORE_DAY sd where 
    st.STORE_DAY_SEQ_NO = sd.STORE_DAY_SEQ_NO and sd.BUSINESS_DATE >= ('01-FEB-20')
    group by sd.BUSINESS_DATE,st.store,st.STORE_DAY_SEQ_NO,st.TRAN_TYPE order by 1,2;




select * from sa_exported ;

select * from SVC_POSUPLD_STAGING;
select * from SVC_POSUPLD_STAGING_REJ;


select ERROR_CODE,count(1) from RMS.sa_error 
where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE = '01-FEB-20')
 group by ERROR_CODE;

select STORE, SYSTEM_CODE,STORE_DAY_SEQ_NO, count(1) from sa_exported where 
STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE = '09-MAY-21')
group by  STORE, SYSTEM_CODE,STORE_DAY_SEQ_NO
order by  STORE, SYSTEM_CODE,STORE_DAY_SEQ_NO;

select STORE, STORE_DAY_SEQ_NO,count(1) from sa_exported where 
STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE = '09-MAY-21')
group by  STORE, STORE_DAY_SEQ_NO;


select * from int_asos.INT_WD_SHIPPED_SALE;



--64305
select ERROR_CODE,count(1) from RMS.sa_error 
where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE = '01-FEB-20')
 group by ERROR_CODE;

select count(1) from RMS.sa_error; --78

select * from RMS.sa_error where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20')) and error_code='TRAN_OUT_BAL';

select distinct TRAN_TYPE, SUB_TRAN_TYPE, count(1) from 
    sa_tran_head where TRAN_SEQ_NO in (select TRAN_SEQ_NO from RMS.sa_error where 
                STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20'))) 
                group by TRAN_TYPE, SUB_TRAN_TYPE ;

select tran_code,count(1)  from tran_data group by tran_code;
select * from RMS.sa_error where error_code ='RETURN_DISP_REQ' and STORE_DAY_SEQ_NO='8000203';

--update RMS.SA_STORE_DAY set DATA_STATUS ='R', AUDIT_STATUS ='U'  WHERE STORE_DAY_SEQ_NO = 17000401;

select * from RMS.SA_TRAN_HEAD where TRAN_NO ='1569929';
select * from rms.period;
select * from rms.system_variables;
select * from RMS.SA_STORE_DAY order by 1 desc;

select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-JAN-19');
select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20');


select * from subclass;
select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20');
select * from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 8000203 and TRAN_SEQ_NO =45064636; ---531.25
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 8000203) and TRAN_SEQ_NO =45064636; --531.2476
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 8000203) and TRAN_SEQ_NO =45064636;
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 8000203) and TRAN_SEQ_NO =45064636; ---531.2476
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 8000203) and TRAN_SEQ_NO =45064636;
select * from RMS.sa_error where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 8000203) and TRAN_SEQ_NO =45064636;
select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec where se.store_day_seq_no ='8000203' and se.ERROR_CODE =sec.ERROR_CODE and TRAN_SEQ_NO =45064636;


select * from ordcust where ordcust_no ='33208798';
select count(1) from rms.tran_data ;
select tran_code,count(1) from rms.tran_data where trunc(tran_date)='01-MAR-20' group by tran_code;
select tran_code,count(1) from rms.tran_data where trunc(tran_date)!='23-DEC-18' group by tran_code;



select * from rms.tsfhead where tsf_no in (7027555002,7027555001);
select * from rms.tsfdetail where tsf_no in (7027555002,7027555001);
select * from rms.inv_adj where item in ('100990647','100737622','100990648');
select * from item_loc_soh where item in ('100990647','100737622') and loc in (1001,10001);
select * from item_loc_soh where item in ('100990647','100737622') and loc in (1001,10001);


select count(1) from int_asos.INT_PL_SALES_DNLD_STG;
select count(1) from int_asos.INT_PL_RETURNS_DNLD_STG;
select count(distinct item) from int_asos.INT_PL_SALES_DNLD_STG;
select count(distinct item) from int_asos.INT_PL_RETURNS_DNLD_STG;
select * from int_asos.INT_PL_SALES_DNLD_STG where item = '3139375';
select count(1) from int_asos.INT_PL_RETURNS_DNLD_STG;


select * from rms.store;

/asos/oracle/vpt/data/outbound/Integration/DailyTrans/archive
/asos/oracle/vpt/data/outbound/Integration/SalRet/archive
/asos/oracle/vpt/data/outbound/Integration/POCommitment/archive

select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-JAN-19');
select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20');
select * from SA_EXPORT_LOG where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20'));
select * from sa_total where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20'));
select * from store;
select * from mv_loc_sob;
select * from stg_fif_gl_data;
select * from STG_FIF_GL_DATA;

select * from sa_fif_gl_cross_ref where (total_id,rollup_level_1,rollup_level_2,rollup_level_3,SET_OF_BOOKS_ID) in 
    (select total_id,REF_NO1, REF_NO2, REF_NO3, mv.SET_OF_BOOKS_ID
        from sa_total sa ,mv_loc_sob mv where mv.location = sa.store and
        STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20')));


select total_id,REF_NO1, REF_NO2, REF_NO3, mv.SET_OF_BOOKS_ID
        from sa_total sa ,mv_loc_sob mv where mv.location = sa.store and
        STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('01-MAR-20'));

select * from mv_loc_sob;


