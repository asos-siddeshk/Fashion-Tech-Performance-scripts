create or replace package wp_refresh_process_sql as
-------------------------------------------------------------------------------------------------------
full_refresh varchar2(10):= 'FULL';
full_process varchar2(10):= 'FULL';
-------------------------------------------------------------------------------------------------------
function process_by_area (O_error_message in out varchar2,
                          I_area          in     varchar2,
                          I_process_mode  in     varchar2)
return boolean;
-------------------------------------------------------------------------------------------------------
function process (O_error_message     in out varchar2,
                  I_result_table_name in     varchar2,
                  I_process_mode      in     varchar2)
return boolean;
-------------------------------------------------------------------------------------------------------
procedure threaded_load(I_thread_no     number,
                        I_config_id_seq number);
-------------------------------------------------------------------------------------------------------
end wp_refresh_process_sql;
/