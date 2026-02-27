select * from sups where sup_status = 'A' and SUPPLIER_PARENT is not null;

drop table supplier_deal;

create table supplier_deal as 
    select * from (select distinct supplier,count(*) as cnt_ord from ordhead where status= 'A' group by supplier order by 2 desc );
    
select * from supplier_deal;
select SUPPLIER_PARENT,supplier from sups where supplier_parent in ('1000000477','1000000484','1000000485');
select SUPPLIER_PARENT,supplier from sups where supplier in (select supplier from supplier_deal);
select SUPPLIER_PARENT,supplier from sups;

select * from rms.deal_head;
select * from rms.deal_head;

1000000477
1000000484
1000000485



select * from  rms.deal_itemloc_div_grp where deal_id >='735065001';
select * from sups where supplier = '1100004648';
select * from sups where supplier = '1100000952';

select * from ma_asos.ma_logs;

select * from rms.deal_head;
select * from rms.deal_head order by 1 desc;

select * from  rms.DEAL_HEAD where deal_id ='735065001';
select * from  rms.DEAL_DETAIL where deal_id ='735065001';
select * from  rms.DEAL_THRESHOLD where deal_id ='735065001'; --3%
select * from  rms.deal_itemloc_div_grp where deal_id ='735065001';
select * from  rms.DEAL_ITEM_LOC_explode where deal_id ='735070001';
select * from future_Cost where item in ('8324231','8324232','8324233') and supplier = '1100004633' and location = '1001';

select * from  rms.DEAL_ITEM_LOC_explode;

select * from ma_asos.ma_stg_ordloc_discount;
select * from ma_asos.ma_stg_ordloc_discount;


select * from sups where supplier not in (select supplier from deal_head);
select * from sups where supplier not in (select supplier from deal_head) and SUP_STATUS = 'A' and supplier_parent is not null;

select * from cost_event_run_type_config;
update rms.cost_event_run_type_config set event_run_type = 'ASYNC' where event_type in ('D','DP');

select deal_id,count(1) from  rms.DEAL_ITEM_LOC_explode group by deal_id;--735065701	1264277

select * from rms.nb_create_deals;
select * from sups where supplier not in (select supplier from deal_head);
select * from sups where supplier not in (select supplier from deal_head) and SUP_STATUS = 'A' and supplier_parent is not null;
select count(1) from rms.deal_head where status='C';

select count(1) from rms.deal_head where status ='A' and close_date <rms.get_vdate;
select count(1) from rms.deal_head where status ='A' and close_date <rms.get_vdate;


select * from sups where supplier in ('1100004648');
select * from deal_head where supplier = '1000001423';

select * from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('26-APR-2023 11:00', 'DD-MON-YYYY hh24:mi'));
select * from  SVC_ORDHEAD where master_po_no in (select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('26-APR-2023 11:00', 'DD-MON-YYYY hh24:mi'));
select * from  coresvc_po_err where order_no = '500060025850';
select * from rms.ordhead where CREATE_DATETIME>= to_date('26-APR-2023 11:00', 'DD-MON-YYYY hh24:mi');
select * from item_supp_country_loc where item = '129227003';



Update deal_head set APPROVAL_DATE = ACTIVE_DATE -2, APPROVAL_ID ='RMS' where status ='A' and APPROVAL_DATE is null;
Update deal_head set CREATE_DATETIME = APPROVAL_DATE where status ='A';

select * from rms.deal_head order by ACTIVE_DATE desc;
select * from rms.period;

select * from  rms.DEAL_HEAD where deal_id between 40001 and 40005;
select * from  rms.DEAL_DETAIL where deal_id between 40001 and 40005;
select * from  rms.DEAL_ACTUALS_FORECAST where deal_id between 40001 and 40005;
select * from  rms.DEAL_THRESHOLD where deal_id between 40001 and 40005;
select * from  rms.DEAL_ITEMLOC_DCS where deal_id between 40001 and 40005;
select * from  rms.DEAL_ITEM_LOC_explode where deal_id between 40001 and 40005;
select deal_id,count(deal_id) from  rms.DEAL_ITEM_LOC_explode where deal_id between 40001 and 40005 group by deal_id;
select deal_id,count(deal_id) from  rms.DEAL_ITEM_LOC_explode group by deal_id;

