select trunc(ADJ_DATE),count(1) from inv_adj group by trunc(ADJ_DATE) order by 1; --17-MAY-18	44100

SELECT count(1)
    FROM inv_adj
   WHERE (:pi_inv_adj_months < MONTHS_BETWEEN(to_date(:ps_vdate,'YYYYMMDD'),inv_adj.adj_date));
       
select vdate-31 from period;
   
select count(1) from inv_adj where trunc(adj_date) ='08-MAY-21';

set serveroutput on;
set timing on;
DECLARE
l_inv_date date;

BEGIN
select vdate into l_inv_date from period;

for k in 170..180 loop     
select vdate-k into l_inv_date from period;
insert into rms.inv_adj
    select  ITEM,INV_STATUS,LOC_TYPE,LOCATION,ADJ_QTY ,REASON,l_inv_date,PREV_QTY,USER_ID ,ADJ_WEIGHT ,ADJ_WEIGHT_UOM,CREATE_ID ,CREATE_DATETIME 
        from rms.inv_adj inv1 where trunc(adj_date) = '09-MAY-21';

commit;
end loop;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/