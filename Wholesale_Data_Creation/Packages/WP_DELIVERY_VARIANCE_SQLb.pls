create or replace package body wp_delivery_variance_sql is
--------------------------------------------------------------------------------
function delivery_var_head_search (O_error_message                 out varchar2,
                                   O_wp_delivery_var_head_tbl      out wp_delivery_variance_head_tbl,
                                   I_sales_order_no                in  wp_order_head.sales_order_no%type default null,
                                   I_order_no                      in  wp_order_head.order_no%type default null,
                                   I_order_row_code                in  wp_order_head.order_row_code%type default null,
                                   I_customer_id                   in  wf_customer.wf_customer_id%type default null,
                                   I_customer_loc                  in  store.store%type default null,
                                   I_option_id                     in  wp_order_detail.item%type default null,
                                   I_despatch_month                in  varchar2 default null,
                                   I_current_start_date            in  varchar2 default null,
                                   I_current_end_date              in  varchar2 default null,
                                   I_calculated_despatch_month     in  number default null,
                                   I_business_model                in  number default null)
return boolean is
  --
  L_program                       varchar2(250) := 'WP_DELIVERY_VARIANCE_SQL.DELIVERY_VAR_HEAD_SEARCH';
  L_string_query                  varchar2(20000);
  L_wp_delivery_var_head_tbl      wp_delivery_variance_head_tbl;
  L_sys_refcur                    sys_refcursor;
  L_date                          varchar2(15) := GLOBAL_VARS_SQL.G_wp_date;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no,
                              :2  bv_order_no,
                              :3  bv_order_row_code,
                              :4  bv_customer_id,
                              :5  bv_customer_loc,
                              :6  bv_option_id,
                              :7  bv_despatch_month,
                              :8  bv_current_start_date,
                              :9  bv_current_end_date,
                              :10 bv_calculated_despatch_month,
                              :11 bv_business_model
                         from dual)
                      select new wp_delivery_variance_head_obj(order_no,
                                                               order_row_code,
                                                               first_dest,
                                                               final_dest,
                                                               first_dest_desc,
                                                               final_dest_desc,
                                                               first_dest_week,
                                                               final_dest_week,
                                                               asn_delivery_week,
                                                               asn_receipt_week,
                                                               final_despatch_month)
                         from wp_delivery_variance_head wpdv,
                              t_binds b
                        where 1=1}';
  --
  /*********sales order header filters***********/
  --
  --order no
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_no = wpdv.order_no
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_row_code = wpdv.order_row_code
                                          }';
    --
  end if;
  --
  --fist and final delivery date
  --
  if I_current_start_date is not null and  I_current_end_date is not null then
    --
   L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no           = wpdv.order_no
                                                           and wpd.first_dest         = wpdv.first_dest
                                                           and wpd.final_dest         = wpdv.final_dest
                                                           and to_char(wpd.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                                           and to_char(wpd.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date)
                                          }';

  end if;
  --
  --first delivery date
  --
  if I_current_start_date is not null then
    --
    --dbms_output.put_line(I_first_dest_date);

    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no           = wpdv.order_no
                                                           and wpd.first_dest         = wpdv.first_dest
                                                           and wpd.final_dest         = wpdv.final_dest
                                                           and to_char(wpd.current_start_date, '}'|| L_date || q'{')>= b.bv_current_start_date)
                                          }';
    --
  end if;
  --
  --final delivery date
  --
  if  I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no           = wpdv.order_no
                                                           and wpd.first_dest         = wpdv.first_dest
                                                           and wpd.final_dest         = wpdv.final_dest
                                                           and to_char(wpd.current_end_date, '}'|| L_date || q'{')<= b.bv_current_end_date)
                                          }';
    --
  end if;
  --
  /*************sales order detail filters**************/
  --
  --calculated_despatch_month/month gap
  --
  if I_calculated_despatch_month is not null then
    --
    if I_calculated_despatch_month >= 3 then
      --
      L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no                  = wpdv.order_no
                                                           and wpd.first_dest                = wpdv.first_dest
                                                           and wpd.final_dest                = wpdv.final_dest
                                                           and wpd.calculated_despatch_month >= b.bv_calculated_despatch_month)
                                          }';
      --
    else
      --
      L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no                  = wpdv.order_no
                                                           and wpd.first_dest                = wpdv.first_dest
                                                           and wpd.final_dest                = wpdv.final_dest
                                                           and wpd.calculated_despatch_month = b.bv_calculated_despatch_month)
                                          }';
      --
    end if;
    --
  end if;
  --
  --sales order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no       = wpdv.order_no
                                                           and wpd.first_dest     = wpdv.first_dest
                                                           and wpd.final_dest     = wpdv.final_dest
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
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no       = wpdv.order_no
                                                           and wpd.first_dest     = wpdv.first_dest
                                                           and wpd.final_dest     = wpdv.final_dest
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
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no       = wpdv.order_no
                                                           and wpd.first_dest     = wpdv.first_dest
                                                           and wpd.final_dest     = wpdv.final_dest
                                                           and wpd.customer_loc   = b.bv_customer_loc)
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no       = wpdv.order_no
                                                           and wpd.first_dest     = wpdv.first_dest
                                                           and wpd.final_dest     = wpdv.final_dest
                                                           and wpd.customer_id    = b.bv_customer_id)
                                          }';
    --
  end if;
  --
  --despatch month
  --
  if I_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and exists (select 1
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no               = wpdv.order_no
                                                           and wpd.first_dest             = wpdv.first_dest
                                                           and wpd.final_dest             = wpdv.final_dest
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
                                                          from wp_delivery_variance_dtl wpd
                                                         where wpd.order_no               = wpdv.order_no
                                                           and wpd.first_dest             = wpdv.first_dest
                                                           and wpd.final_dest             = wpdv.final_dest
                                                           and wpd.business_model         = b.bv_business_model)
                                          }';
    --
  end if;
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_order_row_code,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_option_id,
                                                I_despatch_month,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_calculated_despatch_month,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wp_delivery_var_head_tbl;
  close L_sys_refcur;
  --
  O_wp_delivery_var_head_tbl := L_wp_delivery_var_head_tbl;
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
                                            I_error_key       => 'ERROR_DELIVERY_VAR_HEAD_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end delivery_var_head_search;
