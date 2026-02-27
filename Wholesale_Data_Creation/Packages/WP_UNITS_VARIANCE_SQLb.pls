create or replace package body wp_units_variance_sql as
--------------------------------------------------------------------------------
function sales_order_head_search (O_error_message       out varchar2,
                                  O_wpSalesOrderHeadTbl out wpSalesOrderHeadTbl,
                                  I_sales_order_no      in  wp_order_head.sales_order_no%type default null,
                                  I_order_no            in  wp_order_head.order_no%type default null,
                                  I_order_row_code      in  wp_order_head.order_row_code%type default null,
                                  I_qty_variance        in  number default null,
                                  I_customer_id         in  wf_customer.wf_customer_id%type default null,
                                  I_customer_loc        in  store.store%type default null,
                                  I_option_id           in  wp_order_detail.item%type default null,
                                  I_despatch_month      in  varchar2 default null,
                                  I_current_start_date  in  varchar2 default null,
                                  I_current_end_date    in  varchar2 default null,
                                  I_carrier_booking     in  varchar2 default null,
                                  I_business_model      in  number   default null)
 return boolean is
  --
  L_program             varchar2(250) := 'WP_UNITS_VARIANCE_SQL.SALES_ORDER_HEAD_SEARCH';
  L_string_query        varchar2(20000);
  L_wpSalesOrderHeadTbl wpSalesOrderHeadTbl;
  L_sys_refcur          sys_refcursor;
  L_date                varchar2(25) := GLOBAL_VARS_SQL.G_wp_date;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no,
                              :2  bv_order_no,
                              :3  bv_order_row_code,
                              :4  bv_qty_variance,
                              :5  bv_customer_id,
                              :6  bv_customer_loc,
                              :7  bv_option_id,
                              :8  bv_despatch_month,
							                :9  bv_current_start_date,
                              :10 bv_current_end_date,
                              :11 bv_carrier_booking,
                              :12 bv_business_model
                         from dual)
                      select new wpSalesOrderHeadObj(order_no,
                                                     order_row_code,
                                                     first_dest,
                                                     final_dest,
                                                     first_dest_desc,
                                                     final_dest_desc,
                                                     to_char(first_dest_date, '}'|| L_date || q'{'),
                                                     to_char(final_dest_date, '}'|| L_date || q'{'),
                                                     qty_ordered,
                                                     qty_cancelled,
                                                     qty_total,
                                                     qty_variance)
                         from wp_units_variance_head wpuv,
                              t_binds b
                        where exists (select 1
                                        from wp_units_variance_ca_dtl ca
                                      where ca.order_no   = wpuv.order_no
                                        and ca.first_dest = wpuv.first_dest
                                        and ca.final_dest = wpuv.final_dest
                                        and ca.qty_variance_sku != 0) }';
  --
  /*********sales order header filters***********/
  --
  --order no
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and wpuv.order_no = b.bv_order_no
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and wpuv.order_row_code = b.bv_order_row_code
                                          }';
    --
  end if;
  --
  --variance
  --
  if I_qty_variance is not null and I_qty_variance > 0 then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_ca_dtl ca
                                                         where ca.order_no       = wpuv.order_no
                                                           and ca.first_dest     = wpuv.first_dest
                                                           and ca.final_dest     = wpuv.final_dest
                                                           and ca.qty_variance_sku >= b.bv_qty_variance)
                                         }';
    --
  elsif I_qty_variance is not null then
    --
     L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_ca_dtl ca
                                                         where ca.order_no       = wpuv.order_no
                                                           and ca.first_dest     = wpuv.first_dest
                                                           and ca.final_dest     = wpuv.final_dest
                                                           and ca.qty_variance_sku <= b.bv_qty_variance)
                                         }';
    --
  end if;
  --
  if I_carrier_booking is not null then
    --
    L_string_query := L_string_query || q'{ and wpuv.carrier_booking = b.bv_carrier_booking
                                          }';
    --
  end if;
  --
  /*************sales order detail filters**************/
  --
  --sales order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no       = wpuv.order_no
                                                           and wpd.first_dest     = wpuv.first_dest
                                                           and wpd.final_dest     = wpuv.final_dest
                                                           and wpd.sales_order_no = b.bv_sales_order_no)
                                          }';
    --
  end if;
  --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no       = wpuv.order_no
                                                           and wpd.first_dest     = wpuv.first_dest
                                                           and wpd.final_dest     = wpuv.final_dest
                                                           and wpd.option_id      = b.bv_option_id)
                                          }';
    --
  end if;
  --
  --customer_loc = partner loc
  --
  if I_customer_loc is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no            = wpuv.order_no
                                                           and wpd.first_dest          = wpuv.first_dest
                                                           and wpd.final_dest          = wpuv.final_dest
                                                           and wpd.customer_loc        = b.bv_customer_loc)
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no         = wpuv.order_no
                                                           and wpd.first_dest       = wpuv.first_dest
                                                           and wpd.final_dest       = wpuv.final_dest
                                                           and wpd.customer_id      = b.bv_customer_id)
                                          }';
    --
  end if;
  --
  --sales order delivery start and end dates
  --
  if I_current_start_date is not null and I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no           = wpuv.order_no
                                                           and wpd.first_dest         = wpuv.first_dest
                                                           and wpd.final_dest         = wpuv.final_dest
                                                           and to_char(wpd.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                                           and to_char(wpd.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date)
                                          }';
    --
  elsif I_current_start_date is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no           = wpuv.order_no
                                                           and wpd.first_dest         = wpuv.first_dest
                                                           and wpd.final_dest         = wpuv.final_dest
                                                           and to_char(wpd.current_start_date, '}'|| L_date || q'{')>= b.bv_current_start_date)
                                          }';
    --
  elsif I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no           = wpuv.order_no
                                                           and wpd.first_dest         = wpuv.first_dest
                                                           and wpd.final_dest         = wpuv.final_dest
                                                           and to_char(wpd.current_end_date, '}'|| L_date || q'{')<= b.bv_current_end_date)
                                          }';
    --
  end if;
  --
  --despatch month
  --
  if I_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no               = wpuv.order_no
                                                           and wpd.first_dest             = wpuv.first_dest
                                                           and wpd.final_dest             = wpuv.final_dest
                                                           and wpd.current_despatch_month = b.bv_despatch_month)
                                          }';
    --
  end if;
  --
  --business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_dtl wpd
                                                         where wpd.order_no               = wpuv.order_no
                                                           and wpd.first_dest             = wpuv.first_dest
                                                           and wpd.final_dest             = wpuv.final_dest
                                                           and wpd.business_model         = b.bv_business_model)
                                          }';
    --
  end if;
  --
  --dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_order_row_code,
                                                I_qty_variance,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_option_id,
                                                I_despatch_month,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_carrier_booking,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wpSalesOrderHeadTbl;
  close L_sys_refcur;
  --
  O_wpSalesOrderHeadTbl := L_wpSalesOrderHeadTbl;
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
                                            I_error_key       => 'ERROR_SALES_ORDER_HEAD_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end sales_order_head_search;
