create or replace package wp_sales_order_release_sql is
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
return boolean;
--------------------------------------------------------------------------------
function release_sales_order (O_error_message            out varchar2,
                              O_wp_sor_errors_tbl        out wp_sor_errors_tbl,
                              I_sales_order              in  wp_number_tbl,
                              I_freight                  in  varchar2)
return boolean;
--------------------------------------------------------------------------------
function validate_so_already_release (O_error_message            out varchar2,
                                      O_wp_sor_errors_tbl        out wp_sor_errors_tbl,
                                      I_sales_order              in  wp_number_tbl)
return boolean;
--------------------------------------------------------------------------------
end wp_sales_order_release_sql;
/