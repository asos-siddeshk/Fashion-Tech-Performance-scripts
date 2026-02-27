select * from rms.ITEM_MFQUEUE;
select count(1) from rms.ITEM_MFQUEUE;
select * from rpm_batch_control;
select * from RIB_MESSAGE_FAILURE;
update RIB_MESSAGE set MAX_ATTEMPTS = '6';
delete reclass_item where item in (select distinct item from ma_asos.ma_stg_item_buy_hier_reclass) ;
select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select distinct item from ma_asos.ma_stg_item_buy_hier_reclass) group by BUSINESS_MODEL;
select count(1) from reclass_item;
select EFFECTIVE_DATE,error_message,PROCESS_STATUS,count(1) from ma_asos.ma_stg_item_buy_hier_reclass group by EFFECTIVE_DATE,error_message,PROCESS_STATUS;
select count(1) from RPM_ITEM_MODIFICATION;
select count(1) from RPM_EvEnt_itEmloc; --2202491
select count(1) from RPM_ITEMLOC_THREAD;

select * from reclass_error_log;
select * from ma_asos.ma_stg_item_buy_hier_reclass;


select count(1) from ma_asos.ma_item_attributes where trunc(LAST_UPDATE_DATETIME)> ='19-FEB-21';

SELECT COUNT(1)
        FROM 
             reclass_item ri,
             reclass_head rh,
             item_master im,
             deps   d1,
             groups g1,
             deps   d2,
             groups g2
       WHERE rh.reclass_no   = ri.reclass_no
         AND rh.reclass_date <=NVL(TO_DATE('20210509', 'YYYYMMDD'), rh.reclass_date)
         AND (ri.item = im.item
               OR ri.item = im.item_parent
               OR ri.item = im.item_grandparent)
         AND d1.dept     = rh.to_dept
         AND d1.group_no = g1.group_no
         AND d2.dept     = im.dept
         AND d2.group_no = g2.group_no;
			
select RECLASS_no,count(1) from reclass_head group by RECLASS_no;   
select * from rms.reclass_head;
select * from rms.reclass_item;
delete from reclass_head where reclass_no in (select reclass_no from del_recls);



select RECLASS_DATE,count(1) from reclass_head group by RECLASS_DATE;   
Update reclass_head set RECLASS_DATE ='20-JAN-19';
            
select count(1) from RPM_ITEM_MODIFICATION;
delete from reclass_item where rownum <= '8272'; 
delete from MC_REJECTIONS;
select * from MC_REJECTIONS;


create table del_recls as
select * from reclass_head ;
delete from reclass_item where reclass_no in (select reclass_no from del_recls);
delete from reclass_head where reclass_no in (select reclass_no from del_recls);
drop table del_recls;
delete from RPM_ITEM_MODIFICATION; 
commit;


/*

delete from RECLASS_HEAD where reclass_no not in (select reclass_no from RECLASS_ITEM);
delete from RECLASS_ITEM where reclass_no in (select reclass_no from RECLASS_HEAD where RECLASS_DESC not like 'Reclass_For_Dept%');
delete from RECLASS_HEAD where RECLASS_DESC not like 'Reclass_For_Dept%';

select * from reclass_head;
select reclass_no,count(reclass_no) from reclass_item group by reclass_no order by 1 desc;
select count(1) from reclass_item;
RPM_ITEM_MODIFICATION
select count(1) from reclass_item where reclass_no between 410 and 582;
delete from reclass_item where reclass_no in (5153,5151,5148,5145,5144,5143,5141,5138,5134,5133,5132,5131,5130,5129,5128,5126,5125,5119);
delete from reclass_head where reclass_no in (5153,5151,5148,5145,5144,5143,5141,5138,5134,5133,5132,5131,5130,5129,5128,5126,5125,5119);
select * from RECLASS_HEAD where reclass_no not in (select reclass_no from RECLASS_ITEM);

select * from RECLASS_HEAD;
select * from RECLASS_ITEM;
delete from RECLASS_ITEM;
delete from RECLASS_HEAD;

select * from restart_program_status where program_name like 'reclsdly';

Insert into restart_program_status  values ('reclsdly',17,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',18,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',19,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',20,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',21,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',22,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',23,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',24,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',25,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',26,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',27,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',28,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',29,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',30,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',31,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);
Insert into restart_program_status  values ('reclsdly',32,to_date('21-NOV-18','DD-MON-RR'),'reclsdly','ready for start',null,null,to_date('21-NOV-18','DD-MON-RR'),null,null,null,null,null);

select * from restart_control where program_name like 'reclsdly';
select * from restart_program_status where program_name like 'reclsdly';

Update restart_control set NUM_THREADS ='32' where program_name like 'reclsdly';
*/


