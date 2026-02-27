select  DAY_DATE, LOC, SNAP_ID, count(1) from INT_ASOS.INT_AUTO_CORRECTION_STG where DAY_DATE= '16-JAN-24' group by DAY_DATE, LOC, SNAP_ID;
select loc,STATUS, ERROR_MSG, count(1) from INT_ASOS.INT_AUTO_CORRECTION_STG where DAY_DATE= '20-FEB-24' group by loc, STATUS, ERROR_MSG  order by loc, STATUS, ERROR_MSG;

select distinct SNAP_ID,FILENAME, SOURCE, LOC ,count(1) from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '20-FEB-24' group by SNAP_ID,FILENAME, SOURCE, LOC  ORDER by SNAP_ID, LOC ; 
 
select distinct SNAP_ID,FILENAME, LOC ,count(1) from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '20-FEB-24' group by SNAP_ID,FILENAME, LOC  ORDER by SNAP_ID, LOC ; 


SELECT * FROM nb_system_parameters WHERE FUNC_AREA='STOCK_RECON' AND PARAMETER='STOCK_RECON_DATE';
SELECT * FROM nb_system_parameters WHERE FUNC_AREA='NB_STOCK_ADJUST';
SELECT * FROM nb_system_parameters WHERE FUNC_AREA='STOCK_RECON';

update nb_system_parameters set VALUE_1 ='20230226' WHERE FUNC_AREA='STOCK_RECON' AND PARAMETER='STOCK_RECON_DATE';
update nb_system_parameters np2 set VALUE_1='29000' WHERE np2.func_area = 'NB_STOCK_ADJUST' AND parameter = 'SKU_LEVEL_THRESHOLD'; --5000
update nb_system_parameters np2 set VALUE_1='29000' WHERE np2.func_area = 'NB_STOCK_ADJUST' AND parameter = 'LOCATION_LEVEL_THRESHOLD'; --300

select * from all_tab_partitions where table_name like 'INT_EXT_STOCK_SNAPSHOT_STG';
select * from all_tab_partitions where table_name like '%EXT_STOCK_SNAPSHOT%';



RMS_STOCK_BUCKET_CORRECTION


SELECT value_1  --20210508
  FROM nb_system_parameters
 WHERE FUNC_AREA='STOCK_RECON' AND PARAMETER='STOCK_RECON_DATE';



 MERGE INTO nb_system_parameters trg
            USING (
                      SELECT
                          'STOCK_RECON' func_area,
                          'STOCK_RECON_DATE' parameter,
                          to_char(get_vdate,'YYYYMMDD') vdate
                      FROM
                          dual
                  )
            src ON ( trg.func_area = src.func_area
                    AND trg.parameter = src.parameter )
            WHEN MATCHED THEN UPDATE
            SET trg.value_1 = src.vdate,
                trg.last_update_id = user,
                trg.last_update_date = sysdate;
      COMMIT;
      





select * from int_asos.INT_BATCH_QUEUE;

delete from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_stock_snapshot';
update int_asos.INT_BATCH_QUEUE set status ='N' where SEQ_NO='17345';


truncate table INT_ITEM_LOC_SOH_AU_TMP;
truncate table INT_INV_STATUS_QTY_AU_TMP;



--ils_snap

SELECT value_1
FROM nb_system_parameters
WHERE FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';

select * from int_asos.INT_ITEM_LOC_SOH_AU_TMP; -- 1549480 // 10 48 330

select count(1) from int_asos.INT_ITEM_LOC_SOH_AU_TMP; -- 1549480 // 10 48 330
select count(1) from int_asos.INT_ITEM_LOC_SOH_AU_A; 
select count(1) from int_asos.INT_ITEM_LOC_SOH_AU_B;

--inv_snap

SELECT value_3
FROM nb_system_parameters
WHERE FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';

