select * from sa_tran_head where TRAN_SEQ_NO >= 1141080001 and TRAN_TYPE = 'RETURN'; 360k     

select * from all_sequences where sequence_name like 'SA%TRAN%';


cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'THEAD' RTLOG*.dat | wc -l
353555
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'FHEAD' RTLOG*.dat | wc -l
18
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDINT' RTLOG*.dat | wc -l
68794
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'SPLORD' RTLOG*.dat | wc -l
66787
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'RETURN' RTLOG*.dat | wc -l
147664
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDCMP' RTLOG*.dat | wc -l
70310
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'THEAD' RTLOG_10001*.dat | wc -l
151700
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'FHEAD' RTLOG_10001*.dat | wc -l
6
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDINT' RTLOG_10001*.dat | wc -l
33695
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'SPLORD' RTLOG_10001*.dat | wc -l
32739
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'RETURN' RTLOG_10001*.dat | wc -l
50958
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDCMP' RTLOG_10001*.dat | wc -l
34308
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'THEAD' RTLOG_10003*.dat | wc -l
101134
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'FHEAD' RTLOG_10003*.dat | wc -l
6
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDINT' RTLOG_10003*.dat | wc -l
18649
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'SPLORD' RTLOG_10003*.dat | wc -l
17954
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'RETURN' RTLOG_10003*.dat | wc -l
45591
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDCMP' RTLOG_10003*.dat | wc -l
18940
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'THEAD' RTLOG_10004*.dat | wc -l
100721
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'FHEAD' RTLOG_10004*.dat | wc -l
6
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDINT' RTLOG_10004*.dat | wc -l
16450
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'SPLORD' RTLOG_10004*.dat | wc -l
16094
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'RETURN' RTLOG_10004*.dat | wc -l
51115
[siddeshk@vptpreuwormsd01 pending]$ grep -o 'ORDCMP' RTLOG_10004*.dat | wc -l
17062


select ref_no2,count(1) from sa_tran_head where TRAN_SEQ_NO >= 1141080001 and TRAN_TYPE ='RETURN' group by ref_no2;
select * from sa_tran_head where TRAN_SEQ_NO >= 1141080001 and ref_no_2 is not null;

select count(1) from sa_tran_head where TRAN_SEQ_NO >= 1141442944;


begin
Update RMS.SA_TRAN_HEAD set REF_NO2 = '20190127' where TRAN_SEQ_NO >= 1141442944 and tran_type = 'RETURN';
commit;
end;
/

Update SA_TRAN_HEAD set REF_NO2 = '20190127153524' where TRAN_SEQ_NO >= 1141442944 and tran_type = 'RETURN';

select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('27-JAN-19');
select * from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000001 and TRAN_SEQ_NO  >= 1141442944; ---531.25
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000001) and TRAN_SEQ_NO  >= 1141442944; --531.2476
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000001) and TRAN_SEQ_NO  >= 1141442944;
select * from RMS.SA_TRAN_TENDER where TRAN`_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000001) and TRAN_SEQ_NO  >= 1141442944; ---531.2476
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000001) and TRAN_SEQ_NO  >= 1141442944;
select * from RMS.sa_error where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO = 14000001) and TRAN_SEQ_NO  >= 1141442944;

select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec 
    where se.ERROR_CODE =sec.ERROR_CODE and TRAN_SEQ_NO >= 1141442944;


select * from SA_EXPORT_LOG where STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('27-JAN-19'));

select * from sa_exported where TRAN_SEQ_NO >= 1141442944 and system_code = 'RA';
select * from sa_customer;


select * from sa_store_emp;
select * from sales_exp_DS where tran_type = 'RETURN';


select STORE,TRAN_TYPE, SUB_TRAN_TYPE,count(1)*5 as trns_count from sales_exp_DS group by STORE,TRAN_TYPE, SUB_TRAN_TYPE ;

select distinct REF_NO2 from sales_exp_DS where tran_type = 'RETURN';