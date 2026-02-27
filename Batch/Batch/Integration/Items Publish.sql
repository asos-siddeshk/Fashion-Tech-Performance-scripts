select dept,count(1) from rms.item_master im where im.item_level ='1' 
  and exists (select 1 from skumar.processed_item pi where pi.item = im.item) group by dept order by 2 desc;
  
select dept,class,subclass,count(1) from rms.tran_data where item_level ='1' group by dept,class,subclass;
select count(1) from rms.item_master where item_level ='1' group by item;
select dept,class,subclass,count(1) from rms.item_master where item_level ='1' group by dept,class,subclass;
select dept,class,subclass,count(1) from rms.item_master where item_level ='2' group by dept,class,subclass order by dept,class,subclass;


select dept,count(1) from rms.item_master where item_level ='1' group by dept having count(1) between 10000 and 15000;
select ITEM_LEVEL,count(1) from rms.item_master where dept ='2050' group by ITEM_LEVEL;
select ITEM_LEVEL,count(1) from rms.item_master group by ITEM_LEVEL;
select item from rms.item_master where dept ='2050' and status ='A' and item_level  ='1';
select rms.logger_logs_seq.currval - 1000 from dual;
select * from rms.logger_logs where id > 82088404 order by id desc;

select * from rms.item_mfqueue;
select * from rms.item_pub_info;

select * from rms.item_mfqueue where item in (select item from rms.item_master where dept='2050' and status ='A');
select * from rms.item_pub_info where item in (select item from rms.item_master where dept='2050' and status ='A') and published ='N';

select * from rms.item_master where item_level ='1' and dept='2050' and status ='A';
select * from rms.item_master where item_level ='2' and dept='2050' and status ='A';

select * from all_objects where lower(object_name) like 'dbms_lock';
select * from all_objects where lower(object_name) like 'dbms_session';


select count(1) from rms.item_master im where item_level ='1' and dept ='2050' and status ='A'
    and not exists (select 1 from skumar.processed_item pi where pi.item = im.item);
    
 --Yet to be processed 
 select count(1) from rms.item_master im where item_level ='1' and dept ='2050' and status ='A' and not exists (select 1 from skumar.processed_item pi where pi.item = im.item);
 --Processed        
 select count(1) from rms.item_master im where item_level ='1' and dept ='2050' and status ='A' and  exists (select 1 from skumar.processed_item pi where pi.item = im.item);
select count(1) from rms.item_mfqueue;
select count(1) from processed_item;
select count(1) from rms.item_pub_info;
select count(1) from rms.item_pub_info where item in (select item from rms.item_master where dept='2050') and published='N'; -- 84933
select count(1) from rms.item_pub_info im  where item in (select item from rms.item_master where dept='2050') and published!='Y' and  exists (select 1 from skumar.processed_item pi where pi.item = im.item);
select count(1) from rms.item_pub_info im  where item in (select item from rms.item_master where dept='2050') and published='Y' and  exists (select 1 from skumar.processed_item pi where pi.item = im.item);
select * from rms.item_mfqueue where item in (select item from rms.item_master where dept='2050' and status ='A');
select * from rms.item_pub_info where item in (select item from rms.item_master where dept='2050'); 
select * from rib_message where FAMILY = 'Items' and trunc (PUBLISH_TIME) = trunc(sysdate) and id  in (select item from rms.item_master where dept='2050') order by 1 desc; -- 477
select * from rib_message_failure where message_num ='615630'; 
    
select * from processed_item;

select * from processed_item where item ='100027029' order by 1 desc;
select count(1) from processed_item where item in (select item from item_master where dept ='2050') order by 1 desc;
select * from processed_item where item in (select item from item_master where dept ='2050') order by 1 desc;
select count(1) from ITEM_MFQUEUE where item in (select item from item_master where dept ='2050');
select * from item_master where ITEM = '100027029' or ITEM_PARENT = '100027029' or ITEM_GRANDPARENT= '100027029' ;
select * from ITEM_MFQUEUE where item in (select item from item_master where ITEM = '100027029' or ITEM_PARENT = '100027029' or ITEM_GRANDPARENT= '100027029');
select * from ITEMloc_MFQUEUE where item in (select item from item_master where ITEM = '100027029' or ITEM_PARENT = '100027029' or ITEM_GRANDPARENT= '100027029');

select count(1) from processed_item where item in (select item from item_master where dept ='2050') order by 1 desc;
select * from rib_message where id in (select item from item_master where dept ='2050') order by 1 desc;
select * from rms.rib_message_failure where MESSAGE_NUM ='629123';

select * from item_master where dept ='1053';


  --Successfully processed

select * from skumar.processed_item rpi where rpi.status ='P' and 
    not exists (select 1 from itemloc_mfqueue pi where pi.item = rpi.item)
    and not exists (select 1 from item_mfqueue pi where pi.item = rpi.item)
    and exists (select 1 from processed_itemloc pi where pi.item = rpi.item and pi.status ='P')
    and trunc(PROCESSEDTIME) = '15-APR-2019' order by PROCESSEDTIME desc;

select im.ITEM,im.PROCESSEDTIME as ITEM_PROCESSEDTIME, il.PROCESSEDTIME as ITEMLOC_PROCESSEDTIME
  from processed_itemloc il, processed_item im where im.item = il.item and im.item ='100253982';
  
 select im.ITEM,im.PROCESSEDTIME as ITEM_PROCESSEDTIME, il.PROCESSEDTIME as ITEMLOC_PROCESSEDTIME
  from processed_itemloc il, processed_item im where im.item = il.item and trunc(im.PROCESSEDTIME) = '09-APR-2019' and trunc(il.PROCESSEDTIME) = '09-APR-2019';

