create or replace package wp_entity_lock_sql as
  -------------------------------------------------------------------------------------------------------
  function lock_entity(O_error_message   out varchar2,
                       O_expiration_date out varchar2,
                       I_entity_type     in  wp_entity_lock.entity_type%type,
                       I_entity_id       in  wp_entity_lock.entity_id%type,
                       I_user_id         in  wp_entity_lock.user_id%type)
  return boolean;
  -------------------------------------------------------------------------------------------------------
  function release_entity(O_error_message out varchar2,
                          I_entity_type   in  wp_entity_lock.entity_type%type,
                          I_entity_id     in  wp_entity_lock.entity_id%type)
  return boolean;
  -------------------------------------------------------------------------------------------------------
  function purge(O_error_message out varchar2)
  return boolean;
-------------------------------------------------------------------------------------------------------
end wp_entity_lock_sql;
/
