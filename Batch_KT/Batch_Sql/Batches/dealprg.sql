
  /*
alter session set current_schema=rms;

select * from  rms.DEAL_HEAD where deal_id between 60018  and 60022;
select * from  rms.DEAL_DETAIL where deal_id between 60018  and 60022;
select * from  rms.DEAL_ACTUALS_FORECAST where deal_id between 60018  and 60022;
select * from  rms.DEAL_THRESHOLD where deal_id between 60018  and 60022;
select * from  rms.DEAL_ITEMLOC_DCS where deal_id between 60018  and 60022;
select * from  rms.DEAL_ITEM_LOC_explode where deal_id between 60018  and 60022;
select deal_id,count(deal_id) from  rms.DEAL_ITEM_LOC_explode where deal_id between 60018  and 60022 group by deal_id order by 1 desc;

*/
  SELECT so.deal_history_months,
             TO_CHAR(p.vdate, 'YYYYMMDD')
        FROM system_options so,
             period p;

-- Purge

 SELECT d.deal_id
        FROM deal_head d
       WHERE d.type   != 'O'
         AND d.status  = 'A'
         AND MONTHS_BETWEEN(TO_DATE(:ps_vdate, 'YYYYMMDD'), d.close_date) > :pi_deal_hist_months
         AND NOT EXISTS (select 'x'
                           from ordloc_discount
                          where deal_id = d.deal_id)
         AND NOT EXISTS (select 'x'
                           from ordhead_discount
                          where deal_id = d.deal_id)
         AND (billing_type                                 != 'BBVFP'
              OR (PM_API_SQL.DEAL_PROMO_EXISTS(deal_id) = 'N'))
    ORDER BY deal_id;
    
-- Close
  SELECT dh.deal_id,
             '20190127'
        FROM deal_head dh
          WHERE dh.type != 'O'
         AND dh.status = 'A'
         AND ((dh.billing_type = 'OI'                              --Off Invoice close on close date
               AND dh.close_date <= to_date('20190127','YYYYMMDD'))
                OR (dh.invoice_processing_logic = 'NO' 
                    --Deal with NO inovice will be closed after the final reporting period.
                    AND dh.close_date <= to_date('20190127','YYYYMMDD')
                    AND (SELECT max(reporting_date) 
                    FROM deal_actuals_forecast vdaf 
                    WHERE vdaf.deal_id=dh.deal_id)<= to_date('20190127','YYYYMMDD'))  --Deal with NO inovice will be closed after the final reporting period.
                OR (dh.billing_type != 'OI'                        --bill back close on/after month close
                    AND dh.est_next_invoice_date IS NULL
                    AND dh.invoice_processing_logic != 'NO'))
    ORDER BY dh.deal_id;
    
    


set serveroutput on;
set timing on;

 DECLARE

o_deal_id rms.DEAL_HEAD.deal_id%type;
n_deal_id rms.DEAL_HEAD.deal_id%type;


cursor C_deal_seq is
select rms.deal_sequence.nextval deal_id
from dual; 

    cursor c1 is
   select distinct deal_id from rms.deal_head where deal_id between 60018  and 60022;
    --''735010001'   number(6);

    cursor c2(P_deal_id rms.deal_head.deal_id%type) is
      select distinct deal_id from rms.deal_detail where deal_id =p_deal_id;
	
	cursor c3(P_deal_id rms.deal_threshold.deal_id%type)   is
		select distinct deal_id from rms.deal_threshold where deal_id =p_deal_id;
	
	cursor c4(P_deal_id rms.DEAL_ITEMLOC_DCS.deal_id%type)   is
		select distinct deal_id from rms.DEAL_ITEMLOC_DCS where deal_id =p_deal_id;

  cursor c5(P_deal_id rms.deal_item_loc_explode.deal_id%type)   is
		select distinct deal_id from rms.deal_item_loc_explode where deal_id =p_deal_id;

  cursor c6(P_deal_id rms.deal_actuals_forecast.deal_id%type)   is
		select distinct deal_id  from rms.deal_actuals_forecast  where deal_id=P_deal_id;
   

BEGIN
dbms_output.put_line('begin'||SYSTIMESTAMP);
for k in 0..4 loop
for i in c1 loop 

 select rms.deal_sequence.nextval into n_deal_id from dual;
 o_deal_id:=i.deal_id;
 
