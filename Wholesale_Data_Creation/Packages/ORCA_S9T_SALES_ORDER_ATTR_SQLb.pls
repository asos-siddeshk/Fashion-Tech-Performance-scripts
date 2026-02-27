CREATE OR REPLACE PACKAGE BODY ORCA_S9T_SALES_ORDER_ATTR_SQL is
-------------------------------------------------------------------------------
  FUNCTION ENQUEUE(O_error_message out varchar2,
                   I_process_id    in  number)
  RETURN BOOLEAN IS
    --
    L_program            varchar2(64) := LP_program || '.ENQUEUE';
    --L_error_message      VARCHAR2(4000);
    --
    L_queue_name         varchar2(100) := 'ORCA_S9T_SALES_ORDER_ATTR_U_AQ';
    L_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    L_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    L_payload            orca_s9t_sales_order_attr_payload;
    L_message_handle     raw(16);
    --
  BEGIN
    --
    L_payload := orca_s9t_sales_order_attr_payload(process_id => I_process_id);
    --
    L_enqueue_options.visibility := DBMS_AQ.ON_COMMIT;
    --
    DBMS_AQ.ENQUEUE(queue_name         => L_queue_name,
                    enqueue_options    => L_enqueue_options,
                    message_properties => L_message_properties,
                    payload            => L_payload,
                    msgid              => L_message_handle);
    --
    return TRUE;
    --
  EXCEPTION
    --
    when others then
      --
      --O_error_message := 'ERR$' || L_program;
      --
      O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => I_process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      return false;
      --
  END ENQUEUE;
  -------------------------------------------------------------------------------
  PROCEDURE DEQUEUE(context  raw,
                    reginfo  sys.aq$_reg_info,
                    descr    sys.aq$_descriptor,
                    payload  raw,
                    payloadl number) IS
    --
    L_program             varchar2(64) := LP_program || '.DEQUEUE';
    L_error_message       varchar2(2000);
    L_dequeue_options     DBMS_AQ.DEQUEUE_OPTIONS_T;
    L_message_properties  DBMS_AQ.MESSAGE_PROPERTIES_T;
    L_payload             orca_s9t_sales_order_attr_payload;
    L_message_handle      RAW(16);
    --
  BEGIN
    --
    L_dequeue_options.msgid         := descr.msg_id;
    L_dequeue_options.consumer_name := descr.consumer_name;
    L_dequeue_options.visibility    := DBMS_AQ.IMMEDIATE;
    L_dequeue_options.wait          := DBMS_AQ.NO_WAIT;
    --
    DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                    dequeue_options    => L_dequeue_options,
                    message_properties => L_message_properties,
                    payload            => L_payload,
                    msgid              => L_message_handle);
    --
    update orca_s9t_process p
       set p.dequeue_datetime = sysdate
     where p.process_id       = L_payload.process_id;
    --
    if orca_s9t_sql.FIRE_PROCESS_JOB(O_error_message => L_error_message,
                                     I_process_id    => L_payload.process_id) = false then
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => L_payload.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
    END IF;
    --
  EXCEPTION
    --
    when others then
      --
      L_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' || L_program,
                                                I_aux_1           => L_payload.process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
  END DEQUEUE;
  -------------------------------------------------------------------------------
  FUNCTION VALIDATE(O_error_message       OUT VARCHAR2,
                    IO_orca_s9t_error_tbl IN OUT orca_s9t_error_tbl,
                    I_process_id          IN OUT NUMBER) RETURN BOOLEAN IS
    --
    L_program       varchar2(64) := LP_program || '.VALIDATE';
    --
    L_rec_s9t_bulk_so_attr orca_s9t_bulk_so_attr_tbl;
    L_rec_s9t_error        ORCA_S9T_ERROR_TBL;
    L_return               VARCHAR2(1);
    L_custom_error         VARCHAR2(2000);
    --
    L_release_ind             wp_order_head.release_ind%type;
    L_status                  wp_order_head.status%type;
    L_valid_partner_dc_id     varchar2(1);
    L_valid_partner_store_id  varchar2(1);
    L_expiration_date         varchar2(25);
    L_partner_st_req_ind      wp_customer_attrib.partner_st_req_ind%type;
    L_partner_order_ind       wp_customer_attrib.partner_order_ind%type;
    L_partner_dept_ind        wp_customer_attrib.partner_dept_ind %type;
    L_user_id                 VARCHAR2(50);
    L_check_entity_lock       varchar2(1);
    --
    CURSOR c_get_user IS
      SELECT create_id
        FROM orca_s9t_process
       WHERE process_id = I_process_id;
    --
    CURSOR C_get_bulk_so_attr IS
    SELECT ORCA_S9T_BULK_SO_ATTR_OBJ(brand              => ba.brand,
                                     partner_loc_name   => ba.partner_loc_name, 
                                     product_group_name => ba.product_group_name,
                                     order_row_code     => ba.order_row_code,
                                     option_id          => ba.option_id,
                                     option_desc        => ba.option_desc,
                                     sales_order_no     => ba.sales_order_no,
                                     partner_dc_id      => ba.partner_dc_id,
                                     partner_store_id   => ba.partner_store_id,
                                     partner_po         => ba.partner_po,
                                     partner_dept_no    => ba.partner_dept_no),
           ORCA_S9T_ERROR_OBJ(PROCESS_ID   => ba.process_id,
                              TEMPLATE_KEY => ba.template_key,
                              WKSHT_KEY    => ba.wksht_key,
                              COLUMN_KEY   => NULL,
                              LINE         => ba.line,
                              ERROR_TYPE   => 'E',
                              ERROR_KEY    => NULL,
                              ERROR_DESC   => (select cd.code_desc
                                                 from code_detail cd
                                                where cd.code_type = 'WUST'
                                                  and cd.code      = 'E'))
      FROM ORCA_V_S9T_BULK_SO_ATTR ba
     WHERE ba.process_id = I_process_id
       AND NOT EXISTS (SELECT 1
                         FROM table(IO_orca_s9t_error_tbl) ose
                        WHERE ose.line       = ba.line
                          AND ose.PROCESS_ID = ba.process_id);
    -- check so
    cursor C_chk_so_invalid (I_sales_order_no in number) is
      select 'Y'
        from wp_order_head w
       where w.sales_order_no = I_sales_order_no;
    -- check duplicates SO
    cursor C_check_multiple_so (I_sales_order_no in number) is
    select 'Y'
      from dual
      where (select count(1)
               from table(L_rec_s9t_bulk_so_attr) t
              where t.sales_order_no = I_sales_order_no) > 1;
    --  check so status
    cursor C_get_so (I_sales_order_no in number) is
      select w.release_ind , w.status
        from wp_order_head w
       where w.sales_order_no = I_sales_order_no;
   -- check partner_store_id
    cursor C_chk_partner_store_id (I_sales_order_no   in number,
                                   I_partner_store_id in VARCHAR2
                               )is
       select 'Y'
         from wp_order_detail          wod,
              wp_customer_dc_st_link   wc
        where wod.sales_order_no  = I_sales_order_no
          and wc.customer_loc     = wod.customer_loc
          and wc.partner_store_id = I_partner_store_id
       group by wc.partner_store_id;
    -- check partner_dc_id
    cursor C_chk_partner_dc_id (I_sales_order_no in number,
                                I_partner_dc_id  in VARCHAR2
                               )is
       select 'Y'
         from wp_order_detail          wod,
              wp_customer_dc_st_link   wc
        where wod.sales_order_no = I_sales_order_no
          and wc.customer_loc    = wod.customer_loc
          and wc.partner_dc_id   = I_partner_dc_id
       group by wc.partner_dc_id;
    -- mandatory partner_store_id and partner_dc_id, partner_po, partner_dept_no
    cursor C_check_partner_mandatory (I_sales_order_no in number) is
      select ca.partner_st_req_ind,
             ca.partner_order_ind,
             ca.partner_dept_ind
        from wp_order_head woh,
             wp_customer_attrib ca
      where woh.sales_order_no = I_sales_order_no
        and ca.customer_id = woh.customer_id;
    --
    cursor C_check_entity_lock  (I_sales_order_no in number)  is
      select  'Y'
        from  wp_entity_lock l
        where l.entity_type = 'SALES_ORDER'
          and l.entity_id   = I_sales_order_no; 
    --
  BEGIN
    --
    open  C_get_user;
    fetch C_get_user into L_user_id;
    close C_get_user;
    --
    OPEN C_get_bulk_so_attr;
    FETCH C_get_bulk_so_attr BULK COLLECT INTO L_rec_s9t_bulk_so_attr, L_rec_s9t_error;
    CLOSE C_get_bulk_so_attr;
    --
    for X in 1 .. L_rec_s9t_bulk_so_attr.count LOOP
    begin
      L_return := NULL;
      -- exist SO
      OPEN  C_chk_so_invalid(L_rec_s9t_bulk_so_attr(x).sales_order_no);
      FETCH C_chk_so_invalid  INTO L_return;
      CLOSE C_chk_so_invalid;
      --
      IF NVL(L_return, 'N') = 'N' THEN
        --
        L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'SO_NO_EXIST');
        --
        L_rec_s9t_error(x).error_key := L_custom_error;
        --
        IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                           IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                           I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                          ) = FALSE THEN
          --
          RETURN FALSE;
          --
        END IF;
        --
        CONTINUE;
        --
      END IF;
      --
      L_return := NULL;
      -- duplicated SO
      OPEN  C_check_multiple_so(L_rec_s9t_bulk_so_attr(x).sales_order_no);
      FETCH C_check_multiple_so INTO L_return;
      CLOSE C_check_multiple_so;
      --
      IF NVL(L_return, 'N') = 'Y' THEN
        --
        L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'DUPLICATED_SO', I_txt_1 => L_rec_s9t_bulk_so_attr(x).sales_order_no);
        --
        L_rec_s9t_error(x).error_key := L_custom_error;
        --
        IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                           IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                           I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                          ) = FALSE THEN
          --
          RETURN FALSE;
          --
        END IF;
        --
        CONTINUE;
        --
      END IF;
      --
      L_release_ind := null;
      L_status      := null;
      open  C_get_so(L_rec_s9t_bulk_so_attr(x).sales_order_no);
      fetch C_get_so into L_release_ind, L_status;
      close C_get_so;
      --
      -- cancelled
      if nvl(L_status, 'N') = 'C' then
        --
        L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'SO_CANCEL');
        --
        L_rec_s9t_error(x).error_key := L_custom_error;
        --
        IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                           IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                           I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                          ) = FALSE THEN
          --
          RETURN FALSE;
          --
        END IF;
        --
        CONTINUE;
        --
      end if;
      --
      -- release
      if nvl(L_release_ind, 'N') = 'Y' then
        --
        L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'SO_RELEASE');
        --
        L_rec_s9t_error(x).error_key := L_custom_error;
        --
        IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                           IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                           I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                          ) = FALSE THEN
          --
          RETURN FALSE;
          --
        END IF;
        --
        CONTINUE;
        --
      end if;
      --
      -- Check mandatory partner_store_id, partner_dc_id, partner_po, partner_dept_ind
      L_partner_st_req_ind := null;
      L_partner_order_ind  := null;
      L_partner_dept_ind   := null;
      --
      open  C_check_partner_mandatory (L_rec_s9t_bulk_so_attr(x).sales_order_no);
      fetch C_check_partner_mandatory into L_partner_st_req_ind,
                                           L_partner_order_ind,
                                           L_partner_dept_ind;
      close C_check_partner_mandatory;
      --
      if L_partner_st_req_ind = 'Y' then
        -- Partner Store No. are not valid ones for the Partner Location on the Sales Order.
        L_valid_partner_store_id := null;
        --
        if L_rec_s9t_bulk_so_attr(x).partner_store_id is not null then

          Open  C_chk_partner_store_id (L_rec_s9t_bulk_so_attr(x).sales_order_no,
                                        L_rec_s9t_bulk_so_attr(x).partner_store_id);
          fetch C_chk_partner_store_id into L_valid_partner_store_id ;
          close C_chk_partner_store_id;
          --
          if nvl(L_valid_partner_store_id, 'N') = 'N' then
            --L_valid_partner_store_id
            L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'INV_PARTNER_DC_STORE');
            --
            L_rec_s9t_error(x).error_key := L_custom_error;
            --
            IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                               IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                               I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                              ) = FALSE THEN
              --
              RETURN FALSE;
              --
            END IF;
            --
            CONTINUE;
            --
          end if;
        end if;
        --
        -- Partner DC No. are not valid ones for the Partner Location on the Sales Order.
        L_valid_partner_dc_id := null;
        --
        if L_rec_s9t_bulk_so_attr(x).partner_dc_id is not null then
          --
          Open  C_chk_partner_dc_id (L_rec_s9t_bulk_so_attr(x).sales_order_no,
                                     L_rec_s9t_bulk_so_attr(x).partner_dc_id);
          fetch C_chk_partner_dc_id into L_valid_partner_dc_id ;
          close C_chk_partner_dc_id;
          --
          if nvl(L_valid_partner_dc_id, 'N') = 'N' then
            --
            L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'INV_PARTNER_DC_STORE');
            --
            L_rec_s9t_error(x).error_key := L_custom_error;
            --
            IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                               IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                               I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                              ) = FALSE THEN
              --
              RETURN FALSE;
              --
            END IF;
            --
            CONTINUE;
            --
          end if;
        end if;
        --
      else
        --
        if L_rec_s9t_bulk_so_attr(x).partner_store_id is not null then
          --
          L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'NOT_MAND_PARTNER_DC_STORE');
          --
          L_rec_s9t_error(x).error_key := L_custom_error;
          --
          IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                             IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                             I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                             ) = FALSE THEN
            --
            RETURN FALSE;
            --
          END IF;
          --
          CONTINUE;
          --
        end if;
        --
        if L_rec_s9t_bulk_so_attr(x).partner_dc_id is not null then
          --
          L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'NOT_MAND_PARTNER_DC_STORE');
          --
          L_rec_s9t_error(x).error_key := L_custom_error;
          --
          IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                             IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                             I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                            ) = FALSE THEN
            --
            RETURN FALSE;
            --
          END IF;
          --
          CONTINUE;
          --
        end if;
        --
      end if;
      --
      -- validate partner_po
      if nvl(L_partner_order_ind, 'N') = 'N' then
        --
        if L_rec_s9t_bulk_so_attr(x).partner_po is not null then
          --
          L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'NOT_MAND_PARTNER_PO_DEPT');
          --
          L_rec_s9t_error(x).error_key := L_custom_error;
          --
          IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                             IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                             I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                            ) = FALSE THEN
            --
            RETURN FALSE;
            --
          END IF;
          --
          CONTINUE;
          --
        end if;
        --
      end if;
      -- validate_partner_dept
      if nvl(L_partner_dept_ind, 'N') = 'N' then
        --
        if L_rec_s9t_bulk_so_attr(x).partner_dept_no is not null then
          --
          L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'NOT_MAND_PARTNER_PO_DEPT');
          --
          L_rec_s9t_error(x).error_key := L_custom_error;
          --
          IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                             IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                             I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                             ) = FALSE THEN
            --
            RETURN FALSE;
            --
          END IF;
          --
          CONTINUE;
          --
        end if;
        --
      end if;
      --
      -- Sales Order is locked.
      L_check_entity_lock := 'N';
      --
      open C_check_entity_lock(L_rec_s9t_bulk_so_attr(x).sales_order_no);
      fetch C_check_entity_lock into L_check_entity_lock ;
      close C_check_entity_lock;
      --
      if nvl(L_check_entity_lock, 'N') = 'Y' then
        --
        L_custom_error := WP_ERRORS_SQL.GET_MESSAGE_TEXT(i_key => 'SALES_ORDER_LOCKED');
        --
        L_rec_s9t_error(x).error_key := L_custom_error;
        --
        IF ORCA_S9T_SQL.POPULATE_ERROR_MSG(O_error_message       => O_error_message,
                                           IO_orca_s9t_error_tbl => IO_orca_s9t_error_tbl,
                                           I_orca_s9t_error_obj  => L_rec_s9t_error(x)
                                          ) = FALSE THEN
          --
          RETURN FALSE;
          --
        END IF;
        --
        CONTINUE;
        --
      end if;
      --
    end;
    end loop;
    --
    RETURN TRUE;
    --
  EXCEPTION
    --
    WHEN OTHERS THEN
      --
      O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERR$' ||
                                                                     L_program,
                                                I_aux_1           => I_process_id,
                                                I_error_backtrace => DBMS_UTILITY.format_error_backtrace,
                                                I_error_stack     => DBMS_UTILITY.format_error_stack);
      --
      RETURN FALSE;
      --
  END VALIDATE;
  -------------------------------------------------------------------------------
  function MERGE_INFO (O_error_message  OUT VARCHAR2,
                       I_process_id     IN  NUMBER)
  return boolean is
    --
    L_program              varchar2(64) := 'ORCA_S9T_SALES_ORDER_ATTR_SQ.MERGE_INFO';
    --
    L_user_id              varchar2(50);
    L_process_name         varchar2(255);
    L_process_date         date;
    L_expiration_date      varchar2(25);
    --
    cursor C_get_info is
    select sales_order_no,
           partner_dc_id,
           partner_store_id,
           partner_po,
           partner_dept_no
      from ORCA_V_S9T_BULK_SO_ATTR ba
     where ba.process_id = I_process_id;
    --
    cursor C_get_user is
    select create_id,
           process_desc,
           trunc(last_update_datetime) last_update_datetime
        from orca_s9t_process
       where process_id = I_process_id;
    --
  begin
    --
    open  C_get_user;
    fetch C_get_user into L_user_id, L_process_name, L_process_date;
    close C_get_user;
    --
    -- lock SO
    for L in C_get_info loop
      --
      if wp_entity_lock_sql.lock_entity(O_error_message   => O_error_message,
                                        O_expiration_date => L_expiration_date,
                                        I_entity_type     => 'SALES_ORDER',
                                        I_entity_id       => L.sales_order_no,
                                        I_user_id         => L_user_id
                                       ) = false then
        --
        RETURN FALSE;
        --
      end if;
      --
    end loop;
    --
    for L_get_info in C_get_info loop
      --
      update wp_order_head woh
         set woh.partner_order_no     = nvl(L_get_info.partner_po, woh.partner_order_no),
             woh.partner_dept_no      = nvl(L_get_info.partner_dept_no, woh.partner_dept_no),
             woh.last_update_id       = L_user_id,
             woh.last_update_datetime = L_process_date
         where woh.sales_order_no = L_get_info.sales_order_no;
      --

      update wp_order_detail wod
         set wod.partner_dc_id        = nvl(L_get_info.partner_dc_id, wod.partner_dc_id),
             wod.partner_store_id     = nvl(L_get_info.partner_store_id, wod.partner_store_id),
             wod.last_update_id       = L_user_id,
             wod.last_update_datetime = L_process_date
         where wod.sales_order_no = L_get_info.sales_order_no;
      --
    end loop;
    --
    -- release SO
    for R in C_get_info loop
      --
      if wp_entity_lock_sql.release_entity(O_error_message => O_error_message,
                                           I_entity_type   => 'SALES_ORDER',
                                           I_entity_id     => R.sales_order_no
                                          ) = false then
        --
        RETURN FALSE;
        --
      end if;
      --
    end loop;
    --
    return true;
    --
  exception
    --
    when OTHERS then
      --
      O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERROR_MERGE_INFO',
                                                I_aux_1           => I_process_id,
                                                I_error_backtrace => dbms_utility.format_error_backtrace,
                                                I_error_stack     => dbms_utility.format_error_stack);
        --
        return false;
        --
  end MERGE_INFO;
  -------------------------------------------------------------------------------
  function PROCESS(O_error_message out varchar2,
                   I_process_id    in  number)
  return boolean is
    --
    L_program varchar2(64) := 'ORCA_S9T_SALES_ORDER_ATTR_SQL.PROCESS';
    --
    l_notification_type    raf_notification_type_b.notification_type_code%type;
    l_notification_desc    raf_notification.notification_desc%type;
    l_notification_context raf_notification_context.notification_context%type;
    l_launchable           raf_notification.launchable%type;
    --
    CURSOR c_get_user IS
    SELECT create_id
      FROM orca_s9t_process
     WHERE process_id = I_process_id;
    --
    L_user_id  VARCHAR2(50);
    L_merge_info_error  VARCHAR2(1) := 'N';
    --
  begin
    --
    open  C_get_user;
    fetch C_get_user into L_user_id;
    close C_get_user;
    --
    if MERGE_INFO(O_error_message  => O_error_message,
                  I_process_id     => I_process_id) = false then
        --
        L_merge_info_error := 'Y';
        --
    end if;
    --
    --notifications
    --
     if L_merge_info_error = 'Y' then
      --
      L_notification_type := 'SO Attribute Upload Errors';
      L_notification_desc := nvl(O_error_message, WP_ERRORS_SQL.GET_MESSAGE_TEXT('PROCESS_UPLOAD_FAIL', I_process_id));
      L_launchable        := 'N';
      --
    else
      --
      L_notification_type := 'SO Attribute Upload Success';
      L_notification_desc := WP_ERRORS_SQL.GET_MESSAGE_TEXT('PROCESS_UPLOAD_SUCCESS', I_process_id);
      L_launchable        := 'N';
      --
    end if;
    --
    if WP_NOTIFICATIONS_SQL.INSERT_NOTIFICATION(O_error_message        => O_error_message,
                                                I_notification_type    => L_notification_type,
                                                I_notification_desc    => L_notification_desc,
                                                I_notification_context => L_notification_context,
                                                I_launchable           => L_launchable,
                                                I_user                 => L_user_id) = false then
      --
      null;
      --
    end if;
    --
    if L_merge_info_error = 'Y' then
      --
      return false;
      --
    end if;
    --
    return true;
    --
  exception
    --
    when OTHERS then
      --
      O_error_message := LOG_SQL.HANDLE_WP_LOGS(I_wp_id           => GLOBAL_VARS_SQL.G_wp_wholesale,
                                                I_log_level       => GLOBAL_VARS_SQL.G_level_error,
                                                I_program_name    => L_program,
                                                I_error_key       => 'ERROR_PROCESS',
                                                I_aux_1           => I_process_id,
                                                I_error_backtrace => dbms_utility.format_error_backtrace,
                                                I_error_stack     => dbms_utility.format_error_stack);
        --
        return false;
        --
  end PROCESS;
  -------------------------------------------------------------------------------
END ORCA_S9T_SALES_ORDER_ATTR_SQL;
/
