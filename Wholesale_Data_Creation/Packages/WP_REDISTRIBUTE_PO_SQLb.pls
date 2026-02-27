create or replace package body wp_redistribute_po_sql as
--------------------------------------------------------------------------------
function redistribute_po_search (O_error_message            out varchar2,
                                 O_wp_redistribute_tbl      out wp_redistribute_tbl,
                                 I_order_no                 in  wp_order_head.order_no%type,
                                 I_view_mode                in  varchar2 default 'N')
return boolean is
  --
  L_program             varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.REDISTRIBUTE_PO_SEARCH';
  L_wp_redistribute_tbl wp_redistribute_tbl;
  --
  cursor C_redistribute_po_dtl_view is
  select new wp_redistribute_obj (sales_order_no         => d.sales_order_no,
                                  customer_name          => d.customer_name,
                                  order_row_code         => d.order_row_code,
                                  current_despatch_month => d.current_despatch_month,
                                  customer_loc_name      => d.customer_loc_name,
                                  option_id              => d.option_id,
                                  option_desc            => d.option_desc,
                                  original_qty           => d.original_qty,
                                  current_qty            => d.current_qty,
                                  qty_ordered            => d.qty_ordered_released,
                                  final_receipt_units    => d.final_released_receipt_units,
                                  distributed_ind        => d.redist_ind)
    from wp_v_r_redistribute_po d
   where d.order_no = I_order_no
   order by sales_order_no;
   --
   cursor C_redistribute_po_dtl_edit is
  select new wp_redistribute_obj (sales_order_no         => d.sales_order_no,
                                  customer_name          => d.customer_name,
                                  order_row_code         => d.order_row_code,
                                  current_despatch_month => d.current_despatch_month,
                                  customer_loc_name      => d.customer_loc_name,
                                  option_id              => d.option_id,
                                  option_desc            => d.option_desc,
                                  original_qty           => d.original_qty,
                                  current_qty            => d.current_qty,
                                  qty_ordered            => d.qty_ordered,
                                  final_receipt_units    => d.final_receipt_units,
                                  distributed_ind        => d.redist_ind)
    from wp_v_r_redistribute_po d
   where d.order_no    = I_order_no
     and d.release_ind = 'N'
     and d.sales_order_status  not in ('C', 'D','P')
   order by sales_order_no;
   --
begin
  --
  if I_view_mode = 'Y' then
  --
    open C_redistribute_po_dtl_view;
    fetch C_redistribute_po_dtl_view bulk collect into L_wp_redistribute_tbl;
    close C_redistribute_po_dtl_view;
  --
  elsif I_view_mode = 'N' then
  --
    open C_redistribute_po_dtl_edit;
    fetch C_redistribute_po_dtl_edit bulk collect into L_wp_redistribute_tbl;
    close C_redistribute_po_dtl_edit;
  --
  end if;
  --
  O_wp_redistribute_tbl := L_wp_redistribute_tbl;
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
                                            I_error_key       => 'ERROR_REDISTRIBUTE_PO_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end redistribute_po_search;
-------------------------------------------------------------------------------
function redistribute_dtl_search (O_error_message           out varchar2,
                                  O_wp_distribution_dtl_tbl out wp_distribution_dtl_tbl,
                                  I_order_no                in  wp_order_head.order_no%type,
                                  I_option_id               in  item_master.item%type,
                                  I_customer_id             in  wf_customer.wf_customer_id%type default null,
                                  I_size_code               in  varchar2 default null,
                                  I_view_mode               in  varchar2 default 'N')
return boolean is
  --
  L_program                 varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.REDISTRIBUTE_DTL_SEARCH';
  L_wp_distribution_dtl_tbl wp_distribution_dtl_tbl;
  L_string_query            varchar2(20000);
  L_sys_refcur              sys_refcursor;
  L_current_qty             number;
  L_receipt_qty             number;
  L_PO_qty                  number;
  L_final_receipt_qty       number;
  --
  cursor C_get_totals is
  select sum(current_qty), sum(receipt_qty)
    from table(L_wp_distribution_dtl_tbl);
  --
  cursor C_get_POQuantity_view is
  select sum(d.qty_ordered_released) qty_ordered_released,
         sum(d.final_released_receipt_units) final_released_receipt_units
    from (select d.qty_ordered_released, d.final_released_receipt_units
            from wp_v_r_redistribute_dtl d
           where d.order_no    = I_order_no
          group by d.order_no,
                   d.item,
                   d.qty_ordered_released,
                   d.final_released_receipt_units) d;
  --
  cursor C_get_POQuantity_edit is
  select sum(d.qty_ordered) qty_ordered,
         sum(d.final_receipt_units) final_receipt_units
    from (select d.qty_ordered, d.final_receipt_units
            from wp_v_r_redistribute_dtl d
           where d.order_no    = I_order_no
             and d.release_ind = 'N'
             and d.sales_order_status  not in ('C', 'D','P')
          group by d.order_no,
                   d.item,
                   d.qty_ordered,
                   d.final_receipt_units) d;
  --
