select trunc(CREATE_DATETIME),count(1) from rms.ordcust group by trunc(CREATE_DATETIME) order by 1; --COUNT(1)
select trunc(CREATE_DATETIME),count(1) from ordcust_detail group by trunc(CREATE_DATETIME) order by 1; --COUNT(1)
select vdate -765 from rms.period;
select ORDCUST_NO,count(1) from ordcust_detail group by ORDCUST_NO order by ORDCUST_NO  desc;

select * from ordcust;
select * from ordcust_detail;

Update ordcust set status ='X'  where trunc(CREATE_DATETIME)<='11-JAN-16' and status ='C';
Update ordcust set CREATE_DATETIME ='10-JAN-16'  where trunc(CREATE_DATETIME) ='02-NOV-16' and rownum <= '50000';
Update ordcust set CREATE_DATETIME ='09-JAN-16'  where trunc(CREATE_DATETIME) ='02-NOV-16' and rownum <= '50000';
Update ordcust set CREATE_DATETIME ='08-JAN-16'  where trunc(CREATE_DATETIME) ='02-NOV-16' and rownum <= '50000';

update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;
select * from rms.restart_program_status;


-- 17k deleted 

select * from ordcust_detail;
select * from ordcust;
select * from all_constraints where CONSTRAINT_NAME like 'ODL_UK';

select count(oc.ordcust_no)
        from rms.ordcust oc,
             rms.purge_config_options pc,
             rms.period p
       where (   oc.status = 'X'
             or  (   oc.status = 'C'
                 and oc.order_no is NULL
                 and oc.tsf_no is NULL))
         and NVL(MONTHS_BETWEEN(p.vdate, oc.create_datetime),0) > pc.cust_order_history_months;
         
select cust_order_history_months from purge_config_options;

  select ocd.ordcust_no
        from rms.ordcust oc,
             rms.ordcust_detail ocd,
             rms.purge_config_options pc,
             rms.period p
       where (   oc.status = 'X'
             or  (   oc.status = 'C'
                 and oc.order_no is NULL
                 and oc.tsf_no is NULL))
         and NVL(MONTHS_BETWEEN(p.vdate, oc.create_datetime),0) > pc.cust_order_history_months
         and oc.ordcust_no = ocd.ordcust_no;
         
       select vdate -173 from rms.period;  
         
         
set serveroutput on;
set timing on;

declare
    
    
     c_commit  	        NUMBER(10);
     l_custord_id         varchar2(32000);
    l_customer_order     varchar2(32000);
    l_fulfilord_id       varchar2(32000);
     l_date       date;
	l_item               rms.item_master.item%type;
l_ref_item               rms.item_master.item%type;
l_TSF_NO             rms.tsfdetail.TSF_NO%type;
      l_from_loc             rms.tsfhead.from_loc%type;
    l_tsf_qty             rms.tsfdetail.tsf_qty%type;
    
cursor c_custord is
    select distinct tsf.TSF_NO, from_loc from rms.tsfhead tsf where status ='C' and 
        not exists  (select 1 from ordcust o where tsf_no = tsf.TSF_NO ) and rownum<=20000 order by 1;

cursor c_custord_detail (l_tsf_no rms.tsfdetail.TSF_NO%type) is
   select item,tsf_qty from rms.tsfdetail tsf where tsf_no = l_tsf_no and rownum<='7';

begin

 for k in 1..2 loop 
    select vdate -183 into l_date from rms.period;
    
for i in c_custord loop 
	l_TSF_NO    := i.TSF_NO;
	l_from_loc  := i.from_loc;
                
        SELECT rms.ORDCUST_SEQ.nextval INTO l_custord_id FROM dual;
        SELECT rms.SVC_CUSTORDSUB_ID_SEQ.nextval INTO l_customer_order FROM dual;
        select rms.SVC_FULFILORD_ID_SEQ.nextval into l_fulfilord_id  FROM dual; 
    
        insert into rms.ordcust        (            ORDCUST_NO , 
													STATUS , 
                                                    TSF_NO,
													FULFILL_LOC_TYPE, 
													FULFILL_LOC_ID ,
                                                    SOURCE_LOC_TYPE,
                                                    SOURCE_LOC_ID,
													CUSTOMER_ORDER_NO, 
													FULFILL_ORDER_NO, 
													PARTIAL_DELIVERY_IND,
                                                    CONSUMER_DELIVERY_DATE,
                                                    BILL_FIRST_NAME,
                                                    BILL_LAST_NAME,
                                                    BILL_ADD1,
                                                    BILL_CITY,
                                                    BILL_STATE,
                                                    BILL_COUNTRY_ID,
                                                    DELIVER_FIRST_NAME,
                                                    DELIVER_LAST_NAME,
                                                    DELIVER_ADD1,
                                                    DELIVER_CITY,
                                                    DELIVER_STATE,
                                                    DELIVER_COUNTRY_ID,
                                                    DELIVER_PHONE,
													CREATE_DATETIME, 
													CREATE_ID,
                                                    LAST_UPDATE_DATETIME,
													LAST_UPDATE_ID 
													)
                            values					(l_custord_id,
                                                     'X',
                                                     l_TSF_NO,
                                                     'V',
                                                     '10001',
                                                     'WH',
                                                     l_from_loc,
                                                     l_customer_order,
                                                     l_fulfilord_id,
                                                     'N',
                                                     l_date,
                                                     'Not Available',
                                                     'Not Available',
                                                     'Not Available',
                                                     'Not Available',
                                                     'N/A',
                                                     'GB',
                                                     'Not Available',
                                                     'Not Available',
                                                     'Not Available',
                                                     'Not Available',
                                                      'N/A',
                                                       'GB',
                                                      'Not Available',
                                                      l_date,
													 'PTUSER',
													  l_date,                                                     
                                                     'PTUSER');
							
 for j in c_custord_detail(l_TSF_NO) loop 
	l_item:= j.item;  
    l_tsf_qty:= j.tsf_qty;
    
        INSERT into	rms.ordcust_detail (         ORDCUST_NO,
                                                 ITEM,
                                                 ORIGINAL_ITEM,
                                                 QTY_ORDERED_SUOM,
                                                 QTY_CANCELLED_SUOM,
                                                 STANDARD_UOM,
                                                 TRANSACTION_UOM,
                                                 SUBSTITUTE_ALLOWED_IND,
                                                 CREATE_DATETIME,
                                                 CREATE_ID,
                                                 LAST_UPDATE_DATETIME,
                                                 LAST_UPDATE_ID)
                                         
                 VALUES        ( 		 l_custord_id,
                                         l_item,
                                         l_REF_ITEM,
                                         l_tsf_qty,
                                         1,
                                         'EA',
                                         'EA',
                                         'N',
                                        l_date,
										'PTUSER',
										l_date,                                                     
                                        'PTUSER');                                                   
		 l_REF_ITEM :=l_REF_ITEM + 1; 
        end loop;    
        l_REF_ITEM := '1';
		end loop;
        
		    c_commit :=c_commit + 1;            
       IF MOD(c_commit, 10) = 0 THEN
        COMMIT;
       END IF;  
        
 end loop;     
 commit;   
        
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


