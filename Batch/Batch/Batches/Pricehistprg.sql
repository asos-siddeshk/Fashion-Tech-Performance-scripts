select * from ALL_TAB_PARTITIONS where lower(table_name) like'price_hist';

SELECT count(ROWID) FROM 
(SELECT /* parallel(ph) */
      ROWID,Row_number() over (
        PARTITION BY item, loc, tran_type 
        ORDER BY action_date DESC
      ) AS action_date_rank FROM 
      rms.price_hist PARTITION (PRICE_HIST_P09) ph 
    where post_date < (To_date('20221231', 'YYYYMMDD') - '762')) 
where action_date_rank > 1 ;

select TABLE_NAME, PARTITION_NAME, NUM_ROWS, HIGH_VALUE from ALL_TAB_PARTITIONS where lower(table_name) like'price_hist' AND NUM_ROWS >= '16007308';

SELECT count(ROWID) FROM 
(SELECT /* parallel(ph) */
      ROWID,Row_number() over (
        PARTITION BY item, loc, tran_type 
        ORDER BY action_date DESC
      ) AS action_date_rank FROM 
      rms.price_hist PARTITION (PRICE_HIST_P12) ph 
    where post_date < (To_date('20221231', 'YYYYMMDD') - '762')) 
where action_date_rank > 1 ; 

Volumes of records which will be purged until next 2022 dec.
-- PRICE_HIST_P09 -- 7130263 -- 1001
-- PRICE_HIST_P21 -- 7719199 -- 20001
-- PRICE_HIST_P28 -- 7409627 -- 20008
-- PRICE_HIST_P26 -- 7981839 -- 20006
-- PRICE_HIST_P10 -- 4647541 -- 1011
-- PRICE_HIST_P14 -- 6948572 -- 4001
-- PRICE_HIST_P12 -- 6914433 -- 3001
-- PRICE_HIST_P15 -- 4369172 -- 4011

       
select PRICE_HIST_RETENTION_DAYS from PURGE_CONFIG_OPTIONS;
update  PURGE_CONFIG_OPTIONS set PRICE_HIST_RETENTION_DAYS='586';

select /*+ parallel(8) */ count(1), post_date--, (post_date+588) earliest_purge_date 
  from price_hist group by post_date order by post_date;


select /*+ parallel(8) */  count(*)
 from rms.price_hist ph
where ph.post_date <
(select p.vdate-so.price_hist_retention_days from rms.system_options so,rms.PERIOD p);

select /*+ parallel(8) */ count(*)
  from rms.price_hist ph
where ph.post_date < ( TO_DATE('20210510', 'YYYYMMDD') - (select so.price_hist_retention_days from rms.system_options so));

select /*+ parallel(8) */ *
  from rms.price_hist ph
where ph.post_date < ( TO_DATE('20210510', 'YYYYMMDD') - (select so.price_hist_retention_days from rms.system_options so));


select /*+ parallel(8) */ *
  from rms.price_hist ph
where ph.post_date < ( TO_DATE('20210510', 'YYYYMMDD') - (select so.price_hist_retention_days from rms.system_options so));


 select im.ITEM_ID, '3' as tsf_qty
    from skumar.cust_tsf_upld im 
      where FROM_LOC= '1001' 
          AND not exists (select 1 from rms.tsfdetail td, tsfhead th where th.tsf_no >= '7268409004' and
                    th.tsf_no = td.tsf_no and td.item = im.item_id and th.from_loc= '1001')
          AND rownum<= 7 ORDER BY DBMS_RANDOM.VALUE;


  select finisher_ind
        from wh
       where wh = '1001';
       
--create table PRICE_HIST_P26 as

select * from (SELECT item, loc, tran_type, ACTION_DATE, POST_DATE, /* parallel(ph) */ ROWID, ROW_NUMBER() OVER 
                       (PARTITION BY item, loc, tran_type 
                       ORDER BY action_date DESC) AS action_date_rank 
                FROM price_hist PARTITION (PRICE_HIST_P26) ph )
            WHERE action_date_rank > 1 
            order by ACTION_DATE;