--------------------------------------------------------------------------------
function sales_order_dtl_search (O_error_message         out varchar2,
                                 O_wpSalesOrderDetailTbl out wpSalesOrderDetailTbl,
                                 I_order_no              in  wp_order_head.order_no%type,
                                 I_first_dest            in  number,
                                 I_final_dest            in  number,
                                 I_offset                in  number,
                                 I_limit                 in  number)
return boolean is
  --
  L_program               varchar2(250) := 'WP_UNITS_VARIANCE_SQL.SALES_ORDER_DTL_SEARCH';
  L_wpSalesOrderDetailTbl wpSalesOrderDetailTbl;
  --
  cursor C_sales_order_dtl is
  select new wpSalesOrderDetailObj(sales_order_no              => sales_order_no,
                                   option_id                   => option_id,
                                   option_desc                 => option_desc,
                                   customer_loc                => customer_loc,
                                   customer_id                 => customer_id,
                                   customer_loc_name           => customer_loc_name,
                                   customer_name               => customer_name,
                                   current_despatch_month      => current_despatch_month,
                                   cancel_reason               => cancel_reason,
                                   original_qty                => original_qty,
                                   current_qty                 => current_qty)
      from wp_units_variance_dtl
     where order_no   = I_order_no
       and first_dest = I_first_dest
       and final_dest = I_final_dest
     order by sales_order_no, option_id
     OFFSET I_offset rows FETCH NEXT I_limit ROWS ONLY ;
  --
