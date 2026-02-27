SET SERVEROUTPUT ON;
SET timing ON;
DECLARE
   o_error_message VARCHAR2(200) := NULL;
   v_cancel_code VARCHAR2(1) := 'A';
   v_cancel_id VARCHAR2(30) := 'FORCECLR';
   v_alloc_close_ind VARCHAR2(200);
   v_return BOOLEAN := FALSE;

   le_error EXCEPTION;

   Cursor C_GET_DATA IS
    SELECT order_no
         ,status
         ,otb_eow_date
     FROM ordhead oh
    WHERE status != 'C' 
        and  order_no  in (select order_no from skumar.order_pro);
      --  and status ='A' and ORIG_APPROVAL_ID ='ORACNV';
      --  and exists (select 1 from rms.ordloc ol where oh.order_no = ol.order_no and ol.QTY_CANCELLED is not null and rownum <= '1') ;
      /* and order_no  in (SELECT oh.order_no
                         FROM ordhead oh
                        WHERE TRUNC(oh.not_after_date) < '26-DEC-18'
                          AND oh.status IN ('W', 'A')); */


BEGIN

   FOR rec in C_GET_DATA

   LOOP

      IF rec.otb_eow_date IS NULL THEN
         UPDATE ordhead
            SET otb_eow_date = get_vdate()
          WHERE order_no = rec.order_no;
      END IF;
     
      v_return := ORDER_STATUS_SQL.CANCEL_ALL(o_error_message,
                                              rec.order_no,
                                              v_cancel_code,
                                              v_cancel_id,
                                              v_alloc_close_ind);

      --DBMS_OUTPUT.PUT_LINE('o_error_message = ' || o_error_message);

      IF (v_return) THEN 

         UPDATE ordhead
            SET status = 'C',
                close_date = get_vdate
          WHERE order_no = rec.order_no;
      ELSE
         DBMS_OUTPUT.PUT_LINE('v_return = ' || 'ERROR WAS ENCOUNTERED');
         RAISE le_error;
      END IF;

   END LOOP;

   COMMIT;

   EXCEPTION
      WHEN le_error THEN
         DBMS_OUTPUT.PUT_LINE('something happened error');
         ROLLBACK;

      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error was encountered: '||TO_CHAR(SQLCODE)||': '||SQLERRM);
         ROLLBACK;

END;
/