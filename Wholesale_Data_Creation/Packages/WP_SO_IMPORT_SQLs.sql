CREATE OR REPLACE PACKAGE WP_SO_IMPORT_SQL AS
--------------------------------------------------------------------------------
GV_error VARCHAR2(1) := 'E';
GV_processed VARCHAR2(1) := 'P';
GV_new VARCHAR2(1) := 'N';
GV_validated VARCHAR2(1) := 'V';
GV_update VARCHAR2(3) := 'UPD';
GV_create VARCHAR2(3) := 'CRE';
G_chunk_size    wp_plsql_batch_config.MAX_CHUNK_SIZE%TYPE;
G_max_threads   wp_plsql_batch_config.MAX_CONCURRENT_THREADS%TYPE;
G_lockwait      wp_plsql_batch_config.RETRY_WAIT_TIME%TYPE;
G_lockattempts  wp_plsql_batch_config.RETRY_LOCK_ATTEMPTS%TYPE;
--WO statuses
G_posted  VARCHAR2(1) := 'P';
G_despatched  VARCHAR2(1) := 'D';
G_released  VARCHAR2(1) := 'R';

--------------------------------------------------------------------------------
FUNCTION PROCESS_STG(O_error_message      IN OUT VARCHAR2)
RETURN BOOLEAN;
--------------------------------------------------------------------------------
FUNCTION PURGE_IMPORT_ARCH (O_ERROR_MESSAGE IN OUT VARCHAR2) RETURN BOOLEAN;
--------------------------------------------------------------------------------
END;
/