select * from 
(SELECT item, loc, tran_type, ACTION_DATE, POST_DATE, /* parallel(ph) */ ROWID, ROW_NUMBER() OVER 
                       (PARTITION BY item, loc, tran_type 
                       ORDER BY action_date DESC) AS action_date_rank 
                FROM price_hist where item ='4111243')
                WHERE post_date < (TO_DATE('20210511', 'YYYYMMDD') - '588')
            order by ACTION_DATE;
                   
SELECT 
  count(ROWID) FROM (
    SELECT /* parallel(ph) */
      ROWID,Row_number() over (
        PARTITION BY item, loc, tran_type 
        ORDER BY action_date DESC
      ) AS action_date_rank 
    FROM 
      rms.price_hist PARTITION (PRICE_HIST_P26) ph 
    where post_date < ((select p.vdate-so.price_hist_retention_days from rms.system_options so,rms.PERIOD p))) 
where action_date_rank > 1 ;
        
--10-MAY-21 -- 12-MAY-23
                                   
select * from price_hist where tran_type ='2';
select * from price_hist where item ='11177342';
select * from price_hist where item ='4111243' and loc = '1001';


update price_hist set POST_DATE = TO_DATE('20191001', 'YYYYMMDD') where item ='9355760';
 and POST_DATE  between '02-MAR-20' and '25-MAR-20';
update price_hist set POST_DATE = '02-OCT-19' where item ='9355760' and POST_DATE  between '15-MAR-20' and '18-MAR-20';



select /*+ parallel(8) */  count(*)
 from rms.price_hist ph
where ph.post_date <
(trunc(sysdate) -600);



       update price_hist 
          set POST_DATE = ACTION_DATE,CREATE_DATETIME = sysDATE
        where trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD') 
          and loc = '1001'  
          and rownum <= 5000;

      update price_hist 
         set POST_DATE = ACTION_DATE,
             CREATE_DATETIME = sysDATE
       where trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD') 
         and trunc(CREATE_DATETIME) <  TO_DATE('20211029','YYYYMMDD') 
         and loc = '1001'  
         and rownum <= 5000;


select * from price_hist 
       where trunc(ACTION_DATE) = TO_DATE(POST_DATE) 
         and trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD') 
         and loc = '1001'  
         and rownum <= 5000;

s
select FROM_LOC,count(1)  from rms.tsfhead td
    where td.tsf_no in (select tsf_no from skumar.iwtdispath_cls) group by FROM_LOC;


select SYSTIMESTAMP,count(1) from price_hist where loc ='1001' and trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD');
select SYSTIMESTAMP,count(1) from price_hist where loc ='3001' and trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD');
select SYSTIMESTAMP,count(1) from price_hist where loc ='4001' and trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD');


