select dept,class,subclass,count(1) from rms.item_master where item_level ='1' group by dept,class,subclass;
select dept,count(1) from rms.item_master where item_level ='1' group by dept having count(1) between 10000 and 15000;
select ITEM_LEVEL,count(1) from rms.item_master where dept ='2050' group by ITEM_LEVEL;
select item from rms.item_master where dept ='2050' and status ='A' and item_level  ='1';
select * from rib_message;
select * from rib_message_failure;

select count(1) from rms.ITEM_MFQUEUE;
select count(1) from rms.ITEMLOC_MFQUEUE;
select count(1) from processed_itemloc;

select * from processed_itemloc;
delete ITEMLOC_MFQUEUE;

select * from rms.ITEMLOC_MFQUEUE;
select count(distinct(ITEm)) from rms.ITEMLOC_MFQUEUE ;

select * from item_master where item  in (select item from ITEMLOC_MFQUEUE) ;


select * from rms.ITEMLOC_MFQUEUE where PUB_STATUS ='U';

select * from rms.ITEMLOC_MFQUEUE where item in (select item from rms.item_master where item ='6495591') order by 1 desc;
select * from rib_message where id in (select item from item_master where item ='6495591') order by 1 desc;
select * from rms.rib_message_failure where MESSAGE_NUM ='630675';


select * from processed_itemloc where item in (select item from rms.item_master where dept='2050' and status ='A');
select * from rms.item_master where item_level ='1' and dept='2050' and status ='A';
select * from processed_itemloc;
--delete from ITEMLOC_MFQUEUE where item in (select item from item_master where item ='100000014' or item_parent ='100000014' or ITEM_GRANDPARENT ='100000014');

select * from rms.rib_message where family like 'Items' and trunc(PUBLISH_TIME) = trunc(sysdate) order by 1 desc;
select * from rms.rib_message_failure where MESSAGE_NUM like 'Items' ;

create table processed_itemloc (item varchar2(25),PROCESSEDTIME DATE, status varchar2(2));
create table processed_item (item varchar2(25),PROCESSEDTIME DATE,status varchar2(2));

drop table processed_item;
drop TABLE processed_itemloc;

truncatE TABLE  processed_itemloc;


set serveroutput on
set timing on

DECLARE

  c_commit              NUMBER(10)                    := 0;
  l_item                rms.ITEM_MASTER.ITEM%TYPE ;
  l_item_parent         rms.ITEM_MASTER.ITEM%TYPE ;

Cursor c_get_item_parent is
       select item from (
       select distinct item_parent as item from rms.item_master im where item_level ='2' and dept ='2050'  
            and not exists (select 1 from skumar.processed_itemloc pi where pi.item = im.item)) where rownum<= '700' order by 1;  

    Cursor C_get_item (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
        select item from rms.ITEM_MASTER where  item_level=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;


Begin    
 
 
 for k in c_get_item_parent
 loop
    l_item_parent := k.item;
      
  for   c1 in C_get_item(l_item_parent)
  loop
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
       IF MOD(c_commit, 10) = 0 THEN
  --     commit;
        continue;
       END IF;

    insert into skumar.processed_itemloc values (l_item,systimestamp,'P');

end loop;
--commit;
      

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