--Total processed
select * from skumar.processed_item rpi where trunc(PROCESSEDTIME) = '09-APR-2019' order by PROCESSEDTIME ;
select * from skumar.processed_itemloc rpi where trunc(PROCESSEDTIME) = '09-APR-2019' order by PROCESSEDTIME ;
 

--Not processed
select * from skumar.processed_item rpi where 
    exists (select 1 from item_mfqueue pi where pi.item = rpi.item)
    and  exists (select 1 from processed_itemloc pi where pi.item = rpi.item)
    and trunc(PROCESSEDTIME) = '30-APR-2019' order by PROCESSEDTIME ;

    
    select * from item_mfqueue where PUB_STATUS ='H' and trunc(TRANSACTION_TIME_STAMP) = '09-APR-2019';
    select * from itemloc_mfqueue;   
    alter table processed_item add status varchar2(10);
 drop table        processed_item;
  create table processed_item (item varchar2(25));
    alter table processed_item add status varchar2(255);
    alter table processed_item add PROCESSEDTIME timestamp;
    
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.processed_itemloc TO rdatla; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.processed_itemloc TO RCHANDEL; 
  
select * from processed_item;
Update skumar.processed_item set processedtime = systimestamp -1;
Update skumar.processed_itemloc set processedtime = systimestamp -1;

MERGE INTO skumar.processed_item e
    USING (SELECT distinct id FROM rms.rib_message) h
    ON (h.id = e.item)
  WHEN MATCHED THEN
    UPDATE SET e.status= 'E';
    
MERGE INTO skumar.processed_itemloc e
    USING (SELECT distinct id FROM rms.rib_message) h
    ON (h.id = e.item)
  WHEN MATCHED THEN
    UPDATE SET e.status= 'E';  
select * from rib_message;


set serveroutput on;
set timing on;
declare
  c_commit               NUMBER(10)                    := 0;
  
  L_queue_rec           rms.ITEM_MFQUEUE%ROWTYPE := NULL;
  L_item                rms.ITEM_MASTER.ITEM%TYPE ;
  I_custom_message_type rms.ITEM_mfqueue.custom_message_type%TYPE := 'N';
  
  L_error_msg           VARCHAR2(4000);
  L_tran_level_ind      rms.ITEM_PUB_INFO.TRAN_LEVEL_IND%TYPE;
     l_item_parent      rms.ITEM_MASTER.ITEM%TYPE ;

 Cursor c_get_item_parent is
 
     select item from rms.item_master im where item_level ='1' and status ='A' and dept ='2050'
        and not exists (select 1 from skumar.processed_item pi where pi.item = im.item) and rownum < ='10' order by 1 ; 
      
    
  Cursor C_get_item (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
        select * from rms.item_master where  item_level<=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;

begin

-- DBMS_OUTPUT.PUT_LINE('Start Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
 for j in 0..10 loop
 
 for k in c_get_item_parent
 loop
    l_item_parent := k.item;
      
  for   c1 in C_get_item(l_item_parent)
    
  loop
 
   
  L_queue_rec.message_type := rms.RMSMFM_ITEMS.ITEM_UPD;
  L_queue_rec.approve_ind  := 'Y';
  L_queue_rec.item         := c1.item;
  
  if c1.item_level = c1.tran_level then
    L_tran_level_ind := 'Y';
  else
    L_tran_level_ind := 'N';
  end if;

 merge into rms.item_pub_info ipb
  using (select c1.item item,
                'N' published,
                c1.SELLABLE_IND SELLABLE_IND,
                L_tran_level_ind tran_level_ind,
                'N' appr_upon_create_ind
           from dual) inner
  on (ipb.item = inner.item)
  when matched then
    update
       set ipb.published            = inner.published,
           ipb.appr_upon_create_ind = inner.appr_upon_create_ind
  when not matched then
    insert
      (ipb.item,
       ipb.published,
       ipb.SELLABLE_IND,
       ipb.tran_level_ind,
       ipb.appr_upon_create_ind)
    values
      (inner.item,
       inner.published,
       inner.SELLABLE_IND,
       inner.tran_level_ind,
       inner.appr_upon_create_ind);  
       
  if rms.RMSMFM_ITEMS.ADDTOQ(L_error_msg,
                         L_queue_rec,
                         c1.SELLABLE_IND,
                         L_tran_level_ind,
                         I_custom_message_type) = FALSE then
    dbms_output.put_line(L_error_msg);
  end if;
    
 
end loop;

   c_commit :=c_commit + 1;
       IF MOD(c_commit, 10) = 0 THEN
      --  COMMIT;
   --      DBMS_OUTPUT.PUT_LINE('c_commit ' || c_commit);
 --      DBMS_OUTPUT.PUT_LINE('Sleep Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
   -- sys.dbms_lock.sleep(20);
   -- commit;
 --   DBMS_OUTPUT.PUT_LINE('Sleep Ended: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
        continue;
       END IF;
     
       insert into skumar.processed_item values (l_item_parent,systimestamp,'P');
    
   --DBMS_OUTPUT.PUT_LINE('Item: '||l_item_parent);
     
end loop;

 sys.dbms_lock.sleep(60);
    commit;
end loop;
commit;
  --DBMS_OUTPUT.PUT_LINE('End Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/