dbms_output.put_line('Old deal: '||o_deal_id);
dbms_output.put_line('New deal: '||n_deal_id);

  insert INTO rms.deal_head				 (     deal_id                      , 
											partner_type                 , 
											partner_id                   , 
											supplier                     , 
											type                         , 
											status                       , 
											currency_code                , 
											active_date                  , 
											close_date                   , 
											close_id                     , 
											create_datetime              , 
											create_id                    , 
											approval_date                , 
											approval_id                  , 
											reject_date                  , 
											reject_id                    , 
											ext_ref_no                   , 
											order_no                     , 
											recalc_approved_orders       , 
											comments                     , 
											last_update_id               , 
											last_update_datetime         , 
											billing_type                 , 
											bill_back_period             , 
											deal_appl_timing             , 
											threshold_limit_type         , 
											threshold_limit_uom          , 
											rebate_ind                   , 
											rebate_calc_type             , 
											growth_rebate_ind            , 
											historical_comp_start_date   , 
											historical_comp_end_date     , 
											rebate_purch_sales_ind       , 
											deal_reporting_level         , 
											bill_back_method             , 
											deal_income_calculation      , 
											invoice_processing_logic     , 
											stock_ledger_ind             , 
											include_vat_ind              , 
											billing_partner_type         , 
											billing_partner_id           , 
											billing_supplier_id          , 
											growth_rate_to_date          , 
											turnover_to_date             , 
											actual_monies_earned_to_date , 
											security_ind                 , 
											est_next_invoice_date        , 
											last_invoice_date            , 
											track_pack_level_ind         , 
											bbd_add_rep_days             , 
											rpm_deal_ind                 )           

									select  distinct n_deal_id           , 
											partner_type                 , 
											partner_id                   , 
											supplier                     , 
											type                         , 
											'A'                       , 
											currency_code                , 
											add_months(rms.DEAL_HEAD.ACTIVE_DATE,-26),
											add_months(rms.DEAL_HEAD.close_DATE,-26),
											close_id                     , 
											create_datetime              , 
											create_id                    , 
											approval_date                , 
											approval_id                  , 
											reject_date                  , 
											reject_id                    , 
											ext_ref_no                   , 
											order_no                     , 
											recalc_approved_orders       , 
											comments                     , 
											last_update_id               , 
											last_update_datetime         , 
											billing_type                 , 
											bill_back_period             , 
											deal_appl_timing             , 
											threshold_limit_type         , 
											threshold_limit_uom          , 
											rebate_ind                   , 
											rebate_calc_type             , 
											growth_rebate_ind            , 
											historical_comp_start_date   , 
											historical_comp_end_date     , 
											rebate_purch_sales_ind       , 
											deal_reporting_level         , 
											bill_back_method             , 
											deal_income_calculation      , 
											invoice_processing_logic     , 
											stock_ledger_ind             , 
											include_vat_ind              , 
											billing_partner_type         , 
											billing_partner_id           , 
											billing_supplier_id          , 
											growth_rate_to_date          , 
											turnover_to_date             , 
											actual_monies_earned_to_date , 
											security_ind                 , 
											null as est_next_invoice_date        , 
											last_invoice_date            , 
											track_pack_level_ind         , 
											bbd_add_rep_days             , 
											rpm_deal_ind                 
                                    from rms.deal_head where deal_id = o_deal_id;
  
 --dbms_output.put_line('insert INTO dd'||SYSTIMESTAMP);                                   
 
 for j in c2(o_deal_id) loop 
 
    o_deal_id:=j.deal_id;
    
			insert INTO rms.deal_detail	(   deal_id                       ,
											deal_detail_id                ,
											deal_comp_type                ,
											application_order             ,
											collect_start_date            ,
											collect_end_date              ,
											cost_appl_ind                 ,
											price_cost_appl_ind           ,
											deal_class                    ,
											threshold_value_type          ,
											qty_thresh_buy_item           ,
											qty_thresh_get_type           ,
											qty_thresh_get_value          ,
											qty_thresh_buy_qty            ,
											qty_thresh_recur_ind          ,
											qty_thresh_buy_target         ,
											qty_thresh_buy_avg_loc        ,
											qty_thresh_get_item           ,
											qty_thresh_get_qty            ,
											qty_thresh_free_item_unit_cost,
											tran_discount_ind             ,
											current_comp_start_date       ,
											current_comp_end_date         ,
											comments                      ,
											create_datetime               ,
											last_update_id                ,
											last_update_datetime          ,
											calc_to_zero_ind              ,
											total_forecast_units          ,
											total_forecast_revenue        ,
											total_budget_turnover         ,
											vfp_default_contrib_pct       ,
											total_baseline_growth_budget  ,
											total_baseline_growth_act_for ,
											total_budget_fixed_ind        ,
											total_actual_fixed_ind        ,
											total_actual_forecast_turnover,
											actual_monies_earned_to_date  ,
											growth_rate_to_date           ,
											turnover_to_date              ,
											get_free_discount              )           
    select                                  distinct n_deal_id            ,
											deal_detail_id                ,
											deal_comp_type                ,
											application_order             ,
										add_months(rms.deal_detail.collect_start_date,-26),
										add_months(rms.deal_detail.collect_end_date,-26),
											cost_appl_ind                 ,
											price_cost_appl_ind           ,
											deal_class                    ,
											threshold_value_type          ,
											qty_thresh_buy_item           ,
											qty_thresh_get_type           ,
											qty_thresh_get_value          ,
											qty_thresh_buy_qty            ,
											qty_thresh_recur_ind          ,
											qty_thresh_buy_target         ,
											qty_thresh_buy_avg_loc        ,
											qty_thresh_get_item           ,
											qty_thresh_get_qty            ,
											qty_thresh_free_item_unit_cost,
											tran_discount_ind             ,
											current_comp_start_date       ,
											current_comp_end_date         ,
											comments                      ,
											create_datetime               ,
											last_update_id                ,
											last_update_datetime          ,
											calc_to_zero_ind              ,
											total_forecast_units          ,
											total_forecast_revenue        ,
											total_budget_turnover         ,
											vfp_default_contrib_pct       ,
											total_baseline_growth_budget  ,
											total_baseline_growth_act_for ,
											total_budget_fixed_ind        ,
											total_actual_fixed_ind        ,
											total_actual_forecast_turnover,
											actual_monies_earned_to_date  ,
											growth_rate_to_date           ,
											turnover_to_date              ,
											get_free_discount             
                                       from  rms.deal_detail where deal_id=o_deal_id;    
    
   -- dbms_output.put_line('insert INTO iexpl'||SYSTIMESTAMP);  
   
   for x in c3 (o_deal_id) loop
   o_deal_id:=x.deal_id;
   insert into rms.deal_threshold(	DEAL_ID              ,  
									DEAL_DETAIL_ID       ,  
									LOWER_LIMIT          ,  
									UPPER_LIMIT          ,  
									VALUE                ,  
									TARGET_LEVEL_IND     ,  
									CREATE_DATETIME      ,  
									LAST_UPDATE_ID       ,  
									LAST_UPDATE_DATETIME ,  
									TOTAL_IND            ,  
									REASON               )
							select 	n_DEAL_ID              ,  
									DEAL_DETAIL_ID       ,  
									LOWER_LIMIT          ,  
									UPPER_LIMIT          ,  
									VALUE                ,  
									TARGET_LEVEL_IND     ,  
									CREATE_DATETIME      ,  
									LAST_UPDATE_ID       ,  
									LAST_UPDATE_DATETIME ,  
									TOTAL_IND            ,  
									REASON              		
							from  rms.deal_threshold where deal_id=o_deal_id; 		   

		for n in c4 (o_deal_id) loop
			   o_deal_id:=n.deal_id;
			   insert into rms.DEAL_ITEMLOC_DCS(DEAL_ID              ,  
										deal_detail_id       ,  
										seq_no               ,  
										merch_level          ,  
										division             ,  
										group_no             ,  
										dept                 ,  
										class                ,  
										subclass             ,  
										org_level            ,  
										chain                ,  
										area                 ,  
										region               ,  
										district             ,  
										location             ,  
										origin_country_id    ,  
										loc_type             ,  
										excl_ind             ,  
										create_datetime      ,  
										last_update_id       , 
										last_update_datetime ,  
										active_ind           )  
								select		n_DEAL_ID              ,  
										deal_detail_id       ,  
										seq_no               ,  
										merch_level          ,  
										division             ,  
										group_no             ,  
										dept                 ,  
										class                ,  
										subclass             ,  
										org_level            ,  
										chain                ,  
										area                 ,  
										region               ,  
										district             ,  
										location             ,  
										origin_country_id    ,  
										loc_type             ,  
										excl_ind             ,  
										create_datetime      ,  
										last_update_id       , 
										last_update_datetime ,  
										active_ind             		
							from  rms.DEAL_ITEMLOC_DCS where deal_id=o_deal_id;
  
  for k in c5(o_deal_id) loop  
		o_deal_id:=k.deal_id;

				insert INTO rms.deal_item_loc_explode (   item
												, supplier
												, origin_country_id
												, location
												, loc_type
												, deal_id
												, deal_detail_id
												, active_date
												, close_date
												, cost_appl_ind
												, price_cost_appl_ind
												, deal_class
												, threshold_value_type
												, qty_thresh_buy_item
												, qty_thresh_get_type
												, qty_thresh_get_value
												, qty_thresh_buy_qty
												, qty_thresh_recur_ind
												, qty_thresh_buy_target
												, qty_thresh_buy_avg_loc
												, qty_thresh_get_item
												, qty_thresh_get_qty
												, qty_thresh_free_item_unit_cost
												, setup_merch_level
												, setup_division
												, setup_group_no
												, setup_dept
												, setup_class
												, setup_subclass
												, setup_item_parent
												, setup_item_grandparent
												, setup_diff_1
												, setup_diff_2
												, setup_diff_3
												, setup_diff_4
												, setup_org_level
												, setup_chain
												, setup_area
												, setup_region
												, setup_district
												, setup_location
												, deal_head_type
												, partner_type
												, partner_id
												, create_datetime
												, deal_detail_application_order
												, get_free_discount )           
                        
						select          item
										, supplier
										, origin_country_id
										, location
										, loc_type
										, n_deal_id
										, deal_detail_id
										, add_months(rms.deal_item_loc_explode.ACTIVE_DATE,-26)
                                        , add_months(rms.deal_item_loc_explode.close_DATE,-26)
										, cost_appl_ind
										, price_cost_appl_ind
										, deal_class
										, threshold_value_type
										, qty_thresh_buy_item
										, qty_thresh_get_type
										, qty_thresh_get_value
										, qty_thresh_buy_qty
										, qty_thresh_recur_ind
										, qty_thresh_buy_target
										, qty_thresh_buy_avg_loc
										, qty_thresh_get_item
										, qty_thresh_get_qty
										, qty_thresh_free_item_unit_cost
										, setup_merch_level
										, setup_division
										, setup_group_no
										, setup_dept
										, setup_class
										, setup_subclass
										, setup_item_parent
										, setup_item_grandparent
										, setup_diff_1
										, setup_diff_2
										, setup_diff_3
										, setup_diff_4
										, setup_org_level
										, setup_chain
										, setup_area
										, setup_region
										, setup_district
										, setup_location
										, deal_head_type
										, partner_type
										, partner_id
										, create_datetime
										, deal_detail_application_order
										, get_free_discount
                        from rms.deal_item_loc_explode where deal_id=o_deal_id;
				end loop;
