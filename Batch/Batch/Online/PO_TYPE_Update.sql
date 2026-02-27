7atzyj07f7xz0
8jg3mjumzknj2
100000
select 100000/3 from dual;


select item from rms.item_master where status ='A' and item_level ='1' and Item_DESC LIKE '%Item creation Perf Test%'
        and CREATE_DATETIME>= to_date('15-MAR-2021 15:10', 'DD-MON-YYYY hh24:mi');

select count(ORDER_NO) from rms.ordhead 
 where CREATE_DATETIME>= to_date('15-MAR-2021 01:25', 'DD-MON-YYYY hh24:mi');

select count(1) from alloc_header where ORDER_NO in ( select ORDER_NO from rms.ordhead 
 where CREATE_DATETIME>= to_date('15-MAR-2021 01:25', 'DD-MON-YYYY hh24:mi'));


select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL 
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('5uqgn017gtgy1','4gwcfhuqtqmc7')
and s.snap_id = SQL.snap_id
and s.begin_interval_time> TO_date('16-mar-2020 11:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time< TO_date('16-mar-2020 16:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;



insert into order_pro
select Distinct order_no from rms.ordhead where CREATE_DATETIME>= to_date('15-MAR-2021 12:25', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%';
    
select * from order_mfqueue;
SELECT po_type,count(1)
     FROM ordhead oh
    WHERE order_no  in (select order_no from skumar.order_pro) group by po_type;


--truncate table skumar.order_pro;
select * from skumar.order_pro;
select count(1) from order_mfqueue;

--Pre-POTRANSFORMATION

SET SERVEROUTPUT ON;
SET timing ON;
DECLARE
   o_error_message      VARCHAR2(200) := NULL;
   COUNTER_COMMIT       NUMBER(8)     := 0;

   Cursor C_GET_ord IS
    SELECT order_no
         FROM ordhead oh
        WHERE order_no  in (select order_no from skumar.order_pro) AND po_type!='D';

   TYPE order_ids_t IS TABLE OF ordhead.order_no%TYPE;
   l_ord_ids   order_ids_t; 
    
BEGIN

   open C_GET_ord;
   
   LOOP
    FETCH C_GET_ord BULK COLLECT INTO l_ord_ids LIMIT 10000;
        EXIT WHEN l_ord_ids.count=0;
--      DBMS_OUTPUT.put_line ('Retrieved ' || l_ord_ids.COUNT);

        FOR idx IN l_ord_ids.FIRST.. l_ord_ids.LAST
        LOOP
         UPDATE ordhead
            SET PO_TYPE = 'D',
                COMMENT_DESC = 'Pre-POTRANSFORMATION',
                LAST_UPDATE_ID = user,
                LAST_UPDATE_DATETIME= SYSTIMESTAMP
          WHERE order_no = l_ord_ids(idx) and PO_TYPE != 'D';

       COUNTER_COMMIT :=COUNTER_COMMIT + 1;
       IF MOD(COUNTER_COMMIT,10000) = 0 THEN -- Commit every 1000 records
                --COMMIT;
                continue;
       END IF;

        END LOOP; 
    END LOOP;
    CLOSE C_GET_ord;

   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error was encountered: '||TO_CHAR(SQLCODE)||': '||SQLERRM);
         ROLLBACK;

END;
/


select count(1) from order_mfqueue;
select * from order_pub_info where PUBLISHED = 'N';
DELETE from order_mfqueue;
UPDATE order_pub_info set PUBLISHED = 'N' where PUBLISHED = 'N';

    SELECT *
         FROM ordhead oh
        WHERE order_no  in (select order_no from skumar.order_pro);


SET SERVEROUTPUT ON;
SET timing ON;
DECLARE
   o_error_message      VARCHAR2(200) := NULL;
   COUNTER_COMMIT       NUMBER(8)     := 0;

   Cursor C_GET_ord IS
    SELECT order_no
         FROM ordhead oh
        WHERE order_no  in (select order_no from skumar.order_pro);

   TYPE order_ids_t IS TABLE OF ordhead.order_no%TYPE;
   l_ord_ids   order_ids_t; 
    
BEGIN

   open C_GET_ord;
   
   LOOP
    FETCH C_GET_ord BULK COLLECT INTO l_ord_ids LIMIT 5000;
        EXIT WHEN l_ord_ids.count=0;
--      DBMS_OUTPUT.put_line ('Retrieved ' || l_ord_ids.COUNT);

        FOR idx IN l_ord_ids.FIRST.. l_ord_ids.LAST
        LOOP
         UPDATE ordhead
            SET PO_TYPE = 'S',
                COMMENT_DESC = 'POTRANSFORMATION',
                LAST_UPDATE_ID = user,
                LAST_UPDATE_DATETIME= SYSTIMESTAMP
          WHERE order_no = l_ord_ids(idx);

       --COUNTER_COMMIT :=COUNTER_COMMIT + 1;
      -- IF MOD(COUNTER_COMMIT,25000) = 0 THEN -- Commit every 1000 records
                --COMMIT;
                --continue;
       --END IF;

        END LOOP; 
    END LOOP;
    CLOSE C_GET_ord;
 
 Commit;
 
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error was encountered: '||TO_CHAR(SQLCODE)||': '||SQLERRM);
         ROLLBACK;

END;
/

