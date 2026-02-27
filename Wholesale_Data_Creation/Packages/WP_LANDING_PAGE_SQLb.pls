create or replace package body wp_landing_page_sql as
--------------------------------------------------------------------------------------------------------------------------------
function sales_order_release_chart (O_error_message            out varchar2,
                                    O_wp_sor_partners_tbl      out wp_lp_chart_tbl)
return boolean is
  --
  L_program             varchar2(250) := 'WP_LANDING_PAGE_SQL.SALES_ORDER_RELEASE_CHART';
  L_wp_chart_tbl        wp_lp_chart_tbl;
  L_source_loc          varchar2(250);
  L_others              wp_lp_chart_tbl;
  --
  cursor C_get_partner_by_loc is
  select new wp_lp_chart_obj ( source_loc => p.source_loc,
                               info_desc  => p.customer_name,
                               info_qty   => p.current_qty)
    from wp_v_so_release_partners p,
         wp_dashboard_detail d
where d.dashboard_id  = 'SOR'
  and p.customer_name = d.series_desc;
  --
  cursor C_get_partner_by_loc_others is
  select new wp_lp_chart_obj ( source_loc => s.source_loc,
                               info_desc  => 'Others',
                               info_qty   => sum(s.current_qty))
    from wp_v_so_release_partners s
   where s.customer_name not in  (select p.series_desc
                                    from wp_dashboard_detail p
                                   where p.dashboard_id  = 'SOR'
                                   )
   group by s.source_loc;
  --
begin
  --
  open  C_get_partner_by_loc;
  fetch C_get_partner_by_loc bulk collect into L_wp_chart_tbl;
  close C_get_partner_by_loc;
  --
  open  C_get_partner_by_loc_others;
  fetch C_get_partner_by_loc_others bulk collect into L_others;
  close C_get_partner_by_loc_others;
  --
  if L_others is not null then
    for i in 1..L_others.count loop
      --
      L_wp_chart_tbl.extend();
      L_wp_chart_tbl(L_wp_chart_tbl.last) := L_others(i);
      --
    end loop;
    --
  end if;
  O_wp_sor_partners_tbl := L_wp_chart_tbl;
  --
  return true;
  --
exception
  --
  when OTHERS then
  --
  O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                            I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                            I_program_name    => L_program,
                                            I_error_key       => 'ERROR_SALES_ORDER_RELEASE_CHART',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end sales_order_release_chart;
--------------------------------------------------------------------------------------------------------------------------------
function unproductive_stock_chart (O_error_message       out varchar2,
                                    O_wp_up_item_tbl     out wp_lp_chart_tbl)
return boolean is
  --
  L_program                varchar2(250) := 'WP_LANDING_PAGE_SQL.UNPRODUCTIVE_STOCK_CHART';
  L_wp_business_model_tbl  wp_lp_chart_tbl;
  L_others                 wp_lp_chart_tbl;
  --
  cursor C_get_division_brand_by_loc is
   select new wp_lp_chart_obj(source_loc => i.source_loc,
                              info_desc   => i.business_model_name,
                              info_qty    => i.unproductive_stock_qty)
    from wp_v_unproductive_stock_item i
   where exists (select 1
                   from wp_dashboard_detail d
                  where series_desc = i.business_model_name
                    and d.dashboard_id  = 'UP');
  --
  cursor C_get_division_brand_others is
  select new wp_lp_chart_obj(source_loc => s.source_loc,
                             info_desc  => 'Others',
                             info_qty   => sum(s.unproductive_stock_qty))
    from wp_v_unproductive_stock_item s
   where s.business_model_name not in (select d.series_desc
                                         from wp_dashboard_detail d
                                        where d.dashboard_id  = 'UP')
  group by s.source_loc;
  --
begin
  --
  open  C_get_division_brand_by_loc;
  fetch C_get_division_brand_by_loc bulk collect into L_wp_business_model_tbl;
  close C_get_division_brand_by_loc;
  --
  open  C_get_division_brand_others;
  fetch C_get_division_brand_others bulk collect into L_others;
  close C_get_division_brand_others;
  --
  if L_others is not null then
    --
    for i in 1..L_others.count loop
      --
      L_wp_business_model_tbl.extend();
      L_wp_business_model_tbl(L_wp_business_model_tbl.last) := L_others(i);
      --
    end loop;
    --
  end if;
  --
  O_wp_up_item_tbl := L_wp_business_model_tbl;
  --
  return true;
  --
