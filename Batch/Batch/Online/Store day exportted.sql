select count(1) from tsf_mfqueue;
select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE ! = '27-JAN-19' ;
select * from item_mfqueue where item ='5499005';
select * from order_mfqueue;

select distinct TOTAL_ID from v_sa_total where store_day_seq_no = '14000001';

select TOTAL_ID,count(1) from sa_total where trunc(UPDATE_DATETIME) = trunc(sysdate) group by TOTAL_ID;

select * from sa_store_day where business_date >= '08-MAY-21' order by 2,1;
select * from sa_store_day order by 2,1;
select * from sa_store_day where business_date >= '08-MAY-21' order by 2,1;
select SYSTEM_CODE,count(1) from sa_exported where store_day_seq_no ='273000401' group by SYSTEM_CODE;

RA	    776604
WEBDEP	652738
CORET	122304
RMS	    676689
GL	    10182
RPAS	246170

begin
delete from sa_exported where store_day_seq_no ='272000401' and system_code ='GL';
delete from sa_export_log where store_day_seq_no ='272000401' and system_code ='GL';
delete from sa_exported where store_day_seq_no ='272000402' and system_code ='GL';
delete from sa_export_log where store_day_seq_no ='272000402' and system_code ='GL';
delete from sa_exported where store_day_seq_no ='272000403' and system_code ='GL';
delete from sa_export_log where store_day_seq_no ='272000403' and system_code ='GL';
delete from sa_exported where store_day_seq_no ='272000401' and system_code ='RPAS';
delete from sa_export_log where store_day_seq_no ='272000401' and system_code ='RPAS';
delete from sa_exported where store_day_seq_no ='272000402' and system_code ='RPAS';
delete from sa_export_log where store_day_seq_no ='272000402' and system_code ='RPAS';
delete from sa_exported where store_day_seq_no ='272000403' and system_code ='RPAS';
delete from sa_export_log where store_day_seq_no ='272000403' and system_code ='RPAS';
commit;
end;
/

select count(1) from sa_tran_head where store_day_seq_no ='272000402'; 
    -- Other than DCLOSE -- RMS & RA
    -- return - CORET
    -- RPAS  SPLORD & RETURN
    -- GL  -- total_seq_no
    select * from sa_tran_head sth where store_day_seq_no ='15007401' and TRAN_TYPE in ('SPLORD','RETURN')  and
        not exists (select 1 from sa_exported se where se.store_day_seq_no = sth.store_day_seq_no
                                    and se.system_code ='RPAS'
                                and se.TRAN_SEQ_NO = sth.TRAN_SEQ_NO) ;

select tran_type, sub_TRAN_TYPE,  count(1) from sa_tran_head where store_day_seq_no ='15007401' group by tran_type, sub_TRAN_TYPE; -- Other than dclose -- RMS & RA
select SYSTEM_CODE,count(1) from sa_exported where store_day_seq_no ='15007401' group by SYSTEM_CODE;

select * from sa_exported where store_day_seq_no ='15007401' and system_code ='GL';
select * from sa_export_log where store_day_seq_no ='15007401';
select * from v_sa_total where store_day_seq_no ='15007401';


select SYSTEM_CODE,STATUS,count(1) from sa_export_log group by SYSTEM_CODE,STATUS order by 1,2,3;

select * from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  not in ('08-MAY-21','27-JAN-19')) order by 2,1;
 
select * from sa_tran_head where ERROR_IND = 'N'; 



 -- GL  -- done

set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_TOTAL_SEQ_NO              v_sa_total.TOTAL_SEQ_NO%type;
    l_tran_type                 sa_tran_head.tran_type%type := 'DCLOSE';
    l_export_seq_no             sa_exported.export_seq_no%type;
    l_exp_datetime              sa_exported.exp_datetime%type;
    l_store                     sa_exported.store%type;
    l_day                       sa_exported.day%type;
    l_system_code               sa_exported.system_code%type := 'GL';
    
    l_counter           number(10) := 0;
    
cursor c_custord is
   select store_day_seq_no, business_date, store, day from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  not in ('08-MAY-21','27-JAN-19','27-AUG-19')) order by 2,1;
   
cursor c_custord_exp (k_store_day_seq_no sa_store_day.store_day_seq_no%type)is
    select sth.TOTAL_SEQ_NO from v_sa_total sth where sth.store_day_seq_no = k_store_day_seq_no and 
        not exists (select 1 from sa_exported se where se.store_day_seq_no = sth.store_day_seq_no
                                and se.system_code = l_system_code and se.TOTAL_SEQ_NO = sth.TOTAL_SEQ_NO) ;
   
    
