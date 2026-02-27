select distinct trunc(DAY_DATE),count(1) from SUP_DATA group by trunc(DAY_DATE) order by 1;

select distinct DAY_DATE,count(1) from SUP_DATA group by DAY_DATE order by 1;
select HALF_NO, MONTH_NO,count(MONTH_NO) from SUP_MONTH group by HALF_NO, MONTH_NO order by HALF_NO, MONTH_NO;
select * from SUP_MONTH;
select * from SUP_DATA;
 SELECT last_eom_date_unit,
              next_eom_date_unit
         FROM rms.system_variables;

 SELECT sd.dept,
              TO_CHAR(sd.supplier),
              sd.tran_type,
              SUM(sd.amount),
              ';'||TO_CHAR(sd.dept)||
              ';'||TO_CHAR(sd.supplier)
         FROM rms.v_restart_dept rv, 
              rms.sup_data sd
        WHERE rv.driver_value = sd.dept
          AND TRUNC(sd.day_date) > '02-DEC-18'
          AND TRUNC(sd.day_date) <= '30-DEC-18'
     GROUP BY sd.dept,
              sd.supplier,
              sd.tran_type
     ORDER BY sd.dept,
              sd.supplier,
              sd.tran_type;
              
select * from rib_message where family ='InvAdjust' order by 1 desc;               
select * from rib_message_failure order by 1 desc;                             
              
              
              
select * from rms.inv_adj;