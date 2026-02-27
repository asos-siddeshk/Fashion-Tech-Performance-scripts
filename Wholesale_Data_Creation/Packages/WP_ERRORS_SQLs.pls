CREATE OR REPLACE PACKAGE WP_ERRORS_SQL IS
  --
  FUNCTION GET_MESSAGE_TEXT(I_key   varchar2,
                            I_txt_1 varchar2 := null,
                            I_txt_2 varchar2 := null,
                            I_txt_3 varchar2 := null) RETURN VARCHAR2;
  --
END WP_ERRORS_SQL;
/
