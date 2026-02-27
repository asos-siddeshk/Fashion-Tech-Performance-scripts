create or replace package body wp_refresh_process_sql as
--------------------------------------------------------------------------------------------------------------------------------
function get_config(O_error_message in out varchar2,
                    I_result_name   in     varchar2,
                    O_config        out    wp_refresh_config_obj)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.GET_CONFIG';
  L_config wp_refresh_config_obj;
  --
begin
  --
  select wp_refresh_config_obj(id_seq,
                               result_synonym,
                               result_table_a,
                               result_table_b,
                               source_view,
                               preprocess_procedure,
                               default_order,
                               area,
                               preserve_data,
                               threadable,
                               num_threads,
                               threading_col,
                               threading_sql,
                               dashboard_id)
        into L_config
     from wp_refresh_config
    where result_synonym = I_result_name;
  --
  O_config := L_config;
  --
  return true;
  --
exception
  --
  when no_data_found then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Couldn''t find table in configuration table - WP_REFRESH_CONFIG',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
   when others then
     return false;
  --
end get_config;
--------------------------------------------------------------------------------------------------------------------------------
function trace_synonym(O_error_message in out varchar2,
                       I_synyonym      in     varchar2,
                       O_table_name    out    varchar2)
return boolean is
  --
  L_table_name varchar2(30);
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.TRACE_SYNONYM';
  --
begin
  --
  select table_name
     into L_table_name
    from user_synonyms where synonym_name = I_synyonym;
  --
  O_table_name := L_table_name;
  --
  return true;
  --
exception
  --
  when no_data_found then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Couldn''t find table name for synonym '||I_synyonym||', please validate synonym setup',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
   when others then
     return false;
  --
