select *
     from SUPP_ASOS.sc_batch_config
    where program_name = UPPER('SC_EMAIL_ORDER_ADDTOQ');

select distinct owner from all_tables;
select * from all_tables where owner like 'SUPP_ASOS' and table_name like '%EMAIL%';

SC_EMAIL_SHIPMENT_PUBINFO
SC_EMAIL_ORDER_PUBINFO

SC_EMAIL_ORDER_QUEUE
SC_EMAIL_SHIPMENT_QUEUE

select distinct ERROR_MSG from SUPP_ASOS.SC_EMAIL_ORDER_QUEUE;

select * from SUPP_ASOS.SC_PO_EMAIL_QUEUE;
select * from SUPP_ASOS.SC_PO_EMAIL_PUBINFO where published ='N';

select * from SUPP_ASOS.SC_PO_EMAIL_HIST;
select * from SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO;

update SUPP_ASOS.SC_EMAIL_ORDER_PUBINFO set PUBLISHED_IND ='N' where PUBLISHED_IND ='Y' and rownum<='15000';

select * from SUPP_ASOS.SC_EMAIL_SHIPMENT_PUBINFO;
select * from SUPP_ASOS.SC_EMAIL_SHIPMENT_QUEUE;




select * from all_tables where owner like 'DAS' and table_name like '%ORD%';