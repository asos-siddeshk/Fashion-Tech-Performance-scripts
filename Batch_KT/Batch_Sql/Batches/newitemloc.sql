SELECT count(distinct ITEM_PARENT) FROM ITEM_MASTER IM
    WHERE EXISTS (SELECT 1 FROM ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS  MID 
                                                where process_seq  BETWEEN '5900' AND '5903' 
                                                AND MID.BUSINESS_OBJ_ID = IM.ITEM_PARENT);

SELECT count(distinct BUSINESS_OBJ_ID) FROM ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS  MID 
                                                where process_seq  BETWEEN '5900' AND '5903';

SELECT distinct BUSINESS_OBJ_ID FROM ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS  MID 
                                                where process_seq  BETWEEN '5900' AND '5903';
                                                
SELECT ITEM_PARENT,count(1) FROM ITEM_MASTER IM
    WHERE EXISTS (SELECT 1 FROM ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS  MID 
                                                where process_seq  BETWEEN '5900' AND '5903' 
                                                AND MID.BUSINESS_OBJ_ID = IM.ITEM_PARENT) group by item_parent;



--Dept Counts
select im.dept,count(ril.loc) from rms.item_master im,rpm_stage_item_loc ril where  im.item = ril.item  group by im.dept order by 1;

select im.dept,count(ril.loc) from rms.item_master im,new_item_loc_batch ril where  im.item = ril.item  group by im.dept order by 1;


-- Total
--drop table new_item_loc_batch;
--create table new_item_loc_batch as select * from rms.rpm_stage_item_loc; Main

select * from new_item_loc_batch;
truncate table rpm_stage_item_loc;


select count(1) from rms.rpm_stage_item_loc;
select count(1) from itemloc_mfqueue;



set serveroutput on;
set timing on;

declare
   p_item_id                    ma_asos.ma_price_change.item%type;



cursor c_item_loc is 
    select * from (
        select distinct im.item_parent as item 
                from 
                rms.item_master im where im.item_level = '2' and dept in ('1051') --,2108,1108,2114)  
                and exists (select 1 from skumar.new_item_loc_batch im2 where im2.item = im.item_parent)
                and not exists (select 1 from rms.rpm_stage_item_loc ril where ril.item = im.item)) where rownum <= '500';

begin

for k in 0..0 loop

for i in c_item_loc loop
        p_item_id := i.item;

        insert into rpm_stage_item_loc
            select STAGE_ITEM_LOC_ID, ITEM, LOC, LOC_TYPE, SELLING_UNIT_RETAIL, SELLING_UOM, STATUS, CREATE_DATE, ERROR_MSG, ERROR_DATE, PROCESS_ID
               from new_item_loc_batch 
                    where item in (select item from item_master where item = p_item_id or item_parent = p_item_id);

end loop; 
end loop; 
    delete from new_item_loc_batch where  STAGE_ITEM_LOC_ID in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc);

commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
   


create table overnight_item_loc_batch as select * from rms.rpm_stage_item_loc;
delete from rms.rpm_stage_item_loc;

select * from overnight_item_loc_batch;
insert into rms.rpm_stage_item_loc select * from overnight_item_loc_batch;

select count(1) from rms.rpm_stage_item_loc;
select count(1) from itemloc_mfqueue;




select v.DIVISION, v.GROUP_NO, v.DEPT,s.CLASS, s.SUBCLASS from v_deps v,subclass s where v.dept = s.dept and s.subclass = '1' and s.class = '1';




select * from uda_item_defaults;
select * from uda_item_defaults_bk;

--drop table uda_item_defaults_bk;
create table uda_item_defaults_bk as select * from rms.uda_item_defaults;
insert into uda_item_defaults select * from uda_item_defaults_bk;
delete from rms.uda_item_defaults;

select * from ma_asos.MA_STG_UPLOAD_PROCESS order by 1 desc;
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq = '5885';

select count(1) from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq = '5885';

select count(1) from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq >= '5900';

select * from ma_asos.MA_STG_UPLOAD_PROCESS where process_seq >= '5900';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE where process_seq >= '5900';
select * from ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS where process_seq >= '5900';
select * from ma_asos.MA_STG_UPLOAD_BOUNDED_ATTR where process_seq >= '5900';
select * from ma_asos.MA_STG_UPLOAD_UNBOUNDED_ATTR where process_seq >= '5900';


