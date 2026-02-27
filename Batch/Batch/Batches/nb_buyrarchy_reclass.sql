select * from ma_asos.ma_stg_item_buy_hier_reclass where CREATE_ID like 'Heather.Curtis';
select * from rms.item_master;
select item from rms.item_master where status ='A' 
        and item_level ='1' 
        and BRAND_NAME = 'NEW LOOK' 
        and  rownum<= '5000' orDEr by 1 DESC;

select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select distinct item from ITEM_BUY_P_RECLASS) group by BUSINESS_MODEL;
select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select item from item_master where item_parent in  (select distinct item from  ITEM_BUY_P_RECLASS))
    group by BUSINESS_MODEL;
select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select item from item_master where item in  (select distinct item from  ITEM_BUY_P_RECLASS))
    group by BUSINESS_MODEL;
    
select EFFECTIVE_DATE,error_message,PROCESS_STATUS,count(1) from ma_asos.ma_stg_item_buy_hier_reclass --where trunc(CREATE_DATETIME) = '18-DEC-20' 
    group by EFFECTIVE_DATE,error_message,PROCESS_STATUS;

select count(1) from item_mfqueue;
select * from item_mfqueue;
truncate table ITEM_BUY_P_RECLASS;
select * from ITEM_BUY_P_RECLASS;
delete from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N' AND rownum <= '4300';
select * from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N' AND rownum <= '4300';


delete from ma_asos.ma_stg_item_buy_hier_reclass;

select * from ma_asos.ma_item_attributes where item ='100241984'; --3	199	24	74


set serveroutput on;
set timing on;
declare
	l_process_seq        ma_asos.ma_stg_item_buy_hier_reclass.process_seq%type;  
	l_item               ma_asos.ma_stg_item_buy_hier_reclass.item%type;  
	l_status             ma_asos.ma_stg_item_buy_hier_reclass.status%type 			:='A';              
	l_new_brand_name     ma_asos.ma_stg_item_buy_hier_reclass.new_brand_name%type	:='TRANSFER';   
	l_business_model	 ma_asos.ma_stg_item_buy_hier_reclass.business_model%type	;
	l_buying_group		 ma_asos.ma_stg_item_buy_hier_reclass.buying_group%type		;
	l_buying_subgroup	 ma_asos.ma_stg_item_buy_hier_reclass.buying_subgroup%type	;
	l_buying_set		 ma_asos.ma_stg_item_buy_hier_reclass.buying_set%type		;
    L_EFFECTIVE_DATE     ma_asos.ma_stg_item_buy_hier_reclass.EFFECTIVE_DATE%type;
		   
cursor c_buy_reclass is
     select IM.ITEM,p.vdate+1 as effective_date,im.BUSINESS_MODEL, im.BUYING_GROUP, im.BUYING_SUBGROUP, im.BUYING_SET
        from ITEM_BUY_P_RECLASS im, rms.period p 
        where  not exists (Select 1 from ma_asos.ma_stg_item_buy_hier_reclass r where r.item=im.item and PROCESS_STATUS= 'N');
        --and rownum<=1;
	
begin  
for i in c_buy_reclass loop 
	l_item:= i.item;
	l_effective_date     := i.effective_date;
	l_business_model	 := i.BUSINESS_MODEL ;
	l_buying_group		 := i.BUYING_GROUP ;
	l_buying_subgroup	 := i.BUYING_SUBGROUP ;
	l_buying_set		 := i.BUYING_SET ;
    
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


select distinct BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET from ma_asos.MA_V_BUYING_SET ;
select * from ma_asos.MA_V_BUYERARCHY where item = '105697557';
MA_V_BUYING_GROUP
MA_V_BUYING_SUBGROUP
MA_V_BUYING_SET

select item_level,count(1) from item_master where item_level = tran_level and item in (
select distinct item from rms.uda_item_ff where
(LAST_UPDATE_DATETIME  between to_date('15-JUL-2020 11:40', 'DD-MON-YYYY hh24:mi')
    AND  to_date('15-JUL-2020 12:50', 'DD-MON-YYYY hh24:mi'))
and UDA_ID  in ('2010')) group by item_level;


