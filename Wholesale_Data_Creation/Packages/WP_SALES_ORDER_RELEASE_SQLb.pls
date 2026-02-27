create or replace package body wp_sales_order_release_sql as
--------------------------------------------------------------------------------
function sales_order_release_search (O_error_message            out varchar2,
                                     O_wp_so_release_tbl        out wp_so_release_tbl,
                                     I_sales_order_no           in  wp_order_head.sales_order_no%type default null,
                                     I_order_no                 in  wp_order_head.order_no%type default null,
                                     I_order_row_code           in  wp_order_head.order_row_code%type default null,
                                     I_customer_id              in  wf_customer.wf_customer_id%type default null,
                                     I_customer_loc             in  store.store%type default null,
                                     I_option_id                in  wp_order_detail.item%type default null,
                                     I_current_despatch_month   in  varchar2 default null,
                                     I_current_start_date       in  varchar2 default null,
                                     I_current_end_date         in  varchar2 default null,                                    
                                     I_status                   in  varchar2 default null,
                                     I_source_loc               in  wh.wh_name%type,
                                     I_hold_level               in  varchar2 default null,
                                     I_sales_order_type         in  varchar2 default null,
                                     I_partner_tile             in  varchar2,
                                     I_business_model           in  number   default null)
return boolean is
  --
  L_program             varchar2(250) := 'WP_SALES_ORDER_RELEASE_SQL.SALES_ORDER_RELEASE_SEARCH';
  L_string_query        varchar2(20000);
  L_wp_so_release_tbl   wp_so_release_tbl;
  L_sys_refcur          sys_refcursor;
  L_date                varchar2(25) := GLOBAL_VARS_SQL.G_wp_date;
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
                              :7  bv_current_despatch_month,
                              :8  bv_current_start_date,
                              :9  bv_current_end_date,
                              :10 bv_status,
                              :11 bv_source_loc,
                              :12 bv_hold_level,
                              :13 bv_sales_order_type,
                              :14 bv_partner_tile,
                              :15 bv_business_model
                         from dual)
                      select new wp_so_release_obj(sales_order_no,
                                                   sales_order_type,
                                                   order_no,
                                                   asn,
                                                   option_id,
                                                   option_desc,
                                                   customer_name,
                                                   customer_loc_name,
                                                   final_dest_receipt_units,
                                                   current_qty,
                                                   current_despatch_month,
                                                   distributed_ind,
                                                   hold_level,
                                                   status,
                                                   rrp_value)
                         from wp_sales_order_release sor,
                              t_binds b
                        where sor.source_loc = b.bv_source_loc }';
  --
  /*********sales order header filters***********/
  if I_partner_tile = 'Others' then
    --check view
    L_string_query := L_string_query || q'{ and sor.customer_name not in (select s.series_desc
                                                                            from wp_dashboard_detail s
                                                                           where s.dashboard_id  = 'SOR'
                                                                             and s.dash_dtl_id < 5)
                                          }';
    --
  else
    --
    L_string_query := L_string_query || q'{ and sor.customer_name = b.bv_partner_tile
                                          }';
    --
  end if;
  --
  --order no
  --
  if I_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and sor.order_no = b.bv_order_no
                                          }';
    --
  end if;
  --
  --order row code
  --
  if I_order_row_code is not null then
    --
    L_string_query := L_string_query || q'{ and sor.order_row_code = b.bv_order_row_code
                                          }';
    --
  end if;
  --
  --sales order no
  --
  if I_sales_order_no is not null then
    --
    L_string_query := L_string_query || q'{ and sor.sales_order_no = b.bv_sales_order_no
                                          }';
    --
  end if;
  --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and sor.option_id = b.bv_option_id
                                          }';
    --
  end if;
  --
  --customer_loc = partner loc
  --
  if I_customer_loc is not null then
    --
    L_string_query := L_string_query || q'{ and sor.customer_loc  = b.bv_customer_loc
                                          }';
    --
  end if;
  --
  --customer_id = partner
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and sor.customer_id = b.bv_customer_id
                                          }';
    --
  end if;
  --
  --sales order delivery start and end dates
  --
  if I_current_start_date is not null and I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(sor.current_start_date, '}'|| L_date || q'{')= b.bv_current_start_date
                                            and to_char(sor.current_end_date, '}'|| L_date || q'{')  = b.bv_current_end_date
                                          }';
    --
  elsif I_current_start_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(sor.current_start_date, '}'|| L_date || q'{')>= b.bv_current_start_date
                                          }';
    --
  elsif I_current_end_date is not null then
    --
    L_string_query := L_string_query || q'{ and to_char(sor.current_end_date, '}'|| L_date || q'{')<= b.bv_current_end_date
                                          }';
    --
  end if;
  --
  --despatch month
  --
  if I_current_despatch_month is not null then
    --
    L_string_query := L_string_query || q'{ and sor.current_despatch_month = b.bv_current_despatch_month
                                          }';
    --
  end if;
  --
  -- sales order status
  --
  if I_status is not null then
    --
    L_string_query := L_string_query || q'{ and sor.status_id = b.bv_status
                                          }';
    --
  end if;
  --
  -- hold level
  --
  if I_hold_level is not null then
    --
    L_string_query := L_string_query || q'{ and sor.hold_level_id = b.bv_hold_level
                                          }';
    --
  end if;
  --
  -- sales order type
  --
  if I_sales_order_type is not null then
    --
    L_string_query := L_string_query || q'{ and sor.sales_order_type_id = b.bv_sales_order_type
                                          }';
    --
  end if;
  --
  -- business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and sor.business_model = b.bv_business_model
                                          }';
    --
  end if; 
  --
  L_string_query := L_string_query || q'{ order by sor.current_month_date,
                                                   sor.option_id,
                                                   sor.customer_name
                                          }';                                         
  --
  --dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no,
                                                I_order_no,
                                                I_order_row_code,
                                                I_customer_id,
                                                I_customer_loc,
                                                I_option_id,
                                                I_current_despatch_month,
                                                I_current_start_date,
                                                I_current_end_date,
                                                I_status,
                                                I_source_loc,
                                                I_hold_level,
                                                I_sales_order_type,
                                                I_partner_tile,
                                                I_business_model;
  --
  fetch L_sys_refcur bulk collect into L_wp_so_release_tbl;
  close L_sys_refcur;
  --
  O_wp_so_release_tbl := L_wp_so_release_tbl;
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
                                            I_error_key       => 'ERROR_SALES_ORDER_RELEASE_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end sales_order_release_search;