select * from item_master where item = '101512124' or item_parent = '101512124';
select * from item_loc where item = '101512124' or item_parent = '101512124';
select count(1) from rpm_stage_item_loc where item in (select item from item_master where item = '101512124' or item_parent = '101512124');


select count(1) from rpm_stage_item_loc;
select count(1) from rpm_stage_item_loc_bk; --4604313


SELECT DISTINCT IM.ITEM_PARENT FROM ITEM_MASTER IM
    WHERE ITEM IN (select DISTINCT iteM from rpm_stage_item_loc)
        AND EXISTS (SELECT 1 FROM ma_asos.MA_STG_UPLOAD_PROCESS_LINE_IDS  MID 
                                                where process_seq  BETWEEN '5900' AND '5903' 
                                                AND MID.BUSINESS_OBJ_ID = IM.ITEM_PARENT);


select im.dept,ril.loc,count(ril.loc) from rms.item_master im,rpm_stage_item_loc ril where 
 im.status ='A' and im.item = ril.item and im.item_level = '1'
 group by im.dept,ril.loc order by 1,2,3;

select im.dept,ril.loc,count(ril.loc) from rms.item_master im,rpm_stage_item_loc_bk ril where 
 im.status ='A' and im.item = ril.item and im.item_level = '1'
 group by im.dept,ril.loc order by 1,2,3;


select im.dept,count(ril.loc) from rms.item_master im,rpm_stage_item_loc_bk ril where 
 im.status ='A' and im.item = ril.item
 group by im.dept order by 1,2;

select im.dept,count(ril.loc) from rms.item_master im,rpm_stage_item_loc_bk ril where 
 im.status ='A' and im.item = ril.item
 group by im.dept order by 1,2;
 
select count(1) from rpm_stage_item_loc;
select count(1) from rpm_stage_item_loc_bk; --4604313

select count(1) from rpm_stage_item_loc;

select * from rpm_stage_item_loc_bk;

            select STAGE_ITEM_LOC_ID, ITEM, LOC, LOC_TYPE, SELLING_UNIT_RETAIL, SELLING_UOM, STATUS, CREATE_DATE, ERROR_MSG, ERROR_DATE, PROCESS_ID
               from rpm_stage_item_loc_bk 
                    where item in (select item from item_master where item = '101057060' or item_parent = '101057060');

        select * from (select distinct ril.item from 
                        rpm_stage_item_loc_bk ril, rms.item_master im where 
                            ril.item= im.item and im.item_level = '1' and dept= '1050' and
                                exists (select 1 from rms.item_master im2 where im2.item_parent = im.item ));





set serveroutput on;
set timing on;

declare
   p_item_id                    ma_asos.ma_price_change.item%type;



cursor c_item_loc is 
    select * from (
        select distinct im.item_parent as item 
                from 
                rms.item_master im where im.item_level = '2' and dept in ('2108') --,2108,1108,2114)  
                and exists (select 1 from skumar.new_item_loc_batch im2 where im2.item = im.item_parent)
                and not exists (select 1 from rms.rpm_stage_item_loc ril where ril.item = im.item)) where rownum <= '500';

begin

for k in 0..0 loop

for i in c_item_loc loop
        p_item_id := i.item;

        insert into rpm_stage_item_loc
            select STAGE_ITEM_LOC_ID, ITEM, LOC, LOC_TYPE, SELLING_UNIT_RETAIL, SELLING_UOM, STATUS, CREATE_DATE, ERROR_MSG, ERROR_DATE, PROCESS_ID
               from new_item_loc_batch 
                    where item in (select item from item_master where item = p_item_id or item_parent = p_item_id);

end loop; 
end loop; 
    delete from new_item_loc_batch where  STAGE_ITEM_LOC_ID in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc);

commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
   


