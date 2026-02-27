/*select distinct skuitemid from skumar.Cashandsales_int;
delete from skumar.CASHANDSALES_ALL;
delete from skumar.CASHANDSALES_ALL_2 ;
delete from skumar.CASHANDSALES_ALL_3;
delete from skumar.CASHANDSALES_ALL_4;
*/

set serveroutput on;
set timing on;

declare
COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'APR021';
l_paymentreference          varchar2(6)   := 'APR021';
l_orderid                   varchar2(20)  := 'APR021';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC01';
l_stockreference            NUMBER(15)    := '161';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 3;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'GB';
l_orderreference            varchar2(20)  := 'APR021';
l_idorconversionid          number(10)    := '161';
l_currencycode              varchar2(3)   := 'GBP';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'APR021';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20002';
SlNO      number(15)    ;
COUNTER      number(15)    := '01';
l_priceversion_id           varchar2(80);
    
cursor c_item_loc is 
     select   PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int il  
 where il.STOREID ='20002' and not exists (select 1 from skumar.CASHANDSALES_ALL ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
Begin

--delete from skumar.CASHANDSALES_ALL where  WLOCATION = l_wlocation;

for k in 0..6513 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;
    
    
insert into skumar.CASHANDSALES_ALL
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
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
commit;

    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


set serveroutput on;
set timing on;

declare
COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'APR022';
l_paymentreference          varchar2(6)   := 'APR022';
l_orderid                   varchar2(20)  := 'APR022';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC01';
l_stockreference            NUMBER(15)    := '162';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 3;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'GB';
l_orderreference            varchar2(20)  := 'APR022';
l_idorconversionid          number(10)    := '162';
l_currencycode              varchar2(3)   := 'GBP';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'APR022';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20002';
SlNO      number(15)    ;
COUNTER      number(15)    := '01';
l_priceversion_id           varchar2(80);
    
cursor c_item_loc is 
   select   PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int il  
 where il.STOREID ='20002' and not exists (select 1 from skumar.CASHANDSALES_ALL_2 ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
Begin

--delete from skumar.CASHANDSALES_ALL_2 where  WLOCATION = l_wlocation;

for k in 0..6513 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;
    
    
insert into skumar.CASHANDSALES_ALL_2 
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
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
commit;

    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


set serveroutput on;
set timing on;

declare
COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'APR023';
l_paymentreference          varchar2(6)   := 'APR023';
l_orderid                   varchar2(20)  := 'APR023';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC01';
l_stockreference            NUMBER(15)    := '163';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 3;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'GB';
l_orderreference            varchar2(20)  := 'APR023';
l_idorconversionid          number(10)    := '163';
l_currencycode              varchar2(3)   := 'GBP';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'APR023';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20002';
SlNO      number(15)    ;
COUNTER      number(15)    := '01';
l_priceversion_id           varchar2(80);
    
cursor c_item_loc is 
   select   PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int il  
 where il.STOREID ='20002' and not exists (select 1 from skumar.CASHANDSALES_ALL_3 ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
 
Begin

--delete from skumar.CASHANDSALES_ALL_3 where  WLOCATION = l_wlocation;

for k in 0..6513 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;
    
    
insert into skumar.CASHANDSALES_ALL_3 
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
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
commit;

    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/



set serveroutput on;
set timing on;

declare
COUNTER_COMMIT  NUMBER(8)     := 1;
l_invoicereference          varchar2(100) := 'APR020';
l_paymentreference          varchar2(6)   := 'APR020';
l_orderid                   varchar2(20)  := 'APR020';
l_discounttotalamount       number(20,4)  := 0;
l_discountcode              varchar2(10)  := 'moreplease';
l_discounttype              varchar2(20)  := 'Percentage';
l_discountvalue             number(20,4)  := 0;
l_wlocation                 varchar2(10)  := 'FC01';
l_stockreference            NUMBER(15)    := '160';
l_sku                       varchar2(25)  ;
l_quantity                  number(20,4)  := 3;
l_currentprice              number(20,4)  ;
l_deliverycountrycode       varchar2(2)   := 'GB';
l_orderreference            varchar2(20)  := 'APR020';
l_idorconversionid          number(10)    := '160';
l_currencycode              varchar2(3)   := 'GBP';
l_action                    varchar2(3)   := 'E';
l_code                      varchar2(20)  := 'Receipt Return';
l_returnqty                 number(20,4)  := 1;
l_user_def_type_4           varchar2(20)  := 'APR020';
l_lock_code                 varchar2(20)  := 'AQL';
l_ordertype                 varchar2(20)  := 'Consumer';
l_location      rms.item_loc.loc%type := '20002';
SlNO      number(15)    ;
COUNTER      number(15)    := '01';
l_priceversion_id           varchar2(80);
    
cursor c_item_loc is 
   select   PRICEVERSIONID as priceversionid, SKUITEMID as item, SELLINGUNITRETAILPRICE as selling_unit_retail
  from skumar.Cashandsales_int il  
 where il.STOREID ='20002' and not exists (select 1 from skumar.CASHANDSALES_ALL_4 ca where ca.sku=il.SKUITEMID and WLOCATION = l_wlocation)
   and rownum<=3;
 
 
Begin

--delete from skumar.CASHANDSALES_ALL_4 where  WLOCATION = l_wlocation;

for k in 0..1000 loop
    select skumar.CASHANDSALES_SlNO.nextval into SlNO from dual;

for i in c_item_loc loop
    EXIT WHEN c_item_loc%NOTFOUND;
l_sku := i.item ;
l_currentprice := i.selling_unit_retail ;
l_priceversion_id := i.priceversionid ;
    
    
insert into skumar.CASHANDSALES_ALL_4 
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
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
			   END IF;	

end loop; 
commit;

    
EXCEPTION
WHEN OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


/*

select * from skumar.CASHANDSALES_ALL;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL_2 ;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL_3 ;
select count(distinct ORDERID) from skumar.CASHANDSALES_ALL_4 ;
create table Cashandsales_int (
PriceVersionID	varchar2(50),
SKUItemID	varchar2(25),
SellingCurrency	varchar2(3),
SellingUOM	varchar2(4),
SellingUnitRetailPrice	number(20,4),
StoreID varchar2(10));

begin

insert into skumar.CASHANDSALES_ALL
select * from skumar.CASHANDSALES_ALL_2;
delete from skumar.CASHANDSALES_ALL_2;
insert into skumar.CASHANDSALES_ALL
select * from skumar.CASHANDSALES_ALL_3;
delete from skumar.CASHANDSALES_ALL_3;
insert into skumar.CASHANDSALES_ALL
select * from skumar.CASHANDSALES_ALL_4;
delete from skumar.CASHANDSALES_ALL_4;
commit;
end;
/


begin
update item_loc_soh set AV_COST =UNIT_COST where item in (select distinct item from CASHANDSALES_ALL) and AV_COST is null;
commit;
end;
/