begin
  --
  if I_view_mode = 'N' then
  --
   L_string_query := q'{with t_binds as
                       (select :1  bv_customer_id,
                               :2  bv_size_code,
                               :3  bv_option_id,
                               :4  bv_order_no
                         from dual)
                       select new wp_distribution_dtl_obj(size_code,
                                                          sum(current_qty),
                                                          final_receipt_units)
                         from wp_v_r_redistribute_dtl ca,
                              t_binds b
                        where ca.order_no     = b.bv_order_no
                          and ca.option_id    = b.bv_option_id
                          and ca.release_ind  = 'N'
                          and ca.sales_order_status  not in ('C', 'D','P') }';
   --
   elsif I_view_mode = 'Y' then
     --
     L_string_query := q'{with t_binds as
                       (select :1  bv_customer_id,
                               :2  bv_size_code,
                               :3  bv_option_id,
                               :4  bv_order_no
                         from dual)
                       select new wp_distribution_dtl_obj(size_code,
                                                          sum(current_qty),
                                                          final_released_receipt_units)
                         from wp_v_r_redistribute_dtl ca,
                              t_binds b
                        where ca.order_no  = b.bv_order_no
                          and ca.option_id = b.bv_option_id }';
     --
  end if;
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and ca.customer_id = b.bv_customer_id
                                          }';
    --
  end if;
  --
  if I_size_code is not null then
    --
    L_string_query := L_string_query || q'{ and ca.size_code = b.bv_size_code
                                          }';
    --
  end if;
  --
  L_string_query := L_string_query || q'{ group by size_code, final_receipt_units, final_released_receipt_units, display_seq
                                          order by display_seq
                                          }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_customer_id,
                                                I_size_code,
                                                I_option_id,
                                                I_order_no;
  --
  fetch L_sys_refcur bulk collect into L_wp_distribution_dtl_tbl;
  close L_sys_refcur;
  --
  open C_get_totals;
  fetch C_get_totals into L_current_qty,
                          L_receipt_qty;
  --
  L_wp_distribution_dtl_tbl.extend();
  L_wp_distribution_dtl_tbl(L_wp_distribution_dtl_tbl.last) := wp_distribution_dtl_obj('Total',L_current_qty, L_receipt_qty);
  --
  if I_view_mode = 'N' then
    --
    open C_get_POQuantity_edit;
    fetch C_get_POQuantity_edit into L_PO_qty,
                                     L_final_receipt_qty;
    close C_get_POQuantity_edit;
    --
  elsif I_view_mode = 'Y' then
    --
    open C_get_POQuantity_view;
    fetch C_get_POQuantity_view into L_PO_qty,
                                     L_final_receipt_qty;
    close C_get_POQuantity_view;
    --
  end if;
  --
  L_wp_distribution_dtl_tbl.extend();
  L_wp_distribution_dtl_tbl(L_wp_distribution_dtl_tbl.last) := wp_distribution_dtl_obj('POQuantity',L_PO_qty, L_final_receipt_qty);
  --
  O_wp_distribution_dtl_tbl := L_wp_distribution_dtl_tbl;
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
                                            I_error_key       => 'ERROR_REDISTRIBUTE_DTL_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end redistribute_dtl_search;
-------------------------------------------------------------------------------
function redistribute_so_dtl_search (O_error_message              out varchar2,
                                     O_wp_redistribute_so_dtl_tbl out wp_redistribute_so_dtl_tbl,
                                     I_order_no                   in  wp_order_head.order_no%type,
                                     I_option_id                  in  item_master.item%type,
                                     I_customer_id                in  wf_customer.wf_customer_id%type default null,
                                     I_size_code                  in  varchar2 default null,
                                     I_view_mode                  in  varchar2 default 'N')
