begin
Update rms.tran_data_a set tran_date='27-JAN-19' where tran_date!='27-JAN-19';
commit;
Update rms.tran_data_b set tran_date='27-JAN-19' where tran_date!='27-JAN-19';
commit;
delete rms.tran_data_B  where  (dept=9999 or CLASS=9999 or SUBCLASS=9999) ;
commit;
delete rms.tran_data_a  where  (dept=9999 or CLASS=9999 or SUBCLASS=9999) ;
commit;
DELETE from rms.DAILY_DATA  where  (dept=9999 or CLASS=9999 or SUBCLASS=9999)  ;
commit;
delete FROM rms.sup_data where (DEPT,SUPPLIER) in (select DEPT,SUPPLIER from rms.sup_month);
commit;
delete from rms.rpm_event_itemloc where selling_unit_retail is null;
commit;
 DELETE from int_asos.int_pl_sizprof_head_upld_stg where status='U' ;
 commit;
DELETE FROM int_asos.int_pl_sizprof_detail_upld_stg WHERE SIZE_PROFILE not IN 
( select SIZE_PROFILE from int_asos.int_pl_sizprof_head_upld_stg);
commit;
delete from daily_purge  where KEY_VALUE  in (
select item from rms.item_master im where item_level ='2' and status ='A'   --and dept ='2050'
and not exists (select 1 from rms.diff_ids pi where pi.diff_id = im.DIFF_2));
commit;
delete from daily_purge  where KEY_VALUE  in (
select item_parent from rms.item_master im where item_level ='2' and status ='A'   --and dept ='2050'
and not exists (select 1 from rms.diff_ids pi where pi.diff_id = im.DIFF_2));
commit;
delete from daily_purge  where KEY_VALUE  in (
   select item from rms.item_master im where item_level ='3' and status ='A'   --and dept ='2050'
   and not exists (select 1 from rms.diff_ids pi where pi.diff_id = im.DIFF_2));
commit;
-------------Invalid diff ids deletion script(for nd_tckndwnd)-------------
delete  from rms.int_tckt_dnld_stage where order_no
            in( select order_no from rms.ordloc where  item
             not  in (select im.item  from rms.diff_ids di, rms.item_master im where  IM.DIFF_2 = di.DIFF_ID));
commit;
delete  from rms.int_tckt_dnld_stage where order_no
        in( select order_no from rms.ordloc where item not in ( select  uil.item
            from rms.uda_item_lov uil,rms.uda_values dd, int_asos.nb_system_parameters nsp
        where uil.uda_id=nsp.value_1
        --and item = :ps_item
        and nsp.func_area = 'TICKET_REQUEST'
        and nsp.PARAMETER = 'SUSTAINABLE_FIBRES_UDA_ID'
        and dd.uda_id = uil.uda_id
        and dd.uda_value = uil.uda_value));
commit;		
delete  from rms.int_tckt_dnld_stage where order_no
    in( select order_no from rms.ordloc where  item
    not  in (select item from rms.MA_V_BUYERARCHY));	
commit;	
end;
/
