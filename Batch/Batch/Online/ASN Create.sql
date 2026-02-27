select * from supp_asos.ordhead where order_no not in (select order_no from supp_asos.ordloc );
select * from supp_asos.SC_ASNIN where trunc(CREATE_DATETIME) = trunc(sysdate) or trunc(LAST_UPDATE_DATETIME) = trunc(sysdate);

select * from supp_asos.SC_ASNIN_PO where ASN_NBR  in ('42153123000003','42153123000005');
select * from supp_asos.SC_ASNIN where ASN_NBR  in ('42153123000003','42153123000005');
select * from supp_asos.SC_ASNIN_ITEM where ASN_NBR  in ('42153123000003','42153123000005');


select * from supp_asos.MA_LOGS;
select * from all_tables where table_name like '%SYSTEM%' and owner like 'SUPP_ASOS';

MA_ORDER_UTILS_SQL.GET_PARTNER_CFA_RMS ""SUPP_ASOS.SC_UTILS_SQL", line 351 -> ORA-01403: no data found"
select * from SUPP_ASOS.ORCA_S9T_PUBINFO;

select * from supp_asos.SC_SYSTEM_OPTIONS;

select * from all_source where lower(text) like '%sc_asn_mfqueue%';


select * from supp_asos.SC_EVENT_MESSAGE;
select * from supp_asos.SC_EVENT_MESSAGE_FAILURE;
select * from supp_asos.sc_asn_mfqueue;
select * from supp_asos.sc_asn_mfqueue;


select * from rms.addr;




select SUPPLIER,count(1) from ASN_CRE group by SUPPLIER;
drop table asn_cre;
create table asn_cre as 
select master_po_no,supplier,order_no, PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_ho_start,
        LATEST_SHIP_DATE as  expected_ho_end,
        NOT_BEFORE_DATE as expected_sh_date,
        NOT_AFTER_DATE as expected_Dly_date
        from ordhead where status ='A' and PICKUP_DATE between '01-MAR-21' and '30-MAR-22';



select * from asn_cre;

    select master_po_no,order_no,status,PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_handover_start,
        LATEST_SHIP_DATE as  expected_handover_end,
        NOT_BEFORE_DATE as expected_shipment_date,
        NOT_AFTER_DATE as expected_Delivery_date from ordhead  order by 2;
    select * from order_mfqueue;

select oh.order_no,oh.MASTER_PO_NO,asp.ASN_NBR from supp_asos.ordhead oh, SUPP_ASOS.SC_ASNIN_PO asp 
    where oh.master_po_no in ('500786','500788','500797','500799','500785','500787','500798') and oh.order_no = asp.PO_NBR;

select * from supp_asos.SC_ASNIN_PO where ASN_NBR ='11953001000412';
select * from supp_asos.SC_ASNIN  where ASN_NBR ='11953001000412';
select * from supp_asos.SC_ASNIN_ITEM  where ASN_NBR ='11953001000412';

db.getCollection('exportedASNIn').find({})
db.getCollection('exportedASNIn').find({_id:"11953001000411"})
db.getCollection('publishedASNInRMS').find({_id:"11953001000411"})
db.getCollection('publishedASNInRMS').find({"_id":{$regex:"11953001000411"}})

db.getCollection('exportedPurchaseOrder').find({})
db.getCollection('exportedPurchaseOrder').find({_id:"PO_501000021207_exported"})

 
 
select * from ordhead where master_po_no ='20603105';
select * from ordloc where order_no  in (select order_no  from ordhead where master_po_no ='20603105');
select * from ordsku where order_no  in (select order_no  from ordhead where master_po_no ='20603105');
select * from ordhead_cfa_ext where order_no  in (select order_no  from ordhead where master_po_no ='20603105');
select * from ordsku_cfa_ext where order_no  in (select order_no  from ordhead where master_po_no ='20603105');
   
drop table asn_cre;
create table asn_cre as select order_no from ordhead ;
delete from asn_cre a where exists (select 1 from shipment sh where sh.order_no = a.order_no);
select * from asn_cre a where not exists (select 1 from shipment sh where sh.order_no = a.order_no);


    select master_po_no,supplier,order_no, PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_ho_start,
        LATEST_SHIP_DATE as  expected_ho_end,
        NOT_BEFORE_DATE as expected_sh_date,
        NOT_AFTER_DATE as expected_Dly_date
        from ordhead where order_no in (select order_no from asn_cre where status is not null);
    
