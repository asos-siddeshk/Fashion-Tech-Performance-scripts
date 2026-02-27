select * from nb_system_parameters where func_area= 'MOM_MAINT' and parameter='TSF';
Update nb_system_parameters set value_2 ='500000' where func_area= 'MOM_MAINT' and parameter='TSF'; 

select count(1) from doc_purge_queue;


select * from doc_purge_queue dp where not exists (select 1 from rms.tsfhead th where dp.tsf_no= th.tsf_no);
select * from doc_purge_queue dp where exists (select 1 from rms.tsfhead th where dp.tsf_no= th.tsf_no);



SELECT system_options.tsf_history_mths,
             TO_CHAR((period.vdate + 1), 'YYYYMMDD')
        FROM system_options,
             period;
             
select trunc(CLOSE_DATE),count(1) from tsfhead  group by trunc(CLOSE_DATE) order by trunc(CLOSE_DATE);        
select CLOSE_DATE,count(1) from tsfhead where CLOSE_DATE <= '01-OCT-20' group by CLOSE_DATE order by CLOSE_DATE;        

BEGIN
Update  tsfhead set close_date ='19-JUN-18' where trunc(CLOSE_DATE) = '26-DEC-16' ;
Update  tsfhead set close_date ='18-JUN-18' where trunc(CLOSE_DATE) = '25-DEC-16' ;
Update  tsfhead set close_date ='17-JUN-18' where trunc(CLOSE_DATE) = '24-DEC-16' ;
Update  tsfhead set close_date ='16-JUN-18' where trunc(CLOSE_DATE) = '23-DEC-16' ;
Update  tsfhead set close_date ='15-JUN-18' where trunc(CLOSE_DATE) = '22-DEC-16';
commit;
END;
/

