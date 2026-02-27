Update rms.restart_program_status set PROGRAM_STATUS ='ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;
select * from all_objects where OBJECT_NAME like 'SA_T_%' and OBJECT_TYPE ='FUNCTION';

select * from sa_total_head where TOTAL_ID not in (select distinct TOTAL_ID from sa_total where STORE_DAY_SEQ_NO in 
    (select  STORE_DAY_SEQ_NO  from sa_store_day where business_date in ('26-JAN-19','27-JAN-19')));

select * from v_sa_total where  TOTAL_ID ='SALEREPL' order by 1;

select * from ALL_SEQUENCES where sequence_name like 'SA_TOTAL%';


select SA_TOTAL_SEQ_NO_SEQUENCE.nextval from dual;;

select STORE_DAY_SEQ_NO,TRAN_TYPE, SUB_TRAN_TYPE, count(1) from RMS.SA_TRAN_HEAD where
    STORE_DAY_SEQ_NO in (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-JAN-19'))
    group by STORE_DAY_SEQ_NO,TRAN_TYPE, SUB_TRAN_TYPE order by 1,2;
    
select ERROR_CODE,count(1) from RMS.sa_error where STORE_DAY_SEQ_NO in 
    (select STORE_DAY_SEQ_NO from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-JAN-19')) group by ERROR_CODE;

select * from sa_store_day where AUDIT_STATUS!='A' order by 2,1;

cd /asos/oracle/vpt/data/inbound/Integration/sales/rtlog/pending/Archive
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'THEAD' RTLOG*.dat | wc -l
415104
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'FHEAD' RTLOG*.dat | wc -l
15
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDINT' RTLOG*.dat | wc -l
124873
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'SPLORD
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'RETURN' RTLOG*.dat | wc -l
36061
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDCMP'' RTLOG*.dat | wc -l
129298 RTLOG*.dat | wc -l
124872
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'THEAD' RTLOG_10001*.dat | wc -l
162165
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'FHEAD' RTLOG_10001*.dat | wc -l
5
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDINT' RTLOG_10001*.dat | wc -l
49003
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'SPLORD' RTLOG_10001*.dat | wc -l
41682
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'RETURN' RTLOG_10001*.dat | wc -l
36061
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDCMP' RTLOG_10001*.dat | wc -l
35419
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'THEAD' RTLOG_10003*.dat | wc -l
122109
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'FHEAD' RTLOG_10003*.dat | wc -l
5
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDINT' RTLOG_10003*.dat | wc -l
35069
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'SPLORD' RTLOG_10003*.dat | wc -l
46614
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'RETURN' RTLOG_10003*.dat | wc -l
0
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDCMP' RTLOG_10003*.dat | wc -l
40426
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'THEAD' RTLOG_10004*.dat | wc -l
130830
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'FHEAD' RTLOG_10004*.dat | wc -l
5
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDINT' RTLOG_10004*.dat | wc -l
40801
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'SPLORD' RTLOG_10004*.dat | wc -l
41002
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'RETURN' RTLOG_10004*.dat | wc -l
0
[siddeshk@vptpreuwormsd01 Archive]$ grep -o 'ORDCMP' RTLOG_10004*.dat | wc -l
49027

select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-JAN-19');
select * from store;

select * from NB_V_SA_TRAN_ITEM_NET_ROLLED where TRAN_SEQ_NO ='65051125'; 
select * from NB_V_SA_TRAN_DISC_NET_ROLLED where TRAN_SEQ_NO ='65051125'; 

select * from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO  ='65051125';
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO = '65051125'; 
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO ='65051125'; 



-- SALETAX, salerpm -- Not done

select NVL(SUM(NB_V_SA_TRAN_ITEM_NET_ROLLED.TOTAL_TAX_AMT),0) TOTAL,
       SA_TRAN_HEAD.REF_NO3 REF_NO1, 
       SA_TRAN_HEAD.REF_NO4 REF_NO2, 
       NB_V_SA_TRAN_ITEM_NET_ROLLED.TAX_CODE REF_NO3
from NB_V_SA_TRAN_ITEM_NET_ROLLED,
     SA_TRAN_HEAD, 
     SA_STORE_DAY
where SA_TRAN_HEAD.STORE = NB_V_SA_TRAN_ITEM_NET_ROLLED.STORE
and SA_STORE_DAY.STORE_DAY_SEQ_NO = SA_TRAN_HEAD.STORE_DAY_SEQ_NO
and SA_TRAN_HEAD.DAY = NB_V_SA_TRAN_ITEM_NET_ROLLED.DAY
and SA_STORE_DAY.STORE = NB_V_SA_TRAN_ITEM_NET_ROLLED.STORE
and SA_TRAN_HEAD.TRAN_SEQ_NO = NB_V_SA_TRAN_ITEM_NET_ROLLED.TRAN_SEQ_NO
and SA_STORE_DAY.DAY = NB_V_SA_TRAN_ITEM_NET_ROLLED.DAY
and SA_TRAN_HEAD.TRAN_TYPE = 'ORDCMP'
and SA_TRAN_HEAD.TRAN_TYPE = 'SALE'
and SA_STORE_DAY.STORE_DAY_SEQ_NO  in (select  STORE_DAY_SEQ_NO from sa_store_day where business_date in ('26-JAN-19','27-JAN-19'))
and SA_TRAN_HEAD.STATUS !='D'
and (SA_STORE_DAY.AUDIT_STATUS ='R'
   or SA_STORE_DAY.STORE_DAY_SEQ_NO NOT IN
      (select SA_TOTAL.STORE_DAY_SEQ_NO
       from SA_TOTAL
       where SA_TOTAL.TOTAL_ID = 'SALETAX'
       and SA_TOTAL.STORE = SA_STORE_DAY.STORE
       and SA_TOTAL.STATUS !='D'
       and SA_TOTAL.DAY = SA_STORE_DAY.DAY)) 
group by SA_TRAN_HEAD.REF_NO3,
         SA_TRAN_HEAD.REF_NO4,
         NB_V_SA_TRAN_ITEM_NET_ROLLED.TAX_CODE;






 -- rtn repl
 
 select NVL(SUM(SA_TRAN_TENDER.ORIG_CURR_AMT),0) TOTAL,
       SA_TRAN_TENDER.ORIG_CURRENCY REF_NO1, 
       SA_TRAN_HEAD.REF_NO4 REF_NO2, 
       SA_TRAN_TENDER.TENDER_TYPE_ID REF_NO3
from SA_TRAN_TENDER,
     SA_TRAN_HEAD, 
     SA_STORE_DAY
where SA_TRAN_HEAD.DAY = SA_TRAN_TENDER.DAY
and SA_TRAN_HEAD.STORE = SA_TRAN_TENDER.STORE
and SA_TRAN_HEAD.TRAN_SEQ_NO = SA_TRAN_TENDER.TRAN_SEQ_NO
and SA_STORE_DAY.STORE_DAY_SEQ_NO = SA_TRAN_HEAD.STORE_DAY_SEQ_NO
and SA_STORE_DAY.DAY = SA_TRAN_TENDER.DAY
and SA_STORE_DAY.STORE = SA_TRAN_TENDER.STORE
and SA_TRAN_TENDER.TENDER_TYPE_ID = 10090
and SA_TRAN_HEAD.TRAN_TYPE = 'RETURN'
and SA_TRAN_HEAD.STATUS !='D'
and (SA_STORE_DAY.AUDIT_STATUS ='R'
   or SA_STORE_DAY.STORE_DAY_SEQ_NO NOT IN
      (select SA_TOTAL.STORE_DAY_SEQ_NO
       from SA_TOTAL
       where SA_TOTAL.TOTAL_ID = 'RTNREPL'
       and SA_TOTAL.STORE = SA_STORE_DAY.STORE
       and SA_TOTAL.STATUS !='D'
       and SA_TOTAL.DAY = SA_STORE_DAY.DAY))
group by SA_TRAN_TENDER.ORIG_CURRENCY,
         SA_TRAN_HEAD.REF_NO4,
         SA_TRAN_TENDER.TENDER_TYPE_ID;
         
         
        
set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    N_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000001' and TRAN_TYPE = 'RETURN' and rownum <= '1000' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000002' and TRAN_TYPE = 'RETURN' and rownum <= '500' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000003' and TRAN_TYPE = 'RETURN' and rownum <= '500' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='14000001' and TRAN_TYPE = 'RETURN' and rownum <= '2000' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='14000002' and TRAN_TYPE = 'RETURN' and rownum <= '800' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='14000003' and TRAN_TYPE = 'RETURN' and rownum <= '800' and ERROR_IND ='N';

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;

     update SA_TRAN_TENDER set TENDER_TYPE_ID = 10090 where tran_seq_no =l_TRAN_SEQ_NO;
     
     
     	IF MOD(l_counter, 3) = 0 THEN
                commit;
			   END IF;	
	end loop;                         
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/         
         
         


--salerepl

 select NVL(SUM(SA_TRAN_TENDER.ORIG_CURR_AMT),0) TOTAL,
       SA_TRAN_TENDER.ORIG_CURRENCY REF_NO1, 
       SA_TRAN_HEAD.REF_NO4 REF_NO2, 
       SA_TRAN_TENDER.TENDER_TYPE_ID REF_NO3
from SA_TRAN_TENDER,
     SA_TRAN_HEAD, 
     SA_STORE_DAY
where SA_TRAN_HEAD.DAY = SA_TRAN_TENDER.DAY
and SA_TRAN_HEAD.STORE = SA_TRAN_TENDER.STORE
and SA_TRAN_HEAD.TRAN_SEQ_NO = SA_TRAN_TENDER.TRAN_SEQ_NO
and SA_STORE_DAY.STORE_DAY_SEQ_NO = SA_TRAN_HEAD.STORE_DAY_SEQ_NO
and SA_STORE_DAY.DAY = SA_TRAN_TENDER.DAY
and SA_STORE_DAY.STORE = SA_TRAN_TENDER.STORE
and SA_TRAN_TENDER.TENDER_TYPE_ID = 10090
and SA_TRAN_HEAD.TRAN_TYPE = 'SALE'
and SA_TRAN_HEAD.SUB_TRAN_TYPE = 'ORDCMP'
and SA_TRAN_HEAD.STATUS !='D'
and (SA_STORE_DAY.AUDIT_STATUS ='R'
   or SA_STORE_DAY.STORE_DAY_SEQ_NO NOT IN
      (select SA_TOTAL.STORE_DAY_SEQ_NO
       from SA_TOTAL
       where SA_TOTAL.TOTAL_ID = 'SALEREPL'
       and SA_TOTAL.STORE = SA_STORE_DAY.STORE
       and SA_TOTAL.STATUS !='D'
       and SA_TOTAL.DAY = SA_STORE_DAY.DAY))
group by SA_TRAN_TENDER.ORIG_CURRENCY,
         SA_TRAN_HEAD.REF_NO4,
         SA_TRAN_TENDER.TENDER_TYPE_ID;

         
set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    N_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000001' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '1000' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000002' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '500' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000003' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '500' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='14000001' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '2000' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='14000002' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '800' and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='14000003' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '800' and ERROR_IND ='N';

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;

     update SA_TRAN_TENDER set TENDER_TYPE_ID = 10090 where tran_seq_no =l_TRAN_SEQ_NO;
     
     
     	IF MOD(l_counter, 3) = 0 THEN
                commit;
			   END IF;	
	end loop;                         
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/



 -- REFUND -- 

select NVL(SUM(SA_TRAN_TENDER.ORIG_CURR_AMT),0) TOTAL,
       SA_TRAN_TENDER.ORIG_CURRENCY REF_NO1, 
       SA_TRAN_HEAD.REF_NO4 REF_NO2, 
       SA_TRAN_TENDER.TENDER_TYPE_ID REF_NO3
from SA_TRAN_TENDER,
     SA_TRAN_HEAD, 
     SA_STORE_DAY
where SA_TRAN_HEAD.STORE = SA_TRAN_TENDER.STORE
    and SA_TRAN_HEAD.DAY = SA_TRAN_TENDER.DAY
    and SA_TRAN_HEAD.TRAN_SEQ_NO = SA_TRAN_TENDER.TRAN_SEQ_NO
    and SA_STORE_DAY.STORE_DAY_SEQ_NO = SA_TRAN_HEAD.STORE_DAY_SEQ_NO
    and SA_STORE_DAY.DAY = SA_TRAN_TENDER.DAY
    and SA_STORE_DAY.STORE = SA_TRAN_TENDER.STORE
and SA_TRAN_HEAD.TRAN_TYPE = 'SALE'
and SA_TRAN_HEAD.SUB_TRAN_TYPE = 'ORDCAN'
/* and SA_STORE_DAY.STORE_DAY_SEQ_NO = I_store_day_seq_no
and SA_STORE_DAY.STORE = l_store
and SA_STORE_DAY.DAY = l_day */
and SA_TRAN_HEAD.STATUS !='D'
and (SA_STORE_DAY.AUDIT_STATUS ='R'
   or SA_STORE_DAY.STORE_DAY_SEQ_NO NOT IN
      (select SA_TOTAL.STORE_DAY_SEQ_NO from SA_TOTAL
       where SA_TOTAL.TOTAL_ID = 'REFUND'
       and SA_TOTAL.STORE = SA_STORE_DAY.STORE
       and SA_TOTAL.STATUS !='D'
       and SA_TOTAL.DAY = SA_STORE_DAY.DAY))
group by SA_TRAN_TENDER.ORIG_CURRENCY,
         SA_TRAN_HEAD.REF_NO4,
         SA_TRAN_TENDER.TENDER_TYPE_ID;  
         
select * from SA_TRAN_HEAD where SUB_TRAN_TYPE = 'ORDCAN';
   --update SA_TRAN_HEAD set SUB_TRAN_TYPE = 'ORDCAN' where SUB_TRAN_TYPE = 'ORDCMP' and TRAN_SEQ_NO = '841263681';


select * from all_sequences where sequence_name like '%SA_TRA%';

select * from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO  ='75021591';
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO = '75021591'; 
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO ='75021591'; 
select * from RMS.SA_TRAN_DISC where TRAN_SEQ_NO ='75021591'; 
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO ='75021591';

delete from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO  ='841625001';
delete from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO = '841625001'; 
delete from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO ='841625001'; 
delete from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO ='841625001';

select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('27-JAN-19');
select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('26-JAN-19');


select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000001' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '5000' and REF_NO4 is not null and ERROR_IND ='N'


 --REFUND
 
set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    N_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000001' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '5000' and REF_NO4 is not null and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000002' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '3000' and REF_NO4 is not null and ERROR_IND ='N'
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='13000003' and SUB_TRAN_TYPE = 'ORDCMP' and rownum <= '2000' and REF_NO4 is not null and ERROR_IND ='N';

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;

    select SA_TRAN_SEQ_NO_SEQUENCE.nextval into N_TRAN_SEQ_NO from dual;
         l_counter := l_counter+1;

insert into SA_TRAN_HEAD
select STORE, DAY, n_TRAN_SEQ_NO, REV_NO, STORE_DAY_SEQ_NO, TRAN_DATETIME, REGISTER, TRAN_NO, CASHIER, SALESPERSON, TRAN_TYPE, 'ORDCAN', ORIG_TRAN_NO, ORIG_TRAN_TYPE, ORIG_REG_NO, REF_NO1, REF_NO2, REF_NO3, REF_NO4, REASON_CODE, VENDOR_NO, VENDOR_INVC_NO, PAYMENT_REF_NO, PROOF_OF_DELIVERY_NO, STATUS, VALUE, POS_TRAN_IND, UPDATE_DATETIME, UPDATE_ID, ERROR_IND, BANNER_NO, ROUNDED_AMT, ROUNDED_OFF_AMT, CREDIT_PROMOTION_ID, REF_NO25, REF_NO26, REF_NO27, RTLOG_ORIG_SYS, TRAN_PROCESS_SYS
    from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
insert into SA_TRAN_ITEM    
select STORE, DAY, n_TRAN_SEQ_NO, ITEM_SEQ_NO, ITEM_STATUS, ITEM_TYPE, ITEM, REF_ITEM, NON_MERCH_ITEM, VOUCHER_NO, DEPT, CLASS, SUBCLASS, QTY, UNIT_RETAIL, SELLING_UOM, OVERRIDE_REASON, ORIG_UNIT_RETAIL, STANDARD_ORIG_UNIT_RETAIL, TAX_IND, ITEM_SWIPED_IND, ERROR_IND, DROP_SHIP_IND, WASTE_TYPE, WASTE_PCT, PUMP, RETURN_REASON_CODE, SALESPERSON, EXPIRATION_DATE, STANDARD_QTY, STANDARD_UNIT_RETAIL, STANDARD_UOM, REF_NO5, REF_NO6, REF_NO7, REF_NO8, UOM_QUANTITY, CATCHWEIGHT_IND, SELLING_ITEM, CUSTOMER_ORDER_LINE_NO, MEDIA_ID, UNIT_RETAIL_VAT_INCL, TOTAL_IGTAX_AMT, UNIQUE_ID, CUST_ORDER_NO, CUST_ORDER_DATE, FULFILL_ORDER_NO, NO_INV_RET_IND, RETURN_WH, SALES_TYPE, RETURN_DISPOSITION
    from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
insert into SA_TRAN_TENDER
select STORE, DAY, n_TRAN_SEQ_NO, TENDER_SEQ_NO, TENDER_TYPE_GROUP, TENDER_TYPE_ID, TENDER_AMT, CC_NO, CC_EXP_DATE, CC_AUTH_NO, CC_AUTH_SRC, CC_ENTRY_MODE, CC_CARDHOLDER_VERF, CC_TERM_ID, CC_SPEC_COND, VOUCHER_NO, COUPON_NO, COUPON_REF_NO, REF_NO9, REF_NO10, REF_NO11, REF_NO12, ERROR_IND, CHECK_ACCT_NO, CHECK_NO, IDENTI_METHOD, IDENTI_ID, ORIG_CURRENCY, ORIG_CURR_AMT
    from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
insert into SA_TRAN_PAYMENT
select STORE, DAY, n_TRAN_SEQ_NO, PAYMENT_SEQ_NO, PAYMENT_AMT, ERROR_IND
    from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO =l_TRAN_SEQ_NO;
insert into SA_TRAN_DISC
select STORE, DAY, n_TRAN_SEQ_NO, ITEM_SEQ_NO, DISCOUNT_SEQ_NO, RMS_PROMO_TYPE, PROMOTION, DISC_TYPE, COUPON_NO, COUPON_REF_NO, QTY, UNIT_DISCOUNT_AMT, STANDARD_QTY, STANDARD_UNIT_DISC_AMT, REF_NO13, REF_NO14, REF_NO15, REF_NO16, ERROR_IND, UOM_QUANTITY, CATCHWEIGHT_IND, PROMO_COMP
    from RMS.SA_TRAN_DISC where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;

     -- dbms_output.put_line('New tran'||n_TRAN_SEQ_NO);
     
     	IF MOD(l_counter, 3) = 0 THEN
                commit;
			   END IF;	
	end loop;                         
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/



--- Delete transactions 
drop table tran_seq_no_null;
create table tran_seq_no_null as 
select distinct tran_seq_no from sa_tran_item where item is null;

select count(tran_seq_no) from tran_seq_no_null;

set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    N_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
     select tran_seq_no from tran_seq_no_null order by 1;
     --select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD where SUB_TRAN_TYPE = 'REFUND';

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;

             l_counter := l_counter+1;
             
delete from RMS.SA_TRAN_TENDER_REV where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_DISC_rev where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_item_rev where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_DISC where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_EXPORTED where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_ERROR where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;
delete from tran_seq_no_null where TRAN_SEQ_NO  =l_TRAN_SEQ_NO;

     	IF MOD(l_counter, 3) = 0 THEN
                commit;
			   END IF;	
	end loop;                         
  commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


select * from all_constraints where constraint_name like 'STE_SHE_FK';
select * from SA_EXPORTED;

select * from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO  ='845252001';
select * from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO = '845252001'; 
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO ='845252001'; 
select * from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO ='845252001';



select STORE_DAY_SEQ_NO,TOTAL_ID,count(1) from sa_total where STORE_DAY_SEQ_NO in 
    (select  STORE_DAY_SEQ_NO from sa_store_day where business_date in ('26-JAN-19','27-JAN-19')) group by STORE_DAY_SEQ_NO,TOTAL_ID order by 1,2;

select STORE_DAY_SEQ_NO,TOTAL_ID,count(1) from sa_total where STORE_DAY_SEQ_NO in 
    (select  STORE_DAY_SEQ_NO from sa_store_day where business_date in ('26-JAN-19','27-JAN-19')) group by STORE_DAY_SEQ_NO,TOTAL_ID having count(1) > 15;
    
select distinct TOTAL_SEQ_NO from sa_total where STORE_DAY_SEQ_NO = '14000001' and total_id ='SALECOGS'  order by 1;




delete from sa_total where total_seq_no ='3500417';
delete from sa_sys_value where total_seq_no ='3500417';

set timing on;

declare
    l_TRAN_SEQ_NO           sa_total.TOTAL_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
    select distinct TOTAL_SEQ_NO from sa_total where STORE_DAY_SEQ_NO = '14000001' and total_id ='SALECOGS' and TOTAL_SEQ_NO > 6000042 order by 1;
    

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TOTAL_SEQ_NO;

             l_counter := l_counter+1;

delete from sa_sys_value where total_seq_no =l_TRAN_SEQ_NO;
delete from sa_total where total_seq_no =l_TRAN_SEQ_NO;


	end loop;                         
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/