/*

insert into rpm_stage_item_loc_bk select * from rpm_stage_item_loc;
delete from rpm_stage_item_loc;
select count(1) from rpm_stage_item_loc_bk;





insert into rpm_stage_item_loc_bk 
select * from rpm_stage_item_loc where STAGE_ITEM_LOC_ID not in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc_bk) and rownum <= '700000' order by 1 ;
delete from rpm_stage_item_loc;

select * from rpm_stage_item_loc;
insert into rpm_stage_item_loc 
    select * from rpm_stage_item_loc_bk where rownum <= '650000' order by 1;
delete from rpm_stage_item_loc_bk where STAGE_ITEM_LOC_ID in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc);



select * from rpm_stage_item_loc_bk where (ITEM, LOC) not in (select ITEM, LOC from rpm_stage_item_loc);
select * from rpm_stage_item_loc_bk where (ITEM, LOC) not in (select ITEM, LOC from rpm_stage_item_loc);

select * from rpm_stage_item_loc_bk where item in (select item from item_master where status!='A');


delete
        from rpm_stage_item_loc_bk sil
       where  NOT EXISTS (select item
                          from item_master im
                         where im.item = sil.item);
                         
DELETE FROM rpm_stage_item_loc_bk
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM rpm_stage_item_loc_bk
		GROUP BY item,loc);	

delete
        from rpm_stage_item_loc_bk s
       where s.status     = 'N'
         and (   s.item IN (select im.item
                              from item_master im
                             where im.item = s.item
                               and (   im.item_level   != im.tran_level
                                    or im.sellable_ind != 'Y'))
              or s.loc_type NOT IN (select 'S'
                                      from dual
                                    union all
                                    select DECODE(recognize_wh_as_locations,
                                                  1, 'W',
                                                  'S')
                                      from rpm_system_options)
              or s.selling_unit_retail is NULL
              or s.selling_uom         is NULL);







select LOC,count(1) from rpm_stage_item_loc group by loc;
select LOC,count(1) from rpm_stage_item_loc_bk group by loc;

DELETE FROM rpm_stage_item_loc_bk WHERE rowid not in(SELECT MIN (rowid)
		FROM rpm_stage_item_loc_bk
		GROUP BY STAGE_ITEM_LOC_ID,item,loc);	
        

select * from rpm_stage_item_loc_bk_20000;

create table rpm_stage_item_loc_bk_20000 as
select * from rpm_stage_item_loc_bk where loc ='20000';

insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='10000';
commit;

select * from rpm_stage_item_loc;
--drop table rpm_stage_item_loc_bk;

create table rpm_stage_item_loc_bk as
select * from rpm_stage_item_loc;

select (select count(1) from rpm_stage_item_loc_bk)-1005938 from dual;
--truncate table rpm_stage_item_loc_bk;


select * from rpm_item_loc;

create table rpm_item_loc_sid as
select item,
			   loc,
			   loc_type,
			   selling_unit_retail,
			   selling_uom from rms.item_loc il where (il.item,il.loc) not in (select ril.item,ril.loc from rms.rpm_item_loc ril) 
and exists (select 1 from rms.item_master im where im.item_level ='2' and im.status ='A' and im.item = il.item);

select * from rpm_stage_item_loc_bk;


insert into rpm_stage_item_loc_bk
    select RPM_STAGE_ITEM_LOC_SEQ.nextval,
       item,
       loc,
       loc_type,
       selling_unit_retail,
       selling_uom,
       'N',
       vdate as create_date,
       null,
       null,
       null
       from rpm_item_loc_sid, period p;


select * from tran_data_a;
select count(1) from tran_data_b;



2012;

select dept,count(dept) from rms.item_master where item in (select distinct item from rpm_stage_item_loc) group by dept order by 2;

select count(ril.item) from rpm_stage_item_loc ril, item_master im where 
    im.dept in (2104,2151,2114,999,2159,2103,2105,2113,2108,1114,2111,2055,2102,2101,2016,9999,1062,
    1054,1053,2056,1063,2156,1061,1051,1011,2009,2052,2054,1060,1057,1008,1052,2003,2053,2001,2051,1001,1050,2050) 
    and im.status ='A' and im.item = ril.item;


create table rpm_stage_item_loc_del_bk as
select ril.* from rpm_stage_item_loc ril, item_master im where 
    im.dept in (2104,2151,2114,999,2159,2103,2105,2113,2108,1114,2111,2055,2102,2101,2016,9999,1062,
    1054,1053,2056,1063,2156,1061,1051,1011,2009,2052,2054,1060,1057,1008,1052,2003,2053,2001,2051,1001,1050,2050) 
    and im.status ='A' and im.item = ril.item;

select * from rpm_stage_item_loc where STAGE_ITEM_LOC_ID in (select STAGE_ITEM_LOC_ID from rpm_stage_item_loc_del_bk);
--delete from rpm_stage_item_loc where STAGE_ITEM_LOC_ID in (select STAGE_ITEM_LOC_ID from skumar.rpm_stage_item_loc_del_bk);
select * from rpm_stage_item_loc_del_bk;
drop table rpm_stage_item_loc_bk;
create table rpm_stage_item_loc_bk as
select * from rpm_stage_item_loc;

select dept,count(dept) from rms.item_master where item in (select distinct item from rpm_stage_item_loc) group by dept order by 2;
insert into rpm_stage_item_loc_del_bk
select * from rpm_stage_item_loc where item in (select distinct item from rms.item_master where dept ='2012');
delete from rpm_stage_item_loc where item in (select distinct item from rms.item_master where dept ='2012');


select im.dept,ril.loc,count(ril.loc) from rms.item_master im,rpm_stage_item_loc ril where 
 im.status ='A' and im.item = ril.item
 group by im.dept,ril.loc order by 2;

select count(1) from rpm_stage_item_loc ;
select count(1) from rpm_stage_item_loc_clean;

insert into rpm_stage_item_loc
select ril.* from rpm_stage_item_loc_del_bk ril, item_master im where 
    im.dept in (1053,1054,1011,2056,2009,1062,2052,1008,1051,1057,1063,2003,2053,1061,1052,2054,2156,1060,2050,1050,2001,1001) 
    and im.status ='A' and im.item = ril.item order by 2,3;

insert into rpm_stage_item_loc
select ril.* from rpm_stage_item_loc_del_bk ril, item_master im where 
    im.dept in (2012) 
    and im.item not in (select item from rpm_stage_item_loc)
    and im.status ='A' and im.item = ril.item and rownum <='80000' order by 2,3;

insert into rpm_stage_item_loc
select ril.* from rpm_stage_item_loc_del_bk ril, item_master im where 
    im.dept in (2051) 
    and im.item not in (select item from rpm_stage_item_loc)
    and im.status ='A' and im.item = ril.item and rownum <='80000' order by 2,3;

select im.dept,ril.loc,count(ril.loc) from rms.item_master im,rpm_stage_item_loc_del_bk ril where 
 im.status ='A' and im.item = ril.item
 and im.item not in (select item from rpm_stage_item_loc)
 group by im.dept,ril.loc order by 2;
 
 
select im.dept,ril.loc,count(ril.loc) from rms.item_master im,rpm_stage_item_loc ril where 
 im.status ='A' and im.item = ril.item
 group by im.dept,ril.loc order by 1,2;
 
 
 select * from ma_asos.MA_PRICE_EVENT_BALANCE_MATRIX;
 
 select count(1) from rpm_stage_item_loc where loc_type ='S'; --148239
 select count(1) from rpm_item_loc where (item,loc) in (select item,loc from rpm_stage_item_loc ); --110774
 
 
 
select count(1) from rpm_stage_item_loc where loc_type ='W'; --27846
select count(1) from rpm_item_loc where (item,loc) in (select item,loc from rpm_stage_item_loc_bk); --358

select * from rms.rpm_system_options;
Update rms.rpm_system_options set RECOGNIZE_WH_AS_LOCATIONS ='1';
Update  ma_asos.ma_stage_clearance set OUT_OF_STOCK_DATE =EFFECTIVE_DATE+3, RESET_DATE=EFFECTIVE_DATE+3 where status ='N';
update ma_asos.ma_stage_simple_promo set STAGE_ID =rownum, STAGE_PROMO_COMP_ID =rownum where status ='N';

  insert into rpm_stage_item_loc
  select * from rpm_stage_item_loc_bk_n;
  
  
delete
        from rpm_stage_item_loc_bk sil
       where  NOT EXISTS (select item
                          from item_master im
                         where im.item = sil.item);
                         
DELETE FROM rpm_stage_item_loc_bk
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM rpm_stage_item_loc_bk
		GROUP BY item,loc);	

delete
        from rpm_stage_item_loc_bk s
       where s.status     = 'N'
         and (   s.item IN (select im.item
                              from item_master im
                             where im.item = s.item
                               and (   im.item_level   != im.tran_level
                                    or im.sellable_ind != 'Y'))
              or s.loc_type NOT IN (select 'S'
                                      from dual
                                    union all
                                    select DECODE(recognize_wh_as_locations,
                                                  1, 'W',
                                                  'S')
                                      from rpm_system_options)
              or s.selling_unit_retail is NULL
              or s.selling_uom         is NULL);
              
              
              
              
              
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
commit;

insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
insert into rpm_stage_item_loc select * from rpm_stage_item_loc_bk_20000 rilb where  not exists (select 1 from rpm_stage_item_loc ril where ril.STAGE_ITEM_LOC_ID=rilb.STAGE_ITEM_LOC_ID) and rownum <='100000';
commit;

