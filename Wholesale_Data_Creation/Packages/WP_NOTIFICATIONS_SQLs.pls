CREATE OR REPLACE PACKAGE WP_NOTIFICATIONS_SQL IS
 
GV_notification_type_code CONSTANT RAF_NOTIFICATION_TYPE_B.NOTIFICATION_TYPE_CODE%TYPE := 'Data Upload Warning';
--------------------------------------------------------------------------------
FUNCTION INSERT_NOTIFICATION(O_error_message        OUT VARCHAR2,
                             I_notification_type    IN  RAF_NOTIFICATION_TYPE_B.NOTIFICATION_TYPE_CODE%TYPE,
                             I_notification_desc    IN  RAF_NOTIFICATION.NOTIFICATION_DESC%TYPE,
                             I_notification_context IN  VARCHAR2,
                             I_launchable           IN  RAF_NOTIFICATION.LAUNCHABLE%TYPE DEFAULT 'Y',
                             I_user                 IN  RAF_NOTIFICATION_RECIPIENTS.RECIPIENT_ID%TYPE DEFAULT GET_APP_USER,
                             I_severity             IN  NUMBER DEFAULT NULL)
RETURN BOOLEAN;
--------------------------------------------------------------------------------
END WP_NOTIFICATIONS_SQL;
/