SELECT th.tsf_no,
             -1 child_tsf_no,
             th.to_loc,
             th.to_loc_type,
             th.from_loc,
             th.from_loc_type
        FROM tsfhead th
       WHERE th.mrt_no IS NULL
         AND NOT EXISTS (SELECT 'X'
                           FROM tsfhead th1
                          WHERE th1.tsf_parent_no = th.tsf_no)
         AND (th.status = 'D'
              OR (th.status = 'C'
                  AND MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'), th.close_date) >= :ol_tsf_history_mths))
      UNION ALL
      SELECT th.tsf_no,
             th1.tsf_no  child_tsf_no,
             th.to_loc,
             th.to_loc_type,
             th.from_loc,
             th.from_loc_type
        FROM tsfhead th,
             tsfhead th1
       WHERE (th.status = 'D'
              OR (th.status = 'C'
                  AND MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'),th.close_date) >= :ol_tsf_history_mths))
         AND (th1.tsf_parent_no = th.tsf_no
              AND (th1.status = 'D'
                   OR (th1.status = 'C'
                       AND MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'),th1.close_date) >= :ol_tsf_history_mths)));
                       
                       
SELECT alloc.alloc_no,
          -1 child_alloc_no,
          WH from_loc,
          'W' loc_type
     FROM alloc_header alloc
    WHERE alloc.order_no IS NULL
      AND NOT EXISTS (SELECT 'X'
                           FROM alloc_header alloc1
                            WHERE alloc1.alloc_parent = alloc.alloc_no)
          AND alloc.status = 'C'
         AND MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'), alloc.close_date) >= :ol_tsf_history_mths
       UNION ALL
       SELECT alloc.alloc_no,
              alloc1.alloc_no child_alloc_no,
              alloc.WH from_loc,
             'W' loc_type
        FROM alloc_header alloc,
              alloc_header alloc1
        WHERE alloc.order_no IS NULL
          AND alloc1.alloc_parent = alloc.alloc_no
           AND alloc.status = 'C'
          AND MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'), alloc.close_date) >= :ol_tsf_history_mths
          AND alloc1.status = 'C'
          AND MONTHS_BETWEEN(TO_DATE(:ps_vdate,'YYYYMMDD'), alloc1.close_date) >= :ol_tsf_history_mths;
          
          
SELECT doc_type,
          tsf_no,
          child_tsf_no,
          to_loc,
          to_loc_type,
          from_loc,
          from_loc_type
   FROM (SELECT  'T' doc_type,
                 dpq.tsf_no,
                 dpq.child_tsf_no,
                 nvl(dpq.to_loc,-999) to_loc,
                 nvl(dpq.to_loc_type,'X') to_loc_type,
                 dpq.from_loc,
                 dpq.from_loc_type
         FROM doc_purge_queue dpq
         WHERE EXISTS(SELECT 'x'
                      FROM v_restart_transfer rv
                      WHERE rv.driver_value = dpq.tsf_no)
         AND NOT EXISTS (SELECT 'x'
                        FROM gtt_alloc_ord_no ap
                       WHERE ap.order_no = dpq.tsf_no
                          OR ap.order_no = dpq.child_tsf_no)
      UNION ALL
      SELECT  'A' doc_type,
              dpq.alloc_no,
              dpq.child_alloc_no,
              dpq.from_loc,
              dpq.from_loc_type,
              dpq.from_loc,
              dpq.from_loc_type
       FROM   alloc_purge_queue dpq
       WHERE  EXISTS(SELECT 'x'
                     FROM v_restart_alloc rv
                     WHERE  rv.driver_value = dpq.alloc_no)
       AND NOT EXISTS (SELECT 'x'
       FROM gtt_alloc_ord_no ap
       WHERE ap.order_no = dpq.alloc_no
          OR ap.order_no = dpq.child_alloc_no) 
        )
    ORDER BY 1;
    
    
select * from alloc_purge_queue;
select count(1) from doc_purge_queue;
select count(1) from doc_purge_queue dp where not exists (select 1 from rms.tsfhead th where dp.tsf_no= th.tsf_no);
select count(1) from tsf_mfqueue;


select * from store;

select * from doc_purge_queue dp where not exists (select 1 from rms.tsfhead th where dp.tsf_no= th.tsf_no);
select * from doc_purge_queue dp where exists (select 1 from rms.tsfhead th where dp.tsf_no= th.tsf_no);

7282737110
7280222551
7282737111
7280027146
7280027147
7280027148

select count(1) from rms.tsf_mfqueue;

select * from ordcust where tsf_no in ('7280222551');
select * from ordcust_detail where ORDCUST_NO  in (select ORDCUST_NO from ordcust where tsf_no in ('7280222551'));
select * from rms.tsfhead where tsf_no in ('7280222551');
select * from rms.tsfdetail where tsf_no in ('7280222551');
select * from rms.shipment where shipment in (select shipment from rms.shipSKU where DISTRO_NO in ('7280027146','7280027147','7280027148'));
select * from rms.shipSKU where shipment in ('122871988');
select * from rms.shipSKU where DISTRO_NO in ('7280222551');
select * from rms.shipSKU_loc where shipment in ('122871988');
select * from rms.DOC_CLOSE_QUEUE where doc in ('7280222551');
select * from rms.item_loc_soh where  (item,loc) in (select ITEM, LOCATION from rms.tran_data where ref_no_1 in ('7280222551'));
select * from rms.tran_data where ref_no_1 in ('7280222551');


select TSF_NO, count(1) from ordcust group by tsf_no having count(1)>=2;

set serveroutput on;
set timing on;

declare

l_close_date                rms.tsfhead.close_date%type;
l_tsf_no              		rms.tsfhead.tsf_no%TYPE;

cursor c_template is
    select add_months(th.close_date,-25) as close_date,tsf_no from rms.tsfhead th where status ='C' --and close_date >='12-JUN-18'
        and rownum<='50000' order by TSF_NO;
             
begin


for i in c_template loop

		l_close_date                    :=i.close_date;
		l_tsf_no				    :=i.tsf_no;
		
		Update rms.tsfhead set CLOSE_DATE = l_close_date-2
            where tsf_no = l_tsf_no ;
end loop;
commit;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/




set serveroutput on;
set timing on;
DECLARE
  num_rec             NUMBER(10)                    := 30000;
  counter             NUMBER(10)                    := 0;
  c_commit  	        NUMBER(5)                     := 100;
  
  I_tsf_no            rms.tsfhead.tsf_no%TYPE           :=7013147120;
  n_tsfno            rms.tsfhead.tsf_no%TYPE  ;
  I_create_date       rms.tsfhead.delivery_date%TYPE    := sysdate - 392;
  n_seq_no            rms.tsfdetail.tsf_seq_no%TYPE;
  n_from_loc          rms.tsfhead.from_loc%TYPE         := 4001;
  n_from_loc_type     rms.tsfhead.from_loc_type%TYPE    := 'W';
  n_to_loc_type       rms.tsfhead.to_loc_type%TYPE      := 'W'; 
  n_to_loc            rms.tsfhead.to_loc%TYPE;
  
  n_ship              rms.shipment.shipment%TYPE;
  
  CURSOR cur_store IS
	select 	wh2.wh 
	from 	rms.wh wh1, rms.wh wh2 
	where 	wh1.org_unit_id!=wh2.org_unit_id and wh1.wh = '4001' 
    ORDER BY dbms_random.value; 

  
  CURSOR cur_tsf IS
  SELECT 	th.dept
			, th.inventory_type
			, th.tsf_type 
			, th.repl_tsf_approve_ind
  FROM rms.tsfhead th
  WHERE th.tsf_no = I_tsf_no;
  
  CURSOR cur_dtl IS
	select im.item,il.selling_unit_retail as TSF_PRICE,iscl.UNIT_COST as TSF_COST, '5' as tsf_qty,'N' as UPDATED_BY_RMS_IND,1 as supp_pack_size, im.DEPT, im.CLASS, im.SUBCLASS
				from rms.item_master im,rms.item_supp_country_loc iscl, rms.item_loc il
				where im.item=iscl.item and im.status='A' and im.tran_level = im.item_level
					and im.item=il.item
					and iscl.loc='4001'
					and iscl.loc =il.loc and rownum<='7' ORDER BY DBMS_RANDOM.VALUE;

BEGIN

  WHILE counter < num_rec LOOP
 
 
    IF MOD(counter, 1000) = 0 THEN -- Number of Tsf per day
      I_create_date := to_timestamp(I_create_date+1,'DD-MON-RR HH24.MI.SSXFF');
    END IF;
    
    FOR rc_tsf IN cur_tsf LOOP
      n_seq_no := 0;
    
      OPEN cur_store;
      FETCH cur_store INTO n_to_loc;
      CLOSE cur_store;
    
      SELECT rms.transfer_number_sequence.NEXTVAL
          INTO n_tsfno
          FROM sys.dual;

		  
      -- tsfhead
      INSERT INTO rms.tsfhead (tsf_no, from_loc_type, from_loc, to_loc_type, to_loc, EXP_DC_DATE, dept, inventory_type, tsf_type, status, freight_code, create_date,close_date,
                           create_id, repl_tsf_approve_ind, delivery_date,APPROVAL_DATE, APPROVAL_ID,EXT_REF_NO,EXP_DC_EOW_DATE,NOT_AFTER_DATE)
                VALUES(n_tsfno, n_from_loc_type, n_from_loc, n_to_loc_type, n_to_loc, I_create_date+1,rc_tsf.dept, rc_tsf.inventory_type, rc_tsf.tsf_type, 'C', 'N',
                       I_create_date,I_create_date, 'PTUSER', rc_tsf.repl_tsf_approve_ind, I_create_date+1,I_create_date, 'PTUSER','HIST',I_create_date,I_create_date);



      -- Sequence
      SELECT rms.shipment_sequence.nextval
      INTO n_ship
      FROM dual;

      INSERT INTO rms.shipment (shipment, bol_no, ship_date, receive_date, est_arr_date, ship_origin, status_code, to_loc, to_loc_type, from_loc, from_loc_type, courier, no_boxes)
                  VALUES (n_ship, n_tsfno, I_create_date, I_create_date+1, I_create_date+1, 3, 'R', n_to_loc, n_to_loc_type, n_from_loc, n_from_loc_type, 'DC', 1);

      FOR rc_dtl IN cur_dtl LOOP
      
        -- tsfdetail
        n_seq_no := n_seq_no + 1;
      
        INSERT INTO rms.tsfdetail(tsf_no, tsf_seq_no, item, tsf_price, tsf_qty, SHIP_QTY, RECEIVED_QTY,DISTRO_QTY, supp_pack_size, tsf_cost, updated_by_rms_ind,PUBLISH_IND)
                     VALUES(n_tsfno, n_seq_no, rc_dtl.item, rc_dtl.tsf_cost, rc_dtl.tsf_qty,rc_dtl.tsf_qty,rc_dtl.tsf_qty,'0', rc_dtl.supp_pack_size, rc_dtl.tsf_cost, rc_dtl.updated_by_rms_ind,'Y');

      
        INSERT INTO rms.shipsku (shipment, seq_no, item, distro_no, distro_type, carton, inv_status, status_code, qty_received, unit_cost, unit_retail, qty_expected)
                   VALUES (n_ship, n_seq_no, rc_dtl.item, n_tsfno, 'T', n_tsfno, -1, 'A', rc_dtl.tsf_qty, rc_dtl.tsf_cost, rc_dtl.tsf_price, rc_dtl.tsf_qty);
    
      END LOOP;
	 --   dbms_output.put_line('Tsf Success: '||n_tsfno);   
	
    END LOOP;
    
    counter   := counter + 1;

    IF MOD(counter, c_commit) = 0 THEN
      COMMIT;
    END IF;

	
	  END LOOP;
	commit;


EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line(substr(SQLERRM, 1, 255));
      ROLLBACK;
END;
/
