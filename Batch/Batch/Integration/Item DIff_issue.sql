     select item from rms.item_master im where item_level ='1' and status ='A'   --and dept ='2050' 
        and not exists (select 1 from rms.DIFF_GROUP_HEAD pi where pi.DIFF_GROUP_ID = im.DIFF_2) ; 
  
  select * from rms.item_master where ITEM = '100245392' or ITEM_PARENT = '100245392' or ITEM_GRANDPARENT= '100245392';
  
    select distinct ITEM_PARENT from rms.item_master where diff_2 ='TBC';
    select distinct item from rms.item_master where diff_2 ='TBC';
    select * from daily_purge;

    delete from daily_purge where KEY_VALUE in (select distinct item from rms.item_master where diff_2 ='TBC');
    
    
    
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
 l_item           rms.item_master.item%type ;
   
cursor cur_dept_a is --2613
    select item from rms.item_master im where item_level ='1' and status ='A'   --and dept ='2050' 
        and not exists (select 1 from rms.DIFF_GROUP_HEAD pi where pi.DIFF_GROUP_ID = im.DIFF_2) ; 

        
BEGIN

for k in cur_dept_a loop
        l_item      := k.item;

      delete from rms.RIB_MESSAGE_ROUTING_INFO where message_num in (select message_num from rms.rib_message where id =l_item);
      delete from rms.rib_message_failure where message_num in (select message_num from rms.rib_message where id =l_item);
      delete from rms.rib_message where id =l_item;
     delete from rms.item_mfqueue where item  =l_item;        
    MERGE INTO rms.item_master e
        USING (select dh.DIFF_GROUP_ID,im.item_parent from rms.DIFF_GROUP_detail dh, rms.item_master im 
                where im.item_parent =l_item and im.diff_2=dh.diff_id and rownum <= '1') h
        ON (h.item_parent = e.item)
      WHEN MATCHED THEN
        UPDATE SET e.diff_2= h.DIFF_GROUP_ID;
        
   delete from rms.item_mfqueue where item  =l_item;      
   delete from rms.item_pub_info where item  =l_item;     
   
     /*  UPdate skumar.processed_item set status ='R',PROCESSEDTIME=systimestamp where item =l_item;
       UPdate skumar.processed_itemloc set status ='R',PROCESSEDTIME=systimestamp where item =l_item; 
      */ 
  --DBMS_OUTPUT.PUT_LINE('Item: '||l_item);
end loop;
commit;
 
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/ 