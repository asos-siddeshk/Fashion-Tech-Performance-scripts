-- for intra day batch
drop table ma_ship_rest_rule_mfqueue_bk;
create table ma_ship_rest_rule_mfqueue_bk as
select * from ma_asos.ma_ship_rest_rule_mfqueue;
insert into ma_asos.ma_ship_rest_rule_mfqueue select * from ma_ship_rest_rule_mfqueue_bk;
delete from ma_asos.ma_ship_rest_rule_mfqueue;


select * from  ma_asos.MA_SHIP_REST_RULE where BRAND_NAME is not null;
select * from  ma_asos.MA_SHIP_REST_GROUP_DETAIL where REST_GROUP_ID ='468';
select * from  ma_asos.MA_SHIP_REST_GROUP_HEAD where REST_GROUP_ID ='468';
select * from  ma_asos.MA_SHIP_REST_RULE where GROUP_ID ='468';
select * from  ma_asos.MA_SHIP_REST_RULE where rule_id >='550324';

select * from ma_asos.ma_ship_rest_rule_mfqueue; 
select * from ma_asos.MA_ITEM_RESTRICTIONS where RULE_ID > '550324';

select  RULE_ID, RULE_DESC, SUPPLIER, DIVISION, BRAND_NAME,count(1) 
    from ma_asos.MA_ITEM_RESTRICTIONS where RULE_ID > '490044'
    group by RULE_ID, RULE_DESC, SUPPLIER, DIVISION, BRAND_NAME;

select * from ma_asos.MA_ITEM_RESTRICTIONS where item = '100286853';

-- 10k Options
Supplier Site: 1100000946 - New Look Retailers Ltd
Brand: 'NEW LOOK'
division = '1'
Country  = Germany
select supplier, count(1) from item_supplier where item in (select item from NEWLOOK_1) AND PRIMARY_SUPP_IND= 'Y' group by supplier;
create table NEWLOOK_1 as
select * from v_item_master where brand_name like 'NEW LOOK' and item_level = '1' and division = '1';
select * from sups where supplier = '1100000304';

--1.3k Options
Supplier Site: 1100000304 - Calvin Klein Europe B.V.
Brand: 'CALVIN KLE'
division = '1'
Country  = Germany

select * from sups where supplier = '1100000304';
create table CALVIN_1 as select * from v_item_master where brand_name like 'CALVIN KLE' and item_level = '1' and division = '1';
select supplier, count(1) from item_supplier where item in (select item from CALVIN_1) group by supplier;
select * from item_supplier where item in (select item from CALVIN_1);


select  * from brand where BRAND_NAME like 'CAL%%';


select im.brand_name,im.division,iv.DIV_NAME,iss.supplier,s.SUP_NAME,count(1) from 
    v_item_master im,item_supplier iss,division iv, sups s where iss.supplier = s.supplier and iss.supplier!= '1100000086'
      AND  im.division= iv.division AND (im.brand_name not like '%ASOS%' or im.brand_name not like '%ASOS%')
      and im.item_level = '1' and im.item = iss.item and im.status = 'A' 
    AND PRIMARY_SUPP_IND= 'Y' 
    AND SUP_STATUS= 'A' 
    group by im.brand_name,im.division,iv.DIV_NAME,iss.supplier,s.SUP_NAME;
    
select im.brand_name,im.division,iv.DIV_NAME,iss.supplier,s.SUP_NAME,count(1) from 
    v_item_master im,item_supplier iss,division iv, sups s where iss.supplier = s.supplier and iss.supplier!= '1100000086'
      AND  im.division= iv.division AND im.brand_name not like '%ASOS%' 
      and im.item_level = '1' and im.item = iss.item and im.status = 'A' 
    AND PRIMARY_SUPP_IND= 'Y' 
    AND SUP_STATUS= 'A' 
    group by im.brand_name,im.division,iv.DIV_NAME,iss.supplier,s.SUP_NAME order by count(1) desc;

select * from sups;


select * from  ma_asos.ma_ship_rest_rule_mfqueue;

