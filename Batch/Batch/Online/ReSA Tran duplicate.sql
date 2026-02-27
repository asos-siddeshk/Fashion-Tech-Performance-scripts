

select * from RMS.sa_store_day where BUSINESS_DATE in('10-NOV-21') order by 3 desc;


select * from RMS.SA_TRAN_HEAD where TRAN_NO in ('100817286','100817287','100817288','100817290') and store ='10004';



select * from RMS.SA_TRAN_HEAD where STORE_DAY_SEQ_NO ='458000602'; ---531.25
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_NO ='20736650'); --531.2476
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO in  (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_NO ='20736650'); 
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_NO ='20736650');  ---531.2476
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO in (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_NO ='20736650'); 
select * from RMS.sa_error where TRAN_SEQ_NO in  (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_NO ='20736650'); 
select se.*,sec.error_desc from rms.sa_error se,rms.sa_error_codes sec where 
    se.ERROR_CODE =sec.ERROR_CODE and TRAN_SEQ_NO in 
    (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_NO ='16763167002');


SELECT ST.store || ',' || TO_NUMBER(TRAN_NO) || ',' || SS.BUSINESS_DATE ||',N,'|| TO_NUMBER(TRAN_NO+1) || ',' || SS.BUSINESS_DATE ||',N'  AS INCT
  from RMS.SA_TRAN_HEAD ST,sa_store_day SS 
 where ST.STORE_DAY_SEQ_NO ='275000403' AND ST.STORE_DAY_SEQ_NO =SS.STORE_DAY_SEQ_NO ORDER BY TRAN_SEQ_NO;


select * from RMS.sa_store_day ;



select ST.* from  RMS.SA_TRAN_HEAD ST,sa_store_day SS 
where st.TRAN_NO between 100817277 and 100817360
 --in ('100817286','100817287','100817288','100817289','100817290','100817291','100817292','100817293','100817294') 
 and  st.store ='10004'
 --and ST.STORE_DAY_SEQ_NO ='272000403' 
 AND ST.STORE_DAY_SEQ_NO =SS.STORE_DAY_SEQ_NO ORDER BY TRAN_SEQ_NO;
/*  

tdup file - base
10004,100817277,20210511,N,100817277,20210511,N 
10004,100817287,20210511,N,100817288,20210511,N 
10004,100817290,20210511,N,100817292,20210511,N
10004,100817359,20210511,N,100817360,20210511,N 

Our file
10004,100817277,20210511,N,100817277,20210511,N 
10004,100817287,20210511,N,100817287,20210511,N 
10004,100817288,20210511,N,100817288,20210511,N 
10004,100817290,20210511,N,100817290,20210511,N
10004,100817291,20210511,N,100817291,20210511,N
10004,100817292,20210511,N,100817292,20210511,N
10004,100817359,20210511,N,100817359,20210511,N 
10004,100817360,20210511,N,100817360,20210511,N

*/


select st.* from  RMS.SA_TRAN_HEAD ST,sa_store_day SS 
  where st.TRAN_NO in ('100817286','100817287','100817288','100817289','100817290','100817291','100817292','100817293') and st.store ='10004'
   and ST.STORE_DAY_SEQ_NO ='272000403' AND ST.STORE_DAY_SEQ_NO =SS.STORE_DAY_SEQ_NO ORDER BY TRAN_NO;

SELECT ST.store || ',' || TO_NUMBER(TRAN_NO) || ',' || to_char(SS.BUSINESS_DATE, 'YYYYMMDD')
||',N,'|| TO_NUMBER(TRAN_NO+1) || ',' || to_char(SS.BUSINESS_DATE, 'YYYYMMDD')||',N'  AS INCT
  from RMS.SA_TRAN_HEAD ST,sa_store_day SS 
 where ST.STORE_DAY_SEQ_NO ='458000602' AND ST.STORE_DAY_SEQ_NO =SS.STORE_DAY_SEQ_NO ORDER BY TRAN_SEQ_NO;


create table rtlogtdup(sample_data varchar2(100));

TRUNCATE TABLE rtlogtdup;

SELECT * from rtlogtdup;


set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_tran_type                 varchar2(10);
    l_DUMMY                     varchar2(100);
    l_store                     sa_exported.store%type;
    l_day                       varchar2(10);
    l_tran_seq_no               sa_tran_head.tran_seq_no%type;
    l_tran_no                   sa_tran_head.tran_no%type;
    l_tran_n_no                   sa_tran_head.tran_no%type;
    
cursor c_str is
   select store_day_seq_no, store, to_char(BUSINESS_DATE, 'YYYYMMDD') as BUSINESS_DATE
     from sa_store_day where BUSINESS_DATE in ('10-NOV-21','09-NOV-21','08-NOV-21') AND store = '10004'
     --and store_day_seq_no = '458000604'
     ORDER BY store_day_seq_no;
     
   
cursor c_str_tran (l_store_day_seq_no sa_store_day.store_day_seq_no%type) is
   select  tran_seq_no, tran_no, tran_no as tran_n_no
     from  sa_tran_head sth 
     where store_day_seq_no = l_store_day_seq_no
     --and TRAN_SEQ_NO between 16768334639 and  16768334859
     ORDER BY TRAN_SEQ_NO;


begin
 for i in c_str loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_store               := i.store;
    l_day                 := i.BUSINESS_DATE;

 for k in c_str_tran (l_store_day_seq_no) loop
    l_tran_seq_no          := k.tran_seq_no;
    l_tran_no              := k.tran_no;
    l_tran_n_no            := k.tran_n_no;
     
  SELECT l_store || ',' || TO_NUMBER(l_tran_no) || ',' || l_day ||',N,'|| TO_NUMBER(l_tran_n_no) || ',' || l_day ||',N'  into l_DUMMY
    from dual;
  insert into rtlogtdup (sample_data) values (l_DUMMY);
     -- dbms_output.put_line('l_DUMMY'||l_DUMMY);

    end loop;                            
    end loop;                            
  commit;   
        
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