cd /home/siddeshk
date
cp deals_40001.sql /home/oracle/custom/deal
cp deals_40002.sql /home/oracle/custom/deal
cp deals_40003.sql /home/oracle/custom/deal
cp deals_40004.sql /home/oracle/custom/deal
cp deals_40005.sql /home/oracle/custom/deal
date
cd /home/oracle/custom/deal
sqlplus $UP

cd /orabin/app/oracle/product/retail/batch/oracle/proc/bin
./fcthreadexec $UP
echo $?
./prepost $UP fcexec pre
echo $?
./fcexec $UP
echo $?

select * from emer_price_hist;
select * from  rms.DEAL_HEAD where deal_id between 60018  and 735065002;
select * from  rms.DEAL_DETAIL where deal_id between 60018  and 735065002;
select * from  rms.DEAL_ACTUALS_FORECAST where deal_id between 60018  and 735065002;
select * from  rms.DEAL_THRESHOLD where deal_id between 60018  and 735065002;
select * from  rms.DEAL_ITEMLOC_DCS where deal_id between 60018  and 735065002;
select * from  rms.DEAL_ITEM_LOC_explode where deal_id between 60018  and 735065002;
select deal_id,count(deal_id) from  rms.DEAL_ITEM_LOC_explode where deal_id between 60018  and 735065002 group by deal_id order by 1 desc;
select deal_id,count(deal_id) from rms.DEAL_ITEM_LOC_explode group by deal_id order by 1 desc;
delete from deal_queue;
select * from cost_event order by 1 desc;
select * from cost_event_deal where deal_id between 90071  and 90080 order by 1 desc;
select * from rms.cost_event_deal;
select * from rms.cost_event_deal;
select * from cost_event_deal;
select * from rms.cost_event_thread order by 1 desc;

select * from cost_event_thread;


select * from rms.cost_event_result where status!='C' order by 1 desc;
update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;

select * from DEAL_ITEM_LOC_explode;
select deal_id,count(deal_id) from rms.DEAL_ITEM_LOC_explode group by deal_id order by 1 desc;

Update rms.DEAL_HEAD set est_next_invoice_date=null where CLOSE_DATE <'30-DEC-18' and est_next_invoice_date is not null;


select count(1) from tran_data where tran_code ='20' and (item,location) in (select item,location from rms.DEAL_ITEM_LOC_explode dh, rms.period p where p.vdate between ACTIVE_DATE and CLOSE_DATE);
select count(1) from tran_data where tran_code ='1' and (item,location) in (select item,location from rms.DEAL_ITEM_LOC_explode dh, rms.period p where p.vdate between ACTIVE_DATE and CLOSE_DATE);

select DEAL_HISTORY_MONTHS from RMS.PURGE_CONFIG_OPTIONS;
Update PURGE_CONFIG_OPTIONS set DEAL_HISTORY_MONTHS ='25';

select * from rms.cost_event_deal;
delete from rms.cost_event_deal where deal_id not between 90071 and 90081;
select * from rms.cost_event_deal where deal_id not between 90071 and 90081;
select * from cost_event_run_type_config;

