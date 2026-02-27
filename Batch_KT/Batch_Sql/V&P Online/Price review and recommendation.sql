select vim.division,mvim.business_model,mvim.BUYING_GROUP, mvim.BUYING_SUBGROUP, mvim.BUYING_SET,mvim.dept, count(im.item)  from item_master im
    inner join rms.v_item_master vim on vim.item=im.item
    inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
where im.item_level='1' and im.status ='A' and im.dept not in ('2008')
    group by vim.division,mvim.business_model,mvim.BUYING_GROUP, mvim.BUYING_SUBGROUP, mvim.BUYING_SET,mvim.dept
        having count(1) between 100 and 200;
        
select vim.division,mvim.business_model,mvim.dept, count(im.item)  from item_master im
    inner join rms.v_item_master vim on vim.item=im.item
    inner join ma_asos.ma_v_item mvim on mvim.item=vim.item
where im.item_level='1' and im.status ='A' --and im.dept not in ('2008')
    group by vim.division,mvim.business_model,mvim.dept
        having count(1) between 75 and 150;
                

select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME from V_MERCH_HIERARCHY where division = '1'  order by DEPT_NAME;
select * from all_views where view_name like '%BUS%';
select * from MA_ASOS.MA_V_BUSINESS_MODEL order by BUSINESS_MODEL_NAME;

select * from V_MERCH_HIERARCHY where division = '1'  order by DEPT_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME from V_MERCH_HIERARCHY where division = '1'  order by DEPT_NAME;
select distinct DIVISION, DIV_NAME, DEPT, DEPT_NAME,CLASS, CLASS_NAME from V_MERCH_HIERARCHY where division = '1' and dept = '1158' order by CLASS_NAME;


 --25-JUN-22
 

select status,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '21-MAY-21' group by status;
select LOCATION,status,EFFECTIVE_DATE,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '21-MAY-21' group by LOCATION,status,EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1; --
select * from ma_asos.ma_stage_price_change where trunc(CREATE_DATETIME)> = '21-MAY-21';
delete from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete from ma_asos.ma_stage_price_change where status='N';
delete from ma_asos.ma_price_change where trunc(CREATE_DATETIME)> = '21-MAY-21' AND CREATE_ID likE 'PTESTUSER%';





1	1	1113	90
1	2	1110	103
1	7	1002	109
1	3	1108	90
1	7	1052	103
1	6	1057	77
1	3	1112	113
1	3	1113	96
1	3	1150	142

0,0,7
0,1,3
0,6,21
0,2,5
0,6,18
0,5,27
0,2,0
0,2,7
0,2,23


2	6	2016	106
2	6	2114	86
2	6	2150	150
2	6	2156	110
2	1	2108	96
2	4	2159	119
2	4	2105	116
2	6	2113	144
2	6	2105	98
2	6	2115	87
2	2	2008	80

1,5,37
1,5,7
1,5,13
1,5,11
1,0,1
1,3,22
1,3,6
1,5,5
1,5,6
1,5,8
1,1,20

Ol

1,3,32
1,5,13
1,5,0
1,5,1
1,5,5
1,3,1
0,2,24
0,2,13
0,1,12
