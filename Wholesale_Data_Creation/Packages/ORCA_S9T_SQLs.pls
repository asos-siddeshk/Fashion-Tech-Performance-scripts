CREATE OR REPLACE PACKAGE ORCA_S9T_SQL IS
  -------------------------------------------------------------------------------
  -- CREATE DATE - 2022/04
  -- CREATE USER - Innovation and Technology Center
  -- PROJECT     - ORCA
  -- DESCRIPTION - Generic package for file upload and download process.
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  G_upload_action_type         CONSTANT varchar2(5) := 'U';
  G_download_action_type       CONSTANT varchar2(5) := 'D';
  G_download_black_action_type CONSTANT varchar2(5) := 'B';
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - GET_FILE_PATH
  -- DESCRIPTION   - Function to get file ID and file path by Template.
  -------------------------------------------------------------------------------
  FUNCTION GET_FILE_PATH(O_error_message    OUT VARCHAR2,
                         O_file_id          OUT NUMBER,
                         O_file_path        OUT WP_SYSTEM_PARAMETERS.VALUE_1%TYPE,
                         I_template_key  IN     ORCA_S9T_FILE.TEMPLATE_KEY%TYPE)
  RETURN BOOLEAN;
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
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - GET_TEMPLATES
  -- DESCRIPTION   - Get templaye information by Template Type.
  -------------------------------------------------------------------------------
  FUNCTION GET_TEMPLATES(O_error_message     OUT VARCHAR2,
                         O_templates         OUT ORCA_S9T_TEMPLATE_TBL,
                         I_template_type     IN  ORCA_S9T_TEMPLATE.TEMPLATE_TYPE%TYPE)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - VALIDATE
  -- DESCRIPTION   - Validate Download/Upload.
  -------------------------------------------------------------------------------
  FUNCTION VALIDATE(O_error_message            OUT VARCHAR2,
                    O_error_count              out Number,
                    IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ,
                    IO_orca_s9t_error_tbl   IN OUT ORCA_S9T_ERROR_TBL)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS
  -- DESCRIPTION   - Process Download/Upload.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS(O_error_message            OUT VARCHAR2,
                   IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS_UPLOAD
  -- DESCRIPTION   - Process Upload.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS_UPLOAD(O_error_message            OUT VARCHAR2,
                          IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS_DOWNLOAD
  -- DESCRIPTION   - Process Download.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS_DOWNLOAD(O_error_message            OUT VARCHAR2,
                            IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PROCESS_DOWNLOAD_BLANK
  -- DESCRIPTION   - Process Download Blank.
  -------------------------------------------------------------------------------
  FUNCTION PROCESS_DOWNLOAD_BLANK(O_error_message            OUT VARCHAR2,
                                  IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - PERSIST_OBJ_INTO_STG
  -- DESCRIPTION   - Insert data into S9T tables.
  -------------------------------------------------------------------------------
  FUNCTION PERSIST_OBJ_INTO_STG(O_error_message           OUT VARCHAR2,
                                I_orca_s9t_process_obj IN     ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - FIRE_PROCESS_JOB
  -- DESCRIPTION   - Call PROCESS_EVENTS by Process ID.
  -------------------------------------------------------------------------------
  FUNCTION FIRE_PROCESS_JOB(O_error_message    OUT VARCHAR2,
                            I_process_id    IN     NUMBER)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - PROCESS_EVENTS
  -- DESCRIPTION    - Process validations and upload.
  -------------------------------------------------------------------------------
  PROCEDURE PROCESS_EVENTS(I_process_id IN NUMBER);
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - BUILD_PROCESS_OBJ
  -- DESCRIPTION    - Build object by template key.
  -------------------------------------------------------------------------------
  FUNCTION BUILD_PROCESS_OBJ(O_error_message            OUT VARCHAR2,
                             IO_orca_s9t_process_obj IN OUT ORCA_S9T_PROCESS_OBJ)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - INSERT_LINES_SUCCESS
  -- DESCRIPTION    - Insert msg sucess into "ORCA_S9T_ERRORS" table.
  -------------------------------------------------------------------------------
  FUNCTION INSERT_LINES_SUCCESS(O_error_message       OUT VARCHAR2,
                                IO_orca_s9t_error_tbl IN  OUT ORCA_S9T_ERROR_TBL,
                                I_process_id          IN  NUMBER)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- PROCEDURE NAME - INSERT_VALIDATION_ERRORS
  -- DESCRIPTION    - Insert errors into "ORCA_S9T_ERRORS" table.
  -------------------------------------------------------------------------------
  FUNCTION INSERT_VALIDATION_ERRORS(O_error_message         OUT VARCHAR2,
                                    I_orca_s9t_error_tbl IN     ORCA_S9T_ERROR_TBL)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  -- FUNCTION NAME - GET_LOADING_ISSUES
  -- DESCRIPTION   - Get all issues of a specific uploaded file
  -------------------------------------------------------------------------------
  FUNCTION GET_LOADING_ISSUES(O_error_message      OUT VARCHAR2,
                              O_orca_s9t_error_tbl OUT ORCA_S9T_ERROR_TBL,
                              I_process_id         IN  NUMBER)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  FUNCTION VALIDATE_PROCESS_NAME (O_error_message     OUT  VARCHAR2,
                                  O_process_exists    OUT  VARCHAR2,
                                  I_process_name      IN   orca_s9t_process.process_desc%TYPE)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  FUNCTION PURGE_S9T_TABLES (O_error_message  OUT VARCHAR2,
                             I_process_id     IN  NUMBER)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  FUNCTION POPULATE_ERROR_MSG (O_error_message          OUT VARCHAR2,
                               IO_orca_s9t_error_tbl IN OUT orca_s9t_error_tbl,
                               I_orca_s9t_error_obj  IN     orca_s9t_error_obj)
  RETURN BOOLEAN;
  -------------------------------------------------------------------------------
  FUNCTION GET_THRESHOLD(O_error_message  OUT  VARCHAR2,
                         O_THRESHOLD      OUT  number,
                         I_TEMPLATE_KEY    IN  WP_SYSTEM_PARAMETERS.PARAMETER%TYPE
                        )
  RETURN BOOLEAN;
  --
END ORCA_S9T_SQL;
/
