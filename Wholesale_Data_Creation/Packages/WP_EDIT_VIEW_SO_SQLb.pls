create or replace package body WP_EDIT_VIEW_SO_SQL is
--------------------------------------------------------------------------------
function sales_order_head_search (O_error_message                 out varchar2,
                                  O_wp_sales_order_head_tbl       out WP_EDIT_VIEW_SO_HEAD_TBL,
                                  O_view_mode                     out varchar2,
                                  O_edit_partner_st_req_ind       out wp_customer_attrib.partner_st_req_ind%type,
                                  O_edit_partner_order_ind        out wp_customer_attrib.partner_order_ind%type,
                                  O_edit_partner_dept_ind         out wp_customer_attrib.partner_dept_ind %type,
                                  I_sales_order_no                in  wp_order_head.sales_order_no%type
                                  )
return boolean is
  --
  L_program                    varchar2(250) := 'WP_EDIT_VIEW_SO_SQL.SALES_ORDER_HEAD_SEARCH';
  L_string_query               varchar2(20000);
  L_wp_so_head_tbl             WP_EDIT_VIEW_SO_HEAD_TBL;
  L_sys_refcur                 sys_refcursor; 
  L_mask_date                  varchar2(15) := GLOBAL_VARS_SQL.G_wp_uk_date;
  L_view_mode                  varchar2(1)  := 'N';
  --
  L_partner_st_req_ind         wp_customer_attrib.partner_st_req_ind%type := null;
  L_partner_order_ind          wp_customer_attrib.partner_order_ind%type  := null;
  L_partner_dept_ind           wp_customer_attrib.partner_dept_ind %type  := null ;
  --                            
  -- mandatory partner_store_id and partner_dc_id, partner_po, partner_dept_no
  cursor C_check_partner_mandatory (I_customer_id in wp_customer_attrib.customer_id%type) is 
    select ca.partner_st_req_ind, 
           ca.partner_order_ind,
           ca.partner_dept_ind
      from wp_customer_attrib ca
     where  ca.customer_id  = I_customer_id;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no 
                            , :2 bv_mask
                         from dual)
                      select new WP_EDIT_VIEW_SO_HEAD_OBJ ( sales_order_no             ,
                                                            partner_id                 ,
                                                            partner_name               ,
                                                            partner_loc_id             ,
                                                            partner_loc_name           ,
                                                            order_row_code             ,
                                                            sales_order_type           ,
                                                            sales_order_comments       ,
                                                            sales_order_source         ,
                                                            Suplier_PO                 ,
                                                            First_Destination          ,
                                                            Final_Destination          ,
                                                            ASN                        , 
                                                            to_char(first_dest_delivery_date, b.bv_mask)   ,
                                                            to_char(final_dest_delivery_date, b.bv_mask)   ,
                                                            to_char(Latest_ASN_Delivery_Date, b.bv_mask)   ,
                                                            to_char(Latest_ASN_Receipt_Date,  b.bv_mask)   ,
                                                            Final_Dest_despatch_Month  ,
                                                            Original_Despatch_Month    ,
                                                            current_despatch_month     ,
                                                            sales_order_status         ,
                                                            sales_order_status_desc    ,
                                                            release_ind                , 
                                                            to_char(release_date , b.bv_mask)   ,
                                                            currency_code              ,
                                                            freight                    ,
                                                            hold_flag                  ,
                                                            hold_level                 ,
                                                            partner_po                 ,
                                                            partner_dept_no            ,
                                                            partner_dc_id              ,
                                                            partner_dc_id_name         ,
                                                            partner_store_id           ,
                                                            partner_store_name         
                                                           )
                         from WP_V_EDIT_VIEW_SO_HEAD whv,
                              t_binds b
                        where  whv.sales_order_no = b.bv_sales_order_no }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no , L_mask_date;
  --
  fetch L_sys_refcur bulk collect into L_wp_so_head_tbl;
  close L_sys_refcur;
  -- 
  for X in 1..L_wp_so_head_tbl.count loop
    --
    L_view_mode := 'N';
    if L_wp_so_head_tbl(x).release_ind = 'Y' 
       or L_wp_so_head_tbl(x).Sales_order_status in ( 'C', 'D', 'P') 
    then
      L_view_mode :=  'Y';
    end if;
    -- Check mandatory partner_store_id, partner_dc_id, partner_po, partner_dept_ind
    --
    open  C_check_partner_mandatory (L_wp_so_head_tbl(x).partner_id);
    fetch C_check_partner_mandatory into L_partner_st_req_ind, 
                                         L_partner_order_ind, 
                                         L_partner_dept_ind;
    close C_check_partner_mandatory;
    --
    O_edit_partner_st_req_ind := nvl(L_partner_st_req_ind, 'N');
    O_edit_partner_order_ind  := nvl(L_partner_order_ind, 'N');
    O_edit_partner_dept_ind   := nvl(L_partner_dept_ind, 'N');
    --                                  
  end loop;
  --
  O_view_mode := nvl(L_view_mode, 'N');
  
  O_wp_sales_order_head_tbl := L_wp_so_head_tbl;
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
function sales_order_dtl_search (O_error_message                 out varchar2,
                                 O_wp_sales_order_dtl_tbl        out WP_EDIT_VIEW_SO_DTL_TBL,
                                 I_sales_order_no                in  wp_order_head.sales_order_no%type
                                 )
