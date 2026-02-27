
SELECT
  STOCKREFERENCE,
  COUNT(*)
FROM
    skumar.CASHANDSALES_ALL_CHK
GROUP BY
  STOCKREFERENCE
HAVING COUNT(*) < 3;

 --- Smoke tests -- 11-10-2020
create table CASHANDSALES_ALL_CHK as
select * from CASHANDSALES_ALL3 where orderid in ('FEB017826385','FEB017826387','FEB017826389','FEB017826391');

select distinct INVOICEREFERENCE from CASHANDSALES_ALL_CHK;


--First Set-- 
Update CASHANDSALES_ALL_CHK set STOCKREFERENCE = 900||ltrim(ORDERID,'FEB01');
UPDATE skumar.CASHANDSALES_ALL_CHK SET SL_NO=rownum,
    INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB01','OCT01'),
    ORDERID = replace(ORDERID,'FEB01','OCT01'),
  -- STOCKREFERENCE = 900||ltrim(ORDERID,'OCT01');
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB01','OCT01'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB01','OCT01');




---------- New table 28_042020 ----------
select * from all_tables where table_name like '%CASH%';

CASHANDSALES_ALL -- Main table 



GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cashandsales_all3 TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cashandsales_all3 TO PSURENDRAN; 



select distinct ORDERID from cashandsales_all2;
desc cashandsales_all3;
CREATE TABLE cashandsales_all3 AS  select * from cashandsales_all2;

select WLOCATION,COUNT(1)/3 from cashandsales_all3 GROUP  BY WLOCATION;

FC04	81924
FC01	190226
FC03	145152

select SKU, QUANTITY, CURRENTPRICE,WLOCATION from cashandsales_all2;
SELECT * FROM cashandsales_all2;

SELECT * FROM ITEMLOCATION_change;
truncate table ITEMLOCATION_change;

INSERT INTO ITEMLOCATION_change 
SELECT il.ITEM,3 AS QTY, il.UNIT_RETAIL, 'FC04' as WLOCATION,rownum as sl_no
    FROM ITEM_LOC il WHERE il.LOC = '4001' AND ROWNUM <= '81924' AND il.CREATE_ID = 'ORACNV'
        and exists (select 1 from rms.item_master im where im.item = il.item and item_level = '2' and tran_level = '2');
    
    
    
SELECT * FROM cashandsales_all3;
SELECT * FROM ITEMLOCATION_change;

alter table cashandsales_all3 add  (sl_no number(10));
alter table ITEMLOCATION_change add  (WLOCATION VARCHAR2(10), sl_no number(10));

select * from ITEMLOCATION_change;
SELECT * FROM cashandsales_all3;

update cashandsales_all3 set sl_no = rownum where WLOCATION = 'FC04';

MERGE INTO cashandsales_all3 s1 USING ITEMLOCATION_change s2 ON (s1.WLOCATION = s2.WLOCATION and s1.sl_no = s2.sl_no) 
    WHEN MATCHED THEN UPDATE SET s1.SKU = s2.item, s1.CURRENTPRICE = s2.UNIT_RETAIL;
    
    
------------ Old --------------

select * from cashandsales_all2 where STOCKREFERENCE like '%JAN%';

select distinct INVOICEREFERENCE,
     STOCKREFERENCE,PAYMENTREFERENCE,
    ORDERID,
    TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS Timestamp
    from cashandsales_all;

desc cashandsales_all;

select * from CASHANDSALES_PAYMENT;
select distinct orderid from cashandsales_all;

--drop table CASHANDSALES_ALL3;

create table CASHANDSALES_ALL2 as
select * from skumar.CASHANDSALES_ALL;

create table CASHANDSALES_ALL3 as
select * from skumar.CASHANDSALES_ALL;


Update CASHANDSALES_ALL2 set STOCKREFERENCE = 800||ltrim(ORDERID,'FEB01');
UPDATE skumar.CASHANDSALES_ALL2     SET
INVOICEREFERENCE = replace(INVOICEREFERENCE,'JAN03','FEB01'),
PAYMENTREFERENCE = replace(PAYMENTREFERENCE,'JAN03','FEB01'),
ORDERID = replace(ORDERID,'JAN03','FEB01'),
ORDERREFERENCE = replace(ORDERREFERENCE,'JAN03','FEB01'),
USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'JAN03','FEB01');