select * from reclass_head order by 1 desc;

select reclass_no,count(reclass_no) from reclass_item group by reclass_no order by 1 desc;

select count(1) from reclass_item where reclass_no in (select reclass_no from reclass_head where RECLASS_DATE >= '09-MAY-21');
select count(1) from reclass_head where RECLASS_DATE >= '09-MAY-21';

select count(1) from reclass_item;

select * from reclass_head ;

select rms.RECLASS_NO_SEQUENCE.nextval  from dual;

select count(1) from reclass_item;




set serveroutput on;
set timing on;

declare
        l_reclass_no   number(4)        :=NULL; 
		l_reclass_desc varchar2(120)    :='Reclass_For_Dept_'; 
		l_reclass_date  date        ;
		L_DEPT          number(4)       :=NULL; 
        L_class         number(4)       :=NULL; 
        L_subclass      number(4)       :=NULL; 
        l_to_dept       number(4)       :=NULL;
		l_to_class      number(4)       :=NULL; 
		l_to_subclass   number(4)       :=NULL;
		l_item 		    varchar2(25)    :=NULL;
        i number;
        
 CURSOR cur_dept IS 	
	select dept from (
	   select distinct dept,count(dept) from item_master_op where 
		(dept!='9999' or class!='9999' or subclass!='9999') and status ='A' and item_level ='1' and tran_level ='2'
        --and dept not in (select to_dept from RECLASS_HEAD)
		group by dept having (count(dept) > 50)) ; --where rownum <= '20';
        
cursor c_reclass (l_dept rms.subclass.dept%type) is
   		select to_dept,to_class,to_subclass from (
          with new_class as (select dept,class,subclass from rms.subclass where dept =l_dept  and class!='9999' and subclass!='9999' 
                                and rownum <='2')
            select         new_class.dept as to_dept,
                           new_class.class as to_class,
                           new_class.subclass as to_subclass
            from rms.item_master im, rms.period p, new_class
            where im.dept =l_dept
            and im.item_level < im.tran_level 
            and new_class.dept =im.dept
            and new_class.class=im.class
            and new_class.subclass=im.subclass 
            ) where rownum<='1';

cursor c_reclass_item (l_dept rms.subclass.dept%type,L_class rms.subclass.class%type,L_subclass rms.subclass.subclass%type) is
   		select item from (
           select     distinct im.item_parent as item
            from rms.item_master im
            where  im.item_level = '2'
            and im.dept =l_dept
            and im.class!= L_class
            and im.subclass!=L_subclass
            and im.status ='A'
            and not exists (select 1 from rms.reclass_item ri where (ri.item =im.item_parent or ri.item =im.item)) 
            ) where rownum<= 50;
            
begin

for l in 0..4 loop

 for k in cur_dept loop

     l_dept := k.dept;
 
     FOR i in c_reclass(l_dept) Loop
     
        select rms.RECLASS_NO_SEQUENCE.nextval into l_reclass_no from dual;
        select l_reclass_desc||l_dept into l_reclass_desc from dual;
        select vdate into l_reclass_date from rms.period;

		l_to_dept       :=i.to_dept;
		l_to_class      :=i.to_class;
		l_to_subclass   :=i.to_subclass; 
        

     
	insert into  rms.RECLASS_HEAD(reclass_no   , 
								reclass_desc , 
								reclass_date , 
								to_dept      , 
								to_class     , 
								to_subclass  )
								 
	values          (l_reclass_no,
					 l_reclass_desc,
					 l_reclass_date,
					 l_to_dept,
					 l_to_class,
					 l_to_subclass);	
    
            
    for j in c_reclass_item (l_to_dept,l_to_class,l_to_subclass) loop
        
    EXIT WHEN c_reclass_item%NOTFOUND IS NULL;
            l_item 		    :=j.item;
    
    insert into  rms.RECLASS_ITEM( reclass_no,
								 item)
								 
	values          (l_reclass_no,
					 l_item);
   end loop;
   
  l_reclass_desc := 'Reclass_For_Dept_';
  end loop;
    end loop;
 commit;
 end loop;
     
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
	  
