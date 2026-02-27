 -- nb_refresh_result.ksh <alias> DASH_FACT_CORREC
 --  Approved worksheet order's

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_FACT_CORREC';

select * from dash_asos.DASH_FACT_CORREC;
select * from dash_asos.DASH_R_FACT_CORREC_DTL_A;
select * from dash_asos.DASH_R_FACT_CORREC_DTL_B;
select * from dash_asos.DASH_V_R_FACT_CORREC_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_FACT_CORREC';    
select * from all_views where upper(view_name) like 'DASH_V_R_FACT_CORREC_DTL'; 


 -- nb_refresh_result.ksh <alias> DASH_ACTION_ASN
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ACTION_ASN';
select * from dash_asos.DASH_ACTION_ASN ;
select * from dash_asos.DASH_R_ACTION_ASN_DTL_A;
select * from dash_asos.DASH_R_ACTION_ASN_DTL_B;
select * from dash_asos.DASH_V_R_ACTION_ASN_DTL where order_no in (select order_no from dash_asos.ordhead where master_po_no ='642577');;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ACTION_ASN';    
select * from all_views where upper(view_name) like 'DASH_V_R_ACTION_ASN_DTL'; 

                    
                    SELECT oh.order_no   FROM dash_asos.ordhead                oh
                     WHERE oh.status            = 'A' 
                     and oh.PICKUP_DATE       < get_vdate() + 28
                                    and not exists (select 1 from rms.shipment sh where sh.order_no =oh.order_no) ;
                    
                    
                    
                    set serveroutput on;
                    set timing on;
                     
                    DECLARE
                     
                     COUNTER            NUMBER(8)     := 0;
                     l_order_no           rms.ordhead.order_no%type;
                     
                     cursor cur_dept is
                SELECT oh.order_no   FROM ordhead                oh
                     WHERE oh.status            = 'A' 
                     and oh.PICKUP_DATE       > get_vdate() 
                     and not exists (select 1 from rms.shipment sh where sh.order_no =oh.order_no) and rownum <= '4000';
                    
                    BEGIN
                    for k in cur_dept loop    
                        l_order_no := k.order_no;
                    
                        Update ordhead set PICKUP_DATE = get_vdate()+COUNTER where order_no = l_order_no;
                                    
                                   IF MOD(COUNTER, 100) = 0 THEN
                                    COUNTER :=COUNTER + 1;
                                    --  commit;
                                   END IF;	
                    end loop;
                    --commit;
                    
                    EXCEPTION 
                       when OTHERS THEN
                          dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
                          ROLLBACK;
                     
                    END;
                    /
                    
                    select * from order_mfqueue;



 -- nb_refresh_result.ksh <alias> DASH_PEND_RECEIPT

SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_PEND_RECEIPT';
select * from dash_asos.DASH_PEND_RECEIPT;
select * from dash_asos.DASH_R_PEND_RCPT_DTL_A;
select * from dash_asos.DASH_R_PEND_RCPT_DTL_B;
select * from dash_asos.DASH_V_R_PEND_RECEIPT_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_PEND_RECEIPT';    
select * from all_views where upper(view_name) like 'DASH_V_R_PEND_RECEIPT_DTL'; 
select * from dash_asos.v_cfa_ship_dates_g;

select * from dash_asos.DASH_BM_GTT;

    set serveroutput on;
    set timing on;
     
    DECLARE
     
     COUNTER            NUMBER(8)     := 2;
     l_order_no           rms.NB_SHIPMENT_CFA_EXT.shipment%type;
     
     cursor cur_dept is
      select shipment from rms.NB_SHIPMENT_CFA_EXT g where group_id = '1010100' and
            exists (select 1 from rms.shipment sh, rms.ordhead oh  where sh.order_no = oh.order_no and oh.status ='A' 
                and sh.shipment = g.shipment) and rownum <= '1';
    
    BEGIN
    for k in cur_dept loop    
        l_order_no := k.shipment;
    
        Update rms.NB_SHIPMENT_CFA_EXT set DATE_24 = get_vdate()-COUNTER where group_id = '1010100' and shipment = l_order_no;
                    
                   IF MOD(COUNTER, 50) = 0 THEN
                    COUNTER :=COUNTER + 1;
                    --  commit;
                   END IF;	
    end loop;
    --commit;
         dbms_output.put_line('Exception blcok'||l_order_no);
    EXCEPTION 
       when OTHERS THEN
          dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
          ROLLBACK;
     
    END;
    /
    
    select * from order_mfqueue;


 -- nb_refresh_result.ksh <alias> DASH_PEND_SHIP
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_PEND_SHIP';

