select distinct sh.SKULIST, sh.SKULIST_DESC, DIVISION, DEPT, CLASS, SUBCLASS from rms.skulist_detail sd, rms.skulist_head sh, rms.v_item_master im 
    where sh.skulist = sd.skulist and sh. sKULIST_DESC like 'Mass Search%' and sd.item = im.item order by DEPT;
select * from v_deps where DIVISION = '2' order by 4;
145081,1,22,5,3
145088,1,24,9,1
145093,1,19,4,1
145094,1,19,2,1
145089,1,19,3,1
145096,1,19,1,2
145076,1,32,3,12
145083,1,32,1,2
145100,1,32,1,6
145073,1,8,1,1
145090,2,36,2,7
145077,2,34,3,3
145099,2,33,5,1
145086,2,24,3,5
145087,2,24,9,12
145085,2,22,5,5
145097,2,39,2,1
145084,2,25,1,1
145080,2,18,3,1
145098,2,35,5,1
145091,2,35,8,1
145078,2,10,1,3
145092,2,7,2,7
145074,2,8,3,1
145101,2,11,2,1
145082,2,27,3,11
145075,2,27,1,6


 -- Completed
select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 20 order by count(distinct(order_no));
0,12,3,0
1,19,1,8
0,20,1,0
1,31,1,8
0,5,3,0
 -- Completed
select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 50 order by count(distinct(order_no));
1,23,2,2
1,37,1,2
1,5,4,3
0,6,4,2
0,12,17,0

 -- Completed
select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 100 order by count(distinct(order_no));
1,7,2,0
1,11,4,2
0,16,4,0
1,37,1,6
1,17,1,2

-- Completed
select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 150 order by count(distinct(order_no));
0,20,3,0
1,19,1,2
1,7,13,0
1,23,1,4
0,40,1,0

select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 250 order by count(distinct(order_no));
0,6,10,1
1,31,0,2
1,11,4,1
0,9,6,1
0,37,2,0


select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 500 order by count(distinct(order_no));
1,11,5,0
0,16,5,0
0,6,9,3
0,5,12,0
1,35,0,0


select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 1000 order by count(distinct(order_no));
0,36,5,0
0,14,6,0
1,11,6,0
0,9,9,0


select DIVISION, DEPT, CLASS, SUBCLASS,count(distinct(order_no)) 
    from orditemloc_d group by DIVISION, DEPT, CLASS, SUBCLASS having count( distinct (order_no)) > 2000 order by count(distinct(order_no));
1,35,10,0   
0,9,4,2
