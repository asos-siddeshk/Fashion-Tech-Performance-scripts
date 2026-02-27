create or replace PACKAGE BODY WP_ORDER_APPROVAL_SQL AS
------------------------------------------------------------------------------------------
FUNCTION CAN_APPROVE_ORDER(O_error_message         OUT VARCHAR2,
                           I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE)
RETURN BOOLEAN IS

   L_program       VARCHAR2(64) := 'WP_ORDER_APPROVAL_SQL.CAN_APPROVE_ORDER';

   CURSOR C_head IS
      SELECT   SALES_ORDER_NO,
               EXTERNAL_ORDER_NO,
               CUSTOMER_ID,
               SALES_ORDER_TYPE,
               ORDER_NO,
               ORDER_ROW_CODE,
               STATUS,
               ORDER_TYPE,
               CURRENCY_CODE,
               EXCHANGE_RATE,
               CANCEL_REASON,
               COMMENTS,
               HOLD_IND,
               REDIST_IND,
               PARTNER_ORDER_NO,
               CONTEXT_TYPE,
               CONTEXT_VALUE,
               RELEASE_IND,
               RELEASE_DATE,
               CANCEL_DATE,
               CREATE_ID,
               CREATE_DATETIME,
               LAST_UPDATE_ID,
               LAST_UPDATE_DATETIME
      FROM wp_order_head
      where sales_order_no = I_sales_order_no;

   L_head_rec C_head%ROWTYPE;

   CURSOR C_detail IS
      SELECT   SALES_ORDER_NO,
               ITEM,
               SOURCE_LOC_TYPE,
               SOURCE_LOC_ID,
               CUSTOMER_LOC,
               ORIGINAL_QTY,
               CURRENT_QTY,
               ORIGINAL_PARTNER_PRICE,
               CURRENT_PARTNER_PRICE,
               ORIGINAL_WINDOW_START_DATE,
               CURRENT_WINDOW_START_DATE,
               ORIGINAL_WINDOW_END_DATE,
               CURRENT_WINDOW_END_DATE,
               CANCEL_REASON,
               CANCEL_DATE, 
               RRP_GBP,
               RRP_EUR,
               RRP_USD,
               RRP_CAD,
               CANCELLED_QTY,
               PARTNER_DC_ID,			
               PARTNER_STORE_ID,
               CREATE_ID,
               CREATE_DATETIME,
               LAST_UPDATE_ID,
               LAST_UPDATE_DATETIME
      FROM wp_order_detail
      where sales_order_no = I_sales_order_no;

   L_detail_exists BOOLEAN := FALSE;

BEGIN

   OPEN C_head;
   FETCH C_head INTO L_head_rec;

   if C_head%NOTFOUND then
      O_error_message := 'Sales order no does not exists: '|| I_sales_order_no;
      close C_head;
      return FALSE;
   end if;

   close C_head;

   if L_head_rec.CUSTOMER_ID IS NULL then
      O_error_message := 'Mandatory field CUSTOMER_ID can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.SALES_ORDER_TYPE IS NULL then
      O_error_message := 'Mandatory field SALES_ORDER_TYPE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.ORDER_ROW_CODE IS NULL then
      O_error_message := 'Mandatory field ORDER_ROW_CODE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.STATUS IS NULL then
      O_error_message := 'Mandatory field STATUS can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.ORDER_TYPE IS NULL then
      O_error_message := 'Mandatory field ORDER_TYPE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.CURRENCY_CODE IS NULL then
      O_error_message := 'Mandatory field CURRENCY_CODE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.EXCHANGE_RATE IS NULL then
      O_error_message := 'Mandatory field EXCHANGE_RATE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.CONTEXT_TYPE IS NULL then
      O_error_message := 'Mandatory field CONTEXT_TYPE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.CONTEXT_VALUE IS NULL then
      O_error_message := 'Mandatory field CONTEXT_VALUE can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   if L_head_rec.RELEASE_IND IS NULL then
      O_error_message := 'Mandatory field RELEASE_IND can not be NULL: '|| I_sales_order_no;
      return FALSE;
   end if;

   FOR C_rec in C_detail loop

      if C_rec.item IS NULL then
         O_error_message := 'Mandatory field ITEM can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;

      if C_rec.SOURCE_LOC_TYPE IS NULL then
         O_error_message := 'Mandatory field SOURCE_LOC_TYPE can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;

      if C_rec.SOURCE_LOC_ID IS NULL then
         O_error_message := 'Mandatory field SOURCE_LOC_ID can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;

      if C_rec.CUSTOMER_LOC IS NULL then
         O_error_message := 'Mandatory field CUSTOMER_LOC can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;

      if C_rec.CURRENT_QTY IS NULL then
         O_error_message := 'Mandatory field CURRENT_QTY can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;

      if C_rec.CURRENT_WINDOW_START_DATE IS NULL then
         O_error_message := 'Mandatory field CURRENT_WINDOW_START_DATE can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;

      if C_rec.CURRENT_WINDOW_END_DATE IS NULL then
         O_error_message := 'Mandatory field CURRENT_WINDOW_END_DATE can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;
      L_detail_exists := TRUE;

      if C_rec.RRP_GBP IS NULL then
         O_error_message := 'Mandatory field RRP_GBP can not be NULL: '|| I_sales_order_no;
         return FALSE;
      end if;
      L_detail_exists := TRUE;

   end loop;

   if L_detail_exists = FALSE then
      O_error_message := 'Sales order can not be approved without detail: '|| I_sales_order_no;
      return FALSE;
   end if;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
      O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END CAN_APPROVE_ORDER;
------------------------------------------------------------------------------------------
FUNCTION APPROVE_ORDER(O_error_message         OUT VARCHAR2,
                       I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE)
RETURN BOOLEAN IS

   L_program       VARCHAR2(64) := 'WP_ORDER_APPROVAL_SQL.APPROVE_ORDER';

BEGIN

   IF CAN_APPROVE_ORDER(O_error_message,
                        I_sales_order_no) = FALSE then
      return FALSE;
   end if;

   UPDATE WP_ORDER_HEAD
      SET STATUS = APPROVED,
          LAST_UPDATE_ID = USER,
          LAST_UPDATE_DATETIME = SYSDATE
   WHERE SALES_ORDER_NO = I_sales_order_no;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
      O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END APPROVE_ORDER;
------------------------------------------------------------------------------------------
FUNCTION CANCEL_ORDER(O_error_message         OUT VARCHAR2,
                       I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE)
RETURN BOOLEAN IS

   L_program       VARCHAR2(64) := 'WP_ORDER_APPROVAL_SQL.CANCEL_ORDER';

BEGIN

   UPDATE WP_ORDER_HEAD
      SET STATUS = CANCELLED,
          LAST_UPDATE_ID = USER,
          LAST_UPDATE_DATETIME = SYSDATE
   WHERE SALES_ORDER_NO = I_sales_order_no;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
      O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END CANCEL_ORDER;
------------------------------------------------------------------------------------------
END WP_ORDER_APPROVAL_SQL;
/