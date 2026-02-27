CREATE OR REPLACE PACKAGE BODY LOG_SQL AS
--------------------------------------------------------------------------------
/******************************************************************************/
/* DESCRIPTION - Function to parse log message                                */
/******************************************************************************/
--------------------------------------------------------------------------------
FUNCTION GET_LOG_MESSAGE(I_key     VARCHAR2,
                         I_txt_1   VARCHAR2 DEFAULT NULL,
                         I_txt_2   VARCHAR2 DEFAULT NULL,
                         I_txt_3   VARCHAR2 DEFAULT NULL,
                         I_txt_4   VARCHAR2 DEFAULT NULL,
                         I_txt_5   VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2 IS
  --
  L_program        VARCHAR2(64)  := 'GET_LOG_MESSAGE';
  L_step           NUMBER        := 0;
  L_key            VARCHAR2(50)  := substr(upper(I_key), 1, 50);
  L_txt_1          VARCHAR2(255) := substr(I_txt_1, 1, 255);
  L_txt_2          VARCHAR2(255) := substr(I_txt_2, 1, 255);
  L_txt_3          VARCHAR2(255) := substr(I_txt_3, 1, 255);
  L_txt_4          VARCHAR2(255) := substr(I_txt_4, 1, 255);
  L_txt_5          VARCHAR2(255) := substr(I_txt_5, 1, 255);
  L_temp_msg1      VARCHAR2(260) := NULL;
  L_temp_msg2      VARCHAR2(260) := NULL;
  L_temp_msg3      VARCHAR2(260) := NULL;
  L_temp_msg4      VARCHAR2(260) := NULL;
  L_temp_msg5      VARCHAR2(260) := NULL;
  L_error_message  VARCHAR2(275) := NULL;
  L_return_message VARCHAR2(255) := NULL;
  --
BEGIN
  --
  L_error_message := L_key;
  --
  L_step := 100;
  --
  if L_txt_1 is NOT NULL then
    L_temp_msg1 := ' # ' || L_txt_1;
  else
    L_temp_msg1 := NULL;
  end if;
  --
  if L_txt_2 is NOT NULL then
    L_temp_msg2 := ' # ' || L_txt_2;
  else
    L_temp_msg2 := NULL;
  end if;
  --
  if L_txt_3 is NOT NULL then
    L_temp_msg3 := ' # ' || L_txt_3;
  else
    L_temp_msg3 := NULL;
  end if;
  --
  if L_txt_4 is NOT NULL then
    L_temp_msg4 := ' # ' || L_txt_4;
  else
    L_temp_msg4 := NULL;
  end if;
  --
  if L_txt_5 is NOT NULL then
    L_temp_msg5 := ' # ' || L_txt_5;
  else
    L_temp_msg5 := NULL;
  end if;
  --
  -- Return Message
  --
  L_step := 200;
  --
  L_return_message := substr(L_error_message || L_temp_msg1 || L_temp_msg2 ||
                             L_temp_msg3 || L_temp_msg4 || L_temp_msg5,
                             1,
                             255);
  --
  RETURN L_return_message;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN substr(L_program || ',' || L_step  || '->' || SQLERRM || ' : ' || I_key ||
                  L_temp_msg1 || L_temp_msg2 || L_temp_msg3 || L_temp_msg4 || L_temp_msg5,
                  1,
                  255);
    --
 --
END GET_LOG_MESSAGE;
--------------------------------------------------------------------------------
/******************************************************************************/
/* DESCRIPTION - Function to insert microapps logs                            */
/******************************************************************************/
--------------------------------------------------------------------------------
FUNCTION INS_WP_LOGS_AUTONOMOUS (I_wp_logs IN OUT wp_LOGS%ROWTYPE)
RETURN BOOLEAN IS
  --
  PRAGMA AUTONOMOUS_TRANSACTION;
  --
BEGIN
  --
  insert into wp_logs values I_wp_logs;
  COMMIT;
  --
  RETURN TRUE;
  --
EXCEPTION
  --
  when OTHERS then
    --
    ROLLBACK;
    I_wp_logs.msg_code := 'ERROR_INSERT_WP_LOGS#' || SQLERRM;
    RETURN FALSE;
    --
  --
END INS_WP_LOGS_AUTONOMOUS;
---------------------------------------------------------------------------------
FUNCTION IS_ERROR (I_msg_log_level IN WP_LOGS.LOG_LEVEL%TYPE)
RETURN BOOLEAN IS
  --
BEGIN
  --
  case I_msg_log_level
    --
    when GLOBAL_VARS_SQL.G_level_error then
      --
      RETURN TRUE;
      --
    --
    else
      --
      RETURN FALSE;
      --
    --
  end case;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN FALSE;
    --
END IS_ERROR;
---------------------------------------------------------------------------------
FUNCTION IS_WARNING (I_msg_log_level IN WP_LOGS.LOG_LEVEL%TYPE)
RETURN BOOLEAN IS
  --
BEGIN
  --
  case I_msg_log_level
    --
    when GLOBAL_VARS_SQL.G_level_warning then
      --
      RETURN TRUE;
      --
    --
    else
      --
      RETURN IS_ERROR(I_msg_log_level);
      --
    --
  end case;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN FALSE;
    --
END IS_WARNING;
---------------------------------------------------------------------------------
FUNCTION IS_INFO (I_msg_log_level IN WP_LOGS.LOG_LEVEL%TYPE)
RETURN BOOLEAN IS
  --
BEGIN
  --
  case I_msg_log_level
    --
    when GLOBAL_VARS_SQL.G_level_info then
      --
      RETURN TRUE;
      --
    --
    else
      --
      RETURN IS_WARNING(I_msg_log_level);
      --
    --
  end case;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN FALSE;
    --
END IS_INFO;
---------------------------------------------------------------------------------
FUNCTION IS_DEBUG (I_msg_log_level IN WP_LOGS.LOG_LEVEL%TYPE)
RETURN BOOLEAN IS
  --
BEGIN
  --
  case I_msg_log_level
    --
    when GLOBAL_VARS_SQL.G_level_debug then
      --
      RETURN TRUE;
      --
    else
      --
      RETURN IS_INFO(I_msg_log_level);
      --
    --
  end case;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN FALSE;
    --
END IS_DEBUG;
---------------------------------------------------------------------------------
FUNCTION IS_TRACE (I_msg_log_level IN WP_LOGS.LOG_LEVEL%TYPE)
RETURN BOOLEAN IS
  --
BEGIN
  --
  case I_msg_log_level
    --
    when GLOBAL_VARS_SQL.G_level_trace then
      --
      RETURN TRUE;
      --
    --
    else
      --
      RETURN IS_DEBUG(I_msg_log_level);
      --
    --
  end case;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN FALSE;
    --
END IS_TRACE;
---------------------------------------------------------------------------------
FUNCTION IS_WHOLESALE_ACTIVE(I_wp_id IN VARCHAR2)
RETURN BOOLEAN IS
  --
  L_wp_status VARCHAR2(1);
  --
/*  cursor C_get_status is
  select 'A'
    from dual;*/
  --
BEGIN
  --
  L_wp_status := 'A';
  --
/*  open  C_get_status;
  fetch C_get_status into L_wp_status;
  close C_get_status;*/
  --
  if L_wp_status = GLOBAL_VARS_SQL.G_wp_active then
    --
    return true;
    --
  else
    --
    return false;
    --
  end if;
  --
EXCEPTION
  --
  when OTHERS then
    --
    return false;
    --
END IS_WHOLESALE_ACTIVE;
---------------------------------------------------------------------------------
FUNCTION IS_LOG_ALLOWED(I_wp_logs IN OUT WP_LOGS%ROWTYPE)
RETURN BOOLEAN IS
  --
  L_wp_log_level WP_LOGS.LOG_LEVEL%TYPE;
  --
BEGIN
  --
  L_wp_log_level := I_wp_logs.Log_Level;
  --
  case L_wp_log_level
    --
    when GLOBAL_VARS_SQL.G_level_trace then
      --
      RETURN IS_TRACE(I_wp_logs.log_level);
      --
    when GLOBAL_VARS_SQL.G_level_debug then
      --
      RETURN IS_DEBUG(I_wp_logs.log_level);
      --
    when GLOBAL_VARS_SQL.G_level_info then
      --
      RETURN IS_INFO(I_wp_logs.log_level);
      --
    when GLOBAL_VARS_SQL.G_level_warning then
      --
      RETURN IS_WARNING(I_wp_logs.log_level);
      --
    when GLOBAL_VARS_SQL.G_level_error then
      --
      RETURN IS_ERROR(I_wp_logs.log_level);
      --
    --
    else
      --
      dbms_output.put_line('erro_is_log_allowed');
      RETURN FALSE;
      --
    --
  end case;
  --
EXCEPTION
  --
  when OTHERS then
    --
    RETURN FALSE;
    --
  --
END IS_LOG_ALLOWED;
--------------------------------------------------------------------------------
/******************************************************************************/
/* DESCRIPTION - Function to parse backtrace message                          */
/******************************************************************************/
--------------------------------------------------------------------------------
FUNCTION PARSE_BACTRACE(I_error_backtrace  IN  VARCHAR2,
                        I_error_stack      IN  VARCHAR2)
RETURN VARCHAR2 IS
  --
  L_error_backtrace VARCHAR2(2000);
  L_backtrace_desc  VARCHAR2(2000);
  --
BEGIN
  --
  L_error_backtrace := replace(I_error_backtrace,CHR(10), '');
  --
  L_backtrace_desc := substr(L_error_backtrace,
                            instr(L_error_backtrace,': at ',1)+5,
                            length(L_error_backtrace))
                       || ' -> ' || I_error_stack;
  --
  RETURN L_backtrace_desc;
  --
EXCEPTION
  --
  when OTHERS then
    --
    L_backtrace_desc := 'Error parsing error_backtrace and error_stack: '
                        || I_error_backtrace || '|' || I_error_stack;
    RETURN L_backtrace_desc;
    --
  --
END PARSE_BACTRACE;
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
RETURN VARCHAR2 IS
  --
  L_wp_logs     WP_LOGS%ROWTYPE;
  PROGRAM_ERROR EXCEPTION;
  --
BEGIN
  --
  L_wp_logs.id           := wp_log_seq.nextval;
  L_wp_logs.wp_id        := I_wp_id;
  L_wp_logs.log_level    := I_log_level;
  L_wp_logs.program_name := I_program_name;
  L_wp_logs.log_user     := I_log_user;
  L_wp_logs.log_ts       := SYSTIMESTAMP;
  L_wp_logs.aux_1        := I_aux_1;
  L_wp_logs.aux_2        := I_aux_2;
  L_wp_logs.aux_3        := I_aux_3;
  L_wp_logs.aux_4        := I_aux_4;
  L_wp_logs.aux_5        := I_aux_5;
  --
  L_wp_logs.msg_code     := GET_LOG_MESSAGE(I_key   => I_error_key,
                                            I_txt_1 => I_aux_1,
                                            I_txt_2 => I_aux_2,
                                            I_txt_3 => I_aux_3,
                                            I_txt_4 => I_aux_4,
                                            I_txt_5 => I_aux_5);
  --
  if I_error_backtrace IS NOT NULL AND
     I_error_stack     IS NOT NULL then
    --
    L_wp_logs.backtrace_desc := PARSE_BACTRACE(I_error_backtrace => I_error_backtrace,
                                               I_error_stack     => I_error_stack);

    --
  else
    --
    L_wp_logs.backtrace_desc := I_error_backtrace;
    --
  end if;
  --
  BEGIN
    --
    L_wp_logs.sess_sid         := SYS_CONTEXT('USERENV',    'SID');
    L_wp_logs.sess_id          := SYS_CONTEXT('USERENV',    'SESSIONID');
    L_wp_logs.sess_user        := SYS_CONTEXT('USERENV',    'SESSION_USER');
    L_wp_logs.db_instance      := SYS_CONTEXT('USERENV',    'INSTANCE');
    L_wp_logs.db_instance_name := SYS_CONTEXT('USERENV',    'INSTANCE_NAME');
    L_wp_logs.user_host        := SYS_CONTEXT('USERENV',    'HOST');
    L_wp_logs.user_ip_address  := SYS_CONTEXT('USERENV',    'IP_ADDRESS');
    L_wp_logs.os_user          := SYS_CONTEXT('USERENV',    'OS_USER');
    L_wp_logs.app_user         := SYS_CONTEXT('RETAIL_CTX', 'APP_USER_ID');
    --
  EXCEPTION
    --
    when OTHERS then
      --
      NULL;
      --
    --
  END;
  --
  if IS_WHOLESALE_ACTIVE(I_wp_id => L_wp_logs.wp_id) = false and L_wp_logs.wp_id is not null then
    --
    return 'FAILED TO HANDLE WP LOG:STATUS OF WHOLESALE IS NOT ACTIVE';
    --
  end if;
  --
  if IS_LOG_ALLOWED(I_wp_logs=> L_wp_logs) = TRUE then
    --
    if INS_WP_LOGS_AUTONOMOUS(I_wp_logs => L_wp_logs) = FALSE then
      --
      RAISE PROGRAM_ERROR;
      --
    end if;
    --
  else
    --
    RAISE PROGRAM_ERROR;
    --
  end if;
  --
  RETURN L_wp_logs.MSG_CODE || '|' || L_wp_logs.backtrace_desc;
  --
EXCEPTION
  --
  when PROGRAM_ERROR then
    --
    raise_application_error( -20001, L_wp_logs.msg_code);

    RETURN L_wp_logs.msg_code;
    --
  --
  when OTHERS then
    --
    RETURN 'FAILED TO HANDLE WP LOG:'||substr(SQLERRM,1,100);
    --
  --
END HANDLE_WP_LOGS;
--------------------------------------------------------------------------------
FUNCTION HANDLE_WP_LOGS_LONG(I_wp_id        IN WP_LOGS.WP_ID%TYPE,
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
RETURN VARCHAR2 IS
  --
  L_wp_logs    WP_LOGS%ROWTYPE;
  PROGRAM_ERROR EXCEPTION;
  --
BEGIN
  --
  L_wp_logs.id           := wp_log_seq.nextval;
  L_wp_logs.wp_id        := I_wp_id;
  L_wp_logs.log_level    := I_log_level;
  L_wp_logs.program_name := I_program_name;
  L_wp_logs.log_user     := I_log_user;
  L_wp_logs.log_ts       := SYSTIMESTAMP;
  L_wp_logs.aux_1        := I_aux_1;
  L_wp_logs.aux_2        := I_aux_2;
  L_wp_logs.aux_3        := I_aux_3;
  L_wp_logs.aux_4        := I_aux_4;
  L_wp_logs.aux_5        := I_aux_5;
  L_wp_logs.aux_6        := I_aux_6;
  --
  L_wp_logs.msg_code     := GET_LOG_MESSAGE(I_key   => I_error_key,
                                            I_txt_1 => I_aux_1,
                                            I_txt_2 => I_aux_2,
                                            I_txt_3 => I_aux_3,
                                            I_txt_4 => I_aux_4,
                                            I_txt_5 => I_aux_5);
  --
  if I_error_backtrace IS NOT NULL AND
     I_error_stack     IS NOT NULL then
    --
    L_wp_logs.backtrace_desc := PARSE_BACTRACE(I_error_backtrace => I_error_backtrace,
                                               I_error_stack     => I_error_stack);

    --
  else
    --
    L_wp_logs.backtrace_desc := I_error_backtrace;
    --
  end if;
  --
  BEGIN
    --
    L_wp_logs.sess_sid         := SYS_CONTEXT('USERENV',    'SID');
    L_wp_logs.sess_id          := SYS_CONTEXT('USERENV',    'SESSIONID');
    L_wp_logs.sess_user        := SYS_CONTEXT('USERENV',    'SESSION_USER');
    L_wp_logs.db_instance      := SYS_CONTEXT('USERENV',    'INSTANCE');
    L_wp_logs.db_instance_name := SYS_CONTEXT('USERENV',    'INSTANCE_NAME');
    L_wp_logs.user_host        := SYS_CONTEXT('USERENV',    'HOST');
    L_wp_logs.user_ip_address  := SYS_CONTEXT('USERENV',    'IP_ADDRESS');
    L_wp_logs.os_user          := SYS_CONTEXT('USERENV',    'OS_USER');
    L_wp_logs.app_user         := SYS_CONTEXT('RETAIL_CTX', 'APP_USER_ID');
    --
  EXCEPTION
    --
    when OTHERS then
      --
      NULL;
      --
    --
  END;
  --
  if IS_WHOLESALE_ACTIVE(I_wp_id => L_wp_logs.wp_id) = false and L_wp_logs.wp_id is not null then
    --
    return 'FAILED TO HANDLE WP LOG:STATUS OF WHOLESALE IS NOT ACTIVE';
    --
  end if;
  --
  if IS_LOG_ALLOWED(I_wp_logs=> L_wp_logs) = TRUE then
    --
    if INS_WP_LOGS_AUTONOMOUS(I_wp_logs => L_wp_logs) = FALSE then
      --
      RAISE PROGRAM_ERROR;
      --
    end if;
    --
  else
    --
    RAISE PROGRAM_ERROR;
    --
  end if;
  --
  RETURN L_wp_logs.MSG_CODE || '|' || L_wp_logs.backtrace_desc;
  --
EXCEPTION
  --
  when PROGRAM_ERROR then
    --
    raise_application_error( -20001, L_wp_logs.msg_code);

    RETURN L_wp_logs.msg_code;
    --
  --
  when OTHERS then
    --
    RETURN 'FAILED TO HANDLE WP LOG:'||substr(SQLERRM,1,100);
    --
  --
END HANDLE_WP_LOGS_LONG;
--------------------------------------------------------------------------------
END LOG_SQL;
/