drop table ORDUPDQTY ;
create table ORDUPDQTY as
select distinct master_po_no,order_no from ordhead oh where status ='A'AND oh.supplier ='1100000086'
    and not exists( select 1 from rms.shipment sh where  sh.order_no = oh.order_no);

select * from ORDUPDQTY;


set SERVEROUTPUT ON;
set timing ON;
  
declare
  o_error_message           varchar2(255);
  i_order_no               rms.ordhead.order_no%type;
  i_MASTER_PO_NO           rms.ordhead.MASTER_PO_NO%type;
  v_return                  boolean;
  l_exists                  rms.item_master.item_parent%type;
    
    cursor c_get_asn is
         select distinct MASTER_PO_NO from ORDUPDQTY;

    cursor c_reclass (i_MASTER_PO_NO rms.ordhead.MASTER_PO_NO%type) is
           select 1 from shipment where order_no in (select order_no from ordhead where master_po_no = i_MASTER_PO_NO); 

begin
  
  
   FOR k in c_get_asn Loop
    i_MASTER_PO_NO                                     := k.MASTER_PO_NO; 
        
        
   
   open c_reclass(i_MASTER_PO_NO);
   
   fetch c_reclass into l_exists;
    
        if c_reclass%FOUND then
            delete from ORDUPDQTY where MASTER_PO_NO = i_MASTER_PO_NO;
     
        end if;
    close c_reclass;      
    
    end loop;

commit;

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;

END;
/

   
   select * from ordhead where master_po_no ='21071507';
   select * from ordloc where order_no  in (select order_no  from ordhead where master_po_no ='21071507');
   select * from ordsku where order_no  in (select order_no  from ordhead where master_po_no ='21071507');
   select * from ordhead_cfa_ext where order_no  in (select order_no  from ordhead where master_po_no ='21071507');
   select * from ordloc_cfa_ext where order_no  in (select order_no  from ordhead where master_po_no ='21071507');
   select * from ordsku_cfa_ext where order_no  in (select order_no  from ordhead where master_po_no ='21071507');
   
   
SELECT *
    FROM ma_asos.ma_stg_order_drops_detail where MASTER_ORDER_NO ='21071507' order by 3;
   
drop table ORDUPDQTYdate;
create table  ORDUPDQTYdate as
select master_po_no,order_no,status,PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_handover_start,
        LATEST_SHIP_DATE as  expected_handover_end,
        NOT_BEFORE_DATE as expected_shipment_date,
        NOT_AFTER_DATE as expected_Delivery_date
 from ordhead where PICKUP_DATE is null and status ='A';

drop table ORDUPDQTYdate_bk;
create table ORDUPDQTYdate_bk as select * from ORDUPDQTYdate;

select count(distinct master_po_no) from ORDUPDQTYdate;

select master_po_no,order_no,status,PICKUP_DATE as expected_handover,
        EARLIEST_SHIP_DATE as expected_handover_start,
        LATEST_SHIP_DATE as  expected_handover_end,
        NOT_BEFORE_DATE as expected_shipment_date,
        NOT_AFTER_DATE as expected_Delivery_date
 from ordhead  where (MASTER_PO_NO, order_no) in 
        (select MASTER_PO_NO, order_no from  ORDUPDQTYdate_bk oub where not 
            exists (select 1 from ORDUPDQTYdate ourd where ourd.master_po_no = oub.MASTER_PO_NO)) order by 4 desc;
 
 
delete from ORDUPDQTYdate_bk where (MASTER_PO_NO, order_no) not in 
        (select MASTER_PO_NO, order_no from  ORDUPDQTYdate) ;
 
 
set serveroutput on;
Set timing on;

DECLARE
        i_need_date             	date;
        i_vdate                 	date  := '01-DEC-2019';
        i_vdate1                 	date  := '01-DEC-2019';
        v_return                	boolean;
        l_order_no              	rms.ordhead.order_no%type;
        l_master_po_no          	rms.ordhead.master_po_no%type;
        counter                 	number(10) := 1;
        counter1                 	number(10) := 0;
        counter_commit          	number(10) := 0;
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


  cursor cur_masterpo is
	select master_po_no from (
    select distinct master_po_no from ORDUPDQTYdate ) where rownum <= '15' order by 1;
    --='21060892';

  cursor cur_Order(L_master_po_no    rms.ordhead.master_po_no%type) is
        select order_no from ordhead where master_po_no =L_master_po_no and status ='A' order by 1;

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

