create or replace package body wp_entity_lock_sql as
  --------------------------------------------------------------------------------------------------------------------------------
  function lock_entity(O_error_message   out varchar2,
                       O_expiration_date out varchar2,
                       I_entity_type     in  wp_entity_lock.entity_type%type,
                       I_entity_id       in  wp_entity_lock.entity_id%type,
                       I_user_id         in  wp_entity_lock.user_id%type)
  return boolean is
    --
    L_program                varchar2(250) := 'WP_ENTITY_LOCK_SQL.LOCK_ENTITY';
    L_entity_desc            wp_entity.entity_desc%type := null;
    L_entity_id              wp_entity_lock.entity_id%type := null;
    L_user_id                wp_entity_lock.user_id%type := null;
    L_expiration_date        date := null;
    L_dependent_entity_type  wp_entity.dependent_entity_type%type := null;
    L_dependent_entity_query wp_entity.dependent_entity_query%type := null;
    L_sys_refcur             sys_refcursor;    
    L_wp_list_type           wp_list_type;
    --
    cursor C_get_dependent_entity is
    select e.dependent_entity_type,
           e.dependent_entity_query
      from wp_entity e
     where e.entity_type = I_entity_type;
    --
    cursor C_check_lock is
    select e.entity_desc,
           t.entity_id,
           t.user_id
      from wp_entity e,
           wp_entity_lock t
     where e.entity_type     = t.entity_type
       and t.entity_type     = I_entity_type
       and t.entity_id       = I_entity_id
       and t.expiration_date > sysdate
     union all
    select ed.entity_desc,
           td.entity_id,
           td.user_id
      from wp_entity ed,
           wp_entity_lock td
     where ed.entity_type     = td.entity_type
       and td.entity_type     = L_dependent_entity_type
       and td.entity_id       in (select to_char(t.column_value) 
                                    from table(L_wp_list_type) t)
       and td.expiration_date > sysdate;
    --
    cursor C_get_expiration_date is
    select round(sysdate + (1 / 1440 * p.value_1), 'MI') as
      from wp_system_parameters p
     where p.func_area = 'ENTITY_LOCK'
       and p.parameter = 'EXPIRATION_MINUTES';
    --
  begin
    --
    open  C_get_dependent_entity;
    fetch C_get_dependent_entity into L_dependent_entity_type, L_dependent_entity_query;
    close C_get_dependent_entity;
    --
    if L_dependent_entity_type is not null and L_dependent_entity_query is not null then
      --
      open  L_sys_refcur for L_dependent_entity_query using I_entity_id;
      fetch L_sys_refcur bulk collect into L_wp_list_type;
      close L_sys_refcur;
      --
    end if;
    --
    open  C_check_lock;
    fetch C_check_lock into L_entity_desc, L_entity_id, L_user_id;
    close C_check_lock;
    --
    if L_user_id is not null and L_user_id <> I_user_id then
      --
      O_error_message := L_entity_desc || ' ' || L_entity_id || ' is locked';
      return false;
      --
    end if;
    --
    open  C_get_expiration_date;
    fetch C_get_expiration_date into L_expiration_date;
    close C_get_expiration_date;
    --
    merge into wp_entity_lock t
    using (select I_entity_type     as entity_type,
                  I_entity_id       as entity_id,
                  I_user_id         as user_id,
                  L_expiration_date as expiration_date
             from dual
            union all
           select L_dependent_entity_type as entity_type,
                  to_char(t.column_value) as entity_id,
                  I_user_id               as user_id,
                  L_expiration_date       as expiration_date
             from table(L_wp_list_type) t
          ) s
       on (t.entity_type = s.entity_type and
           t.entity_id   = s.entity_id)
    when matched then
      update set t.user_id         = s.user_id,
                 t.expiration_date = s.expiration_date
    when not matched then
      insert(entity_type,
             entity_id,
             user_id,
             expiration_date)
       values(s.entity_type,
              s.entity_id,
              s.user_id,
              s.expiration_date);
    --
    O_expiration_date := to_char(L_expiration_date, GLOBAL_VARS_SQL.G_wp_full_date);
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
                                              I_error_key       => 'ERROR_' || L_program,
                                              I_aux_1           => I_entity_type,
                                              I_aux_2           => I_entity_id,
                                              I_aux_3           => I_user_id,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
      --
      return false;
      --
  end lock_entity;
  --------------------------------------------------------------------------------------------------------------------------------
  function release_entity(O_error_message out varchar2,
                          I_entity_type   in  wp_entity_lock.entity_type%type,
                          I_entity_id     in  wp_entity_lock.entity_id%type)
  return boolean is
    --
    L_program                varchar2(250) := 'WP_ENTITY_LOCK_SQL.RELEASE_ENTITY';
    L_dependent_entity_type  wp_entity.dependent_entity_type%type := null;
    L_dependent_entity_query wp_entity.dependent_entity_query%type := null;
    L_sys_refcur             sys_refcursor;    
    L_wp_list_type           wp_list_type;
    --
    cursor C_get_dependent_entity is
    select e.dependent_entity_type,
           e.dependent_entity_query
      from wp_entity e
     where e.entity_type = I_entity_type;
    --
  begin
    --
    open  C_get_dependent_entity;
    fetch C_get_dependent_entity into L_dependent_entity_type, L_dependent_entity_query;
    close C_get_dependent_entity;
    --
    if L_dependent_entity_type is not null and L_dependent_entity_query is not null then
      --
      open  L_sys_refcur for L_dependent_entity_query using I_entity_id;
      fetch L_sys_refcur bulk collect into L_wp_list_type;
      close L_sys_refcur;
      --
      delete wp_entity_lock t
       where t.entity_type = L_dependent_entity_type
         and t.entity_id   in (select to_char(t.column_value) 
                                 from table(L_wp_list_type) t);
      --
    end if;
    --
    delete wp_entity_lock t
     where t.entity_type = I_entity_type
       and t.entity_id   = I_entity_id;
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
                                              I_error_key       => 'ERROR_' || L_program,
                                              I_aux_1           => I_entity_type,
                                              I_aux_2           => I_entity_id,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
      --
      return false;
      --
  end release_entity;
  --------------------------------------------------------------------------------------------------------------------------------
  function purge(O_error_message out varchar2)
  return boolean is
    --
    L_program varchar2(250) := 'WP_ENTITY_LOCK_SQL.PURGE';
    --
  begin
    --
    delete wp_entity_lock t
     where t.expiration_date < sysdate;
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
                                              I_error_key       => 'ERROR_' || L_program,
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
      --
      return false;
      --
  end purge;
  --------------------------------------------------------------------------------------------------------------------------------
end wp_entity_lock_sql;
/