return boolean is
  --
  L_program                    varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.REDISTRIBUTE_SO_DTL_SEARCH';
  L_wp_redistribute_sku_tbl    wp_redistribute_sku_tbl;
  L_wp_redistribute_so_dtl_tbl wp_redistribute_so_dtl_tbl;
  L_string_query               varchar2(20000);
  L_sys_refcur                 sys_refcursor;
  L_string_query2              varchar2(20000);
  L_sys_refcur2                sys_refcursor;
  --
begin
  --
    L_string_query := q'{with t_binds as
                       (select :1  bv_customer_id,
                               :2  bv_size_code,
                               :3  bv_option_id,
                               :4  bv_order_no
                         from dual)
                       select new wp_redistribute_so_dtl_obj(sales_order_no,
                                                             customer_name,
                                                             threshold_percent,
                                                             null)
                         from wp_v_r_redistribute_dtl ca,
                              t_binds b
                        where ca.order_no  = b.bv_order_no
                          and ca.option_id = b.bv_option_id }';

  --
  if I_view_mode = 'N' then
    --
    L_string_query := L_string_query || q'{ and ca.release_ind = 'N'
                                            and ca.sales_order_status   not in ('C', 'D','P')
                                          }';
    --
  end if;
  --
  if I_customer_id is not null then
    --
    L_string_query := L_string_query || q'{ and ca.customer_id = b.bv_customer_id
                                          }';
    --
  end if;
  --
  if I_size_code is not null then
    --
    L_string_query := L_string_query || q'{ and ca.size_code = b.bv_size_code
                                          }';
    --
  end if;
  --
   L_string_query := L_string_query || q'{ group by sales_order_no, order_no, customer_name, threshold_percent
                                           order by sales_order_no
                                          }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_customer_id,
                                                I_size_code,
                                                I_option_id,
                                                I_order_no;
  --
  fetch L_sys_refcur bulk collect into L_wp_redistribute_so_dtl_tbl;
  close L_sys_refcur;
  --
  for i in 1..L_wp_redistribute_so_dtl_tbl.count loop
    --
        L_string_query2 := q'{with t_binds as
                       (select :1  bv_customer_id,
                               :2  bv_size_code,
                               :3  bv_option_id,
                               :4  bv_order_no
                         from dual)
                       select new wp_redistribute_sku_obj(size_code,
                                                          diff_id_uk,
                                                          current_qty)
                         from wp_v_r_redistribute_dtl ca,
                              t_binds b
                        where ca.order_no  = b.bv_order_no
                          and ca.option_id = b.bv_option_id
                          and ca.sales_order_no =}' || L_wp_redistribute_so_dtl_tbl(i).sales_order_no;
    --
    if I_customer_id is not null then
    --
    L_string_query2 := L_string_query2 || q'{ and ca.customer_id = b.bv_customer_id
                                          }';
    --
    end if;
    --
    if I_size_code is not null then
       --
       L_string_query2 := L_string_query2 || q'{ and ca.size_code = b.bv_size_code
                                          }';
       --
    end if;
    --
    L_string_query2 := L_string_query2 || q'{ order by display_seq
                                          }';
    --
    dbms_output.put_line(L_string_query2);
    --
     open L_sys_refcur2 for L_string_query2 using in I_customer_id,
                                                     I_size_code,
                                                     I_option_id,
                                                     I_order_no;
    --
    fetch L_sys_refcur2 bulk collect into L_wp_redistribute_sku_tbl;
    close L_sys_refcur2;
    --
    L_wp_redistribute_so_dtl_tbl(i).skus := L_wp_redistribute_sku_tbl;
    --
  end loop;
  --
  O_wp_redistribute_so_dtl_tbl := L_wp_redistribute_so_dtl_tbl;
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
                                            I_error_key       => 'ERROR_REDISTRIBUTE_SO_DTL_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end redistribute_so_dtl_search;
--------------------------------------------------------------------------------
function redistribute_save (O_error_message              out varchar2,
                             I_wp_redistribute_so_dtl_tbl in  wp_redistribute_so_dtl_tbl,
                             I_order_no                   in  wp_order_head.order_no%type,
                             I_option_id                  in  item_master.item%type)
return boolean is
  --
  L_program                    varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.REDISTRIBUTE_SAVE';
  --
