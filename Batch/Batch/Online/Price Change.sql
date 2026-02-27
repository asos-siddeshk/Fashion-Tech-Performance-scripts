--alter session set current_schema=int_asos;
set serveroutput on;
set timing on;
 
DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1;
  
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
   O_error_message              ma_asos.MA_LOGS.MSG_CODE%TYPE;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                   rms.subclass.subclass%type; 
   ma_zone_id              	    rms.rpm_stage_clearance.zone_id%type;
   ma_location              	rms.rpm_stage_clearance.location%type;

		  
	 cursor cur_dept is --16991
		select dept,zone_id,store from (
		   select distinct im.dept,ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			dept!='9999'  or subclass!='9999'or class!='9999' 
            group by im.dept,ma.ZONE_ID,ma.store);
	
	CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
                select * from ( select im.item,
                                            ma.zone_id,
                                            s.currency_code,
                                            il.loc as location,
                                            il.selling_unit_retail as current_retail,
                                            il.selling_unit_retail + 15 as new_retail
                      from skumar.option_item             im,
                           ma_asos.ma_pricing_defaults ma,
                           rms.item_loc                il,
                           rms.store                   s
                     where im.dept = l_dept
                       and il.item = im.item
                       and il.loc = l_location
                       and s.store = il.loc
                       and ma.store = il.loc
                       and not exists (select 1 from ma_asos.ma_price_change mc
                             where mc.item = im.item
                               and mc.LOCATION = il.loc)) where rownum <= 2;

 
 				 
BEGIN    

    select vdate+2 into p_effective_date from rms.period;
      
for k in cur_dept loop
  l_dept := k.dept;
	     ma_zone_id := k.zone_id;
         ma_location := k.store;
         
         
   FOR cust_ma in c_get_cuitem_pc(l_dept,ma_zone_id,ma_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
        
        select ma_asos.MA_PRICE_CHANGE_TRANS_SEQ.nextval into  p_pc_tran_id from dual;
   
                p_item_id                   := cust_ma.item;  
                p_zone_id                   := cust_ma.zone_id;
                p_Location                  := cust_ma.location;
                p_current_retail            := cust_ma.current_retail;
				p_new_retail             	:= cust_ma.new_retail;
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
                                values                  (p_pc_tran_id,
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
														sysdate,
														sysdate,
														'PTUSER',
														'PTUSER',
														p_pc_stage_id,
                                                        p_current_retail,
                                                        ((p_current_retail+p_new_retail)/p_current_retail),
                                                        p_pc_c_stage_id,
                                                        ((p_current_retail+p_new_retail)/p_current_retail)-((p_current_retail-p_new_retail)/p_current_retail) );
														
           
				if ma_asos.ma_pricing_sql.update_pricing_change(O_error_message,p_pc_tran_id,'S') = false then
							--   dbms_output.put_line( p_pc_tran_id||': Failed'||O_error_message);
            continue;
                               else 
                            --  dbms_output.put_line('Sucess' || p_pc_tran_id);
            continue;
				end if;

	
 
END LOOP; 
END LOOP; 
commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/