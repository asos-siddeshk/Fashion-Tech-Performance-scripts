select * from rib_message;
select * from rib_message_failure;

SELECT oh.alloc_no
     FROM alloc_header oh, order_pro op
    WHERE oh.order_no  = op.order_no ;

select count(1) from alloc_mfqueue;

SET SERVEROUTPUT ON;
SET timing ON;
DECLARE
   o_error_message      VARCHAR2(200) := NULL;
   COUNTER_COMMIT       NUMBER(8)     := 0;
    l_alloc_no          rms.alloc_header.alloc_no%TYPE;
    L_MESSAGE_TYPE        ALLOC_MFQUEUE.MESSAGE_TYPE%TYPE;
    L_TEXT                VARCHAR2(255) := NULL;

   Cursor C_GET_ALLOC IS
        SELECT oh.alloc_no
             FROM alloc_header oh, order_pro op
            WHERE oh.order_no  = op.order_no ;

   TYPE alloc_ids_t IS TABLE OF alloc_header.alloc_no%TYPE;
       l_alloc_ids   alloc_ids_t; 

BEGIN
    L_MESSAGE_TYPE := 'AllocHdrMod';
    
   open C_GET_ALLOC;
   LOOP
    FETCH C_GET_ALLOC BULK COLLECT INTO l_alloc_ids LIMIT 100000;
        EXIT WHEN l_alloc_ids.count=0;

        FOR idx IN l_alloc_ids.FIRST.. l_alloc_ids.LAST
        LOOP
            l_alloc_no := l_alloc_ids(idx);
   
                  UPDATE ALLOC_PUB_INFO API
                   SET API.PUBLISHED = 'N'
                 WHERE API.ALLOC_NO = l_alloc_no;
                --
                DELETE FROM ALLOC_DETAILS_PUBLISHED WHERE ALLOC_NO = l_alloc_no;
                --
                IF L_MESSAGE_TYPE IS NOT NULL THEN
                  --
                  IF RMSMFM_ALLOC.ADDTOQ(L_TEXT,
                                         L_MESSAGE_TYPE,
                                         l_alloc_no,
                                         'A',
                                         NULL) = FALSE THEN
                    --TO_LOC is null for a header level call
                    DBMS_OUTPUT.PUT_LINE('Alloc :' || l_alloc_no || 'Error :' || L_TEXT);
                    exit;
                  else
                    --DBMS_OUTPUT.PUT_LINE('Alloc :' || l_alloc_no || 'Success');
                    Continue;
                  END IF;
                  --
                END IF;

        END LOOP; 
    END LOOP;
    CLOSE C_GET_ALLOC;
    commit;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
--      ROLLBACK;
END;
/