drop table asn_cre;
create table asn_cre as
    select master_po_no,supplier,order_no, PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_ho_start,
        LATEST_SHIP_DATE as  expected_ho_end,
        NOT_BEFORE_DATE as expected_sh_date,
        NOT_AFTER_DATE as expected_Dly_date
        from ordhead where status ='A' and PICKUP_DATE between '01-OCT-21' and '30-NOV-21';
        -->= '01-JAN-22';
--        between '01-AUG-21' and '18-NOV-21';

alter table asn_cre add (status varchar2(10));
delete from asn_cre a where exists (select 1 from shipment sh where sh.order_no = a.order_no);
select * from asn_cre a where not exists (select 1 from shipment sh where sh.order_no = a.order_no);
        

select count(1) from ASN_CRE where status is not null;
select SUPPLIER,count(1) from ASN_CRE group by SUPPLIER;
select count(1) from ASN_CRE where status is null;
select count(1) from ASN_CRE where status is not null;
select count(1) from rms.order_mfqueue;


select * from if_errors;

DELETE from order_mfqueue;
UPDATE order_pub_info set PUBLISHED = 'Y' where PUBLISHED = 'N';
delete from asn_cre where status is not null;


    select master_po_no,supplier,order_no, PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_ho_start,
        LATEST_SHIP_DATE as  expected_ho_end,
        NOT_BEFORE_DATE as expected_sh_date,
        NOT_AFTER_DATE as expected_Dly_date
        from ordhead where order_no in (select order_no from asn_cre where status is null and supplier = '1100000234') order by 1;



set serveroutput on;
Set timing on;

