
/*

{
  "correlationId": "7162afd1-b4ff-4e6e-be10-77e82b54ddd9",
  "eventDateTime": "2019-07-26T12:15:00Z",
  "eventType": "DateOnSiteLeanEvent",
  "dateOnStore": "2019-07-26T12:24:00Z",
  "retailId": 102555239,
  "digitalStoreId": "ROW"
}
*/
select * from store;


select * from (select distinct TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS eventDateTime,'DateOnSiteLeanEvent' as eventType,
TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS dateOnStore, il.item as retailId,ss.STORE_NAME3 as digitalStoreId 
from skumar.livebyfcitem il, rms.store ss where ss.CUSTOMER_ORDER_LOC_IND!='Y' 
order by  RETAILID, DIGITALSTOREID);

 
select * from store;
select * from WH;

delete from int_asos.int_itemloc_lfc_stg where item in (select distinct SKU from CASHANDSALES_ALL);
delete from int_asos.int_itemloc_lfc_stg where item in (select item_parent from item_master where item in (select distinct SKU from CASHANDSALES_ALL));

drop table livebyfc;

create table livebyfc as
 select * from (
     select distinct item_parent from item_master where item in (select distinct sku from CASHANDSALES_ALL) ) where rownum<= '5000';
select item from livebyfc;

create table livebyfcitem as
select * from item_master where item_parent in (select item_parent from livebyfc);


GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.livebyfcitem TO SSHASTRY; 

select ITEM_PARENT from livebyfcitem;
select item from livebyfcitem;

select * from all_tables where table_name like ('ITEM%CFA%');
select * from CFA_ATTRIB;
select * from CFA_ATTRIB_GROUP;
select * from CFA_ATTRIB_GROUP_LABELS;
select * from CFA_ATTRIB_GROUP_SET;
select * from CFA_ATTRIB_GROUP_SET_LABELS;
select * from CFA_ATTRIB_LABELS;
select * from CFA_EXT_ENTITY;
select * from CFA_EXT_ENTITY_KEY;
select * from CFA_EXT_ENTITY_KEY_LABELS;
select * from CFA_REC_GROUP;
select * from CFA_REC_GROUP_LABELS;

select distinct item_parent from livebyfcitem;

select il.item,il.loc,110100 from item_loc il where item in (select item from item_master where item ='100000586' or item_parent = '100000586')
 and  not exists (select 1 from ITEM_LOC_CFA_EXT ilc where ilc.item =il.item and ilc.LOC = il.loc);

select loc,DATE_22,count(1) from ITEM_LOC_CFA_EXT where item in (select item from livebyfc) group by loc,date_22;
delete from int_asos.int_itemloc_lfc_stg where item in (select distinct SKU from CASHANDSALES_ALL);
delete from int_asos.int_itemloc_lfc_stg where item in (select item_parent from item_master where item in (select distinct SKU from CASHANDSALES_ALL));


set serveroutput on;
set timing on;
declare
l_item_parent rms.item_master.item_parent%type;
l_exists rms.item_master.item_parent%type;
l_job_id rms.item_master.item_parent%type;

  
CURSOR cur_dept IS
  select distinct item_parent from livebyfcitem;
  
cursor c_reclass (l_item_parent rms.item_master.item_parent%type) is
        select 1 from item_loc il where item in (select item from item_master where item =l_item_parent or item_parent = l_item_parent)
                and exists (select 1 from ITEM_LOC_CFA_EXT ilc where ilc.item =il.item and ilc.LOC = il.loc);
Begin
for k in cur_dept loop
   l_item_parent := k.item_parent;

   open c_reclass(l_item_parent);
   
   fetch c_reclass into l_exists;
    
      if c_reclass%NOTFOUND then
     insert into ITEM_LOC_CFA_EXT (item,loc,group_id)
            select il.item,il.loc,110100 from item_loc il where item in (select item from item_master where item =l_item_parent or item_parent = l_item_parent)
             and not exists (select 1 from ITEM_LOC_CFA_EXT ilc where ilc.item =il.item and ilc.LOC = il.loc);
     
  end if;
close c_reclass;
 commit;
 
end loop;
EXCEPTION
WHEN OTHERS THEN
 dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/

set serveroutput on;
set timing on;
declare
l_item_parent rms.item_master.item_parent%type;
l_exists rms.item_master.item_parent%type;
l_job_id rms.item_master.item_parent%type;

  
CURSOR cur_dept IS
  select distinct item_parent from livebyfcitem;
  
Begin
for k in cur_dept loop
   l_item_parent := k.item_parent;
   
     insert into ITEM_LOC_CFA_EXT (item,loc,group_id)
            select il.item,il.loc,110100 from item_loc il where item in (select item from item_master where item =l_item_parent or item_parent = l_item_parent)
             and not exists (select 1 from ITEM_LOC_CFA_EXT ilc where ilc.item =il.item and ilc.LOC = il.loc);
     
 
