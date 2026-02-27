SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER804'; -- 101
SELECT * FROM ma_asos.ma_merch_hier_default where USER_ID like 'PTESTUSER804'; --82

SELECT * FROM ma_asos.ma_buy_hier_default where BUYING_GROUP in ('226','128');
SELECT * FROM ma_asos.ma_merch_hier_default where trunc(CREATE_DATETIME) >= '19-SEP-20';
--delete FROM ma_asos.ma_buy_hier_default where trunc(CREATE_DATETIME) >= '20-SEP-20';

delete FROM ma_asos.ma_buy_hier_default;
delete FROM ma_asos.ma_buy_hier_default where BUYING_GROUP not in ('100','101','103','124','112','104','106','198','199');
update ma_asos.ma_buy_hier_default set PRIMARY_IND= 'Y' where BUYING_GROUP in ('100');

--options counts
select mb.USER_ID, mh.DIVISION, mh.DEPT, mb.BUSINESS_MODEL , mb.BUYING_GROUP, sum(oic.COUNT_OPTIONS)
 from option_item_counts oic, ma_asos.ma_buy_hier_default mb,ma_asos.ma_merch_hier_default mh
 where mb.USER_ID = mh.USER_ID 
 and oic.DIVISION=mh.DIVISION 
 and oic.DEPT=mh.DEPT 
 and oic.BUSINESS_MODEL=mb.BUSINESS_MODEL 
 and oic.BUYING_GROUP=mb.BUYING_GROUP
 group by mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL,mh.DEPT, mb.BUYING_GROUP  
 order by mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL;

select mb.USER_ID, 
--mh.DIVISION, mb.BUSINESS_MODEL, 
sum(oic.COUNT_OPTIONS)
 from option_item_counts oic, ma_asos.ma_buy_hier_default mb,ma_asos.ma_merch_hier_default mh
 where mb.USER_ID = mh.USER_ID 
 and oic.DIVISION=mh.DIVISION 
 and oic.DEPT=mh.DEPT 
 and oic.BUSINESS_MODEL=mb.BUSINESS_MODEL 
 and oic.BUYING_GROUP=mb.BUYING_GROUP
 group by mb.USER_ID ;--, mh.DIVISION, mb.BUSINESS_MODEL ;

select * from option_item_counts;
select * from v_item_master im; 
select * from  ma_asos.ma_v_item;
select * from  MA_ASOS.MA_BUSINESS_MODEL;
select * from  MA_ASOS.MA_BUSINESS_MODEL;
select * from option_item_counts where COUNT_OPTIONS > 120 order by COUNT_OPTIONS;


SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER802';


set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_supplier          ma_asos.ma_buy_hier_default.USER_ID%type;
    l_supp              ma_asos.ma_buy_hier_default.USER_ID%type;  
Begin 

for supnum in 801 .. 850 loop        

select 'PTESTUSER'||supnum into l_supplier from dual;

insert into ma_asos.ma_buy_hier_default 
select distinct l_supplier, BUSINESS_MODEL, BUYING_GROUP, 'N', '22-SEP-20','22-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where 
  BUSINESS_MODEL in ( '1','3') and 
 not exists (select 1 from ma_asos.ma_buy_hier_default mh where mh.BUSINESS_MODEL = oic.BUSINESS_MODEL and mh.BUYING_GROUP = oic.BUYING_GROUP and mh.USER_ID likE l_supplier) ;


insert into ma_asos.ma_merch_hier_default 
select distinct l_supplier, DIVISION, DEPT, 'N', '22-SEP-20','22-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where --DIVISION = '1' and 
 not exists (select 1 from ma_asos.ma_merch_hier_default mh where mh.DIVISION = oic.DIVISION and mh.DEPT = oic.DEPT and mh.USER_ID likE l_supplier) ;


END LOOP;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/

SELECT * FROM ma_asos.ma_merch_hier_default where USER_ID like 'PTESTUSER802';

