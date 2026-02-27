select * from rib_message where family != 'NBASNIn' and message_num > '65994616' order by 1 desc;
select * from rib_message where message_num > '65994616' order by 1 desc;
select * from rib_message order by 1 desc;
select * from rib_message where MESSAGE_NUM = '65994616';
select * from rib_message_failure where MESSAGE_NUM = '65989735';


select sh.ORDER_NO, sh.shipment, sh.ASN, sh.SHIP_DATE, RECEIVE_DATE, sh.status_code, to_loc 
    from  rms.shipment sh where shipment in (select shipment from skumar.receipt_adj);

select count(sh.ORDER_NO) from  rms.shipment sh where shipment in (select shipment from skumar.receipt_adj) and status_code = 'I';
select count(sh.ORDER_NO) from  rms.shipment sh where shipment in (select shipment from skumar.receipt_adj) and status_code != 'I';

select * from  rms.shipment sh where shipment in (select shipment from skumar.receipt_adj);
select count(sh.ORDER_NO) from  rms.shipment sh where shipment in (select shipment from skumar.receipt_adj);
select shipment,count(*) from  rms.shipsku sh where shipment in (select shipment from skumar.receipt_adj) group by shipment;




select * from wh;
select sh.ORDER_NO, sh.shipment, sh.ASN, sh.SHIP_DATE from rms.shipment sh where sh.order_no is not null and sh.STATUS_CODE = 'I' and shipment in (select shipment from skumar.receipt_adj);
select sh.ORDER_NO as User_Def_Type_1 , sh.ASN as user_def_type_5, '+' as update_quantity_sign, sk.ITEM as sku_id, sk.QTY_EXPECTED as update_qty,sh.TO_LOC, to_char(sh.SHIP_DATE+1,'YYYYMMDDHHMMSS')  as dstamp, wh.WH_NAME_SECONDARY as to_loc_id from rms.shipment sh, rms.shipsku sk, rms.wh wh where sh.shipment in (select shipment from skumar.receipt_adj) and sh.order_no is not null and sh.STATUS_CODE = 'I' and sh.shipment = sk.shipment and  sh.to_loc = wh.wh;

create table skumar.receipt_adj as  
select DISTINCT SHIPMENT from  rms.shipsku sh where shipment > = '381452522 ';

drop table skumar.receipt_adj;
create table skumar.receipt_adj as  select DISTINCT SHIPMENT from  rms.shipment sh where  order_no >=500062005781  and order_no is not null and to_loc ='1' and rownum <= '3800';
insert into skumar.receipt_adj  select DISTINCT SHIPMENT from  rms.shipment sh where  order_no >=500062005781  and order_no is not null and to_loc ='3' and rownum <= '2500';
insert into skumar.receipt_adj  select DISTINCT SHIPMENT from  rms.shipment sh where  order_no >=500062005781  and order_no is not null and to_loc ='4' and rownum <= '2000';;

select * from wh;

delete from receipt_adj where shipment in (select shipment from rms.shipment sh where status_code != 'I');

select * from  rms.shipment sh where ORDER_NO is not null and to_loc != '1' and shipment > = '381452522 ';


create table skumar.receipt_adj as  select * from  rms.shipsku sh where shipment > = '381452522 ';
select * from  rms.shipsku sh where shipment > = '381452522 ';

drop table receipt_adj;
create table skumar.receipt_adj as 
select * from ( select SH.SHIPMENT from rms.shipment sh
       where sh.order_no  IN (SELECT ORDER_NO FROM ORDHEAD WHERE CREATE_DATETIME>= to_date('21-OCT-2023 10.00', 'DD-MON-YYYY hh24:mi') ));

select * from ( select SH.SHIPMENT from rms.shipment sh
       where sh.order_no  IN (SELECT ORDER_NO FROM ORDHEAD WHERE );


drop table receipt_adj;
create table skumar.receipt_adj as 
select SH.SHIPMENT from rms.shipment sh where STATUS_CODE = 'I' and order_no is not null and rownum <= '20';


45 ASN 

POs
2000 POs (500 skus)

ASN
1000 PO's (500 sku's)