--------------------------------------------------------------------------------
function delivery_var_dtl_search (O_error_message            out varchar2,
                                  O_wp_delivery_variance_dtl_tbl out wp_delivery_variance_dtl_tbl,
                                  I_order_no                 in  wp_order_head.order_no%type,
                                  I_first_dest               in  number,
                                  I_final_dest               in  number,
                                  I_offset                   in  number,
                                  I_limit                    in number)
return boolean is
  --
  L_program                  varchar2(250) := 'WP_UNITS_VARIANCE_SQL.DELIVERY_VAR_DTL_SEARCH';
  L_wp_delivery_variance_dtl_tbl wp_delivery_variance_dtl_tbl;
  --
  cursor C_delivery_var_dtl is
  select new wp_delivery_variance_dtl_obj(sales_order_no          => sales_order_no,
                                      option_id                   => option_id,
                                      option_desc                 => option_desc,
                                      customer_loc                => customer_loc_name,
                                      customer_id                 => customer_name,
                                      original_despatch_month     => original_despatch_month,
                                      current_despatch_month      => current_despatch_month,
                                      calculated_despatch_month   => calculated_despatch_month,
                                      final_despatch_month        => final_despatch_month)
      from wp_delivery_variance_dtl
     where order_no             = I_order_no
       and first_dest           = I_first_dest
       and final_dest           = I_final_dest
  order by sales_order_no, option_id
  offset I_offset rows fetch next I_limit rows only;
  --
begin
  --
  open  C_delivery_var_dtl;
  fetch C_delivery_var_dtl bulk collect into L_wp_delivery_variance_dtl_tbl;
  close C_delivery_var_dtl;
  --
  O_wp_delivery_variance_dtl_tbl := L_wp_delivery_variance_dtl_tbl;
  --
  --dbms_output.put_line(L_wp_delivery_variance_dtl_tbl.count);
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
                                            I_error_key       => 'ERROR_DELIVERY_VAR_DTL_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end delivery_var_dtl_search;
--------------------------------------------------------------------------------
function delivery_var_export (O_error_message                 out varchar2,
                              O_wp_delivery_var_export_tbl    out wp_delivery_var_export_tbl,
                              I_sales_order_no                in  wp_order_head.sales_order_no%type default null,
                              I_order_no                      in  wp_order_head.order_no%type default null,
                              I_order_row_code                in  wp_order_head.order_row_code%type default null,
                              I_customer_id                   in  wf_customer.wf_customer_id%type default null,
                              I_customer_loc                  in  store.store%type default null,
                              I_option_id                     in  wp_order_detail.item%type default null,
                              I_despatch_month                in  varchar2 default null,
                              I_current_start_date            in  varchar2 default null,
                              I_current_end_date              in  varchar2 default null,
                              I_calculated_despatch_month     in  number default null,
                              I_business_model                in  number default null)
