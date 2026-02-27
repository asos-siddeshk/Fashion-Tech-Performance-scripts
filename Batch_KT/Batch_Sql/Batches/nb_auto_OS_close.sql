 SELECT TO_NUMBER(value_1)
        FROM nb_system_parameters
       WHERE func_area = 'AUTOPO'
         AND parameter = 'RELEASE_DAYS'; --2
         
         
 SELECT DISTINCT oh.master_po_no
        FROM ordhead oh,
             alloc_header alh
       WHERE oh.po_type = 'A'
         AND oh.status = 'A'
     --    AND RESTART_THREAD_RETURN(oh.master_po_no, TO_NUMBER(:ps_num_threads)) = TO_NUMBER(:ps_thread_val)
         AND oh.order_no = alh.order_no
         AND alh.status = 'A'
         /* Unassgined allocations exist */
         AND NOT EXISTS (select 'x'
                         from ma_asos.nb_alloc_detail_cfa_ext alc_cfa
                        where alc_cfa.alloc_no = alh.alloc_no
                          and alc_cfa.number_11 is not null
                          and alc_cfa.group_id in (select group_id
                                                     from cfa_attrib
                                                    where view_col_name = 'AUTO_PO_SHIPMENT'))
         /* Over-receipt not processed */
         AND EXISTS (select 'X'
                       from shipment sp,
                            shipsku sk
                      where sp.status_code = 'R'
                        and sp.order_no = oh.order_no
                        and sk.item = alh.item
                        and NVL(sk.qty_received, 0) > NVL(sk.qty_expected, 0)
                        and not exists (select 'X' from ma_asos.nb_shipment_cfa_ext sp_cfa where sp_cfa.shipment = sp.shipment and sp_cfa.varchar2_2 = 'Y')
                        and (exists (select 'X' from int_asos.int_receipt_close_head rch where rch.shipment = sp.shipment)
                               or
                             exists (select 'X' from shipment sp2 where sp.shipment = sp2.shipment and (receive_date + 2) < SYSDATE)
                            )
                     );
                     
                     
                     