insert into ma_asos.ma_merch_hier_default 
select distinct 'PTESTUSER801', DIVISION, DEPT, 'N', '19-SEP-20','19-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where DIVISION = '1' 
 and not exists (select 1 from ma_asos.ma_merch_hier_default mh where mh.DIVISION = oic.DIVISION and mh.DEPT = oic.DEPT ) ;

select im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET, count(1) as count_options
    from v_item_master im, ma_asos.ma_v_item ma where im.item = ma.item and im.item_level = '1' and im.status = 'A'
    group by im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET;




select mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL, sum(oic.COUNT_OPTIONS)
 from option_item_counts oic, ma_asos.ma_buy_hier_default mb,ma_asos.ma_merch_hier_default mh
 where mb.USER_ID = mh.USER_ID 
 and oic.DIVISION=mh.DIVISION 
 and oic.DEPT=mh.DEPT 
 and oic.BUSINESS_MODEL=mb.BUSINESS_MODEL 
 and oic.BUYING_GROUP=mb.BUYING_GROUP
 group by mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL 
 order by mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL;

drop table pricmasssearch;
create table pricmasssearch as
    select price_change_id, ITEM, location, status from ma_asos.ma_price_change
union
    select price_change_id, ITEM, location, 'A' from rpm_price_change where STATe ='pricechange.state.approved';


select * from pricmasssearch where  ITEM = '100156608';
select * from pricmasssearch_h;


select *  from  pricmasssearch pr;
create table pricmasssearch_h as 
select im.item,im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET 
    from v_item_master im, ma_asos.ma_v_item ma where im.item = ma.item and im.item_level = '1' and im.status = 'A' 
    AND im.item in (select Distinct item  from  pricmasssearch);

-- Pric
select mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL, pr.STATUS,
 count(pr.PRICE_CHANGE_ID)
 from pricmasssearch pr, pricmasssearch_h oic, ma_asos.ma_buy_hier_default mb,ma_asos.ma_merch_hier_default mh
 where pr.ITEM = oic.ITEM 
 and pr.STATUS in ('A','W')-- '100156608'
 and oic.DIVISION=mh.DIVISION 
 and oic.DEPT=mh.DEPT 
 and oic.BUSINESS_MODEL=mb.BUSINESS_MODEL 
 and oic.BUYING_GROUP=mb.BUYING_GROUP
 and mb.USER_ID = mh.USER_ID 
 group by mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL ,STATUS 
 order by mb.USER_ID, mh.DIVISION, mb.BUSINESS_MODEL;
 

-- PO

create table orditemloc as 
    select oh.order_no,od.item,od.location,oh.supplier 
        from ordloc od ,ordhead oh where oh.order_no = od.order_no and oh.status ='A';
drop table orditemloc;
create table orditemloc_h as 
select im.item,im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET 
    from v_item_master im, ma_asos.ma_v_item ma where im.item = ma.item --and im.item_level = '1' and im.status = 'A' 
    AND im.item in (select Distinct item  from  orditemloc);

select item,count(1) from orditemloc group by item;


select mb.USER_ID , --mh.DIVISION, --mh.DEPT, mb.BUSINESS_MODEL,--mb.BUYING_GROUP,
count(pr.order_no)/3
 from orditemloc pr, orditemloc_h oic, ma_asos.ma_buy_hier_default mb,ma_asos.ma_merch_hier_default mh
 where pr.ITEM = oic.ITEM 
 and oic.DIVISION=mh.DIVISION 
 and oic.DEPT=mh.DEPT 
 and oic.BUSINESS_MODEL=mb.BUSINESS_MODEL 
 and oic.BUYING_GROUP=mb.BUYING_GROUP
 and mb.USER_ID = mh.USER_ID 
 group by mb.USER_ID --, mh.DIVISION, mb.BUSINESS_MODEL --,mh.DEPT,mb.BUYING_GROUP
 order by mb.USER_ID;, mh.DIVISION, mb.BUSINESS_MODEL ;--,mh.DEPT,mb.BUYING_GROUP;