PO receipt 
1000 PO's (500 sku's)


select * from rms.shipment where order_no >=500062005781 and ;

select sh.ORDER_NO, sh.shipment, sh.ASN, sh.SHIP_DATE, RECEIVE_DATE, sh.status_code, to_loc 
    from  rms.shipment sh where shipment in (select shipment from skumar.receipt_adj);
select sh.ASN, sk.ITEM as sku_id, sk.QTY_EXPECTED as qty  
    from rms.shipment sh, rms.shipsku sk, rms.wh wh where sh.shipment in (select shipment from skumar.receipt_adj) and sh.shipment = sk.shipment;


select count(order_no)
from rms.ordhead 
 where CREATE_DATETIME>= to_date('15-JAN-2023 10.00', 'DD-MON-YYYY hh24:mi');

drop table skumar.receipt_adj;

create table skumar.receipt_adj as 
select * from (
  select DISTINCT SH.SHIPMENT
        from rms.shipment sh
       where sh.order_no is not null
         and sh.to_loc = '3'
         and sh.status_code = 'I' 
		  and sh.RECEIVE_DATE is null ) WHERE  rownum <= '20';

insert into receipt_adj 
select * from (
  select DISTINCT SH.SHIPMENT
        from rms.shipment sh
       where sh.order_no is not null
         and sh.to_loc = '4'
         and sh.status_code = 'I' 
		  and sh.RECEIVE_DATE is null ) WHERE  rownum <= '400';

insert into receipt_adj 
select * from (
  select DISTINCT SH.SHIPMENT
        from rms.shipment sh
       where sh.to_loc ='1'
		 and sh.order_no is not null
         and sh.status_code = 'I' 
		  and sh.RECEIVE_DATE is null ) WHERE  rownum <= '4999';

        
select STATUS_CODE,count(1) from SHIPMENT where shipment in (select shipment from skumar.receipt_adj) group by STATUS_CODE;
        
          
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.receipt_adj TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.receipt_adj TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.receipt_adj TO rdatla; 

  
         select * from shipment sh where sh.order_no is not null --and to_loc ='1'
                and sh.STATUS_CODE = 'I' and shipment in (select shipment from skumar.receipt_adj);
 
         select sh.ORDER_NO as User_Def_Type_1 , sh.ASN as user_def_type_5, '+' as update_quantity_sign, sk.ITEM as sku_id, sk.QTY_EXPECTED as update_qty,
          sh.TO_LOC, to_char(sh.SHIP_DATE+1,'YYYYmmddHHMISS')  as dstamp, wh.WH_NAME_SECONDARY as to_loc_id
                from shipment sh, shipsku sk, wh wh
                where sh.shipment in (select shipment from skumar.receipt_adj) and sh.order_no is not null
         and sh.STATUS_CODE = 'I' and sh.shipment = sk.shipment
         and  sh.to_loc = wh.wh;
         
    select sh.ORDER_NO as User_Def_Type_1 , sh.ASN as user_def_type_5, '+' as update_quantity_sign, sk.ITEM as sku_id, sk.QTY_EXPECTED as update_qty,sh.TO_LOC, to_char(sh.SHIP_DATE+1,'YYYYMMDDHHMMSS')  as dstamp, wh.WH_NAME_SECONDARY as to_loc_id from rms.shipment sh, rms.shipsku sk, rms.wh wh where sh.shipment in (select shipment from skumar.receipt_adj) and sh.order_no is not null and sh.STATUS_CODE = 'I' and sh.shipment = sk.shipment and  sh.to_loc = wh.wh;
         
          select * from shipsku where shipment ='22814546'; --QTY_RECEIVED, QTY_EXPECTED
          select * from shipment where shipment ='22814546';
          select ITEM, QTY_EXPECTED, TO_LOC from shipsku where shipment ='1283';
          
          
