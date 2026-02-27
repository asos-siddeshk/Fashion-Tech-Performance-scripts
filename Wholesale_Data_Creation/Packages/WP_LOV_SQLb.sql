create or replace package body wp_lov_sql is
--------------------------------------------------------------------------------
function get_sales_order_no (O_error_message             out varchar2,
                             O_wp_Lov_Sales_Order_No_Tbl out wp_Lov_Sales_Order_No_Tbl,
                             I_sales_order_no            in  number)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_SALES_ORDER_NO';
  L_wp_Lov_Sales_Order_No_Tbl wp_Lov_Sales_Order_No_Tbl;
  L_sales_order_no            varchar2(100) := '%' || I_sales_order_no || '%';
  --
  cursor C_get_sales_order_no is
   select new wp_Lov_Sales_Order_No_Obj(sales_order_no => sales_order_no)
     from wp_order_head wod
    where wod.sales_order_no like L_sales_order_no;
  --
begin
  --
  open  C_get_sales_order_no;
  fetch C_get_sales_order_no bulk collect into L_wp_Lov_Sales_Order_No_Tbl;
  close C_get_sales_order_no;
  --
  O_wp_Lov_Sales_Order_No_Tbl := L_wp_Lov_Sales_Order_No_Tbl;
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
                                              I_error_key       => 'ERROR_WP_LOV_SALES_ORDER_NO',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_sales_order_no;
--------------------------------------------------------------------------------
function get_po_number (O_error_message            out varchar2,
                           O_wp_Lov_Po_Number_Tbl     out wp_Lov_Po_Number_Tbl,
                           I_po_number                in  number)
return boolean is
  --
  L_program                  varchar2(250) := 'WP_LOV_SQL.GET_PO_NUMBER';
  L_wp_Lov_Po_Number_Tbl     wp_Lov_Po_Number_Tbl;
  L_po_number                varchar2(100) := '%' || I_po_number || '%';
  --
  cursor C_get_po_number is
   select new wp_Lov_Po_Number_Obj(order_no => woh.order_no)
     from wp_order_head woh
    where woh.order_no like L_po_number
   group by woh.order_no;
  --
begin
  --
  open  C_get_po_number;
  fetch C_get_po_number bulk collect into L_wp_Lov_Po_Number_Tbl;
  close C_get_po_number;
  --
  O_wp_Lov_Po_Number_Tbl := L_wp_Lov_Po_Number_Tbl;
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
                                              I_error_key       => 'ERROR_WP_LOV_PO_NUMBER',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_po_number;
--------------------------------------------------------------------------------
function get_order_row_code (O_error_message                 out varchar2,
                                O_wp_Lov_Order_Row_Code_Tbl     out wp_Lov_Order_Row_Code_Tbl,
                                I_order_row_code                in  varchar2)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_ORDER_ROW_CODE';
  L_wp_Lov_Order_Row_Code_Tbl wp_Lov_Order_Row_Code_Tbl;
  L_order_row_code            varchar2(100) := '%' || upper(I_order_row_code) || '%';
  --
  cursor C_get_order_row_code is
   select new wp_Lov_Order_Row_Code_Obj(order_row_code => order_row_code)
     from wp_order_head woh
    where upper(woh.order_row_code) like L_order_row_code
    group by order_row_code;
  --
begin
  --
  open  C_get_order_row_code;
  fetch C_get_order_row_code bulk collect into L_wp_Lov_Order_Row_Code_Tbl;
  close C_get_order_row_code;
  --
  O_wp_Lov_Order_Row_Code_Tbl := L_wp_Lov_Order_Row_Code_Tbl;
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
                                              I_error_key       => 'ERROR_WP_LOV_ORDER_ROW_CODE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_order_row_code;
--------------------------------------------------------------------------------
function get_option (O_error_message         out varchar2,
                     O_wp_Lov_option_tbl     out wp_Lov_option_tbl,
                     I_option_id             in  varchar2,
                     I_option_desc           in  varchar2)
