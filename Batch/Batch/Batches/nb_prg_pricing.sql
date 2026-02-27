Update ma_asos.ma_price_change set EFFECTIVE_DATE='30-NOV-18' where trunc(EFFECTIVE_DATE)='19-NOV-18';
Update ma_asos.ma_price_change set EFFECTIVE_DATE='29-NOV-18' where trunc(EFFECTIVE_DATE)='20-NOV-18';
Update ma_asos.ma_price_change set EFFECTIVE_DATE='25-NOV-18' where trunc(EFFECTIVE_DATE)='23-NOV-18';
Update ma_asos.ma_price_change set EFFECTIVE_DATE='26-NOV-18' where trunc(EFFECTIVE_DATE)='24-NOV-18';
commit;

select EFFECTIVE_DATE,count(1) from ma_asos.ma_price_change group by EFFECTIVE_DATE order by EFFECTIVE_DATE;

SELECT count(distinct(pc.price_change_id))
    FROM ma_asos.ma_price_change pc,
         RMS.rpm_system_options so
   WHERE pc.status = 'W'
     AND pc.effective_date < (get_vdate - so.reject_hold_days_pc_clear)
   GROUP BY pc.trans_id,
            pc.price_change_id;  
            

set serveroutput on;
set timing on;
 
DECLARE
 
COUNTER         NUMBER(5)     := 0;
COUNTER_COMMIT  NUMBER(5)     := 10;
  
   p_pc_s_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_item_id                    ma_asos.ma_price_change.item%type;
   p_zone_id                    ma_asos.ma_price_change.zone_id%type;
   p_location                   ma_asos.ma_price_change.location%type;
   p_effective_date             ma_asos.ma_price_change.effective_date%type;  
   p_current_retail             ma_asos.ma_price_change.current_price%type;
   p_new_retail              	ma_asos.ma_price_change.current_price%type;
   p_pc_d_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_pc_stage_id                ma_asos.ma_price_change.price_change_id%type;
   p_pc_c_stage_id              ma_asos.ma_price_change.CUST_ATTR_ID%type;
   p_currency_code 				ma_asos.ma_price_change.currency_code%type;
   P_PC_TRAN_ID                 ma_asos.ma_price_change.TRANS_ID%type;
   P_TRAN_ID                    ma_asos.ma_price_change.TRANS_ID%type;
   O_error_message         ma_asos.MA_LOGS.MSG_CODE%TYPE;
     
CURSOR c_get_cuitem_pc IS
				select im.item,
						ma.zone_id, 
						ma.store as location,
						s.currency_code,
						p.vdate-8 as effective_date,
						il.selling_unit_retail as current_retail,
						il.selling_unit_retail +5 as new_retail
				from rms.item_loc        il,
					 rms.item_master     im,
					 ma_asos.ma_pricing_defaults ma,
					 rms.period p,
					 rms.rpm_zone_location rzl,
					 rms.store s
				where il.item             = im.item
				 and il.clear_ind ='N'
				 and il.promo_retail is null 
				 and il.loc = ma.store
				 and rzl.location = ma.store
				 and ma.store=s.store
				 and rzl.zone_id =ma.zone_id
                 and im.item_level = im.tran_level and rownum<= 10000
                 order by item,
						zone_id, 
						location;
 			 
				 
BEGIN    
   select ma_asos.MA_PRICE_CHANGE_TRANS_SEQ.nextval into  p_pc_tran_id from dual;


FOR  inc in 0..0 Loop

FOR cust_ma in c_get_cuitem_pc Loop
                p_item_id                   := cust_ma.item;  
                p_zone_id                   := cust_ma.zone_id;
                p_Location                  := cust_ma.location;
                p_effective_date            := cust_ma.effective_date-inc;
                p_current_retail            := cust_ma.current_retail;
				p_new_retail             	:= cust_ma.new_retail+inc;
				p_CURRENCY_CODE             := cust_ma.currency_code; 							
                
                select rms.RPM_PRICE_CHANGE_DISPLAY_SEQ.nextval into p_pc_d_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_SEQ.nextval into p_pc_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_CUST_ATTR_SEQ.nextval into p_pc_c_stage_id from dual;
   
                insert into ma_asos.ma_price_change ( 	trans_id        , 
														price_change_id , 
														zone_group_id   , 
														zone_id         , 
														location        , 
														currency_code   , 
														item            , 
														effective_date  , 
														reason_code     , 
														status          ,
														new_price           ,
														new_margin          ,
														create_datetime     ,
														last_update_datetime,
														create_id           ,
														last_update_id      ,
														rms_price_change_id ,
                                                        CURRENT_PRICE, 
                                                        CURRENT_MARGIN,
                                                        CUST_ATTR_ID,
                                                        CONV_LANDED_VALUE)
                                values                  (   p_pc_tran_id,
														p_pc_d_stage_id,
														2,
														p_zone_id,
														p_location,
														p_currency_code,
														p_item_id,
														p_effective_date,
														12,
														'W',
														p_new_retail,
														((p_current_retail-p_new_retail)/p_current_retail),
														p_effective_date,
														p_effective_date,
														'PTUSER',
														'PTUSER',
														p_pc_stage_id,
                                                        p_current_retail,
                                                        ((p_current_retail+p_new_retail)/p_current_retail),
                                                        p_pc_c_stage_id,
                                                        ((p_current_retail+p_new_retail)/p_current_retail)-((p_current_retail-p_new_retail)/p_current_retail) );
														
					END LOOP;
                    
    COUNTER_COMMIT :=COUNTER_COMMIT + 1;
 
       IF MOD(COUNTER_COMMIT, 7) = 0 THEN
        COMMIT;
        select ma_asos.MA_PRICE_CHANGE_TRANS_SEQ.nextval into p_pc_tran_id from dual;
       END IF;
       
END LOOP;
  commit;
  
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