select * from CASHANDSALES_ALL3;

Update CASHANDSALES_ALL3 set STOCKREFERENCE = 801||ltrim(ORDERID,'FEB02');
UPDATE skumar.CASHANDSALES_ALL3     SET
INVOICEREFERENCE = replace(INVOICEREFERENCE,'JAN03','FEB02'),
PAYMENTREFERENCE = replace(PAYMENTREFERENCE,'JAN03','FEB02'),
ORDERID = replace(ORDERID,'JAN03','FEB02'),
ORDERREFERENCE = replace(ORDERREFERENCE,'JAN03','FEB02'),
USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'JAN03','FEB02');
commit;


create table cashsalpay (orderid VARCHAR2(20), paymentref VARCHAR2(100));

select * from cashandsales_all2;

insert into  cashandsales_all2 
select * from cashandsales_all3;

select * from (select distinct ORDERID from cashandsales_all2) where rownum <= '139103';

delete from cashandsales_all2 where ORDERID not in (select ORDERID from cashsalpay);



ALTER TABLE cashandsales_all2
MODIFY PAYMENTREFERENCE VARCHAR2(255);

MERGE INTO cashandsales_all2 s1 USING cashsalpay s2 ON (s1.orderid = s2.orderid) 
WHEN MATCHED THEN UPDATE SET s1.PAYMENTREFERENCE = s2.PAYMENTREF ;

select * from cashandsales_all2 ;

select count(distinct (ORDERID)) from cashandsales_all2 ;
select WLOCATION,count(distinct (ORDERID)) from cashandsales_all2 group by WLOCATION;



SELECT
  STOCKREFERENCE,
  COUNT(*)
FROM
  skumar.CASHANDSALES_ALL2
GROUP BY
  STOCKREFERENCE
HAVING COUNT(*) > 3;



cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/
sed -i 's/20190528/20190127/g' RTLOG_*.dat
sed -i 's/-/0/g' RTLOG_*.dat
grep -o 'THEAD' RTLOG*10001*.dat | wc -l
grep -o 'THEAD' RTLOG*10003*.dat | wc -l
grep -o 'THEAD' RTLOG*10004*.dat | wc -l

Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' ;
delete from rms.restart_bookmark ;

select * from rms.restart_bookmark ;

select STORE_DAY_SEQ_NO,store,count(1) from RMS.SA_TRAN_HEAD where 
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('27-JAN-19')) group by STORE_DAY_SEQ_NO,store order by 1,2;

select store, STORE_DAY_SEQ_NO,TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD where
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('27-JAN-19'))
    group by store, STORE_DAY_SEQ_NO,TRAN_TYPE, SUB_TRAN_TYPE order by 1,2;
    
select count(distinct (ORDERID)) from skumar.CASHANDSALES_ALL_DAY;
select WLOCATION,count(distinct (ORDERID)) from skumar.CASHANDSALES_ALL_DAY group by WLOCATION;


select count(1) from Cashandsales_int_2 where storeid ='20004'; --FC4
select count(1) from Cashandsales_int_2 where storeid ='20002'; --FC1
select count(1) from Cashandsales_int_2 where storeid ='20009'; --FC3
select count(1) from Cashandsales_int_2 where storeid  in ('20004','20002','20009');
select * from Cashandsales_int_2 where storeid  in ('20004','20002','20009');

delete from Cashandsales_int_2 where SELLINGUNITRETAILPRICE is null;

DELETE FROM Cashandsales_int_2
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM Cashandsales_int_2
		GROUP BY PRICEVERSIONID, SKUITEMID, SELLINGCURRENCY, SELLINGUOM, SELLINGUNITRETAILPRICE, STOREID);		


select * from item_loc where (item,loc) in (select SKUITEMID, STOREID from Cashandsales_int_2 where PRICEVERSIONID like 'CLRP%');

  MERGE INTO Cashandsales_int_2 a
      USING (SELECT ITEM, LOC, SELLING_UNIT_RETAIL
             FROM item_loc) b
      ON (a.SKUITEMID = b.item
            and a.STOREID = b.loc
            and a.PRICEVERSIONID like 'CLRP%')
      WHEN MATCHED THEN
        UPDATE SET
          SELLINGUNITRETAILPRICE       = b.SELLING_UNIT_RETAIL -1;


