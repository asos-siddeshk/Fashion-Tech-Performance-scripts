select count(1) from WH_MFQUEUE;
select count(1) from WH_pub_info where PUBLISHED!='Y';
select * from WH_MFQUEUE;
select * from WH_pub_info;
delete from WH_MFQUEUE;

select * from WH_MFQUEUE where wh in (select wh from WH where PHYSICAL_WH! ='1');
select * from WH_pub_info where wh in (select wh from WH where PHYSICAL_WH ='1');

select distinct FAMILY from rib_message;

select * from rib_message order by 1 desc;
select * from rib_message where message_num ='633100';
select * from rib_message_failure where message_num ='633100';

--WH--

set serveroutput on;
set timing on;
DECLARE
  c_commit  	        NUMBER(5)                     := 2;
  l_wh 		            rms.wh.wh%type;

cursor c_dept is 
		select distinct PHYSICAL_WH from wh;

Begin


for k in c_dept loop
      l_wh := k.PHYSICAL_WH;

Update wh_pub_info set PUBLISHED ='N' where WH in (select wh from wh where PHYSICAL_WH = l_wh);

   
   INSERT /*+ append */ INTO WH_MFQUEUE
   (SEQ_NO,
    WH,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
      SELECT  WH_MFSEQUENCE.NextVal SEQ_NO,
    WH.WH WH,
    NULL ADDR_KEY,
    'whcre' MESSAGE_TYPE,
    'WH' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    WH.WH TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM WH where WH in (select wh from wh where PHYSICAL_WH = l_wh);
    
    commit;
    
INSERT /*+ append */ INTO WH_MFQUEUE
   (SEQ_NO,
    WH,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
      SELECT  WH_MFSEQUENCE.NextVal SEQ_NO,
    ADDR.KEY_VALUE_1 WH,
    ADDR.ADDR_KEY ADDR_KEY,
    'whdtlcre' MESSAGE_TYPE,
    'WH' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    ADDR.KEY_VALUE_1 TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM ADDR
   WHERE MODULE = 'WH' and KEY_VALUE_1 in (select wh from wh where PHYSICAL_WH = l_wh);
   
  
   commit;   
   
    sys.dbms_lock.sleep(20);
  
 end loop; 
 commit;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/   


select count(1) from store_MFQUEUE;
select count(1) from store_pub_info where PUBLISHED!='Y';
select * from store_MFQUEUE;
select * from store_pub_info;
delete from store_MFQUEUE;

set serveroutput on;
set timing on;
DECLARE
  l_store 		            rms.store.store%type;

cursor c_dept is 
		select distinct store from store where store = '10001';

Begin

for k in c_dept loop
      l_store := k.store;

Update store_pub_info set PUBLISHED ='N' where store = l_store;
Update addr set PUBLISH_IND ='N' where MODULE = 'ST' and KEY_VALUE_1 = l_store;

  INSERT /*+ append */ INTO STORE_MFQUEUE
   (SEQ_NO,
    STORE,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
SELECT  STORE_MFSEQUENCE.NextVal SEQ_NO,
    STORE,
    NULL ADDR_KEY,
    'storecre' MESSAGE_TYPE,
    'STORES' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    STORE TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM STORE where store = l_store;
    
   commit;   
      
   
   INSERT /*+ append */ INTO STORE_MFQUEUE
   (SEQ_NO,
    STORE,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
  SELECT  STORE_MFSEQUENCE.NextVal SEQ_NO,
    ADDR.KEY_VALUE_1 STORE,
    ADDR.ADDR_KEY ADDR_KEY,
    'storedtlcre' MESSAGE_TYPE,
    'STORES' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    ADDR_KEY TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM ADDR
   WHERE MODULE = 'ST' and KEY_VALUE_1 = l_store;

    commit;   
   
   sys.dbms_lock.sleep(20);
  
 end loop; 
 commit;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/   


select * from store_pub_info where store = '20014';

delete from store_pub_info where store = '20014';
  
    
 INSERT /*+ append */ INTO STORE_MFQUEUE
   (SEQ_NO,
    STORE,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
SELECT  STORE_MFSEQUENCE.NextVal SEQ_NO,
    STORE.STORE STORE,
    NULL ADDR_KEY,
    'storecre' MESSAGE_TYPE,
    'STORES' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    STORE.STORE TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM STORE where store = '20014';





--- WH ---
select * from WH where PHYSICAL_WH ='1';
select * from addr where module like 'WH' and KEY_VALUE_1 in (select wh from WH where PHYSICAL_WH ='1');

Update WH_MFQUEUE set MESSAGE_TYPE ='whdtlcre' where SEQ_NO ='15025';


Update WH set WH_NAME_SECONDARY = 'FC01' where PHYSICAL_WH ='1';
Update addr set CONTACT_NAME = 'Test_0429' where module like 'WH' and KEY_VALUE_1 in (select wh from WH where PHYSICAL_WH ='1');

--- Warehouse ---
select * from WH_MFQUEUE where wh in (select wh from WH where PHYSICAL_WH ='1');
select * from WH_pub_info where wh in (select wh from WH where PHYSICAL_WH ='1');

 INSERT /*+ append */ INTO WH_PUB_INFO
   (WH,
    PUBLISHED,
    WH_TYPE,
    PRICING_LOC,
    PRICING_LOC_CURR)
WITH whp AS (SELECT wh.wh,
       DECODE(wh.wh, wh.physical_wh, 'P', 'V') AS wh_type FROM wh)
   SELECT  WHP.WH WH,
    'Y' PUBLISHED,
    WHP.WH_TYPE WH_TYPE,
    NULL PRICING_LOC,
    NULL PRICING_LOC_CURR
    FROM WHP;
    
INSERT /*+ append */ INTO WH_MFQUEUE
   (SEQ_NO,
    WH,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
      SELECT  WH_MFSEQUENCE.NextVal SEQ_NO,
    ADDR.KEY_VALUE_1 WH,
    ADDR.ADDR_KEY ADDR_KEY,
    'whdtlcre' MESSAGE_TYPE,
    'WH' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    ADDR.KEY_VALUE_1 TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM ADDR
   WHERE MODULE = 'WH';
   
   INSERT /*+ append */ INTO WH_MFQUEUE
   (SEQ_NO,
    WH,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
      SELECT  WH_MFSEQUENCE.NextVal SEQ_NO,
    WH.WH WH,
    NULL ADDR_KEY,
    'whcre' MESSAGE_TYPE,
    'WH' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    WH.WH TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM WH;
  
--- Store ---

select * from store_MFQUEUE;
select * from store_pub_info where store = '20014';

delete from store_pub_info where store = '20014';
  
  INSERT /*+ append */ INTO STORE_PUB_INFO
   (STORE,
    PUBLISHED,
    STORE_TYPE,
    PRICING_LOC,
    PRICING_LOC_CURR,
    STOCKHOLDING_IND)
      WITH st AS (SELECT  store.store,store.store_type,store.stockholding_ind FROM store)
   SELECT  ST.STORE STORE,
    'N' PUBLISHED,
    ST.STORE_TYPE STORE_TYPE,
    NULL PRICING_LOC,
    NULL PRICING_LOC_CURR,
    ST.STOCKHOLDING_IND STOCKHOLDING_IND
    FROM ST where store = '20014';
    
 INSERT /*+ append */ INTO STORE_MFQUEUE
   (SEQ_NO,
    STORE,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
SELECT  STORE_MFSEQUENCE.NextVal SEQ_NO,
    STORE.STORE STORE,
    NULL ADDR_KEY,
    'storecre' MESSAGE_TYPE,
    'STORES' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    STORE.STORE TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM STORE where store = '20014';



select * from store where store = '20001';
select * from addr where module like 'ST' and KEY_VALUE_1 in (select store from store where store = '20001');

Update STORE set STORE_MGR_NAME = 'ASOS_0430' where store = '20001';
Update addr set CONTACT_PHONE = '+918105197' where module like 'ST'  and KEY_VALUE_1 in (select store from store where store = '20001');

select * from STORE_MFQUEUE;

select * from rib_message where family ='Stores' order by 1 desc;
select * from rib_message_failure order by 1 desc;
