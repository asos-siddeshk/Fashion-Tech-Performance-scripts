CREATE OR REPLACE PACKAGE WP_SYSTEM_CALENDAR_SQL AUTHID CURRENT_USER AS
---------------------------------------------------------------------------
FUNCTION GET_CAL_OPTS ( O_error_message         IN OUT VARCHAR2,
                        O_cal_ind               IN OUT VARCHAR2,
                        O_start_of_half_month   IN OUT NUMBER,
                        O_start_last_year       IN OUT NUMBER)
RETURN BOOLEAN;
---------------------------------------------------------------------------
END WP_SYSTEM_CALENDAR_SQL;
/
