drop table rpm_stage_simple_promo_bk;
create table rpm_stage_simple_promo_bk_2 as
select  * from rms.rpm_stage_simple_promo;

drop table ma_stage_simple_promo_bk;
create table ma_stage_simple_promo_bk as
select * from ma_asos.ma_stage_simple_promo ;


delete from rpm_stage_simple_promo;
delete from ma_asos.ma_stage_simple_promo;

select status,ERROR_MESSAGE from rpm_stage_simple_promo;
select * from ma_asos.ma_stage_simple_promo;
delete from rpm_stage_simple_promo;
truncate table rpm_stage_simple_promo;
select * from rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo);
select * from rpm_promo_comp where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.rpm_stage_simple_promo);
select * from rpm_promo where PROMO_ID in (select PROMO_ID from rms.rpm_stage_simple_promo);


DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1000;

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
    p_change_type		    ma_asos.ma_stage_price_change.change_type%type; 
    p_change_amount		    ma_asos.ma_stage_price_change.change_amount%type; 
    p_change_currency	    ma_asos.ma_stage_price_change.change_currency%type;
    p_change_selling_uom    ma_asos.ma_stage_price_change.change_selling_uom%type;	 



	 CURSOR c_get_cuitem_pc is
				select  price_change_id, 
						price_change_display_id, 
						item, 
						location, 
						effective_date, 
						change_type, 
						change_amount, 
						change_currency, 
						change_selling_uom 						
				from rpm_price_change rpc where state like 'pricechange.state.approved' and effective_date > '12-NOV-18' and ZONE_NODE_TYPE ='0' and 
                rownum <='1000'
                    and not exists (select 1 from ma_asos.ma_stage_price_change mspc where mspc.STAGE_PRICE_CHANGE_ID =rpc.price_change_display_id);


BEGIN    
   FOR cust_ma in c_get_cuitem_pc Loop

			p_pc_stage_id   	:= cust_ma.price_change_id; 
			p_pc_d_stage_id 	:= cust_ma.price_change_display_id; 
			p_item_id 			:= cust_ma.item; 
			p_Location			:= cust_ma.location; 
			p_effective_date	:= cust_ma.effective_date; 
			p_change_type		:= cust_ma.change_type; 
			p_change_amount		:= cust_ma.change_amount; 
			p_change_currency	:= cust_ma.change_currency; 
			p_change_selling_uom:= cust_ma.change_selling_uom; 						


                insert into ma_asos.ma_stage_price_change (stage_price_change_id
														, message_seq
														, message_type
														, reason_code
														, item
														, location
														, zone_node_type
														, effective_date
														, change_type
														, change_amount
														, null_multi_ind
														, ignore_constraints
														, auto_approve_ind
														, status
														, price_change_id
														, price_change_display_id
														, vendor_funded_ind
														, zone_group_id
														, stage_cust_attr_id
														, cust_attr_id
														, create_datetime
														, last_update_datetime
														, create_id
														, last_update_id
                                                        , CHANGE_SELLING_UOM )
                                values               ( p_pc_d_stage_id
														, 1
														, 'W'
														, 12
														, p_item_id
														, p_Location
														, 0
														, p_effective_date
														, p_change_type
														, p_change_amount
														, 0
														, 1
														, 1
														, 'N'
														, p_pc_stage_id
														, p_pc_d_stage_id
														, 0
														, null
														, null
														, null
														, sysdate
														, sysdate
														, 'PTUSER'
														, 'PTUSER'
                                                        , p_change_selling_uom);

	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 100) = 0 THEN
				COMMIT;
			   END IF;	

    END LOOP; 

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;

END;/
