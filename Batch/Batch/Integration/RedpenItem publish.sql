  create table processed_item (item varchar2(25));
    alter table processed_item add status varchar2(255);
    alter table processed_item add PROCESSEDTIME timestamp;



select * from inday_bcp;
select count(1)  from processed_item;
select count(1)  from item_mfqueue_bk;

select count(1)  from item_mfqueue;
select * from item_mfqueue;

insert into item_mfqueue
select * from item_mfqueue_bk;

select * from item_mfqueue;
select count (distinct item) from item_mfqueue;
select count(1) from item_pub_info where published!='Y';
select count(1) from item_pub_info where published='Y';
select * from rms.item_mfqueue;
select count(1) from item_mfqueue where item in (select item from redPen_item_sku);


create table redPen_item_sku as 
select item from (    select item from item_master where item_parent in (select item from inday_bcp)
    union 
    select item from inday_bcp); --186k
    

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
 
     select item from rms.item_master im where item in (select item from inday_bcp)
        and not exists (select 1 from skumar.processed_item pi where pi.item = im.item) and rownum < ='10' order by 1 ; 
      
    
  Cursor C_get_item (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
        select * from rms.item_master where  item_level<=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;

begin

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
        COMMIT;
       END IF;
     
       insert into skumar.processed_item values (l_item_parent,'P',systimestamp);
end loop;

    commit;
end loop;
commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/