<dataheader>
    <record_type>ITL</record_type>
    <action>E</action>
    <code>Receipt</code>
    <original_quantity_sign>+</original_quantity_sign>
    <original_qty>0.000000</original_qty>
    <update_quantity_sign>+</update_quantity_sign>
    <update_qty>7.000000</update_qty>
    <dstamp>20170510161927</dstamp>
    <client_id>ASOS</client_id>
    <sku_id>YBOAC919955</sku_id>
    <from_loc_id>GI_RATS</from_loc_id>
    <to_loc_id>GI_RATS</to_loc_id>
    <tag_id>CA08051723</tag_id>
    <reference_id>00643170004261</reference_id>
    <line_id>5</line_id>
    <user_id>ABBEY</user_id>
    <site_id>GB01</site_id>
    <container_id>CA08051723</container_id>
    <owner_id>ASOS</owner_id>
    <lock_status>Unlocked</lock_status>
    <supplier_id></supplier_id>
    <user_def_type_1>0060000126001</user_def_type_1>
    <user_def_type_5>00643170004261</user_def_type_5>
    <user_def_type_7>0060000126001</user_def_type_7>
    <user_def_date_1>20170510161927</user_def_date_1>
    <user_def_num_1>5.000000</user_def_num_1>
    <user_def_num_2>1.000000</user_def_num_2>
    <user_def_num_3>1.000000</user_def_num_3>
    <user_def_num_4>1.000000</user_def_num_4>
    <time_zone_name>Europe/London</time_zone_name>
    <config_id>YBOAC919950</config_id>
    <complete_dstamp>20170510161927</complete_dstamp>
    <lock_code></lock_code>
    <process_bo>N</process_bo>
  </dataheader>
  
  
select * from nb_shipment_cfa_ext where shipment in (4664844,4676832); you have records created from 22-12-2018
  
select * from rib_message where family like 'Receipt' order by 1 desc;
select * from rib_message where message_num >632854 order by 1 desc;

select * from rib_message where message_num =632854;
select * from rib_message_failure where message_num =632854;

select count(1) from tran_data;

select * from shipment where asn like '500004358601231223'; --
select * from shipsku where shipment in (4662960,4674745); --Before

select * from shipment where asn like '500004122891231223'; --
select * from shipsku where shipment in (4666426,4678610); --Before


select  status from ordhead where order_no in (50000435860);
select * from ordloc where order_no in (50000435860);
select * from shipment where order_no in (50000435860);
select STATUS_CODE,count(1) from shipment where order_no in (50000435860) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50000435860));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (50000435860));
select * from DOC_CLOSE_QUEUE where doc in (50000435860);
select * from item_loc_soh where (item,loc) in (select item,location from ordloc where order_no in (50000435860));
select * from tran_data where ref_no_1 in (50000435860);



-- 500 in One
select sh.shipment,
    sh.ORDER_NO as User_Def_Type_1 , 
    sh.ASN as user_def_type_5, 
    '+' as update_quantity_sign, 
    sk.ITEM as sku_id, 
    sk.QTY_EXPECTED as update_qty, 
    sh.TO_LOC,to_char(sh.SHIP_DATE+1,'YYYYMMDDHHMMSS')  as dstamp, 
    wh.WH_NAME_SECONDARY as to_loc_id 
from rms.shipment sh, rms.shipsku sk, rms.wh wh 
where sh.order_no is not null and sh.STATUS_CODE = 'I' 
    and sh.shipment = sk.shipment and  sh.to_loc = wh.wh and to_loc ='1' 
    and sh.shipment in (select shipment from skumar.receipt_adj);
    
    delete from receipt_adj;

    insert into receipt_adj
    select shipment from shipment sh where sh.order_no is not null
        and exists ( select 1 from rms.ordhead oh where oh.order_no = sh.order_no and oh.status ='A') 
        and rownum <= '1600';
        
select * from shipment sh where sh.order_no is not null and RECEIVE_DATE is null and to_loc = '1'
        and exists ( select 1 from rms.ordhead oh where oh.order_no = sh.order_no and oh.status ='A') 
        and rownum <= '1600';
        