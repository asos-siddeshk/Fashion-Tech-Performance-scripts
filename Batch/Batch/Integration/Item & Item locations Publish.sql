--exec system.killsession ('2660');
select * from rms.item_master where ITEM = '118849364' or ITEM_PARENT = '118849364' or ITEM_GRANDPARENT= '118849445';
select count(1) from rms.ITEMloc_MFQUEUE ;

select count(1) from rms.ITEM_MFQUEUE;
select count(1) from rms.ITEMloc_MFQUEUE;

select ITEM_LEVEL,count(1) from rms.item_master group by ITEM_LEVEL;


/* Update skumar.processed_item set processedtime = systimestamp -1 where trunc(PROCESSEDTIME)!= '29-APR-2019';
update skumar.processed_itemloc set processedtime = systimestamp -1 where trunc(PROCESSEDTIME)!= '29-APR-2019'; */
delete FROM skumar.processed_item WHERE rowid not in (SELECT MIN(rowid) FROM skumar.processed_item GROUP BY ITEM);			
select count(1) from skumar.processed_item rpi where rpi.status ='P' and  not exists (select 1 from rms.itemloc_mfqueue pi where pi.item = rpi.item) and not exists (select 1 from rms.item_mfqueue pi where pi.item = rpi.item) and exists (select 1 from skumar.processed_itemloc pi where pi.item = rpi.item and pi.status ='P') and trunc(PROCESSEDTIME) = '10-MAY-2019' order by PROCESSEDTIME desc;

select * from skumar.processed_item rpi where 
    not exists (select 1 from rms.itemloc_mfqueue pi where pi.item = rpi.item)
    and not exists (select 1 from rms.item_mfqueue pi where pi.item = rpi.item)
    and exists (select 1 from skumar.processed_itemloc pi where pi.item = rpi.item and pi.status ='P')
    and trunc(PROCESSEDTIME) = '24-SEP-2019' order by PROCESSEDTIME desc;
    
    --Not processed
select * from skumar.processed_item rpi where 
    exists (select 1 from rms.item_mfqueue pi where pi.item = rpi.item)
    or exists (select 1 from rms.itemloc_mfqueue pi where pi.item = rpi.item)
    and trunc(PROCESSEDTIME) = '09-MAY-2019' order by PROCESSEDTIME ;    

select * from rms.item_master where ITEM = '100640930' or ITEM_PARENT = '100640930' or ITEM_GRANDPARENT= '100640930';
select * from rms.ITEM_MFQUEUE where item in (select item from rms.item_master where ITEM = '100640930' or ITEM_PARENT = '100640930' or ITEM_GRANDPARENT= '100640930');
select * from rms.ITEMloc_MFQUEUE where item in (select item from rms.item_master where ITEM = '100640930' or ITEM_PARENT = '100640930' or ITEM_GRANDPARENT= '100640930');

select im.ITEM,im.PROCESSEDTIME as ITEM_PROCESSEDTIME, il.PROCESSEDTIME as ITEMLOC_PROCESSEDTIME
  from skumar.processed_itemloc il, skumar.processed_item im where im.item = il.item and im.item ='100640930';

select * from rib_message order by 1 desc;

select * from rib_message where message_num ='635558';
select * from rib_message_failure where message_num ='635558';

select * From item_loc_proc_int;

drop table item_loc_proc_int;
create table item_loc_proc_int as
   select dept,class,subclass,count from (  
    select im.dept,im.class,im.subclass,count(1) as count from rms.item_master im  where item_level ='1' and status ='A' 
    and not exists (select 1 from skumar.processed_item pi where pi.item = im.item) group by im.dept,im.class,im.subclass);
    
    