return boolean is
  --
  L_program                    varchar2(250) := 'WP_EDIT_VIEW_SO_SQL.SALES_ORDER_DTL_SEARCH';
  L_string_query               varchar2(20000);
  L_wp_so_dtl_tbl              WP_EDIT_VIEW_SO_DTL_TBL;
  L_sys_refcur                 sys_refcursor; 
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_sales_order_no 
                         from dual)
                      select new WP_EDIT_VIEW_SO_DTL_OBJ ( sales_order_no, 
                                                           option_id, 
                                                           option_desc, 
                                                           sku, 
                                                           brand_size, 
                                                           final_dest_po_units, 
                                                           final_dest_receipted_units, 
                                                           sales_order_units_original, 
                                                           sales_order_units_current, 
                                                           despatched_units, 
                                                           partner_cp
                                                         )
                         from WP_V_EDIT_VIEW_SO_DTL wdv,
                              t_binds b
                        where wdv.sales_order_no = b.bv_sales_order_no }';
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_sales_order_no ;
  --
  fetch L_sys_refcur bulk collect into L_wp_so_dtl_tbl;
  close L_sys_refcur;
  --
  O_wp_sales_order_dtl_tbl := L_wp_so_dtl_tbl;
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
function update_sales_order (O_error_message                 out varchar2,
                             I_wp_sales_order_head_tbl       in  WP_EDIT_VIEW_SO_HEAD_TBL 
                             )
return boolean is
  --
  L_program                    varchar2(250) := 'WP_EDIT_VIEW_SO_SQL.UPDATE_SALES_ORDER'; 
  --
begin  
  --
 
  merge into wp_order_head h
  using (select tbl.sales_order_no
              , tbl.hold_flag
              , tbl.partner_po 
              , tbl.partner_dept_no
           from table(I_wp_sales_order_head_tbl) tbl) s
     on (h.sales_order_no = s.sales_order_no)
  when matched then
    update set h.hold_ind             = s.hold_flag
             , h.partner_order_no     = s.partner_po 
             , h.partner_dept_no      = s.partner_dept_no
             , h.last_update_id       = get_app_user
             , h.last_update_datetime = sysdate
    ;
    -- 
  merge into wp_order_detail d
  using (select tbl.sales_order_no
              , tbl.partner_dc_id
              , tbl.partner_store_id
           from table(I_wp_sales_order_head_tbl) tbl) s
     on (d.sales_order_no = s.sales_order_no)
  when matched then
    update set 
               d.partner_dc_id        = s.partner_dc_id
             , d.partner_store_id     = s.partner_store_id
             , d.last_update_id       = get_app_user
             , d.last_update_datetime = sysdate
    ; 
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
                                            I_error_key       => 'ERROR_UPDATE_SALES_ORDER',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end update_sales_order;
--------------------------------------------------------------------------------
end WP_EDIT_VIEW_SO_SQL;
/