end loop;
 commit;

EXCEPTION
WHEN OTHERS THEN
 dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/



create table check_item_loc as
select * from (select distinct TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS eventDateTime,'DateOnSiteLeanEvent' as eventType,
TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS dateOnStore, il.item as retailId,ss.STORE_NAME3 as digitalStoreId,store 
from skumar.livebyfcitem il, rms.store ss where ss.CUSTOMER_ORDER_LOC_IND!='Y' order by  RETAILID, DIGITALSTOREID);


create table check_item_loc_p as
select * from (select distinct TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS eventDateTime,'DateOnSiteLeanEvent' as eventType,
TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS dateOnStore, il.item_parent as retailId,ss.STORE_NAME3 as digitalStoreId,store 
from skumar.livebyfcitem il, rms.store ss where ss.CUSTOMER_ORDER_LOC_IND!='Y' order by  RETAILID, DIGITALSTOREID);

select RETAILID, STORE from check_item_loc;
select * from check_item_loc_p;

create table item_loc_ranging as
    select il.RETAILID,il.STORE from check_item_loc_p il  where not exists (select 1 from ITEM_LOC ilc where ilc.item =il.RETAILID and ilc.LOC = il.STORE);

insert into item_loc_ranging
    select il.RETAILID,il.STORE from check_item_loc il  where not exists (select 1 from ITEM_LOC ilc where ilc.item =il.RETAILID and ilc.LOC = il.STORE);
commit;



select il.RETAILID,il.STORE from check_item_loc il  where not exists 
    (select 1 from ITEM_LOC_cfa_ext ilc where ilc.item =il.RETAILID and ilc.LOC = il.STORE);

select il.RETAILID,il.STORE from check_item_loc_p il  where not exists 
    (select 1 from ITEM_LOC_cfa_ext ilc where ilc.item =il.RETAILID and ilc.LOC = il.STORE);


select * from item_loc_ranging;


ALTER TABLE item_loc_ranging 
ADD comments varchar2(1000);






set serveroutput on;
set timing on;

DECLARE
  O_ERROR_MESSAGE VARCHAR2(200);
  I_ITEM VARCHAR2(25);
  I_LOCATION NUMBER;
  I_ITEM_PARENT VARCHAR2(25);
  I_ITEM_GRANDPARENT VARCHAR2(25);
  I_LOC_TYPE VARCHAR2(1);
  I_SHORT_DESC VARCHAR2(120);
  I_DEPT NUMBER;
  I_CLASS NUMBER;
  I_SUBCLASS NUMBER;
  I_ITEM_LEVEL NUMBER;
  I_TRAN_LEVEL NUMBER;
  I_ITEM_STATUS VARCHAR2(1);
  I_WASTE_TYPE VARCHAR2(6);
  I_DAILY_WASTE_PCT NUMBER;
  I_SELLABLE_IND VARCHAR2(1);
  I_ORDERABLE_IND VARCHAR2(1);
  I_PACK_IND VARCHAR2(1);
  I_PACK_TYPE VARCHAR2(1);
  I_UNIT_COST_LOC NUMBER;
  I_UNIT_RETAIL_LOC NUMBER;
  I_SELLING_RETAIL_LOC NUMBER;
  I_SELLING_UOM VARCHAR2(4);
  I_ITEM_LOC_STATUS VARCHAR2(1);
  I_TAXABLE_IND VARCHAR2(1);
  I_TI NUMBER;
  I_HI NUMBER;
  I_STORE_ORD_MULT VARCHAR2(1);
  I_MEAS_OF_EACH NUMBER;
  I_MEAS_OF_PRICE NUMBER;
  I_UOM_OF_PRICE VARCHAR2(4);
  I_PRIMARY_VARIANT VARCHAR2(25);
  I_PRIMARY_SUPP NUMBER;
  I_PRIMARY_CNTRY VARCHAR2(3);
  I_LOCAL_ITEM_DESC VARCHAR2(250);
  I_LOCAL_SHORT_DESC VARCHAR2(120);
  I_PRIMARY_COST_PACK VARCHAR2(25);
  I_RECEIVE_AS_TYPE VARCHAR2(1);
  I_DATE DATE;
  I_DEFAULT_TO_CHILDREN BOOLEAN;
  I_LIKE_STORE NUMBER;
  I_ITEM_DESC VARCHAR2(250);
  I_DIFF_1 VARCHAR2(10);
  I_DIFF_2 VARCHAR2(10);
  I_DIFF_3 VARCHAR2(10);
  I_DIFF_4 VARCHAR2(10);
  I_LANG NUMBER;
  I_CLASS_VAT_IND VARCHAR2(1);
  I_ELC_IND VARCHAR2(1);
  I_STD_AV_IND VARCHAR2(1);
  I_VAT_IND VARCHAR2(200);
  I_RPM_IND VARCHAR2(200);
  I_INBOUND_HANDLING_DAYS NUMBER;
  I_GROUP_TYPE VARCHAR2(6);
  I_STORE_PRICE_IND VARCHAR2(1);
  I_UIN_TYPE VARCHAR2(6);
  I_UIN_LABEL VARCHAR2(6);
  I_CAPTURE_TIME VARCHAR2(6);
  I_EXT_UIN_IND VARCHAR2(1);
  I_SOURCE_METHOD VARCHAR2(1);
  I_SOURCE_WH NUMBER;
  I_NEW_LOC_IND VARCHAR2(200);
  I_RANGED_IND VARCHAR2(1);
  I_COSTING_LOC NUMBER;
  I_COSTING_LOC_TYPE VARCHAR2(1);
  v_Return BOOLEAN;

  
