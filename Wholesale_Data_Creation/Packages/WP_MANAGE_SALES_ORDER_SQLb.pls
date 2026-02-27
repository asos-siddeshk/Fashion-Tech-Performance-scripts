create or replace package body wp_manage_sales_order_sql is
--------------------------------------------------------------------------------
function manage_so_dtl_search (O_error_message                 out varchar2,
                               O_wp_manage_so_dtl_tbl          out wp_manage_so_dtl_tbl,
                               I_sales_order_no                in  wp_order_head.sales_order_no%type default null,
                               I_order_no                      in  wp_order_head.order_no%type default null,
                               I_brand                         in  brand.brand_name%type default null,
                               I_partner_group                 in  wf_customer_group.wf_customer_group_id%type default null,
                               I_customer_id                   in  wf_customer.wf_customer_name%type default null,
                               I_customer_loc                  in  store.store_name%type default null,
                               I_order_row_code                in  wp_order_head.order_row_code%type default null,
                               I_option_id                     in  wp_order_detail.item%type default null,
                               I_sales_order_status            in  wp_sales_order_status_tbl default null,
                               I_sales_order_type              in  wp_order_head.sales_order_type%type default null,
                               I_current_start_date            in  varchar2 default null,
                               I_current_end_date              in  varchar2 default null,
                               I_current_despatch_month        in  varchar2 default null,
                               I_release_start_date             in  varchar2 default null,
                               I_release_end_date              in  varchar2 default null,
                               I_ready_release                 in  varchar2 default null,
                               I_business_model                in  number default null)
return boolean is
  --
  L_program                       varchar2(250) := 'WP_MANAGE_SALES_ORDER_SQL.MANAGE_SO_DTL_SEARCH';
  L_string_query                  varchar2(20000);
  L_wp_manage_so_dtl_tbl          wp_manage_so_dtl_tbl;
  L_sys_refcur                    sys_refcursor;
  L_date                          varchar2(15) := GLOBAL_VARS_SQL.G_wp_date;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no,
                              :2  bv_order_no,
                              :3  bv_brand,
                              :4  bv_customer_id,
                              :5  bv_customer_loc,
                              :6  bv_order_row_code,
                              :7  bv_option_id,
                              :8  bv_sales_order_status,
                              :9  bv_sales_order_type,
                              :10 bv_current_start_date,
                              :11 bv_current_end_date,
                              :12 bv_current_despatch_month,
                              :13 bv_release_start_date,
                              :14 bv_release_end_date,
                              :15 bv_partner_group,
                              :16 bv_ready_release,
                              :17 bv_business_model
                         from dual)
                      select new wp_manage_so_dtl_obj(sales_order_no,
                                                      sales_order_type_desc,
                                                      customer_name,
                                                      customer_loc_name,
                                                      sales_order_status_desc,
                                                      hold_level,
                                                      release_date,
                                                      order_no,
                                                      asn,
                                                      order_row_code,
                                                      po_type_desc,
                                                      first_dest_desc,
                                                      final_dest_desc,
                                                      option_id,
                                                      option_desc,
                                                      current_despatch_month,
                                                      ready_release,
                                                      ready_dist)
                         from wp_v_r_manage_sales_order wmso,
                              t_binds b
                        where 1=1}';
  --
  /*********sales order header filters***********/
  --
  --sales_order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_sales_order_no = wmso.sales_order_no
                                          }';
    --
  end if;
  --
  --order no
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_no = wmso.order_no
                                          }';
    --
  end if;
  --
  --brand
  --
  if I_brand is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_brand = wmso.brand_name
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and wmso.customer_id    = b.bv_customer_id
                                          }';
    --
  end if;
  --
  --customer_loc = partner loc
  --
  if I_customer_loc is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_customer_loc  = wmso.customer_loc
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_row_code  = wmso.order_row_code
                                          }';
    --
  end if;
    --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_option_id  = wmso.option_id
                                          }';
    --
  end if;
  --
  --sales order status
  --
  if I_sales_order_status is not null then
      --
    L_string_query := L_string_query || q'{ and wmso.sales_order_status in (select value_1 from table(b.bv_sales_order_status))
                                          }';
    --
  end if;
  --
  --sales order type
  --
  if I_sales_order_type is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_sales_order_type = wmso.sales_order_type
                                          }';
    --
  end if;
  --
  --fist and final delivery date
  --
  if I_current_start_date is not null and  I_current_end_date is not null then
    --
   L_string_query := L_string_query || q'{ and to_char(wmso.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                           and to_char(wmso.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date
                                          }';


  --
  --first delivery date
  --
    elsif I_current_start_date is not null then
      --
      --dbms_output.put_line(I_first_dest_date);

      L_string_query := L_string_query || q'{ and to_char(wmso.current_start_date, '}'|| L_date || q'{')>= b.bv_current_start_date
                                            }';
      --
    --
    --final delivery date
    --
    elsif I_current_end_date is not null then
      --
      L_string_query := L_string_query || q'{ and to_char(wmso.current_end_date, '}'|| L_date || q'{')<= b.bv_current_end_date
                                            }';
      --
  --
  end if;
  --
  --despatch month
  --
  if I_current_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_current_despatch_month  = wmso.current_despatch_month
                                          }';
    --
  end if;
  --
  --release date
  --
  if I_release_start_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(wmso.release_date, '}'|| L_date || q'{')>= b.bv_release_start_date
                                          }';
    --
  end if;
  --
  if I_release_end_date is not null then
    --
     L_string_query := L_string_query || q'{ and to_char(wmso.release_date, '}'|| L_date || q'{')<= b.bv_release_end_date
                                          }';
    --
  end if;
  --
  --parner group
  --
  if I_partner_group is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_partner_group  = wmso.partner_group
                                          }';
    --
  end if;
  --
  if I_ready_release is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_ready_release  = wmso.ready_release
                                          }';
    --
  end if;
  --
  -- business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and wmso.business_model = b.bv_business_model
                                          }';
    --
  end if;
  --
  L_string_query := L_string_query || q'{ order by wmso.sales_order_no
                                          }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_brand,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_order_row_code,
                                                I_option_id,
                                                I_sales_order_status,
                                                I_sales_order_type,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_current_despatch_month,
                                                I_release_start_date,
                                                I_release_end_date,
                                                I_partner_group,
                                                I_ready_release,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wp_manage_so_dtl_tbl;
  close L_sys_refcur;
  --
  O_wp_manage_so_dtl_tbl := L_wp_manage_so_dtl_tbl;
  --
  DBMS_OUTPUT.put_line('Total:' || L_wp_manage_so_dtl_tbl.count);
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
                                            I_error_key       => 'ERROR_MANAGE_SO_DTL_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end manage_so_dtl_search;
