set serveroutput on;
set timing on;
 
DECLARE
 
   COUNTER         NUMBER(8)     := 0;
   COUNTER_COMMIT  NUMBER(8)     := 1000;
  i1 NUMBER := 10 ;  

 stage_COMMIT  NUMBER(8)     := 0;
 
 
   p_skulist                    ma_asos.ma_stage_clearance.skulist%type;
   p_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   p_location                   ma_asos.ma_stage_clearance.location%type;
   p_effective_date             ma_asos.ma_stage_clearance.effective_date%type;  
   p_out_of_stock_date          ma_asos.ma_stage_clearance.out_of_stock_date%type; 
   p_reset_date                 ma_asos.ma_stage_clearance.reset_date%type; 
   p_change_amount              ma_asos.ma_stage_clearance.change_amount%type; 
   p_clearance_display_id       ma_asos.ma_stage_clearance.CLEARANCE_DISPLAY_ID%type; 
   p_clearance_id               ma_asos.ma_stage_clearance.clearance_id%type; 
   p_change_type				ma_asos.ma_stage_clearance.change_type%type; 
   
   
 cursor c_get_cuitem_clr is
    select  CLEARANCE_ID, 
            CLEARANCE_DISPLAY_ID,
            skulist, 
            zone_id, 
            EFFECTIVE_DATE, 
            OUT_OF_STOCK_DATE, 
            RESET_DATE, 
            CHANGE_TYPE, 
            CHANGE_AMOUNT              
    from rms.rpm_clearance rpc  where state like 'pricechange.state.approved' 
         and EFFECTIVE_DATE >= '02-MAR-20' and ZONE_NODE_TYPE ='1' and skulist is not null and rownum<='5'
        and not exists (select 1 from ma_asos.ma_stage_clearance mspc where mspc.STAGE_CLEARANCE_ID =rpc.CLEARANCE_DISPLAY_ID); 

	  
	  
BEGIN

FOR cust_ma in c_get_cuitem_clr Loop

		p_clearance_id			:= cust_ma.CLEARANCE_ID; 
		p_clearance_display_id	:= cust_ma.CLEARANCE_DISPLAY_ID;
		p_skulist				:= cust_ma.skulist; 
		p_zone_id				:= cust_ma.zone_id; 
		p_effective_date		:= cust_ma.EFFECTIVE_DATE; 
		p_out_of_stock_date		:= cust_ma.OUT_OF_STOCK_DATE; 
		p_reset_date			:= cust_ma.RESET_DATE; 
		p_change_type 			:= cust_ma.CHANGE_TYPE; 
		p_change_amount			:= cust_ma.CHANGE_AMOUNT; 
							
              
         
          insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                  message_seq,                                                  
                                                  message_type,
                                                  reason_code,												
                                                  skulist,													
                                                  zone_id,													
                                                  zone_node_type,											
                                                  effective_date,
                                                  out_of_stock_date,
                                                  reset_date,
                                                  change_type,
                                                  change_amount,
                                                  auto_approve_ind,
                                                  status,
                                                  vendor_funded_ind,
                                                  create_datetime,
                                                  last_update_datetime,
                                                  create_id,
                                                  last_update_id,
												  CLEARANCE_ID, 
												  CLEARANCE_DISPLAY_ID)

                                values            (p_clearance_display_id ,
                                                   1,
                                                   'W', 
                                                   20,
                                                   p_skulist ,
                                                   p_zone_id ,
                                                   1,
                                                   p_effective_date,
                                                   p_out_of_stock_date,
                                                   p_reset_date,
                                                   p_change_type,
                                                   p_change_amount ,
                                                   1,
                                                   'N',
                                                   0,
                                                   sysdate,
                                                   sysdate,
                                                   'PTUSER',
                                                   'PTUSER',
												   p_clearance_id,
												   p_clearance_display_id);
                                                   
	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 500) = 0 THEN
				COMMIT;
			   END IF;	
 
                        END LOOP;   
						
	
		commit;
        
   
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