begin
  --
  open  C_sales_order_dtl;
  fetch C_sales_order_dtl bulk collect into L_wpSalesOrderDetailTbl;
  close C_sales_order_dtl;
  --
  O_wpSalesOrderDetailTbl := L_wpSalesOrderDetailTbl;
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
                                            I_error_key       => 'ERROR_SALES_ORDER_DTL_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end sales_order_dtl_search;
--------------------------------------------------------------------------------
function sales_order_CA_dtl_search (O_error_message                out varchar2,
                                    O_wp_units_variance_CA_dtl_tbl out wp_units_variance_CA_dtl_tbl,
                                    I_sales_order_no               in  wp_order_head.sales_order_no%type,
                                    I_customer_id                  in  wp_order_head.customer_id%type,
                                    I_customer_loc                 in  wp_order_detail.customer_loc%type,
                                    I_current_despatch_month       in  varchar2,
                                    I_option_id                    in  wp_order_detail.item%type,
                                    I_final_dest                   in  number)
return boolean is
  --
  L_program                    varchar2(250) := 'WP_UNITS_VARIANCE_SQL.SALES_ORDER_CA_DTL_SEARCH';
  L_wpUnitsVariance_CA_dtl_tbl wp_units_variance_CA_dtl_tbl;
  --
  cursor C_units_variance_CA_dtl is
  select new wp_units_variance_CA_dtl_obj(option_id    => ca.option_id,
                                          sku_size     => ca.size_code,
                                          qty_ordered  => ca.qty_ordered,
                                          current_qty  => ca.current_qty)
     from wp_units_variance_CA_dtl ca
    where ca.sales_order_no         = I_sales_order_no
      and ca.customer_id            = I_customer_id
      and ca.customer_loc           = I_customer_loc
      and ca.current_despatch_month = I_current_despatch_month
      and ca.option_id              = I_option_id
      and ca.final_dest             = I_final_dest;

  --
begin
  --
  open  C_units_variance_CA_dtl;
  fetch C_units_variance_CA_dtl bulk collect into L_wpUnitsVariance_CA_dtl_tbl;
  close C_units_variance_CA_dtl;
  --
  O_wp_units_variance_CA_dtl_tbl := L_wpUnitsVariance_CA_dtl_tbl;
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
                                            I_error_key       => 'ERROR_SALES_ORDER_CA_DTL_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end sales_order_CA_dtl_search;
--------------------------------------------------------------------------------
function sales_order_export  (O_error_message                out varchar2,
                              O_wp_units_variance_export_tbl out wp_units_variance_export_tbl,
                              I_sales_order_no               in  wp_order_head.sales_order_no%type default null,
                              I_order_no                     in wp_order_head.order_no%type default null,
                              I_order_row_code               in wp_order_head.order_row_code%type default null,
                              I_qty_variance                 in number default null,
                              I_customer_id                  in wf_customer.wf_customer_id%type default null,
                              I_customer_loc                 in store.store%type default null,
                              I_option_id                    in wp_order_detail.item%type default null,
                              I_despatch_month               in varchar2 default null,
                              I_current_start_date           in varchar2 default null,
                              I_current_end_date             in varchar2 default null,
                              I_carrier_booking              in varchar2 default null,
                              I_business_model               in number   default null)
