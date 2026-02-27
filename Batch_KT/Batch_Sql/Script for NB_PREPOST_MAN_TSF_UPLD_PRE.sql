--This script is run before starting Intra day job TRANSFER_UPLOAD_PROCESS (NB_PREPOST_MAN_TSF_UPLD_PRE)
set serveroutput on;
set timing on;

declare
   
        l_int_seq_no    INT_ASOS.INT_BATCH_QUEUE.SEQ_NO%type;            
        l_filename         INT_ASOS.INT_BATCH_QUEUE.EXT_REF_NO%type;

cursor c_tsf_upld  is
    select distinct FILENAME 
        from int_asos.int_stg_man_tsf_upld 
         where status = 'U';

begin

delete from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_batch_man_tsf_ulpd';

for r in c_tsf_upld loop 
   l_filename := r.FILENAME;
   
insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) 
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_batch_man_tsf_ulpd','N',l_filename,'T','INT_ASOS',sysdate,'INT_ASOS',sysdate
    from dual;

end loop;     
commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/