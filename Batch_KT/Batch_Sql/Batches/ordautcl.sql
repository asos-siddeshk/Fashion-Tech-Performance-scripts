select * from all_tables where owner like 'SKUMAR' and table_name like '%PUB_INFO%';

select status,count(1) from rms.ordhead group by status;

select CLOSE_DATE,count(1) from rms.ordhead group by CLOSE_DATE order by 1 desc;
UPdate ordhead set CLOSE_DATE ='12-JUN-18' where CLOSE_DATE < '12-JUN-18';



UPdate ordhead set CLOSE_DATE ='12-JUN-18' where CLOSE_DATE < '12-JUN-18';





select * from ORDER_PUB_INFO;

   SELECT ord_appr_close_delay, --180	999	762	Y	20181114
             ord_part_rcvd_close_delay,
             ord_worksheet_clean_up_delay,
             ord_auto_close_part_rcvd_ind,
             TO_CHAR(vdate,'YYYYMMDD')
        FROM system_options,
             period;
             
             --180	999	762	Y	20181114
 SELECT '1', -- null -- 8460
             oh1.order_no
        FROM ordhead oh1
       WHERE oh1.status != 'C'
         AND oh1.orig_approval_date IS NOT NULL
         AND TO_DATE(:ps_vdate,'YYYYMMDD') - oh1.not_after_date >= :pi_ord_appr_close_delay
         AND NOT EXISTS (SELECT 1
                           FROM shipment sh1
                          WHERE sh1.order_no = oh1.order_no
                            AND sh1.status_code != 'C'
                            AND ROWNUM = 1)
         AND NOT EXISTS (SELECT 1
                           FROM appt_head ah,
                                appt_detail ad
                          WHERE ad.appt = ah.appt
                            AND ad.doc = oh1.order_no
                            AND ad.doc_type = 'P'
                            AND ah.status != 'AC'
                            AND ROWNUM = 1)
         AND oh1.otb_eow_date is not null;



SELECT  --'3' --, --category,
             oh3.order_no
        FROM ordhead oh3
       WHERE oh3.status IN ('W','S')
         AND oh3.orig_approval_date IS NULL
         AND oh3.orig_ind = 2 -- Manual orders only 
         AND TO_DATE(:ps_vdate,'YYYYMMDD') - oh3.written_date > :pi_ord_worksheet_clean_up_delay
         AND oh3.otb_eow_date is not null;
         
              --180	999	762	Y	20181114
         
select distinct order_no from order_details_published where order_no in (select order_no from order_pub_info);


 SELECT '2' ,  -- 8155
             oh2.order_no
        FROM ordhead oh2
       WHERE oh2.status != 'C'
         AND oh2.orig_approval_date IS NOT NULL
         AND (( (:pi_ord_part_rcvd_close_delay > 0 
	         AND TO_DATE(:ps_vdate,'YYYYMMDD') - oh2.not_after_date >= :pi_ord_part_rcvd_close_delay
	         AND TO_DATE(:ps_vdate,'YYYYMMDD') - :pi_ord_part_rcvd_close_delay >=
	                     (SELECT MAX(TRUNC(NVL(sh2.est_arr_date, sh2.ship_date)))
	                        FROM shipment sh2
	                       WHERE sh2.order_no = oh2.order_no
	                         AND sh2.status_code not in ('C','I')))
	         OR (:pi_ord_part_rcvd_close_delay = 0 
	             AND TO_DATE(:ps_vdate,'YYYYMMDD') >=
	                    (SELECT MAX(TRUNC(sh4.receive_date))
	                       FROM shipment sh4
	                      WHERE sh4.order_no = oh2.order_no
	                        AND sh4.receive_date is not NULL)))                    
	         OR (TO_DATE(:ps_vdate,'YYYYMMDD') - oh2.not_after_date >= :pi_ord_appr_close_delay
	             AND TO_DATE(:ps_vdate,'YYYYMMDD') - :pi_ord_appr_close_delay >=
	                        (SELECT MAX(TRUNC(NVL(sh2.est_arr_date, sh2.ship_date)))
	                           FROM shipment sh2
	                          WHERE sh2.order_no = oh2.order_no
                                    AND sh2.status_code ='I')))
         AND NOT EXISTS (SELECT 1
                           FROM appt_head ah,
                                appt_detail ad,
                                shipment sh3
                          WHERE sh3.order_no = oh2.order_no
                            AND sh3.asn = ad.asn
                            AND ad.appt = ah.appt
                            AND ah.status != 'AC'
                            AND sh3.status_code != 'C'
                            AND ROWNUM = 1);
 
                            
select * from ORDCUST_PUB_INFO;




set serveroutput on;
set timing on;

declare

l_order_no                rms.ordhead.order_no%type;

cursor c_template is
	 select order_no from rms.ordhead oh1 where status  ='C' AND oh1.orig_approval_date IS NOT NULL
         AND rms.get_vdate - oh1.not_after_date >= 180--:pi_ord_appr_close_delay
         AND NOT EXISTS (SELECT 1
                           FROM rms.shipment sh1
                          WHERE sh1.order_no = oh1.order_no
                            AND sh1.status_code != 'C'
                            AND ROWNUM = 1) and rownum <='1000';
     

   
             
begin

for i in c_template loop

		l_order_no                    :=i.order_no;

	Update rms.ordhead set status ='A' where order_no =l_order_no;

end loop;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/

/* TESTING;
-------
SELECT * from rms.SVC_PROCESS_TRACKER;  */

