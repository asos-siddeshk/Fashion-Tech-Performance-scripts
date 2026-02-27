    with zone_locs as (select zone_id,
                              count(1) count_locs 
                         from rpm_zone_location 
                        group by zone_id)
    select nvl((select sum(count_explode_locs)
                  from (select stage_price_change_id,
                               message_seq,
                               message_type,
                               case 
                                 when p.location is null then
                                   (select count_locs
                                      from zone_locs
                                     where zone_id = p.zone_id) 
                                  else
                                    1
                                end count_explode_locs,
                               nvl(LAG (message_type,1) OVER (PARTITION BY stage_price_change_id,zone_id,location,item ORDER BY message_seq),'N') previous_message_type,
                               nvl(LEAD (message_type,1) OVER (PARTITION BY stage_price_change_id,zone_id,location,item ORDER BY message_seq),'N') next_message_type
                          from ma_asos.ma_stage_price_change p
                         where status = 'N')--'N'
                 where ((message_type = 'A' and next_message_type != 'D') or 
                        (message_type = 'D' and previous_message_type != 'A') or( message_type = 'W') )),0) count_price_change,
           nvl((select sum(count_explode_locs)
                  from (select stage_clearance_id,
                               message_seq,
                               message_type,
                                case 
                                 when c.location is null then
                                   (select count_locs
                                      from zone_locs
                                     where zone_id = c.zone_id) 
                                  else
                                    1
                                end count_explode_locs,
                               nvl(LAG (message_type,1) OVER (PARTITION BY stage_clearance_id,zone_id,location,item ORDER BY message_seq),'N') previous_message_type,
                               nvl(LEAD (message_type,1) OVER (PARTITION BY stage_clearance_id,zone_id,location,item ORDER BY message_seq),'N') next_message_type
                          from ma_asos.ma_stage_clearance c
                         where status = 'N')
                 where ((message_type = 'A' and next_message_type != 'D') or 
                        (message_type = 'D' and previous_message_type != 'A'))),0) count_clearance,
           nvl((select sum(count_explode_locs)
                  from (select stage_simple_promo_id,
                               message_seq,
                               message_type,
                               case 
                                 when sp.location is null then
                                   (select count_locs
                                      from zone_locs
                                     where zone_id = sp.zone_id) 
                                  else
                                    1
                                end count_explode_locs,
                               nvl(LAG (message_type,1) OVER (PARTITION BY stage_simple_promo_id,zone_id,location,item ORDER BY message_seq),'N') previous_message_type,
                               nvl(LEAD (message_type,1) OVER (PARTITION BY stage_simple_promo_id,zone_id,location,item ORDER BY message_seq),'N') next_message_type
                          from ma_asos.ma_stage_simple_promo sp
                          where status = 'N')--'N'
                 where ((message_type = 'A' and next_message_type != 'D') or 
                        (message_type = 'D' and previous_message_type != 'A') or message_type = 'U')),0) count_simple_promo,
           0 count_complex_promo
      from dual;


    select greatest(nvl(price_change_locs,0),nvl(clearance_locs,0),nvl(simple_promo_locs,0),nvl(complex_promo_locs,0)) max_locs,
           least(nvl(price_change_locs,9999999),nvl(clearance_locs,99999999),nvl(simple_promo_locs,99999999),nvl(complex_promo_locs,99999999)) max_locs_runtime,
           tbl.max_increase_percentage,
           case 
             when 'PC' = 'PC' then
               '125405' + '31350' + '0'
           end count_other_promos    
      from (select m.*,
                   nvl2(price_change_locs,'Y','N') price_change_exist, 
                   nvl2(clearance_locs,'Y','N') clearance_exist, 
                   nvl2(simple_promo_locs,'Y','N') simple_promo_exist, 
                   nvl2(complex_promo_locs,'Y','N') complex_promo_exist
              from ma_asos.ma_price_event_balance_matrix m
             where event_type = 'PC'
            )tbl
      where tbl.price_change_exist = (case when '9890' > 0 then 'Y' else 'N' end) 
        and tbl.clearance_exist = (case when '125405' > 0 then 'Y' else 'N' end)
        and tbl.simple_promo_exist = (case when '31350' > 0 then 'Y' else 'N' end)
        and tbl.complex_promo_exist = (case when '0' > 0 then 'Y' else 'N' end); 

select * from ma_asos.ma_price_event_balance_matrix;

    select tbl.stage_price_change_id, 
                                   tbl.stage_process_id, 
                                   tbl.message_seq, 
                                   tbl.message_type, 
                                   tbl.reason_code, 
                                   tbl.item, 
                                   tbl.diff_id, 
                                   tbl.zone_id, 
                                   tbl.location, 
                                   tbl.zone_node_type, 
                                   tbl.link_code, 
                                   trunc(tbl.effective_date), 
                                   tbl.change_type, 
                                   tbl.change_amount, 
                                   tbl.change_currency, 
                                   tbl.change_percent, 
                                   tbl.change_selling_uom, 
                                   tbl.null_multi_ind, 
                                   tbl.multi_units, 
                                   tbl.multi_unit_retail, 
                                   tbl.multi_selling_uom, 
                                   tbl.price_guide_id, 
                                   tbl.ignore_constraints, 
                                   tbl.auto_approve_ind, 
                                   tbl.status, 
                                   tbl.error_message, 
                                   tbl.process_id, 
                                   tbl.price_change_id, 
                                   tbl.price_change_display_id, 
                                   tbl.skulist, 
                                   tbl.thread_num, 
                                   tbl.exclusion_created, 
                                   tbl.vendor_funded_ind, 
                                   tbl.funding_type, 
                                   tbl.funding_amount, 
                                   tbl.funding_amount_currency, 
                                   tbl.funding_percent, 
                                   tbl.deal_id, 
                                   tbl.deal_detail_id, 
                                   tbl.zone_group_id, 
                                   tbl.stage_cust_attr_id, 
                                   tbl.cust_attr_id,
                                   tbl.explode_weight_value, 
                                   tbl.create_datetime, 
                                   tbl.last_update_datetime, 
                                   tbl.create_id, 
                                   tbl.last_update_id
      from (select tbl.*,
                   sum(tbl.explode_weight_value) over (order by tbl.line) line_locs_accumulator
              from (with zone_locs as (select zone_id,
                                              count(1) count_locs 
                                         from rms.rpm_zone_location 
                                        group by zone_id)
                    select tbl.*,
                           rownum line
                      from (select p.*,
                                   case 
                                     when p.explode_weight is not null then
                                       p.explode_weight
                                     when p.location is not null then 1
                                        else
                                            (select count_locs from zone_locs where zone_id = p.zone_id)
                                   end explode_weight_value
                              from (select * from ma_asos.ma_stage_price_change 
                                     where status = 'N') p
                            order by case 
                                       when trunc(p.effective_date) <= trunc(GET_VDATE + 1) then p.effective_date 
                                       else null end,
                                     p.stage_price_change_id,p.message_seq) tbl) tbl
              order by line
           )tbl
     where ((trunc(tbl.effective_date) <= trunc(rms.GET_VDATE + 1)) or -- vdate
             line_locs_accumulator <= 500);