begin
  --
  for x in 1..I_wp_redistribute_so_dtl_tbl.count loop
    --
    update wp_order_head w
        set w.redist_ind = 'Y',
            w.last_update_id = get_app_user,
            w.last_update_datetime = sysdate
         where w.sales_order_no = I_wp_redistribute_so_dtl_tbl(x).sales_order_no;
    --
    for i in 1..I_wp_redistribute_so_dtl_tbl(x).skus.count loop
      --
      merge into wp_order_detail s
        using (select I_wp_redistribute_so_dtl_tbl(x).sales_order_no sales_order_no,
                      I_wp_redistribute_so_dtl_tbl(x).skus(i).size_code size_code,
                      i.item item,
                      I_wp_redistribute_so_dtl_tbl(x).skus(i).final_receipt_units final_receipt_units
                  from item_master i
                 where item_parent = I_option_id
                  and diff_2 = I_wp_redistribute_so_dtl_tbl(x).skus(i).size_code) src
        on ( s.sales_order_no = src.sales_order_no
            and s.item      = src.item)
        when matched then
          update set s.current_qty  = src.final_receipt_units,
                     s.last_update_id       = get_app_user,
                     s.last_update_datetime = sysdate;
      --
    end loop;
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
                                            I_error_key       => 'ERROR_REDISTRIBUTE_SAVE',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end redistribute_save;
--------------------------------------------------------------------------------
function auto_redistribute (O_error_message                   out varchar2,
                            O_wp_redistribute_auto_button_tbl out wp_redistribute_auto_button_tbl,
                            I_order_no                        in  wp_order_head.order_no%type)
return boolean is
  --
  L_program                    varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.AUTO_REDISTRIBUTE';
  L_wp_redistribute_auto_button_tbl wp_redistribute_auto_button_tbl;
  --
  cursor C_automatic_distribution is
  select new wp_redistribute_auto_button_obj  (po.sales_order_no,
                                              po.option_id,
                                              po.option_desc,
                                              po.customer_loc_name,
                                              sum(po.current_qty),
                                              floor(round(sum(po.final_receipt_units * (po.current_qty/h.total_current_qty)),10)) ,
                                              floor(round(sum(po.final_receipt_units * (po.current_qty/h.total_current_qty)),10)))
    from wp_v_r_redistribute_po po,
         (select order_no, sum(current_qty) total_current_qty
            from wp_v_r_redistribute_po
           where order_no = I_order_no
           and sales_order_status != 'R'
           group by order_no
           ) h
    where po.order_no = h.order_no
     and po.order_no = I_order_no
     and po.release_ind = 'N'
     and po.sales_order_status not in ('C', 'D', 'P')
     group by po.sales_order_no,
              po.option_id,
              po.option_desc,
              po.customer_loc_name,
              original_qty,
              qty_ordered,
              h.total_current_qty,
              po.final_receipt_units;
  --
begin
  --
  open C_automatic_distribution;
  fetch C_automatic_distribution bulk collect into L_wp_redistribute_auto_button_tbl;
  close C_automatic_distribution;
  --
  O_wp_redistribute_auto_button_tbl := L_wp_redistribute_auto_button_tbl;
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
                                            I_error_key       => 'ERROR_AUTO_REDISTRIBUTE',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end auto_redistribute;
--------------------------------------------------------------------------------
function save_auto_distribute (O_error_message                   out varchar2,
                               O_wp_redistribute_error_tbl       out wp_redistribute_error_tbl,
                               I_wp_redistribute_auto_button_tbl in  wp_redistribute_auto_button_tbl,
                               I_order_no                        in  wp_order_head.order_no%type)
return boolean is
  --
  L_program                    varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.SAVE_AUTO_DISTRIBUTE';
  --
  L_get_units wp_redistribute_auto_units_tbl;
  L_check_total_units number;
  --
  cursor C_check_total_units is
  select max(1) t
    from (select sum(i.ammended_units) total_ammended_units
            from table (I_wp_redistribute_auto_button_tbl) i) s,
          wp_v_r_redistribute_po po
    where po.sales_order_no in (select sales_order_no from table (I_wp_redistribute_auto_button_tbl))
     and s.total_ammended_units > po.final_receipt_units;
  --
  cursor C_get_units is
  select new wp_redistribute_auto_units_obj(sales_order_no      => i.sales_order_no,
                                            option_id           => a.option_id,
                                            item                => a.item,
                                            final_receipt_units => case when i.ammended_units = i.recommended_units then
                                                                     a.distributed_units
                                                                   else
                                                                     floor((a.calc_distributed_units * i.ammended_units)/case i.recommended_units when 0 then 1 else i.recommended_units end)
                                                                   end)
     from table(I_wp_redistribute_auto_button_tbl) i,
          wp_v_r_auto_redistributed_so a
    where i.sales_order_no = a.sales_order_no
     and i.option_id       = a.option_id;
  --
  cursor C_check_distributed_units is
  select s.sales_order_no,
         s.option_id,
         s.final_receipt_units final_receipt_units,
         i.ammended_units ammended_units
    from (select auto.sales_order_no,
                 auto.option_id,
                 sum(auto.final_receipt_units) final_receipt_units
            from table(L_get_units) auto
          group by auto.sales_order_no,
                   auto.option_id) s,
         table(I_wp_redistribute_auto_button_tbl) i
   where i.sales_order_no  = s.sales_order_no
     and i.option_id       = s.option_id
     and i.ammended_units != s.final_receipt_units;
  --
  type check_distributed_units is table of C_check_distributed_units%ROWTYPE;
  L_check_distributed_units check_distributed_units;
  --