--------------------------------------------------------------------------------
function apply_hold_flag (O_error_message           out varchar2,
                          O_wp_manage_so_errors_tbl out wp_manage_so_errors_tbl,
                          I_sales_order_tbl         in  wp_sales_order_no_tbl)
return boolean is
  --
  L_program                       varchar2(250) := 'WP_MANAGE_SALES_ORDER_SQL.APPLY_HOLD_FLAG';
  L_expiration_date               varchar2(25);
  --
  cursor C_validate_sales_orders is
  select sales_order_no, status, hold_ind, release_ind
    from wp_order_head woh
   where woh.sales_order_no in (select column_value from table(I_sales_order_tbl))
    and ((status = 'C' or status = 'R') or hold_ind = 'Y' or release_ind = 'Y');
  --
  type invalid_so is table of C_validate_sales_orders%ROWTYPE;
  L_invalid_so invalid_so;
  --
  cursor C_get_valid_so is
  select s.column_value
    from table(I_sales_order_tbl) s
   where s.column_value not in (select sales_order_no from table(O_wp_manage_so_errors_tbl));
  --
  type sales_order_list is table of C_get_valid_so%ROWTYPE;
  L_sales_order_list sales_order_list;
  --
begin
  --
  open  C_validate_sales_orders;
  fetch C_validate_sales_orders bulk collect into L_invalid_so;
  close C_validate_sales_orders;
  --
  O_wp_manage_so_errors_tbl := wp_manage_so_errors_tbl();
  --
  for i in 1..L_invalid_so.count loop
    --
    O_wp_manage_so_errors_tbl.extend();
    if L_invalid_so(i).status = 'C' then
      --
      O_wp_manage_so_errors_tbl(O_wp_manage_so_errors_tbl.last) := wp_manage_so_errors_obj(L_invalid_so(i).sales_order_no, 'Sales Order: ' || to_char(L_invalid_so(i).sales_order_no) || ' - Status is Cancelled.');
      --
    elsif L_invalid_so(i).status = 'R' or L_invalid_so(i).release_ind = 'Y' then
      --
      O_wp_manage_so_errors_tbl(O_wp_manage_so_errors_tbl.last) := wp_manage_so_errors_obj(L_invalid_so(i).sales_order_no, 'Sales Order: ' || to_char(L_invalid_so(i).sales_order_no) || ' - Is already released.');
      --
    end if;
    --
    if L_invalid_so(i).hold_ind = 'Y' then
      --
      O_wp_manage_so_errors_tbl(O_wp_manage_so_errors_tbl.last) := wp_manage_so_errors_obj(L_invalid_so(i).sales_order_no, 'Sales Order: ' || to_char(L_invalid_so(i).sales_order_no) || ' - Sale Order Hold flag already applied.');
      --
    end if;
    --
  end loop;
  --
  open C_get_valid_so;
  fetch C_get_valid_so bulk collect into L_sales_order_list;
  close C_get_valid_so;
  --
  for i in 1..L_sales_order_list.count loop
    --
    if (wp_entity_lock_sql.lock_entity(O_error_message   => O_error_message,
                                       O_expiration_date => L_expiration_date,
                                       I_entity_type     => 'SALES_ORDER',
                                       I_entity_id       => L_sales_order_list(i).column_value,
                                       I_user_id         => get_app_user)) = false then
      return false;
    --
    end if;
    --
    update wp_order_head h
      set hold_ind = 'Y'
     where sales_order_no = L_sales_order_list(i).column_value;
    --
    if (wp_entity_lock_sql.release_entity(O_error_message => O_error_message,
                                          I_entity_type   => 'SALES_ORDER',
                                          I_entity_id     =>  L_sales_order_list(i).column_value)) = false then
      --
      return false;
      --
    end if;
    --
  end loop;
  --
  return true;
  --