select count(1) from ma_asos.ma_ship_rest_rule_mfqueue; --shiprestadd
select * from ma_asos.ma_ship_rest_rule_mfqueue; --shiprestadd
select trunc(CREATE_DATETIME),count(1) from ma_asos.ma_item_restrictions group by trunc(CREATE_DATETIME ) order by 1 desc ; --2193925
select distinct RULE_ID from ma_asos.ma_item_restrictions where trunc(CREATE_DATETIME) = '25-FEB-19'; --2193925
Update ma_asos.ma_item_restrictions set CREATE_DATETIME ='24-FEB-19' where trunc(CREATE_DATETIME) = '19-FEB-19' and rownum <='54621';

delete from ma_asos.ma_item_restrictions where trunc(CREATE_DATETIME) = '26-FEB-19';

select * from ma_asos.ma_ship_rest_rule_mfqueue;

   insert into ma_asos.ma_ship_rest_rule_mfqueue
  select ma_asos.MA_SHIP_REST_RULE_MFSEQUENCE.nextval,
		 RULE_ID,
         substr('shiprestmod',1,15),
		 'U',
		 sysdate
  from ma_asos.ma_ship_rest_rule 
   where  rownum<=400;
  


truncate table ma_asos.ma_item_restrictions;

select q.seq_no,
           q.rule_id,
           q.message_type,
           q.pub_status,
           q.transaction_time_stamp
      from ma_asos.ma_ship_rest_rule_mfqueue q
     where q.pub_status = 'U'
    --   and q.rule_id not in (select rule_id from table(cast(L_locked_rules as ma_ship_rest_rule_tbl)))
     order by q.seq_no asc;
     
begin     
     update ma_asos.ma_ship_rest_rule_mfqueue set TRANSACTION_TIME_STAMP = sysdate;

  
   insert into ma_asos.ma_ship_rest_rule_mfqueue
  select ma_asos.MA_SHIP_REST_RULE_MFSEQUENCE.nextval,
		 RULE_ID,
         substr('shiprestmod',1,15),
		 'U',
		 sysdate
  from ma_asos.ma_ship_rest_rule 
   where  rownum<=400;
  
  insert into ma_asos.ma_ship_rest_rule_mfqueue
 select ma_asos.MA_SHIP_REST_RULE_MFSEQUENCE.nextval,
		 RULE_ID,
         substr('shiprestmod',1,15),
		 'U',
		 sysdate
  from ma_asos.ma_ship_rest_rule 
   where  RULE_ID not in (select distinct rule_id from ma_asos.ma_ship_rest_rule_mfqueue
                            union
                            select distinct rule_id from ma_asos.ma_item_restrictions)
   and MANU_COUNTRY_ID is null
  and rownum<=200;
  commit;
  
  exception	
when others then
    dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
end;
/

select * from ma_asos.ma_ship_rest_rule where RULE_TYPE ='COM';

select * from all_tables where table_name like '%GROUP%' and owner like 'MA_ASOS';
select * from all_sequences where sequence_name like '%REST%';.

select ma_asos.MA_SHIP_REST_RULE_SEQ.nextval from dual;


select * from ma_asos.MA_ITEM_RESTRICTIONS where RULE_ID = '';
select * from ma_asos.MA_SHIP_REST_GROUP_DETAIL;

select REST_GROUP_ID, SUPPLIER, DIVISION from ma_asos.MA_SHIP_REST_GROUP_HEAD m, rms.sups s, rms.division d
    where SUP_STATUS ='A' and SUPPLIER_PARENT is not null
    and not exists (select 1 from ma_asos.MA_SHIP_REST_RULE msr where msr.supplier =s.supplier) and division in (1,2) and rownum<='500000';
    
select * from sups s where SUP_STATUS ='A' and SUPPLIER_PARENT is not null
    and not exists (select 1 from ma_asos.MA_SHIP_REST_RULE msr where msr.supplier =s.supplier);

select * from ma_asos.MA_SHIP_REST_GROUP_HEAD;
select * from  ma_asos.MA_SHIP_REST_RULE where BRAND_NAME is not null;
select * from ma_asos.ma_ship_rest_rule_mfqueue; --shiprestadd
 --1100000592
select * from ma_asos.MA_ITEM_RESTRICTIONS where RULE_ID = '550323';
select * from country;
550323	SUPP	468 Group


select * from  ma_asos.MA_SHIP_REST_RULE where GROUP_ID ='4';

