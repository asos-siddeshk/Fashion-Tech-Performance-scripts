DROP TABLE skumar.pro_alloc ;
create table pro_alloc as
    select alloc_no from alloc_header where status!='C' and order_no in (select order_no from ordhead where status ='C') and rownum<='10000';


delete from skumar.pro_alloc where  alloc_no in (select alloc_no from alloc_header where status ='C');

select * from alloc_header where alloc_no in (select alloc_no from skumar.pro_alloc) and status!='C';
select count(1) from alloc_mfqueue;
select count(1) from item_mfqueue;
select count(1) from tsf_mfqueue;
select * from alloc_mfqueue;
delete from alloc_mfqueue;

select * from rib_message order by 1 desc;
select * from rib_message_failure where message_num ='636155';

--20--
Product reclassifications
--40k options - 300K messages -- itemhrdupd
Buyrarchy reclassifications
--3k options - 60K messages -- itemudaffcre


select * from rib_message where message_num > 635558 order by 1 desc;

update alloc_header set status ='C' where alloc_no in (select alloc_no from skumar.pro_alloc) and status!='C';

select * from alloc_detail where alloc_no in (select alloc_no from skumar.pro_alloc);

insert into doc_close_queue
        select distro_no,'A' from shipsku where distro_no in (select alloc_no from pro_alloc) 
         and shipment in (select shipment from shipment where status_code='R');
    
select * from shipment where shipment in (select distinct shipment from shipsku where distro_no in (select alloc_no from skumar.pro_alloc));

select * from shipsku where distro_no in (select alloc_no from skumar.pro_alloc);

Update restart_program_status set PROGRAM_STATUS ='ready for start';
delete from rms.restart_bookmark;

select DOC_TYPE,count(1) from skumar.doc_close_queue_bk group by DOC_TYPE;
select DOC_TYPE,count(1) from doc_close_queue group by DOC_TYPE;

select * from shipment where shipment in (select distinct shipment from shipsku where distro_no in (select alloc_no from pro_alloc)) and status_code='R';