--dbms_output.put_line('insert INTO daf'||SYSTIMESTAMP);                        

for p in 7..7 loop

for d in c6(o_deal_id) loop  

		o_deal_id:=d.deal_id;

		insert into rms.deal_actuals_forecast  ( deal_id                      ,
											deal_detail_id                ,
											reporting_date               ,
											actual_forecast_ind           ,
											baseline_turnover             ,
											budget_turnover               ,
											budget_income                 ,
											actual_forecast_turnover      ,
											actual_forecast_income        ,
											actual_forecast_trend_turnover,
											actual_forecast_trend_income  )
                                    select   n_deal_id,                    
                                             deal_detail_id                ,
                                             add_months(rms.DEAL_ACTUALS_FORECAST.reporting_DATE,-26)+p ,
											 actual_forecast_ind           ,
											 baseline_turnover             ,
											 budget_turnover               ,
											 budget_income                 ,
											 actual_forecast_turnover      ,
											 actual_forecast_income        ,
											 actual_forecast_trend_turnover,
											 actual_forecast_trend_income
                               from   rms.deal_actuals_forecast where deal_id=o_deal_id;
                                  
     
                            end loop;
                       end loop;
              end loop;
           
            end loop; 
end loop;--new t
end loop;--new t			
      o_deal_id:=null;    
      n_deal_id:=null;
end loop;--new t			

EXCEPTION

when OTHERS THEN

  dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);

  ROLLBACK;

END;

/

 