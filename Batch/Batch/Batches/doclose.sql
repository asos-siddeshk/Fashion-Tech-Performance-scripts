create table pro_alloc as 
    select alloc_no from alloc_header ah where ah.status = 'A'  and alloc_no in (select doc from doc_close_queue d where d.doc_type ='A'
      and exists (select  1 from rms.alloc_header t where t.alloc_no = d.doc and t.status! ='C'));

select alloc_no from pro_alloc;

select alloc_no from skumar.pro_alloc;
select * from pro_order;

insert into skumar.pro_alloc
select alloc_no from alloc_header ah where ah.status = 'A' and order_no in (select order_no from skumar.pro_order); 


drop table pro_order;
create table pro_order as 
select order_no from ordhead oh where status ='A' and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no ) and trunc(WRITTEN_DATE) <= '05-JAN-24' and rownum <= '6000';--93k

select * from ordhead oh where status ='A' and not exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no ) and trunc(WRITTEN_DATE) <= '05-JAN-24'
    and rownum <= '6000';--93k


Retention data of PO, TSF should be processed for this batch.
P	42332
A	8069
T	269928

   SELECT doc_type, count(1)
       FROM rms.doc_close_queue
      group by doc_type;
    
select * from if_errors;  

   SELECT doc_type, count(1)
       FROM skumar.doc_close_queue_bk
      group by doc_type;
      
insert into doc_close_queue
 select * from doc_close_queue_bk where DOC_TYPE='P' and doc not in (select doc from doc_close_queue);

delete from doc_close_queue d where d.doc_type ='P'
      and exists (select  1 from rms.ordhead t where t.order_no = d.doc and t.status='C'); 
      
delete from doc_close_queue d where d.doc_type ='T'
      and exists (select  1 from rms.tsfhead t where t.tsf_no = d.doc and t.status ='C');

select * from doc_close_queue d where d.doc_type ='T'
      and exists (select  1 from rms.tsfhead t where t.tsf_type = 'CO' and t.tsf_no = d.doc and t.status ='C');
      
delete from doc_close_queue d where d.doc_type ='A'
      and exists (select  1 from rms.alloc_header t where t.alloc_no = d.doc and t.status ='C');

      
      
select * from if_errors;
      
      
create table  doc_close_queue_bk as     
   SELECT *
       FROM doc_close_queue;
       
       drop table doc_close_queue_bk;
       
      DELETE FROM doc_close_queue
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM doc_close_queue
		GROUP BY DOC, DOC_TYPE);	
      
select * from rms.restart_program_status where program_name like '%docclose%';
select * from rms.restart_control where program_name like '%docclose%';
Insert into restart_program_status values ('docclose',2,to_date('07-MAR-19','DD-MON-RR'),'docclose','completed',null,null,to_date('07-MAR-19','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status values ('docclose',3,to_date('07-MAR-19','DD-MON-RR'),'docclose','completed',null,null,to_date('07-MAR-19','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status values ('docclose',4,to_date('07-MAR-19','DD-MON-RR'),'docclose','completed',null,null,to_date('07-MAR-19','DD-MON-RR'),null,null,null,null,null);
Update restart_program_status set PROGRAM_STATUS ='ready for start' where program_name like '%docclose%';
delete from rms.restart_bookmark where restart_name like '%docclose%';

      
      select count(1) from doc_close_queue_bk d where d.doc_type ='T'
      and not exists (select  1 from rms.tsfhead t where t.tsf_no = d.doc);
    
    insert into doc_close_queue  
    select doc,'T' from doc_close_queue_bk d where d.doc_type ='T'
      and exists (select  1 from rms.tsfhead t where t.tsf_no = d.doc and t.status ='S') and rownum< ='15000';
      
      insert into doc_close_queue  
    select doc,'P' from doc_close_queue_bk d where d.doc_type ='P'
      and exists (select  1 from rms.ordhead t where t.order_no = d.doc and t.status!='C') and rownum< ='15000';
      
      
      
select * from tsfhead where tsf_no in ('7009273417');
select * from tsfdetail where tsf_no in ('7009273417');
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in ('7009273417'));
select * from shipSKU where DISTRO_NO in ('7009273417');
select * from shipSKU_loc where shipment in (select shipment from shipSKU where DISTRO_NO in ('7009273417'));
select * from DOC_CLOSE_QUEUE where doc in ('7009273417');
      
      
      create table doc_close_queue_bk as 
      SELECT *
       FROM doc_close_queue;
delete from doc_close_queue where doc_type ='A';
delete from doc_close_queue where doc_type ='T' and rownum <= '15000';



create table doc_close_queue_bk as
select * from doc_close_queue;
drop table doc_close_queue_bk;

delete from doc_close_queue where DOC_TYPE='T';

insert into doc_close_queue
select * from doc_close_queue_bk where rownum <='210000';

select * from doc_close_queue where DOC_TYPE='P' and doc in (select doc from doc_close_queue_bk);

insert into doc_close_queue
select * from doc_close_queue_bk where DOC_TYPE='P' and doc not in (select doc from doc_close_queue);

select count(1),CLOSE_DATE from rms.alloc_header group by CLOSE_DATE;

select status,count(1) from rms.alloc_header group by status;
select status,count(1) from rms.ordhead group by status;
select status,count(1) from rms.tsfhead group by status;

select count(1) from doc_close_queue;

select count(1) from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no );--93k
select count(1) from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no and sh.status_code ='I'); --43k
select count(1) from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no and sh.status_code ='R'); --50k


