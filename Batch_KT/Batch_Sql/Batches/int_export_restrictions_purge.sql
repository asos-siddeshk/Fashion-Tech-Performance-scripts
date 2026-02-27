   select * --9000
    FROM int_asos.INT_ITEM_REST_EVENT_DNLD_STG
   WHERE BASE_EXTRACTED_IND = 'Y'
     AND TRANSACTION_DATETIME < (GET_VDATE + 30);
     
     



/*---------------------------Batch name:RMS.INT_EXPORT_ITEM_RESTRICTIONS----------------------------------
1.PL/SQL script execution that will delete the records from the base tables	:int_asos.INT_ITEM_REST_EVENT_DNLD_STG,rms.data_export_hist tables.
2.Batch execution 															:RMS.INT_EXPORT_ITEM_RESTRICTIONS via Automic.
---------------------------------------------------------------------------------------

   select count(ITEM)
     from ma_asos.MA_ITEM_RESTRICTIONS MIR,
          ma_asos.MA_SHIP_REST_GROUP_DETAIL SRGD
    where MIR.GROUP_ID = SRGD.REST_GROUP_ID
      and EXISTS(SELECT 'X' FROM ITEM_PUB_INFO IPI WHERE IPI.PUBLISHED = 'Y' AND IPI.ITEM = MIR.ITEM)
    group by MIR.ITEM, SRGD.COUNTRY_ID
    order by MIR.ITEM, SRGD.COUNTRY_ID;
    
delete
    FROM int_asos.INT_ITEM_REST_EVENT_DNLD_STG where TRANSACTION_DATETIME > (GET_VDATE);
    
   select *
    FROM int_asos.INT_ITEM_REST_EVENT_DNLD_STG
   WHERE BASE_EXTRACTED_IND = 'Y'
     AND TRANSACTION_DATETIME < (GET_VDATE + 30);
     
    update  int_asos.INT_ITEM_REST_EVENT_DNLD_STG set BASE_EXTRACTED_IND = 'Y';
    
  select distinct (trunc(TRANSACTION_DATETIME)),count(1)
    FROM int_asos.INT_ITEM_REST_EVENT_DNLD_STG group by trunc(TRANSACTION_DATETIME) order by 1 desc;
    
 */   
    
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0; 

BEGIN

for k in 1..7 loop    

    insert into int_asos.INT_ITEM_REST_EVENT_DNLD_STG 
select INT_ASOS.INT_ITEM_REST_EXPORT_SEQ.nextval,ITEM, 'ItemRestMod' as ACTION_TYPE, 'Y' as BASE_EXTRACTED_IND, 1234 -k as PROCESS_ID, 
    (select vdate-k from period) as TRANSACTION_DATETIME from int_asos.INT_ITEM_REST_EVENT_DNLD_STG 
    where trunc(TRANSACTION_DATETIME) ='16-AUG-21' and rownum <= '50000';

end loop;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/