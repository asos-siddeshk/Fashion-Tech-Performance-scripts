create or replace package body wp_unproductive_stock_sql as
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
return boolean is
  --
  L_program             varchar2(250) := 'WP_UNPRODUCTIVE_STOCK_SQL.UNPRODUCTIVE_STOCK_SEARCH';
  L_string_query        varchar2(20000);
  L_wp_unp_stock_tbl    wp_unp_stock_tbl;
  L_sys_refcur          sys_refcursor;
  --
begin
  --
  L_string_query := q'{with t_binds as
                      (select :1  bv_division,
                              :2  bv_product_group,
                              :3  bv_category,
                              :4  bv_subcategory,
                              :5  bv_business_model,
                              :6  bv_buying_group,
                              :7  bv_buying_subgroup,
                              :8  bv_buying_set,
                              :9  bv_option_id,
                              :10 bv_source_loc,
                              :11 bv_business_model_comb
                         from dual)
                      select new wp_unp_stock_obj(brand_description,
                                                  business_model_name,
                                                  buying_group_name,
                                                  buying_subgroup_name,
                                                  buying_set_name,
                                                  div_name,
                                                  product_group_name,
                                                  category_name,
                                                  subcategory_name,
                                                  source_loc,
                                                  option_id,
                                                  option_desc,
                                                  size_code,
                                                  sku,
                                                  unproductive_stock,
                                                  rrp_value)
                         from wp_unproductive_stock up,
                              t_binds b
                        where 1=1 }';
  --
  --division
  --
  if I_division is not null then
    --
    L_string_query := L_string_query || q'{ and up.division = b.bv_division
                                          }';
    --
  end if;
  --
  --product group
  --
  if I_product_group is not null then
    --
    L_string_query := L_string_query || q'{ and up.division      = b.bv_division
                                            and up.product_group = b.bv_product_group
                                          }';
    --
  end if;
  --
  --category
  --
  if I_category is not null then
    --
    L_string_query := L_string_query || q'{ and up.division      = b.bv_division
                                            and up.product_group = b.bv_product_group
                                            and up.category      = b.bv_category
                                          }';
    --
  end if;
  --
  --subcategory
  --
  if I_subcategory is not null then
    --
    L_string_query := L_string_query || q'{ and up.division      = b.bv_division
                                            and up.product_group = b.bv_product_group
                                            and up.category      = b.bv_category
                                            and up.subcategory   = b.bv_subcategory
                                          }';
    --
  end if;
  --
  --business model
  --
  if I_business_model is not null then
    --
    L_string_query := L_string_query || q'{ and up.business_model  = b.bv_business_model
                                          }';
    --
  end if;
  --
  --buying group
  --
  if I_buying_group is not null then
    --
    L_string_query := L_string_query || q'{ and up.business_model  = b.bv_business_model
                                            and up.buying_group    = b.bv_buying_group
                                          }';
    --
  end if;
  --
  --buying group
  --
  if I_buying_subgroup is not null then
    --
    L_string_query := L_string_query || q'{ and up.business_model  = b.bv_business_model
                                            and up.buying_group    = b.bv_buying_group
                                            and up.buying_subgroup = b.bv_buying_subgroup
                                          }';
    --
  end if;
    --
  --buying set
  --
  if I_buying_set is not null then
    --
    L_string_query := L_string_query || q'{ and up.business_model  = b.bv_business_model
                                            and up.buying_group    = b.bv_buying_group
                                            and up.buying_subgroup = b.bv_buying_subgroup
                                            and up.buying_set      = b.bv_buying_set
                                          }';
    --
  end if;
  --
  --option id
  --
  if I_option_id is not null then
    --
    L_string_query := L_string_query || q'{ and up.option_id = b.bv_option_id
                                          }';
    --
  end if;
  --
  -- source loc - Asos fulfillment centre
  --
  if I_source_loc is not null then
    --
    L_string_query := L_string_query || q'{ and up.source_loc = b.bv_source_loc
                                          }';
    --
  end if;
  --
  -- bussiness model name
  --
   if I_business_model_comb = 'Others' then
    --
    L_string_query := L_string_query || q'{ and up.business_model_name not in (select d.series_desc
                                                                            from wp_dashboard_detail d
                                                                           where d.dashboard_id = 'UP'
                                                                             and d.dash_dtl_id  < 5)
                                          }';
    --
  else
    --
    L_string_query := L_string_query || q'{ and up.business_model_name = b.bv_business_model_comb
                                          }';
    --
  end if;
  --
  dbms_output.put_line(L_string_query);
  --
  open L_sys_refcur for L_string_query using in I_division,
                                                I_product_group,
                                                I_category,
                                                I_subcategory,
                                                I_business_model,
                                                I_buying_group,
                                                I_buying_subgroup,
                                                I_buying_set,
                                                I_option_id,
                                                I_source_loc,
                                                I_business_model_comb;
  --
  fetch L_sys_refcur bulk collect into L_wp_unp_stock_tbl;
  close L_sys_refcur;
  --
  O_wp_unp_stock_tbl := L_wp_unp_stock_tbl;
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
                                            I_error_key       => 'ERROR_UNPRODUCTIVE_STOCK_SEARCH',
                                            I_error_backtrace => dbms_utility.format_error_backtrace,
                                            I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end unproductive_stock_search;
--------------------------------------------------------------------------------
end wp_unproductive_stock_sql;
/