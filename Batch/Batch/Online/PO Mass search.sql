create table orditemloc as 
    select oh.order_no,od.item,od.location,oh.supplier 
        from ordloc od ,ordhead oh where oh.order_no = od.order_no and oh.status ='A';

drop table orditemloc;
drop table orditemloc_d;

select * from orditemloc;

create table orditemloc_d as 
 select oil.*,DIVISION, DEPT, CLASS, SUBCLASS from orditemloc oil, v_item_master im where oil.item= im.item;


select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 20 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 50 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 100 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 150 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 250 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 500 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 1000 order by count(distinct(order_no));

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 2000 order by count(distinct(order_no));


drop table po_mass_search;
create table po_mass_search as
select  * from (
select distinct DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) as count 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 20 order by count(distinct(order_no)) ) 
    where rownum <= '10';

insert into po_mass_search 
select  * from (
select distinct DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) as count 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 1000 order by count(distinct(order_no)) ) where rownum <= '10';


select * from po_mass_search order by 1,2,3,4;
	
   delete FROM po_mass_search
		WHERE rowid not in
		(SELECT MIN(rowid)
		FROM po_mass_search
		GROUP BY DIVISION, DEPT, CLASS, SUBCLASS, COUNT);		

select * from po_mass_search order by 1,2,3,4;

select * from all_views where view_name like '%HIERAR%';
select * from V_MERCH_HIERARCHY where division = '1'  order by DEPT_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME from V_MERCH_HIERARCHY where division = '2'  order by DEPT_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME,CLASS, CLASS_NAME from V_MERCH_HIERARCHY where division = '2' and dept = '2014' order by CLASS_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME,CLASS, CLASS_NAME,SUBCLASS, SUB_NAME from V_MERCH_HIERARCHY where dept = '2014' and class = '11' and division = '2' order by SUB_NAME;


select * from ma_asos.ma_system_options;
select * from all_tables where table_name like '%%';
