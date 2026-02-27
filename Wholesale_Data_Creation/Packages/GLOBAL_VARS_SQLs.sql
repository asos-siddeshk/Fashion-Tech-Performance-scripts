create or replace package GLOBAL_VARS_SQL is
--------------------------------------------------------------------------------  
  G_wp_wholesale                  CONSTANT VARCHAR2(9)  := 'WHOLESALE';
  
   -- Wholesale log levels
  G_level_trace                   CONSTANT VARCHAR2(5) := 'TRACE';
  G_level_debug                   CONSTANT VARCHAR2(5) := 'DEBUG';
  G_level_info                    CONSTANT VARCHAR2(4) := 'INFO';
  G_level_warning                 CONSTANT VARCHAR2(7) := 'WARNING';
  G_level_error                   CONSTANT VARCHAR2(5) := 'ERROR';

  -- Wholesale status
  G_wp_inactive                   CONSTANT VARCHAR2(1) := 'I';
  G_wp_suspended                  CONSTANT VARCHAR2(1) := 'S';
  G_wp_active                     CONSTANT VARCHAR2(1) := 'A';

   --date format masks
   G_wp_full_date                  CONSTANT VARCHAR2(25) := 'YYYY-MM-DD HH24:MI:SS';
   G_wp_date                       CONSTANT VARCHAR2(15) := 'YYYY-MM-DD';
   G_wp_uk_date                    CONSTANT VARCHAR2(15) := 'DD-MM-YYYY';
--------------------------------------------------------------------------------  
end GLOBAL_VARS_SQL;
/