select dept,class,subclass,count from (  
    select im.dept,im.class,im.subclass,count(1) as count from rms.item_master im  where item_level ='1' and status ='A' 
    and not exists (select 1 from skumar.processed_item pi where pi.item = im.item) group by im.dept,im.class,im.subclass);
    


    select im.item from rms.item_master im  where item_level ='1' and status ='A' and dept = '1007'
    and not exists (select 1 from skumar.processed_item pi where pi.item = im.item) and rownum <= '50000';
    
    
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
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 
   
   
Cursor c_get_dept is
   --select dept,class,subclass from skumar.item_loc_proc_int where count <= '1' order by count;
   select 1005 as dept,1 as class,1 as subclass from dual;
   

 Cursor c_get_item_parent (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type) is
      select item from rms.item_master im where item_level ='1' 
            and status ='A' 
            and im.dept =l_dept
            and im.class = l_class
            and im.subclass = l_subclass
        and not exists (select 1 from skumar.processed_item pi where pi.item = im.item) and rownum < ='2' order by 1 ; 
      
    
  Cursor C_get_item (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
        select * from rms.item_master where  item_level<=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;

  Cursor C_get_item_loc (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
       select item from rms.ITEM_MASTER where  item_level=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;


begin

-- DBMS_OUTPUT.PUT_LINE('Start Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));


for k in c_get_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        
        
 for k in c_get_item_parent(l_dept,l_class,l_subclass)
 loop
    l_item_parent := k.item;
      
  for   c1 in C_get_item(l_item_parent) loop
      EXIT WHEN C_get_item%NOTFOUND;
  
 
   
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

   for   c1 in C_get_item_loc(l_item_parent) loop
    
     EXIT WHEN C_get_item_loc%NOTFOUND;
  
   L_item        := c1.item;

 INSERT  INTO rms.ITEMLOC_MFQUEUE
   (SEQ_NO,
    ITEM,
    LOC,
    LOC_TYPE,
    PHYSICAL_LOC,
    LOCAL_ITEM_DESC,
    LOCAL_SHORT_DESC,
    STATUS,
    PRIMARY_SUPP,
    PRIMARY_CNTRY,
    RECEIVE_AS_TYPE,
    TAXABLE_IND,
    SOURCE_METHOD,
    SOURCE_WH,
    PRIMARY_REPL_SUPPLIER,
    REPL_METHOD,
    REJECT_STORE_ORDER_IND,
    NEXT_DELIVERY_DATE,
    MESSAGE_TYPE,
    THREAD_NO,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_TIME_STAMP,
    STORE_PRICE_IND,
    UNIT_RETAIL,
    SELLING_UNIT_RETAIL,
    SELLING_UOM,
    MULT_RUNS_PER_DAY_IND,
    UIN_TYPE,
    UIN_LABEL,
    CAPTURE_TIME,
    EXT_UIN_IND,
    RANGED_IND,
    RETURNABLE_IND)
      WITH itl AS   (SELECT rms.ITEM_MASTER.item AS item,
                      item_loc.loc  AS loc,
                      loc.physical_loc             AS physical_loc,
                      item_loc.loc_type            AS loc_type,
                      item_loc.local_item_desc     AS local_item_desc,
                      item_loc.local_short_desc    AS local_short_desc,
                      item_loc.status              AS status,
                      item_loc.primary_supp        AS primary_supp,
                      item_loc.primary_cntry       AS primary_cntry,
                      item_loc.receive_as_type     AS receive_as_type,
                      item_loc.taxable_ind         AS taxable_ind,
                      item_loc.source_method       AS source_method,
                      item_loc.source_wh           AS source_wh,
                      item_loc.store_price_ind     AS store_price_ind,
                      item_loc.unit_retail         AS unit_retail,
                      item_loc.selling_unit_retail AS selling_unit_retail,
                      item_loc.selling_uom         AS selling_uom,
                      item_loc.uin_type            AS uin_type,
                      item_loc.uin_label           AS uin_label,
                      rms.item_loc.capture_time        AS capture_time,
                      rms.item_loc.ext_uin_ind         AS ext_uin_ind,
                      rms.item_loc.ranged_ind          AS ranged_ind,
                      mod(rms.ITEM_MASTER.item, rib_settings.num_threads)+ 1 AS thread_no
                      FROM rms.ITEM_MASTER
                         CROSS JOIN rms.rib_settings
                            INNER JOIN rms.item_loc
                                    ON rms.ITEM_MASTER.item  = rms.item_loc.item
                                   INNER JOIN ( SELECT wh.physical_wh AS physical_loc,
                                                    wh.wh AS loc
                                             FROM rms.wh
                                             WHERE wh.physical_wh <> wh.wh
                                             UNION ALL
                                             SELECT STORE.STORE AS physical_loc,
                                                   STORE.STORE AS loc
                                             FROM rms.STORE) loc
            ON    rms.item_loc.loc = loc.loc      
                 WHERE rms.ITEM_MASTER.item_level = rms.ITEM_MASTER.tran_level
                   AND rib_settings.family = 'itemloc'
                   and rms.ITEM_MASTER.item=L_item)
   SELECT  rms.ITEMLOC_MFSEQUENCE.NextVal SEQ_NO,
    ITL.ITEM ITEM,
    ITL.LOC LOC,
    ITL.LOC_TYPE LOC_TYPE,
    ITL.PHYSICAL_LOC PHYSICAL_LOC,
    ITL.LOCAL_ITEM_DESC LOCAL_ITEM_DESC,
    ITL.LOCAL_SHORT_DESC LOCAL_SHORT_DESC,
    ITL.STATUS STATUS,
    ITL.PRIMARY_SUPP PRIMARY_SUPP,
    ITL.PRIMARY_CNTRY PRIMARY_CNTRY,
    ITL.RECEIVE_AS_TYPE RECEIVE_AS_TYPE,
    ITL.TAXABLE_IND TAXABLE_IND,
    ITL.SOURCE_METHOD SOURCE_METHOD,
    ITL.SOURCE_WH SOURCE_WH,
    NULL PRIMARY_REPL_SUPPLIER,
    NULL REPL_METHOD,
    NULL REJECT_STORE_ORDER_IND,
    NULL NEXT_DELIVERY_DATE,
    'ItemLocCre' MESSAGE_TYPE,
    ITL.THREAD_NO THREAD_NO,
    'ItemLoc' FAMILY,
    'N' CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    SYSDATE TRANSACTION_TIME_STAMP,
    ITL.STORE_PRICE_IND STORE_PRICE_IND,
    ITL.UNIT_RETAIL UNIT_RETAIL,
    ITL.SELLING_UNIT_RETAIL SELLING_UNIT_RETAIL,
    SELLING_UOM SELLING_UOM,
    'N' MULT_RUNS_PER_DAY_IND,
    ITL.UIN_TYPE UIN_TYPE,
    ITL.UIN_LABEL UIN_LABEL,
    ITL.CAPTURE_TIME CAPTURE_TIME,
    ITL.EXT_UIN_IND EXT_UIN_IND,
    ITL.RANGED_IND RANGED_IND,
    NULL RETURNABLE_IND
    FROM ITL;

end loop;
  
   c_commit :=c_commit + 1;
       IF MOD(c_commit, 2) = 0 THEN
 --      DBMS_OUTPUT.PUT_LINE('c_commit ' || c_commit);
 --      DBMS_OUTPUT.PUT_LINE('Sleep Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
  sys.dbms_lock.sleep(10);
   commit;
 --   DBMS_OUTPUT.PUT_LINE('Sleep Ended: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
        continue;
       END IF;
     
       insert into skumar.processed_item values (l_item_parent,systimestamp,'P');
       insert into skumar.processed_itemloc values (l_item_parent,systimestamp,'P');
    
  --DBMS_OUTPUT.PUT_LINE('Item: '||l_item_parent);
     
end loop;

 sys.dbms_lock.sleep(0);
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

select item  from rms.item_master where status ='A' 
        and item_level ='1' and Item_DESC='Item creation Perf Test' and rownum <= '50';

 --- Parent Item Publish 


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
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 
   
   

 Cursor c_get_item_parent is
     select item from item_master where item in ('100043895','100043896','100043897','100043911','100043940','100043941','100043956','100044026,','100044059','100044060');
--    select item from ITEM_pub_info ip where ip.published= 'N' and exists (select 1 from rms.item_master im where im.item = ip.item and item_level = '1') and rownum <= '20';  
    
  Cursor C_get_item (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
        select * from rms.item_master where  item_level<=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;

  Cursor C_get_item_loc (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
       select item from rms.ITEM_MASTER where  item_level=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;


begin

 DBMS_OUTPUT.PUT_LINE('Start Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
        
 for k in c_get_item_parent 
 loop
    l_item_parent := k.item;

   for   c1 in C_get_item_loc(l_item_parent) loop
    
     EXIT WHEN C_get_item_loc%NOTFOUND;
  
   L_item        := c1.item;

 INSERT  INTO rms.ITEMLOC_MFQUEUE
   (SEQ_NO,
    ITEM,
    LOC,
    LOC_TYPE,
    PHYSICAL_LOC,
    LOCAL_ITEM_DESC,
    LOCAL_SHORT_DESC,
    STATUS,
    PRIMARY_SUPP,
    PRIMARY_CNTRY,
    RECEIVE_AS_TYPE,
    TAXABLE_IND,
    SOURCE_METHOD,
    SOURCE_WH,
    PRIMARY_REPL_SUPPLIER,
    REPL_METHOD,
    REJECT_STORE_ORDER_IND,
    NEXT_DELIVERY_DATE,
    MESSAGE_TYPE,
    THREAD_NO,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_TIME_STAMP,
    STORE_PRICE_IND,
    UNIT_RETAIL,
    SELLING_UNIT_RETAIL,
    SELLING_UOM,
    MULT_RUNS_PER_DAY_IND,
    UIN_TYPE,
    UIN_LABEL,
    CAPTURE_TIME,
    EXT_UIN_IND,
    RANGED_IND,
    RETURNABLE_IND)
      WITH itl AS   (SELECT rms.ITEM_MASTER.item AS item,
                      item_loc.loc  AS loc,
                      loc.physical_loc             AS physical_loc,
                      item_loc.loc_type            AS loc_type,
                      item_loc.local_item_desc     AS local_item_desc,
                      item_loc.local_short_desc    AS local_short_desc,
                      item_loc.status              AS status,
                      item_loc.primary_supp        AS primary_supp,
                      item_loc.primary_cntry       AS primary_cntry,
                      item_loc.receive_as_type     AS receive_as_type,
                      item_loc.taxable_ind         AS taxable_ind,
                      item_loc.source_method       AS source_method,
                      item_loc.source_wh           AS source_wh,
                      item_loc.store_price_ind     AS store_price_ind,
                      item_loc.unit_retail         AS unit_retail,
                      item_loc.selling_unit_retail AS selling_unit_retail,
                      item_loc.selling_uom         AS selling_uom,
                      item_loc.uin_type            AS uin_type,
                      item_loc.uin_label           AS uin_label,
                      rms.item_loc.capture_time        AS capture_time,
                      rms.item_loc.ext_uin_ind         AS ext_uin_ind,
                      rms.item_loc.ranged_ind          AS ranged_ind,
                      mod(rms.ITEM_MASTER.item, rib_settings.num_threads)+ 1 AS thread_no
                      FROM rms.ITEM_MASTER
                         CROSS JOIN rms.rib_settings
                            INNER JOIN rms.item_loc
                                    ON rms.ITEM_MASTER.item  = rms.item_loc.item
                                   INNER JOIN ( SELECT STORE.STORE AS physical_loc,
                                                   STORE.STORE AS loc
                                             FROM rms.STORE where store ='20015') loc
            ON    rms.item_loc.loc = loc.loc      
                 WHERE rms.ITEM_MASTER.item_level = rms.ITEM_MASTER.tran_level
                   AND rib_settings.family = 'itemloc'
                   and rms.ITEM_MASTER.item=L_item
                   )
   SELECT  rms.ITEMLOC_MFSEQUENCE.NextVal SEQ_NO,
    ITL.ITEM ITEM,
    ITL.LOC LOC,
    ITL.LOC_TYPE LOC_TYPE,
    ITL.PHYSICAL_LOC PHYSICAL_LOC,
    ITL.LOCAL_ITEM_DESC LOCAL_ITEM_DESC,
    ITL.LOCAL_SHORT_DESC LOCAL_SHORT_DESC,
    ITL.STATUS STATUS,
    ITL.PRIMARY_SUPP PRIMARY_SUPP,
    ITL.PRIMARY_CNTRY PRIMARY_CNTRY,
    ITL.RECEIVE_AS_TYPE RECEIVE_AS_TYPE,
    ITL.TAXABLE_IND TAXABLE_IND,
    ITL.SOURCE_METHOD SOURCE_METHOD,
    ITL.SOURCE_WH SOURCE_WH,
    NULL PRIMARY_REPL_SUPPLIER,
    NULL REPL_METHOD,
    NULL REJECT_STORE_ORDER_IND,
    NULL NEXT_DELIVERY_DATE,
    'ItemLocCre' MESSAGE_TYPE,
    ITL.THREAD_NO THREAD_NO,
    'ItemLoc' FAMILY,
    'N' CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    SYSDATE TRANSACTION_TIME_STAMP,
    ITL.STORE_PRICE_IND STORE_PRICE_IND,
    ITL.UNIT_RETAIL UNIT_RETAIL,
    ITL.SELLING_UNIT_RETAIL SELLING_UNIT_RETAIL,
    SELLING_UOM SELLING_UOM,
    'N' MULT_RUNS_PER_DAY_IND,
    ITL.UIN_TYPE UIN_TYPE,
    ITL.UIN_LABEL UIN_LABEL,
    ITL.CAPTURE_TIME CAPTURE_TIME,
    ITL.EXT_UIN_IND EXT_UIN_IND,
    ITL.RANGED_IND RANGED_IND,
    NULL RETURNABLE_IND
    FROM ITL;

end loop;
  
   c_commit :=c_commit + 1;
       IF MOD(c_commit, 1) = 0 THEN
 --         DBMS_OUTPUT.PUT_LINE('Sleep Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
           --  sys.dbms_lock.sleep(10);
             commit;
 --         DBMS_OUTPUT.PUT_LINE('Sleep Ended: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
        continue;
       END IF;
     
     
  DBMS_OUTPUT.PUT_LINE('Item: '||l_item_parent);
     
end loop;


 DBMS_OUTPUT.PUT_LINE('End Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/