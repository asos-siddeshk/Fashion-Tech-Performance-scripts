select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq= '28891';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq= '28891';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq= '28891';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq= '28891';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq= '28891';


select * from item_master where ITEM >='178664453' and item_level = '1' and ITEM_DESC like '%upload%';

select STORE_DAY_SEQ_NO,count(1) from int_asos.INT_CUST_RETURNS_DNLD_STG group by STORE_DAY_SEQ_NO;
select * from int_asos.INT_CUST_RETURNS_DNLD_STG ;

select STORE_DAY_SEQ_NO,count(1) from int_asos.INT_CUST_RETURNS_DNLD_STG group by STORE_DAY_SEQ_NO;

  select store_day_seq_no, business_date, store, day from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  in ('26-JAN-19','27-JAN-19','27-AUG-19')) order by 2,1;

select * from sa_tran_head where tran_seq_no in (select tran_seq_no from sa_exported where SYSTEM_CODE = 'CORET' 
    and STORE_DAY_SEQ_NO= '14000001') order by 3;


begin
delete from sa_exported where SYSTEM_CODE = 'CORET' and STORE_DAY_SEQ_NO= '14000001';
delete from sa_exported where SYSTEM_CODE = 'CORET' and STORE_DAY_SEQ_NO= '14000002';
delete from sa_exported where SYSTEM_CODE = 'CORET' and STORE_DAY_SEQ_NO= '14000003';
commit;
end;
/

select * from ALL_TAB_PARTITIONS where table_name like '%CUST%'


select * from int_asos.INT_CUST_RETURNS_DNLD_STG group by STORE_DAY_SEQ_NO;
select * from int_asos.INT_CUST_RETURNS_DNLD_STG ;


select trunc(EXTRACT_DATE),count(1) from int_asos.INT_CUST_RETURNS_DNLD_STG group by trunc(EXTRACT_DATE);
select * from int_asos.INT_CUST_RETURNS_DNLD_STG ;


update int_asos.INT_CUST_RETURNS_DNLD_STG  set EXTRACT_DATE= '27-JAN-2019' 
    where trunc(EXTRACT_DATE)='18-MAR-19' and rownum<= '30';