CURSOR cur_dept IS
 select * from item_loc_ranging;
  
BEGIN

for k in cur_dept loop
  O_ERROR_MESSAGE := NULL;
  I_ITEM := k.RETAILID;
  I_LOCATION := k.STORE;
  I_ITEM_PARENT := NULL;
  I_ITEM_GRANDPARENT := NULL;
  I_LOC_TYPE := NULL;
  I_SHORT_DESC := NULL;
  I_DEPT := NULL;
  I_CLASS := NULL;
  I_SUBCLASS := NULL;
  I_ITEM_LEVEL := NULL;
  I_TRAN_LEVEL := NULL;
  I_ITEM_STATUS := NULL;
  I_WASTE_TYPE := NULL;
  I_DAILY_WASTE_PCT := NULL;
  I_SELLABLE_IND := NULL;
  I_ORDERABLE_IND := NULL;
  I_PACK_IND := NULL;
  I_PACK_TYPE := NULL;
  I_UNIT_COST_LOC := NULL;
  I_UNIT_RETAIL_LOC := NULL;
  I_SELLING_RETAIL_LOC := NULL;
  I_SELLING_UOM := NULL;
  I_ITEM_LOC_STATUS := NULL;
  I_TAXABLE_IND := NULL;
  I_TI := NULL;
  I_HI := NULL;
  I_STORE_ORD_MULT := NULL;
  I_MEAS_OF_EACH := NULL;
  I_MEAS_OF_PRICE := NULL;
  I_UOM_OF_PRICE := NULL;
  I_PRIMARY_VARIANT := NULL;
  I_PRIMARY_SUPP := NULL;
  I_PRIMARY_CNTRY := NULL;
  I_LOCAL_ITEM_DESC := NULL;
  I_LOCAL_SHORT_DESC := NULL;
  I_PRIMARY_COST_PACK := NULL;
  I_RECEIVE_AS_TYPE := NULL;
  I_DATE := NULL;
  I_DEFAULT_TO_CHILDREN := NULL;
  I_LIKE_STORE := NULL;
  I_ITEM_DESC := NULL;
  I_DIFF_1 := NULL;
  I_DIFF_2 := NULL;
  I_DIFF_3 := NULL;
  I_DIFF_4 := NULL;
  I_LANG := NULL;
  I_CLASS_VAT_IND := NULL;
  I_ELC_IND := NULL;
  I_STD_AV_IND := NULL;
  I_VAT_IND := NULL;
  I_RPM_IND := NULL;
  I_INBOUND_HANDLING_DAYS := NULL;
  I_GROUP_TYPE := NULL;
  I_STORE_PRICE_IND := NULL;
  I_UIN_TYPE := NULL;
  I_UIN_LABEL := NULL;
  I_CAPTURE_TIME := NULL;
  I_EXT_UIN_IND := 'N';
  I_SOURCE_METHOD := NULL;
  I_SOURCE_WH := NULL;
  I_NEW_LOC_IND := NULL;
  I_RANGED_IND := 'N';
  I_COSTING_LOC := NULL;
  I_COSTING_LOC_TYPE := NULL;

  v_Return := RMS.NEW_ITEM_LOC(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_ITEM => I_ITEM,
    I_LOCATION => I_LOCATION,
    I_ITEM_PARENT => I_ITEM_PARENT,
    I_ITEM_GRANDPARENT => I_ITEM_GRANDPARENT,
    I_LOC_TYPE => I_LOC_TYPE,
    I_SHORT_DESC => I_SHORT_DESC,
    I_DEPT => I_DEPT,
    I_CLASS => I_CLASS,
    I_SUBCLASS => I_SUBCLASS,
    I_ITEM_LEVEL => I_ITEM_LEVEL,
    I_TRAN_LEVEL => I_TRAN_LEVEL,
    I_ITEM_STATUS => I_ITEM_STATUS,
    I_WASTE_TYPE => I_WASTE_TYPE,
    I_DAILY_WASTE_PCT => I_DAILY_WASTE_PCT,
    I_SELLABLE_IND => I_SELLABLE_IND,
    I_ORDERABLE_IND => I_ORDERABLE_IND,
    I_PACK_IND => I_PACK_IND,
    I_PACK_TYPE => I_PACK_TYPE,
    I_UNIT_COST_LOC => I_UNIT_COST_LOC,
    I_UNIT_RETAIL_LOC => I_UNIT_RETAIL_LOC,
    I_SELLING_RETAIL_LOC => I_SELLING_RETAIL_LOC,
    I_SELLING_UOM => I_SELLING_UOM,
    I_ITEM_LOC_STATUS => I_ITEM_LOC_STATUS,
    I_TAXABLE_IND => I_TAXABLE_IND,
    I_TI => I_TI,
    I_HI => I_HI,
    I_STORE_ORD_MULT => I_STORE_ORD_MULT,
    I_MEAS_OF_EACH => I_MEAS_OF_EACH,
    I_MEAS_OF_PRICE => I_MEAS_OF_PRICE,
    I_UOM_OF_PRICE => I_UOM_OF_PRICE,
    I_PRIMARY_VARIANT => I_PRIMARY_VARIANT,
    I_PRIMARY_SUPP => I_PRIMARY_SUPP,
    I_PRIMARY_CNTRY => I_PRIMARY_CNTRY,
    I_LOCAL_ITEM_DESC => I_LOCAL_ITEM_DESC,
    I_LOCAL_SHORT_DESC => I_LOCAL_SHORT_DESC,
    I_PRIMARY_COST_PACK => I_PRIMARY_COST_PACK,
    I_RECEIVE_AS_TYPE => I_RECEIVE_AS_TYPE,
    I_DATE => I_DATE,
    I_DEFAULT_TO_CHILDREN => I_DEFAULT_TO_CHILDREN,
    I_LIKE_STORE => I_LIKE_STORE,
    I_ITEM_DESC => I_ITEM_DESC,
    I_DIFF_1 => I_DIFF_1,
    I_DIFF_2 => I_DIFF_2,
    I_DIFF_3 => I_DIFF_3,
    I_DIFF_4 => I_DIFF_4,
    I_LANG => I_LANG,
    I_CLASS_VAT_IND => I_CLASS_VAT_IND,
    I_ELC_IND => I_ELC_IND,
    I_STD_AV_IND => I_STD_AV_IND,
    I_VAT_IND => I_VAT_IND,
    I_RPM_IND => I_RPM_IND,
    I_INBOUND_HANDLING_DAYS => I_INBOUND_HANDLING_DAYS,
    I_GROUP_TYPE => I_GROUP_TYPE,
    I_STORE_PRICE_IND => I_STORE_PRICE_IND,
    I_UIN_TYPE => I_UIN_TYPE,
    I_UIN_LABEL => I_UIN_LABEL,
    I_CAPTURE_TIME => I_CAPTURE_TIME,
    I_EXT_UIN_IND => I_EXT_UIN_IND,
    I_SOURCE_METHOD => I_SOURCE_METHOD,
    I_SOURCE_WH => I_SOURCE_WH,
    I_NEW_LOC_IND => I_NEW_LOC_IND,
    I_RANGED_IND => I_RANGED_IND,
    I_COSTING_LOC => I_COSTING_LOC,
    I_COSTING_LOC_TYPE => I_COSTING_LOC_TYPE
  );
  
IF (v_Return) THEN 
    delete from item_loc_ranging where RETAILID = I_ITEM and STORE = I_LOCATION ;
  ELSE
   update item_loc_ranging set comments = O_ERROR_MESSAGE where RETAILID = I_ITEM and STORE = I_LOCATION ;
  END IF;

end loop;
 commit;
 

EXCEPTION
WHEN OTHERS THEN
 dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/



select * from 
    (select distinct TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS eventDateTime,
            'DateOnSiteLeanEvent' as eventType,
            TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS dateOnStore, 
            il.item as retailId, 
            replace(ss.STORE_NAME3,'UK','COM') as digitalStoreId 
    from skumar.livebyfcitem il, rms.store ss 
    where ss.CUSTOMER_ORDER_LOC_IND!='Y' and ss.STORE_NAME3 not in ('IBP','EU')
        order by  RETAILID, DIGITALSTOREID);

select * from livebyfcitem;
select distinct item_parent from livebyfcitem;

select * from store;