select item_level,count(1) from item_master where item in (
select item from ma_asos.ma_item_attributes where
LAST_UPDATE_DATETIME between to_date('15-JUL-2020 11:40', 'DD-MON-YYYY hh24:mi') 
    AND  to_date('15-JUL-2020 11:50', 'DD-MON-YYYY hh24:mi')) group by item_level;

select item.item,uda.UDA_ID,uda.UDA_TEXT,uda.LAST_UPDATE_DATETIME from rms.uda_item_ff uda, rms.item_master item
where item.item=uda.item and item.item_level=item.tran_level 
and uda.UDA_ID = '2010' and (uda.LAST_UPDATE_DATETIME between to_date('15-JUL-2020 11:40', 'DD-MON-YYYY hh24:mi') 
    AND  to_date('15-JUL-2020 11:50', 'DD-MON-YYYY hh24:mi')) order by item.item;
    
    
    
/*
---------------------------Batch name:RMS.NB_BUYRARCHY_RECLASS----------------------------------
1.Custom table																:SKUMAR.cust_buy_hier_reclass.
2.Bulk inserted the records to the custom table								:SKUMAR.cust_buy_hier_reclass(Transaction volume:*** records)
3.PL/SQL script execution that will insert the records to the staging table :ma_asos.ma_stg_item_buy_hier_reclass
4.Batch execution 															:RMS.NB_BUYRARCHY_RECLASS via Automic.
5.inserted 2 records with status='a' and prcess_status='n'
after exceution process_status='p'..
------------------------------------------------------------------------------------------------
create table buy_rec as select * from ma_asos.ma_stg_item_buy_hier_reclass;

delete from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N';
select * from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N';
select distinct item from ma_asos.ma_stg_item_buy_hier_reclass;



SELECT im.brand,IM.ITEM, CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION' WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM, im.DIVISION,dn.DIV_NAME,im.GROUP_NO, g.GROUP_NAME, IM.DEPT PRODUCT_GROUP,d.dept_name  PRODUCT_GROUP_DESC,IM.CLASS "CATEGORY",c.class_name CATEGORY_NAME, IM.SUBCLASS SUB_CATEGORY, s.sub_name SUB_CATEGORY_NAME,IM.BRAND_NAME BRAND, IM.ITEM_DESC ITEM_DESCRIPTION,IM.SHORT_DESC SHORT_DESCRIPTION, IM.DIFF_1 COLOUR,IM.DIFF_2 SIZE_GROUP,UDA_ATTRIB.SUPER_STYLE,        UDA_ATTRIB.STYLE,UDA_ATTRIB.BUSINESS_MODEL,UDA_ATTRIB.BUYING_GROUP,        UDA_ATTRIB.BUYING_SUBGROUP,UDA_ATTRIB.BUYING_SET
  FROM v_ITEM_MASTER IM,
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = 1002 THEN UDA_TEXT END) SUPER_STYLE,
               MAX(CASE WHEN UDA_ID = 1003 THEN UDA_TEXT END) STYLE,
               MAX(CASE WHEN UDA_ID = 2010 THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = 2020 THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = 2030 THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = 2040 THEN UDA_TEXT END) BUYING_SET
         FROM (SELECT ITEM,UDA_ID,
                      UDA_TEXT 
                 FROM UDA_ITEM_FF 
                WHERE UDA_ID IN (2010,2020,2030,2040,1002,1003))
             GROUP BY ITEM) UDA_ATTRIB,
        deps d,
         class c,
         subclass s,
         groups g,
         division dn
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
    and im.division = dn.division
    and im.division = g.division
    and im.GROUP_NO = g.GROUP_NO
    and d.GROUP_NO = g.GROUP_NO
    and im.dept=d.dept
    and d.dept =c.dept
    and d.dept =S.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=S.class
    and im.item ='100025793'
  ORDER BY DIVISION, GROUP_NO, PRODUCT_GROUP, CATEGORY, SUB_CATEGORY,TYPE_OF_ITEM;   


select * from rms.brand;


*/

