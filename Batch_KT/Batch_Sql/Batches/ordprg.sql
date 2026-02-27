select * from rms.restart_control where program_name like '%ordprg%';
select * from rms.restart_bookmark where restart_name like '%ordprg%';

SELECT count(distinct(order_no)) 
              FROM rms.ordhead oh
             WHERE (0 < (NVL(MONTHS_BETWEEN(TO_DATE('20210509','YYYYMMDD'),
                     oh.close_date),0) - 25));
             
             
             select count(1) from item_master where item_level ='1'; --748915
             

        select * from rpm_zone_location;
             
             
       SELECT DISTINCT oh.order_no
         FROM ordhead oh,
              ordhead_rev ohr
        WHERE oh.status = 'C'
          AND ohr.order_no = oh.order_no
          AND (TO_DATE('20200301','YYYYMMDD') - 182) >
              NVL(oh.close_date, TO_DATE('20200301','YYYYMMDD'));
              

SELECT s.edi_rev_days,
             s.repl_order_history_days,
             TO_CHAR(p.vdate,'YYYYMMDD'),
             pc.order_history_months,
             s.import_ind
        FROM system_options s,
             period p,
             purge_config_options pc;


select * from item_master where item in ('187879095');

select * from rms.restart_control where program_name like '%ordprg%';
select * from rms.restart_bookmark where restart_name like '%ordprg%';

select CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;
select status,COUNT(1) from rms.ordhead GROUP BY status ORDER BY 1 desc;

 SELECT s.edi_rev_days,
             s.repl_order_history_days,
             TO_CHAR(p.vdate,'YYYYMMDD'),
             pc.order_history_months,             
             s.import_ind
        FROM system_options s,
             period p,
             purge_config_options pc;
     --   1	14	20181202	6	Y
           
 select * from ordhead where status in ('W','S');
 
 create table order_no_pur as
 SELECT order_no 
              FROM ordhead oh
             WHERE
             ((0 < (NVL(MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'),
                     oh.close_date),0) - :pi_hist_months))
              );
                              
          select * from ordhead where order_no ='50000499533';
          select * from ordloc where order_no ='50000499533';
          select * from ordsku where order_no ='50000499533';
          select * from shipment where order_no ='50000499533';
          select * from alloc_header where order_no ='50000499533';
          --Update shipment set status_code ='C' where order_no ='18900000281';
          select * from shipsku where shipment ='63304';
                              
SELECT goh.order_no,
             NVL(lc.lc_ind,0)
        FROM gtt_ordhead_order_no goh,
             ordlc lc
       WHERE lc.order_no(+) = goh.order_no

         AND EXISTS ( SELECT 1
                        FROM shipsku ss, shipment sh
                       WHERE sh.shipment = ss.shipment
                         AND goh.order_no = sh.order_no                      
                         AND ( ss.match_invc_id IS NULL OR EXISTS (SELECT 1 
                                                                     FROM invc_head ih
                                                                    WHERE ss.match_invc_id = ih.invc_id
                                                                      AND edi_sent_ind != 'N' ))) 
                    
      UNION
        SELECT goh.order_no,
               NVL(lc.lc_ind,0)
          FROM gtt_ordhead_order_no goh,
               ordlc lc
         WHERE lc.order_no(+) = goh.order_no
           AND NOT EXISTS (SELECT 'x'
                             FROM shipment sh
                            WHERE sh.order_no = goh.order_no);
                            
                            
select * from doc_close_queue;
                            
select DISTINCT CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;

Update ordhead set CLOSE_DATE ='12-JUN-18' where trunc(CLOSE_DATE) <'12-JUN-18';
Update ordhead set CLOSE_DATE ='1-DEC-18' where trunc(CLOSE_DATE) ='21-MAR-21' and rownum<='10000';  
Update ordhead set CLOSE_DATE ='3-DEC-18' where trunc(CLOSE_DATE) ='21-MAR-21' and rownum<='10000';  
Update ordhead set CLOSE_DATE ='4-DEC-18' where trunc(CLOSE_DATE) ='21-MAR-21' and rownum<='10000';  
Update ordhead set CLOSE_DATE ='5-DEC-18' where trunc(CLOSE_DATE) ='21-MAR-21' and rownum<='10000';  
Update ordhead set CLOSE_DATE ='6-DEC-18' where trunc(CLOSE_DATE) ='21-MAR-21' and rownum<='10000';  
Update ordhead set CLOSE_DATE ='7-DEC-18' where trunc(CLOSE_DATE) ='21-MAR-21' and rownum<='10000';  

drop table order_pur;
create table order_pur as
             SELECT order_no
              FROM ordhead oh
             WHERE
             (
              (0 < (NVL(MONTHS_BETWEEN(TO_DATE('20181202','YYYYMMDD'),
                     oh.close_date),0) - 6))
              OR
              (oh.status in ('W','S')
               AND oh.orig_ind = 0
               AND oh.orig_approval_date is NULL /* Indicates order was never approved*/
               AND oh.contract_no is NULL
               AND (TO_DATE('20181202','YYYYMMDD') - 14 >= oh.written_date )
             ));
             
             
             
select * from order_no_pur;

Update
select close_date from ordhead where status!='C' and order_no in ( select order_no from order_no_pur);


Update ordhead set close_date = '15-DEC-2018' where status='C' and close_date!= '15-DEC-2018'
    and order_no in ( select order_no from order_no_pur) and rownum <='5000';
select CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;



order_pur

select * from ordhead where order_no in ( select order_no from order_pur);
select distinct order_no from ordloc where order_no in ( select order_no from order_pur);
select distinct order_no from ordsku where order_no in ( select order_no from order_pur);


select * from ordhead where order_no not in (select order_no from ordloc);

select DISTINCT CLOSE_DATE,COUNT(1) from rms.ordhead GROUP BY CLOSE_DATE ORDER BY 1 desc;
select * from ordhead where status='C' and close_date is null;
Update ordhead set close_date ='13-JUN-18' where status='C' and close_date is null;