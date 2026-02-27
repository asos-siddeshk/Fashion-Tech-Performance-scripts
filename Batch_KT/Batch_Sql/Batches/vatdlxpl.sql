Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where program_name like '%vatdl%';
delete from rms.restart_bookmark where restart_name like '%vatdl%';
select * from rms.restart_program_status where program_name like '%vatdl%';
select * from rms.restart_bookmark where restart_name like '%vatdl%';

select * from all_Sequences where SEQUENCE_NAME like '%VAT%';

select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL 
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('btuhz613rkb8r','82n1zdf20smf4','dgby5w3h9mrpc') 
    and s.snap_id = SQL.snap_id
    and s.begin_interval_time> TO_date('12-oct-2020 12:00', 'dd-mon-yyyy hh24:mi')
    and s.begin_interval_time< TO_date('12-oct-2020 18:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;

select * from v$restore_point;

select * from period;
select * from vat_region;
select * from vat_codes;
select * from vat_code_rates where vat_CODE= 'SEGS';

select * from vat_item where vat_CODE= 'SEGS';

select * from vat_item where item in 
(select item from item_master where item ='100008785' or item_parent = '100008785') and vat_code = 'IEGS'
    order by ITEM, VAT_REGION, ACTIVE_DATE, VAT_TYPE, VAT_CODE, VAT_RATE;


--1032	SEGS	6092023 --6298447
select * from all_triggers where lower(table_name) like '%IVAT%';
select * from all_tables where lower(table_name) like 'vat_item'; --207512756

select count(1) from ITEM_MFQUEUE; --5860761
select count(1) from ITEM_MFQUEUE;

select count(1) from item_pub_info where PUBLISHED = 'N';


--1017	IEGS	6340544 / 6298447

select VAT_REGION, ACTIVE_DATE, VAT_CODE,VAT_RATE,count(1) from vat_item where VAT_CODE = 'IEGS' group by VAT_REGION, ACTIVE_DATE, VAT_CODE,VAT_RATE order by 1;
select VAT_REGION, VAT_CODE,count(1) from vat_item where VAT_CODE = 'IEGS' group by VAT_REGION, VAT_CODE order by 1;

select * from vat_code_rates where create_id ='PTUSER';
select count(1) from vat_item where trunc(ACTIVE_DATE) ='03-MAR-20';
select count(1) from ITEM_SUPP_COUNTRY_LOC where trunc(LAST_UPDATE_DATETIME) ='03-MAR-20';

SELECT p.vdate + 1,
             p.vdate,
             s.default_tax_type
        FROM period p,
             system_options s;


       SELECT vcr1.vat_code,
              TO_CHAR(vcr1.vat_rate),
              vcr1.active_date,
              vdate 
         FROM vat_code_rates vcr1,period
        WHERE vcr1.active_date = '03-MAR-2020' --vdate+1
          ORDER BY vcr1.vat_code;
     
     select * from vat_code_rates where create_id ='PTUSER';
     select * from vat_Codes;
        select distinct vi.VAT_CODE,vcr.VAT_RATE+3 as VAT_RATE from RMS.VAT_ITEM vi, rms.vat_code_rates vcr 
            where vi.VAT_CODE = vcr.VAT_CODE and vi.vat_CODE = 'IEGS'and rownum='1';


/*     
set serveroutput on;
set timing on;

declare
        l_vat_code     rms.vat_code_rates.vat_code%type:=null;
        l_vat_rate     rms.vat_code_rates.vat_rate%type:=null;
        l_active_date  rms.vat_code_rates.active_date%type;
        i number;
        
        
cursor c_vatcode is
        select distinct vi.VAT_CODE,vcr.VAT_RATE+3 as VAT_RATE from RMS.VAT_ITEM vi, rms.vat_code_rates vcr 
            where vi.VAT_CODE = vcr.VAT_CODE and vi.vat_CODE = 'IEGS'and rownum='1';

begin
 
    for i in c_vatcode loop
    
	select vdate+1 into l_active_date from rms.period;
	
    l_vat_code :=i.vat_code;
    l_vat_rate :=i.vat_rate;
    
 
  insert into rms.vat_code_rates(   vat_code    , 
                                    active_date , 
                                    vat_rate    , 
                                    create_date , 
                                    create_id   )
                values          (   l_vat_code,
                                    l_active_date,
                                    l_vat_rate,
                                    sysdate,
                                    'PTUSER');
                                    
 
 end loop;
	
exception
   when others then
      dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
      rollback;
	  
end;
/	