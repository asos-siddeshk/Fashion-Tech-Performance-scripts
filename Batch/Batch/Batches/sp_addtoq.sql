
select distinct application_code from SUPP_ASOS.RAF_NOTIFICATION_TYPE_B;

select * from all_tables where table_name like 'RAF_NOTIFICATION_TYPE_B';

RAF_NOTIFICATION_TASK_PKG.DEL_NOTIF_PAST_RETENTION


/orabin/app/oracle/product/retail/database/dbsql_supp_asosdas/supp_asos/packages

SC_EMAIL_ORDER_SQL.ADDTOQ

SELECT email_po_retention_days
      FROM SUPP_ASOS.sc_system_options; --30

SELECT  supplier,master_po_no,rev_no
      FROM  (select oh.supplier,
                    oh.master_po_no,
                    max(ohr.rev_no) rev_no
               from SUPP_ASOS.ordhead oh,
                    SUPP_ASOS.ordhead_rev ohr
              where oh.order_no    = ohr.order_no(+)
                and NVL(oh.master_po_no,0) != 0
                and oh.status != 'W'
              group by oh.supplier, oh.master_po_no) tab 
       WHERE NOT EXISTS  (select 1
                         from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO pi
                        where pi.supplier      = tab.supplier
                          and pi.master_po_no  = tab.master_po_no
                          and pi.rev_no       >= tab.rev_no
                          and pi.published_ind = 'Y')
         AND NOT EXISTS (SELECT 1
                            FROM SUPP_ASOS.sc_email_order_queue oq
                          WHERE tab.supplier = oq.supplier
                            AND tab.master_po_no = oq.master_po_no
                            AND oq.status IN ('E', 'U'))
   AND ((EXISTS (SELECT 1 FROM SUPP_ASOS.sc_supp_cfg sc where supplier = sc.supplier_id AND sc.order_email_notify = 'Y'))
        OR
         (NOT EXISTS (SELECT 1 FROM SUPP_ASOS.sc_supp_cfg sc where supplier = sc.supplier_id))
       ) ;

SELECT  supplier,count(1)
      FROM  (select oh.supplier,
                    oh.master_po_no,
                    max(ohr.rev_no) rev_no
               from SUPP_ASOS.ordhead oh,
                    SUPP_ASOS.ordhead_rev ohr
              where oh.order_no    = ohr.order_no(+)
                and NVL(oh.master_po_no,0) != 0
                and oh.status != 'W'
              group by oh.supplier, oh.master_po_no) tab
       WHERE NOT EXISTS  (select 1
                         from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO pi
                        where pi.supplier      = tab.supplier
                          and pi.master_po_no  = tab.master_po_no
                          and pi.rev_no       >= tab.rev_no
                          and pi.published_ind = 'Y')
         AND NOT EXISTS (SELECT 1
                            FROM SUPP_ASOS.sc_email_order_queue oq
                          WHERE tab.supplier = oq.supplier
                            AND tab.master_po_no = oq.master_po_no
                            AND oq.status IN ('E', 'U'))
   AND (
         (EXISTS (SELECT 1 FROM SUPP_ASOS.sc_supp_cfg sc where supplier = sc.supplier_id AND sc.order_email_notify = 'Y'))
        OR
         (NOT EXISTS (SELECT 1 FROM SUPP_ASOS.sc_supp_cfg sc where supplier = sc.supplier_id))
       ) group by supplier;



select * from SUPP_ASOS.ordhead where master_po_no ='20064565';
select * from SUPP_ASOS.ordhead_rev where ORDER_NO in (select ORDER_NO from SUPP_ASOS.ordhead where master_po_no ='20064565');
select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO where master_po_no ='20064565';
select * from SUPP_ASOS.sc_email_order_queue where status ='E';
select status,count(1) from SUPP_ASOS.sc_email_order_queue group by status;
select distinct ERROR_MSG,count(1) from SUPP_ASOS.sc_email_order_queue group by ERROR_MSG;

select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO where PROCESS_DATETIME is null;

delete  from SUPP_ASOS.sc_email_order_queue;
select count(1) from SUPP_ASOS.sc_email_order_queue;
select STATUS,count(1) from SUPP_ASOS.sc_email_order_queue group by status;


Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set PUBLISHED_IND ='N', PROCESSED_IND='N', PROCESS_DATETIME =null where supplier in  
        (select supplier from (select SUPPLIER, count(1) from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  having count(1) between 1400 and 1800 group by SUPPLIER));

select SUPPLIER, count(1) from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  having count(1) between 1400 and 1800 group by SUPPLIER;



select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO sceop where not exists 
    (select 1 from SUPP_ASOS.ordhead_rev ohr where ohr.ORDER_NO=sceop.ORDER_NO and ohr.REV_NO=sceop.REV_NO);

