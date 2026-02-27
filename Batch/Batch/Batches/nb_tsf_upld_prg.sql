  select * from int_asos.int_stg_man_tsf_upld 
     where status = 'S'
       and process_datetime < get_vdate - 90; --3000
       
  select * from int_asos.int_stg_man_tsf_upld 
     where status = 'S'
       and trunc(process_datetime) ='01-OCT-21'; --3000
       
       
       
       /*
---------------------------Batch name:RMS.NB_BATCH_MAN_TSF_UPLD_PROCESS----------------------------------
1.Custom table																:SKUMAR.cust_tsf_upld.
2.Bulk inserted the records to the custom table								:SKUMAR.cust_tsf_upld.(Transaction volume:*** records)
3.PL/SQL script execution that will insert the records to the staging table :INT_ASOS.int_stg_man_tsf_upld
4.Batch execution 															:RMS.NB_BATCH_MAN_TSF_UPLD_PROCESS via Automic.
----------------------------------------------------------------------------------------------


  select * from int_asos.int_stg_man_tsf_upld 
     where status = 'S'
       and process_datetime < get_vdate - 90;
       
       
       
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
 l_date DATE;
 
BEGIN

for k in 1..92 loop    

select vdate into l_date from rms.period;

insert into int_asos.int_stg_man_tsf_upld
select rms.INT_STG_MAN_TSF_UPLD_SEQ.nextval, RECORD_TYPE, 'FILE_RETEN', l_date-k, 
  ITEM_ID, FROM_LOC_TYPE, FROM_LOC, TO_LOC_TYPE, TO_LOC, QUANTITY, 'S', l_date-k, ERROR_MESSAGE, THREAD_NO
  from int_asos.int_stg_man_tsf_upld where CREATE_DATETIME like '15-NOV-22';

end loop;
commit;


EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/
       
       
       
       