select count(1) from item_master where item in (select item from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N')
    or item_parent in (select item from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N');


select * from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N';
delete from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N';


select EFFECTIVE_DATE,error_message,PROCESS_STATUS,count(1) from ma_asos.ma_stg_item_buy_hier_reclass where trunc(CREATE_DATETIME) = '16-DEC-20' 
    group by EFFECTIVE_DATE,error_message,PROCESS_STATUS;


select EFFECTIVE_DATE,PROCESS_STATUS,count(1) from ma_asos.ma_stg_item_buy_hier_reclass where trunc(CREATE_DATETIME) = '16-DEC-20' 
    group by EFFECTIVE_DATE,PROCESS_STATUS;

select * from ma_asos.ma_stg_item_buy_hier_reclass where trunc(CREATE_DATETIME) = '11-JUN-20';
    group by EFFECTIVE_DATE,error_message,PROCESS_STATUS;
select count(1) from item_mfqueue;


select * from ma_asos.ma_stg_item_buy_hier_reclass where trunc(CREATE_DATETIME) = trunc(sysdate);

select * from BRAND where BRAND_NAME like 'ASOS%';
select * from ITEM_MASTER_op;
select * from ma_asos.MA_V_BUYERARCHY where business_model = '3';
select * from ma_asos.MA_V_hierarchy where business_model = '1';
select * from ma_asos.MA_item_attributes where business_model = '1';

 --1	122	1	1
 --4    219 1   1
 --2	180	1	35
 --3	199	24	73
 

set serveroutput on;
set timing on;

declare
	l_process_seq        ma_asos.ma_stg_item_buy_hier_reclass.process_seq%type;  
	l_item               ma_asos.ma_stg_item_buy_hier_reclass.item%type;  
	l_status             ma_asos.ma_stg_item_buy_hier_reclass.status%type 			:='A';              
	l_new_brand_name     ma_asos.ma_stg_item_buy_hier_reclass.new_brand_name%type	:='ASOS';   
	l_business_model	 ma_asos.ma_stg_item_buy_hier_reclass.business_model%type	:=1;
	l_buying_group		 ma_asos.ma_stg_item_buy_hier_reclass.buying_group%type		:=102;
	l_buying_subgroup	 ma_asos.ma_stg_item_buy_hier_reclass.buying_subgroup%type	:=1;
	l_buying_set		 ma_asos.ma_stg_item_buy_hier_reclass.buying_set%type		:=6;
    L_EFFECTIVE_DATE     ma_asos.ma_stg_item_buy_hier_reclass.EFFECTIVE_DATE%type;
		   
cursor c_buy_reclass is

	SELECT  IM.ITEM,
            p.vdate+1 as effective_date
	  FROM ITEM_MASTER_op IM, rms.period p,
		   (SELECT ITEM,
				   MAX(CASE WHEN UDA_ID = '2010' THEN UDA_TEXT END) BUSINESS_MODEL,
				   MAX(CASE WHEN UDA_ID = '2020' THEN UDA_TEXT END) BUYING_GROUP,
				   MAX(CASE WHEN UDA_ID = '2030' THEN UDA_TEXT END) BUYING_SUBGROUP,
				   MAX(CASE WHEN UDA_ID = '2040' THEN UDA_TEXT END) BUYING_SET
			 FROM (SELECT ITEM,UDA_ID,
						  UDA_TEXT 
					 FROM rms.UDA_ITEM_FF 
					WHERE UDA_ID IN ('2010','2020','2030','2040'))
				 GROUP BY ITEM) UDA_ATTRIB
	  WHERE IM.ITEM = UDA_ATTRIB.ITEM
		and UDA_ATTRIB.BUYING_SET       != l_buying_set
		and UDA_ATTRIB.BUYING_SUBGROUP  != l_buying_subgroup
		and UDA_ATTRIB.BUYING_GROUP     != l_buying_group
		and UDA_ATTRIB.BUSINESS_MODEL   != l_business_model
		--and IM.brand_name		        !='AMERICAN A' 
        and not exists (Select 1 from ma_asos.ma_stg_item_buy_hier_reclass r where r.item=im.item)
        and rownum <= 1000;

begin
  
for i in c_buy_reclass loop 

	
	l_item:= i.item;
	l_effective_date:= i.effective_date;
	
        select ma_asos.MA_PROCESS_ID_SEQ.nextval 
                into l_process_seq from dual;
    
    
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
                                                     'PTUSER'
                                                     );
		end loop;
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


 



---------------------------

select * from all_tables where table_name like '%BUYRAR%'; and owner like 'SKUMAR';

ITEM_BUY
ITEM_BUYGROUP
ITEM_BUY_P

drop table  ITEM_BUY_P;
create table ITEM_BUY_P as 
select distinct item_parent from item_master where item in (select distinct item from ordloc where order_no in (select order_no from ordhead where status ='A'));
    
select BUSINESS_MODEL,count(1) from ITEM_BUY_P_RECLASS group by BUSINESS_MODEL;

drop table ITEM_BUY_P_reclass;
create table ITEM_BUY_P_reclass as
SELECT  p.vdate+1 as effective_date, UDA_ATTRIB.*,im.BRAND_NAME
	  FROM rms.ITEM_MASTER IM, rms.period p,
		   (SELECT ITEM,
				   MAX(CASE WHEN UDA_ID = '2010' THEN UDA_TEXT END) BUSINESS_MODEL,
				   MAX(CASE WHEN UDA_ID = '2020' THEN UDA_TEXT END) BUYING_GROUP,
				   MAX(CASE WHEN UDA_ID = '2030' THEN UDA_TEXT END) BUYING_SUBGROUP,
				   MAX(CASE WHEN UDA_ID = '2040' THEN UDA_TEXT END) BUYING_SET
			 FROM (SELECT ITEM,UDA_ID,
						  UDA_TEXT 
					 FROM rms.UDA_ITEM_FF 
					WHERE UDA_ID IN ('2010','2020','2030','2040'))
				 GROUP BY ITEM) UDA_ATTRIB,
                 ITEM_BUY_P ib
	  WHERE IM.ITEM = UDA_ATTRIB.ITEM
         and im.item = ib.item_parent\
        and not exists (Select 1 from ma_asos.ma_stg_item_buy_hier_reclass r where r.item=im.item);
        
select BUSINESS_MODEL,count(1) from ITEM_BUY_P_RECLASS group by BUSINESS_MODEL;  

delete from ma_asos.ma_stg_item_buy_hier_reclass where EFFECTIVE_DATE ='28-JAN-19';
select * from ma_asos.ma_stg_item_buy_hier_reclass where EFFECTIVE_DATE ='28-JAN-19' ;

select * from brand where BRAND_NAME ='TRANSFER';
Insert into brand  values ('TRANSFER','TRANSFER',to_date('11-JUN-18','DD-MON-RR'),to_date('11-JUN-18','DD-MON-RR'),'ORACNV','ORACNV');

select * from ma_asos.ma_item_attributes where item = '100164636'; business_model = '8'; --6	298	19	542



select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes where item in (select distinct item from  ITEM_BUY_P_RECLASS) group by BUSINESS_MODEL order by BUSINESS_MODEL;
select count(1),BUSINESS_MODEL from ma_asos.ma_stg_item_buy_hier_reclass group by BUSINESS_MODEL;
select count(1),PROCESS_STATUS from ma_asos.ma_stg_item_buy_hier_reclass group by PROCESS_STATUS;

truncate table ITEM_BUY_P_RECLASS;
drop table ITEM_BUY_P_RECLASS;
select  *from ITEM_BUY_P_RECLASS;

create table ITEM_BUY_P_RECLASS (item varchar2(25),BUSINESS_MODEL  NUMBER(4), 
BUYING_GROUP    NUMBER(4), 
BUYING_SUBGROUP NUMBER(4),
BUYING_SET      NUMBER(4) 
);

drop table unique_buyrarchy;
create table unique_buyrarchy as
select distinct BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET from ma_asos.MA_V_BUYING_SET ;

desc unique_buyrarchy;

select count(1),BUSINESS_MODEL from ma_asos.ma_item_attributes 
    where item in (select item from item_master where item_parent in (select distinct item from  ma_asos.ma_stg_item_buy_hier_reclass))
    group by BUSINESS_MODEL;
    
select EFFECTIVE_DATE,error_message,PROCESS_STATUS,count(1) from ma_asos.ma_stg_item_buy_hier_reclass where trunc(CREATE_DATETIME) = '18-DEC-20' 
    group by EFFECTIVE_DATE,error_message,PROCESS_STATUS;

select count(1) from item_mfqueue;
select * from item_mfqueue;
delete from ma_asos.ma_stg_item_buy_hier_reclass;
select * from ma_asos.ma_stg_item_buy_hier_reclass;



set serveroutput on;
set timing on;
declare
	l_process_seq        ma_asos.ma_stg_item_buy_hier_reclass.process_seq%type;  
	l_item               ma_asos.ma_stg_item_buy_hier_reclass.item%type;  
	l_status             ma_asos.ma_stg_item_buy_hier_reclass.status%type 			:='A';              
	l_new_brand_name     ma_asos.ma_stg_item_buy_hier_reclass.new_brand_name%type	:='TRANSFER';   
	l_business_model	 ma_asos.ma_stg_item_buy_hier_reclass.business_model%type	;
	l_buying_group		 ma_asos.ma_stg_item_buy_hier_reclass.buying_group%type		;
	l_buying_subgroup	 ma_asos.ma_stg_item_buy_hier_reclass.buying_subgroup%type	;
	l_buying_set		 ma_asos.ma_stg_item_buy_hier_reclass.buying_set%type		;
    L_EFFECTIVE_DATE     ma_asos.ma_stg_item_buy_hier_reclass.EFFECTIVE_DATE%type;
		   
cursor c_buy_reclass is
	 
     select IM.ITEM,p.vdate+1 as effective_date,im.BUSINESS_MODEL, im.BUYING_GROUP, im.BUYING_SUBGROUP, im.BUYING_SET
        from ITEM_BUY_P_RECLASS im, rms.period p 
        where  not exists (Select 1 from ma_asos.ma_stg_item_buy_hier_reclass r where r.item=im.item and PROCESS_STATUS= 'N');
        --and rownum<=1;
	
begin  
for i in c_buy_reclass loop 
	l_item:= i.item;
	l_effective_date     := i.effective_date;
	l_business_model	 := i.BUSINESS_MODEL ;
	l_buying_group		 := i.BUYING_GROUP ;
	l_buying_subgroup	 := i.BUYING_SUBGROUP ;
	l_buying_set		 := i.BUYING_SET ;
    
	
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
    	
--       delete from ITEM_BUY_P_RECLASS where item = l_item;
       
        end loop;
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


select COUNT(1) from ma_asos.ma_stg_item_buy_hier_reclass where PROCESS_STATUS = 'N';

insert into ma_asos.ma_stg_item_buy_hier_reclass
    select ma_asos.MA_PROCESS_ID_SEQ.nextval,item, 'A','3','199','26','3','02-MAR-20','TRANSFER','N','04-JUN-20','04-JUN-20','PTUSER','PTUSER',null
        from reclass_ord_rec;

select * from ma_asos.ma_item_attributes where item = '100007380';

create table reclass_ord_rec as select item from item_master where item in (select OPTION_ID from ma_asos.ma_order_rec_head_stg)  and dept = '1006' and rownum <= '1000';
    select * from item_master where item = '100007380';
    select * from period;

insert into  rms.RECLASS_HEAD(reclass_no   , reclass_desc , reclass_date , to_dept      , to_class     , to_subclass  )
	values ('1','order_rec','01-MAR-20',1050,1,1);	

insert into RECLASS_item select 1,item from reclass_ord_rec;