INT_INV_STATUS_QTY_AU_A
select count(1) from int_asos.INT_INV_STATUS_QTY_AU_TMP; -- 664334 /482428
select count(1) from int_asos.INT_INV_STATUS_QTY_AU_A; --  3658707
select * from int_asos.INT_INV_STATUS_QTY_AU_B;


select * from int_asos.INT_EXT_STOCK_SNAPSHOT_STG;


      SELECT value_1 --already in YYYYMMDD format
          FROM nb_system_parameters
          WHERE FUNC_AREA='STOCK_RECON' AND PARAMETER='STOCK_RECON_DATE';


     SELECT value_2 -- Audit view time switch
          FROM nb_system_parameters
          WHERE FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';

     update nb_system_parameters set value_2 = TO_DATE('2021-11-09 04:00:16','YYYY-MM-DD HH:mi:ss') 
                 WHERE FUNC_AREA='NB_STOCK_ADJUST' AND PARAMETER='LAST_VIEW_SWITCH_TS';
          

      SELECT TO_CHAR(MIN(SNAPSHOT_TIMESTAMP),'YYYY-MM-DD HH24:mi:ss') min_snapshot_ts --2021-11-10 00:00:00
          FROM int_asos.INT_EXT_STOCK_SNAPSHOT_STG stg
          WHERE stg.day_date = to_date('20211110','YYYYMMDD')
                and stg.snap_id = '3588'
                and stg.source ='EXT';

--2021-11-10 04:00:16
--2021-05-08 13:20:23
select * from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_stock_snapshot';
delete from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_stock_snapshot' and status!='N';

update int_asos.INT_BATCH_QUEUE set status ='N' where SEQ_NO='17345';


select * from int_asos.INT_EXT_STOCK_SNAPSHOT_STG;
select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21';
select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21' and item  in ('8557802','10442435');

select distinct SNAP_ID,FILENAME, SOURCE, LOC ,count(1) from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21'
 group by SNAP_ID,FILENAME, SOURCE, LOC 
ORDER by SOURCE, LOC ; 



select SNAP_ID,FILENAME from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21' and item ='10039323' and loc ='1001' and source = 'EXT';
--select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and item ='10039323' and loc ='1001' and source = 'EXT';


select distinct SNAP_ID,FILENAME, SOURCE, LOC ,count(1) from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21'
 group by SNAP_ID,FILENAME, SOURCE, LOC 
ORDER by SOURCE, LOC ; 

Drop table STOCK_SNAPSHOT_STG_07092021;
create table STOCK_SNAPSHOT_STG_07092021 as
select distinct SNAP_ID,FILENAME, SOURCE, LOC ,count(1) as count  from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21'
 group by SNAP_ID,FILENAME, SOURCE, LOC 
ORDER by SOURCE, LOC ; 

select * from STOCK_SNAPSHOT_STG_07092021;



select * from all_sequences where sequence_name like '%SNAP%' ;

select INT_ASOS.INT_STOCK_SNAPSHOT_SEQ.nextval from dual; -1875

select * from STOCK_SNAPSHOT_STG_08092021 where SOURCE ='EXT';

select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21'; -- 

select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21' and SNAP_ID = '1885'; -- 



select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21' and SNAP_ID = '1881';
select * from INT_ASOS.INT_BATCH_QUEUE order by SEQ_NO desc;


--- INT_AUTO_CORRECTION_STG

      SELECT value_1 --already in YYYYMMDD format
      FROM nb_system_parameters
      WHERE FUNC_AREA='STOCK_RECON' AND PARAMETER='STOCK_RECON_DATE';


select * from INT_ASOS.INT_AUTO_CORRECTION_STG;
select * from INT_ASOS.INT_AUTO_CORRECTION_LOG;
select * from INT_ASOS.int_auto_correction_helper_gtt;



select * from int_asos.INT_BATCH_QUEUE where seq_no >'15255';