select * from  ma_asos.MA_SHIP_REST_RULE where BRAND_NAME is not null;
select * from  ma_asos.MA_SHIP_REST_GROUP_DETAIL where REST_GROUP_ID ='468';
select * from  ma_asos.MA_SHIP_REST_GROUP_HEAD where REST_GROUP_ID ='468';
select * from  ma_asos.MA_SHIP_REST_RULE where GROUP_ID ='468';
select * from  ma_asos.MA_SHIP_REST_RULE where rule_id ='550323';

select * from ma_asos.ma_ship_rest_rule_mfqueue; 
select * from ma_asos.MA_ITEM_RESTRICTIONS where RULE_ID = '550323';


select * from MA_ASOS.MA_GROUP_HEADER where GROUP_ID ='4';
select * from MA_ASOS.MA_GROUP_HEADER;

set serveroutput on;
set timing on;

declare
l_rule_id              number  ;      
l_rule_type            varchar2(6) :='COM';
l_rule_desc            varchar2(120) ;
l_group_id             number     ;   
l_supplier             number(10)   ; 
l_division             number(4)    ; 
l_manu_country_id      varchar2(3)   ;

cursor c_item_loc is 
        select gh.REST_GROUP_ID as GROUP_ID,gd.COUNTRY_ID  from ma_asos.MA_SHIP_REST_GROUP_HEAD gh, ma_asos.MA_SHIP_REST_GROUP_DETAIL gd
            where  gd.REST_GROUP_ID = gd.REST_GROUP_ID
             and not exists (select 1 from ma_asos.MA_SHIP_REST_RULE msr where msr.GROUP_ID =gh.REST_GROUP_ID and msr.RULE_TYPE ='COM') and rownum<='50000';
		
		
Begin

for i in c_item_loc loop
        l_group_id := i.GROUP_ID;
        l_manu_country_id := i.COUNTRY_ID;
  
    select ma_asos.MA_SHIP_REST_RULE_SEQ.nextval into l_rule_id from dual;
    
insert into ma_asos.MA_SHIP_REST_RULE 
			(RULE_ID, RULE_TYPE, RULE_DESC, GROUP_ID, SUPPLIER, DIVISION, MANU_COUNTRY_ID, CREATE_ID, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME) 
     values (l_rule_id          
            , l_rule_type        
            , 'Rule for Group '||l_group_id||' COM '||l_manu_country_id
            , l_group_id         
            , null         
            , null         
            , l_manu_country_id
            , 'PTUSER'
            , sysdate
            , 'PTUSER'
            , sysdate);
			
	end loop; 
   commit;
    
    
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/   
   


set serveroutput on;
set timing on;

declare
l_rule_id              number  ;      
l_rule_type            varchar2(6) :='SUPP';
l_rule_desc            varchar2(120) ;
l_group_id             number     ;   
l_supplier             number(10)   ; 
l_division             number(4)    ; 
l_manu_country_id      varchar2(3)   ;

cursor c_item_loc is 
    select REST_GROUP_ID as GROUP_ID, SUPPLIER, DIVISION from ma_asos.MA_SHIP_REST_GROUP_HEAD m, rms.sups s, rms.division d
          where SUP_STATUS ='A' and SUPPLIER_PARENT is not null
        and not exists (select 1 from ma_asos.MA_SHIP_REST_RULE msr where msr.supplier =s.supplier) and division in (1,2) and rownum<='500000';
		
		
Begin

for i in c_item_loc loop
        l_group_id := i.GROUP_ID;
        l_supplier := i.supplier;
        l_division := i.DIVISION;
  
    select ma_asos.MA_SHIP_REST_RULE_SEQ.nextval into l_rule_id from dual;
insert into ma_asos.MA_SHIP_REST_RULE 
			(RULE_ID, RULE_TYPE, RULE_DESC, GROUP_ID, SUPPLIER, DIVISION, MANU_COUNTRY_ID, CREATE_ID, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME) 
     values (l_rule_id          
            , l_rule_type        
            , 'Rule for Group '||l_group_id||' Supplier '||l_supplier||' Division ' || l_division
            , l_group_id         
            , l_supplier         
            , l_division         
            , null
            , 'PTUSER'
            , sysdate
            , 'PTUSER'
            , sysdate);
			
	end loop; 
   commit;
    
    
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/   
    



