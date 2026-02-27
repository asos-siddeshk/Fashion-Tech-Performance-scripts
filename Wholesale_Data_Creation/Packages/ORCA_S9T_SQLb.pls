CREATE OR REPLACE PACKAGE BODY ORCA_S9T_SQL is
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - GET_FILE_PATH
  -- DESCRIPTION   - Function to get file ID and file path by Template.
  -------------------------------------------------------------------------------
  FUNCTION GET_FILE_PATH(O_error_message    OUT VARCHAR2,
                         O_file_id          OUT NUMBER,
                         O_file_path        OUT WP_SYSTEM_PARAMETERS.VALUE_1%TYPE,
                         I_template_key  IN     ORCA_S9T_FILE.TEMPLATE_KEY%TYPE)
  RETURN BOOLEAN IS
    --
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.GET_FILE_PATH';
    L_error_message VARCHAR2(4000);
    --
    CURSOR C_get_file_path IS
      SELECT p.value_1
        FROM wp_system_parameters p
       where p.func_area     = 'UPLD_FILE_DIR'
         AND p.parameter     = I_template_key;
    --
  BEGIN
    --
    O_file_id := ORCA_S9T_FILE_SEQ.NEXTVAL;
    --
    OPEN  C_get_file_path;
    FETCH C_get_file_path INTO O_file_path;
    CLOSE C_get_file_path;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_template_key,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END GET_FILE_PATH;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - INSERT_FILE
  -- DESCRIPTION   - Insert data into "ORCA_S9T_FILE" table.
  -------------------------------------------------------------------------------
  FUNCTION INSERT_FILE(O_error_message    OUT VARCHAR2,
                       IO_file_id      IN OUT NUMBER,
                       I_file_name     IN     ORCA_S9T_FILE.FILE_NAME%TYPE,
                       I_file_location IN     ORCA_S9T_FILE.FILE_LOCATION%TYPE,
                       I_file_type     IN     ORCA_S9T_FILE.FILE_TYPE%TYPE,
                       I_action_type   IN     ORCA_S9T_FILE.ACTION_TYPE%TYPE,
                       I_template_key  IN     ORCA_S9T_FILE.TEMPLATE_KEY%TYPE,
                       I_user_lang     IN     ORCA_S9T_FILE.USER_LANG%TYPE,
                       I_status        IN     ORCA_S9T_FILE.STATUS%TYPE DEFAULT 'A')
  RETURN BOOLEAN IS
    --
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.INSERT_FILE';
    L_error_message VARCHAR2(4000);
    --
  BEGIN
    --
    IF IO_file_id IS NULL THEN
      --
      IO_file_id := ORCA_S9T_FILE_SEQ.NEXTVAL;
      --
    END IF;
    --
    --
    INSERT INTO orca_s9t_file(file_id,
                              file_name,
                              file_location,
                              file_type,
                              action_type,
                              template_key,
                              user_lang,
                              status,
                              create_id,
                              create_datetime,
                              last_update_id,
                              last_update_datetime)
    VALUES(IO_file_id,
           I_file_name,
           I_file_location,
           I_file_type,
           I_action_type,
           I_template_key,
           I_user_lang,
           I_status,
           GET_APP_USER,
           SYSDATE,
           GET_APP_USER,
           SYSDATE);
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_template_key,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END INSERT_FILE;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - GET_TEMPLATES
  -- DESCRIPTION   - Get templaye information by Template Type.
  -------------------------------------------------------------------------------
  FUNCTION GET_TEMPLATES(O_error_message     OUT VARCHAR2,
                         O_templates         OUT ORCA_S9T_TEMPLATE_TBL,
                         I_template_type     IN  ORCA_S9T_TEMPLATE.TEMPLATE_TYPE%TYPE)
  RETURN BOOLEAN IS
    --
    L_error_message VARCHAR2(4000);
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.GET_TEMPLATES';
    --
    CURSOR C_templates IS
      SELECT ORCA_S9T_TEMPLATE_OBJ(template_key  => t.template_key,
                                   template_name => t.template_name,
                                   template_desc => t.template_desc,
                                   template_type => t.template_type)
        FROM orca_s9t_template t
       WHERE t.template_type = nvl(I_template_type, t.template_type)
       ORDER BY t.template_name;
    --
  BEGIN
    --
    OPEN  C_templates;
    FETCH C_templates BULK COLLECT INTO O_templates;
    CLOSE C_templates;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_template_type,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END GET_TEMPLATES;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - VALIDATE
  -- DESCRIPTION   - Validate Download/Upload.
  -------------------------------------------------------------------------------
  FUNCTION VALIDATE(O_error_message            OUT VARCHAR2,
                    O_error_count              out Number,
                    IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ,
                    IO_orca_s9t_error_tbl   IN OUT ORCA_S9T_ERROR_TBL)
  RETURN BOOLEAN IS
    --
    L_error_message     VARCHAR2(4000);
    L_program           VARCHAR2(64) := 'ORCA_S9T_SQL.VALIDATE';
    L_validation_event  ORCA_S9T_TEMPLATE_EVENTS.VALIDATION_EVENT%TYPE;
    L_validation_action VARCHAR2(4000);
    L_validation_result VARCHAR2(1) := 'Y';
    L_error_count       NUMBER := 0;
    --
    CURSOR C_get_template_configs IS
    SELECT e.validation_event
      FROM orca_s9t_template_events e,
           orca_s9t_process p
     WHERE e.template_key = p.template_key
       AND e.action_type  = p.action_type
       AND p.process_id   = IO_orca_s9t_process_obj.process_id;
    --
    CURSOR C_get_error_count IS
    SELECT COUNT(1)
      FROM TABLE(IO_orca_s9t_error_tbl);
    --
  BEGIN
    --
    IF IO_orca_s9t_process_obj IS NULL THEN
      --
      RETURN FALSE;
      --
    END IF;
    --
    -- Get Process ID
    --
    IF IO_orca_s9t_process_obj.process_id IS NULL THEN
      --
      IO_orca_s9t_process_obj.process_id := ORCA_S9T_PROCESS_SEQ.NEXTVAL;
      --
    END IF;
    --
    -- Insert data into staging tables
    --
    IF PERSIST_OBJ_INTO_STG(O_error_message        => O_error_message,
                            I_orca_s9t_process_obj => IO_orca_s9t_process_obj) = FALSE THEN
      --
      RETURN FALSE;
      --
    END IF;
    --
    -- Run validation event
    --
    OPEN  C_get_template_configs;
    FETCH C_get_template_configs INTO L_validation_event;
    CLOSE C_get_template_configs;
    --
    IF L_validation_event IS NOT NULL THEN
      --
      UPDATE orca_s9t_process p
         SET p.validation_start_datetime = SYSDATE
       WHERE p.process_id                = IO_orca_s9t_process_obj.process_id;
      --
      L_validation_action := 'BEGIN IF ' || L_validation_event || '(O_error_message => :O_error_message, IO_orca_s9t_error_tbl => :L_orca_s9t_error_tbl, I_process_id => :I_process_id) = FALSE THEN :L_validation_result := ''N''; END IF; END;';
      --
      EXECUTE IMMEDIATE L_validation_action USING OUT    L_error_message,
                                                  IN OUT IO_orca_s9t_error_tbl,
                                                  IN OUT IO_orca_s9t_process_obj.process_id,
                                                  OUT    L_validation_result;
      --
      UPDATE orca_s9t_process p
         SET p.validation_end_datetime = SYSDATE
       WHERE p.process_id              = IO_orca_s9t_process_obj.process_id;
      --
    END IF;
    --
    OPEN  C_get_error_count;
    FETCH C_get_error_count INTO L_error_count;
    CLOSE C_get_error_count;
    --
    O_error_count := L_error_count;
    --
    IF ORCA_S9T_SQL.INSERT_LINES_SUCCESS(O_error_message       => L_error_message,
                                         IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                         I_process_id          => IO_orca_s9t_process_obj.process_id) = FALSE THEN
      --
      NULL;
      --
    END IF;
    --
    IF ORCA_S9T_SQL.INSERT_VALIDATION_ERRORS(O_error_message      => L_error_message,
                                             I_orca_s9t_error_tbl => IO_orca_s9t_error_tbl) = FALSE THEN
      --
      NULL;
      --
    END IF;
    --
    IF L_validation_result <> 'Y' OR L_error_count <> 0 THEN
      --
      UPDATE orca_s9t_process p
         SET p.status     = 'E'
       WHERE p.process_id = IO_orca_s9t_process_obj.process_id;
      --
    END IF;
    --
    O_error_count := L_error_count;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => IO_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END VALIDATE;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS
  -- DESCRIPTION   - Process Download/Upload.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS(O_error_message            OUT VARCHAR2,
                   IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN IS
    --
    L_error_message VARCHAR2(4000);
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.PROCESS';
    --
  BEGIN
    --
    -- Process Upload
    --
    IF IO_orca_s9t_process_obj.action_type = G_upload_action_type THEN
      --
      IF PROCESS_UPLOAD(O_error_message         => O_error_message,
                        IO_orca_s9t_process_obj => IO_orca_s9t_process_obj) = FALSE THEN
        --
        RETURN FALSE;
        --
      END IF;
      --
    END IF;
    --
    -- Process Download
    --
    IF IO_orca_s9t_process_obj.action_type = G_download_action_type THEN
      --
      IF PROCESS_DOWNLOAD(O_error_message         => O_error_message,
                          IO_orca_s9t_process_obj => IO_orca_s9t_process_obj) = FALSE THEN
        --
        RETURN FALSE;
        --
      END IF;
      --
    END IF;
    --
    -- Process Download Blank
    --
    IF IO_orca_s9t_process_obj.action_type = G_download_black_action_type THEN
      --
      IF PROCESS_DOWNLOAD_BLANK(O_error_message         => O_error_message,
                                IO_orca_s9t_process_obj => IO_orca_s9t_process_obj) = FALSE THEN
        --
        RETURN FALSE;
        --
      END IF;
      --
    END IF;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => IO_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END PROCESS;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS_UPLOAD
  -- DESCRIPTION   - Process Upload.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS_UPLOAD(O_error_message            OUT VARCHAR2,
                          IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN IS
    --
    L_program       VARCHAR2(64) := 'ORCA_S9T_SQL.PROCESS_UPLOAD';
    L_result        VARCHAR2(1) := 'Y';
    L_enqueue_event ORCA_S9T_TEMPLATE_EVENTS.ENQUEUE_EVENT%TYPE;
    L_process_event ORCA_S9T_TEMPLATE_EVENTS.PROCESS_EVENT%TYPE;
    L_event_call    VARCHAR2(4000);
    L_error_message VARCHAR2(4000);
    --
    CURSOR C_get_enqueue_event IS
      SELECT e.enqueue_event,
             e.process_event
        FROM orca_s9t_template_events e
       WHERE e.template_key = IO_orca_s9t_process_obj.template_key
         AND e.action_type  = IO_orca_s9t_process_obj.action_type;
    --
  BEGIN
    --
    OPEN  C_get_enqueue_event;
    FETCH C_get_enqueue_event INTO L_enqueue_event,
                                   L_process_event;
    CLOSE C_get_enqueue_event;
    --
    --
    IF L_enqueue_event IS NOT NULL THEN
      --
      L_event_call := 'BEGIN IF ' || L_enqueue_event || '(O_error_message => :O_error_message, I_process_id => :I_process_id) = FALSE THEN :L_result := ''N''; END IF; END;';
      --
      EXECUTE IMMEDIATE L_event_call USING OUT O_error_message,
                                           IN  IO_orca_s9t_process_obj.process_id,
                                           OUT L_result;
      --
      UPDATE orca_s9t_process p
         SET p.enqueue_datetime = SYSDATE
       WHERE p.process_id       = IO_orca_s9t_process_obj.process_id;
      --
    ELSIF L_enqueue_event IS NULL AND L_process_event IS NOT NULL THEN
      --
      PROCESS_EVENTS(I_process_id => IO_orca_s9t_process_obj.process_id);
      --
    END IF;
    --
    IF L_result = 'N' THEN
      --
      RETURN FALSE;
      --
    END IF;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => IO_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END PROCESS_UPLOAD;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS_DOWNLOAD
  -- DESCRIPTION   - Process Download.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS_DOWNLOAD(O_error_message            OUT VARCHAR2,
                            IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN IS
    --
    L_program       VARCHAR2(64) := 'ORCA_S9T_SQL.PROCESS_DOWNLOAD';
    L_result        VARCHAR2(1) := 'Y';
    L_result_f      VARCHAR2(1) := 'P';
    L_process_event ORCA_S9T_TEMPLATE_EVENTS.PROCESS_EVENT%TYPE;
    L_event_call    VARCHAR2(4000);
    L_error_message VARCHAR2(4000);
    --
    CURSOR C_get_process_event IS
      SELECT e.process_event
        FROM orca_s9t_template_events e
       WHERE e.template_key = IO_orca_s9t_process_obj.template_key
         AND e.action_type  = IO_orca_s9t_process_obj.action_type;
    --
  BEGIN
    --
    IF BUILD_PROCESS_OBJ(O_error_message         => O_error_message,
                         IO_orca_s9t_process_obj => IO_orca_s9t_process_obj) = FALSE THEN
      --
      RETURN FALSE;
      --
    END IF;
    --
    OPEN  C_get_process_event;
    FETCH C_get_process_event INTO L_process_event;
    CLOSE C_get_process_event;
    --
    IF L_process_event IS NOT NULL THEN
      --
      UPDATE orca_s9t_process p
         SET p.process_start_datetime = SYSDATE
       WHERE p.process_id             = IO_orca_s9t_process_obj.process_id;
      --
      L_event_call := 'BEGIN IF ' || L_process_event || '(O_error_message => :O_error_message, IO_orca_s9t_process_obj => :IO_orca_s9t_process_obj.process_id) = FALSE THEN :L_result := ''N''; END IF; END;';
      --
      EXECUTE IMMEDIATE L_event_call USING    OUT O_error_message,
                                           IN OUT IO_orca_s9t_process_obj,
                                              OUT L_result;
      --
      IF L_result = 'N' THEN
        --
        L_result_f := 'E';
        --
      END IF;
      --
      UPDATE orca_s9t_process p
         SET p.process_end_datetime = SYSDATE,
             p.status               = L_result_f
       WHERE p.process_id           = IO_orca_s9t_process_obj.process_id;
      --
    END IF;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => IO_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);

      --
      RETURN FALSE;
      --
  END PROCESS_DOWNLOAD;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS_DOWNLOAD_BLANK
  -- DESCRIPTION   - Process Download Blank.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS_DOWNLOAD_BLANK(O_error_message            OUT VARCHAR2,
                                  IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN IS
    --
    L_program       VARCHAR2(64) := 'ORCA_S9T_SQL.PROCESS_DOWNLOAD_BLANK';
    L_result        VARCHAR2(1) := 'Y';
    L_result_f      VARCHAR2(1) := 'P';
    L_process_event ORCA_S9T_TEMPLATE_EVENTS.PROCESS_EVENT%TYPE;
    L_event_call    VARCHAR2(4000);
    L_error_message VARCHAR2(4000);
    --
    CURSOR C_get_process_event IS
      SELECT e.process_event
        FROM orca_s9t_template_events e
       WHERE e.template_key = IO_orca_s9t_process_obj.template_key
         AND e.action_type  = IO_orca_s9t_process_obj.action_type;
    --
  BEGIN
    --
    IF BUILD_PROCESS_OBJ(O_error_message         => O_error_message,
                         IO_orca_s9t_process_obj => IO_orca_s9t_process_obj) = FALSE THEN
      --
      RETURN FALSE;
      --
    END IF;
    --
    OPEN  C_get_process_event;
    FETCH C_get_process_event INTO L_process_event;
    CLOSE C_get_process_event;
    --
    IF L_process_event IS NOT NULL THEN
      --
      UPDATE orca_s9t_process p
         SET p.process_start_datetime = SYSDATE
       WHERE p.process_id             = IO_orca_s9t_process_obj.process_id;
      --
      L_event_call := 'BEGIN IF ' || L_process_event || '(O_error_message => :O_error_message, IO_orca_s9t_process_obj => :IO_orca_s9t_process_obj.process_id) = FALSE THEN :L_result := ''N''; END IF; END;';
      --
      EXECUTE IMMEDIATE L_event_call USING    OUT O_error_message,
                                           IN OUT IO_orca_s9t_process_obj,
                                              OUT L_result;
      --
      IF L_result = 'N' THEN
        --
        L_result_f := 'E';
        --
      END IF;
      --
      UPDATE orca_s9t_process p
         SET p.process_end_datetime = SYSDATE,
             p.status               = L_result_f
       WHERE p.process_id           = IO_orca_s9t_process_obj.process_id;
      --
    END IF;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => IO_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END PROCESS_DOWNLOAD_BLANK;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PERSIST_OBJ_INTO_STG
  -- DESCRIPTION   - Insert data into S9T tables.
  -------------------------------------------------------------------------------
  FUNCTION PERSIST_OBJ_INTO_STG(O_error_message           OUT VARCHAR2,
                                I_orca_s9t_process_obj IN     ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN IS
    --
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.PERSIST_INTO_STG';
    L_error_message VARCHAR2(4000);
    --
  BEGIN
    --
    MERGE INTO orca_s9t_process p
         USING (select I_orca_s9t_process_obj.process_id process_id,
                       I_orca_s9t_process_obj.process_desc process_desc,
                       I_orca_s9t_process_obj.file_id file_id,
                       I_orca_s9t_process_obj.template_key template_key,
                       I_orca_s9t_process_obj.action_type action_type,
                       'N' status,
                       NULL enqueue_datetime,
                       NULL dequeue_datetime,
                       NULL process_start_datetime,
                       NULL process_end_datetime,
                       I_orca_s9t_process_obj.user_id create_id,
                       SYSDATE create_datetime,
                       I_orca_s9t_process_obj.user_id last_update_id,
                       SYSDATE last_update_datetime
                  FROM dual) s
            ON (p.process_id = s.process_id)
          WHEN MATCHED THEN
            UPDATE SET p.process_end_datetime = SYSDATE
          WHEN NOT MATCHED THEN
            INSERT ( process_id,
                     process_desc,
                     file_id,
                     template_key,
                     action_type,
                     status,
                     enqueue_datetime,
                     dequeue_datetime,
                     process_start_datetime,
                     process_end_datetime,
                     create_id,
                     create_datetime,
                     last_update_id,
                     last_update_datetime)
             VALUES  (s.process_id,
                     s.process_desc,
                     s.file_id,
                     s.template_key,
                     s.action_type,
                     s.status,
                     s.enqueue_datetime,
                     s.dequeue_datetime,
                     s.process_start_datetime,
                     s.process_end_datetime,
                     s.create_id,
                     s.create_datetime,
                     s.last_update_id,
                     SYSDATE);
    --
    IF I_orca_s9t_process_obj.wksht_tbl IS NULL THEN
      --
      RETURN TRUE;
      --
    END IF;
    --
    FORALL i IN 1..I_orca_s9t_process_obj.wksht_tbl.count
      INSERT INTO orca_s9t_stg_wksht(process_id,
                                     template_key,
                                     wksht_key,
                                     line,
                                     attr_1,
                                     attr_2,
                                     attr_3,
                                     attr_4,
                                     attr_5,
                                     attr_6,
                                     attr_7,
                                     attr_8,
                                     attr_9,
                                     attr_10,
                                     attr_11,
                                     attr_12,
                                     attr_13,
                                     attr_14,
                                     attr_15,
                                     attr_16,
                                     attr_17,
                                     attr_18,
                                     attr_19,
                                     attr_20,
                                     attr_21,
                                     attr_22,
                                     attr_23,
                                     attr_24,
                                     attr_25,
                                     attr_26,
                                     attr_27,
                                     attr_28,
                                     attr_29,
                                     attr_30,
                                     attr_31,
                                     attr_32,
                                     attr_33,
                                     attr_34,
                                     attr_35,
                                     attr_36,
                                     attr_37,
                                     attr_38,
                                     attr_39,
                                     attr_40,
                                     attr_41,
                                     attr_42,
                                     attr_43,
                                     attr_44,
                                     attr_45,
                                     attr_46,
                                     attr_47,
                                     attr_48,
                                     attr_49,
                                     attr_50,
                                     attr_51,
                                     attr_52,
                                     attr_53,
                                     attr_54,
                                     attr_55,
                                     attr_56,
                                     attr_57,
                                     attr_58,
                                     attr_59,
                                     attr_60,
                                     attr_61,
                                     attr_62,
                                     attr_63,
                                     attr_64,
                                     attr_65,
                                     attr_66,
                                     attr_67,
                                     attr_68,
                                     attr_69,
                                     attr_70,
                                     attr_71,
                                     attr_72,
                                     attr_73,
                                     attr_74,
                                     attr_75,
                                     attr_76,
                                     attr_77,
                                     attr_78,
                                     attr_79,
                                     attr_80,
                                     attr_81,
                                     attr_82,
                                     attr_83,
                                     attr_84,
                                     attr_85,
                                     attr_86,
                                     attr_87,
                                     attr_88,
                                     attr_89,
                                     attr_90,
                                     attr_91,
                                     attr_92,
                                     attr_93,
                                     attr_94,
                                     attr_95,
                                     attr_96,
                                     attr_97,
                                     attr_98,
                                     attr_99,
                                     attr_100)
      SELECT I_orca_s9t_process_obj.process_id,
             I_orca_s9t_process_obj.template_key,
             I_orca_s9t_process_obj.wksht_tbl(i).wksht_key,
             t.line,
             t.attr_1,
             t.attr_2,
             t.attr_3,
             t.attr_4,
             t.attr_5,
             t.attr_6,
             t.attr_7,
             t.attr_8,
             t.attr_9,
             t.attr_10,
             t.attr_11,
             t.attr_12,
             t.attr_13,
             t.attr_14,
             t.attr_15,
             t.attr_16,
             t.attr_17,
             t.attr_18,
             t.attr_19,
             t.attr_20,
             t.attr_21,
             t.attr_22,
             t.attr_23,
             t.attr_24,
             t.attr_25,
             t.attr_26,
             t.attr_27,
             t.attr_28,
             t.attr_29,
             t.attr_30,
             t.attr_31,
             t.attr_32,
             t.attr_33,
             t.attr_34,
             t.attr_35,
             t.attr_36,
             t.attr_37,
             t.attr_38,
             t.attr_39,
             t.attr_40,
             t.attr_41,
             t.attr_42,
             t.attr_43,
             t.attr_44,
             t.attr_45,
             t.attr_46,
             t.attr_47,
             t.attr_48,
             t.attr_49,
             t.attr_50,
             t.attr_51,
             t.attr_52,
             t.attr_53,
             t.attr_54,
             t.attr_55,
             t.attr_56,
             t.attr_57,
             t.attr_58,
             t.attr_59,
             t.attr_60,
             t.attr_61,
             t.attr_62,
             t.attr_63,
             t.attr_64,
             t.attr_65,
             t.attr_66,
             t.attr_67,
             t.attr_68,
             t.attr_69,
             t.attr_70,
             t.attr_71,
             t.attr_72,
             t.attr_73,
             t.attr_74,
             t.attr_75,
             t.attr_76,
             t.attr_77,
             t.attr_78,
             t.attr_79,
             t.attr_80,
             t.attr_81,
             t.attr_82,
             t.attr_83,
             t.attr_84,
             t.attr_85,
             t.attr_86,
             t.attr_87,
             t.attr_88,
             t.attr_89,
             t.attr_90,
             t.attr_91,
             t.attr_92,
             t.attr_93,
             t.attr_94,
             t.attr_95,
             t.attr_96,
             t.attr_97,
             t.attr_98,
             t.attr_99,
             t.attr_100
        FROM TABLE(I_orca_s9t_process_obj.wksht_tbl(i).line_tbl) t;
    --
    COMMIT;
    --
    FOR i IN 1..I_orca_s9t_process_obj.wksht_tbl.count LOOP
      --
      IF I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj IS NOT NULL THEN
        --
        INSERT INTO orca_s9t_stg_filter_criteria(process_id,
                                                 template_key,
                                                 wksht_key,
                                                 filter_1,
                                                 filter_2,
                                                 filter_3,
                                                 filter_4,
                                                 filter_5,
                                                 filter_6,
                                                 filter_7,
                                                 filter_8,
                                                 filter_9,
                                                 filter_10,
                                                 filter_11,
                                                 filter_12,
                                                 filter_13,
                                                 filter_14,
                                                 filter_15,
                                                 filter_16,
                                                 filter_17,
                                                 filter_18,
                                                 filter_19,
                                                 filter_20)
        VALUES(I_orca_s9t_process_obj.process_id,
               I_orca_s9t_process_obj.template_key,
               I_orca_s9t_process_obj.wksht_tbl(i).wksht_key,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_1,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_2,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_3,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_4,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_5,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_6,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_7,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_8,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_9,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_10,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_11,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_12,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_13,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_14,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_15,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_16,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_17,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_18,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_19,
               I_orca_s9t_process_obj.wksht_tbl(i).filter_criteria_obj.filter_20);
        --
      END IF;
      --
    END LOOP;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END PERSIST_OBJ_INTO_STG;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - FIRE_PROCESS_JOB
  -- DESCRIPTION   - Call PROCESS_EVENTS by Process ID.
  -------------------------------------------------------------------------------
  FUNCTION FIRE_PROCESS_JOB(O_error_message    OUT VARCHAR2,
                            I_process_id    IN     NUMBER)
  RETURN BOOLEAN IS
    --
    L_program               VARCHAR2(64) := 'ORCA_S9T_SQL.FIRE_PROCESS_JOB';
    L_error_message         VARCHAR2(4000);
    --
    L_template_key          ORCA_S9T_TEMPLATE_EVENTS.TEMPLATE_KEY%TYPE;
    L_max_template_jobs     ORCA_S9T_TEMPLATE_EVENTS.MAX_JOBS_RUNNING%TYPE;
    L_retry_wait_time       ORCA_S9T_TEMPLATE_EVENTS.JOB_RETRY_WAIT_TIME%TYPE;
    L_s9t_running_jobs      NUMBER;
    L_job_name              VARCHAR2(30);
    L_job_action            VARCHAR2(4000);
    --
    CURSOR C_get_template_configs IS
    SELECT e.template_key,
           e.max_jobs_running,
           e.job_retry_wait_time
      FROM orca_s9t_template_events e,
           orca_s9t_process p
     WHERE e.template_key = p.template_key
       AND e.action_type  = p.action_type
       AND p.process_id   = I_process_id;
    --
    CURSOR C_get_s9t_running_jobs IS
    SELECT COUNT(1)
      FROM dba_scheduler_jobs j
     WHERE j.job_name LIKE 'ORCA_S9T_JOB_' || L_template_key || '_%'
       AND j.state    = 'RUNNING';
    --
  BEGIN
    --
    OPEN  C_get_template_configs;
    FETCH C_get_template_configs INTO L_template_key,
                                      L_max_template_jobs,
                                      L_retry_wait_time;
    CLOSE C_get_template_configs;
    --
    L_job_name := 'ORCA_S9T_JOB_' || L_template_key || '_' || I_process_id;
    --
    L_job_action := 'BEGIN ORCA_S9T_SQL.PROCESS_EVENTS(I_process_id => ' || I_process_id || ');' || ' END;';
    --
    LOOP
      --
      OPEN  C_get_s9t_running_jobs;
      FETCH C_get_s9t_running_jobs INTO L_s9t_running_jobs;
      CLOSE C_get_s9t_running_jobs;
      --
      IF L_s9t_running_jobs < L_max_template_jobs THEN
        --
        EXIT;
        --
      ELSE
        --
        DBMS_LOCK.SLEEP(L_retry_wait_time);
        --
      END IF;
      --
    END LOOP;
    --
    DBMS_SCHEDULER.CREATE_JOB(job_name   => L_job_name,
                              job_type   => 'PLSQL_BLOCK',
                              job_action => L_job_action,
                              enabled    => TRUE,
                              auto_drop  => TRUE,
                              comments   => L_template_key || '_' || I_process_id);
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END FIRE_PROCESS_JOB;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - PROCESS_EVENTS
  -- DESCRIPTION    - Process validations and upload.
  -------------------------------------------------------------------------------
  PROCEDURE PROCESS_EVENTS(I_process_id IN NUMBER) IS
    --
    L_program            VARCHAR2(64) := 'ORCA_S9T_SQL.PROCESS_EVENTS';
    L_error_message      VARCHAR2(4000);
    --
    L_process_event      ORCA_S9T_TEMPLATE_EVENTS.PROCESS_EVENT%TYPE;
    L_process_action     VARCHAR2(4000);
    L_process_result     VARCHAR2(1) := 'Y';
    L_process_result_f   VARCHAR2(1) := 'P';
    --
    CURSOR C_get_template_configs IS
    SELECT e.process_event
      FROM orca_s9t_template_events e,
           orca_s9t_process p
     WHERE e.template_key = p.template_key
       AND e.action_type  = p.action_type
       AND p.process_id   = I_process_id;
    --
  BEGIN
    --
    OPEN  C_get_template_configs;
    FETCH C_get_template_configs INTO L_process_event;
    CLOSE C_get_template_configs;
    --
    UPDATE orca_s9t_process p
       SET p.process_start_datetime = SYSDATE
     WHERE p.process_id             = I_process_id;
    --
    L_process_action := 'BEGIN IF ' || L_process_event || '(O_error_message => :O_error_message, I_process_id => :I_process_id) = FALSE THEN :L_process_result := ''N''; END IF; END;';
    --
    EXECUTE IMMEDIATE L_process_action USING OUT L_error_message,
                                             IN  I_process_id,
                                             OUT L_process_result;
    --
    IF L_process_result = 'Y' THEN
      --
      L_process_result_f := 'E';
      --
    END IF;
    --
    UPDATE orca_s9t_process p
       SET p.process_end_datetime = SYSDATE,
           p.status               = L_process_result_f
     WHERE p.process_id           = I_process_id;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
  END PROCESS_EVENTS;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - BUILD_PROCESS_OBJ
  -- DESCRIPTION    - Build object by template key.
  -------------------------------------------------------------------------------
  FUNCTION BUILD_PROCESS_OBJ(O_error_message            OUT VARCHAR2,
                             IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN IS
    --
    L_program               VARCHAR2(64) := 'ORCA_S9T_SQL.BUILD_PROCESS_OBJ';
    L_orca_s9t_wksht_tbl    ORCA_S9T_WKSHT_TBL;
    L_orca_s9t_wksht_obj    ORCA_S9T_WKSHT_OBJ;
    L_orca_s9t_column_tbl   ORCA_S9T_COLUMN_TBL;
    L_orca_s9t_column_obj   ORCA_S9T_COLUMN_OBJ;
    L_orca_s9t_list_val_tbl ORCA_S9T_LIST_VAL_TBL;
    L_error_message         VARCHAR2(4000);
    --
    CURSOR C_get_template_file(v_template_key orca_s9t_wksht.template_key%type) IS
      SELECT t.template_file
        FROM orca_s9t_template t
       WHERE t.template_key = v_template_key;
    --
    CURSOR C_get_wkshts(v_template_key orca_s9t_wksht.template_key%type) IS
      SELECT w.wksht_key,
             w.wksht_name,
             w.seq_no,
             w.mandatory
        FROM orca_s9t_wksht w
       WHERE w.template_key = v_template_key
       ORDER BY w.seq_no;
    --
    CURSOR C_get_columns(v_template_key orca_s9t_wksht.template_key%type,
                         v_wksht_key orca_s9t_wksht.wksht_key%type) IS
      SELECT c.column_key,
             c.column_name,
             c.seq_no,
             c.mandatory,
             c.data_type,
             c.data_type_mask,
             c.list_vals,
             c.default_value,
             c.colour_cell_ind,
             c.visual_ind,
             nvl(c.ignore_field, 'N') ignore_field
        FROM orca_s9t_wksht_cols c
       WHERE c.template_key = v_template_key
         AND c.wksht_key    = v_wksht_key
       ORDER BY c.seq_no;
    --
    CURSOR C_get_list_vals(v_code_type orca_s9t_code_detail.code_type%type) IS
      SELECT orca_s9t_list_val_obj(code_type    => cd.code_type,
                                   code         => cd.code,
                                   code_desc    => cd.code_desc,
                                   required_ind => cd.required_ind,
                                   code_seq     => cd.code_seq)
        FROM orca_s9t_code_detail cd
       WHERE cd.code_type = v_code_type;
    --
  BEGIN
    --
    IF IO_orca_s9t_process_obj IS NULL THEN
      --
      O_error_message := 'IO_orca_s9t_process_obj cannot be null';
      RETURN FALSE;
      --
    END IF;
    --
    IF NVL(IO_orca_s9t_process_obj.object_built, 'N') = 'Y' THEN
      --
      RETURN TRUE;
      --
    END IF;
    --
    -- Get Process ID
    IF IO_orca_s9t_process_obj.process_id IS NULL THEN
      --
      IO_orca_s9t_process_obj.process_id := ORCA_S9T_PROCESS_SEQ.NEXTVAL;
      --
    END IF;
    --
    OPEN  C_get_template_file(v_template_key => IO_orca_s9t_process_obj.template_key);
    FETCH C_get_template_file INTO IO_orca_s9t_process_obj.template_file;
    CLOSE C_get_template_file;
    --
    L_orca_s9t_wksht_tbl := orca_s9t_wksht_tbl();
    --
    FOR w IN C_get_wkshts(v_template_key => IO_orca_s9t_process_obj.template_key) LOOP
      --
      L_orca_s9t_column_tbl := orca_s9t_column_tbl();
      --
      FOR c IN C_get_columns(v_template_key => IO_orca_s9t_process_obj.template_key,
                             v_wksht_key    => w.wksht_key) LOOP
        --
        IF c.list_vals IS NOT NULL THEN
          --
          OPEN  C_get_list_vals(c.list_vals);
          FETCH C_get_list_vals BULK COLLECT INTO L_orca_s9t_list_val_tbl;
          CLOSE C_get_list_vals;
          --
        END IF;
        --
        L_orca_s9t_column_obj := ORCA_S9T_COLUMN_OBJ(column_key      => c.column_key,
                                                     column_name     => c.column_name,
                                                     seq_no          => c.seq_no,
                                                     mandatory       => c.mandatory,
                                                     data_type       => c.data_type,
                                                     data_type_mask  => c.data_type_mask,
                                                     list_vals       => c.list_vals,
                                                     list_vals_tbl   => L_orca_s9t_list_val_tbl,
                                                     default_value   => c.default_value,
                                                     colour_cell_ind => c.colour_cell_ind,
                                                     visual_ind      => c.visual_ind,
                                                     ignore_field    => c.ignore_field
                                                     );
        --
        L_orca_s9t_column_tbl.extend();
        L_orca_s9t_column_tbl(L_orca_s9t_column_tbl.count) := L_orca_s9t_column_obj;
        --
      END LOOP;
      --
      L_orca_s9t_wksht_obj := ORCA_S9T_WKSHT_OBJ(wksht_key           => w.wksht_key,
                                                 wksht_name          => w.wksht_name,
                                                 seq_no              => w.seq_no,
                                                 mandatory           => w.mandatory,
                                                 column_tbl          => L_orca_s9t_column_tbl,
                                                 line_tbl            => ORCA_S9T_LINE_TBL(),
                                                 filter_criteria_obj => NULL);
      --
      L_orca_s9t_wksht_tbl.extend();
      L_orca_s9t_wksht_tbl(L_orca_s9t_wksht_tbl.count) := L_orca_s9t_wksht_obj;
      --
    END LOOP;
    --
    IO_orca_s9t_process_obj.wksht_tbl := L_orca_s9t_wksht_tbl;
    IO_orca_s9t_process_obj.object_built := 'Y';
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => IO_orca_s9t_process_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END BUILD_PROCESS_OBJ;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - INSERT_LINES_SUCCESS
  -- DESCRIPTION    - Insert msg sucess into "ORCA_S9T_ERRORS" table.
  -------------------------------------------------------------------------------
  FUNCTION INSERT_LINES_SUCCESS(O_error_message       OUT VARCHAR2,
                                IO_orca_s9t_error_tbl IN  OUT ORCA_S9T_ERROR_TBL,
                                I_process_id          IN  NUMBER)
  RETURN BOOLEAN IS
    --
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.INSERT_LINES_SUCCESS';
    L_rec_s9t_error        ORCA_S9T_ERROR_TBL;
    L_error_message  VARCHAR2(4000);
    --
    cursor C_lines_ok is
    SELECT ORCA_S9T_ERROR_OBJ(PROCESS_ID   => w.process_id,
                              TEMPLATE_KEY => w.template_key,
                              WKSHT_KEY    => w.wksht_key,
                              COLUMN_KEY   => null,
                              LINE         => w.line + 1,
                              ERROR_TYPE   => 'R',
                              ERROR_KEY    => null,
                              ERROR_DESC   => (select cd.code_desc
                                                 from code_detail cd
                                                where cd.code_type = 'WUST'
                                                  and cd.code      = 'R'))
      FROM orca_s9t_stg_wksht w
     WHERE w.process_id = I_process_id
       and not exists (select 1
                         FROM table(io_orca_s9t_error_tbl) t
                        where t.line = (w.line + 1));
    --
  BEGIN
    --
    OPEN  C_lines_ok;
    FETCH C_lines_ok BULK COLLECT INTO L_rec_s9t_error;
    CLOSE C_lines_ok;
    --
    for x in 1..L_rec_s9t_error.count loop
      --
      if ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                         IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                         I_orca_s9t_error_obj  => L_rec_s9t_error(x)) = false then
         --
         return false;
         --
      end if;
      --
    end loop;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END INSERT_LINES_SUCCESS;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - INSERT_VALIDATION_ERRORS
  -- DESCRIPTION    - Insert errors into "ORCA_S9T_ERRORS" table.
  -------------------------------------------------------------------------------
  FUNCTION INSERT_VALIDATION_ERRORS(O_error_message         OUT VARCHAR2,
                                    I_orca_s9t_error_tbl IN     ORCA_S9T_ERROR_TBL)
  RETURN BOOLEAN IS
    --
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.INSERT_VALIDATION_ERRORS';
    L_error_message  VARCHAR2(4000);
    --
  BEGIN
    --
    IF I_orca_s9t_error_tbl IS NULL THEN
      --
      RETURN TRUE;
      --
    END IF;
    --
    INSERT INTO orca_s9t_errors(error_id,
                                process_id,
                                template_key,
                                wksht_key,
                                column_key,
                                line,
                                error_type,
                                error_key,
                                create_id,
                                create_datetime,
                                last_update_id,
                                last_update_datetime)
    SELECT ORCA_S9T_ERRORS_SEQ.NEXTVAL,
           t.process_id,
           t.template_key,
           t.wksht_key,
           t.column_key,
           t.line,
           t.error_type,
           case
             when t.error_key is null then
                (select code_desc
                   from code_detail
                  where code_type = 'WUST'
                    and code = t.error_type)
             else
                t.error_key
           end error_key,
           USER,
           SYSDATE,
           USER,
           SYSDATE
      FROM table(I_orca_s9t_error_tbl) t;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END INSERT_VALIDATION_ERRORS;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - GET_LOADING_ISSUES
  -- DESCRIPTION   - Get all issues of a specific uploaded file
  -------------------------------------------------------------------------------
  FUNCTION GET_LOADING_ISSUES(O_error_message      OUT VARCHAR2,
                              O_orca_s9t_error_tbl OUT ORCA_S9T_ERROR_TBL,
                              I_process_id         IN  NUMBER)
  RETURN BOOLEAN IS
    --
    L_program VARCHAR2(64) := 'ORCA_S9T_SQL.GET_LOADING_ISSUES';
    L_error_message VARCHAR2(4000);
    --
    CURSOR C_process_loading_errors IS
      SELECT ORCA_S9T_ERROR_OBJ ( wksht_desc           => nvl(sw.wksht_name,se.wksht_key),
                                  column_desc          => nvl(swc.column_name,se.column_key),
                                  line                 => se.line,
                                  error_type           => se.error_type,
                                  error_desc           => NULL)
      FROM orca_s9t_errors se,
           orca_s9t_wksht sw,
           orca_s9t_wksht_cols swc/*,
           orca_errors e*/
     WHERE se.process_id = I_process_id
       AND se.template_key = sw.template_key(+)
       AND se.wksht_key = sw.wksht_key(+)
       AND se.template_key = swc.template_key(+)
       AND se.wksht_key = swc.wksht_key(+)
       AND se.column_key = swc.column_key (+);
      /* AND se.error_type = e.error_type(+)
       AND se.error_key = e.error_key(+);*/
    --
  BEGIN
    --
    OPEN  C_process_loading_errors;
    FETCH C_process_loading_errors BULK COLLECT INTO O_orca_s9t_error_tbl;
    CLOSE C_process_loading_errors;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END GET_LOADING_ISSUES;
  -------------------------------------------------------------------------------
  FUNCTION VALIDATE_PROCESS_NAME (O_error_message     OUT  VARCHAR2,
                                  O_process_exists    OUT  VARCHAR2,
                                  I_process_name      IN   orca_s9t_process.process_desc%TYPE)
    RETURN BOOLEAN IS
    --
    L_program            VARCHAR2(64)   := 'ORCA_S9T_SQL.VALIDATE_PROCESS_NAME';
    L_exist_process_name NUMBER;
    --
    cursor C_exist_process_name is
      select 1
        from dual
       where exists (select 1
                       from orca_s9t_process osp
                      where upper(osp.process_desc) = upper(I_process_name));
    --
    BEGIN
    --
    -- check process_name
    --
    open C_exist_process_name;
    fetch C_exist_process_name into L_exist_process_name;
    --
    if C_exist_process_name%FOUND then
      --
      O_process_exists := 'Y';
      --
    else
      --
      O_process_exists := 'N';
      --
    end if;
    --
    close C_exist_process_name;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    when OTHERS then
      --
      O_error_message := 'ERR$' || L_program;
      --
      O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id             => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level         => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name      => L_program,
                                                I_error_key         => 'ERR$' || L_program,
                                                I_aux_1             => I_process_name,
                                                I_error_backtrace   => dbms_utility.format_error_backtrace,
                                                I_error_stack       => dbms_utility.format_error_stack);
      RETURN FALSE;
      --
    --
  END VALIDATE_PROCESS_NAME;
  -------------------------------------------------------------------------------
  FUNCTION PURGE_S9T_TABLES (O_error_message  OUT VARCHAR2,
                             I_process_id     IN  NUMBER)
    RETURN BOOLEAN IS
      --
      L_program      varchar2(64) := 'ORCA_S9T_SQL.PURGE_S9T_TABLES';
      --
    BEGIN
      --
      DELETE
        FROM orca_s9t_process
       WHERE process_id = I_process_id;
      --
      DELETE
        FROM orca_s9t_errors
       WHERE process_id = I_process_id;
      --
      DELETE
        FROM orca_s9t_stg_wksht
       WHERE process_id = I_process_id;
      --
      DELETE
        FROM orca_s9t_stg_filter_criteria
       WHERE process_id = I_process_id;
      --
      RETURN TRUE;
      --
    EXCEPTION
      --
      WHEN OTHERS THEN
        --
        O_error_message := 'ERR$' || L_program;
        --
        O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id             => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                  I_log_level         => GLOBAL_VARS_SQL.G_level_error,
                                                  I_program_name      => L_program,
                                                  I_error_key         => 'ERR$' || L_program,
                                                  I_aux_1             => I_process_id,
                                                  I_error_backtrace   => dbms_utility.format_error_backtrace,
                                                  I_error_stack       => dbms_utility.format_error_stack);
        --
        RETURN FALSE;
        --
  END PURGE_S9T_TABLES;
  -------------------------------------------------------------------------------
  FUNCTION POPULATE_ERROR_MSG (O_error_message          OUT VARCHAR2,
                               IO_orca_s9t_error_tbl IN OUT orca_s9t_error_tbl,
                               I_orca_s9t_error_obj  IN     orca_s9t_error_obj)
  RETURN BOOLEAN IS
    --
    L_program      varchar2(64) := 'ORCA_S9T_SQL.POPULATE_ERROR_MSG';
    L_error_message VARCHAR2(4000);
    --
  BEGIN
    --
    IO_orca_s9t_error_tbl.extend();
    IO_orca_s9t_error_tbl(IO_orca_s9t_error_tbl.count) := I_orca_s9t_error_obj;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_orca_s9t_error_obj.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END POPULATE_ERROR_MSG;
  -------------------------------------------------------------------------------
  FUNCTION GET_THRESHOLD(O_error_message  OUT  VARCHAR2,
                         O_THRESHOLD      OUT  number,
                         I_TEMPLATE_KEY    IN  WP_SYSTEM_PARAMETERS.PARAMETER%TYPE
                        )
  RETURN BOOLEAN IS
    --
    L_program           VARCHAR2(64) := 'ORCA_S9T_SQL.GET_THRESHOLD';
    L_error_message     VARCHAR2(4000);
    --
    cursor C_get_threshold is
      select to_number(s.value_1) as threshold
       from  wp_SYSTEM_PARAMETERS s
       where s.func_area = 'UPLD_THRESHOLDS'
         and s.parameter = I_TEMPLATE_KEY;
    --
  BEGIN
    --
    open  C_get_threshold;
    fetch C_get_threshold into O_THRESHOLD;
    close C_get_threshold;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := 'ERR$' || L_program;
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_template_key,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END GET_THRESHOLD;
  -------------------------------------------------------------------------------
END ORCA_S9T_SQL;
/