return boolean is
  --
  L_program               varchar2(250) := 'WP_LOV_SQL.GET_OPTION';
  L_wp_Lov_option_tbl     wp_Lov_option_tbl;
  L_option_id             varchar2(100) := '%' || I_option_id || '%';
  L_option_desc           varchar2(300) := '%' || upper(I_option_desc) || '%';
  --
  cursor C_get_option is
   select new wp_Lov_option_obj(option_id   => item,
                                option_desc => item_desc)
     from item_master it
    where it.item_level = 1
     and it.item like L_option_id
     and upper(it.item_desc) like L_option_desc;
  --
begin
  --
  open  C_get_option;
  fetch C_get_option bulk collect into L_wp_Lov_option_tbl;
  close C_get_option;
  --
  O_wp_Lov_option_tbl := L_wp_Lov_option_tbl;
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
                                              I_error_key       => 'ERROR_GET_OPTION',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_option;
--------------------------------------------------------------------------------
function get_partner (O_error_message        out varchar2,
                      O_wp_Lov_partner_tbl   out wp_Lov_partner_tbl,
                      I_partner_group        in  store.wf_customer_id%type)
return boolean is
  --
  L_program               varchar2(250) := 'WP_LOV_SQL.GET_PARTNER';
  --
  cursor C_get_partner is
   select new wp_Lov_partner_obj(partner_id   => wfc.wf_customer_id,
                                 partner_desc => wfc.wf_customer_name)
     from wf_customer wfc
    where wfc.wf_customer_group_id = I_partner_group
       or I_partner_group IS NULL;
  --
begin
  --
  open  C_get_partner;
  fetch C_get_partner bulk collect into O_wp_Lov_partner_tbl;
  close C_get_partner;
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
                                              I_error_key       => 'ERROR_GET_PARTNER',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_partner;
--------------------------------------------------------------------------------
function get_partner_location (O_error_message           out varchar2,
                               O_wp_Lov_partner_loc_tbl  out wp_Lov_partner_loc_tbl,
                               I_customer_id             in  store.wf_customer_id%TYPE,
                               I_partner_group           in  wf_customer.wf_customer_group_id%TYPE)
return boolean is
  --
  L_program        varchar2(250) := 'WP_LOV_SQL.GET_PARTNER_LOCATION';
  --
  L_sys_refcur     sys_refcursor;
  L_string_query   Varchar2(20000);
  --
BEGIN
  --
  L_string_query := q'{with t_binds as
                            (select :1  bv_customer_id,
                                    :2  bv_partner_group
                               from dual)
                             select new wp_Lov_partner_loc_obj(partner_loc_id   => st.store,
                                                               partner_loc_desc => st.store_name)
                               from store st,
                                    wf_customer ct,
                                    t_binds b
                              where st.wf_customer_id = ct.wf_customer_id}';
    --
  if I_customer_id is not null then
  --
    L_string_query := L_string_query || q'{ and st.wf_customer_id = b.bv_customer_id}';
    --
    end if;
    --
  if I_partner_group is not null then
  --
    L_string_query := L_string_query || q'{ and ct.wf_customer_group_id = b.bv_partner_group}';
    --
  end if;
  --
  L_string_query := L_string_query || q'{ order by st.store}';
  --
  open L_sys_refcur for L_string_query using in I_customer_id,
                                                I_partner_group;
  --
  fetch L_sys_refcur bulk collect into O_wp_Lov_partner_loc_tbl;
  close L_sys_refcur;
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
                                              I_error_key       => 'ERROR_GET_PARTNER_LOCATION',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_partner_location;
--------------------------------------------------------------------------------
function get_so_type (O_error_message              out varchar2,
                      O_wp_Lov_so_type_tbl     out wp_Lov_so_type_tbl)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_SO_TYPE';
  L_wp_Lov_so_type_tbl        wp_Lov_so_type_tbl;
  --
  cursor C_get_so_type is
   select new wp_Lov_so_type_obj    (value_1   => wsp.value_1,
                                     value_2   => wsp.value_2)
     from wp_system_parameters wsp
     where wsp.func_area = 'SALES_ORDER'
     and wsp.parameter = 'SALES_ORDER_TYPE';
  --
