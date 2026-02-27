create or replace package wp_lov_sql is
--------------------------------------------------------------------------------
function get_sales_order_no (O_error_message             out varchar2,
                             O_wp_Lov_Sales_Order_No_Tbl out wp_Lov_Sales_Order_No_Tbl,
                             I_sales_order_no            in  number)
return boolean;
--------------------------------------------------------------------------------
function get_po_number (O_error_message            out varchar2,
                           O_wp_Lov_Po_Number_Tbl     out wp_Lov_Po_Number_Tbl,
                           I_po_number                in  number)
return boolean;
--------------------------------------------------------------------------------
function get_order_row_code (O_error_message                 out varchar2,
                                O_wp_Lov_Order_Row_Code_Tbl     out wp_Lov_Order_Row_Code_Tbl,
                                I_order_row_code                in  varchar2)
return boolean;
--------------------------------------------------------------------------------
function get_option (O_error_message         out varchar2,
                        O_wp_Lov_option_tbl     out wp_Lov_option_tbl,
                        I_option_id             in  varchar2,
                        I_option_desc           in  varchar2)
return boolean;
--------------------------------------------------------------------------------
function get_partner (O_error_message          out varchar2,
                      O_wp_Lov_partner_tbl     out wp_Lov_partner_tbl,
                      I_partner_group          in  store.wf_customer_id%type)
return boolean;
--------------------------------------------------------------------------------
function get_partner_location (O_error_message           out varchar2,
                               O_wp_Lov_partner_loc_tbl  out wp_Lov_partner_loc_tbl,
                               I_customer_id             in  store.wf_customer_id%TYPE,
                               I_partner_group           in  wf_customer.wf_customer_group_id%TYPE)
return boolean;
--------------------------------------------------------------------------------
function get_so_type (O_error_message              out varchar2,
                      O_wp_Lov_so_type_tbl     out wp_Lov_so_type_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_asos_fcentre (O_error_message              out varchar2,
                           O_wp_Lov_asos_fc_type_tbl    out wp_Lov_asos_fc_type_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_brands (O_error_message              out varchar2,
                     O_wp_Lov_brand_type_tbl    out wp_Lov_brand_type_tbl,
                     I_brand_name                 in varchar2,
                     I_brand_desc                 in varchar2)
return boolean;
--------------------------------------------------------------------------------
function get_hold_level (O_error_message              out varchar2,
                         O_wp_Lov_hold_level_type_tbl out wp_Lov_hold_level_type_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_so_status (O_error_message              out varchar2,
                        O_wp_Lov_so_status_type_tbl  out wp_Lov_so_status_type_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_division (O_error_message             out varchar2,
                       O_wp_lov_merch_hier_tbl     out wp_lov_merch_hier_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_product_group (O_error_message             out varchar2,
                            O_wp_lov_merch_hier_tbl     out wp_lov_merch_hier_tbl,
                            I_division                  in  division.division%type)
return boolean;
--------------------------------------------------------------------------------
function get_category (O_error_message           out varchar2,
                       O_wp_lov_merch_hier_tbl   out wp_lov_merch_hier_tbl,
                       I_division                in  division.division%type,
                       I_product_group           in  deps.dept%type)
return boolean;
--------------------------------------------------------------------------------
function get_sub_category (O_error_message            out varchar2,
                           O_wp_lov_merch_hier_tbl    out wp_lov_merch_hier_tbl,
                           I_division                 in  division.division%type,
                           I_product_group            in  deps.dept%type,
                           I_category                 in  class.class%type)
return boolean;
--------------------------------------------------------------------------------
function get_business_model (O_error_message            out varchar2,
                             O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_buying_group (O_error_message            out varchar2,
                           O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl,
                           I_business_model           in  ma_business_model.business_model%type)
return boolean;
--------------------------------------------------------------------------------
function get_buying_subgroup (O_error_message            out varchar2,
                              O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl,
                              I_business_model           in  ma_business_model.business_model%type,
                              I_buying_group             in  ma_buying_group.buying_group%type)
return boolean;
--------------------------------------------------------------------------------
function get_buying_set (O_error_message            out varchar2,
                         O_wp_lov_buy_hier_tbl      out wp_lov_buy_hier_tbl,
                         I_business_model           in  ma_business_model.business_model%type,
                         I_buying_group             in  ma_buying_group.buying_group%type,
                         I_buying_subgroup          in  ma_buying_subgroup.buying_subgroup%type)
return boolean;
--------------------------------------------------------------------------------
function get_partner_group (O_error_message                  out varchar2,
                            O_wp_Lov_partner_group_tbl  out wp_Lov_partner_group_type_tbl,
                            I_partner_group_id               in  number,
                            I_partner_group_name             in  varchar2)
return boolean;
--------------------------------------------------------------------------------
function get_freight_type(O_error_message            out varchar2,
                          O_wp_lov_freight_type_tbl  out wp_lov_freight_type_tbl)
return boolean;
--------------------------------------------------------------------------------
function get_re_option (O_error_message                  out varchar2,
                        O_wp_Lov_option_tbl              out wp_Lov_option_tbl,
                        I_order_no                       in  number)
return boolean;
--------------------------------------------------------------------------------
function get_re_partner (O_error_message          out varchar2,
                         O_wp_Lov_partner_tbl     out wp_Lov_partner_tbl,
                         I_order_no             in  number,
                         I_option_id           in  varchar2)
return boolean;
--------------------------------------------------------------------------------
function get_brand_size (O_error_message       out varchar2,
                         O_wp_Lov_Brand_Tbl    out wp_Lov_Brand_Tbl,
                         I_option_id           in varchar2)
return boolean;
--------------------------------------------------------------------------------
function get_partner_dc (O_error_message             out varchar2,
                         O_wp_Lov_partner_dc_tbl     out wp_lov_partner_dc_tbl,
                         I_sales_order_no            in  number )
return boolean ;
--------------------------------------------------------------------------------
function get_partner_store (O_error_message             out varchar2,
                            O_wp_Lov_partner_store_tbl  out wp_lov_partner_store_tbl,
                            I_sales_order_no            in  number ,
                            I_partner_dc_id             in  VARCHAR2
                            )
return boolean;
--------------------------------------------------------------------------------
function get_upload_templates (O_error_message             out varchar2,
                               O_wp_upload_template_tbl    out wp_upload_template_tbl)
return boolean;
--------------------------------------------------------------------------------
end wp_lov_sql;
/