select count(*) from SUPP_ASOS.sc_asnin; --1404181
select count(*) from SUPP_ASOS.sc_asnin; --1404181


select count(*) from SUPP_ASOS.sc_asnin where CREATE_DATETIME >= to_date('18-JAN-2021 01:00', 'DD-MON-YYYY hh24:mi'); 
SELECT count(*) FROM SUPP_ASOS.shipment where ORDER_no in (select ORDER_no from SUPP_ASOS.ordhead where CREATE_DATETIME>= to_date('18-JAN-2021 01:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%');

SELECT TO_LOC, count(1) FROM SUPP_ASOS.shipment where ORDER_no in (select ORDER_no from SUPP_ASOS.ordhead where CREATE_DATETIME>= to_date('18-JAN-2021 01:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%') group by TO_LOC;

select count(1) from SUPP_ASOS.ordhead where CREATE_DATETIME>= to_date('18-JAN-2021 01:05', 'DD-MON-YYYY hh24:mi') and comment_desc like '%PO Create%';

select count(1) from rms.ordhead where CREATE_DATETIME>= to_date('18-JAN-2021 02:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%';

SELECT count(1) FROM SUPP_ASOS.shipment where ORDER_no in (select ORDER_no from SUPP_ASOS.ordhead where CREATE_DATETIME>= to_date('18-JAN-2021 02:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%');

SELECT count(1) FROM SUPP_ASOS.shipment where ORDER_no in ('501090000000');

SELECT location,count(1) FROM SUPP_ASOS.ordloc where ORDER_no in (select ORDER_no from SUPP_ASOS.ordhead where CREATE_DATETIME>= to_date('18-JAN-2021 02:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%') group by location;


db.getCollection('exportedASNIn').find({})
db.getCollection('exportedASNIn').find({_id:"12853001006731"})
db.getCollection('publishedASNInRMS').find({_id:"12853001006731"})
db.getCollection('publishedASNInRMS').find({"_id":{$regex:"12853001006731"}})

db.getCollection('exportedPurchaseOrder').find({})
db.getCollection('exportedPurchaseOrder').find({_id:"PO_501000005108_exported"})
db.getCollection('exportedbaseproduct').find({})
db.getCollection('exportedbaseproduct').find({ItemNo:"101133006"})
    
select * from all_sequences where SEQUENCE_NAME like '%ASN%';
SELECT SUPP_ASOS.SC_ASN_SEQ.NEXTVAL FROM DUAL;


500834005073

select * from supp_asos.SC_ASNIN_PO WHERE PO_NBR = '500834005073';

select * from supp_asos.SC_ASNIN_PO where ASN_NBR ='12853019992019';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='12853019992019';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='12853019992019';

db.getCollection('exportedPurchaseOrder').find({_id:"PO_501090000000_exported"})



set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  VARCHAR2(25);
  curr_seq   VARCHAR2(25);
BEGIN
  SELECT 52253606467 INTO last_used FROM dual;

  LOOP
    SELECT SUPP_ASOS.SC_ASN_SEQ.NEXTVAL INTO curr_seq FROM dual;
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/



--2533 Create asn --1284 -- 10402

select count(*) from SUPP_ASOS.sc_asnin  --2788
    where  CREATE_DATETIME >= to_date('22-SEP-2020 08:50', 'DD-MON-YYYY hh24:mi'); 

--Amend asn ---- 8380

select count(*) from SUPP_ASOS.sc_asnin --520
    where  trunc(CREATE_DATETIME) <> trunc(LAST_UPDATE_DATETIME)
    and LAST_UPDATE_DATETIME >= to_date('11-SEP-2020 08:50', 'DD-MON-YYYY hh24:mi'); 



set SERVEROUTPUT ON;
set timing on;
DECLARE
  l_date   supp_asos.ordhead.PICKUP_DATE%type := '30-SEP-2020';

BEGIN
Update supp_asos.ordhead set PICKUP_DATE = l_date,EARLIEST_SHIP_DATE =l_date,LATEST_SHIP_DATE = l_date+1,
    NOT_BEFORE_DATE=l_date+2,NOT_AFTER_DATE=l_date+3 where order_no in 
        (select distinct po_nbr from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%'
--    and exists (select 1 from SUPP_ASOS.ordhead oh where oh.status ='A' and asp.PO_NBR = oh.order_no and oh.order_no between 50000831767 and 50000899259)
    and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR and sa.SHIPMENT_DATE >'28-MAY-2020'));
    
update supp_asos.SC_ASNIN set SHIPMENT_DATE =l_date, EST_ARR_DATE =l_date where asn_nbr in 
(select distinct asn_nbr from supp_asos.SC_ASNIN_PO where CREATE_ID like 'PTESTUSER%' and PO_NBR in 
    (select distinct po_nbr from SUPP_ASOS.SC_ASNIN_PO  asp where  CREATE_ID like 'PTESTUSER%'
--    and exists (select 1 from SUPP_ASOS.ordhead oh where oh.status ='A' and asp.PO_NBR = oh.order_no and oh.order_no between 50000831767 and 50000899259)
    and exists (select 1 from SUPP_ASOS.SC_ASNIN sa where sa.ASN_NBR = asp.ASN_NBR and sa.SHIPMENT_DATE >'28-MAY-2020')));
    
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/