return boolean is
  --
  L_program                       varchar2(250) := 'WP_DELIVERY_VARIANCE_SQL.DELIVERY_VAR_EXPORT';
  L_string_query                  varchar2(20000);
  L_wp_delivery_var_export_tbl    wp_delivery_var_export_tbl;
  L_sys_refcur                    sys_refcursor;
  L_date                          varchar2(15) := GLOBAL_VARS_SQL.G_wp_date;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no,
                              :2  bv_order_no,
                              :3  bv_order_row_code,
                              :4  bv_customer_id,
                              :5  bv_customer_loc,
                              :6  bv_option_id,
                              :7  bv_despatch_month,
                              :8  bv_current_start_date,
                              :9  bv_current_end_date,
                              :10 bv_calculated_despatch_month,
                              :11 bv_business_model
                         from dual)
                      select new wp_delivery_var_export_obj(order_no,
                                                               order_row_code,
                                                               first_dest_desc,
                                                               final_dest_desc,
                                                               first_dest_week,
                                                               final_dest_week,
                                                               asn_delivery_week,
                                                               asn_receipt_week,
                                                               sales_order_no,
                                                               option_id,
                                                               option_desc,
                                                               customer_loc_name,
                                                               customer_name,
                                                               original_despatch_month,
                                                               current_despatch_month,
                                                               final_despatch_month)
                         from wp_delivery_variance_dtl wpdv,
                              t_binds b
                        where 1=1}';
  --
  /*********sales order header filters***********/
  --
  --order no
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_no = wpdv.order_no
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_row_code = wpdv.order_row_code
                                          }';
    --
  end if;
  --
  --fist and final delivery date
  --
  if I_current_start_date is not null and  I_current_end_date is not null then
    --

    L_string_query := L_string_query || q'{ and to_char(wpdv.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                           and to_char(wpdv.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date)
                                         }';
    --
  end if;
  --
  --first delivery date
  --
  if I_current_start_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(wpdv.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                         }';
    --
  end if;
  --
  --final delivery date
  --
  if  I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(wpdv.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date
                                         }';
    --
  end if;
  --
  /*************sales order detail filters**************/
  --
  --calculated_despatch_month/month gap
  --
  if I_calculated_despatch_month is not null then
    --
    if I_calculated_despatch_month >= 3 then
      --
      L_string_query := L_string_query || q'{ and wpdv.calculated_despatch_month >= b.bv_calculated_despatch_month
                                          }';
      --
    else
      --
      L_string_query := L_string_query || q'{ and wpdv.calculated_despatch_month = b.bv_calculated_despatch_month
                                          }';
      --
    end if;
    --
  end if;
  --
  --sales order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and wpdv.sales_order_no = b.bv_sales_order_no
                                          }';
    --
  end if;
  --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and wpdv.option_id = b.bv_option_id
                                          }';
    --
  end if;
  --
  --customer_loc = partner loc
  --
  if I_customer_loc is not null then
    --
    L_string_query := L_string_query || q'{ and wpdv.customer_loc   = b.bv_customer_loc
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and wpdv.customer_id    = b.bv_customer_id
                                          }';
    --
  end if;
  --
  --despatch month
  --
  if I_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and wpdv.current_despatch_month = b.bv_despatch_month
                                          }';
    --
  end if;
  --
  --business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and wpdv.business_model = b.bv_business_model
                                          }';
    --
  end if;
  --
   L_string_query := L_string_query || q'{ order by wpdv.option_id, wpdv.sales_order_no
                                          }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_order_row_code,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_option_id,
                                                I_despatch_month,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_calculated_despatch_month,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wp_delivery_var_export_tbl;
  close L_sys_refcur;
  --
  O_wp_delivery_var_export_tbl := L_wp_delivery_var_export_tbl;
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
                                            I_error_key       => 'ERROR_DELIVERY_VAR_EXPORT',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end delivery_var_export;
--------------------------------------------------------------------------------
end wp_delivery_variance_sql;
/