begin
for i in c_custord loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_exp_datetime        := i.business_date;
    l_store               := i.store;
    l_day                 := i.day;

    for k in c_custord_exp (l_store_day_seq_no) loop
        l_TOTAL_SEQ_NO := k.TOTAL_SEQ_NO;
    
            select sa_export_seq_no_sequence.nextval into l_export_seq_no from dual;
    
          insert into sa_exported (store, day, export_seq_no, store_day_seq_no, TOTAL_SEQ_NO, system_code, exp_datetime, status)
                            values(l_store,l_day,l_export_seq_no,l_store_day_seq_no,l_TOTAL_SEQ_NO,l_system_code,l_exp_datetime,'P');
    
             l_counter := l_counter+1;
     	if mod(l_counter, 1000) = 0 then
                commit;
			   end if;	
    	end loop;  
        
        update sa_export_log set status ='E', datetime =l_exp_datetime where status!='E' and
            store_day_seq_no = l_store_day_seq_no and system_code = l_system_code;

    end loop;                         
    
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


 -- RA  -- done

set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_tran_seq_no               sa_tran_head.tran_seq_no%type;
    l_tran_type                 sa_tran_head.tran_type%type := 'DCLOSE';
    l_export_seq_no             sa_exported.export_seq_no%type;
    l_exp_datetime              sa_store_day.business_date%type;
    l_store                     sa_store_day.store%type;
    l_day                       sa_store_day.day%type;
    l_system_code               sa_exported.system_code%type := 'RA'; --'RMS'; 
    
    l_counter           number(10) := 0;
    
cursor c_custord is
   select store_day_seq_no, business_date, store, day from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  not in ('08-MAY-21','27-JAN-19','27-AUG-19')) order by 2,1;
   
cursor c_custord_exp (k_store_day_seq_no sa_store_day.store_day_seq_no%type)is
    select sth.tran_seq_no from sa_tran_head sth where store_day_seq_no = k_store_day_seq_no and sth.tran_type!=l_tran_type and sth.ERROR_IND = 'N' and 
        not exists (select 1 from sa_exported se where se.store_day_seq_no = sth.store_day_seq_no
                                and se.system_code = l_system_code and se.tran_seq_no = sth.tran_seq_no) ;
   
    
begin
for i in c_custord loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_exp_datetime        := i.business_date;
    l_store               := i.store;
    l_day                 := i.day;

    for k in c_custord_exp (l_store_day_seq_no) loop
        l_tran_seq_no := k.tran_seq_no;
    
            select sa_export_seq_no_sequence.nextval into l_export_seq_no from dual;
    
          insert into sa_exported (store, day, export_seq_no, store_day_seq_no, tran_seq_no, system_code, exp_datetime, status)
                            values(l_store,l_day,l_export_seq_no,l_store_day_seq_no,l_tran_seq_no,l_system_code,l_exp_datetime,'P');
    
             l_counter := l_counter+1;
     	if mod(l_counter, 1000) = 0 then
                commit;
			   end if;	
    	end loop;  
        
        update sa_export_log set status ='E', datetime =l_exp_datetime where store_day_seq_no = l_store_day_seq_no and system_code = l_system_code;

    end loop;                         
    
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


 -- RMS  -- done

set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_tran_seq_no               sa_tran_head.tran_seq_no%type;
    l_tran_type                 sa_tran_head.tran_type%type := 'DCLOSE';
    l_export_seq_no             sa_exported.export_seq_no%type;
    l_exp_datetime              sa_store_day.business_date%type;
    l_store                     sa_store_day.store%type;
    l_day                       sa_store_day.day%type;
    l_system_code               sa_exported.system_code%type := 'RMS'; --'RMS'; 
    
    l_counter           number(10) := 0;
    
cursor c_custord is
   select store_day_seq_no, business_date, store, day from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  not in ('08-MAY-21','27-JAN-19','27-AUG-19')) order by 2,1;
   
cursor c_custord_exp (k_store_day_seq_no sa_store_day.store_day_seq_no%type)is
    select sth.tran_seq_no from sa_tran_head sth where store_day_seq_no = k_store_day_seq_no and sth.tran_type!=l_tran_type and sth.ERROR_IND = 'N' and 
        not exists (select 1 from sa_exported se where se.store_day_seq_no = sth.store_day_seq_no
                                and se.system_code = l_system_code and se.tran_seq_no = sth.tran_seq_no) ;
   
    
begin
for i in c_custord loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_exp_datetime        := i.business_date;
    l_store               := i.store;
    l_day                 := i.day;

    for k in c_custord_exp (l_store_day_seq_no) loop
        l_tran_seq_no := k.tran_seq_no;
    
            select sa_export_seq_no_sequence.nextval into l_export_seq_no from dual;
    
          insert into sa_exported (store, day, export_seq_no, store_day_seq_no, tran_seq_no, system_code, exp_datetime, status)
                            values(l_store,l_day,l_export_seq_no,l_store_day_seq_no,l_tran_seq_no,l_system_code,l_exp_datetime,'P');
    
             l_counter := l_counter+1;
     	if mod(l_counter, 1000) = 0 then
                commit;
			   end if;	
    	end loop;  
        
        update sa_export_log set status ='E', datetime =l_exp_datetime where store_day_seq_no = l_store_day_seq_no and system_code = l_system_code;

    end loop;                         
    
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/

 -- CORET -- done