select distinct SNAP_ID,FILENAME, SOURCE, LOC ,count(1) from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '09-NOV-21' group by SNAP_ID,FILENAME, SOURCE, LOC ORDER by SOURCE, LOC ; 

select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE='10-NOV-21' and SNAP_ID = '1904' and SOURCE='EXT'; 
update INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG set QTY=QTY+2  where DAY_DATE= '10-NOV-21' and SNAP_ID = '1904' and SOURCE='EXT' and rownum <= '90000';

select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE='10-NOV-21' and SNAP_ID = '1905' and SOURCE='EXT'; 
update INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG set QTY=QTY+4  where DAY_DATE= '10-NOV-21' and SNAP_ID = '1905' and SOURCE='EXT' and rownum <= '24000';

select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE='10-NOV-21' and SNAP_ID = '1906' and SOURCE='EXT'; 
update INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG set QTY=QTY+5  where DAY_DATE= '10-NOV-21' and SNAP_ID = '1906' and SOURCE='EXT' and rownum <= '95000';

select * from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21';
select * from INT_ASOS.INT_AUTO_CORRECTION_STG where DAY_DATE= '10-NOV-21';

select  DAY_DATE, LOC, SNAP_ID, count(1) from INT_ASOS.INT_AUTO_CORRECTION_STG where DAY_DATE= '10-NOV-21' group by DAY_DATE, LOC, SNAP_ID;
select loc,STATUS, ERROR_MSG, count(1) from INT_ASOS.INT_AUTO_CORRECTION_STG where DAY_DATE= '10-NOV-21' group by loc, STATUS, ERROR_MSG  order by loc, STATUS, ERROR_MSG;

select * from INT_ASOS.INT_AUTO_CORRECTION_LOG where DAY_DATE= '10-NOV-21';

select loc,STATUS, ERROR_MSG, count(1) from INT_ASOS.INT_AUTO_CORRECTION_LOG where DAY_DATE= '10-NOV-21' group by loc, STATUS, ERROR_MSG  order by loc, STATUS, ERROR_MSG;
select distinct SNAP_ID,FILENAME, SOURCE, LOC ,count(1) from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '10-NOV-21' group by SNAP_ID,FILENAME, SOURCE, LOC ORDER by LOC; 

select * from int_asos.INT_BATCH_QUEUE where seq_no >'15255';
select * from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_stock_snapshot';
delete from int_asos.INT_BATCH_QUEUE where BATCH_NAME= 'nb_stock_snapshot' and status!='N';

update int_asos.INT_BATCH_QUEUE set status ='L' where SEQ_NO='17347';

3588	FC04_InventorySnapshot_20211110230022.csv	4001

---------------------------------------------------------
--1862	Barnsley_InventorySnapshot_20210507231000.csv	928242

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS, 
 'Barnsley_InventorySnapshot_20210511231000.csv' FILENAME, '10-NOV-21' as CREATE_DATETIME, '1885' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as  ADJ_TIMESTAMP_IN_RMS
 from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1862' and SOURCE='EXT';

insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) 
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','1001','1885','N','Barnsley_InventorySnapshot_20210511231000.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
    from dual ;

---------------------------------------------------------
--1865	BIDATA.FC03.20210507232819280.csv	716163

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS, 
 'BIDATA.FC03.20210511232819280.csv' FILENAME, '10-NOV-21' as CREATE_DATETIME, '1886' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as  ADJ_TIMESTAMP_IN_RMS
 from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1865' and SOURCE='EXT';

insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) 
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','3001','1886','N','BIDATA.FC03.20210511232819280.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
    from dual ;

---------------------------------------------------------
1860	FC04_InventorySnapshot_20210508000053.csv	888921

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS, 
 'FC04_InventorySnapshot_20210511000053.csv' FILENAME, '10-NOV-21' as CREATE_DATETIME, '1887' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as  ADJ_TIMESTAMP_IN_RMS
 from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1860' and SOURCE='EXT';

insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE) 
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','4001','1887','N','FC04_InventorySnapshot_20210511000053.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
    from dual ;
---------------------------------------------------------





--1863 RC11_InventorySnapshot_20210507230500.csv 207027

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS,
'RC11_InventorySnapshot_20210511230500.csv' FILENAME, CREATE_DATETIME, '1904' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as ADJ_TIMESTAMP_IN_RMS
from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1863' and SOURCE='EXT';

insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE)
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','1011','1904','N','RC11_InventorySnapshot_20210511230500.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
from dual ;

----------------------------------------------------------------
--1864 InventorySnapshot.SC12.20210507230043733.csv 55907

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS,
'InventorySnapshot.SC12.20210510230043733.csv' FILENAME, CREATE_DATETIME, '1905' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as ADJ_TIMESTAMP_IN_RMS
from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1864' and SOURCE='EXT';


insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE)
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','1014','1905','N','InventorySnapshot.SC12.20210510230043733.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
from dual ;

----------------------------------------------------------------
--1858 RC13_InventorySnapshot_20210507230429.csv 188004

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS,
'RC13_InventorySnapshot_20210510230429.csv' FILENAME, CREATE_DATETIME, '1906' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as ADJ_TIMESTAMP_IN_RMS
from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1858' and SOURCE='EXT';


insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE)
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','1015','1906','N','RC13_InventorySnapshot_20210510230429.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
from dual ;

----------------------------------------------------------------
--1857 RC41_InventorySnapshot_20210508000323.csv 38885

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS,
'RC41_InventorySnapshot_20210510000323.csv' FILENAME, CREATE_DATETIME, '1907' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as ADJ_TIMESTAMP_IN_RMS
from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1857' and SOURCE='EXT';


insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE)
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','4011','1907','N','RC41_InventorySnapshot_20210510000323.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
from dual ;

----------------------------------------------------------------
--1861 RC42_InventorySnapshot_20210507230500.csv 60806

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS,
'RC42_InventorySnapshot_20210510230500.csv' FILENAME, CREATE_DATETIME, '1908' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as ADJ_TIMESTAMP_IN_RMS
from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1861' and SOURCE='EXT';


insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE)
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','4012','1908','N','RC42_InventorySnapshot_20210510230500.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
from dual ;

----------------------------------------------------------------
--1859 RC43_InventorySnapshot_20210507230444.csv 70099

insert into INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG
select '10-NOV-21' as DAY_DATE, SOURCE, ITEM, LOC, LOC_TYPE, QTY, DISPOSITION, '10-NOV-21' as SNAPSHOT_TIMESTAMP, STATUS,
'RC43_InventorySnapshot_20210510230444.csv' FILENAME, CREATE_DATETIME, '1909' as SNAP_ID, null as ADJ_QTY_IN_RMS,null as ADJ_TIMESTAMP_IN_RMS
from INT_ASOS.INT_EXT_STOCK_SNAPSHOT_STG where DAY_DATE= '07-MAY-21' and SNAP_ID = '1859' and SOURCE='EXT';


insert into int_asos.INT_BATCH_QUEUE (SEQ_NO, BATCH_NAME, KEY_1, KEY_2, STATUS,EXT_REF_NO, REQUEST_TYPE,CREATE_ID, CREATE_DATE, LAST_UPDATE_ID, LAST_UPDATE_DATE)
select INT_ASOS.INT_BATCH_QUEUE_SEQ.nextval,'nb_stock_snapshot','4013','1909','N','RC43_InventorySnapshot_20210510230444.csv','T','INT_ASOS',sysdate,'INT_ASOS',sysdate
from dual ;

----------------------------------------------------------------











      SELECT *--//already in YYYYMMDD format
          FROM nb_system_parameters
          WHERE FUNC_AREA='STOCK_RECON' AND PARAMETER='STOCK_RECON_DATE';