exception
  --
  when others then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'ERROR_APPLY_HOLD_FLAG',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end apply_hold_flag;
--------------------------------------------------------------------------------
function manage_so_dtl_download (O_error_message               out varchar2,
                               O_wp_manage_so_download_tbl     out wp_manage_so_download_tbl,
                               I_sales_order_no                in  wp_order_head.sales_order_no%type default null,
                               I_order_no                      in  wp_order_head.order_no%type default null,
                               I_brand                         in  brand.brand_name%type default null,
                               I_partner_group                 in  wf_customer_group.wf_customer_group_id%type default null,
                               I_customer_id                   in  wf_customer.wf_customer_name%type default null,
                               I_customer_loc                  in  store.store_name%type default null,
                               I_order_row_code                in  wp_order_head.order_row_code%type default null,
                               I_option_id                     in  wp_order_detail.item%type default null,
                               I_sales_order_status            in  wp_sales_order_status_tbl default null,
                               I_sales_order_type              in  wp_order_head.sales_order_type%type default null,
                               I_current_start_date            in  varchar2 default null,
                               I_current_end_date              in  varchar2 default null,
                               I_current_despatch_month        in  varchar2 default null,
                               I_release_start_date             in  varchar2 default null,
                               I_release_end_date              in  varchar2 default null,
                               I_ready_release                 in  varchar2 default null,
                               I_business_model                in  number default null)