begin
  --
  open  C_get_so_type;
  fetch C_get_so_type bulk collect into L_wp_Lov_so_type_tbl;
  close C_get_so_type;
  --
  O_wp_Lov_so_type_tbl := L_wp_Lov_so_type_tbl;
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
                                              I_error_key       => 'ERROR_GET_SO_TYPE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_so_type;
--------------------------------------------------------------------------------
function get_asos_fcentre (O_error_message              out varchar2,
                           O_wp_Lov_asos_fc_type_tbl    out wp_Lov_asos_fc_type_tbl)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_SO_TYPE';
  L_wp_Lov_asos_fc_type_tbl   wp_Lov_asos_fc_type_tbl;
  --
  cursor C_get_asos_fcentre is
   select new wp_Lov_asos_fc_type_obj    (wh       => wh.wh,
                                          wh_name  => wh.wh_name)
     from wh
     where wh.physical_wh != wh.wh
     and wh.channel_id = 2;
  --
begin
  --
  open  C_get_asos_fcentre;
  fetch C_get_asos_fcentre bulk collect into L_wp_Lov_asos_fc_type_tbl;
  close C_get_asos_fcentre;
  --
  O_wp_Lov_asos_fc_type_tbl := L_wp_Lov_asos_fc_type_tbl;
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
                                              I_error_key       => 'ERROR_GET_ASOS_FCENTRE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_asos_fcentre;
--------------------------------------------------------------------------------
function get_brands (O_error_message              out varchar2,
                     O_wp_Lov_brand_type_tbl    out wp_Lov_brand_type_tbl,
                     I_brand_name                 in varchar2,
                     I_brand_desc                 in varchar2)
return boolean is
  --
  L_program                 varchar2(250) := 'WP_LOV_SQL.GET_BRANDS';
  L_wp_Lov_brand_type_tbl   wp_Lov_brand_type_tbl;
  L_brand_name              varchar2(100) := '%' || upper(I_brand_name) || '%';
  L_brand_desc              varchar2(150) := '%' || upper(I_brand_desc) || '%';
  --
  cursor C_get_brands is
   select new wp_Lov_brand_type_obj    (brand_name  => b.brand_name,
                                        brand_desc  => b.brand_description)
     from brand b
     where upper(b.brand_name) like L_brand_name
     and upper(b.brand_description) like L_brand_desc;
  --
begin
  --
  open  C_get_brands;
  fetch C_get_brands bulk collect into L_wp_Lov_brand_type_tbl;
  close C_get_brands;
  --
  O_wp_Lov_brand_type_tbl := L_wp_Lov_brand_type_tbl;
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
                                              I_error_key       => 'ERROR_GET_BRANDS',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_brands;
--------------------------------------------------------------------------------
function get_hold_level (O_error_message              out varchar2,
                         O_wp_Lov_hold_level_type_tbl    out wp_Lov_hold_level_type_tbl)
return boolean is
  --
  L_program                 varchar2(250) := 'WP_LOV_SQL.GET_HOLD_LEVEL';
  L_wp_Lov_hold_level_type_tbl   wp_Lov_hold_level_type_tbl;
  --
  cursor C_get_hold_level is
    select new wp_Lov_hold_level_type_obj (value_1   => wsp.value_1,
                                           value_2   => wsp.value_2)
      from wp_system_parameters wsp
     where wsp.func_area = 'SALES_ORDER'
      and wsp.parameter = 'HOLD_LEVEL';
  --
begin
  --
  open  C_get_hold_level;
  fetch C_get_hold_level bulk collect into L_wp_Lov_hold_level_type_tbl;
  close C_get_hold_level;
  --
  O_wp_Lov_hold_level_type_tbl := L_wp_Lov_hold_level_type_tbl;
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
                                              I_error_key       => 'ERROR_GET_HOLD_LEVEL',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_hold_level;
