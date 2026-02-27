select item from rms.item_master where status ='A' 
        and item_level ='1' and Item_DESC='Item creation Perf Test'
        and CREATE_DATETIME>=to_date('03-DEC-2020 13:00', 'DD-MON-YYYY hh24:mi')
        and CREATE_DATETIME < to_date('03-DEC-2020 15:10', 'DD-MON-YYYY hh24:mi') ORDER BY 1;

select po_type,count(1) from rms.ORDHEAD where status ='A' 
        and CREATE_DATETIME>=to_date('03-DEC-2020 17:00', 'DD-MON-YYYY hh24:mi')
        and CREATE_DATETIME < to_date('03-DEC-2020 23:00', 'DD-MON-YYYY hh24:mi') group by po_type ORDER BY 1;
        

select item from rms.item_master where status ='A' 
        and item_level ='1' and Item_DESC='Item creation Perf Test'
        and CREATE_DATETIME>=to_date('03-DEC-2020 13:00', 'DD-MON-YYYY hh24:mi')
        and CREATE_DATETIME < to_date('03-DEC-2020 15:10', 'DD-MON-YYYY hh24:mi') ORDER BY 1;

select count(1) from rms.ordhead where CREATE_DATETIME>= to_date('03-DEC-2020 17:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%';
SELECT count(1) FROM ALLOC_HEADER where ORDER_no in (select ORDER_no from rms.ordhead where CREATE_DATETIME>= to_date('03-DEC-2020 17:00', 'DD-MON-YYYY hh24:mi')
    and comment_desc like '%PO Create%');

SELECT count(1) FROM shipment where ORDER_no in 
    (select ORDER_no from rms.ordhead where CREATE_DATETIME>= to_date('03-DEC-2020 17:00', 'DD-MON-YYYY hh24:mi') and comment_desc like '%PO Create%');



select count(shipment) from shipment where shipment > 50948532 and order_no is not null ;


select * from shipment where shipment > 50984862 and order_no is not null ;


--0100000000670588
select count(1) from ordhead where order_no > '50009228743' and status = 'A';
select distinct order_no from ordhead where order_no > '50009228743' and status = 'A';

select distinct order_no from ordloc where item in (select item from item_master where item_parent ='163664434');

select * from skulist_head where SKULIST_DESC like '%PO%';

select * from skulist_detail where skulist = '2902991';

select ITEM_PARENT,count(1) from item_master where item_parent in (select item from skulist_detail where skulist = '2902991') group by ITEM_PARENT;


select * from rib_message;