begin 
delete from Cashandsales_int_2 where storeid not in ('20004','20002','20009') and rownum <= 100000;
delete from Cashandsales_int_2 where storeid not in ('20004','20002','20009') and rownum <= 100000;
delete from Cashandsales_int_2 where storeid not in ('20004','20002','20009') and rownum <= 100000;
commit;
end;
/

select * from cashandsales_all;

create table cashandsales_payment (PaymentReference varchar2(255));
delete from cashandsales_payment where PAYMENTREFERENCE is null;

select * from cashandsales_payment;


create table CASHANDSALES_ALL_DAY as 
select * from CASHANDSALES_ALL where 1=2;

select * from skumar.CASHANDSALES_ALL2 where paymentreference= 'd6d4ec41-9aa3-4464-b3bd-ca77ae522d3f';
select distinct IDORCONVERSIONID  from  skumar.CASHANDSALES_ALL_DAY;
--delete from CASHANDSALES_ALL_DAY;;



GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.CASHANDSALES_ALL2 TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.CASHANDSALES_ALL2 TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.CASHANDSALES_ALL2 TO SSHASTRY; 

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.Cashandsales_int_2 TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.Cashandsales_int_2 TO rdatla; 

select *  from SKUMAR.Cashandsales_int_2;

UPDATE skumar.CASHANDSALES_ALL_DAY     SET
INVOICEREFERENCE = replace(INVOICEREFERENCE,'MAY27','MAY271'),
PAYMENTREFERENCE = replace(PAYMENTREFERENCE,'MAY27','MAY271'),
ORDERID = replace(ORDERID,'MAY27','MAY271'),
ORDERREFERENCE = replace(ORDERREFERENCE,'MAY27','MAY271'),
USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'MAY27','MAY271');
UPDATE skumar.CASHANDSALES_ALL_DAY     SET IDORCONVERSIONID = replace(IDORCONVERSIONID,'300','310');
UPDATE skumar.CASHANDSALES_ALL_DAY     SET IDORCONVERSIONID = replace(IDORCONVERSIONID,'400','410');
UPDATE skumar.CASHANDSALES_ALL_DAY     SET IDORCONVERSIONID = replace(IDORCONVERSIONID,'500','510');
UPDATE skumar.CASHANDSALES_ALL_DAY     SET STOCKREFERENCE = replace(STOCKREFERENCE,'300','310');
UPDATE skumar.CASHANDSALES_ALL_DAY     SET STOCKREFERENCE = replace(STOCKREFERENCE,'400','410');
UPDATE skumar.CASHANDSALES_ALL_DAY     SET STOCKREFERENCE = replace(STOCKREFERENCE,'500','510');


--FC01
set serveroutput on;
set timing on;

declare
COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'MAY27';
l_paymentreference          varchar2(6)   := 'MAY27';
l_orderid                   varchar2(20)  := 'MAY27';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC01';
l_stockreference            NUMBER(15)    := '300';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 1;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'GB';
l_orderreference            varchar2(20)  := 'MAY27';
l_idorconversionid          number(10)    := '300';
l_currencycode              varchar2(3)   := 'GBP';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'MAY27';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20002';
SlNO      number(15)    ;
COUNTER      number(15)    := '01';
l_priceversion_id           varchar2(80);
    
cursor c_item_loc is 
select PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int_2 il  
 where il.STOREID =l_location and not exists (select 1 from skumar.CASHANDSALES_ALL_DAY ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
Begin

for k in 0..46000 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;


insert into skumar.CASHANDSALES_ALL_DAY
  (invoicereference,paymentreference,orderid,discounttotalamount , discountcode, discounttype, discountvalue, wlocation, stockreference , sku, quantity, currentprice, 
  deliverycountrycode, orderreference , idorconversionid, currencycode, action, code, returnqty , user_def_type_4, lock_code , ordertype, priceversionid) 
     values (l_invoicereference||SlNO,
   l_paymentreference||SlNO,
   l_orderid||SlNO,
   l_discounttotalamount,
   l_discountcode,
   l_discounttype,
   l_discountvalue,
   l_wlocation,
   l_stockreference||SlNO,
   l_sku,
   l_quantity,
   l_currentprice,
   l_deliverycountrycode,
   l_orderreference||SlNO,
   l_idorconversionid,
   l_currencycode,
   l_action,
   l_code,
   l_returnqty,
   l_user_def_type_4||SlNO,
   l_lock_code,
   l_ordertype,
             l_priceversion_id);
  
end loop; 

        COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 5) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
