create or replace package wp_landing_page_sql as
-------------------------------------------------------------------------------------------------------
function get_dashboards(O_error_message      out varchar2,
                        O_dashboard_tbl      out wp_dashboard_head_tbl)
return boolean;
-------------------------------------------------------------------------------------------------------
end wp_landing_page_sql;
/