begin
delete from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO sceop where not exists 
    (select 1 from SUPP_ASOS.ordhead_rev ohr where ohr.ORDER_NO=sceop.ORDER_NO and ohr.REV_NO=sceop.REV_NO);
commit;
end;
/

----------------------------------


select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO where PROCESSED_IND = 'N';

insert into SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  
SELECT  supplier,master_po_no,order_no,rev_no,null,'Y','N',sysdate,sysdate,null
      FROM  (select oh.supplier,
                    oh.master_po_no,
                    oh.order_no,
                    max(ohr.rev_no) rev_no
               from SUPP_ASOS.ordhead oh,
                    SUPP_ASOS.ordhead_rev ohr
              where oh.order_no    = ohr.order_no 
                and NVL(oh.master_po_no,0) != 0
                and oh.status != 'W'
              group by oh.supplier, oh.master_po_no,oh.order_no) tab
       WHERE NOT EXISTS  (select 1
                         from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO pi
                        where pi.supplier      = tab.supplier
                          and pi.master_po_no  = tab.master_po_no
                          and pi.rev_no       >= tab.rev_no
                          and pi.published_ind = 'Y')
         AND NOT EXISTS (SELECT 1
                            FROM SUPP_ASOS.sc_email_order_queue oq
                          WHERE tab.supplier = oq.supplier
                            AND tab.master_po_no = oq.master_po_no
                            AND oq.status IN ('E', 'U'))
   AND ((EXISTS (SELECT 1 FROM SUPP_ASOS.sc_supp_cfg sc where supplier = sc.supplier_id AND sc.order_email_notify = 'Y'))
        OR
         (NOT EXISTS (SELECT 1 FROM SUPP_ASOS.sc_supp_cfg sc where supplier = sc.supplier_id))
       ) ;
    
    
    
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20121652 and ORDER_NO = 11500288831 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20088590 and ORDER_NO = 10900180741 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20061571 and ORDER_NO = 3300112331 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20082492 and ORDER_NO = 10900166971 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20019479 and ORDER_NO = 6900036471 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20112770 and ORDER_NO = 4000257511 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20020735 and ORDER_NO = 6900038941 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20002825 and ORDER_NO = 6700006431 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20126217 and ORDER_NO = 3000306781 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20019003 and ORDER_NO = 6900035641 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20043911 and ORDER_NO = 10800084961 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20127291 and ORDER_NO = 3000313791 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20092899 and ORDER_NO = 4700194681 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20079728 and ORDER_NO = 10900158521 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20126061 and ORDER_NO = 11500306101 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20025997 and ORDER_NO = 11300050591 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20080203 and ORDER_NO = 10900160371 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20086547 and ORDER_NO = 10900175411 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20116837 and ORDER_NO = 11500272651 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20126795 and ORDER_NO = 3000310351 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20111714 and ORDER_NO = 3000254351 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20127269 and ORDER_NO = 3000313581 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20126729 and ORDER_NO = 3000309891 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20124260 and ORDER_NO = 3000298131 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20059207 and ORDER_NO = 3300108861 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20091048 and ORDER_NO = 4700190411 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20090635 and ORDER_NO = 3600189171 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20017968 and ORDER_NO = 6900034151 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20121840 and ORDER_NO = 11500289571 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20017838 and ORDER_NO = 6900033931 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20053280 and ORDER_NO = 12100098451 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20126973 and ORDER_NO = 3000311571 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20015038 and ORDER_NO = 6900029621 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20060649 and ORDER_NO = 3300111011 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20123277 and ORDER_NO = 3000294871 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20087878 and ORDER_NO = 10900178441 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100000049 and MASTER_PO_NO = 20125637 and ORDER_NO = 3000303791 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20050707 and ORDER_NO = 12100094701 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001142 and MASTER_PO_NO = 20061638 and ORDER_NO = 3300112421 and REV_NO = 1;
Update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set  PUBLISHED_IND ='Y' where supplier =1100001682 and MASTER_PO_NO = 20082209 and ORDER_NO = 10900166261 and REV_NO = 1;


insert into SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  
select SUPPLIER, MASTER_PO_NO, ORDER_NO, 1,null,'Y','N',sysdate,sysdate,null
        from SUPP_ASOS.ordhead oh where status = 'A' and
not exists (select 1 from SUPP_ASOS.sc_email_order_queue sepi where sepi.MASTER_PO_NO = oh.MASTER_PO_NO);

insert into SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  
select SUPPLIER, MASTER_PO_NO, ORDER_NO, 3,null,'Y','N',sysdate,sysdate,null
        from SUPP_ASOS.ordhead oh where status != 'A' and
not exists (select 1 from SUPP_ASOS.sc_email_order_queue sepi where sepi.MASTER_PO_NO = oh.MASTER_PO_NO);


