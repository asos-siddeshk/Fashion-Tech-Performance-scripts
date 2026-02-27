select * from RMS.SA_STORE_DAY WHERE BUSINESS_DATE IN ('08-May-2021');

select * from RMS.SA_TRAN_HEAD where TRAN_TYPE = 'REFUND';
select * from sa_exported where tran_seq_no in (select tran_seq_no from RMS.SA_TRAN_HEAD where TRAN_TYPE = 'REFUND');

select * from RMS.SA_TRAN_HEAD where TRAN_TYPE = 'SPLORD' and store_day_seq_no in (14000001) and ERROR_IND ='N';

select * from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO  ='75021576';
select * from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO ='75021576';


    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no in ('14000001') and TRAN_TYPE = 'SPLORD' and ERROR_IND ='N' and rownum <= '2';

272000403
272000401
272000402
    
--   Tender
    
set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    N_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='272000401' and TRAN_TYPE = 'SPLORD' and ERROR_IND ='N' and rownum <= '5000' 
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='272000402' and TRAN_TYPE = 'SPLORD' and ERROR_IND ='N' and rownum <= '2300' 
    union
    select TRAN_SEQ_NO from SA_TRAN_HEAD where store_day_seq_no ='272000403' and TRAN_TYPE = 'SPLORD' and ERROR_IND ='N' and rownum <= '2600';

begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;

    select SA_TRAN_SEQ_NO_SEQUENCE.nextval into N_TRAN_SEQ_NO from dual;
         l_counter := l_counter+1;

insert into SA_TRAN_HEAD
select STORE, DAY, n_TRAN_SEQ_NO, REV_NO, STORE_DAY_SEQ_NO, TRAN_DATETIME, REGISTER, TRAN_NO, CASHIER, SALESPERSON, 'REFUND', SUB_TRAN_TYPE, ORIG_TRAN_NO, ORIG_TRAN_TYPE, ORIG_REG_NO, null, REF_NO2, REF_NO3, REF_NO4, REASON_CODE, VENDOR_NO, VENDOR_INVC_NO, PAYMENT_REF_NO, PROOF_OF_DELIVERY_NO, STATUS, '0', POS_TRAN_IND, UPDATE_DATETIME, UPDATE_ID, ERROR_IND, BANNER_NO, ROUNDED_AMT, ROUNDED_OFF_AMT, CREDIT_PROMOTION_ID, REF_NO25, 'Standard', REF_NO27, RTLOG_ORIG_SYS, TRAN_PROCESS_SYS
    from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 

insert into SA_TRAN_TENDER
select STORE, DAY, n_TRAN_SEQ_NO, TENDER_SEQ_NO, TENDER_TYPE_GROUP, '10040', '-'||TENDER_AMT, CC_NO, CC_EXP_DATE, CC_AUTH_NO, CC_AUTH_SRC, CC_ENTRY_MODE, CC_CARDHOLDER_VERF, CC_TERM_ID, CC_SPEC_COND, VOUCHER_NO, COUPON_NO, COUPON_REF_NO, REF_NO9, REF_NO10,'Klarna','Klarna Invoice', ERROR_IND, CHECK_ACCT_NO, CHECK_NO, IDENTI_METHOD, IDENTI_ID, ORIG_CURRENCY, '-'||ORIG_CURR_AMT
    from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
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

--   Generic

select * from sa_exported where TRAN_SEQ_NO in (select TRAN_SEQ_NO from SA_TRAN_HEAD where SUB_TRAN_TYPE = 'ORDCAN') order by EXP_DATETIME desc ;
 
 
 
 set serveroutput on;
set timing on;

declare
    l_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    N_TRAN_SEQ_NO           SA_TRAN_HEAD.TRAN_SEQ_NO%type;
    l_counter           number(10) := 1;
    
cursor c_custord is
  select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD sth where store_day_seq_no ='13000001' and SUB_TRAN_TYPE = 'ORDCMP' and ERROR_IND ='N'  and rownum <= '15000' 
    and exists (select  1 from rms.SA_TRAN_item std where sth.TRAN_SEQ_NO = std.TRAN_SEQ_NO)
  union
 select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD sth where store_day_seq_no ='13000002' and SUB_TRAN_TYPE = 'ORDCMP' and ERROR_IND ='N'  and rownum <= '15000' 
    and exists (select  1 from rms.SA_TRAN_item std where sth.TRAN_SEQ_NO = std.TRAN_SEQ_NO)
 union
 select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD sth where store_day_seq_no ='13000003' and SUB_TRAN_TYPE = 'ORDCMP' and ERROR_IND ='N'  and rownum <= '15000' 
    and exists (select  1 from rms.SA_TRAN_item std where sth.TRAN_SEQ_NO = std.TRAN_SEQ_NO)
 union
 select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD sth where store_day_seq_no ='14000001' and SUB_TRAN_TYPE = 'ORDCMP' and ERROR_IND ='N'  and rownum <= '50000' 
    and exists (select  1 from rms.SA_TRAN_item std where sth.TRAN_SEQ_NO = std.TRAN_SEQ_NO)
  union
 select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD sth where store_day_seq_no ='14000002' and SUB_TRAN_TYPE = 'ORDCMP' and ERROR_IND ='N'  and rownum <= '35000' 
    and exists (select  1 from rms.SA_TRAN_item std where sth.TRAN_SEQ_NO = std.TRAN_SEQ_NO)
 union
 select TRAN_SEQ_NO from RMS.SA_TRAN_HEAD sth where store_day_seq_no ='14000003' and SUB_TRAN_TYPE = 'ORDCMP' and ERROR_IND ='N'  and rownum <= '35000' 
    and exists (select  1 from rms.SA_TRAN_item std where sth.TRAN_SEQ_NO = std.TRAN_SEQ_NO);
    
