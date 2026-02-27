 -- nb_refresh_result.ksh <alias> DASH_TSF_DISC_HEAD
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_TSF_DISC_HEAD';

select * from dash_asos.DASH_TSF_DISC_HEAD;
select * from dash_asos.DASH_R_TSF_DISC_HEAD_B;
select * from dash_asos.DASH_R_TSF_DISC_HEAD_B;
select * from dash_asos.DASH_V_R_TSF_DISC_HEAD;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_TSF_DISC_HEAD';    
select * from all_views where upper(view_name) like 'DASH_V_R_TSF_DISC_HEAD';  


           set serveroutput on;
                    set timing on;
                     
                    DECLARE
                     
                     COUNTER            NUMBER(8)     := 0;
                     l_order_no           rms.SHIPMENT.SHIPMENT%type;
                     l_date           date;
                     
                     cursor cur_dept is
                     
                       select SHIPMENT from shipment sh where status_code  in ('I','R') and bol_no is not null and rownum <= '5000' 
                        and not exists (select 1 from int_asos.INT_RECEIPT_CLOSE_HEAD rcp where rcp.shipment = sh.shipment) ;
                    
                    BEGIN
                        
                        select vdate into l_date from period;
                        
                    for k in cur_dept loop    
                        l_order_no := k.SHIPMENT;
                    
                        INSERT INTO int_asos.INT_RECEIPT_CLOSE_HEAD (SHIPMENT, BOL_NO, LOC, CLOSE_DATE, CREATE_ID, CREATE_DATETIME)
                                select SHIPMENT,BOL_NO,TO_LOC AS LOC,l_date -COUNTER AS CLOSE_DATE, 'INT_ASOS' CREATE_ID, SYSDATE CREATE_DATETIME
                                from shipment where SHIPMENT = l_order_no;

                        INSERt INTO int_asos.INT_RECEIPT_CLOSE_DETAIL (SHIPMENT, ITEM, QTY, CARTON, MISSING_IND, CREATE_ID, CREATE_DATETIME)
                            SELECT SHIPMENT, ITEM, QTY_EXPECTED, CARTON,'Y','INT_ASOS' CREATE_ID,SYSDATE CREATE_DATETIME FROM SHIPSKU 
                                WHERE SHIPMENT = l_order_no;
                            
                              IF MOD(COUNTER, 100) = 0 THEN
                                    COUNTER :=COUNTER + 1;
                                    --  commit;
                                   END IF;	
                            
                            
                    end loop;
                    commit;
                    
                    EXCEPTION 
                       when OTHERS THEN
                          dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
                          ROLLBACK;
                     
                    END;
                    /

 
 
 -- nb_refresh_result.ksh <alias> DASH_TSF_DISC_BOX
 
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_TSF_DISC_BOX';

select * from dash_asos.DASH_TSF_DISC_BOX;
select * from dash_asos.DASH_R_TSF_DISC_BOX_B;
select * from dash_asos.DASH_R_TSF_DISC_BOX_A;
select * from dash_asos.DASH_V_R_TSF_DISC_BOX;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_TSF_DISC_BOX';    
select * from all_views where upper(view_name) like 'DASH_V_R_TSF_DISC_BOX';
 
 -- nb_refresh_result.ksh <alias> DASH_TSF_DISC_SKU
SELECT * FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_TSF_DISC_SKU';

select * from dash_asos.DASH_TSF_DISC_SKU;
select * from dash_asos.DASH_R_TSF_DISC_SKU_A;
select * from dash_asos.DASH_R_TSF_DISC_SKU_B;
select * from dash_asos.DASH_V_R_TSF_DISC_SKU;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_TSF_DISC_SKU';    
select * from all_views where upper(view_name) like 'DASH_V_R_TSF_DISC_SKU';