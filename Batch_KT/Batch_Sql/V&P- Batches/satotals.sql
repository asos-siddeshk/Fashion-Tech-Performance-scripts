select * from stg_fif_gl_data where ACCOUNTING_DATE ='31-DEC-18';
select ACCOUNTING_DATE,count(1) from stg_fif_gl_data group by ACCOUNTING_DATE order by 2 desc ;
Update stg_fif_gl_data set
    ACCOUNTING_DATE ='27-JAN-19', DATE_CREATED ='27-JAN-19',CURRENCY_CONVERSION_DATE='27-JAN-19' where ACCOUNTING_DATE ='31-DEC-18';
delete from stg_fif_gl_data where ACCOUNTING_DATE! ='27-JAN-19';


select * from sa_store_day where business_date >= '26-JAN-19' order by 2,1;
select * from sa_store_day where AUDIT_STATUS !='A';
select * from sa_total_head;

select * from sa_total_head where TOTAL_ID not in (select distinct TOTAL_ID from sa_total where STORE_DAY_SEQ_NO in 
    (select  STORE_DAY_SEQ_NO from sa_store_day where business_date in ('26-JAN-19','27-JAN-19')));
    
select TOTAL_ID,count(1) from v_sa_total where trunc(UPDATE_DATETIME) = trunc(sysdate) group by TOTAL_ID;

select * from v_sa_total where trunc(UPDATE_DATETIME) = trunc(sysdate) and TOTAL_SEQ_NO ='3500311' order by 2,1;
select * from v_sa_total_value where --234 / 270
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from sa_store_day where business_date in ( '26-JAN-19','27-JAN-19')) order by STORE_DAY_SEQ_NO;

select * from sa_total where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from sa_store_day where business_date in ( '26-JAN-19','27-JAN-19')); -- 234
select * from sa_sys_value where TOTAL_SEQ_NO in (select TOTAL_SEQ_NO from sa_total where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from sa_store_day where business_date in ( '26-JAN-19','27-JAN-19')));   --9898
select * from v_sa_total where TOTAL_SEQ_NO in (select TOTAL_SEQ_NO from sa_total where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from sa_store_day where business_date in ( '26-JAN-19','27-JAN-19')));   --9898

select * from all_objects where OBJECT_NAME like 'SA_T_%' and OBJECT_TYPE ='FUNCTION';

select * from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO  in (2000001);
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO in (2000001));
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO in (2000001));
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO in (2000001));
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO in (2000001));
select * from RMS.sa_error where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO in (2000001));
select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec where se.store_day_seq_no in (2000001)
    and se.ERROR_CODE =sec.ERROR_CODE;

select TOTAL_ID,count(1) from v_sa_total where trunc(UPDATE_DATETIME) = trunc(sysdate) group by TOTAL_ID;
RMS.SA_T_RTNCOGS_180611 (27)
RMS.SA_T_RTNREPL_180611 (27)
RMS.SA_T_SALECOGS_180611 (27)

select distinct BUSINESS_DATE from sa_store_day where business_date > '27-JAN-19' order by 1;

 -- Dclose 
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20190125_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190125_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190125_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190125*.dat
sed -i 's/20190715/20190125/g' RTLOG*20190125*.dat


--Store day with DCLOSE
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190127_20190610081455.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190127_20190619081455.dat
cp RTLOG_10003_20190127_20190610081455.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190127_20190619081455.dat
cp RTLOG_10004_20190127_20190610094309.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190127_20190619094309.dat
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190127_20190619081455.dat RTLOG_10001_20181229_20190619081455.dat
mv RTLOG_10003_20190127_20190619081455.dat RTLOG_10003_20181229_20190619081455.dat
mv RTLOG_10004_20190127_20190619094309.dat RTLOG_10004_20181229_20190619094309.dat
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20181229_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20181229_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20181229_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20181229*.dat
sed -i 's/20190127/20181229/g' RTLOG*20181229*.dat
sed -i 's/20190715/20181229/g' RTLOG*20181229*.dat