begin
for i in c_custord loop 
	l_TRAN_SEQ_NO    := i.TRAN_SEQ_NO;

    select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into N_TRAN_SEQ_NO from dual;
         l_counter := l_counter+1;

insert into rms.SA_TRAN_HEAD
select STORE, DAY, n_TRAN_SEQ_NO, REV_NO, STORE_DAY_SEQ_NO, TRAN_DATETIME, REGISTER, TRAN_NO, CASHIER, SALESPERSON, TRAN_TYPE, 'ORDCAN', ORIG_TRAN_NO, ORIG_TRAN_TYPE, ORIG_REG_NO, REF_NO1, REF_NO2, REF_NO3, REF_NO4, REASON_CODE, VENDOR_NO, VENDOR_INVC_NO, PAYMENT_REF_NO, PROOF_OF_DELIVERY_NO, STATUS, '-'||VALUE, POS_TRAN_IND, UPDATE_DATETIME, UPDATE_ID, ERROR_IND, BANNER_NO, ROUNDED_AMT, ROUNDED_OFF_AMT, CREDIT_PROMOTION_ID, REF_NO25, 'Pink', REF_NO27, RTLOG_ORIG_SYS, TRAN_PROCESS_SYS
    from RMS.SA_TRAN_HEAD where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
insert into rms.SA_TRAN_ITEM    
select STORE, DAY, n_TRAN_SEQ_NO, ITEM_SEQ_NO, 'ORC', ITEM_TYPE, ITEM, REF_ITEM, NON_MERCH_ITEM, VOUCHER_NO, DEPT, CLASS, SUBCLASS, '-'||QTY, UNIT_RETAIL, SELLING_UOM, OVERRIDE_REASON, ORIG_UNIT_RETAIL, STANDARD_ORIG_UNIT_RETAIL, TAX_IND, ITEM_SWIPED_IND, ERROR_IND, DROP_SHIP_IND, WASTE_TYPE, WASTE_PCT, PUMP, RETURN_REASON_CODE, SALESPERSON, EXPIRATION_DATE, '-'||STANDARD_QTY, STANDARD_UNIT_RETAIL, STANDARD_UOM, REF_NO5, REF_NO6, REF_NO7, REF_NO8, '-'||UOM_QUANTITY, CATCHWEIGHT_IND, SELLING_ITEM, CUSTOMER_ORDER_LINE_NO, MEDIA_ID, UNIT_RETAIL_VAT_INCL, TOTAL_IGTAX_AMT, UNIQUE_ID, CUST_ORDER_NO, CUST_ORDER_DATE, FULFILL_ORDER_NO, NO_INV_RET_IND, RETURN_WH, SALES_TYPE, RETURN_DISPOSITION
    from RMS.SA_TRAN_ITEM where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
insert into rms.SA_TRAN_TENDER
select STORE, DAY, n_TRAN_SEQ_NO, TENDER_SEQ_NO, TENDER_TYPE_GROUP, TENDER_TYPE_ID, '-'||TENDER_AMT, CC_NO, CC_EXP_DATE, CC_AUTH_NO, CC_AUTH_SRC, CC_ENTRY_MODE, CC_CARDHOLDER_VERF, CC_TERM_ID, CC_SPEC_COND, VOUCHER_NO, COUPON_NO, COUPON_REF_NO, REF_NO9, REF_NO10, REF_NO11, REF_NO12, ERROR_IND, CHECK_ACCT_NO, CHECK_NO, IDENTI_METHOD, IDENTI_ID, ORIG_CURRENCY, ORIG_CURR_AMT
    from RMS.SA_TRAN_TENDER where TRAN_SEQ_NO =l_TRAN_SEQ_NO; 
insert into rms.SA_TRAN_PAYMENT
select STORE, DAY, n_TRAN_SEQ_NO, PAYMENT_SEQ_NO, '-'||PAYMENT_AMT, ERROR_IND
    from RMS.SA_TRAN_PAYMENT where TRAN_SEQ_NO =l_TRAN_SEQ_NO;
insert into rms.SA_TRAN_DISC
select STORE, DAY, n_TRAN_SEQ_NO, ITEM_SEQ_NO, DISCOUNT_SEQ_NO, RMS_PROMO_TYPE, PROMOTION, DISC_TYPE, COUPON_NO, COUPON_REF_NO, '-'||QTY, UNIT_DISCOUNT_AMT, '-'||STANDARD_QTY, STANDARD_UNIT_DISC_AMT, REF_NO13, REF_NO14, REF_NO15, REF_NO16, ERROR_IND, '-'||UOM_QUANTITY, CATCHWEIGHT_IND, PROMO_COMP
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
