select * from (select ORDER_NO from SUPP_ASOS.ordhead oh where oh.status ='A' and oh.CREATE_DATETIME >= to_date('15-MAR-2021 14:15', 'DD-MON-YYYY hh24:mi')
    and not exists (select 1 from SUPP_ASOS.SC_ASNIN_PO asp where  CREATE_ID like 'PTESTUSER%'  and asp.PO_NBR = oh.order_no)) where  rownum <= '50000';


select count(*) from SUPP_ASOS.sc_asnin where CREATE_DATETIME >= to_date('16-MAR-2021 01:00', 'DD-MON-YYYY hh24:mi');

select * from SUPP_ASOS.sc_asnin where CREATE_DATETIME >= to_date('18-JAN-2021 01:00', 'DD-MON-YYYY hh24:mi');

select * from all_tables where table_name like '%QU%';

select * from supp_asos.sc_event_message;

839
840
838


SELECT (at_time-start_time)*24*60*60, processed, ROUND((processed/((at_time-start_time)*24*60*60)), 2) RATE
  FROM( select to_date('2021-03-17 09:15:00', 'YYYY-MM-DD HH24:MI:SS') start_time, count(*), 109454-count(*) processed, sysdate at_time  
from supp_asos.sc_event_message where  event_type = 'ASNInMod');


set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE VARCHAR2(200);
  l_ASN_NBR         supp_asos.SC_ASNIN.ASN_NBR%TYPE;
  l_VENDOR_NBR      supp_asos.SC_ASNIN.VENDOR_NBR%TYPE;
  I_ASN_NBR         supp_asos.SC_ASNIN.ASN_NBR%TYPE;
  I_VENDOR_NBR      supp_asos.SC_ASNIN.VENDOR_NBR%TYPE;
  I_EVENT_TYPE      VARCHAR2(15);
  I_MESSAGE_DATA    CLOB;
  I_ERROR_MESSAGE   VARCHAR2(4000);
  V_RETURN          BOOLEAN;
  COUNTER_COMMIT    NUMBER(8)     := 0;

  CURSOR C_ASNS IS
        select * from SUPP_ASOS.sc_asnin  --2788
            where CREATE_DATETIME >= to_date('16-MAR-2021 01:00', 'DD-MON-YYYY hh24:mi');
            
            TYPE t_asns IS TABLE OF supp_asos.SC_ASNIN%ROWTYPE;
               l_pub_asn t_asns;
  
BEGIN

 DBMS_OUTPUT.PUT_LINE('Start Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

   open C_ASNS;
   LOOP
    FETCH C_ASNS BULK COLLECT INTO l_pub_asn LIMIT 5000;
        EXIT WHEN l_pub_asn.count=0;

            FOR i IN l_pub_asn.FIRST.. l_pub_asn.LAST
        LOOP
            I_ASN_NBR       := l_pub_asn(i).ASN_NBR;
            I_VENDOR_NBR    := l_pub_asn(i).VENDOR_NBR;
            O_ERROR_MESSAGE := NULL;
            I_EVENT_TYPE    := 'ASNInMod';
   
            IF supp_asos.SC_ASNIN_PUB_SQL.ADDTOERRORQ(O_ERROR_MESSAGE => O_ERROR_MESSAGE,
                                            I_ASN_NBR       => I_ASN_NBR,
                                            I_VENDOR_NBR    => I_VENDOR_NBR,
                                            I_EVENT_TYPE    => I_EVENT_TYPE,
                                            I_MESSAGE_DATA  => I_MESSAGE_DATA,
                                            I_ERROR_MESSAGE => I_ERROR_MESSAGE) = FALSE THEN
              DBMS_OUTPUT.PUT_LINE('FAILED: '|| O_ERROR_MESSAGE || '-' || I_ERROR_MESSAGE);

            END IF;
           COUNTER_COMMIT :=COUNTER_COMMIT + 1;
       IF MOD(COUNTER_COMMIT,5000) = 0 THEN -- Commit every 5k records
                COMMIT;
                continue;
       END IF;

        END LOOP; 
    END LOOP;
    CLOSE C_ASNS;
   
   DBMS_OUTPUT.PUT_LINE('End Time: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
--      ROLLBACK;
END;
/