-- Pric
USER_ID	DIVISION	DEPT	BUSINESS_MODEL	STATUS	BUYING_GROUP	COUNT(PR.PRICE_CHANGE_ID)
PTESTUSER801	1	1050	1	W	122	3506
PTESTUSER801	1	1057	1	A	121	2379

SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER802';
SELECT * FROM ma_asos.ma_merch_hier_default where USER_ID like 'PTESTUSER802';

SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER801';
SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER802';

set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_supplier          ma_asos.ma_buy_hier_default.USER_ID%type;
    l_supp              ma_asos.ma_buy_hier_default.USER_ID%type;  
Begin 

for supnum in 802 .. 850 loop        

select 'PTESTUSER'||supnum into l_supplier from dual;
        
insert into ma_asos.ma_buy_hier_default 
select distinct l_supplier, BUSINESS_MODEL, BUYING_GROUP, 'N', '20-SEP-20','20-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where BUSINESS_MODEL = '1'  and BUYING_GROUP ='121'--'122'
 and  not exists (select 1 from ma_asos.ma_buy_hier_default mh where 
     mh.BUSINESS_MODEL = oic.BUSINESS_MODEL and mh.BUYING_GROUP = oic.BUYING_GROUP and mh.USER_ID likE l_supplier) ;

insert into ma_asos.ma_merch_hier_default 
select distinct l_supplier, DIVISION, DEPT, 'N', '20-SEP-20','20-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where DIVISION = '1' and DEPT ='1057' --'1050'
 and not exists (select 1 from ma_asos.ma_merch_hier_default mh where mh.DIVISION = oic.DIVISION and mh.DEPT = oic.DEPT and mh.USER_ID likE l_supplier) ;

END LOOP;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


--All PGs & 4-5 BMs
SELECT * FROM ma_asos.ma_merch_hier_default where USER_ID like 'PTESTUSER801';
SELECT * FROM ma_asos.ma_merch_hier_default where USER_ID like 'PTESTUSER802';

SELECT * FROM ma_asos.ma_merch_hier_default where dept in ('2111','1112') ;
delete FROM ma_asos.ma_merch_hier_default where dept in ('2111','1112') ;


set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_supplier          ma_asos.ma_buy_hier_default.USER_ID%type;
    l_supp              ma_asos.ma_buy_hier_default.USER_ID%type;  
Begin 

for supnum in 810 .. 850 loop        

select 'PTESTUSER'||supnum into l_supplier from dual;

insert into ma_asos.ma_merch_hier_default 
select distinct l_supplier, DIVISION, DEPT, 'N', '21-SEP-20','21-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where  
 not exists (select 1 from ma_asos.ma_merch_hier_default mh where mh.DIVISION = oic.DIVISION and mh.DEPT = oic.DEPT and mh.USER_ID likE l_supplier) ;

END LOOP;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/


SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER810';
SELECT * FROM ma_asos.ma_buy_hier_default where USER_ID like 'PTESTUSER802';

delete FROM ma_asos.ma_buy_hier_default where BUSINESS_MODEL in ('6','7','8') ;

set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_supplier          ma_asos.ma_buy_hier_default.USER_ID%type;
    l_supp              ma_asos.ma_buy_hier_default.USER_ID%type;  
Begin 

for supnum in 810 .. 850 loop        

select 'PTESTUSER'||supnum into l_supplier from dual;

insert into ma_asos.ma_buy_hier_default 
select distinct l_supplier, BUSINESS_MODEL, BUYING_GROUP, 'N', '21-SEP-20','21-SEP-20','MA_ASOS','MA_ASOS'
 from option_item_counts oic where  not exists (select 1 from ma_asos.ma_buy_hier_default mh where 
     mh.BUSINESS_MODEL = oic.BUSINESS_MODEL and mh.BUYING_GROUP = oic.BUYING_GROUP and mh.USER_ID likE l_supplier) ;

END LOOP;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/