delete FROM cost_event_deal;
delete FROM cost_event where cost_event_process_id in (select cost_event_process_id from cost_event_deal) ;
delete FROM cost_event_deal;


 --fcthread   
    SELECT count(ce.cost_event_process_id)
    FROM cost_event ce,.
             cost_event_run_type_config cec,
             (SELECT ced.cost_event_process_id cost_event_process_id,
                     ced.deal_id key_value
                FROM cost_event_deal ced
              UNION ALL
              SELECT cecc.cost_event_process_id cost_event_process_id,
                     cecc.cost_change key_value
                FROM cost_event_cost_chg cecc 
             ) cekv
       WHERE NVL(ce.override_run_type,cec.event_run_type) = 'BATCH'
         AND cec.event_type = ce.event_type
         AND ce.rowid not in (SELECT ce1.rowid
                              FROM cost_event ce1,
                                   cost_event_result cer
                             WHERE ce1.cost_event_process_id = cer.cost_event_process_id)
         AND cekv.cost_event_process_id(+) = ce.cost_event_process_id
    ORDER BY ce.cost_event_process_id;
      
select * from cost_event_result where status!='C' order by 1 desc;
              
          delete from cost_event where cost_event_process_id  in ( select cost_event_process_id from cost_event_deal );
         delete from cost_event_deal;
         
         
         
--fcexec    
drop table cost_event_check;

--create table cost_event_check as 
      SELECT distinct ce.cost_event_process_id
        FROM cost_event_result cer,
             cost_event_run_type_config cec,        
             cost_event ce
       WHERE NVL(ce.override_run_type,cec.event_run_type) = 'BATCH'
         AND cec.event_type = ce.event_type
         AND cer.cost_event_process_id = ce.cost_event_process_id
           AND 
                (     cer.status = 'N' 
                  AND cer.attempt_num = 0 )
              AND not exists (SELECT 'x'	 	 
                                FROM cost_event_result cer2	 	 
                               WHERE cer2.cost_event_process_id	= cer.cost_event_process_id 	 
                                 AND cer2.thread_id = cer.thread_id
                                 AND cer2.attempt_num > cer.attempt_num);
                                 
                                 
              
              
              
              
          delete from cost_event where cost_event_process_id  in ( select cost_event_process_id from cost_event_deal );
         delete from cost_event_deal;
                
                
--- Sales                                  --
 set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_error_message VARCHAR2(255):=NULL;
  i_dept    NUMBER(5);
  i_dept_c  NUMBER(10);
  COUNTER         NUMBER(5)    := 0;

CURSOR c_dept
       IS 
    select SETUP_DEPT,location from (
    select distinct dile.SETUP_DEPT,dile.location,1 from rms.deal_item_loc_explode dile,rms.period p 
        where p.vdate between dile.ACTIVE_DATE and dile.CLOSE_DATE and dile.loc_type ='S'
        group by dile.SETUP_DEPT,dile.location ) ;

BEGIN
   FOR ship_rec IN c_dept LOOP
        i_dept := ship_rec.SETUP_DEPT;
        i_dept_c := ship_rec.location;
 
    skumar.DEALS_SALES_BUILD_RMS(i_dept_c,i_dept, 50);
		commit;
 
 END LOOP;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/   
                     
----PO--
drop table orders_oct14;
create table orders_oct14 as 
SELECT DISTINCT oh.order_no,
                    ol.loc_type,
                    ol.location,
					oh.supplier,
                    oh.not_after_date
    FROM            rms.ordhead oh, rms.ordloc ol                    
    WHERE           oh.status     = 'A'
      AND           oh.order_no=ol.order_no
      and           oh.order_no in  (select distinct oh.order_no from rms.ordhead oh,rms.ordloc ol where 
                                    oh.order_no = ol.order_no and 
                                    (ol.item,ol.location) in 
                                        (select dile.item,dile.location from rms.deal_item_loc_explode dile, rms.period p  
                                                where p.vdate between dile.ACTIVE_DATE and dile.CLOSE_DATE))
	 and not exists (select 1 from rms.shipment where order_no = oh.order_no) and rownum<='10000';
     
     
     
     select * from month_data;
     
     select * from dba_source where text like '%DEAL%' and owner like 'RMS';
     
     
     select * from order_mfqueue;