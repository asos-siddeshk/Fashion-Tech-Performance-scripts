
/*
	nuno correia ORC  21/12/2021
	PO receiving leveraging the UI API 
*/
alter session set current_schema=RMS;

clear buffer;
set line 256;
set pagesize 1000;
set serveroutput on ;

declare 
L_error_message            RTK_ERRORS.RTK_TEXT%TYPE := NULL;
L_item_receiving_table     RECEIVE_SQL.ITEM_RECV_TABLE;
I_shipment                      SHIPMENT.SHIPMENT%TYPE;  --Shipment ID
--I_distro_content                VARCHAR2 := NULL;
I_location                      SHIPMENT.TO_LOC%TYPE;
I_asn_bol_no                    SHIPMENT.ASN%TYPE ;   -- ASN Number
I_order_no                      SHIPMENT.ORDER_NO%TYPE ;   -- PO Number
I_receipt_date                  SHIPMENT.RECEIVE_DATE%TYPE := sysdate;
I_disposition                   INV_STATUS_CODES.INV_STATUS_CODE%TYPE := 'ATS';
L_item                          ITEM_MASTER.ITEM%TYPE ;  -- SKU Number
	
 cursor c_tsf is
select s.shipment,s.order_no,s.asn,s.to_loc,ss.item
from rms.shipment s 
inner join (select shipment,item from shipsku where seq_no=1) ss on ss.shipment=s.shipment
where s.shipment>381427518 and s.order_no not in (500060003792,500060003229,500060003689,500060003351);

begin
   dbms_output.enable(50000); 
for m in c_tsf loop
I_shipment := m.shipment;
I_location := m.to_loc;
I_asn_bol_no := m.asn;
I_order_no := m.order_no;
L_item := m.item;


if ORDER_RCV_SQL.PO_LINE_ITEM_ONLINE(L_error_message,
                                                 I_location,
                                                 I_order_no,
                                                 L_item,
                                                50,--qty_received,
                                                 'R',
                                                 sysdate, --I_receipt_date,
                                                 I_order_no,
                                                 I_asn_bol_no,
                                                 NULL,
                                                 null, --carton,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 'ATS', --inv_status,
                                                 NULL,
                                                 'Y',
                                                 I_shipment,
                                                 null, --weight_received,
                                                 null--weight_received_uom
												 ) = FALSE then
				dbms_output.put_line('ERROR:' || L_error_message);
				else
				dbms_output.put_line('OK');
				
				end if;                
end loop;
end;
/