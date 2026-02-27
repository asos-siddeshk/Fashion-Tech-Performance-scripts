create or replace package wp_post_receipt_uv_sql is
--------------------------------------------------------------------------------
function post_receipt_uv_head_search (O_error_message                    out varchar2,
                                      O_wp_post_receipt_uv_head_tbl      out wp_post_receipt_uv_head_tbl,
                                      I_sales_order_no                   in  wp_order_head.sales_order_no%type default null,
                                      I_order_no                         in  wp_order_head.order_no%type default null,
                                      I_order_row_code                   in  wp_order_head.order_row_code%type default null,
                                      I_customer_id                      in  wf_customer.wf_customer_id%type default null,
                                      I_customer_loc                     in  store.store%type default null,
                                      I_option_id                        in  wp_order_detail.item%type default null,
                                      I_despatch_month                   in  varchar2 default null,
                                      I_current_start_date               in  varchar2 default null,
                                      I_current_end_date                 in  varchar2 default null,
                                      I_variance                         in  number default null,
                                      I_first_receipt_days_min           in  number default null,
                                      I_first_receipt_days_max           in  number default null,
                                      I_business_model                   in  number default null)
return boolean;
--------------------------------------------------------------------------------
function post_receipt_uv_dtl_search (O_error_message              out varchar2,
                                     O_wp_post_receipt_uv_dtl_tbl out wp_post_receipt_uv_dtl_tbl,
                                     I_order_no                   in  wp_order_head.order_no%type,
                                     I_first_dest                 in  number,
                                     I_final_dest                 in  number,
                                     I_offset                     in  number,
                                     I_limit                      in  number)
return boolean;
--------------------------------------------------------------------------------
function post_receipt_uv_export  (O_error_message           out varchar2,
                                  O_wp_puv_export_tbl       out wp_puv_export_tbl,
                                  I_sales_order_no          in  wp_order_head.sales_order_no%type default null,
                                  I_order_no                in  wp_order_head.order_no%type default null,
                                  I_order_row_code          in  wp_order_head.order_row_code%type default null,
                                  I_customer_id             in  wf_customer.wf_customer_id%type default null,
                                  I_customer_loc            in  store.store%type default null,
                                  I_option_id               in  wp_order_detail.item%type default null,
                                  I_despatch_month          in  varchar2 default null,
                                  I_current_start_date      in  varchar2 default null,
                                  I_current_end_date        in  varchar2 default null,
                                  I_variance                in  number default null,
                                  I_first_receipt_days_min  in  number default null,
                                  I_first_receipt_days_max  in  number default null,
                                  I_business_model          in  number default null)
return boolean;
--------------------------------------------------------------------------------
end wp_post_receipt_uv_sql;
/