set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_tran_seq_no               sa_tran_head.tran_seq_no%type;
    l_tran_type                 sa_tran_head.tran_type%type := 'RETURN';
    l_export_seq_no             sa_exported.export_seq_no%type;
    l_exp_datetime              sa_store_day.business_date%type;
    l_store                     sa_store_day.store%type;
    l_day                       sa_store_day.day%type;
    l_system_code               sa_exported.system_code%type := 'CORET';
    
    l_counter           number(10) := 0;
    
cursor c_custord is
   select store_day_seq_no, business_date, store, day from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  not in ('08-MAY-21','27-JAN-19','27-AUG-19')) order by 2,1;
   
cursor c_custord_exp (k_store_day_seq_no sa_store_day.store_day_seq_no%type)is
    select sth.tran_seq_no from sa_tran_head sth where store_day_seq_no = k_store_day_seq_no and sth.tran_type=l_tran_type and sth.ERROR_IND = 'N' and 
        not exists (select 1 from sa_exported se where se.store_day_seq_no = sth.store_day_seq_no
                                and se.system_code = l_system_code and se.tran_seq_no = sth.tran_seq_no);
   
    
begin
for i in c_custord loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_exp_datetime        := i.business_date;
    l_store               := i.store;
    l_day                 := i.day;

    for k in c_custord_exp (l_store_day_seq_no) loop
        l_tran_seq_no := k.tran_seq_no;
    
            select sa_export_seq_no_sequence.nextval into l_export_seq_no from dual;
    
          insert into sa_exported (store, day, export_seq_no, store_day_seq_no, tran_seq_no, system_code, exp_datetime, status)
                            values(l_store,l_day,l_export_seq_no,l_store_day_seq_no,l_tran_seq_no,l_system_code,l_exp_datetime,'P');
    
             l_counter := l_counter+1;
     	if mod(l_counter, 1000) = 0 then
                commit;
			   end if;	
    	end loop;  
        
        update sa_export_log set status ='E', datetime =l_exp_datetime where store_day_seq_no = l_store_day_seq_no and system_code = l_system_code;

    end loop;                         
    
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


-- RPAS -- done

set timing on;
set serveroutput on;

declare
    l_store_day_seq_no          sa_store_day.store_day_seq_no%type;
    l_tran_seq_no               sa_tran_head.tran_seq_no%type;
    l_tran_type                 sa_tran_head.tran_type%type := 'RETURN';
    l_export_seq_no             sa_exported.export_seq_no%type;
    l_exp_datetime              sa_store_day.business_date%type;
    l_store                     sa_store_day.store%type;
    l_day                       sa_store_day.day%type;
    l_system_code               sa_exported.system_code%type := 'RPAS';
    
    l_counter           number(10) := 0;
    
cursor c_custord is
   select store_day_seq_no, business_date, store, day from sa_store_day where store_day_seq_no
    in (select STORE_DAY_SEQ_NO from sa_store_day where BUSINESS_DATE  not in ('08-MAY-21','27-JAN-19','27-AUG-19')) order by 2,1;
   
cursor c_custord_exp (k_store_day_seq_no sa_store_day.store_day_seq_no%type)is
    select sth.tran_seq_no from sa_tran_head sth where store_day_seq_no = k_store_day_seq_no and sth.TRAN_TYPE in ('SPLORD','RETURN') and sth.ERROR_IND = 'N' and 
        not exists (select 1 from sa_exported se where se.store_day_seq_no = sth.store_day_seq_no
                                and se.system_code = l_system_code and se.tran_seq_no = sth.tran_seq_no);
   
    
begin
for i in c_custord loop 
	l_store_day_seq_no    := i.store_day_seq_no;
    l_exp_datetime        := i.business_date;
    l_store               := i.store;
    l_day                 := i.day;

    for k in c_custord_exp (l_store_day_seq_no) loop
        l_tran_seq_no := k.tran_seq_no;
    
            select sa_export_seq_no_sequence.nextval into l_export_seq_no from dual;
    
          insert into sa_exported (store, day, export_seq_no, store_day_seq_no, tran_seq_no, system_code, exp_datetime, status)
                            values(l_store,l_day,l_export_seq_no,l_store_day_seq_no,l_tran_seq_no,l_system_code,l_exp_datetime,'P');
    
             l_counter := l_counter+1;
     	if mod(l_counter, 1000) = 0 then
                commit;
			   end if;	
    	end loop;  
        
        update sa_export_log set status ='E', datetime =l_exp_datetime where store_day_seq_no = l_store_day_seq_no and system_code = l_system_code;

    end loop;                         
    
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/