for n in 0..5 loop
for m in 0..2 loop
for k in cur_masterpo loop
    L_master_po_no := k.master_po_no;

--        select vdate +  counter1 into I_VDATE from rms.period;
        select I_VDATE +  counter1 into I_VDATE from dual;
            counter   := counter + 1; 

            IF MOD(counter, 20) = 0 THEN
              counter1   := counter1 + 1; 
               --commit;
              END IF;

		for m in cur_order(L_master_po_no) loop 
			L_order_no := m.order_no;

              select I_VDATE + COUNTER_COMMIT into i_vdate1 from dual;

                  COUNTER_COMMIT   := COUNTER_COMMIT + 1; 
            
             for k in cur_Orderdetail(L_order_no) loop

                I_PO_TYPE := k.PO_TYPE;
                	I_SHIP_METHOD := k.SHIP_METHOD;
        			I_SHIP_PORT := k.LADING_PORT;
        			I_FACTORY := k.FACTORY;
        			I_FIRST_DEST := k.location;
        			I_FREIGHT_FORWARDER := k.PARTNER1;
                    io_handover_date := i_vdate1 ;
                    IO_SHIP_DATE := i_vdate1 ;



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
       i_vdate1             := null;
 
        end loop;
        end loop;
 
    delete FROM ORDUPDQTYdate where master_po_no = L_master_po_no;
    COUNTER_COMMIT       := 1;
   
 end loop;
    counter       := 1;
    counter1      := 1;
  end loop;
   delete from order_mfqueue;
   --sys.dbms_lock.sleep(60);
  end loop;
   commit;


exception	
when others then
    dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/