return boolean is
  --
  L_program                        varchar2(250) := 'WP_UNITS_VARIANCE_SQL.SALES_ORDER_EXPORT';
  L_string_query                   varchar2(20000);
  L_sys_refcur                     sys_refcursor;
  L_wp_units_variance_export_tbl   wp_units_variance_export_tbl;
  L_date                           varchar2(25) := GLOBAL_VARS_SQL.G_wp_uk_date;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no,
                              :2  bv_order_no,
                              :3  bv_order_row_code,
                              :4  bv_qty_variance,
                              :5  bv_customer_id,
                              :6  bv_customer_loc,
                              :7  bv_option_id,
                              :8  bv_despatch_month,
							                :9  bv_current_start_date,
                              :10 bv_current_end_date,
                              :11 bv_carrier_booking,
                              :12 bv_business_model
                         from dual)
                      select new wp_units_variance_export_obj(order_no,
                                                             order_row_code,
                                                             first_dest_desc,
                                                             final_dest_desc,
                                                             to_char(first_dest_date, '}'|| L_date || q'{'),
                                                             to_char(final_dest_date, '}'|| L_date || q'{'),
                                                             sales_order_no,
                                                             customer_name,
                                                             customer_loc_name,
                                                             current_despatch_month,
                                                             option_id,
                                                             option_desc,
                                                             size_code,
                                                             qty_ordered,
                                                             original_qty,
                                                             current_qty,
                                                             qty_cancelled,
                                                             cancel_reason)
                         from wp_v_units_variance_export expt,
                              t_binds b
                        where exists (select 1
                                        from wp_units_variance_ca_dtl ca
                                       where ca.order_no         = expt.order_no
                                         and ca.first_dest       = expt.first_dest
                                         and ca.final_dest       = expt.final_dest
                                         and ca.qty_variance_sku != 0) }';
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and expt.order_no = b.bv_order_no
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and expt.order_row_code = b.bv_order_row_code
                                          }';
    --
  end if;
  --
  --variance
  --
  if I_qty_variance is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_units_variance_ca_dtl ca
                                                         where ca.order_no         = expt.order_no
                                                           and ca.first_dest       = expt.first_dest
                                                           and ca.final_dest       = expt.final_dest
                                                           and ca.qty_variance_sku >= b.bv_qty_variance)
                                          }';
    --
  end if;
  --
  if I_carrier_booking is not null then
    --
    L_string_query := L_string_query || q'{ and expt.carrier_booking = b.bv_carrier_booking
                                          }';
    --
  end if;
  --
  --sales order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and expt.sales_order_no = b.bv_sales_order_no
                                          }';
    --
  end if;
  --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and expt.option_id = b.bv_option_id
                                          }';
    --
  end if;
  --
  --customer_loc = partner loc
  --
  if I_customer_loc is not null then
    --
    L_string_query := L_string_query || q'{ and expt.customer_loc = b.bv_customer_loc
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and expt.customer_id = b.bv_customer_id
                                          }';
    --
  end if;
  --
  --sales order delivery start and end dates
  --
  if I_current_start_date is not null and I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(expt.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                            and to_char(expt.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date
                                          }';
    --
  elsif I_current_start_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(expt.current_start_date, '}'|| L_date || q'{')>= b.bv_current_start_date
                                          }';
    --
  elsif I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(expt.current_end_date, '}'|| L_date || q'{')<= b.bv_current_end_date
                                          }';
    --
  end if;
  --
  --despatch month
  --
  if I_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and expt.current_despatch_month = b.bv_despatch_month
                                          }';
    --
  end if;
  --
  -- business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and expt.business_model = b.bv_business_model
                                          }';                                     
    --
  end if;
  --dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_order_row_code,
                                                I_qty_variance,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_option_id,
                                                I_despatch_month,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_carrier_booking,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wp_units_variance_export_tbl;
  close L_sys_refcur;
  --
  O_wp_units_variance_export_tbl := L_wp_units_variance_export_tbl;
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
                                            I_error_key       => 'ERROR_SALES_ORDER_EXPORT_UV',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end sales_order_export;
--------------------------------------------------------------------------------
end wp_units_variance_sql;
/
