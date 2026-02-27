create or replace package wp_redistribute_po_sql is
--------------------------------------------------------------------------------
function redistribute_po_search (O_error_message            out varchar2,
                                 O_wp_redistribute_tbl      out wp_redistribute_tbl,
                                 I_order_no                 in  wp_order_head.order_no%type,
                                 I_view_mode                in  varchar2 default 'N')
return boolean;
--------------------------------------------------------------------------------
function redistribute_dtl_search (O_error_message           out varchar2,
                                  O_wp_distribution_dtl_tbl out wp_distribution_dtl_tbl,
								                  I_order_no                in  wp_order_head.order_no%type,
                                  I_option_id               in  item_master.item%type,
                                  I_customer_id             in  wf_customer.wf_customer_id%type default null,
                                  I_size_code               in  varchar2 default null,
                                  I_view_mode               in  varchar2 default 'N')
return boolean;
--------------------------------------------------------------------------------
function redistribute_so_dtl_search (O_error_message              out varchar2,
                                     O_wp_redistribute_so_dtl_tbl out wp_redistribute_so_dtl_tbl,
                                     I_order_no                   in  wp_order_head.order_no%type,
                                     I_option_id                  in  item_master.item%type,
                                     I_customer_id                in  wf_customer.wf_customer_id%type default null,
                                     I_size_code                  in  varchar2 default null,
                                     I_view_mode                  in  varchar2 default 'N')
return boolean;
--------------------------------------------------------------------------------
function redistribute_save (O_error_message              out varchar2,
                             I_wp_redistribute_so_dtl_tbl in  wp_redistribute_so_dtl_tbl,
                             I_order_no                   in  wp_order_head.order_no%type,
                             I_option_id                  in  item_master.item%type)
return boolean;
--------------------------------------------------------------------------------
function auto_redistribute (O_error_message                   out varchar2,
                            O_wp_redistribute_auto_button_tbl out wp_redistribute_auto_button_tbl,
                            I_order_no                        in  wp_order_head.order_no%type)
return boolean;
--------------------------------------------------------------------------------
function save_auto_distribute (O_error_message                   out varchar2,
                               O_wp_redistribute_error_tbl       out wp_redistribute_error_tbl,
                               I_wp_redistribute_auto_button_tbl in  wp_redistribute_auto_button_tbl,
                               I_order_no                        in  wp_order_head.order_no%type)
return boolean;
--------------------------------------------------------------------------------
function get_view_mode_ind (O_error_message out varchar2,
                            O_view_mode_ind out varchar2,
                            I_order_no      in  wp_order_head.order_no%type)
return boolean;
--------------------------------------------------------------------------------
end wp_redistribute_po_sql;
/