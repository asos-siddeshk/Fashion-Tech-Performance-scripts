DROP TABLE cust_tsf_upld;
create table cust_tsf_upld (item_id          varchar2(25),       
                            from_loc         number(10)  ,      
                            to_loc           number(10)  ,   
                            quantity         number(20,4),
                            error             varchar2(255));

select count(1) from cust_tsf_upld;
delete from int_asos.int_stg_man_tsf_upld ;

create table int_stg_man_tsf_upld_bk as
select * from int_asos.int_stg_man_tsf_upld;

delete from int_asos.int_stg_man_tsf_upld ;
insert into int_asos.int_stg_man_tsf_upld select * from int_stg_man_tsf_upld_bk;

select STATUS,THREAD_NO,count(1) from int_asos.int_stg_man_tsf_upld  group by STATUS,THREAD_NO;

select STATUS,THREAD_NO,count(1) from int_asos.int_stg_man_tsf_upld  group by STATUS,THREAD_NO;
select THREAD_NO,FILENAME,count(1) from int_asos.int_stg_man_tsf_upld where STATUS ='U' group by THREAD_NO,FILENAME;
select STATUS,FILENAME,count(1) from int_asos.int_stg_man_tsf_upld group by STATUS,FILENAME ;

select count(1) from cust_tsf_upld;
select FROM_LOC,count(1) from skumar.cust_tsf_upld group by FROM_LOC;
select * from cust_tsf_upld;

delete from skumar.cust_tsf_upld;


set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE       varchar2(255) := NULL;
  O_AVAILABLE           number(20,4) := NULL;
  l_ITEM                rms.item_loc.item%type;
  l_wh                 rms.item_loc.loc%type;
  l_LOC_TYPE            varchar2(1):= 'W';
  v_Return              BOOLEAN;

  CURSOR C_LOC IS
    SELECT wh  FROM WH where STOCKHOLDING_IND ='Y' and wh in ('1001','4001','3001','6001');

  CURSOR C_ITEMLOC (l_wh rms.wh.wh%type)IS
    SELECT item,loc FROM ITEM_LOC_soh WHERE LOC_TYPE ='W' and loc = l_wh and stock_on_hand>='150' and rownum<='20000';    

BEGIN

for k in C_LOC loop
    l_wh := k.wh;

for i in C_ITEMLOC (l_wh) loop
 l_item := i.item;
 
  v_Return := RMS.ITEMLOC_QUANTITY_SQL.GET_LOC_CURRENT_AVAIL(O_ERROR_MESSAGE => O_ERROR_MESSAGE,
                                O_AVAILABLE => O_AVAILABLE,
                                I_ITEM => l_ITEM,
                                I_LOC => l_wh,
                                I_LOC_TYPE => l_LOC_TYPE);
	IF (v_Return) THEN 
		insert into skumar.cust_tsf_upld (item_id,from_loc,to_loc,quantity) values (l_item,l_wh,null,O_AVAILABLE);
	ELSE
		continue;
    END IF;

	end loop;
	end loop;
commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cust_tsf_upld TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cust_tsf_upld TO SMOHAMMAD; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.iwtdispath TO SMOHAMMAD; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.VPT_LOGS TO SMOHAMMAD; 

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cust_tsf_upld TO rdatla; 


cust_tsf_upld




delete from cust_tsf_upld;

select * from cust_tsf_upld where from_LOC ='6001' and QUANTITY >='3' and rownum<=1000;
select * from cust_tsf_upld where from_LOC ='4001' and QUANTITY >='3' and rownum<=1000;
select THREAD_NO,FILENAME,count(1) from int_asos.int_stg_man_tsf_upld where STATUS ='U' group by THREAD_NO,FILENAME order by 1,2;


select * from INT_ASOS.int_stg_man_tsf_upld where trunc(PROCESS_DATETIME) ='11-JAN-24';

select * from INT_ASOS.int_stg_man_tsf_upld where  status ='S' and proce;
select * from INT_ASOS.int_stg_man_tsf_upld where thread_no ='2';
select * from INT_ASOS.int_stg_man_tsf_upld where thread_no ='1';

select STATUS, THREAD_NO,count(1) from INT_ASOS.int_stg_man_tsf_upld where trunc(PROCESS_DATETIME) ='12-JAN-24' group by STATUS, THREAD_NO;


select STATUS, THREAD_NO,count(1) from INT_ASOS.int_stg_man_tsf_upld --where trunc(PROCESS_DATETIME) =trunc(sysdate) 
group by STATUS, THREAD_NO;
delete from INT_ASOS.int_stg_man_tsf_upld where thread_no ='1' and status ='U' and rownum <='1300';
select * from rms.tsf_mfqueue;
select * from tsfhead order by 1 desc;


set serveroutput on;
set timing on;

declare

