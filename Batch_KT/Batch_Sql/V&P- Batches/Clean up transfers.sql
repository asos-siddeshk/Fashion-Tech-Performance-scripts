select status,COUNT(1) from rms.tsfhead GROUP BY status ORDER BY 1 desc;
select doc_type,count(1) from rms.DOC_CLOSE_QUEUE group by doc_type;
select status,count(1) from tsfhead where tsf_no in (select tsf_no from apprd_tsf) group by status;
select count(1) from skumar.apprd_tsf;
select distinct tran_date,count(1) from rms.tran_data group by tran_date order by 1; --315046
delete from  if_errors;
delete from dOC_CLOSE_QUEUE where doc in (select tsf_no from tsfhead where status ='C');           
delete from skumar.apprd_tsf where tsf_no in (select tsf_no from tsfhead where status ='C');
commit;
exec system.killsession('2846');

select distinct ENTITY,count(ENTITY) from SKUMAR.VPT_LOGS where status ='E' group by ENTITY;

Update rms.tsfhead th set status ='C',CLOSE_DATE =get_vdate  where status!='C' and tsf_no in (select ENTITY_ID from SKUMAR.VPT_LOGS where STATUS='E');
Update rms.tsfhead th set status ='C',CLOSE_DATE =get_vdate  where status!='C' and tsf_no in (select doc from DOC_CLOSE_QUEUE);

delete from SKUMAR.VPT_LOGS where STATUS='E';

insert into apprd_tsf 
select tsf_no from tsfhead th where status ='A' 
    and not exists (select 1 from rms.shipsku sk where sk.distro_no = th.tsf_no) 
    and not exists (select 1 from apprd_tsf sk2 where sk2.tsf_no = th.tsf_no) and rownum<= '150000';

select count(1) from apprd_tsf;
select count(1) from tsfhead where tsf_no in (select tsf_no from apprd_tsf) ; --518034
select status,count(1) from tsfhead where tsf_no in (select tsf_no from apprd_tsf) group by status;
select sh.status_code,count(1) from shipment sh,shipsku sk where sh.shipment =sk.shipment and sk.distro_no in (select tsf_no from apprd_tsf) group by sh.status_code;
select count(distinct(sh.shipment)) from shipment sh,shipsku sk where sh.shipment =sk.shipment and sk.distro_no in (select tsf_no from apprd_tsf);


select create_date,count(1) from tsfhead group by create_date order by 1;
select close_date,count(1) from tsfhead group by close_date order by 1 desc;

update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;



set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE VARCHAR2(255);
  O_CLOSED BOOLEAN;
  I_TSF_NO NUMBER;
  v_Return BOOLEAN;
   c_commit NUMBER(8)                     := 1;
  cursor c_tsf is
     select doc from rms.doc_close_queue d where doc_type ='T' ;
BEGIN 
for k in 0..10 loop 
for m in c_tsf loop
	I_TSF_NO := m.doc;
  v_Return := RMS.APPT_DOC_CLOSE_SQL.CLOSE_TSF(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    O_CLOSED => O_CLOSED,
    I_TSF_NO => I_TSF_NO);
    IF (v_Return) THEN 
delete from rms.DOC_CLOSE_QUEUE where doc = I_TSF_NO;
    ELSE
insert into rms.if_errors (PROGRAM_NAME,ERR_DATE,UNIT_OF_WORK,ERROR)values ('TSF_CLOSE',sysdate,I_TSF_NO,O_ERROR_MESSAGE);
  END IF;
   c_commit :=c_commit + 1;
       IF MOD(c_commit, 10) = 0 THEN
        COMMIT;
       END IF;
  end loop;
  commit;
end loop;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/ 



select create_date,count(1) from tsfhead group by create_date order by 1 desc;
select close_date,count(1) from tsfhead group by close_date order by 1 desc;

select create_date,count(1) from tsfhead group by create_date order by 1 desc;
select close_date,count(1) from tsfhead group by close_date order by 1 desc;

set serveroutput on;
set timing on;
declare 
L_date date;
begin
for k in 0..19 loop
select vdate-32-k into l_date from period;
Update rms.tsfhead th set CREATE_DATE =l_date  where CREATE_DATE ='22-OCT-18' and rownum<='50000';
 commit;
end loop;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/