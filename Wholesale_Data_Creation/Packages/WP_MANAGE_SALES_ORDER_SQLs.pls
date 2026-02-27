create or replace package wp_manage_sales_order_sql is
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
return boolean;
--------------------------------------------------------------------------------
function apply_hold_flag (O_error_message        out varchar2,
                          O_wp_manage_so_errors_tbl out wp_manage_so_errors_tbl,
                          I_sales_order_tbl      in  wp_sales_order_no_tbl)
return boolean;
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
return boolean;
--------------------------------------------------------------------------------
end wp_manage_sales_order_sql;
/