/*

set serveroutput on;
set timing on;

DECLARE
  O_ERROR_MESSAGE VARCHAR2(200);
  I_FACTORY VARCHAR2(10);
  I_PO_TYPE VARCHAR2(4);
  I_SHIP_PORT VARCHAR2(5);
  I_FIRST_DEST NUMBER;
  I_SHIP_METHOD VARCHAR2(6);
  I_FREIGHT_FORWARDER VARCHAR2(10);
  I_FINAL_DEST NUMBER;
  I_SHIP_METHOD_FINAL_DEST VARCHAR2(6);
  IO_HANDOVER_DATE DATE;
  IO_SHIP_DATE DATE;
  IO_NOT_BEFORE_DATE DATE;
  IO_NOT_AFTER_DATE DATE;
  IO_FIRST_DEST_DATE DATE;
  IO_FINAL_DEST_DATE DATE;
  O_EX_FACTORY_DATE DATE;
  O_WEEK_NO NUMBER;
  v_Return BOOLEAN;
BEGIN
  I_FACTORY := '9999';
  I_PO_TYPE := 'D';
  I_SHIP_PORT := 'UNIUN';
  I_FIRST_DEST := '1001';
  I_SHIP_METHOD := '30';
  I_FREIGHT_FORWARDER := '1';
  I_FINAL_DEST := '1001';
  I_SHIP_METHOD_FINAL_DEST := NULL;
  IO_HANDOVER_DATE := '29-NOV-19';
  IO_SHIP_DATE := '30-NOV-19';
  IO_NOT_BEFORE_DATE := NULL;
  IO_NOT_AFTER_DATE := NULL;
  IO_FIRST_DEST_DATE := NULL;
  IO_FINAL_DEST_DATE := NULL;

  v_Return := MA_ASOS.MA_ORDER_UTILS_SQL.GET_DATE(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_FACTORY => I_FACTORY,
    I_PO_TYPE => I_PO_TYPE,
    I_SHIP_PORT => I_SHIP_PORT,
    I_FIRST_DEST => I_FIRST_DEST,
    I_SHIP_METHOD => I_SHIP_METHOD,
    I_FREIGHT_FORWARDER => I_FREIGHT_FORWARDER,
    I_FINAL_DEST => I_FINAL_DEST,
    I_SHIP_METHOD_FINAL_DEST => I_SHIP_METHOD_FINAL_DEST,
    IO_HANDOVER_DATE => IO_HANDOVER_DATE,
    IO_SHIP_DATE => IO_SHIP_DATE,
    IO_NOT_BEFORE_DATE => IO_NOT_BEFORE_DATE,
    IO_NOT_AFTER_DATE => IO_NOT_AFTER_DATE,
    IO_FIRST_DEST_DATE => IO_FIRST_DEST_DATE,
    IO_FINAL_DEST_DATE => IO_FINAL_DEST_DATE,
    O_EX_FACTORY_DATE => O_EX_FACTORY_DATE,
    O_WEEK_NO => O_WEEK_NO);

IF (v_Return) THEN 
    DBMS_OUTPUT.PUT_LINE('v_Return = '|| 'Success' );
    DBMS_OUTPUT.PUT_LINE('v_Return = '|| v_Return);
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'FALSE');
    DBMS_OUTPUT.PUT_LINE('O_ERROR_MESSAGE = ' || O_ERROR_MESSAGE);
  END IF;

DBMS_OUTPUT.PUT_LINE('O_ERROR_MESSAGE = ' || O_ERROR_MESSAGE);
 
DBMS_OUTPUT.PUT_LINE('IO_HANDOVER_DATE = ' || IO_HANDOVER_DATE);
DBMS_OUTPUT.PUT_LINE('IO_SHIP_DATE = ' || IO_SHIP_DATE);
DBMS_OUTPUT.PUT_LINE('IO_NOT_BEFORE_DATE = ' || IO_NOT_BEFORE_DATE);
DBMS_OUTPUT.PUT_LINE('IO_NOT_AFTER_DATE = ' || IO_NOT_AFTER_DATE);
DBMS_OUTPUT.PUT_LINE('IO_FIRST_DEST_DATE = ' || IO_FIRST_DEST_DATE);
DBMS_OUTPUT.PUT_LINE('IO_FINAL_DEST_DATE = ' || IO_FINAL_DEST_DATE);
DBMS_OUTPUT.PUT_LINE('O_EX_FACTORY_DATE = ' || O_EX_FACTORY_DATE);
DBMS_OUTPUT.PUT_LINE('O_WEEK_NO = ' || O_WEEK_NO);


END;
/
      
       



set serveroutput on;
Set timing on;

DECLARE
        O_ERROR_MESSAGE         VARCHAR2(255);
        I_NEED_DATE             DATE;
        I_VDATE                 DATE := '27-JAN-2019';
        v_Return                BOOLEAN;
        L_order_no              rms.ordhead.order_no%type;
        counter                 NUMBER(10)                      := 1;
        COUNTER_COMMIT          NUMBER(10)                      := 0;

  cursor cur_dept is

   select order_no from order_dates_no_ship order by 1;

BEGIN

for k in cur_dept loop
  L_order_no := k.order_no;

  select vdate + counter into I_VDATE from rms.period;
   
      	   IF MOD(COUNTER_COMMIT, 500) = 0 THEN
	  		counter   := counter + 1; 
            commit;
            
          END IF;
	  
      O_ERROR_MESSAGE := NULL;
  
  v_Return := skumar.SET_ORDER_DATES(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_ORDER_NO => L_order_no,
    I_NEED_DATE => I_VDATE,
    I_VDATE => I_VDATE);
    
        IF (v_Return) THEN 
            update skumar.order_dates_no_ship set status = 'S' where order_no = L_order_no;
          ELSE
            update skumar.order_dates_no_ship set status = 'E',comments=O_ERROR_MESSAGE where order_no = L_order_no;
          END IF;
 
     COUNTER_COMMIT :=COUNTER_COMMIT + 1;
          
          
end loop;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/


/*

update ordhead oh set PICKUP_DATE= EARLIEST_SHIP_DATE, NOT_BEFORE_DATE= NOT_AFTER_DATE - 2  
    where order_no in (select order_no from order_dates_no_ship);


create table order_dates_no_ship as 
select order_no from ordhead oh where oh.status ='A' and 
not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no) ;

alter table order_dates_no_ship
ADD (status varchar2(2),comments varchar2(255));


CREATE OR REPLACE FUNCTION SET_ORDER_DATES(O_error_message    IN OUT  RTK_ERRORS.RTK_TEXT%TYPE,
                         I_order_no         IN      rms.ORDHEAD.ORDER_NO%TYPE,
                         I_need_date        IN      rms.ORDSKU.LATEST_SHIP_DATE%TYPE,
                         I_vdate        IN      rms.ORDSKU.LATEST_SHIP_DATE%TYPE)
RETURN BOOLEAN IS

   L_program               VARCHAR2(50)                          := 'SKUMAR.SET_ORDER_DATES';
   L_table                 VARCHAR2(50)                          := NULL;
   L_item                  rms.ITEM_MASTER.ITEM%TYPE                 := NULL;
   L_supplier              rms.ITEM_SUPP_COUNTRY.SUPPLIER%TYPE       := NULL;
   L_lead_time             rms.ITEM_SUPP_COUNTRY.LEAD_TIME%TYPE      := NULL;
   L_latest_ship_days      number                                    := '8';
   L_latest_ship_date      rms.ORDSKU.LATEST_SHIP_DATE%TYPE          := NULL;
   L_max_latest_ship_date  rms.ORDSKU.LATEST_SHIP_DATE%TYPE          := I_need_date;
   L_need_date_eow         rms.ORDHEAD.OTB_EOW_DATE%TYPE             := NULL;
   L_pickup_date           rms.ORDHEAD.PICKUP_DATE%TYPE              := NULL;
   L_not_before_date       rms.ORDHEAD.NOT_BEFORE_DATE%TYPE          := NULL;
   L_not_after_date        rms.ORDHEAD.NOT_AFTER_DATE%TYPE           := NULL;
   L_vdate                 rms.PERIOD.VDATE%TYPE                     := I_vdate;
   RECORD_LOCKED           EXCEPTION;
   PRAGMA                  EXCEPTION_INIT(RECORD_LOCKED, -54);

   cursor C_GET_ITEM_LEAD_TIME is
      select isc.item,
             isc.lead_time,
             isc.supplier
        from rms.item_supp_country isc,
             rms.ordhead oh,
             rms.ordsku os
       where oh.order_no          = I_order_no
         and isc.supplier         = oh.supplier
         and os.order_no          = oh.order_no
         and os.item              = isc.item
         and os.origin_country_id = isc.origin_country_id;

   cursor C_LOCK_ORDHEAD is
      select 'x'
        from rms.ordhead
       where order_no = I_order_no
         for update nowait;

   cursor C_LOCK_ORDSKU is
      select 'x'
        from rms.ordsku
       where order_no = I_order_no
         for update nowait;


BEGIN
      -- Loop through all the ordsku records for the given order
   FOR rec IN c_get_item_lead_time LOOP
      L_supplier := rec.supplier;
      L_latest_ship_date := L_vdate + L_latest_ship_days + nvl(rec.lead_time,0);

      if L_latest_ship_date < I_need_date then
         L_latest_ship_date := I_need_date;
      end if;

      -- lock ordsku before updating
      L_table := 'ORDSKU';
      open C_LOCK_ORDSKU;
      close C_LOCK_ORDSKU;

      -- update this ordsku record accordingly
      update rms.ordsku
         set earliest_ship_date = L_vdate,
             latest_ship_date   = L_latest_ship_date
       where order_no = I_order_no
         and item     = rec.item;

      -- keep track of the greatest latest_ship_date for update the header record
      if L_max_latest_ship_date < L_latest_ship_date then
         L_max_latest_ship_date := L_latest_ship_date;
      end if;

   END LOOP;

   -- grab the eow date for the given need date
   if rms.DATES_SQL.GET_EOW_DATE(O_error_message,
                             L_need_date_eow,
                             I_need_date) = FALSE then
      return FALSE;
   end if;

   -- calculate the pickup, not-before, and not-after dates
   if rms.ORDER_CALC_SQL.CALC_HEADER_DATES(O_error_message,
                                       L_pickup_date,
                                       L_not_before_date,
                                       L_not_after_date,
                                       I_order_no,
                                       L_supplier) = FALSE then
      return FALSE;
   end if;

    if  L_not_before_date > I_need_date then
       L_not_before_date  := I_need_date;
    end if;

    if  L_pickup_date > I_need_date then
        L_pickup_date  := I_need_date;
    end if;

	  if  L_not_after_date < L_max_latest_ship_date then
		    L_not_after_date  := L_max_latest_ship_date;
	  end if ;

   -- lock ordhead before updating
   L_table := 'ORDHEAD';
   open C_LOCK_ORDHEAD;
   close C_LOCK_ORDHEAD;

   -- update the header record
   update rms.ordhead
      set earliest_ship_date   = L_vdate,
          latest_ship_date     = L_max_latest_ship_date,
          not_before_date      = L_not_before_date,
          not_after_date       = L_not_after_date,
          pickup_date          = L_pickup_date,
          otb_eow_date         = L_need_date_eow,
          last_update_id       = get_user,
          last_update_datetime = sysdate
    where order_no = I_order_no;

   return TRUE;

EXCEPTION
   when RECORD_LOCKED then
      O_error_message := SQL_LIB.CREATE_MSG('TABLE_LOCKED',
                                             L_table,
                                             TO_CHAR(I_order_no),
                                             NULL);
      return FALSE;
   when OTHERS then
      O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            to_char(SQLCODE));
      return FALSE;
END;
/



