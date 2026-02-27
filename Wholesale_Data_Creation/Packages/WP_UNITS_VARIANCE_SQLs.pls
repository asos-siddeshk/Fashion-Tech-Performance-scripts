create or replace package wp_units_variance_sql is
 --------------------------------------------------------------------------------
function sales_order_head_search (O_error_message       out varchar2,
                                  O_wpSalesOrderHeadTbl out wpSalesOrderHeadTbl,
                                  I_sales_order_no      in  wp_order_head.sales_order_no%type default null,
                                  I_order_no            in wp_order_head.order_no%type default null,
                                  I_order_row_code      in wp_order_head.order_row_code%type default null,
                                  I_qty_variance        in number default null,
                                  I_customer_id         in wf_customer.wf_customer_id%type default null,
                                  I_customer_loc        in store.store%type default null,
                                  I_option_id           in wp_order_detail.item%type default null,
                                  I_despatch_month      in varchar2 default null,
								                  I_current_start_date  in varchar2 default null,
                                  I_current_end_date    in varchar2 default null,
                                  I_carrier_booking     in varchar2 default null,
                                  I_business_model      in number   default null)
return boolean;
--------------------------------------------------------------------------------
function sales_order_dtl_search (O_error_message         out varchar2,
                                 O_wpSalesOrderDetailTbl out wpSalesOrderDetailTbl,
                                 I_order_no              in  wp_order_head.order_no%type,
                                 I_first_dest            in  number,
                                 I_final_dest            in  number,
                                 I_offset                in  number,
                                 I_limit                 in  number)
return boolean;
--------------------------------------------------------------------------------
function sales_order_CA_dtl_search (O_error_message                out varchar2,
                                    O_wp_units_variance_CA_dtl_tbl out wp_units_variance_CA_dtl_tbl,
                                    I_sales_order_no               in  wp_order_head.sales_order_no%type,
                                    I_customer_id                  in  wp_order_head.customer_id%type,
                                    I_customer_loc                 in  wp_order_detail.customer_loc%type,
                                    I_current_despatch_month       in  varchar2,
                                    I_option_id                    in  wp_order_detail.item%type,
                                    I_final_dest                   in  number)
return boolean;
--------------------------------------------------------------------------------
function sales_order_export  (O_error_message                out varchar2,
                              O_wp_units_variance_export_tbl out wp_units_variance_export_tbl,
                              I_sales_order_no               in  wp_order_head.sales_order_no%type default null,
                              I_order_no                     in  wp_order_head.order_no%type default null,
                              I_order_row_code               in  wp_order_head.order_row_code%type default null,
                              I_qty_variance                 in  number default null,
                              I_customer_id                  in  wf_customer.wf_customer_id%type default null,
                              I_customer_loc                 in  store.store%type default null,
                              I_option_id                    in  wp_order_detail.item%type default null,
                              I_despatch_month               in  varchar2 default null,
                              I_current_start_date           in  varchar2 default null,
                              I_current_end_date             in  varchar2 default null,
                              I_carrier_booking              in  varchar2 default null,
                              I_business_model               in  number   default null)
return boolean;
--------------------------------------------------------------------------------
end wp_units_variance_sql;
/