exception
  --
  when OTHERS then
  --
  O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                            I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                            I_program_name    => L_program,
                                            I_error_key       => 'ERROR_UNPRODUCTIVE_STOCK_CHART',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end unproductive_stock_chart;
--------------------------------------------------------------------------------------------------------------------------------
function get_dashboards(O_error_message      out varchar2,
                        O_dashboard_tbl      out wp_dashboard_head_tbl)
return boolean is
  --
  L_program              varchar2(64) := 'WP_LANDING_PAGE_SQL.GET_DASHBOARDS';
  L_dashboard_tbl        wp_dashboard_head_tbl;
  L_dashboard_detail_tbl wp_dashboard_detail_tbl;
  L_dashboard_id         varchar2(5);
  L_date                 varchar2(25) := GLOBAL_VARS_SQL.G_wp_full_date;
  L_wp_chart_tbl         wp_lp_chart_tbl;
  --
  cursor C_get_dashboard_detail is
  select new wp_dashboard_detail_obj(dash_value     => dl.dash_value,
                                     dash_dtl_id    => dl.dash_dtl_id,
                                     series_id      => dl.series_id,
                                     series_desc    => dl.series_desc,
                                     colour         => dl.colour,
                                     dash_dtl_group => dl.dash_dtl_group)
    from wp_dashboard_detail dl
   where dl.dashboard_id = L_dashboard_id;
  --
  cursor C_get_dashboard_type is
  select new wp_dashboard_head_obj(dashboard_id      => dh.dashboard_id,
                                   dashboard_desc    => dh.dashboard_desc,
                                   last_refresh_date => TO_CHAR(dh.last_refresh_date, L_date),
                                   dashboard_dtl     => null)
    from wp_dashboard_head dh;
  --
  cursor C_get_dash_dtl_chart is
  select new wp_dashboard_detail_obj(dash_value     => c.info_qty,
                                     dash_dtl_id    => dl.dash_dtl_id,
                                     series_id      => dl.series_id,
                                     series_desc    => dl.series_desc,
                                     colour         => dl.colour,
                                     dash_dtl_group => c.source_loc)
    from wp_dashboard_detail dl,
         table(L_wp_chart_tbl) c
   where dl.dashboard_id = L_dashboard_id
     and c.info_desc     = dl.series_desc
   order by dl.dash_dtl_id;
begin
  --
  open C_get_dashboard_type;
  fetch C_get_dashboard_type bulk collect into L_dashboard_tbl;
  close C_get_dashboard_type;
  --
  for i in 1..L_dashboard_tbl.count loop
    --
    L_dashboard_id := L_dashboard_tbl(i).dashboard_id;
    --
    if L_dashboard_id = 'SOR' then
      --
      if (sales_order_release_chart(O_error_message       => O_error_message,
                                    O_wp_sor_partners_tbl => L_wp_chart_tbl)) = false then
        --
        return false;
        --
      end if;
      --
      open C_get_dash_dtl_chart;
      fetch C_get_dash_dtl_chart bulk collect into L_dashboard_detail_tbl;
      close C_get_dash_dtl_chart;
      --
      L_dashboard_tbl(i).dashboard_dtl := L_dashboard_detail_tbl;
      --
    elsif L_dashboard_id = 'UP' then
      --
      if (unproductive_stock_chart(O_error_message  => O_error_message,
                                   O_wp_up_item_tbl => L_wp_chart_tbl)) = false then
        --
        return false;
        --
      end if;
      --
      open C_get_dash_dtl_chart;
      fetch C_get_dash_dtl_chart bulk collect into L_dashboard_detail_tbl;
      close C_get_dash_dtl_chart;
      --
      L_dashboard_tbl(i).dashboard_dtl := L_dashboard_detail_tbl;
      --
    else
      --
      open C_get_dashboard_detail;
      fetch C_get_dashboard_detail bulk collect into L_dashboard_detail_tbl;
      close C_get_dashboard_detail;
      --
      L_dashboard_tbl(i).dashboard_dtl := L_dashboard_detail_tbl;
      --
    end if;
    --
  end loop;
  --
  O_dashboard_tbl := L_dashboard_tbl;
  --
  return true;
  --
exception
  --
  when others then
    --
    o_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                            I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                            I_program_name    => L_program,
                                            I_error_key       => 'ERROR_GET_DASHBOARDS',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end get_dashboards;
--------------------------------------------------------------------------------------------------------------------------------
end wp_landing_page_sql;
/