select count(1) from price_hist where loc ='1001' and trunc(CREATE_DATETIME) =(TO_DATE('20210511','YYYYMMDD');
select count(1) from price_hist where loc ='1001' and trunc(CREATE_DATETIME) = trunc(sysDATE);
select count(1) from price_hist where loc ='20000' and trunc(CREATE_DATETIME) = trunc(sysDATE);


select /*+ parallel(8) */
    count(1),post_date,(post_date+588) earliest_purge_date from price_hist where loc ='1001' group by post_date order by post_date;



set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 5000;
  n_from_loc            rms.tsfhead.from_loc%TYPE ;
  l_date                rms.period.vdate%type         := '30-SEP-2019';
  l_cdate                rms.period.vdate%type         := '28-OCT-2021';

  CURSOR cur_loc IS 	
     select wh from rms.wh wh where STOCKHOLDING_IND = 'Y' and wh in ('1014','4013','4011','4012','1015','1011','4001','1001','3001') 
       union
     select store as wh from store where store in ('10001','10004','20000','20003','20002','20005','20007','20012','20010','20011','20014','10003','20004','20013','20009','20008','20001','20006');

BEGIN

       for n in 0..2 loop
       for k in 0..500 loop
       for i in cur_loc loop
            n_from_loc := i.wh;

--  dbms_output.put_line('n_from_loc      :'||n_from_loc);
--  dbms_output.put_line('START      :'||systimestamp);

 
 
      update price_hist 
         set POST_DATE = ACTION_DATE,
             CREATE_DATETIME = sysDATE
       where trunc(POST_DATE) = TO_DATE('20190930','YYYYMMDD')  
         and trunc(CREATE_DATETIME) <  TO_DATE('20211027','YYYYMMDD') 
         and loc = n_from_loc  
         and rownum <= num_rec;

--  dbms_output.put_line('End        :'||systimestamp);
--  dbms_output.put_line('l_date      :'||l_date);

  END LOOP;
 commit;
  END LOOP;
 commit;
  END LOOP;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END; 
/


 insert into price_hist
 select TRAN_TYPE, REASON, EVENT, ITEM, LOC, LOC_TYPE, UNIT_COST, UNIT_RETAIL, SELLING_UNIT_RETAIL, SELLING_UOM, ACTION_DATE-10, MULTI_UNITS, MULTI_UNIT_RETAIL, MULTI_SELLING_UOM,  ACTION_DATE-10 as post_DATE, 'PRCHIST' as CREATE_ID, sysDATE as CREATE_DATETIME
    from price_hist 
       where trunc(ACTION_DATE)= TO_DATE(POST_DATE) 
         and trunc(POST_DATE)= TO_DATE('20190930','YYYYMMDD')
         and CREATE_ID!='PRCHIST'
         and loc = '1001'
         and rownum <= '5000';


SELECT count(ROWID) FROM 
(SELECT /* parallel(ph) */
      ROWID,Row_number() over (
        PARTITION BY item, loc, tran_type 
        ORDER BY action_date DESC
      ) AS action_date_rank FROM 
      rms.price_hist PARTITION (PRICE_HIST_P09) ph 
    where post_date < (To_date('20221231', 'YYYYMMDD') - '762')) 
where action_date_rank > 1 ;

--PRICE_HIST_P09	1001


set serveroutput on;
set timing on;

DECLARE
  num_rec               NUMBER(10)                    := 5000;
  n_from_loc            rms.tsfhead.from_loc%TYPE ;

  CURSOR cur_loc IS 	
     select wh from rms.wh wh where STOCKHOLDING_IND = 'Y' and wh in ('1014','4013','4011','4012','1015','1011','4001','1001','3001') 
       union
     select store as wh from store where store in ('10001','10004','20000','20003','20002','20005','20007','20012','20010','20011','20014','10003','20004','20013','20009','20008','20001','20006');

BEGIN

       for k in 0..500 loop
       for i in cur_loc loop
            n_from_loc := i.wh;
--  dbms_output.put_line('n_from_loc      :'||n_from_loc);
--  dbms_output.put_line('START      :'||systimestamp);
 
     insert into price_hist

 select TRAN_TYPE, REASON, EVENT, ITEM, LOC, LOC_TYPE, UNIT_COST, UNIT_RETAIL, SELLING_UNIT_RETAIL, SELLING_UOM, ACTION_DATE-10, 
         MULTI_UNITS, MULTI_UNIT_RETAIL, MULTI_SELLING_UOM,  ACTION_DATE-10 as post_DATE, 'PRCHIST' as CREATE_ID, sysDATE as CREATE_DATETIME
    from price_hist 
       where trunc(ACTION_DATE)= TO_DATE(POST_DATE) 
         and trunc(POST_DATE)= TO_DATE('20190930','YYYYMMDD')
         and CREATE_ID!='PRCHIST'
         and loc = n_from_loc  
         and rownum <= num_rec;

--  dbms_output.put_line('End        :'||systimestamp);
--  dbms_output.put_line('l_date      :'||l_date);
  END LOOP;
 commit;
  END LOOP;
 commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END; 
/


