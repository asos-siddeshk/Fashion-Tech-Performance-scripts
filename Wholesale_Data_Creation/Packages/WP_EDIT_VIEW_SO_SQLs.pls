create or replace package WP_EDIT_VIEW_SO_SQL is
--------------------------------------------------------------------------------
function sales_order_head_search (O_error_message                 out varchar2,
                                  O_wp_sales_order_head_tbl       out WP_EDIT_VIEW_SO_HEAD_TBL,
                                  O_view_mode                     out varchar2,
                                  O_edit_partner_st_req_ind       out wp_customer_attrib.partner_st_req_ind%type,
                                  O_edit_partner_order_ind        out wp_customer_attrib.partner_order_ind%type,
                                  O_edit_partner_dept_ind         out wp_customer_attrib.partner_dept_ind %type,
                                  I_sales_order_no                in  wp_order_head.sales_order_no%type
                                  )
return boolean;
-------------------------------------------------------------------------------- 
function sales_order_dtl_search (O_error_message                 out varchar2,
                                 O_wp_sales_order_dtl_tbl        out WP_EDIT_VIEW_SO_DTL_TBL,
                                 I_sales_order_no                in  wp_order_head.sales_order_no%type
                                 )
return boolean;
--------------------------------------------------------------------------------
function update_sales_order (O_error_message                 out varchar2,
                             I_wp_sales_order_head_tbl       in WP_EDIT_VIEW_SO_HEAD_TBL
                             )
return boolean;
--------------------------------------------------------------------------------
end WP_EDIT_VIEW_SO_SQL;
/