end trace_synonym;
--------------------------------------------------------------------------------------------------------------------------------
function gather_stat_on_result(O_error_message in out varchar2,
                               I_table         in     varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.GATHER_STAT_ON_RESULT';
  --
begin
  --
  dbms_stats.gather_table_stats(user, I_table);
  --
  return true;
  --
exception
  --
  when others then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error while gathering stats on '||I_table,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end gather_stat_on_result;
--------------------------------------------------------------------------------------------------------------------------------
function prepare_threads(O_error_message in out varchar2,
                         I_table         in     varchar2,
                         I_config        in     wp_refresh_config_obj)
return boolean is
  --
  pragma autonomous_transaction;
  --
  L_program varchar2(250):='WP_REFRESH_PROCESS_SQL.PREPARE_THREADS';
  L_process_id varchar2(30):=null;
  L_statement varchar2(20000);
  --
begin
  --
  L_process_id := 'REFRESH_CONFIG_'||I_config.id_seq;
  --
  execute immediate 'DELETE FROM WP_REFRESH_THREAD_TMP WHERE process_id=:b1' using L_process_id;
  --
  L_statement:= 'INSERT INTO WP_REFRESH_THREAD_TMP SELECT '''|| L_process_id ||''',rownum,threading_column,'||I_config.id_seq||','''||I_table||''',''N'',sysdate,null From dual,(';
  L_statement:= L_statement || I_config.threading_sql;
  L_statement:= L_statement ||')thread_data';
  --
  -- dbms_output.put_line(l_statement);
  --
  execute immediate L_statement;
  --
  commit;
  --
  return true;
  --
exception
  --
  when others then
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error in PREPARE_THREADS - '||sqlerrm,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    rollback;
    return false;
  --
end prepare_threads;
--------------------------------------------------------------------------------------------------------------------------------
function update_thread_status(I_thread_no     in number,
                              I_status        in varchar2,
                              I_process_id    in varchar2,
                              I_error_message in varchar2)
return boolean is
  --
  pragma autonomous_transaction;
  --
  L_program varchar2(250):='WP_REFRESH_PROCESS_SQL.UPDATE_THREAD_STATUS';
  --
begin
  --
  update wp_refresh_thread_tmp
    set status                = I_status,
        last_update_datetime  = sysdate,
        error_message         = I_error_message
   where thread_no = I_thread_no
     and status    <> 'E'
     and process_id = I_process_id;
  --
  commit;
  --
  return true;
  --
exception
  --
   when others then
      rollback;
      return false;
  --
end update_thread_status;
--------------------------------------------------------------------------------------------------------------------------------
procedure threaded_load(I_thread_no     number,
                        I_config_id_seq number)
is
  --
  L_program            varchar2(40) := 'WP_REFRESH_PROCESS_SQL.THREADED_LOAD';
  L_error_message      varchar2(500);
  program_error        exception;
  L_thread_row         wp_refresh_thread_tmp%rowtype;
  L_config             wp_refresh_config%rowtype;
  --
begin
  --
  select *
     into L_thread_row
    from wp_refresh_thread_tmp
   where config_id_seq = I_config_id_seq
     and thread_no     = I_thread_no;
  --
  select *
     into L_config
    from wp_refresh_config
   where id_seq = L_thread_row.config_id_seq;
  --
  if update_thread_status(I_thread_no,
                          'I', -- in progress
                          L_thread_row.process_id,
                          L_error_message) = false then
     --
     raise program_error;
     --
  end if;
  --
  -- processing here
  --
  if L_config.default_order is not null then
    --
    execute immediate 'INSERT INTO '||L_thread_row.target_table||' SELECT * FROM '||L_config.source_view || ' WHERE '|| L_config.threading_col ||' = '||L_thread_row.thread_col_val ||' ORDER BY ' || L_config.default_order;
    --
  else
    --
    execute immediate 'INSERT INTO '||L_thread_row.target_table||' SELECT * FROM '||L_config.source_view || ' WHERE '|| L_config.threading_col ||' = '||L_thread_row.thread_col_val;
    --
  end if;
  --
  if update_thread_status(I_thread_no,
                          'P', -- in progress
                          L_thread_row.process_id,
                          L_error_message) = false then
     --
     raise program_error;
     --
  end if;
  --
exception
  --
   when others then
    if update_thread_status(I_thread_no,
                            'E', -- in progress
                            L_thread_row.process_id,
                            sqlerrm) = false then
       --
       raise program_error;
       --
    end if;
    --
  raise program_error;
  --
end threaded_load;
--------------------------------------------------------------------------------------------------------------------------------
function do_threaded_load (O_error_message in out varchar2,
                           I_table         in     varchar2,
                           I_config        in     wp_refresh_config_obj)
return boolean is
  --
  L_task_name         varchar2(30)  :='REFRESH_CONFIG_'||I_config.id_seq;
  L_threading_sql     varchar2(255) :='select distinct thread_no start_id,
                                                       config_id_seq end_id
                                          from WP_REFRESH_THREAD_TMP
                                        where process_id='''||L_task_name||'''';
  L_plsql_block       varchar2(255);
  L_error_rows        number(10)    :=0;
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.DO_THREADED_LOAD';
  --
begin
  --
  if prepare_threads(O_error_message, I_table, I_config) = false then
    --
    return false;
    --
  end if;
  --
  begin
    --
    dbms_parallel_execute.drop_task(L_task_name);
    --
  exception
     when others then
        null;
  end;
  --
  dbms_parallel_execute.create_task(task_name => L_task_name);
  --
  dbms_parallel_execute.create_chunks_by_sql(task_name   => L_task_name,
                                             sql_stmt    => L_threading_sql,
                                             by_rowid    => false);
  --
  L_plsql_block := q'[
            declare
            dummy NUMBER(4):=:end_id;
            begin
              WP_REFRESH_PROCESS_SQL.THREADED_LOAD(:start_id,:end_id);
            end;
    ]';
  --
  dbms_parallel_execute.run_task(task_name      => L_task_name,
                                 sql_stmt       => L_plsql_block,
                                 language_flag  => dbms_sql.native,
                                 parallel_level => I_config.num_threads);
  --
  select count(1)
     into L_error_rows
    from wp_refresh_thread_tmp
   where status     = 'E'
     and process_id = L_task_name;
  --
  if L_error_rows > 0 then
    --
    O_error_message:= 'Failed thread found in WP_REFRESH_THREAD_TMP for process_id '||L_task_name;
    raise program_error;
    --
  end if;
  --
  return true;
  --
exception
  --
  when others then
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error while executing threaded load '||sqlerrm,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
  --
end do_threaded_load;
--------------------------------------------------------------------------------------------------------------------------------
function switch_synonym(O_error_message in out varchar2,
                        I_synyonym      in     varchar2,
                        I_table         in     varchar2)
return boolean is
  --
  L_program    varchar2(250) := 'WP_REFRESH_CONFIG.SWITCH_SYNONYM';
  L_table_name varchar2(30);
  --
begin
  --
  execute immediate 'CREATE OR REPLACE SYNONYM '||I_synyonym||' for '||I_table;
  --
  return true;
  --
exception
  --
  when others then
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error while creating synonym '||I_synyonym||' for '||I_table,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
  --
end switch_synonym;
--------------------------------------------------------------------------------------------------------------------------------
function alter_session_full_load(O_error_message in out varchar2)
return boolean is
  ---
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.ALTER_SESSION_FULL_LOAD';
  --
begin
  --
  execute immediate 'ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL';
  execute immediate 'ALTER SESSION SET SORT_AREA_SIZE = 2147483647';
  execute immediate 'ALTER SESSION SET ddl_lock_timeout=60';
  --
  return true;
  --
exception
  --
  when others then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error in ALTER_SESSION_FULl_LOAD',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --

end alter_session_full_load;
--------------------------------------------------------------------------------------------------------------------------------
function update_refresh_date(O_error_message    out varchar2,
                             I_area             in  varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.UPDATE_REFRESH_DATE';
  --
begin
  --
  merge into wp_refresh_times drt
  using (select min(last_ddl_time) last_ddl_time,
                I_area area
           from user_objects
          where object_type = 'SYNONYM'
            and object_name in (select result_synonym
                                  from wp_refresh_config
                                 where area = I_area)
          group by I_area) src
   on (src.area = drt.area)
   when matched then
    update set drt.last_ddl_time        = src.last_ddl_time,
               drt.last_update_datetime = sysdate,
               drt.last_update_id       = user
   when not matched then
    insert (area,
            last_ddl_time,
            create_id,
            create_datetime,
            last_update_id,
            last_update_datetime)
    values (src.area,
            src.last_ddl_time,
            user,
            sysdate,
            user,
            sysdate);
  --
  return true;
  --
exception
  --
  when others then
    --
     O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error while updating WP_REFRESH_TIMES for AREA: '|| I_area,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
     return false;
  --
end update_refresh_date;
--------------------------------------------------------------------------------------------------------------------------------
function update_dashboard_date (O_error_message    out varchar2,
                                I_dashboard_id     in  varchar2) 
return boolean is 
--
L_program             varchar2(250) := 'WP_REFRESH_CONFIG.UPDATE_DASHBOARD_DATE';
--
begin
--
  update wp_dashboard_head 
         set last_refresh_date = sysdate
   where dashboard_id = I_dashboard_id;
  -- 
  return true;
  --
--
exception
  --
  when others then
    --
     O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error while updating WP_DASHBOARD_HEAD for DASHBOARD_ID: '|| I_dashboard_id,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
     return false;
  --
end update_dashboard_date;
--------------------------------------------------------------------------------------------------------------------------------
function modify_indexes(O_error_message    out varchar2,
                        I_table_name       in  varchar2,
                        I_mode             in  varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.MODIFY_INDEXES';
  --
  cursor C_indexes is
  select index_name,
         partitioned
    from user_indexes
   where table_name = upper(I_table_name);
  --
begin
  --
  execute immediate 'alter session set skip_unusable_indexes=true';
  --
  for idx in c_indexes loop
    --
    if upper(I_mode) = 'DISABLE' then
      --
      dbms_output.put_line('ALTER INDEX '||idx.index_name || ' UNUSABLE');
      --
      execute immediate 'ALTER INDEX '||idx.index_name || ' UNUSABLE';
      --
    elsif upper(I_mode) = 'REBUILD' then
      --
      if idx.partitioned = 'NO' then
        --
        dbms_output.put_line('ALTER INDEX ' || idx.index_name || ' REBUILD NOLOGGING');
        --
        execute immediate 'ALTER INDEX ' || idx.index_name || ' REBUILD NOLOGGING';
        --
      elsif idx.partitioned = 'YES' then
        --
        dbms_output.put_line('ALTER INDEX ' || idx.index_name || ' REBUILD PARTITION ');
        --
        for i in (select index_name,
                         partition_name
                    from all_ind_partitions
                   where index_name = idx.index_name) loop
           --
           execute immediate 'ALTER INDEX ' || i.index_name || ' REBUILD PARTITION ' || i.partition_name;
           --
        end loop;
      --
      end if;
    --
    end if;
  --
  end loop;
  --
  return true;
  --
exception
  --
  when others then
    --
     O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error while disable/rebuild indexes on '||I_table_name,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
     return false;
  --
end modify_indexes;
--------------------------------------------------------------------------------------------------------------------------------
function update_dash_value (O_error_message in out varchar2,
                            I_area  in     varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.UPDATE_DASH_VALUE';
  L_dash_value           number;
  L_get_dash_value_query dash_value_query_tbl;
  --
  cursor C_get_dash_value_query is
   select new dash_value_query_obj(dash_value_query => dash_value_query)
     from wp_dashboard_detail dl
    where dl.dash_value_query is not null
      and exists (select 1 
                    from wp_refresh_config rc
                   where rc.area = I_area
                     and rc.dashboard_id = dl.dashboard_id);
  --
begin
  --
  open  C_get_dash_value_query;
  fetch C_get_dash_value_query bulk collect into L_get_dash_value_query;
  close C_get_dash_value_query;
  --
  for i in 1..L_get_dash_value_query.count loop
    --
    execute immediate L_get_dash_value_query(i).dash_value_query into L_dash_value;
    --
    dbms_output.put_line(L_dash_value);
    --
    update wp_dashboard_detail dl
      set dash_value = L_dash_value
     where dash_value_query = L_get_dash_value_query(i).dash_value_query
       and exists (select 1 
                    from wp_refresh_config rc
                   where rc.area = I_area
                     and rc.dashboard_id = dl.dashboard_id);
    --
  end loop;
  --
  return true;
  --
exception
  --
  when others then
    --
     O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error in UPDATE_DASH_VALUE',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
     return false;
  --
end update_dash_value;
--------------------------------------------------------------------------------------------------------------------------------
function update_dash_desc (O_error_message in out varchar2,
                           I_area          in     varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.UPDATE_DASH_DESC';
  L_result_query        wp_list_type;
  L_limit               number := 4;
  L_get_dash_desc_query wp_list_type;
  L_area                varchar2(250);
  --
  cursor C_get_dash_desc_query is
  select dash_desc_query
    from wp_dashboard_detail
   where dashboard_id = I_area
     and dash_desc_query is not null;
  --
begin
  --
  open  C_get_dash_desc_query;
  fetch C_get_dash_desc_query bulk collect into L_get_dash_desc_query;
  close C_get_dash_desc_query;
  --
  for i in 1..L_get_dash_desc_query.count loop
    --
    execute immediate L_get_dash_desc_query(i) bulk collect into L_result_query;
    --
    if L_result_query.count < 4 then
      L_limit := L_result_query.count;
    end if;
    --
    for j in 1..L_limit loop
      update wp_dashboard_detail
        set series_desc = L_result_query(j)
       where dashboard_id = I_area
         and dash_dtl_id = j;
    end loop;
    --
    if L_result_query.count < 4 then
      --
      L_limit := L_result_query.count + 1; 
      for k in L_limit..4 loop 
        update wp_dashboard_detail
        set series_desc = null
       where dashboard_id = I_area
         and dash_dtl_id  = k;
      --
      end loop;
    end if;
    L_result_query := null;
  end loop;
  --
  return true;
  --
exception
  --
  when others then
    --
     O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'Error in UPDATE_DASH_DESC',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
     return false;
  --
end update_dash_desc;
--------------------------------------------------------------------------------------------------------------------------------
function process_by_view(O_error_message in out varchar2,
                         I_queue_name    in     varchar2)
return boolean is
  --
  L_config               wp_refresh_config_obj;
  L_current_result_table varchar2(30);
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.PROCESS_BY_VIEW';
  --
begin
  --
  dbms_output.put_line('Full refresh started...');
  --
  if alter_session_full_load(O_error_message) = false then
    --
    return false;
    --
  end if;
  --
  if get_config(O_error_message, I_queue_name, L_config) = false then
    --
    return false;
    --
  end if;
  --
  -- call preprocess function if required
  --
  if L_config.preprocess_procedure is not null then
    --
    begin
      --
      dbms_output.put_line('Executing preprocess procedure: '||L_config.preprocess_procedure);
      --
      execute immediate 'BEGIN '||L_config.preprocess_procedure||'; END;';
      --
    exception
      when others then
        O_error_message:='Error while calling preprocess function - '||l_config.preprocess_procedure||' - '|| sqlerrm;
        return false;
       --
    end;
    --
  end if;
  --
  if trace_synonym(O_error_message, L_config.result_synonym, L_current_result_table) = false then
    --
    return false;
    --
  end if;
  --
  dbms_output.put_line(L_config.result_synonym||' pointing to '||L_current_result_table);
  --
  -- refresh the "other" result table, point synonym after refresh completed.
  --
  if L_current_result_table = L_config.result_table_a then
    --
    if L_config.preserve_data = 'Y' then
      --
      execute immediate 'TRUNCATE TABLE '||l_config.result_table_b;
      --
    end if;
    --
    -- invalidate indexes
    --
    if modify_indexes(O_error_message, L_config.result_table_b, 'DISABLE') = false then
      --
      return false;
      --
    end if;
    --
    if L_config.threadable = 'N' then
      --
      if L_config.default_order is not null then
        --
        execute immediate 'INSERT /*+ APPEND */ INTO '||L_config.result_table_b||' SELECT * FROM '||L_config.source_view || ' ORDER BY ' || L_config.default_order ;
        --
      else
        --
        execute immediate 'INSERT /*+ APPEND */ INTO '||L_config.result_table_b||' SELECT * FROM '||L_config.source_view ;
        --
      end if;
      --
     else
       --
       if do_threaded_load(O_error_message, L_config.result_table_b, L_config) = false then
         --
         return false;
         --
       end if;
     --
    end if;
    --
    if modify_indexes(O_error_message, L_config.result_table_b, 'REBUILD') = false then
      --
      return false;
      --
    end if;
    --
    if switch_synonym(O_error_message, L_config.result_synonym, L_config.result_table_b) = false then
      --
      return false;
      --
    end if;
    --
    if L_config.preserve_data = 'N' then
      --
      execute immediate 'TRUNCATE TABLE '||L_config.result_table_a;
      --
    end if;
    --
    if gather_stat_on_result(O_error_message, L_config.result_table_b) = false then
      --
      return false;
      --
    end if;
    --
    elsif L_current_result_table = L_config.result_table_b then
      --
      if L_config.preserve_data = 'Y' then
        --
        execute immediate 'TRUNCATE TABLE '||L_config.result_table_a;
        --
      end if;
      --
      -- invalidate indexes
      --
      if modify_indexes(O_error_message, L_config.result_table_a, 'DISABLE') = false then
        --
        return false;
        --
      end if;
      --
      if L_config.threadable = 'N' then
        --
        if L_config.default_order is not null then
          --
          execute immediate 'INSERT /*+ APPEND */ INTO '||L_config.result_table_a||' SELECT * FROM '||L_config.source_view || ' ORDER BY ' || L_config.default_order;
          --
        else
          --
          execute immediate 'INSERT /*+ APPEND */ INTO '||L_config.result_table_a||' SELECT * FROM '||L_config.source_view;
          --
        end if;
        --
      else
        --
        if do_threaded_load(O_error_message, L_config.result_table_a, L_config) = false then
          --
          return false;
          --
        end if;
        --
      end if;
      --
      if modify_indexes(O_error_message, L_config.result_table_a, 'REBUILD') = false then
        --
        return false;
        --
      end if;
      --
      if switch_synonym(O_error_message, L_config.result_synonym, L_config.result_table_a) = false then
        --
        return false;
        --
      end if;
      --
      if L_config.preserve_data = 'N' then
        --
        execute immediate 'TRUNCATE TABLE '||L_config.result_table_b;
        --
      end if;
      --
      if gather_stat_on_result(O_error_message, L_config.result_table_a) = false then
        --
        return false;
        --
      end if;
      --
    else
      --
      O_error_message:='Incorrect synonym setup for '||L_config.result_synonym;
      return false;
      --
    end if;
  --
  if update_refresh_date(O_error_message, L_config.area) = false then
    --
    return false;
    --
  end if;
  --
  dbms_output.put_line('DASHBOARD_ID: '||L_config.dashboard_id);
  --
  if L_config.dashboard_id is not null then 
    --
    if update_dashboard_date(O_error_message, L_config.dashboard_id) = false then
      --
      return false;
      --
    end if;
    --
    if update_dash_desc(O_error_message, L_config.area) = false then
      --
      return false;
      --
    end if;
    --
  end if;
  --
  if update_dash_value(O_error_message, L_config.area) = false then
    --
    return false;
    --
  end if;
  --
  commit;
  --
  return true;
  --
end process_by_view;
--------------------------------------------------------------------------------------------------------------------------------
function process (O_error_message        in out varchar2,
                  I_result_table_name    in     varchar2,
                  I_process_mode         in     varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.PROCESS';
  --
begin
  --
  if I_result_table_name is null or I_process_mode is null then
    --
    O_error_message:='Invalid parameter provided. I_result_table_name and I_process_mode cant be NULL.';
    return false;
    --
  end if;
  --
  dbms_output.put_line('Start processing for result: '||I_result_table_name||', process mode: '||I_process_mode);
  --
  if I_process_mode = full_process then
    --
    if process_by_view(O_error_message, I_result_table_name) = false then
      --
      return false;
      --
    end if;
    --
  else
    --
    O_error_message:='Invalid I_PROCESS_MODE provided.';
    return false;
    --
  end if;
  --
  return true;
  --
exception
  --
  when others then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'ERROR_PROCESS',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end process;
--------------------------------------------------------------------------------------------------------------------------------
function process_by_area (O_error_message in out varchar2,
                          I_area          in     varchar2,
                          I_process_mode  in     varchar2)
return boolean is
  --
  L_program             varchar2(250) := 'WP_REFRESH_CONFIG.PROCESS_BY_AREA';
  L_wp_refresh_area_tbl wp_refresh_area_tbl;
  --
  cursor C_get_area is
    select new wp_refresh_area_obj(result_synonym => result_synonym)
      from wp_refresh_config
     where area = upper(I_area);
  --
BEGIN
  --
  if I_area is null or I_process_mode is null then 
    --
    O_error_message := 'Invalid parameter provided. I_area and I_process_mode cant be NULL.';
    return false;
    --
  end if;
  --
  dbms_output.put_line('Looking for synonyms for: '||I_area||', process mode: '||I_process_mode);
  --
  open  C_get_area;
  fetch C_get_area bulk collect into L_wp_refresh_area_tbl;
  close C_get_area;
  --
  if L_wp_refresh_area_tbl.count = 0 then
    --
    O_error_message := 'That area does not exist';
    return false;
    --
  end if;
  --
  for i in 1..L_wp_refresh_area_tbl.count loop
    --
    if process(O_error_message, L_wp_refresh_area_tbl(i).result_synonym, I_process_mode) = false then
      --
      return false;
      --
    end if;
    --
  end loop;
  --
  return true;
  --
exception
  --
  when others then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'ERROR_PROCESS_BY_AREA',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    return false;
    --
end process_by_area;
--------------------------------------------------------------------------------------------------------------------------------
end wp_refresh_process_sql;
/