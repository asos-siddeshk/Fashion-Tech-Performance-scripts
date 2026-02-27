CREATE OR REPLACE PACKAGE BODY WP_ERRORS_SQL IS
  ---------------------------------------------------------------------
  FUNCTION GET_MESSAGE_TEXT(I_key   varchar2,
                            I_txt_1 varchar2 := NULL,
                            I_txt_2 varchar2 := NULL,
                            I_txt_3 varchar2 := NULL) return varchar2 IS
    --
    L_program VARCHAR2(64) := 'WP_ERRORS_SQL.GET_MESSAGE_TEXT';
    --
    cursor C_GET_MSG(S_KEY wp_errors.wp_error_key%TYPE) is
      select wp_error_text
        from wp_errors
       where wp_error_key = S_KEY;
    --
    L_key_upper varchar2(255) := null;
    L_key_raw   varchar2(255) := null;
    L_txt_1     varchar2(4000) := null;
    L_txt_2     varchar2(4000) := null;
    L_txt_3     varchar2(4000) := null;
    --
    L_disp_msg    varchar2(4000) := NULL; -- made larger to handle %s1,%s2, %s3 emessages.
    L_sub_str     varchar2(3) := '%s?';
    L_table       boolean := FALSE; -- from table
    L_error_dummy varchar2(4000);
    --
  BEGIN
    --
    L_key_upper := upper(rtrim(substrb(I_key, 1, 255)));
    L_key_raw   := rtrim(substrb(I_key, 1, 255));
    L_txt_1     := rtrim(substrb(I_txt_1, 1, 255));
    L_txt_2     := rtrim(substrb(I_txt_2, 1, 255));
    L_txt_3     := rtrim(substrb(I_txt_3, 1, 255));
    --
    if L_key_raw != L_key_upper or -- mixed case NOT a key
       length(L_key_raw) > 100 -- too long to be key
     then
      -- so key is the msg
      L_disp_msg := L_key_raw; -- so start building it
      --
    else
      -- otherwise DO a LOOKUP
      --
      open C_GET_MSG(L_key_raw);
      fetch C_GET_MSG
        into L_disp_msg;
      --
      if C_GET_MSG%NOTFOUND or L_disp_msg = 'x' then
        --
        -- Not Found so send back the incoming
        -- key surrounded by square brackets.
        --
        L_disp_msg := '[' || L_key_raw || ']';
        close C_GET_MSG;
        return(L_disp_msg);
        --
      else
        --
        close C_GET_MSG;
        L_table := TRUE;
        --
      end if;
      --
    end if;
    --
    -- did the user send in a second parameter
    -- to be included/appended in the message.
    --
    if L_txt_1 is not NULL then
      --
      -- he did, so if msg IS on the table and that
      -- message has a substitute string in it then put
      -- the string in place of that substitute string,
      -- otherwise append it.
      --
      L_sub_str := '%s1';
      --
      if L_table AND instr(L_disp_msg, L_sub_str) > 0 then
        --
        L_disp_msg := replace(L_disp_msg, L_sub_str, L_txt_1);
        --
      else
        --
        L_disp_msg := L_disp_msg || ' ' || L_txt_1;
        --
      end if;
      --
    end if;
    --
    if L_txt_2 is not NULL then
      --
      -- check second parameter
      --
      L_sub_str := '%s2';
      --
      if L_table AND instr(L_disp_msg, L_sub_str) > 0 then
        --
        L_disp_msg := replace(L_disp_msg, L_sub_str, L_txt_2);
        --
      else
        --
        L_disp_msg := L_disp_msg || ' ' || L_txt_2;
        --
      end if;
      --
    end if;
    --
    if L_txt_3 is not NULL then
      --
      --
      -- check third parameter
      --
      L_sub_str := '%s3';
      --
      if L_table AND instr(L_disp_msg, L_sub_str) > 0 then
        --
        L_disp_msg := replace(L_disp_msg, L_sub_str, L_txt_3);
        --
      else
        --
        L_disp_msg := L_disp_msg || ' ' || L_txt_3;
        --
      end if;
      --
    end if;
    --
    -- Check totals
    if (NVL(LENGTHB(L_disp_msg), 0) > 1000) then
      --
      L_disp_msg := RTRIM(substrb(I_key || ':' || I_txt_1 || ':' || I_txt_2 || ':' ||
                                  I_txt_3,
                                  1,
                                  255));
      return(L_disp_msg);
      --
    end if;
    --
    return(L_disp_msg);
    --
  EXCEPTION
    --
    when OTHERS then
      --
      L_error_dummy := log_sql.handle_wp_logs(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                              I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                              I_program_name    => L_program,
                                              I_error_key       => 'ERROR_WP_ERRORS_SQL',
                                              I_aux_1           => substrb(L_disp_msg,1,1000),
                                              I_error_backtrace => dbms_utility.format_error_backtrace,
                                              I_error_stack     => dbms_utility.format_error_stack);
      --
      return('Unhandled error in WP_ERRORS_SQL.GET_MESSAGE_TEXT: ' || SQLERRM);
      --
  END GET_MESSAGE_TEXT;
  ----------------------------------------------------------------------------------------
END WP_ERRORS_SQL;
/