-------------------------------------------------------------------------------
function release_sales_order (O_error_message            out varchar2,
                              O_wp_sor_errors_tbl        out wp_sor_errors_tbl,
                              I_sales_order              in  wp_number_tbl,
                              I_freight                  in  varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_SALES_ORDER_RELEASE_SQL.RELEASE_SALES_ORDER';
  --
  L_expiration_date varchar2(25);
  --
  cursor C_check_entity_lock is
  select l.entity_id
    from wp_entity_lock l
   where exists (select 1
                   from table(I_sales_order)
                  where l.entity_type = 'SALES_ORDER'
                   and column_value = l.entity_id);
  --
  type check_entity_lock is table of C_check_entity_lock%ROWTYPE;
  L_check_entity_lock   check_entity_lock;
  --
  cursor C_check_partner_order is
  select woh.sales_order_no
    from wp_order_head woh,
         wp_customer_attrib ca
  where exists (select 1
                  from table(I_sales_order)
                 where column_value = woh.sales_order_no)
    and ca.partner_order_ind = 'Y'
    and ca.customer_id = woh.customer_id
    and woh.sales_order_no not in (select sales_order_no from table(O_wp_sor_errors_tbl))
    and woh.partner_order_no is null;
  --
  type partner_order_list is table of C_check_partner_order%ROWTYPE;
  L_partner_order_list   partner_order_list;
  --
  cursor C_check_partner_store is
  select woh.sales_order_no
    from wp_order_head woh,
         wp_order_detail wod,
         wp_customer_attrib ca
   where exists (select 1
                  from table(I_sales_order)
                 where column_value = woh.sales_order_no)
    and ca.partner_st_req_ind = 'Y'
    and ca.customer_id = woh.customer_id
    and woh.sales_order_no = wod.sales_order_no
    and woh.sales_order_no not in (select sales_order_no from table(O_wp_sor_errors_tbl))
    and (wod.partner_dc_id is null or wod.partner_store_id is null)
   group by woh.sales_order_no;

  --
  type partner_store_list is table of C_check_partner_store%ROWTYPE;
  L_partner_store_list   partner_store_list;
  --
  cursor C_check_partner_dept is
  select woh.sales_order_no
    from wp_order_head woh,
         wp_customer_attrib ca
   where exists (select 1
                  from table(I_sales_order)
                 where column_value = woh.sales_order_no)
    and ca.partner_dept_ind = 'Y'
    and ca.customer_id = woh.customer_id
    and woh.sales_order_no not in (select sales_order_no from table(O_wp_sor_errors_tbl))
    and woh.partner_dept_no is null
   group by woh.sales_order_no;
  --
  type partner_dept_list is table of C_check_partner_dept%ROWTYPE;
  L_partner_dept_list   partner_dept_list;
  --
  cursor C_get_sales_order is
  select i.column_value
    from table(I_sales_order) i
   where i.column_value not in (select sales_order_no from table(O_wp_sor_errors_tbl))
group by i.column_value;
  --
  type sales_order_list is table of C_get_sales_order%ROWTYPE;
  L_sales_order_list   sales_order_list;
  --
begin
  --
  O_wp_sor_errors_tbl := wp_sor_errors_tbl();
  --
  open C_check_entity_lock;
  fetch C_check_entity_lock bulk collect into L_check_entity_lock;
  close C_check_entity_lock;
  --
  for i in 1..L_check_entity_lock.count loop
    --
    O_wp_sor_errors_tbl.extend();
    O_wp_sor_errors_tbl(O_wp_sor_errors_tbl.last) := wp_sor_errors_obj(L_check_entity_lock(i).entity_id, wp_errors_sql.get_message_text('RELEASE_LOCKED_SO',L_check_entity_lock(i).entity_id));
    --
  end loop;
  --
  open C_check_partner_order;
  fetch C_check_partner_order bulk collect into L_partner_order_list;
  close C_check_partner_order;
  --
  for i in 1..L_partner_order_list.count loop
    --
    O_wp_sor_errors_tbl.extend();
    O_wp_sor_errors_tbl(O_wp_sor_errors_tbl.last) := wp_sor_errors_obj(L_partner_order_list(i).sales_order_no, wp_errors_sql.get_message_text('MISS_PARTNER_PO',L_partner_order_list(i).sales_order_no));
    --
  end loop;
  --
  open C_check_partner_store;
  fetch C_check_partner_store bulk collect into L_partner_store_list;
  close C_check_partner_store;
  --
  for i in 1..L_partner_store_list.count loop
    --
    O_wp_sor_errors_tbl.extend();
    O_wp_sor_errors_tbl(O_wp_sor_errors_tbl.last) := wp_sor_errors_obj(L_partner_store_list(i).sales_order_no, wp_errors_sql.get_message_text('MISS_PARTNER_STORE',L_partner_store_list(i).sales_order_no));
    --
  end loop;
  --
  open  C_check_partner_dept;
  fetch C_check_partner_dept bulk collect into L_partner_dept_list;
  close C_check_partner_dept;
  --
  for i in 1..L_partner_store_list.count loop
    --
    O_wp_sor_errors_tbl.extend();
    O_wp_sor_errors_tbl(O_wp_sor_errors_tbl.last) := wp_sor_errors_obj(L_partner_store_list(i).sales_order_no, wp_errors_sql.get_message_text('MISS_PARTNER_DEPT',L_partner_store_list(i).sales_order_no));
    --
  end loop;
  --
  open C_get_sales_order;
  fetch C_get_sales_order bulk collect into L_sales_order_list;
  close C_get_sales_order;
  --
  for i in 1..L_sales_order_list.count loop
    --
    if (wp_entity_lock_sql.lock_entity(O_error_message   => O_error_message,
                                       O_expiration_date => L_expiration_date,
                                       I_entity_type     => 'SALES_ORDER',
                                       I_entity_id       => L_sales_order_list(i).column_value,
                                       I_user_id         => get_app_user)) = false then
      return false;
    end if;
    --
    update wp_order_head
        set release_ind  = 'Y',
            release_date = to_date(sysdate, 'dd/mm/rrrr'),
            freight      = I_freight
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
  when OTHERS then
  --
  O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                            I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                            I_program_name    => L_program,
                                            I_error_key       => 'ERROR_RELEASE_SALES_ORDER',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end release_sales_order;
-------------------------------------------------------------------------------
function validate_so_already_release (O_error_message            out varchar2,
                                      O_wp_sor_errors_tbl        out wp_sor_errors_tbl,
                                      I_sales_order              in  wp_number_tbl)
return boolean is
  --
  L_program             varchar2(250) := 'WP_SALES_ORDER_RELEASE_SQL.VALIDATE_SO_ALREADY_RELEASE';
  --
  cursor C_get_already_release is
  select woh.sales_order_no
    from wp_order_head woh
   where exists (select 1
                  from table(I_sales_order)
                 where column_value = woh.sales_order_no)
     and woh.release_ind = 'Y';
  --
  type sales_release_list is table of C_get_already_release%ROWTYPE;
  L_sales_release_list   sales_release_list;
  --
begin
  --
  O_wp_sor_errors_tbl := wp_sor_errors_tbl();
  --
  open C_get_already_release;
  fetch C_get_already_release bulk collect into L_sales_release_list;
  close C_get_already_release;
  --
  for i in 1..L_sales_release_list.count loop
    --
    O_wp_sor_errors_tbl.extend();
    O_wp_sor_errors_tbl(O_wp_sor_errors_tbl.last) := wp_sor_errors_obj(L_sales_release_list(i).sales_order_no, wp_errors_sql.get_message_text('ALREADY_RELEASE',L_sales_release_list(i).sales_order_no));
    --
  end loop;
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
                                            I_error_key       => 'ERROR_VALIDATE_SO_ALREADY_RELEASE',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
end validate_so_already_release;
-------------------------------------------------------------------------------
end wp_sales_order_release_sql;
/