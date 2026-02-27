select * from supp_asos.sc_batch_config where program_name = UPPER('SC_EMAIL_ORDER_ADDTOQ');


SC_EMAIL_ORDER_SQL.ADDTOQ

select * from supp_asos.sc_email_order_pubinfo where trunc(CREATE_DATETIME) >='17-APR-23';

select * from das.ordhead;

select * from das.ordhead_rev where trunc(REV_DATE) >='26-FEB-23';
select count(distinct master_po_no) from das.ordhead where trunc(LAST_UPDATE_DATETIME) = '18-APR-23';

select * from supp_asos.sc_supp_cfg;
select count(1) from supp_asos.sc_email_order_queue;
--35628
select 35628 -35141 from dual;  -487 
select 35141 -34626 from dual;  -515
select 34626 -34167 from dual;  -459
select 34167 -33683 from dual;  -484
select 33683 -33182 from dual;  -500
select 33182 -32241 from dual;  -941

Queue Processing --500 every min 

select SUPPLIER, PUBLISHED_IND, PROCESSED_IND,count(1) from supp_asos.sc_email_order_pubinfo where trunc(CREATE_DATETIME) >='17-APR-23' group by SUPPLIER, PUBLISHED_IND, PROCESSED_IND;


select * from supp_asos.sc_email_order_pubinfo;


select * from das.ordhead_rev where trunc(REV_DATE) >='17-APR-23';
select count(1) from das.ordhead where trunc(LAST_UPDATE_DATETIME) >='17-APR-23';
select count(1) from das.ordhead where trunc(LAST_UPDATE_DATETIME) >='17-APR-23';

select * from all_tables where lower(table_name) like 'ordhead';

select * from das.ordhead_rev where trunc(REV_DATE) >='17-APR-23';
select * from supp_asos.sc_supp_cfg;

select tab.supplier,
         tab.master_po_no,
         max(tab.rev_no) as rev_no
    from (select oh.supplier,
                 oh.master_po_no,
                 oh.order_no,
                 max(ohr.rev_no) rev_no
            from das.ordhead oh,
                 das.ordhead_rev ohr,
                 das.v_cfa_po_date_g po_cfa
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
                        and tab.master_po_no = oq.master_po_no
                        and oq.status        in ('E', 'U', 'I'))

   group by tab.supplier,
            tab.master_po_no;