select * from sa_store_day where business_date < '26-JAN-19' order by 2,3;
drop table sa_store_day_bk;
create table sa_store_day_bk as 
select * from sa_store_day;
select * from sa_store_day;
select * from sa_store_day where business_date > '27-JAN-19' and store_status !='C' order by 2,3;
select * from sa_store_day_bk;

    MERGE INTO sa_store_day e
    USING sa_store_day_bk h
    ON (e.STORE_DAY_SEQ_NO = h.STORE_DAY_SEQ_NO
        and e.business_date > '27-JAN-19')
  WHEN MATCHED THEN
    UPDATE SET e.OMS_FILES_LOADED = h.OMS_FILES_LOADED;
    

Update sa_store_day set OMS_FILES_LOADED ='1' where business_date > '27-JAN-19' and store_status!='C';

select distinct BUSINESS_DATE,store from sa_store_day where business_date > '27-JAN-19' and store_status!='C' order by 1,2;

select * from sa_store_day where business_date > '27-JAN-19' and store_status='C' order by 1,2;

select * from sa_store_day where business_date > '27-JAN-19' and store_status!='C';
Update sa_store_day set OMS_FILES_LOADED ='1' where business_date > '27-JAN-19' and store_status!='C';



select count(1) from sa_store_day where business_date < '26-JAN-19' and store_status!='C';
 
begin
delete from rms.tran_data_a where TRAN_DATE!='27-JAN-19';
commit;
end;
/

select tran_date, count(1) from tran_data_a where TRAN_DATE!='27-JAN-19' group by tran_date;
select * from tran_data_a where TRAN_DATE='07-JUL-16';
select * from tran_data_a where TRAN_DATE='22-DEC-17';

select * from price_hist where item ='5675606' and loc = '1001';

cd /orabin/app/oracle/product/retail/batch/
. ./batch.profile
cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin
./satotals $UP 10001 &
./satotals $UP 10003 &
./satotals $UP 10004 &
./sarules $UP 10001 &
./sarules $UP 10003 &
./sarules $UP 10004 &


NB_STORE_DAY_SQL.RE_OPEN_STOREDAY

select * from all_objects where OBJECT_NAME like 'SA_T_%' and OBJECT_TYPE ='FUNCTION';
select * from sa_total_head where TOTAL_ID not in (select distinct TOTAL_ID from sa_total);

select TOTAL_ID,count(1) from v_sa_total where trunc(UPDATE_DATETIME) = trunc(sysdate) group by TOTAL_ID;

select TRAN_DATE,TRAN_CODE,count(1) from tran_data group by TRAN_DATE,TRAN_CODE;
select TRAN_CODE,count(1) from tran_data group by TRAN_CODE;

select * from rms.sa_store_day where BUSINESS_DATE >'26-DEC-18' and store_status!='C' order by 2,1;
select * from rms.sa_store_day where store_status!='C' order by 2,1;
select * from rms.sa_store_day where store_status='C' and AUDIT_STATUS!='A' order by 2,1;

 -- Update --
 
 Update rms.sa_store_day set STORE_CLOSED_DATETIME =BUSINESS_DATE,AUDIT_CHANGED_DATETIME =BUSINESS_DATE 
    where BUSINESS_DATE >='28-DEC-18' and store_status='C';
 
  select * from rms.sa_store_day where BUSINESS_DATE >'27-DEC-18' and store_status='C' order by 2,1;
 
 Update rms.sa_store_day set store_status ='C',STORE_CLOSED_DATETIME =BUSINESS_DATE,DATA_STATUS ='F', AUDIT_STATUS ='A',
        AUDIT_CHANGED_DATETIME =BUSINESS_DATE where trunc(BUSINESS_DATE) >= '28-JAN-19' and store_status!='C';
        
 Update rms.sa_store_day set store_status ='C',STORE_CLOSED_DATETIME =BUSINESS_DATE,DATA_STATUS ='F', AUDIT_STATUS ='A',OMS_FILES_LOADED ='2',FILES_LOADED ='0',
        AUDIT_CHANGED_DATETIME =BUSINESS_DATE where trunc(BUSINESS_DATE) >= '28-JAN-19' and store_status='C' and OMS_FILES_LOADED is null;

