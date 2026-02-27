   SELECT tsf_close_overdue -- N
     FROM system_options;

   SELECT NVL(ss_auto_close_days, 0),
          NVL(ws_auto_close_days, 0),
          NVL(sw_auto_close_days, 0),
          NVL(ww_auto_close_days, 0)
     FROM inv_move_unit_options; --7
     
     
     SELECT  count(distinct (th1.tsf_no))
            FROM tsfhead th1,
                 tsfhead th2,
                 tsfdetail td,
                 alloc_header ah,
                 item_master im,
                 v_packsku_qty pq,
                 v_restart_transfer rv,
                 tsfitem_inv_flow tf,
                 (SELECT s2.distro_no,
                         MAX(s1.ship_date) ship_date,
                         s2.item
                    FROM shipment s1,
                         shipsku s2
                   WHERE s1.shipment = s2.shipment
                   GROUP BY s2.distro_no,
                            s2.item) sp
           WHERE th1.tsf_no = td.tsf_no
             AND td.item = im.item
             AND im.item = pq.pack_no(+)
             AND th1.tsf_no = ah.order_no(+)
             AND td.tsf_no = sp.distro_no(+)
             AND td.item = sp.item(+)
             AND td.tsf_no = tf.tsf_no(+)
             AND td.item = tf.item(+)
            -- AND (th1.tsf_no > TO_NUMBER(NVL(:ps_restart_tsf_no, -999)))
             AND ((th1.status = 'A' AND NVL(td.ship_qty, 0) = 0)
                   OR (th1.status = 'S'
                       --only retrieve the transfer if doc_close_queue doesn't already exist,
                       --in case docclose.pc fails to close the transfer and tsfclose.pc is run again
                       AND NOT EXISTS (SELECT 'x'
                                         FROM doc_close_queue dcq
                                        WHERE dcq.doc = td.tsf_no
                                          AND rownum = 1)
                       AND NOT EXISTS (SELECT 'x'
                                         FROM tsfdetail td1
                                        WHERE td1.tsf_no = td.tsf_no
                                          AND NVL(td1.received_qty, 0) > 0)))
             AND th1.tsf_parent_no is NULL
             AND th1.tsf_no = th2.tsf_parent_no(+)
             AND ((th1.to_loc_type='S' AND th1.from_loc_type ='S' AND :pi_ss_auto_close_days > 0
                   AND get_vdate>= NVL(sp.ship_date, th1.create_date) + :pi_ss_auto_close_days) OR
                  ((th1.to_loc_type='S') AND (th1.from_loc_type ='W' OR th1.from_loc_type ='E')
                   AND :pi_ws_auto_close_days > 0 AND get_vdate >= NVL(sp.ship_date, th1.create_date) + :pi_ws_auto_close_days) OR
                  ((th1.to_loc_type='W' OR th1.to_loc_type ='E') AND (th1.from_loc_type ='W' OR th1.from_loc_type ='E')
                   AND :pi_ww_auto_close_days > 0 AND get_vdate >= NVL(sp.ship_date, th1.create_date) + :pi_ww_auto_close_days) OR
                  ((th1.to_loc_type='W' OR th1.to_loc_type ='E') AND (th1.from_loc_type ='S')
                   AND :pi_sw_auto_close_days > 0 AND get_vdate >= NVL(sp.ship_date, th1.create_date) + :pi_sw_auto_close_days));
                   
                   
                   select * from rms.tsfitem_inv_flow;