return boolean is
  --
  L_program                       varchar2(250) := 'WP_MANAGE_SALES_ORDER_SQL.MANAGE_SO_DTL_DOWNLOAD';
  L_string_query                  varchar2(20000);
  L_wp_manage_so_download_tbl     wp_manage_so_download_tbl;
  L_sys_refcur                    sys_refcursor;
  L_date                          varchar2(15) := GLOBAL_VARS_SQL.G_wp_date;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no,
                              :2  bv_order_no,
                              :3  bv_brand,
                              :4  bv_customer_id,
                              :5  bv_customer_loc,
                              :6  bv_order_row_code,
                              :7  bv_option_id,
                              :8  bv_sales_order_status,
                              :9  bv_sales_order_type,
                              :10 bv_current_start_date,
                              :11 bv_current_end_date,
                              :12 bv_current_despatch_month,
                              :13 bv_release_start_date,
                              :14 bv_release_end_date,
                              :15 bv_partner_group,
                              :16 bv_ready_release,
                              :17 bv_business_model
                         from dual)
                      select new wp_manage_so_download_obj( brand_name,
                                                            customer_loc_name,
                                                            product_group_name,
                                                            order_row_code,
                                                            option_id,
                                                            option_desc,
                                                            sales_order_no,
                                                            partner_dc_id,
                                                            partner_store_id,
                                                            partner_order_no,
                                                            partner_dept_no)
                         from wp_v_r_manage_sales_order_download wmso,
                              t_binds b
                        where 1=1}';
  --
  /*********sales order header filters***********/
  --
  --sales_order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_sales_order_no = wmso.sales_order_no
                                          }';
    --
  end if;
  --
  --order no
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_no = wmso.order_no
                                          }';
    --
  end if;
  --
  --brand
  --
  if I_brand is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_brand = wmso.brand_name
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and wmso.customer_id    = b.bv_customer_id
                                          }';
    --
  end if;
  --
  --customer_loc = partner loc
  --
  if I_customer_loc is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_customer_loc  = wmso.customer_loc
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_order_row_code  = wmso.order_row_code
                                          }';
    --
  end if;
    --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_option_id  = wmso.option_id
                                          }';
    --
  end if;
  --
  --sales order status
  --
  if I_sales_order_status is not null then
      --
    L_string_query := L_string_query || q'{ and wmso.sales_order_status in (select value_1 from table(b.bv_sales_order_status))
                                          }';
    --
  end if;
  --
  --sales order type
  --
  if I_sales_order_type is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_sales_order_type = wmso.sales_order_type
                                          }';
    --
  end if;
  --
  --fist and final delivery date
  --
  if I_current_start_date is not null and  I_current_end_date is not null then
    --
   L_string_query := L_string_query || q'{ and to_char(wmso.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                           and to_char(wmso.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date
                                          }';


  --
  --first delivery date
  --
    elsif I_current_start_date is not null then
      --
      --dbms_output.put_line(I_first_dest_date);

      L_string_query := L_string_query || q'{ and to_char(wmso.current_start_date, '}'|| L_date || q'{')>= b.bv_current_start_date
                                            }';
      --
    --
    --final delivery date
    --
    elsif I_current_end_date is not null then
      --
      L_string_query := L_string_query || q'{ and to_char(wmso.current_end_date, '}'|| L_date || q'{')<= b.bv_current_end_date
                                            }';
      --
  --
  end if;
  --
  --despatch month
  --
  if I_current_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_current_despatch_month  = wmso.current_despatch_month
                                          }';
    --
  end if;
  --
  --release date
  --
  if I_release_start_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(wmso.release_date, '}'|| L_date || q'{')>= b.bv_release_start_date
                                          }';
    --
  end if;
  --
  if I_release_end_date is not null then
    --
     L_string_query := L_string_query || q'{ and to_char(wmso.release_date, '}'|| L_date || q'{')<= b.bv_release_end_date
                                          }';
    --
  end if;
  --
  --parner group
  --
  if I_partner_group is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_partner_group  = wmso.partner_group
                                          }';
    --
  end if;
  --
  if I_ready_release is not null then
    --
    L_string_query := L_string_query || q'{ and b.bv_ready_release  = wmso.ready_release
                                          }';
    --
  end if;
  --
  -- business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and wmso.business_model = b.bv_business_model
                                          }';
    --
  end if;
  --
  L_string_query := L_string_query || q'{ order by wmso.sales_order_no
                                          }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_brand,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_order_row_code,
                                                I_option_id,
                                                I_sales_order_status,
                                                I_sales_order_type,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_current_despatch_month,
                                                I_release_start_date,
                                                I_release_end_date,
                                                I_partner_group,
                                                I_ready_release,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wp_manage_so_download_tbl;
  close L_sys_refcur;
  --
  O_wp_manage_so_download_tbl := L_wp_manage_so_download_tbl;
  --
  --DBMS_OUTPUT.put_line('Total:' || L_wp_manage_so_dtl_tbl.count);
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
                                            I_error_key       => 'ERROR_MANAGE_SO_DTL_DOWNLOAD',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end manage_so_dtl_download;
--------------------------------------------------------------------------------
end wp_manage_sales_order_sql;
/