--------------------------------------------------------------------------------
function get_so_status (O_error_message              out varchar2,
                        O_wp_Lov_so_status_type_tbl  out wp_Lov_so_status_type_tbl)
return boolean is
  --
  L_program                     varchar2(250) := 'WP_LOV_SQL.GET_SO_STATUS';
  L_wp_Lov_so_status_type_tbl   wp_Lov_so_status_type_tbl;
  --
  cursor C_get_so_status is
    select new wp_Lov_so_status_type_obj (value_1   => wsp.value_1,
                                          value_2   => wsp.value_2)
      from wp_system_parameters wsp
     where wsp.func_area = 'SALES_ORDER'
      and wsp.parameter = 'STATUS';
  --
begin
  --
  open  C_get_so_status;
  fetch C_get_so_status bulk collect into L_wp_Lov_so_status_type_tbl;
  close C_get_so_status;
  --
  O_wp_Lov_so_status_type_tbl := L_wp_Lov_so_status_type_tbl;
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
                                              I_error_key       => 'ERROR_GET_SO_STATUS',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_so_status;
--------------------------------------------------------------------------------------------------
function get_division (O_error_message             out varchar2,
                       O_wp_lov_merch_hier_tbl     out wp_lov_merch_hier_tbl)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_DIVISION';
  L_wp_lov_merch_hier_tbl     wp_lov_merch_hier_tbl;
  --
  cursor C_get_division is
  select new wp_lov_merch_hier_obj(merch_hier_id   => d.division,
                                   merch_hier_name => d.div_name)
    from division d
   order by d.division;
  --
begin
  --
  open  C_get_division;
  fetch C_get_division bulk collect into L_wp_lov_merch_hier_tbl;
  close C_get_division;
  --
  O_wp_lov_merch_hier_tbl := L_wp_lov_merch_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_DIVISION',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_division;
-----------------------------------------------------------------------------------------
function get_product_group (O_error_message             out varchar2,
                            O_wp_lov_merch_hier_tbl     out wp_lov_merch_hier_tbl,
                            I_division                  in  division.division%type)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_PRODUCT_GROUP';
  L_wp_lov_merch_hier_tbl     wp_lov_merch_hier_tbl;
  --
  cursor C_get_product_group is
  select new wp_lov_merch_hier_obj(merch_hier_id   => pg.dept,
                                   merch_hier_name => pg.dept_name)
    from deps pg, groups g
      where g.group_no = g.group_no
        and g.division = I_division
   group by pg.dept,
            pg.dept_name
   order by pg.dept_name;
  --
begin
  --
  open  C_get_product_group;
  fetch C_get_product_group bulk collect into L_wp_lov_merch_hier_tbl;
  close C_get_product_group;
  --
  O_wp_lov_merch_hier_tbl := L_wp_lov_merch_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_PRODUCT_GROUP',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_product_group;
-----------------------------------------------------------------------------------------
function get_category (O_error_message           out varchar2,
                       O_wp_lov_merch_hier_tbl   out wp_lov_merch_hier_tbl,
                       I_division                in  division.division%type,
                       I_product_group           in  deps.dept%type)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_CATEGORY';
  L_wp_lov_merch_hier_tbl     wp_lov_merch_hier_tbl;
  --
  cursor C_get_category is
  select new wp_lov_merch_hier_obj(merch_hier_id   => c.class,
                                   merch_hier_name => c.class_name)
    from class c, groups g
   where g.group_no          = g.group_no
     and g.division          = I_division
     and c.dept              = I_product_group
    group by c.class,
             c.class_name
    order by c.class_name;
  --
begin
  --
  open  C_get_category;
  fetch C_get_category bulk collect into L_wp_lov_merch_hier_tbl;
  close C_get_category;
  --
  O_wp_lov_merch_hier_tbl := L_wp_lov_merch_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_CATEGORY',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_category;
