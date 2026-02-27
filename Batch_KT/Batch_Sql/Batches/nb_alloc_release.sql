
SELECT DISTINCT oh.master_po_no
        FROM shipment sp,
             ordhead oh
             --,ORDER_ALD oa
       WHERE sp.status_code = 'R'
         AND oh.master_po_no is not null
        -- AND RESTART_THREAD_RETURN(oh.master_po_no, TO_NUMBER(:ps_num_threads)) = TO_NUMBER(:ps_thread_val)
         AND sp.order_no = oh.order_no
        /* and oh.order_no = oa.order_no
         and oa.order_no ='50000570490'
         */ AND oh.po_type = 'A'
         AND EXISTS (SELECT 'X'
                       FROM alloc_header            alh,
                            nb_alloc_header_cfa_ext alh_cfa,
                            nb_alloc_detail_cfa_ext alc_cfa
                      WHERE alh.status = 'A'
                        AND alh.alloc_no = alh_cfa.alloc_no (+)
                        AND (alh_cfa.varchar2_1 is null or alh_cfa.varchar2_1 = 'N')
                        AND alh.alloc_no = alc_cfa.alloc_no
                        AND alc_cfa.number_11 = sp.shipment );
                     
                     
                     
      creaTe table order_ald as
         SELECT distinct alh.ORDER_NO
                       FROM alloc_header            alh,
                            nb_alloc_header_cfa_ext alh_cfa,
                            nb_alloc_detail_cfa_ext alc_cfa
                      WHERE alh.status = 'A'
                        AND alh.alloc_no = alh_cfa.alloc_no (+)
                        AND (alh_cfa.varchar2_1 is null)
                        AND alh.alloc_no = alc_cfa.alloc_no;
          
select * from nb_alloc_header_cfa_ext where alloc_no in (select alloc_no from alloc_header where status='A' and order_no in  (select order_no from order_ald));
select * from nb_alloc_detail_cfa_ext where alloc_no in (select alloc_no from alloc_header where status='A' and order_no in  (select order_no from order_ald));


select  * from ordhead where order_no in (50000570490);
select * from ordloc where order_no in (50000570490);
select * from shipment where order_no in (50000570490);
select STATUS_CODE,count(1) from shipment where order_no in (50000570490) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50000570490));
SELECT * FROM alloc_header where order_no in (50000570490);
select * from nb_alloc_header_cfa_ext;
select * from nb_alloc_detail_cfa_ext;

SELECT * FROM nb_alloc_header_cfa_ext where ALLOC_NO in (SELECT ALLOC_NO FROM alloc_header where order_no in (50000570490));
delete FROM nb_alloc_detail_cfa_ext where ALLOC_NO in (SELECT ALLOC_NO FROM alloc_header where order_no in (50000570490));

select * from nb_alloc_detail_cfa_ext;
select * FROM nb_alloc_detail_cfa_ext where ALLOC_NO not in (SELECT ALLOC_NO FROM nb_alloc_header_cfa_ext);



          
 SELECT DISTINCT sp.SHIPMENT
        FROM shipment sp,
             ordhead oh
       WHERE sp.status_code = 'R'
         AND sp.order_no = oh.order_no
         AND oh.master_po_no  in (20511563)
         AND EXISTS (SELECT 'X'
                       FROM alloc_header            alh,
                            nb_alloc_header_cfa_ext alh_cfa,
                            alloc_detail            alc,
                            nb_alloc_detail_cfa_ext alc_cfa
                      WHERE alh.status = 'A'
                        AND alh.alloc_no = alh_cfa.alloc_no (+)
                        AND (alh_cfa.varchar2_1 is null or alh_cfa.varchar2_1 = 'N')
                        AND alh.alloc_no = alc.alloc_no
                        AND alc.alloc_no = alc_cfa.alloc_no
                        AND alc.to_loc = alc_cfa.to_loc
                        AND alc_cfa.number_11 = sp.shipment);



select * from nb_alloc_header_cfa_ext;
select * from nb_alloc_detail_cfa_ext;
select * from ordhead where  master_po_no = '20511563';
select  * from ordhead where order_no in (50000532988) and po_type ='A';
select * from ordloc where order_no in (50000532988);
select * from shipment where order_no in (50000532988);
select STATUS_CODE,count(1) from shipment where order_no in (50000532988) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50000532988));
SELECT * FROM alloc_header where order_no in (50000532988);

select  * from alloc_header where order_no in (50000532988);
select * from alloc_detail where alloc_no in (select alloc_no from alloc_header where order_no in (50000532988));
select * from shipment where shipment in (select distinct shipment from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (50000532988)));
select * from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (50000532988));

select * from  int_Asos.nb_alloc_detail_cfa_ext where alloc_no in (select alloc_no from alloc_header where order_no in (50000532988));
select * from  int_Asos.nb_alloc_header_cfa_ext where alloc_no in (select alloc_no from alloc_header where order_no in (50000532988));


insert into int_Asos.nb_alloc_header_cfa_ext (ALLOC_NO,  GROUP_ID, VARCHAR2_1)
select ALLOC_NO,  1040100,'Y'
    from  int_Asos.nb_alloc_detail_cfa_ext where 
    alloc_no in (select alloc_no from alloc_header where order_no in (select order_no from alloc_rel where rownum <= '7000')) and GROUP_ID ='1030100';

select * from nb_alloc_detail_cfa_ext where GROUP_ID ='1030100';

select order_no from alloc_rel where rownum <= '7000';