COUNTER         NUMBER(5)     := 0;
COUNTER_COMMIT  NUMBER(5)     := 0;
C_COMMIT  NUMBER(5)     := 0;
  
		l_int_seq_no	INT_ASOS.int_stg_man_tsf_upld.int_seq_no%type;			
		l_record_type  	INT_ASOS.int_stg_man_tsf_upld.record_type%type:='F';		
		l_filename     	INT_ASOS.int_stg_man_tsf_upld.filename%type:='File_name_';
		l_numer			number (10);
		l_item_id		INT_ASOS.int_stg_man_tsf_upld.item_id%type;			
		l_from_loc_type INT_ASOS.int_stg_man_tsf_upld.from_loc_type%type;			
		l_from_loc  	INT_ASOS.int_stg_man_tsf_upld.from_loc%type;			
		l_to_loc_type 	INT_ASOS.int_stg_man_tsf_upld.to_loc_type%type;		
		l_to_loc    	INT_ASOS.int_stg_man_tsf_upld.to_loc%type;			
		l_quantity   	INT_ASOS.int_stg_man_tsf_upld.quantity%type;			  
		l_status      	INT_ASOS.int_stg_man_tsf_upld.status%type;		
		l_error_message INT_ASOS.int_stg_man_tsf_upld.error_message%type;
        l_create_datetime INT_ASOS.int_stg_man_tsf_upld.create_datetime%type;


cursor c_tsf_upld  is
		select ITEM_ID,
			   FROM_LOC ,
			   '3001' as TO_LOC,
			   1 as QUANTITY 
		from skumar.cust_tsf_upld ctu where FROM_LOC ='1001' and QUANTITY >='3' and
				not exists (select 1 from INT_ASOS.int_stg_man_tsf_upld ismt where ismt.item_id= ctu.ITEM_ID) and rownum<=2000;


begin

select rms.INT_STG_MAN_TSF_UPLD_SEQ.nextval into l_int_seq_no from dual;

for r in c_tsf_upld loop 
	l_item_id		:=r.item_id         ;	
	l_from_loc  	:=r.from_loc        ;
	l_to_loc    	:=r.to_loc          ;
	l_quantity   	:=r.quantity        ;

insert into INT_ASOS.int_stg_man_tsf_upld ( int_seq_no			,
											record_type  		,
											filename     		, 
											create_datetime  	,
											item_id				,
											from_loc_type 		,
											from_loc  			,
											to_loc_type 		,
											to_loc    			,
											quantity   			,  
											status      		,
											process_datetime 	,
											error_message  ,thread_no  	)
				
			values      (l_int_seq_no,
						 l_record_type,
						 l_filename||l_int_seq_no,
						 sysdate,
						 l_item_id,
						 'W',
						 l_from_loc  ,
						 'W',
						 l_to_loc    ,
						 l_quantity  ,  
						 'U'   ,
						 sysdate 	,
						 l_error_message,
                         2);
     
     	c_COMMIT :=c_COMMIT + 1;
   IF MOD(c_COMMIT, 10) = 0 THEN
	select rms.INT_STG_MAN_TSF_UPLD_SEQ.nextval into l_int_seq_no from dual;
   END IF;
   
                         
	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
   IF MOD(COUNTER_COMMIT, 1) = 0 THEN
	COMMIT;
   END IF;
   
	end loop;	 
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/



  select * from int_asos.int_stg_man_tsf_upld 
     where status = 'U';

select * from int_asos.INT_BATCH_QUEUE;
delete from int_asos.INT_BATCH_QUEUE;

 

set serveroutput on;
set timing on;

declare
   
		l_int_seq_no	INT_ASOS.INT_BATCH_QUEUE.SEQ_NO%type;			
		l_filename     	INT_ASOS.INT_BATCH_QUEUE.EXT_REF_NO%type;

cursor c_tsf_upld  is
    select distinct FILENAME 
        from int_asos.int_stg_man_tsf_upld 
         where status = 'U';

begin

delete from int_asos.INT_BATCH_QUEUE;

for r in c_tsf_upld loop 
   l_filename := r.FILENAME;
   
insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) 
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_batch_man_tsf_ulpd','N',l_filename,'T','INT_ASOS',sysdate,'INT_ASOS',sysdate
    from dual;

end loop;	 
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/

--- Purge
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER            NUMBER(8)     := 0;
 l_date DATE;
 
BEGIN

for k in 0..3 loop    

select vdate-88 into l_date from rms.period;

insert into int_asos.int_stg_man_tsf_upld
select rms.INT_STG_MAN_TSF_UPLD_SEQ.nextval, RECORD_TYPE, 'FILE_RETEN', l_date-k, 
  ITEM_ID, FROM_LOC_TYPE, FROM_LOC, TO_LOC_TYPE, TO_LOC, QUANTITY, 'S', l_date-k, ERROR_MESSAGE, THREAD_NO
  from int_asos.int_stg_man_tsf_upld where CREATE_DATETIME like '29-OCT-18';

end loop;
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/
       
       
       
       