begin
  --
  open C_check_total_units;
  fetch C_check_total_units into L_check_total_units;
  close C_check_total_units;
  --
   O_wp_redistribute_error_tbl := wp_redistribute_error_tbl();
  --
  if L_check_total_units = 1 then
    --
    O_wp_redistribute_error_tbl.extend();
    O_wp_redistribute_error_tbl(O_wp_redistribute_error_tbl.last) := wp_redistribute_error_obj('E',
                                                                                               null,
                                                                                               null,
                                                                                               'Cannot distribute more than receipted units for the following Supplier PO: ' || I_order_no);
    --
    return false;
    --
  end if;
  --
  open C_get_units;
  fetch C_get_units bulk collect into L_get_units;
  close C_get_units;
  --
  open C_check_distributed_units;
  fetch C_check_distributed_units bulk collect into L_check_distributed_units;
  close C_check_distributed_units;
    --
  update wp_order_head w
    set w.redist_ind = 'Y',
          w.last_update_id = get_app_user,
          w.last_update_datetime = sysdate
    where w.sales_order_no in (select sales_order_no from table(I_wp_redistribute_auto_button_tbl));

    --
    for x in 1..L_get_units.count loop
      --
      merge into wp_order_detail s
            using (select L_get_units(x).sales_order_no sales_order_no,
                          L_get_units(x).item item,
                          L_get_units(x).final_receipt_units final_receipt_units
                          from dual) src
            on (s.sales_order_no = src.sales_order_no
                and s.item = src.item)
            when matched then
              update set s.current_qty  = src.final_receipt_units,
                         s.last_update_id       = get_app_user,
                         s.last_update_datetime = sysdate;
      --
    end loop;
    --
 
  --

    --
   if L_check_distributed_units.count != 0 then
    --
    for i in 1..L_check_distributed_units.count loop
    --
        O_wp_redistribute_error_tbl.extend();
        O_wp_redistribute_error_tbl(O_wp_redistribute_error_tbl.last) := wp_redistribute_error_obj('W',
                                                                                                   L_check_distributed_units(i).sales_order_no,
                                                                                                   L_check_distributed_units(i).option_id,
                                                                                                   'Not all the quantities were distributed. Please manually review it for the following Sales Order: '
                                                                                                   ||to_char( L_check_distributed_units(i).sales_order_no) || ' Option: '||L_check_distributed_units(i).option_id);
                                                                                                   
  --

    --
    end loop;
    --
  end if;
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
                                            I_error_key       => 'ERROR_SAVE_AUTO_DISTRIBUTE',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end save_auto_distribute;
--------------------------------------------------------------------------------
function get_view_mode_ind (O_error_message out varchar2,
                            O_view_mode_ind out varchar2,
                            I_order_no      in  wp_order_head.order_no%type)
return boolean is
  --
  L_program        varchar2(250) := 'WP_REDISTRIBUTE_PO_SQL.GET_VIEW_MODE_IND';
  L_view_mode      varchar2(1)   := 'Y';
  L_view_mode_ind  number;
  --
  cursor C_get_view_mode_ind is
   select max(1)
     from wp_v_r_redistribute_po po
    where po.order_no    = I_order_no
      and po.release_ind = 'N'
      and po.sales_order_status not in ('C', 'D', 'P')
      and po.ready_dist = 'Y';
  --
begin
  --
  open  C_get_view_mode_ind;
  fetch C_get_view_mode_ind into L_view_mode_ind;
  close C_get_view_mode_ind;
  --
  if L_view_mode_ind = 1 then
    --
    L_view_mode := 'N';
    --
  end if;
  --
  O_view_mode_ind := L_view_mode;
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
                                            I_error_key       => 'ERROR_GET_VIEW_MODE_IND',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_view_mode_ind;
--------------------------------------------------------------------------------
end wp_redistribute_po_sql;
/