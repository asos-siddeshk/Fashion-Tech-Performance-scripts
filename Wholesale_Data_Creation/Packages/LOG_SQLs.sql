CREATE OR REPLACE PACKAGE LOG_SQL AS
--------------------------------------------------------------------------------
/******************************************************************************/
/* DESCRIPTION - Function to insert new log for microapp                      */
/******************************************************************************/
--------------------------------------------------------------------------------
FUNCTION HANDLE_WP_LOGS(I_wp_id             IN WP_LOGS.WP_ID%TYPE,
                        I_log_level         IN WP_LOGS.LOG_LEVEL%TYPE,
                        I_program_name      IN WP_LOGS.PROGRAM_NAME%TYPE,
                        I_error_key         IN VARCHAR2,
                        I_aux_1             IN WP_LOGS.AUX_1%TYPE DEFAULT NULL,
                        I_aux_2             IN WP_LOGS.AUX_2%TYPE DEFAULT NULL,
                        I_aux_3             IN WP_LOGS.AUX_3%TYPE DEFAULT NULL,
                        I_aux_4             IN WP_LOGS.AUX_4%TYPE DEFAULT NULL,
                        I_aux_5             IN WP_LOGS.AUX_5%TYPE DEFAULT NULL,
                        I_error_backtrace   IN VARCHAR2 DEFAULT NULL,
                        I_error_stack       IN VARCHAR2 DEFAULT NULL,
                        I_log_user          IN WP_LOGS.LOG_USER%TYPE DEFAULT GET_APP_USER)
RETURN VARCHAR2;
--------------------------------------------------------------------------------
FUNCTION HANDLE_WP_LOGS_LONG(I_wp_id             IN WP_LOGS.WP_ID%TYPE,
                             I_log_level         IN WP_LOGS.LOG_LEVEL%TYPE,
                             I_program_name      IN WP_LOGS.PROGRAM_NAME%TYPE,
                             I_error_key         IN VARCHAR2,
                             I_aux_1             IN WP_LOGS.AUX_1%TYPE DEFAULT NULL,
                             I_aux_2             IN WP_LOGS.AUX_2%TYPE DEFAULT NULL,
                             I_aux_3             IN WP_LOGS.AUX_3%TYPE DEFAULT NULL,
                             I_aux_4             IN WP_LOGS.AUX_4%TYPE DEFAULT NULL,
                             I_aux_5             IN WP_LOGS.AUX_5%TYPE DEFAULT NULL,
                             I_aux_6             IN WP_LOGS.AUX_6%TYPE DEFAULT NULL,
                             I_error_backtrace   IN VARCHAR2 DEFAULT NULL,
                             I_error_stack       IN VARCHAR2 DEFAULT NULL,
                             I_log_user          IN WP_LOGS.LOG_USER%TYPE DEFAULT GET_APP_USER)
RETURN VARCHAR2;
--------------------------------------------------------------------------------
END LOG_SQL;
/