select distinct item,status from ma_asos.ma_price_change ;

update ma_asos.ma_price_change set CREATE_DATETIME='28-APR-2020', LAST_UPDATE_DATETIME='28-APR-2020',PLACE_OF_CREATION = 'M'
    where trunc(CREATE_DATETIME) = '28-MAY-2020';

select distinct dept from item_master_op im where im.dept not in ('1004','1006','1001','2051') order by 1 ;

1004 --50   --trunc(EFFECTIVE_DATE) = '25-APR-21'
1006 --100  --trunc(EFFECTIVE_DATE) = '26-APR-21'
1001 --500  --trunc(EFFECTIVE_DATE) = '27-APR-21'
2051 --1000 --trunc(EFFECTIVE_DATE) = '28-APR-21'


select * from(
select distinct im.item from item_master_op im
    where im.dept not in ('1004','1006','1001','2051') --and im.dept = '1062'
        and not exists (select 1 from ma_asos.ma_price_change mpc where mpc.item = im.item)) 
            where rownum <= '1000';
        
        
        
drop table pomasssearch;
create table pomasssearch as
    select price_change_id, ITEM, location, status from ma_asos.ma_price_change
union
    select price_change_id, ITEM, location, 'A' from rpm_price_change where STATe ='pricechange.state.approved';



drop table pricemasssearch;
create table pricemasssearch as
select p.*,im.DEPT, im.CLASS, im.SUBCLASS from pomasssearch p, v_item_master im where p.item = im.item;


drop table pomasssearch_a;
create table pomasssearch_a as
select price_change_id, ITEM, location from rpm_price_change where state = 'pricechange.state.approved';
create table pricemasssearch_a as
select p.*,im.DEPT, im.CLASS, im.SUBCLASS from pomasssearch_a p, v_item_master im where p.item = im.item;
drop table pricemasssearch_a;

select * from pricemasssearch;

select DEPT, CLASS, SUBCLASS,count(distinct(PRICE_CHANGE_ID)) 
    from pricemasssearch group by DEPT, CLASS, SUBCLASS having count( distinct (PRICE_CHANGE_ID)) > 50 order by count(distinct(PRICE_CHANGE_ID));

-- Price change 50 -- select *  from pricemasssearch where DEPT=1052 and class=4 and SUBCLASS ='2';
-- Price change 100 -- select *  from pricemasssearch where DEPT=2114 and class=6 and SUBCLASS ='1';
-- Price change 150 -- select *  from pricemasssearch where DEPT=2103 and class=1 and SUBCLASS ='7';
-- Price change 250 -- select *  from pricemasssearch where DEPT=2014 and class=8 and SUBCLASS ='3';
-- Price change 500 -- select *  from pricemasssearch where DEPT=1052 and class=11 and SUBCLASS ='1';
-- Price change 1000 -- select *  from pricemasssearch where DEPT=1113 and class=2 and SUBCLASS ='1';
-- Price change 2000 -- select *  from pricemasssearch where DEPT=2054 and class=1 and SUBCLASS ='1';

select * from rms.skulist_head where sKULIST_DESC like 'PriceChange%';
select * from rms.skulist_detail where skulist in (select skulist from rms.skulist_head where sKULIST_DESC like 'Price Change%');
select * from rms.skulist_criteria where skulist in (select skulist from rms.skulist_head where sKULIST_DESC like 'Price Change%');

select * from ma_asos.ma_price_change where item in (select item from skulist_detail where skulist = '150231') and EFFECTIVE_DATE= '31-JAN-21';

select *  from skulist_head where skulist = '150231';
select *  from skulist_detail where skulist = '150231';
select *  from skulist_criteria where skulist = '150231';

delete from skulist_head where skulist = '85003';
delete from skulist_detail where skulist = '85003';
delete from skulist_criteria where skulist = '85003';

insert into skulist_detail (SKULIST, ITEM, ITEM_LEVEL, TRAN_LEVEL, PACK_IND, INSERT_ID, INSERT_DATE, CREATE_DATETIME, LAST_UPDATE_DATETIME, LAST_UPDATE_ID)
    select distinct 2898001,item,1,2,'N','RMS','20-DEC-19','20-DEC-19','20-DEC-19','RMS' from 
        item_master where dept = '2003' and item in (select item from ma_asos.ma_price_change where status = 'W') and item_level = '1';

delete from skulist_detail where skulist = '2651694';
select * from skulist_detail where item_level != '1';


drop table pomasssearch;
create table pomasssearch as
    select price_change_id, ITEM, location from ma_asos.ma_price_change where STATUS ='W';
drop table pricemasssearch;
create table pricemasssearch as
select p.*,im.DEPT, im.CLASS, im.SUBCLASS from pomasssearch p, v_item_master im where p.item = im.item;

drop table pomasssearch_a;
create table pomasssearch_a as
select price_change_id, ITEM, location from rpm_price_change where state = 'pricechange.state.approved';

drop table pricemasssearch_a ;
create table pricemasssearch_a as
select p.*,im.DEPT, im.CLASS, im.SUBCLASS from pomasssearch_a p, v_item_master im where p.item = im.item;

select * from po_mass_search order by 1,2,3,4;
select distinct sh.SKULIST, sh.SKULIST_DESC, DIVISION, DEPT, CLASS, SUBCLASS from rms.skulist_detail sd, rms.skulist_head sh, rms.v_item_master im 
    where sh.skulist = sd.skulist and sh. sKULIST_DESC like '%Mass%PCSearch%' and sd.item = im.item order by 3,4,5,6;

select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME from V_MERCH_HIERARCHY where division = '1'  order by DEPT_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME,CLASS, CLASS_NAME from V_MERCH_HIERARCHY where  dept = '1158' and  division = '1' order by CLASS_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME,CLASS, CLASS_NAME,SUBCLASS, SUB_NAME 
    from V_MERCH_HIERARCHY where division = '1' and dept = '1158' and class = '5' order by SUB_NAME;


set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;
l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist           number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM              VARCHAR2(25);
l_date              date;
l_DEPT              rms.subclass.dept%type;
l_CLASS             rms.subclass.class%type;
l_SUBCLASS          rms.subclass.subclass%type;
l_Count             number(4);


CURSOR c_dept is 
select DEPT, CLASS, SUBCLASS, counts from (
select DEPT, CLASS, SUBCLASS,count(distinct(PRICE_CHANGE_ID))  as counts
    from pricemasssearch group by DEPT, CLASS, SUBCLASS having count( distinct (PRICE_CHANGE_ID)) > 1000 order by count(distinct(PRICE_CHANGE_ID))
    ) where rownum<= '5';

CURSOR c_itemlist (l_DEPT rms.subclass.dept%type,l_CLASS rms.subclass.class%type,l_SUBCLASS rms.subclass.subclass%type) is
    select distinct item  from pricemasssearch where DEPT=l_DEPT and class=l_CLASS and SUBCLASS =l_SUBCLASS;
    
    
BEGIN
for m in c_dept loop 
    
    l_DEPT      :=  m.DEPT;
    l_CLASS     :=  m.CLASS;
    l_SUBCLASS  :=  m.SUBCLASS;
    l_Count     :=  m.Counts;

   select sysdate into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'Mass PCSearch '||'-'||l_Count||'-'||l_REF_NO;
		I_filename 		:= 'Mass PCSearch '||'-'||l_Count||'-'||l_REF_NO;

FOR i in c_itemlist (l_DEPT, l_CLASS , l_SUBCLASS)  Loop 
            l_item     :=i.item;


insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);


 END LOOP;
 END LOOP;

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/