select count(1) from ordhead oh where status ='A' and exists (select 1 from rms.shipment sh where sh.order_no = oh.order_no );--93k



insert into doc_close_queue
select order_no,'P' --50K
    from ordhead oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sh.order_no = oh.order_no and sh.status_code ='R' and sh.shipment =sk.shipment
                and QTY_RECEIVED is not null) and rownum<= '5000' ; --50k


select order_no,'P'  -- 43K
    from ordhead oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sh.order_no = oh.order_no and sh.status_code ='R' and sh.shipment =sk.shipment
                and QTY_RECEIVED is null)  ; --50k
                


select order_no,'P'  -- 43K
    from ordhead oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sh.order_no = oh.order_no and sh.status_code ='R' and sh.shipment =sk.shipment
                and QTY_RECEIVED is null)  ; --50k



select order_no,'P'  -- 43K
    from ordhead oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sh.order_no = oh.order_no and sh.status_code ='R' and sh.shipment =sk.shipment
                and QTY_RECEIVED is null)  ; --50k
                
                
                
                
                
	DELETE FROM rms.doc_close_queue
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM rms.doc_close_queue
		GROUP BY DOC);	
        
        
        
select  order_no,status from rms.ordhead where order_no in (50000682383);
select  * from ordhead where order_no in (50000682383);
select * from ordloc where order_no in (50000682383);
select * from shipment where order_no in (50000682383);
update shipment set STATUS_CODE ='I' where order_no in (50000682383);

select STATUS_CODE,count(1) from shipment where order_no in (50000682383) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50000682383));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (50000682383));
select * from DOC_CLOSE_QUEUE where doc in (50000682383);
select * from item_loc_soh where (item,loc) in (select item,location from ordloc where order_no in (50000682383));
select * from tran_data where ref_no_1 in (50000682383);



select * from tsfhead where tsf_no in ('7011580855');
select * from tsfdetail where tsf_no in ('7011580855');
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in ('7011580855'));
select * from shipSKU where DISTRO_NO in ('7011580855');
select * from shipSKU_loc where shipment in (select shipment from shipSKU where DISTRO_NO in ('7011580855'));
select * from DOC_CLOSE_QUEUE where doc in ('7011580855');
select * from item_loc_soh where  (item,loc) in (select ITEM, LOCATION from tran_data where ref_no_1 in ('7011580855'));
select * from tran_data where ref_no_1 in ('7011580855') order by item,location,tran_code;


begin

/*
insert into DOC_CLOSE_QUEUE
select tsf_no,'T'  
    from tsfhead oh where status ='S' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sk.DISTRO_NO = oh.tsf_no and sh.status_code ='I' and sh.shipment =sk.shipment
                and QTY_RECEIVED is not null) and rownum <= '50000'; 
*/
insert into DOC_CLOSE_QUEUE
select alloc_no,'A'  
    from alloc_header oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sk.DISTRO_NO = oh.alloc_no and sh.status_code ='R' and sh.shipment =sk.shipment
                and QTY_RECEIVED is not null) and rownum <= '150000'; 


commit;
end;
/


select tsf_no,'T'  
    from tsfhead oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sk.DISTRO_NO = oh.tsf_no and sh.status_code ='I' and sh.shipment =sk.shipment
                and QTY_EXPECTED is not null) and rownum <= '10000'; 
                
                select * from shipsku;

drop table alloc_clean;
create table alloc_clean as
select alloc_no   
    from alloc_header oh where status ='A' 
    and exists (select 1 from rms.shipment sh,rms.shipsku sk where sk.DISTRO_NO = oh.alloc_no and sh.status_code ='R' and sh.shipment =sk.shipment
                and QTY_RECEIVED is not null) and                 
    rownum <= '150000'; 

select * from alloc_header where alloc_no in ('1002099801');
select * from alloc_detail where alloc_no in ('1002099801');
select * from shipment where shipment in (select shipment from shipSKU where DISTRO_NO in ('1002099801'));
select * from shipSKU where DISTRO_NO in ('1002099801');
select * from shipSKU_loc where shipment in (select shipment from shipSKU where DISTRO_NO in ('1002099801'));
select * from DOC_CLOSE_QUEUE where doc in ('1002099801');
select * from item_loc_soh where  (item,loc) in (select ITEM, LOCATION from tran_data where ref_no_1 in ('1002099801'));
select * from tran_data where ref_no_1 in ('1002099801') order by item,location,tran_code;

select * from alloc_clean;
Update alloc_header set status ='A' where alloc_no in (select alloc_no from alloc_clean);
delete from alloc_mfqueue;


insert into DOC_CLOSE_QUEUE
select alloc_no,'A'  from alloc_clean;
