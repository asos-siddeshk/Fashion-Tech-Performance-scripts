
select * from repl_item_loc where item in (select item from item_master where item_parent ='100683999');


select * from repl_item_loc where item in (select item from item_master where item_parent ='100683999');
select * from repl_results where item in (select item from item_master where item_parent ='100683999');
select * from item_master where item_parent in (select item from repl_results where item ='100683999');


select * from daily_purge where key_value in (select item from item_master where item_parent ='100683999');

select * from ma_asos.ma_logs where trunc(log_ts) = trunc(sysdate) order by 1 desc;

select item from item_master where item_parent ='100004203';


select MASTER_ITEM, ITEM, LOCATION, PRIMARY_REPL_SUPPLIER, ORIGIN_COUNTRY_ID, ACTIVATE_DATE, DEACTIVATE_DATE, count(1) from repl_results
    group by MASTER_ITEM, ITEM, LOCATION, PRIMARY_REPL_SUPPLIER, ORIGIN_COUNTRY_ID, ACTIVATE_DATE, DEACTIVATE_DATE having count(1) >1;
    
    begin
    	DELETE FROM repl_results
		WHERE rowid not in
            (SELECT MIN(rowid)
                FROM repl_results
                GROUP BY MASTER_ITEM, ITEM, LOCATION, PRIMARY_REPL_SUPPLIER, ORIGIN_COUNTRY_ID, ACTIVATE_DATE, DEACTIVATE_DATE);		
     commit;
     end ;
     /
     
    select * from repl_item_loc;
    
        select * from repl_attr;
    
    
select * from if_errors;
update sups set  sup_status = 'A' where sup_status = 'I';
    
    
    select * from item_supplier where item = '100683999';
    select * from sups where supplier = '1100000304';
    
    
    
    