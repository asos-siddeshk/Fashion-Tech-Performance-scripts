select * from rms.ordhead order by 1 desc;
select * from rms.order_mfqueue;
select * from rms.order_pub_info where published!= 'Y';


select * from all_tables where table_name like '%CFG%' and OWNER = 'SUPP_ASOS';;
select * from all_sequences where sequence_name like '%QUEUE%';

select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO where PUBLISHED_IND!= 'Y';

delete SUPP_ASOS.SC_EMAIL_ORDER_QUEUE;
select * from SUPP_ASOS.SC_EMAIL_ORDER_QUEUE;
select * from SUPP_ASOS.SC_PO_EMAIL_PUBINFO;
delete from SUPP_ASOS.SC_EMAIL_ORDER_QUEUE where supplier = '1100005538';

truncate table SUPP_ASOS.SC_EMAIL_ORDER_QUEUE;

select count(1) from SUPP_ASOS.SC_EMAIL_ORDER_QUEUE;

select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO;
select * from SUPP_ASOS.SC_PO_EMAIL_PUBINFO;

select * from supp_asos.SC_SUPP_USERS_CFG;
select * from supp_asos.SC_SUPP_CFG;
select * from supp_asos.SC_CFG_DEFAULTS;

insert into SUPP_ASOS.SC_PO_EMAIL_PUBINFO
select distinct MASTER_PO_NO,ORDER_NO,REV_NO, 'Y' as PUBLISHED  from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO;

select * from das.ordhead where master_po_no = '22864861';

SELECT * FROM supp_asos.SC_ASN_MFQUEUE;
SELECT * FROM supp_asos.SC_EMAIL_FINANCEDOCS_QUEUE;
select * FROM supp_asos.SC_EMAIL_ORDER_QUEUE;
SELECT * FROM supp_asos.SC_EMAIL_SHIPMENT_QUEUE;
SELECT * FROM supp_asos.SC_PO_EMAIL_QUEUE;

select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO;


SELECT * FROM supp_asos.rib_options;

SELECT * FROM supp_asos.ma_logs;


select * from dba_source where upper(text) like '%SC_EMAIL_ORDER_QUEUE%';
  SELECT email_po_retention_days
      FROM supp_asos.sc_system_options;


select * from SUPP_ASOS.sc_email_order_pubinfo where master_po_no = '22715336';
select * from das.ordhead where master_po_no = '22715336';
select * from das.ordhead_rev where order_no in (select order_no from das.ordhead where master_po_no = '22715336');
select * from SUPP_ASOS.SC_PO_EMAIL_PUBINFO where master_po_no = '22715336';


            
select * from all_tables where table_name like '%LOG%' and owner like 'SUPP_ASOS';


select * from das.ordhead where master_po_no = '22841847';
select * from das.ordhead_rev where order_no in (select order_no from das.ordhead where master_po_no = '22841847');
select * from SUPP_ASOS.SC_PO_EMAIL_PUBINFO where master_po_no = '22841847';

select * from SUPP_ASOS.SC_PO_EMAIL_PUBINFO;

delete from SUPP_ASOS.sc_email_order_queue;

select * from SUPP_ASOS.NB_RTSA_LOG;
select * from SUPP_ASOS.MA_LOGS;


delete from SUPP_ASOS.sc_email_order_queue;


select tab.supplier,
         tab.master_po_no,
         max(tab.rev_no) as rev_no
    from (select oh.supplier,
                 oh.master_po_no,
                 oh.order_no,
                 max(ohr.rev_no) rev_no
            from supp_asos.ordhead oh,
                 supp_asos.ordhead_rev ohr,
                 supp_asos.v_cfa_po_date_g po_cfa
           where oh.order_no                           = ohr.order_no
             and po_cfa.order_no                       = oh.order_no
             and nvl(po_cfa.supplier_confirmation,'Y') = 'Y'
             and nvl(oh.master_po_no, 0)              != 0
             and oh.status                            != 'W'
           group by oh.supplier,
                    oh.master_po_no,
                    oh.order_no
         ) tab,
         supp_asos.sc_supp_cfg sc
   where tab.supplier                    = sc.supplier_id(+)
     and nvl(sc.order_email_notify, 'Y') = 'Y'
     and exists (select 1
                   from das.ordhead ord
                  where ord.supplier     = tab.supplier
                    and ord.master_po_no = tab.master_po_no
                    and ord.order_no     = tab.order_no
                    and ord.status       in ('A', 'C')
                    and not exists (select 1
                                      from supp_asos.sc_email_order_pubinfo pio
                                     where pio.supplier       = tab.supplier
                                       and pio.master_po_no   = tab.master_po_no
                                       and pio.order_no       = tab.order_no
                                       and pio.status         = ord.status
                                       and pio.published_ind  = 'Y'
                                       and (pio.rev_no >= tab.rev_no or pio.status = 'C')))
     and not exists (select 1
                       from supp_asos.sc_email_order_queue oq
                      where tab.supplier     = oq.supplier
                        and tab.master_po_no = oq.master_po_no)
 
   group by tab.supplier,
            tab.master_po_no;

