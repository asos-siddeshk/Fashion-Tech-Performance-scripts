select * from PARTNER_MFQUEUE;
select count(1) from PARTNER_PUB_INFO where published ='N';
    
select * from rib_message;
select * from shipment where shipment > 30848534 order by 1 desc;
    
set serveroutput on;
set timing on;

DECLARE
  c_commit  	        NUMBER(5)                     := 2;
l_partner_id 		rms.partner.partner_id%type;

cursor c_dept is 
		select partner_id from partner where partner_type ='FF' and rownum <= '5';

Begin


for k in c_dept loop
      l_partner_id := k.partner_id;


update PARTNER_PUB_INFO set PUBLISHED ='N' where PARTNER_ID = l_partner_id;

INSERT /*+ append */ INTO PARTNER_MFQUEUE
   (SEQ_NO,
    PARTNER_TYPE,
    PARTNER_ID,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
SELECT  PARTNER_MFSEQUENCE.NextVal SEQ_NO,
    'FA' as PARTNER_TYPE,
    PARTNER_ID PARTNER_ID,
    NULL ADDR_KEY,
    'partnercre' MESSAGE_TYPE,
    'PARTNER' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    NULL TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM PARTNER where partner_id  =l_partner_id;
  
  commit;
    
INSERT /*+ append */ INTO PARTNER_MFQUEUE
   (SEQ_NO,
    PARTNER_TYPE,
    PARTNER_ID,
    ADDR_KEY,
    MESSAGE_TYPE,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_NUMBER,
    TRANSACTION_TIME_STAMP)
SELECT  PARTNER_MFSEQUENCE.NextVal SEQ_NO,
    ADDR.KEY_VALUE_1 PARTNER_TYPE,
    ADDR.KEY_VALUE_2 PARTNER_ID,
    ADDR.ADDR_KEY ADDR_KEY,
    'partnerdtlcre' MESSAGE_TYPE,
    'PARTNER' FAMILY,
    NULL CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    NULL TRANSACTION_NUMBER,
    SYSDATE TRANSACTION_TIME_STAMP
    FROM ADDR
   WHERE MODULE='PTNR' and KEY_VALUE_2  =l_partner_id;

    commit;   
 end loop;  
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/   



 ---------------------------- Data create ----------------------


select * from partner_mfqueue;
select * from PARTNER_PUB_INFO;

delete from partner_mfqueue where PARTNER_ID = N_partner_id;
update PARTNER_PUB_INFO set PUBLISHED ='Y' where PARTNER_ID = N_partner_id;




set serveroutput on;
set timing on;

DECLARE
  c_commit  	        NUMBER(5)                     := 2;
l_partner_id 		rms.partner.partner_id%type;
N_partner_id 		rms.partner.partner_id%type;

cursor c_dept is 
		select partner_id from partner where partner_type ='FA' and rownum <= '300';

Begin

for j in 0..0 loop

for k in c_dept loop
      l_partner_id := k.partner_id;

    select PARTNER_SEQ.nextval into N_partner_id from dual;
    
    insert into partner
    select PARTNER_TYPE, N_partner_id, PARTNER_DESC||c_commit, CURRENCY_CODE, LANG, STATUS, CONTACT_NAME||c_commit, CONTACT_PHONE, CONTACT_FAX, CONTACT_TELEX, CONTACT_EMAIL, MFG_ID, PRINCIPLE_COUNTRY_ID, LINE_OF_CREDIT, OUTSTAND_CREDIT, OPEN_CREDIT, YTD_CREDIT, YTD_DRAWDOWNS, TAX_ID, TERMS, SERVICE_PERF_REQ_IND, INVC_PAY_LOC, INVC_RECEIVE_LOC, IMPORT_COUNTRY_ID, PRIMARY_IA_IND, COMMENT_DESC, TSF_ENTITY_ID, VAT_REGION, ORG_UNIT_ID, PARTNER_NAME_SECONDARY, AUTO_RCV_STOCK_IND
        from partner where partner_id =l_partner_id;
    
    insert into addr
    select ADDR_SEQUENCE.nextval, MODULE, KEY_VALUE_1, N_partner_id, SEQ_NO, ADDR_TYPE, PRIMARY_ADDR_IND, ADD_1||c_commit, ADD_2, ADD_3||c_commit, CITY, STATE, COUNTRY_ID, POST, CONTACT_NAME||c_commit, CONTACT_PHONE, CONTACT_TELEX, CONTACT_FAX, CONTACT_EMAIL, ORACLE_VENDOR_SITE_ID, EDI_ADDR_CHG, COUNTY, PUBLISH_IND, JURISDICTION_CODE, EXTERNAL_REF_ID, CREATE_ID, CREATE_DATETIME
        from addr where KEY_VALUE_2 =l_partner_id;
        
    insert into PARTNER_CFA_EXT
    select PARTNER_TYPE, N_partner_id, GROUP_ID, VARCHAR2_1, VARCHAR2_2, VARCHAR2_3, VARCHAR2_4, VARCHAR2_5, VARCHAR2_6, VARCHAR2_7, VARCHAR2_8, VARCHAR2_9, VARCHAR2_10, NUMBER_11, NUMBER_12, NUMBER_13, NUMBER_14, NUMBER_15, NUMBER_16, NUMBER_17, NUMBER_18, NUMBER_19, NUMBER_20, DATE_21, DATE_22, DATE_23, DATE_24, DATE_25
        from PARTNER_CFA_EXT where partner_id =l_partner_id;

    delete from partner_mfqueue where PARTNER_ID = N_partner_id;
    update PARTNER_PUB_INFO set PUBLISHED ='Y' where PARTNER_ID = N_partner_id;

    end loop;  
     c_commit:= c_commit+1;
 end loop;  
 commit;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/