insert into SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  
select SUPPLIER, MASTER_PO_NO, ORDER_NO, 3,null,'Y','N',sysdate,sysdate,null
        from SUPP_ASOS.ordhead oh where status = 'C' and
 not exists (select 1 from SUPP_ASOS.sc_email_order_queue sepi where sepi.MASTER_PO_NO = oh.MASTER_PO_NO);

insert into SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO  
    select oh.supplier,
                    oh.master_po_no,oh.order_no ,
                    ohr.rev_no, null,'Y','N',sysdate,sysdate,null
               from SUPP_ASOS.ordhead oh,
                    SUPP_ASOS.ordhead_rev ohr
              where oh.order_no    = ohr.order_no 
                and oh.status != 'W'
       and NOT EXISTS  (select 1
                         from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO pi
                        where pi.supplier      = oh.supplier
                          and pi.master_po_no  = oh.master_po_no
                          and pi.rev_no       = ohr.rev_no) ;

select count(1) from SUPP_ASOS.ordhead where order_no not in (select order_no from  SUPP_ASOS.ordhead_rev);


select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO;

 merge into SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO seop
 using (select oh.supplier,
        oh.master_po_no,
        max(ohr.rev_no) rev_no
   from SUPP_ASOS.ordhead oh,
        SUPP_ASOS.ordhead_rev ohr
  where oh.order_no    = ohr.order_no
    and NVL(oh.master_po_no,0) != 0
    and oh.status != 'A'
  group by oh.supplier, oh.master_po_no
  ) tab
   on (seop.master_po_no = tab.master_po_no
      and seop.supplier = tab.supplier)
   when matched then
    update set seop.REV_NO = tab.REV_NO;
  
 
 
 
 
select * from  SUPP_ASOS.ordhead where order_no ='200121901';
select * from  SUPP_ASOS.ordhead_rev where order_no ='200121901';

select * from  SUPP_ASOS.period;    
select order_no from  SUPP_ASOS.ordhead where order_no not in (select order_no from  SUPP_ASOS.ordhead_rev);
select count(distinct order_no) from  SUPP_ASOS.ordsku where order_no not in (select order_no from  SUPP_ASOS.ordhead_rev);
select count(distinct order_no) from  SUPP_ASOS.ordloc where order_no not in (select order_no from  SUPP_ASOS.ordhead_rev);
select count(distinct order_no) from  SUPP_ASOS.ordloc where order_no not in (select order_no from  SUPP_ASOS.ordhead_rev);


select order_no from  SUPP_ASOS.ordloc_rev;


      
      
-- Create Ordrev for records in close orders --
      
create table ordord_no_rev as
select order_no from ordhead oh where not exists (select 1 from rms.ordhead_rev ohr where ohr.order_no =oh.order_no);

select order_no from SUPP_ASOS.ordhead oh where not exists (select 1 from SUPP_ASOS.ordhead_rev ohr where ohr.order_no =oh.order_no);


set serveroutput on;
set timing on;
 
DECLARE
 l_order_no    ordhead.order_no%type;
   c_commit  	  NUMBER(8):= 0;
   
 cursor cur_dept is
    select order_no from ordord_no_rev ;

BEGIN
   