---------------------------------------------------------------------------------------------
function get_sub_category (O_error_message            out varchar2,
                           O_wp_lov_merch_hier_tbl    out wp_lov_merch_hier_tbl,
                           I_division                 in  division.division%type,
                           I_product_group            in  deps.dept%type,
                           I_category                 in  class.class%type)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_SUB_CATEGORY';
  L_wp_lov_merch_hier_tbl     wp_lov_merch_hier_tbl;
  --
  cursor C_get_sub_category is
  select new wp_lov_merch_hier_obj(merch_hier_id   => sc.subclass,
                                   merch_hier_name => sc.sub_name)
    from subclass sc, groups g
   where g.group_no         = g.group_no
     and g.division         = I_division
     and sc.dept            = I_product_group
     and sc.class           = I_category
   group by sc.subclass,
            sc.sub_name
    order by sc.sub_name;
  --
begin
  --
  open  C_get_sub_category;
  fetch C_get_sub_category bulk collect into L_wp_lov_merch_hier_tbl;
  close C_get_sub_category;
  --
  O_wp_lov_merch_hier_tbl := L_wp_lov_merch_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_SUB_CATEGORY',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_sub_category;
--------------------------------------------------------------------------------------------------
function get_business_model (O_error_message            out varchar2,
                             O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_BUSINESS_MODEL';
  L_wp_lov_buy_hier_tbl       wp_lov_buy_hier_tbl;
  --
  cursor C_get_business_model is
   select new wp_lov_buy_hier_obj(buy_hier_id   => bm.business_model,
                                  buy_hier_name => bm.business_model_name)
     from ma_business_model bm
   order by bm.business_model;
  --
begin
  --
  open  C_get_business_model;
  fetch C_get_business_model bulk collect into L_wp_lov_buy_hier_tbl;
  close C_get_business_model;
  --
  O_wp_lov_buy_hier_tbl := L_wp_lov_buy_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_BUSINESS_MODEL',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_business_model;
--------------------------------------------------------------------------------------------------
function get_buying_group (O_error_message            out varchar2,
                           O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl,
                           I_business_model           in  ma_business_model.business_model%type)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_BUYING_GROUP';
  L_wp_lov_buy_hier_tbl       wp_lov_buy_hier_tbl;
  --
  cursor C_get_buying_group is
  select new wp_lov_buy_hier_obj(buy_hier_id   => bg.buying_group,
                                 buy_hier_name => bg.buying_group_name)
    from ma_buying_group bg
   where bg.business_model  = I_business_model
  group by bg.buying_group,
           bg.buying_group_name
  order by bg.buying_group_name;
  --
begin
  --
  open  C_get_buying_group;
  fetch C_get_buying_group bulk collect into L_wp_lov_buy_hier_tbl;
  close C_get_buying_group;
  --
  O_wp_lov_buy_hier_tbl := L_wp_lov_buy_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_BUYING_GROUP',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_buying_group;
--------------------------------------------------------------------------------------------------
function get_buying_subgroup (O_error_message            out varchar2,
                              O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl,
                              I_business_model           in  ma_business_model.business_model%type,
                              I_buying_group             in  ma_buying_group.buying_group%type)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_BUYING_SUBGROUP';
  L_wp_lov_buy_hier_tbl       wp_lov_buy_hier_tbl;
  --
  cursor C_get_buying_subgroup is
  select new wp_lov_buy_hier_obj(buy_hier_id   => bsg.buying_subgroup,
                                 buy_hier_name => bsg.buying_subgroup_name)
    from ma_buying_subgroup bsg
   where bsg.business_model  = I_business_model
     and bsg.buying_group    = I_buying_group
   group by bsg.buying_subgroup,
            bsg.buying_subgroup_name
   order by bsg.buying_subgroup_name;
  --
begin
  --
  open  C_get_buying_subgroup;
  fetch C_get_buying_subgroup bulk collect into L_wp_lov_buy_hier_tbl;
  close C_get_buying_subgroup;
  --
  O_wp_lov_buy_hier_tbl := L_wp_lov_buy_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_BUYING_SUBGROUP',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_buying_subgroup;
--------------------------------------------------------------------------------------------------
function get_buying_set (O_error_message            out varchar2,
                         O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl,
                         I_business_model           in  ma_business_model.business_model%type,
                         I_buying_group             in  ma_buying_group.buying_group%type,
                         I_buying_subgroup          in  ma_buying_subgroup.buying_subgroup%type)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_BUYING_SET';
  L_wp_lov_buy_hier_tbl       wp_lov_buy_hier_tbl;
  --
  cursor C_get_buying_set is
  select new wp_lov_buy_hier_obj(buy_hier_id   => bs.buying_set,
                                 buy_hier_name => bs.buying_set_name)
    from ma_buying_set bs
   where bs.business_model          = I_business_model
     and bs.buying_group            = I_buying_group
     and bs.buying_subgroup         = I_buying_subgroup
   group by bs.buying_set,
            bs.buying_set_name
   order by bs.buying_set_name;
  --
begin
  --
  open  C_get_buying_set;
  fetch C_get_buying_set bulk collect into L_wp_lov_buy_hier_tbl;
  close C_get_buying_set;
  --
  O_wp_lov_buy_hier_tbl := L_wp_lov_buy_hier_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_BUYING_SET',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_buying_set;
--------------------------------------------------------------------------------
function get_partner_group (O_error_message                  out varchar2,
                            O_wp_Lov_partner_group_tbl  out wp_Lov_partner_group_type_tbl,
                            I_partner_group_id               in  number,
                            I_partner_group_name             in  varchar2)
return boolean is
  --
  L_program                          varchar2(250) := 'WP_LOV_SQL.GET_PARTNER_GROUP';
  L_wp_Lov_partner_group_tbl         wp_Lov_partner_group_type_tbl;
  L_partner_group_id                 varchar2(100) := '%' || I_partner_group_id || '%';
  L_partner_group_name               varchar2(150) := '%' || upper(I_partner_group_name) || '%';
  --
  cursor C_get_partner_group is
   select new wp_Lov_partner_group_type_obj(partner_group_id   => wf_customer_group_id,
                                            partner_group_name => wf_customer_group_name)
     from wf_customer_group wfg
    where wfg.wf_customer_group_id like L_partner_group_id
     and upper(wfg.wf_customer_group_name) like L_partner_group_name;
  --
begin
  --
  open  C_get_partner_group;
  fetch C_get_partner_group bulk collect into L_wp_Lov_partner_group_tbl;
  close C_get_partner_group;
  --
  O_wp_Lov_partner_group_tbl := L_wp_Lov_partner_group_tbl;
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
                                              I_error_key       => 'ERROR_GET_PARTNER_GROUP',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_partner_group;
--------------------------------------------------------------------------------
function get_freight_type(O_error_message            out varchar2,
                          O_wp_lov_freight_type_tbl  out wp_lov_freight_type_tbl)
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_FREIGHT_TYPE';
  L_wp_lov_freight_type_tbl   wp_lov_freight_type_tbl;
  --
  cursor C_get_freight is
  select new wp_lov_freight_type_obj(freight_id   => wp.value_1,
                                     freight_desc => wp.value_2)
    from wp_system_parameters wp
   where wp.func_area = 'FREIGHT'
     and wp.parameter = 'FREIGHT_TYPE';
  --
begin
  --
  open  C_get_freight;
  fetch C_get_freight bulk collect into L_wp_lov_freight_type_tbl;
  close C_get_freight;
  --
  O_wp_lov_freight_type_tbl := L_wp_lov_freight_type_tbl;
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
                                              I_error_key       => 'ERROR_LOV_GET_FREIGHT_TYPE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_freight_type;
--------------------------------------------------------------------------------
function get_re_option (O_error_message                  out varchar2,
                        O_wp_Lov_option_tbl              out wp_Lov_option_tbl,
                        I_order_no                       in  number)
return boolean is
  --
  L_program                          varchar2(250) := 'WP_LOV_SQL.GET_PARTNER_GROUP';
  L_wp_Lov_option_tbl                wp_Lov_option_tbl;
  /*L_partner_group_id                 varchar2(100) := '%' || I_partner_group_id || '%';
  L_partner_group_name               varchar2(150) := '%' || upper(I_partner_group_name) || '%';*/
  --
  cursor C_get_re_option is
   select new wp_Lov_option_obj(option_id   => i.item_parent,
                                option_desc => i.item_desc)
     from wp_order_head woh,
          wp_order_detail wpd,
          item_master i
    where woh.sales_order_no = wpd.sales_order_no
     and i.item = wpd.item
     and woh.order_no = I_order_no
    group by i.item_parent, i.item_desc;
  --
begin
  --
  open  C_get_re_option;
  fetch C_get_re_option bulk collect into L_wp_Lov_option_tbl;
  close C_get_re_option;
  --
  O_wp_Lov_option_tbl  := L_wp_Lov_option_tbl ;
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
                                              I_error_key       => 'ERROR_GET_RE_OPTION',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_re_option;
--------------------------------------------------------------------------------
function get_re_partner (O_error_message          out varchar2,
                         O_wp_Lov_partner_tbl     out wp_Lov_partner_tbl,
                         I_order_no             in  number,
                         I_option_id           in  varchar2)
return boolean is
  --
  L_program               varchar2(250) := 'WP_LOV_SQL.GET_PARTNER';
  L_wp_Lov_partner_tbl    wp_Lov_partner_tbl;
  /*L_partner_id             varchar2(100) := '%' || I_partner_id || '%';
  L_partner_desc           varchar2(150) := '%' || upper(I_partner_desc) || '%';*/
  --
  cursor C_get_re_partner is
   select new wp_Lov_partner_obj(partner_id   => wf_customer_id,
                                 partner_desc => wf_customer_name)
     from wp_order_head woh,
          wp_order_detail wod,
          wf_customer w
    where woh.sales_order_no = wod.sales_order_no
     and woh.customer_id = w.wf_customer_id
     and woh.order_no = I_order_no
     and wod.item in (select item from item_master where item_parent = I_option_id)
     group by wf_customer_id,wf_customer_name;
  --
begin
  --
  open  C_get_re_partner;
  fetch C_get_re_partner bulk collect into L_wp_Lov_partner_tbl;
  close C_get_re_partner;
  --
  O_wp_Lov_partner_tbl := L_wp_Lov_partner_tbl;
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
                                              I_error_key       => 'ERROR_GET_RE_PARTNER',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_re_partner;
--------------------------------------------------------------------------------
function get_brand_size (O_error_message       out varchar2,
                         O_wp_Lov_Brand_Tbl    out wp_Lov_Brand_Tbl,
                         I_option_id           in varchar2)
return boolean is
  --
  L_program            varchar2(250) := 'WP_LOV_SQL.GET_BRAND_SIZE';
  L_wp_Lov_Brand_Tbl   wp_Lov_Brand_Tbl;
  --
  cursor C_get_sizes is
   select new wp_Lov_Brand_obj (s.diff_id_uk)
     from wp_v_r_option_size_code s
     where s.option_id = I_option_id;
  --
begin
  --
  open  C_get_sizes;
  fetch C_get_sizes bulk collect into L_wp_Lov_Brand_Tbl;
  close C_get_sizes;
  --
  O_wp_Lov_Brand_Tbl := L_wp_Lov_Brand_Tbl;
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
                                              I_error_key       => 'ERROR_GET_BRAND_SIZE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_brand_size;
--------------------------------------------------------------------------------
function get_partner_dc (O_error_message             out varchar2,
                         O_wp_Lov_partner_dc_tbl     out wp_lov_partner_dc_tbl,
                         I_sales_order_no            in  number )
return boolean is
  --
  L_program                   varchar2(250) := 'WP_LOV_SQL.GET_PARTNER_DC';
  L_wp_Lov_partner_dc_tbl     wp_lov_partner_dc_tbl;
  --
  cursor C_get_partner_c is
   select new wp_lov_partner_dc_obj (PARTNER_DC_ID   => wc.partner_dc_id,
                                     PARTNER_DC_DESC => wc.partner_dc_desc)
     from wp_order_detail          wod,
          wp_customer_dc_st_link   wc
    where wod.sales_order_no = I_sales_order_no
      and wc.customer_loc    = wod.customer_loc
     group by wc.partner_dc_id, wc.partner_dc_desc;
  --
begin
  --
  open  C_get_partner_c;
  fetch C_get_partner_c bulk collect into L_wp_Lov_partner_dc_tbl;
  close C_get_partner_c;
  --
  O_wp_Lov_partner_dc_tbl := L_wp_Lov_partner_dc_tbl;
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
                                              I_error_key       => 'ERROR_GET_PARTNER_DC',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_partner_dc;
--------------------------------------------------------------------------------
function get_partner_store (O_error_message             out varchar2,
                            O_wp_Lov_partner_store_tbl  out wp_lov_partner_store_tbl,
                            I_sales_order_no            in  number ,
                            I_partner_dc_id             in  VARCHAR2
                            )
return boolean is
  --
  L_program                    varchar2(250) := 'WP_LOV_SQL.GET_PARTNER_DC';
  L_wp_Lov_partner_store_tbl   wp_lov_partner_store_tbl;
  --
  cursor C_get_partner_c is
   select new wp_lov_partner_store_obj (PARTNER_STORE_ID   => wc.partner_store_id,
                                        PARTNER_STORE_DESC => wc.partner_store_desc)
     from wp_order_detail          wod,
          wp_customer_dc_st_link   wc
    where wc.customer_loc    = wod.customer_loc
      and wod.sales_order_no = I_sales_order_no
      and wc.partner_dc_id   = I_partner_dc_id
     group by wc.partner_store_id, wc.partner_store_desc;
  --
begin
  --
  open  C_get_partner_c;
  fetch C_get_partner_c bulk collect into L_wp_Lov_partner_store_tbl;
  close C_get_partner_c;
  --
  O_wp_Lov_partner_store_tbl := L_wp_Lov_partner_store_tbl;
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
                                              I_error_key       => 'ERROR_GET_PARTNER_STORE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_partner_store;
--------------------------------------------------------------------------------
function get_upload_templates (O_error_message             out varchar2,
                               O_wp_upload_template_tbl    out wp_upload_template_tbl)
return boolean is
  --
  L_program                    varchar2(250) := 'WP_LOV_SQL.GET_UPLOAD_TEMPLATES';
  L_wp_upload_template_tbl     wp_upload_template_tbl;
  --
  L_templates                  ORCA_S9T_TEMPLATE_TBL;
  L_template_type              ORCA_S9T_TEMPLATE.TEMPLATE_TYPE%TYPE := null;
  --
  cursor C_get_upload_templates is
    select new wp_upload_template_obj(template_key  => t.template_key,
                                      template_name => t.template_name)
      from table(L_templates) t;
  --
begin
  --
  if ORCA_S9T_SQL.GET_TEMPLATES(o_error_message  => o_error_message,
                                o_templates      => L_templates,
                                i_template_type  => L_template_type
                               ) = FALSE THEN
     return false;
  end if;
  --
  open  C_get_upload_templates;
  fetch C_get_upload_templates bulk collect into L_wp_upload_template_tbl;
  close C_get_upload_templates;
  --
  O_wp_upload_template_tbl := L_wp_upload_template_tbl;
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
                                              I_error_key       => 'ERROR_GET_UPLOAD_TEMPLATES',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
  --
  return false;
  --
end get_upload_templates;
--------------------------------------------------------------------------------
end wp_lov_sql;
/