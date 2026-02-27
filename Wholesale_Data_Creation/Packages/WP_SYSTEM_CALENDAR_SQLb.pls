CREATE OR REPLACE PACKAGE BODY WP_SYSTEM_CALENDAR_SQL AS
-----------------------------------------------------------------------------
FUNCTION GET_CAL_OPTS ( O_error_message       IN OUT VARCHAR2,
                        O_cal_ind             IN OUT VARCHAR2,
                        O_start_of_half_month IN OUT NUMBER,
                        O_start_last_year     IN OUT NUMBER)
RETURN BOOLEAN IS
  --
  L_program  VARCHAR2(64)  := 'WP_SYSTEM_CALENDAR_SQL.GET_CAL_OPTS';
  --
  CURSOR c_cal_opts IS
  SELECT calendar_454_ind,
         ABS(start_of_half_month),
         SIGN(start_of_half_month)
    FROM wp_system_options;
  --
BEGIN
  --
  OPEN c_cal_opts;
  --
  FETCH c_cal_opts INTO O_cal_ind,
                        O_start_of_half_month,
                        O_start_last_year;
  --
  IF c_cal_opts%NOTFOUND THEN
    --
    CLOSE c_cal_opts;
    --
    O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'ERROR_GET_CAL_OPTS',
                                              I_aux_1           => 'INV_CURSOR',
                                              I_aux_2           => 'C_cal_opts',
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
    --
    RETURN FALSE;
    --
  ELSE
    --
    CLOSE c_cal_opts;
    RETURN TRUE;
    --
  END IF;
EXCEPTION
   WHEN OTHERS THEN
     --
     O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                               I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                               I_program_name    => L_program,
                                               I_error_key       => 'ERROR_GET_CAL_OPTS',
                                               I_error_backtrace => dbms_utility.format_error_backtrace,
                                               I_error_stack     => dbms_utility.format_error_stack);
     --
     RETURN FALSE;
END GET_CAL_OPTS;
-----------------------------------------------------------------------------
END WP_SYSTEM_CALENDAR_SQL;
/