commit;

    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/

--FC03
set serveroutput on;
set timing on;

declare

COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'MAY27';
l_paymentreference          varchar2(6)   := 'MAY27';
l_orderid                   varchar2(20)  := 'MAY27';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC03';
l_stockreference            NUMBER(15)    := '400';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 3;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'US';
l_orderreference            varchar2(20)  := 'MAY27';
l_idorconversionid          number(10)    := '400';
l_currencycode              varchar2(3)   := 'USD';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'MAY27';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20009';
l_priceversion_id           varchar2(80)  ;
SlNO      number(15)    ;

cursor c_item_loc is 
     select   PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int_2 il  
 where il.STOREID =l_location and not exists (select 1 from skumar.CASHANDSALES_ALL_DAY ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
Begin

--delete from skumar.CASHANDSALES_ALL where  WLOCATION = l_wlocation;

for k in 0..460000 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;
    
    
insert into skumar.CASHANDSALES_ALL_DAY 
  (invoicereference,paymentreference,orderid,discounttotalamount , discountcode, discounttype, discountvalue, wlocation, stockreference , sku, quantity, currentprice, 
  deliverycountrycode, orderreference , idorconversionid, currencycode, action, code, returnqty , user_def_type_4, lock_code , ordertype, priceversionid) 
     values (l_invoicereference||SlNO,
   l_paymentreference||SlNO,
   l_orderid||SlNO,
   l_discounttotalamount,
   l_discountcode,
   l_discounttype,
   l_discountvalue,
   l_wlocation,
   l_stockreference||SlNO,
   l_sku,
   l_quantity,
   l_currentprice,
   l_deliverycountrycode,
   l_orderreference||SlNO,
   l_idorconversionid,
   l_currencycode,
   l_action,
   l_code,
   l_returnqty,
   l_user_def_type_4||SlNO,
   l_lock_code,
   l_ordertype,
             l_priceversion_id);
  
end loop; 
       COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 5) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
    commit;
    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/

--FC04
set serveroutput on;
set timing on;

declare

COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'MAY27';
l_paymentreference          varchar2(6)   := 'MAY27';
l_orderid                   varchar2(20)  := 'MAY27';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC04';
l_stockreference            NUMBER(15)    := '500';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 3;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'DE';
l_orderreference            varchar2(20)  := 'MAY27';
l_idorconversionid          number(10)    := '500';
l_currencycode              varchar2(3)   := 'EUR';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'MAY27';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20004';
l_priceversion_id           varchar2(80)  ;
SlNO      number(15)    ;

cursor c_item_loc is 
 select   PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int_2 il  
 where il.STOREID =l_location and not exists (select 1 from skumar.CASHANDSALES_ALL_DAY ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
 
Begin

--delete from skumar.CASHANDSALES_ALL where  WLOCATION = l_wlocation;

for k in 0..46000 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;
    
    
insert into skumar.CASHANDSALES_ALL_DAY
  (invoicereference,paymentreference,orderid,discounttotalamount , discountcode, discounttype, discountvalue, wlocation, stockreference , sku, quantity, currentprice, 
  deliverycountrycode, orderreference , idorconversionid, currencycode, action, code, returnqty , user_def_type_4, lock_code , ordertype, priceversionid) 
     values (l_invoicereference||SlNO,
   l_paymentreference||SlNO,
   l_orderid||SlNO,
   l_discounttotalamount,
   l_discountcode,
   l_discounttype,
   l_discountvalue,
   l_wlocation,
   l_stockreference||SlNO,
   l_sku,
   l_quantity,
   l_currentprice,
   l_deliverycountrycode,
   l_orderreference||SlNO,
   l_idorconversionid,
   l_currencycode,
   l_action,
   l_code,
   l_returnqty,
   l_user_def_type_4||SlNO,
   l_lock_code,
   l_ordertype,
             l_priceversion_id);
  
end loop; 
       COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 5) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
    commit;
    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/