for i in cur_dept loop
l_order_no := i.order_no;
     
     INSERT INTO ordhead_rev
                      ( rev_no,
                        origin_type,
                        order_no,
                        order_type,
                        not_before_date,
                        nbd_status,
                        not_after_date,
                        nad_status,
                        rev_date,
                        dept,
                        buyer,
                        supplier,
                        supp_add_seq_no,
                        loc_type,   
                        location,
                        promotion,
                        qc_ind,
                        written_date,
                        otb_eow_date,
                        earliest_ship_date,
                        latest_ship_date,
                        close_date,
                        terms,
                        freight_terms,
                        orig_ind,
                        payment_method,
                        backhaul_type,
                        backhaul_allowance,
                        ship_method,
                        purchase_type,
                        status,
                        orig_approval_date,
                        orig_approval_id,
                        ship_pay_method,
                        fob_trans_res,
                        fob_trans_res_desc,
                        fob_title_pass,
                        fob_title_pass_desc,
                        edi_sent_ind,
                        edi_po_ind,
                        import_order_ind,
                        import_country_id,
                        po_ack_recvd_ind,
                        include_on_order_ind,
                        vendor_order_no,
                        exchange_rate,
                        factory,
                        agent,
                        discharge_port,
                        lading_port,
                        /*bill_to_id,*/
                        freight_contract_no,
                        po_type,
                        pre_mark_ind,
                        reject_code,
                        currency_code,
                        contract_no,
                        pickup_date,
                        pud_status,
                        split_ref_ordno,
                        pickup_loc,
                        pickup_no,
                        app_datetime,
                        comment_desc)
                SELECT 1,
                        'V', /* origin_type */
                        order_no,
                        order_type,
                        not_before_date,
                        0, /* nbnd_status */
                        not_after_date,
                        0, /* nad_status */
                        vdate, /* rev_date */
                        dept,
                        buyer,
                        supplier,
                        supp_add_seq_no,
                        loc_type,
                        location,
                        promotion,
                        qc_ind,
                        written_date,
                        otb_eow_date,
                        earliest_ship_date, /* earliest_ship_date */
                        latest_ship_date, /* latest_ship_date */
                        close_date,
                        terms,
                        freight_terms,
                        orig_ind,
                        payment_method, /* payment_method */
                        backhaul_type,
                        backhaul_allowance,
                        ship_method, /* ship_method */
                        purchase_type, /* purchase_type */
                        status,
                        orig_approval_date,
                        orig_approval_id,
                        ship_pay_method,
                        fob_trans_res,
                        fob_trans_res_desc,
                        fob_title_pass,
                        fob_title_pass_desc,
                        edi_sent_ind,
                        edi_po_ind,
                        import_order_ind, /* import_order_ind */
                        import_country_id, /* import_country_id */
                        po_ack_recvd_ind,
                        include_on_order_ind,
                        vendor_order_no,
                        exchange_rate, /* exchange_rate */
                        factory, /* factory */
                        agent, /* agent */
                        discharge_port, /* discharge_port */
                        lading_port, /* lading_port */
                        /*bill_to_id,*/
                        freight_contract_no, /* freight_contract_no */
                        po_type,
                        pre_mark_ind,
                        reject_code,
                        currency_code,
                        contract_no,
                        pickup_date,
                        0,  /* pud_status */
                        split_ref_ordno,
                        pickup_loc,
                        pickup_no,
                        app_datetime,
                        'Populate_REV'
                   FROM ordhead, period
                  WHERE  order_no =l_order_no;
                  
                  
                  INSERT INTO alloc_rev
                      ( alloc_no,
                        rev_no,
                        order_no,
                        wh,
                        location,
                        loc_type,
                        qty_transferred,
                        qty_allocated,
                        non_scale_ind,
                        qty_prescaled )
               SELECT ah.alloc_no,
                        1, 
                        order_no,
                        ah.wh,
                        ad.to_loc,
                        ad.to_loc_type,
                        ad.qty_transferred,
                        ad.qty_allocated,
                        ad.non_scale_ind,
                        ad.qty_prescaled
                   FROM alloc_header ah,
                        alloc_detail ad
                  WHERE ad.alloc_no = ah.alloc_no
                    AND ah.order_no = l_order_no;
                                         
                  INSERT INTO ordsku_rev
                      ( rev_no,
                        origin_type,
                        order_no,
                        item,
                        ref_item,
                        rev_date,
                        status,
                        origin_country_id,
                        earliest_ship_date,
                        latest_ship_date,
                        supp_pack_size,
                        non_scale_ind,
                        pickup_loc,
                        pickup_no)
                SELECT 1,
                        'V', /* origin_type */
                        order_no, 
                        item,
                        ref_item,
                        vdate,
                        0,
                        origin_country_id,
                        earliest_ship_date,
                        latest_ship_date,
                        supp_pack_size,
                        non_scale_ind,
                        pickup_loc,
                        pickup_no
                   FROM ordsku, period
                  WHERE order_no = l_order_no;
          
                  INSERT INTO ordloc_rev
                      ( rev_no,
                        origin_type,
                        order_no,
                        item,
                        location,
                        loc_type,
                        unit_retail,
                        qty_ordered,
                        qty_received,
                        qty_cancelled,
                        cancel_code,
                        cancel_date,
                        cancel_id,
                        rev_date,
                        ship_date,
                        qty_status,
                        cost_status,
                        qty_prescaled,
                        unit_cost,
                        unit_cost_init,
                        cost_source,
                        non_scale_ind,
                        original_repl_qty,
                        tsf_po_link_no )
                SELECT 1,
                        'V',
                        order_no, 
                        item,
                        location,
                        loc_type,
                        unit_retail,
                        qty_ordered,
                        qty_received,
                        qty_cancelled,
                        cancel_code,
                        cancel_date,
                        cancel_id,
                        vdate,
                        NULL,
                        0,
                        0,
                        qty_prescaled,
                        unit_cost,
                        unit_cost_init,
                        cost_source,
                        non_scale_ind,
                        original_repl_qty,
                        tsf_po_link_no
                   FROM ordloc, period
                  WHERE order_no = l_order_no;
                  
                  
 c_commit :=c_commit + 1;
   IF MOD(c_commit, 10) = 0 THEN
    COMMIT;
   END IF;      
end loop;


EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/