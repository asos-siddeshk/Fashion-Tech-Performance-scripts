set serveroutput on;
set timing on;

DECLARE
L_error_message                 varchar2(255);

   cursor C_GET_SHIP is 
     select sh.shipment,
            sh.TO_LOC, 
            sh.ASN,
            sh.ORDER_NO,
            sysdate as RCV_DATE,
            sk.item,
            sk.qty_expected
            from shipment sh, shipsku sk
      where sh.shipment = sk.shipment and sh.shipment = '357644313'
        and sk.QTY_EXPECTED > '0' and  sk.QTY_RECEIVED is null;
begin
   for rec in C_GET_SHIP loop 
      if ORDER_RCV_SQL.PO_LINE_ITEM_ONLINE(L_error_message,
                                                rec.TO_LOC,
                                                rec.order_no,
                                                rec.item,
                                                rec.qty_expected,
                                                'R',
                                                rec.RCV_DATE,
                                                rec.order_no,
                                                rec.asn, 
                                                NULL,
                                                null,
                                                NULL,
                                                NULL,
                                                NULL,
                                                'ATS',
                                                NULL,
                                                'Y',
                                                rec.shipment,
                                                null,null) = FALSE then 
        insert into skumar.ship_status values (rec.shipment,rec.item,L_error_message);
      else 
        insert into skumar.ship_status values (rec.shipment,rec.item,'S');
      end if;   
end loop;  

EXCEPTION
    when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK; 
END;
/


/*--desc shipment;
--create table ship_status (shipment NUMBER(12), item VARCHAR2(20), error_message VARCHAR2(50));

select * from ship_status;
select * from shipment;
*/

