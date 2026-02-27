set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_tran_type                 varchar2(10);
    l_DUMMY                     varchar2(100);
    l_store                     sa_exported.store%type;
    l_day                       varchar2(10);
    l_tran_seq_no               sa_tran_head.tran_seq_no%type;
    l_tran_first_no             sa_tran_head.tran_no%type;
    l_tran_no                   sa_tran_head.tran_no%type;
    l_tran_n_no                 sa_tran_head.tran_no%type;
    
cursor c_str is
   select store_day_seq_no, store, to_char(BUSINESS_DATE, 'YYYYMMDD') as BUSINESS_DATE
     from sa_store_day where 
     --BUSINESS_DATE in ('10-NOV-21','09-NOV-21','08-NOV-21') AND store = '10004' and 
     store_day_seq_no = '275000403'
     ORDER BY store_day_seq_no;
     
cursor c_str_tran (l_store_day_seq_no sa_store_day.store_day_seq_no%type) is
   select  tran_seq_no, tran_no --, tran_no as tran_n_no
     from  sa_tran_head sth 
     where store_day_seq_no = l_store_day_seq_no
--     and TRAN_SEQ_NO between 16768334639 and  16768334859
     and sth.TRAN_NO in ('100817277','100817286','100817287','100817288','100817289') --,'100817290','100817291','100817292','100817293') 
     ORDER BY TRAN_SEQ_NO;

 cursor c_gt_ntran (l_store_day_seq_no sa_store_day.store_day_seq_no%type,l_tran_seq_no sa_tran_head.tran_seq_no%type) is
    select tran_no 
     from SA_TRAN_HEAD 
    where store_day_seq_no = l_store_day_seq_no and TRAN_SEQ_NO = l_tran_seq_no+1;


begin
 for i in c_str loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_store               := i.store;
    l_day                 := i.BUSINESS_DATE;

 for k in c_str_tran (l_store_day_seq_no) loop
    l_tran_seq_no          := k.tran_seq_no;
    l_tran_no              := k.tran_no;
    l_tran_first_no         := k.tran_no;
--  l_tran_n_no            := k.tran_n_no;
     

 for l in c_gt_ntran (l_store_day_seq_no,l_tran_seq_no) loop
    l_tran_n_no          := l.tran_no;

        DBMS_OUTPUT.PUT_LINE( 'l_tran_n_no : bfr  WHILE ' || l_tran_n_no );

    WHILE (l_tran_no - l_tran_n_no = 1)
      LOOP
        DBMS_OUTPUT.PUT_LINE( 'l_tran_no : bfr' || l_tran_no );
        DBMS_OUTPUT.PUT_LINE( 'l_tran_n_no : bfr' || l_tran_n_no );
           l_tran_n_no := rms.FINDTRAN (l_store_day_seq_no,l_tran_no);
        DBMS_OUTPUT.PUT_LINE( 'l_tran_no : afrt' || l_tran_no );
        DBMS_OUTPUT.PUT_LINE( 'l_tran_n_no : afrt' || l_tran_n_no );
        EXIT WHEN (l_tran_no = l_tran_n_no);
           l_tran_no := l_tran_n_no +1;
      END LOOP;
    end loop;                            

        DBMS_OUTPUT.PUT_LINE( 'l_tran_no : insrt' || l_tran_no );
        DBMS_OUTPUT.PUT_LINE( 'l_tran_n_no : insrt' || l_tran_n_no );

  SELECT l_store || ',' || TO_NUMBER(l_tran_first_no) || ',' || l_day ||',N,'|| TO_NUMBER(l_tran_n_no) || ',' || l_day ||',N'  into l_DUMMY
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