end;
/




create table reclass_ord_rec as
select item from item_master where item in (select OPTION_ID from ma_asos.ma_order_rec_head_stg) 
    and dept = '1006' and rownum <= '1000';
    
    
select * from item_master where item = '100007380';



select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select distinct item from RECLASS_item) group by BUSINESS_MODEL;
select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select distinct item from ma_asos.ma_stg_item_buy_hier_reclass) 
   and BUSINESS_MODEL='2' and BUYING_GROUP='150' and BUYING_SUBGROUP='6' and BUYING_SET='4'
group by BUSINESS_MODEL;

select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select item from item_master where item_parent in  (select distinct item from  ITEM_BUY_P_RECLASS))
    group by BUSINESS_MODEL;

select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select distinct item from  ma_asos.ma_stg_item_buy_hier_reclass)
    group by BUSINESS_MODEL;

select count(1),BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET from ma_asos.ma_item_attributes where item in (select item from item_master 
 where item in  (select distinct item from  ma_asos.ma_stg_item_buy_hier_reclass))
     group by BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET
     order by BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET;

select EFFECTIVE_DATE,BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET,PROCESS_STATUS,count(1) 
 from ma_asos.ma_stg_item_buy_hier_reclass group by EFFECTIVE_DATE,BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET,PROCESS_STATUS;

select BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET,count(1) from ma_asos.ma_item_attributes where 
 item in ('103643514')
 and  BUSINESS_MODEL='2' and BUYING_GROUP='150' GROUP BY BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET;




set serveroutput on;
set timing on;
declare
	l_process_seq        ma_asos.ma_stg_item_buy_hier_reclass.process_seq%type;  
	l_item               ma_asos.ma_stg_item_buy_hier_reclass.item%type;  
	l_status             ma_asos.ma_stg_item_buy_hier_reclass.status%type 			:='A';              
	l_new_brand_name     ma_asos.ma_stg_item_buy_hier_reclass.new_brand_name%type	:='7X';   
	l_business_model	 ma_asos.ma_stg_item_buy_hier_reclass.business_model%type	:='2';
	l_buying_group		 ma_asos.ma_stg_item_buy_hier_reclass.buying_group%type		:='150';
	l_buying_subgroup	 ma_asos.ma_stg_item_buy_hier_reclass.buying_subgroup%type	:='6';
	l_buying_set		 ma_asos.ma_stg_item_buy_hier_reclass.buying_set%type		:='4';
    L_EFFECTIVE_DATE     ma_asos.ma_stg_item_buy_hier_reclass.EFFECTIVE_DATE%type;
		   
cursor c_buy_reclass is
     select IM.ITEM,p.vdate+1 as effective_date
        from item_master_op im, rms.period p 
        where  not exists (Select 1 from ma_asos.ma_stg_item_buy_hier_reclass r where r.item=im.item and PROCESS_STATUS= 'N')
               and not exists (Select 1 from RECLASS_item rr where rr.item=im.item ) AND rownum <= '40000';
	
begin  
for i in c_buy_reclass loop 
	l_item:= i.item;
	l_effective_date     := i.effective_date;

	 select ma_asos.MA_PROCESS_ID_SEQ.nextval into l_process_seq from dual;
    
   insert into ma_asos.ma_stg_item_buy_hier_reclass(process_seq          , 
													item                 , 
													status               , 
													business_model       , 
													buying_group         , 
													buying_subgroup      , 
													buying_set           , 
													effective_date       , 
													new_brand_name       ,
                                                    process_status,
													create_datetime      , 
													last_update_datetime , 
													create_id            , 
													last_update_id )
                            values					(l_process_seq,
                                                     l_item,
                                                     l_status,
                                                     l_business_model,
                                                     l_buying_group,
                                                     l_buying_subgroup,
                                                     l_buying_set,
                                                     l_effective_date,
                                                     l_new_brand_name,
                                                     'N',
                                                     sysdate,
                                                     sysdate,
                                                     'PTUSER',
                                                     'PTUSER' );
    	end loop;
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


select*
     from rms_plsql_batch_config
    where program_name like ('%BUY%');
MA_ITEM_BATCH_PROCESSES_SQL.NB_BUYRARCHY_RECLASS


    select *
      from brand;