DECLARE
        i_need_date             	date;
        i_vdate                 	date  := '08-MAR-2022';
        i_vdate1                 	date  := '08-MAR-2022';
        v_return                	boolean;
        l_order_no              	rms.ordhead.order_no%type;
        l_master_po_no          	rms.ordhead.master_po_no%type;
        counter                 	number(10) := 0;
		o_error_message 			varchar2(255);
		i_factory 					varchar2(10);
		i_po_type 					varchar2(4);
		i_ship_port 				varchar2(5);
		i_first_dest 				number;
		i_ship_method 				varchar2(6);
		i_freight_forwarder 		varchar2(10);
		i_final_dest 				number;
		i_ship_method_final_dest	varchar2(6);
		io_handover_date 			date;
		io_ship_date 				date ;
		io_not_before_date 			date ;
		io_not_after_date 			date;
		io_first_dest_date 			date;
		io_final_dest_date 			date;
		o_ex_factory_date 			date;
		o_week_no 					number;
		v_return 					boolean;
		L_group_id   				rms.ordhead_cfa_ext.GROUP_ID%type := '30100';
        L_need_date_eow             rms.ORDHEAD.OTB_EOW_DATE%TYPE             := NULL;


  cursor cur_Order is
        select order_no from asn_cre where status is null and supplier in (
                  select supplier from 
                  (select supplier,count(1) from asn_cre where supplier = '1100000234' group by supplier having count(1) between 200 and 4800)) 
        AND rownum <= '45' order by 1;        

  cursor cur_Orderdetail(L_order_no   rms.ordhead.order_no%type) is
        Select distinct SHIP_METHOD, 	
                        LADING_PORT,
                        FACTORY, 
                        PO_TYPE, 
                        PARTNER1, 
                        ol.location 
        from rms.ordhead oh, rms.ordloc ol 
            where oh.order_no = ol.order_no
                    and oh.order_no = L_order_no;
	
    BEGIN
	for j in 0..10 loop 
    for K in 0..10 loop 
       counter              := 0;
    for m in cur_order loop 
			L_order_no := m.order_no;
                counter   := counter + 1; 

        select I_VDATE + counter into i_vdate1 from dual;
    
             for k in cur_Orderdetail(L_order_no) loop

                    I_PO_TYPE := k.PO_TYPE;
                	I_SHIP_METHOD := k.SHIP_METHOD;
        			I_SHIP_PORT := k.LADING_PORT;
        			I_FACTORY := k.FACTORY;
        			I_FIRST_DEST := k.location;
        			I_FREIGHT_FORWARDER := k.PARTNER1;
                    io_handover_date := i_vdate1;
                    IO_SHIP_DATE := i_vdate1;

                -- grab the eow date for the given need date
               if rms.DATES_SQL.GET_EOW_DATE(O_error_message,
                                         L_need_date_eow,
                                         io_handover_date) = FALSE then
                    L_need_date_eow := L_need_date_eow+7;
               end if;
   

               If I_PO_TYPE ='D'  then       
                  
                    i_ship_method_final_dest := null;
                     if ma_asos.ma_order_utils_sql.get_date(o_error_message,
                                                   i_factory,
                                                   i_po_type,
                                                   i_ship_port,
                                                   i_first_dest,
                                                   i_ship_method,
                                                   i_freight_forwarder,
                                                   i_final_dest,
                                                   i_ship_method_final_dest,
                                                   io_handover_date,
                                                   io_ship_date,
                                                   io_not_before_date,
                                                   io_not_after_date,
                                                   io_first_dest_date,
                                                   io_final_dest_date,
                                                   o_ex_factory_date,
                                                   o_week_no)
                                           = FALSE then 
							
                            insert into rms.if_errors(PROGRAM_NAME ,
													ERR_DATE     ,
													UNIT_OF_WORK ,
													ERROR   )
											values ('ORDDATEUPD',
													sysdate,
													l_order_no,
													O_ERROR_MESSAGE);
                        Else
							
                                    
                            	update rms.ordhead
									set pickup_date = io_handover_date, 
										not_before_date = io_ship_date,
										earliest_ship_date = io_not_before_date,
										latest_ship_date = io_not_after_date,
										not_after_date = io_first_dest_date,
                                        otb_eow_date = L_need_date_eow
									where order_no = l_order_no ;

								update rms.ordsku set earliest_ship_date=io_not_before_date,
										latest_ship_date = io_not_after_date 
									where order_no = l_order_no;

								update rms.ordloc set estimated_instock_date=io_final_dest_date
									where order_no = l_order_no;

								update rms.ordhead_cfa_ext set DATE_21=IO_NOT_BEFORE_DATE,
										DATE_22 = IO_NOT_AFTER_DATE
									where group_id = L_group_id  and order_no = l_order_no;
								
						  END IF;

			else 
            
        			i_ship_method_final_dest := k.SHIP_METHOD;

                select decode (I_FIRST_DEST,'1001','4001',
                        '4001','3001',
                        '3001','1001') into i_final_dest from dual;

                      if ma_asos.ma_order_utils_sql.get_date(o_error_message,
                                                   i_factory,
                                                   i_po_type,
                                                   i_ship_port,
                                                   i_first_dest,
                                                   i_ship_method,
                                                   i_freight_forwarder,
                                                   i_final_dest,
                                                   i_ship_method_final_dest,
                                                   io_handover_date,
                                                   io_ship_date,
                                                   io_not_before_date,
                                                   io_not_after_date,
                                                   io_first_dest_date,
                                                   io_final_dest_date,
                                                   o_ex_factory_date,
                                                   o_week_no)
                                           = FALSE then 
							
                            insert into rms.if_errors(PROGRAM_NAME ,
													ERR_DATE     ,
													UNIT_OF_WORK ,
													ERROR   )
											values ('ORDDATEUPD',
													sysdate,
													l_order_no,
													O_ERROR_MESSAGE);
                        Else
							
                            	update rms.ordhead
									set pickup_date = io_handover_date, 
										not_before_date = io_ship_date,
										earliest_ship_date = io_not_before_date,
										latest_ship_date = io_not_after_date,
										not_after_date = io_first_dest_date,
                                        otb_eow_date = L_need_date_eow
									where order_no = l_order_no ;

								update rms.ordsku set earliest_ship_date=io_not_before_date,
										latest_ship_date = io_not_after_date 
									where order_no = l_order_no;

								update rms.ordloc set estimated_instock_date=io_first_dest_date
									where order_no = l_order_no;

								update rms.ordhead_cfa_ext set DATE_21=IO_NOT_BEFORE_DATE,
										DATE_22 = IO_FINAL_DEST_DATE
									where group_id = L_group_id  and order_no = l_order_no;
								
						  END IF;
        
                    end if;
                    
       io_handover_date     := null;
       io_ship_date         := null;
       io_not_before_date   := null;
       io_not_after_date    := null;
       io_first_dest_date   := null;
       io_final_dest_date   := null;
       o_ex_factory_date    := null;
       o_week_no            := null;
    
       Update asn_cre set status ='S' where order_no = l_order_no;
       end loop;
       end loop;
       end loop;
       end loop;

DELETE from order_mfqueue;
UPDATE order_pub_info set PUBLISHED = 'Y' where PUBLISHED = 'N';
--delete from asn_cre where status is not null;
commit;   

exception	
when others then
    dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/
