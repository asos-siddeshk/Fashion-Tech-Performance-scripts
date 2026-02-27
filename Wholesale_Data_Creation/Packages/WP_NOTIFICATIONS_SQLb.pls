CREATE OR REPLACE PACKAGE BODY WP_NOTIFICATIONS_SQL AS
--------------------------------------------------------------------------------
FUNCTION INSERT_NOTIFICATION(O_error_message        OUT VARCHAR2,
                             I_notification_type    IN  RAF_NOTIFICATION_TYPE_B.NOTIFICATION_TYPE_CODE%TYPE,
                             I_notification_desc    IN  RAF_NOTIFICATION.NOTIFICATION_DESC%TYPE,
                             I_notification_context IN  VARCHAR2,
                             I_launchable           IN  RAF_NOTIFICATION.LAUNCHABLE%TYPE DEFAULT 'Y',
                             I_user                 IN  RAF_NOTIFICATION_RECIPIENTS.RECIPIENT_ID%TYPE DEFAULT GET_APP_USER,
                             I_severity             IN  NUMBER DEFAULT NULL)
RETURN BOOLEAN IS
  --
  L_program           VARCHAR2(64) := 'WP_NOTIFICATIONS_SQL.INSERT_NOTIFICATION';
  L_notification_id   raf_notification.raf_notification_id%TYPE;
  L_user              VARCHAR2(64) := I_user;
  L_notification_type raf_notification.notification_type%type;
  --
  cursor C_get_notif_type is
  select rntb.notification_type
    from raf_notification_type_b rntb
   where upper(rntb.notification_type_code) = upper(I_notification_type);
  --
BEGIN
  --
  L_notification_id := raf_notification_seq.nextval;
  --
  open  C_get_notif_type;
  fetch C_get_notif_type into L_notification_type;
  close C_get_notif_type;
  --
  if L_notification_type is null and is_number(I_notification_type) = true then
    --
    L_notification_type := to_number(I_notification_type);
    --
  end if;
  --
  insert into raf_notification(raf_notification_id,
                               application_code,
                               notification_type,
                               notification_desc,
                               notification_active,
                               created_by,
                               create_date,
                               last_updated_by,
                               last_update_date,
                               object_version_number,
                               severity,
                               launchable)
  values(L_notification_id,
         'wholesale',
         L_notification_type,
         substr(I_notification_desc, 1, 200),
         'U',
         nvl(L_user, get_app_user),
         sysdate,
         L_user,
         sysdate,
         '1',
        NVL(I_severity,case
           when I_launchable = 'Y'
             then '2'
           else '3'
         end),
         I_launchable);
  --
  if I_notification_context is not null then
    --
    insert into raf_notification_context(raf_notification_id,
                                         notification_context,
                                         source)
    values(L_notification_id,
           I_notification_context,
           'TEXT');
    --
  end if;
  --
  insert into raf_notification_recipients(raf_notification_id,
                                          recipient_id)
  values(L_notification_id,
         L_user);
  --
  insert into raf_notification_status(raf_notification_id,
                                      status,
                                      user_id,
                                      created_by,
                                      create_date,
                                      last_updated_by,
                                      last_update_date,
                                      object_version_number)
  values(L_notification_id,
         'U',
         L_user,
         L_user,
         sysdate,
         L_user,
         sysdate,
         '1');
  --
  return true;
  --
exception
  --
  when others then
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id             => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level         => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name      => L_program,
                                              I_error_key         => 'ERROR_INSERT_NOTIFICATION',
                                              I_aux_1             => I_notification_type,
                                              I_aux_2             => I_notification_desc,
                                              I_aux_3             => I_notification_context,
                                              I_error_backtrace   => dbms_utility.format_error_backtrace,
                                              I_error_stack       => dbms_utility.format_error_stack);
    --
    return false;
    --
  --
END INSERT_NOTIFICATION;
--------------------------------------------------------------------------------
END WP_NOTIFICATIONS_SQL;
/