select * from dash_asos.DASH_PEND_SHIP;
select * from dash_asos.DASH_R_PEND_SHIP_A;
select * from dash_asos.DASH_R_PEND_SHIP_B;
select * from dash_asos.DASH_V_R_PEND_SHIP_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_PEND_SHIP';    
select * from all_views where upper(view_name) like 'DASH_V_R_PEND_SHIP_DTL'; 


   select shipment from rms.NB_SHIPMENT_CFA_EXT g where group_id = 1010100 and DATE_24 is null and DATE_23 is null and DATE_22 is null
    and exists (select 1 from rms.shipment sh, rms.ordhead oh  where sh.order_no = oh.order_no and oh.status ='A' 
        and sh.shipment = g.shipment) and rownum <= '1000';      
           
                    set serveroutput on;
                    set timing on;
                     
                    DECLARE
                     
                     COUNTER            NUMBER(8)     := 2;
                     l_order_no           rms.NB_SHIPMENT_CFA_EXT.shipment%type;
                     
                     cursor cur_dept is
                     select shipment from rms.NB_SHIPMENT_CFA_EXT g where group_id = 1010100 and DATE_24 is null and DATE_23 is null and DATE_22 is null
                        and exists (select 1 from rms.shipment sh, rms.ordhead oh  where sh.order_no = oh.order_no and oh.status ='A' 
                            and sh.shipment = g.shipment) and rownum <= '1000';
                    
                    BEGIN
                    for k in cur_dept loop    
                        l_order_no := k.shipment;
                    
                        Update rms.NB_SHIPMENT_CFA_EXT set DATE_22 = get_vdate()-COUNTER where group_id = '1010100' and shipment = l_order_no;
                                    
                                   IF MOD(COUNTER, 50) = 0 THEN
                                    COUNTER :=COUNTER + 1;
                                    --  commit;
                                   END IF;	
                    end loop;
                    commit;
                         dbms_output.put_line('Exception blcok'||l_order_no);
                    EXCEPTION 
                       when OTHERS THEN
                          dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
                          ROLLBACK;
                     
                    END;
                    /
                    

 -- nb_refresh_result.ksh <alias> DASH_PEND_CARR_BOOK
SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_PEND_CARR_BOOK';

select * from dash_asos.DASH_PEND_CARR_BOOK;
select * from dash_asos.DASH_R_PEND_CARR_BOOK_A;
select * from dash_asos.DASH_R_PEND_CARR_BOOK_B;
select * from dash_asos.DASH_V_R_P_CARR_BOOK_DTL;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_PEND_CARR_BOOK';    
select * from all_views where upper(view_name) like 'DASH_V_R_P_CARR_BOOK_DTL'; 

 -- nb_refresh_result.ksh <alias> DASH_PEND_FC_BOOK
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_PEND_FC_BOOK';
select * from dash_asos.DASH_PEND_FC_BOOK;
select * from dash_asos.DASH_R_PEND_FC_BOOK_DTL_A;
select * from dash_asos.DASH_R_PEND_FC_BOOK_DTL_B;
select * from dash_asos.DASH_V_R_PEND_FC_BOOK_DTL;
select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_PEND_CARR_BOOK';    
select * from all_views where upper(view_name) like 'DASH_V_R_PEND_FC_BOOK_DTL'; 