select * from rms.sa_store_day where  trunc(BUSINESS_DATE) >= '28-JAN-19' order by 2,1;
    
select * from rms.sa_store_day where AUDIT_STATUS!='A' order by 2,1;

    -- Yet to process --
   

cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10003_20190127_20190610081455.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190127_20190619081455.dat
cp RTLOG_10004_20190127_20190610094309.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190127_20190619094309.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10003_20190127_20190619081455.dat RTLOG_10003_20190128_20190619081455.dat
mv RTLOG_10004_20190127_20190619094309.dat RTLOG_10004_20190128_20190619094309.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190128_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190128_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190128*.dat
sed -i 's/20190127/20190128/g' RTLOG*20190128*.dat
sed -i 's/20190715/20190128/g' RTLOG*20190128*.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10003_20190127_20190610081455.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190127_20190619081455.dat
cp RTLOG_10004_20190127_20190610094309.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190127_20190619094309.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10003_20190127_20190619081455.dat RTLOG_10003_20190131_20190619081455.dat
mv RTLOG_10004_20190127_20190619094309.dat RTLOG_10004_20190131_20190619094309.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190131_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190131_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190131*.dat
sed -i 's/20190127/20190131/g' RTLOG*20190131*.dat
sed -i 's/20190715/20190131/g' RTLOG*20190131*.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10003_20190127_20190610081455.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190127_20190619081455.dat
cp RTLOG_10004_20190127_20190610094309.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190127_20190619094309.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10003_20190127_20190619081455.dat RTLOG_10003_20190214_20190619081455.dat
mv RTLOG_10004_20190127_20190619094309.dat RTLOG_10004_20190214_20190619094309.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190214_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190214_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190214*.dat
sed -i 's/20190127/20190214/g' RTLOG*20190214*.dat
sed -i 's/20190715/20190214/g' RTLOG*20190214*.dat

select * from sa_store_day where store_status!='C' and business_date >= '26-JAN-19' order by 2,1;


select * from sa_store_day where business_date > '27-JAN-19' and store_status!='C' order by 1,2;


cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20190129_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190129_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190129_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190129*.dat
sed -i 's/20190715/20190129/g' RTLOG*20190129*.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20190130_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190130_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190130_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190130*.dat
sed -i 's/20190715/20190130/g' RTLOG*20190130*.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20190204_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190204_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190204_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190204*.dat
sed -i 's/20190715/20190204/g' RTLOG*20190204*.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20190212_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190212_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190212_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190212*.dat
sed -i 's/20190715/20190212/g' RTLOG*20190212*.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive/SET
cp RTLOG_10001_20190715_20190715233001.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10001_20190715_20190715233001.dat
cp RTLOG_10004_20190715_20190715233002.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10004_20190715_20190715233002.dat
cp RTLOG_10003_20190715_20190715233003.dat /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/RTLOG_10003_20190715_20190715233003.dat
cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
mv RTLOG_10001_20190715_20190715233001.dat RTLOG_10001_20190213_20190715233001.dat
mv RTLOG_10004_20190715_20190715233002.dat RTLOG_10004_20190213_20190715233002.dat
mv RTLOG_10003_20190715_20190715233003.dat RTLOG_10003_20190213_20190715233003.dat
sed -i 's/ 1 / 2 /g' RTLOG_*20190213*.dat
sed -i 's/20190715/20190213/g' RTLOG*20190213*.dat


select * from rms.v_sa_total_value where trunc(UPDATE_DATETIME) = trunc(sysdate) ;