SELECT email_po_retention_days
FROM SUPP_ASOS.sc_system_options;

select * from SUPP_ASOS.sc_email_order_pubinfo;

update SUPP_ASOS.sc_email_order_pubinfo set PROCESSED_IND ='Y',PROCESS_DATETIME =sysdate where PUBLISHED_IND ='Y';      
   
   
   
Update SUPP_ASOS.sc_email_order_pubinfo set process_datetime = SYSDATE - '31',processed_ind = 'Y' where  order_no in (SELECT order_no
FROM SUPP_ASOS.ordhead oh
WHERE
(0 < (NVL(MONTHS_BETWEEN(TO_DATE('20210509','YYYYMMDD'),
oh.close_date),0) - 25)));
                     
                     
                     
SELECT p.master_po_no, p.order_no, p.rev_no
FROM SUPP_ASOS.sc_email_order_pubinfo p
WHERE p.processed_ind = 'Y'
AND p.process_datetime <= SYSDATE - '30'
;
               select count(master_po_no) from SUPP_ASOS.sc_email_order_pubinfo where PUBLISHED_IND ='Y' and PROCESS_DATETIME is null;
             
             
        Update SUPP_ASOS.sc_email_order_pubinfo set process_datetime = SYSDATE - '31' where  order_no in (SELECT distinct order_no
              FROM SUPP_ASOS.ordhead oh
             WHERE 
             (0 < (NVL(MONTHS_BETWEEN(TO_DATE('20190127','YYYYMMDD'),
                     oh.close_date),0) - 24)) ); 
            commit;
            
          select master_po_no from SUPP_ASOS.sc_email_order_pubinfo where PUBLISHED_IND ='Y' and PROCESS_DATETIME is null ;
          
          
          
                 
set serveroutput on;
set timing on;
 
DECLARE
 l_master_po_no    SUPP_ASOS.sc_email_order_pubinfo.master_po_no%type;
 
 cursor cur_dept is
    select master_po_no from SUPP_ASOS.sc_email_order_pubinfo where PUBLISHED_IND ='Y' and PROCESS_DATETIME is null and
       rownum<= '100';


BEGIN

for k in 1..30 loop      
for i in cur_dept loop
l_master_po_no := i.master_po_no;

  Update SUPP_ASOS.sc_email_order_pubinfo set PROCESSED_IND ='Y',PROCESS_DATETIME =sysdate-k where PUBLISHED_IND ='Y' and master_po_no=l_master_po_no;


end loop;
 commit;
 end loop;
                   
 commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/



