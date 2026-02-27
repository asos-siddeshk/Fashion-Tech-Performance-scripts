create or replace package wp_unproductive_stock_sql is
 --------------------------------------------------------------------------------
function unproductive_stock_search (O_error_message            out varchar2,
                                    O_wp_unp_stock_tbl         out wp_unp_stock_tbl,
                                    I_division                 in  division.division%type default null,
                                    I_product_group            in  deps.dept%type default null,
                                    I_category                 in  class.class%type default null,
                                    I_subcategory              in  subclass.subclass%type default null,
                                    I_business_model           in  ma_business_model.business_model%type default null,
                                    I_buying_group             in  ma_buying_group.buying_group%type default null,
                                    I_buying_subgroup          in  ma_buying_subgroup.buying_subgroup%type default null,
                                    I_buying_set               in  ma_buying_set.buying_set%type default null,
                                    I_option_id                in  wp_order_detail.item%type default null,
                                    I_source_loc               in  wh.wh_name%type default null,
                                    I_business_model_comb      in  varchar2 default null)
return boolean;
--------------------------------------------------------------------------------
end wp_unproductive_stock_sql;
/
