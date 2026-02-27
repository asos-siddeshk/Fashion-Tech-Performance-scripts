set SERVEROUTPUT ON;
set timing ON;
begin
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='3001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4013' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='6001' and rownum < ='1200000';
commit;
end;
/

set SERVEROUTPUT ON;
set timing ON;
begin
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.3,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.3,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='3001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.3,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.3,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='6001' and rownum < ='1200000';
commit;
end;
/

select LOC,count(1) from int_asos.INT_WAC_SNAP_B group by LOC;
select LOC,count(1) from int_asos.INT_WAC_SNAP_A group by LOC;

10334838
10334812
10334815
3566421

INT_WAC_SNAP_A

truncate table int_asos.INT_WAC_SNAP_DNLD;
truncate table int_asos.INT_WAC_SNAP_A;
truncate table int_asos.INT_WAC_SNAP_B;


INT_WAC_SNAP_SQL.PROCESS_PARTITION
 from int_asos.INT_WAC_SNAP_A;
select * from int_asos.INT_WAC_SNAP_B;

int_asos.INT_WAC_SNAP_A;

select * from RMS.RPM_BATCH_CONTROL;
select * from rms.restart_program_status where PROGRAM_STATUS!='ready for start';

select * from rms.restart_program_status where restart_name like 'nb_wac_snap_dnld%' order by 3 desc;
select * from restart_program_history where restart_name like 'nb_wac_snap_dnld' order by 3 desc;
select * from rms.restart_control where program_name like 'nb_wac_snap_dnld';
select * from restart_bookmark where restart_name like 'nb_wac_snap_dnld';

select * from int_asos.INT_WAC_SNAP_DNLD;
select * from int_asos.INT_WAC_SNAP_B;

select loc,count(1) from int_asos.INT_WAC_SNAP_B group by LOC;
select LOC,count(1) from int_asos.INT_WAC_SNAP_A group by LOC;


1001	10334838
3001	10334812
4001	10334815
6001	3566421

insert into int_asos.INT_WAC_SNAP_B
select ITEM, LOC, LOC_TYPE, AV_COST-0.2, UNIT_COST, STOCK_ON_HAND,LAST_UPDATE_DATETIME, 'WACSNAPBAT' LAST_UPDATE_ID,'20-DEC-21' SNAPSHOT_DATETIME 
    from item_loc_soh ils where ils.loc = '6001' and trunc(CREATE_DATETIME) <= '01-MAR-22'
    and not exists (select 1 from rms.INT_WAC_SNAP_B iwa where iwa.item = ils.item and iwa.loc = ils.loc) and rownum <= '2000000';

select * from item_loc_soh ils where ils.loc = '1001' and trunc(CREATE_DATETIME) <= '01-MAR-22'
    and not exists (select 1 from rms.INT_WAC_SNAP_B iwa where iwa.item = ils.item and iwa.loc = ils.loc) and rownum <= '2000000';


  1347268 nb_wac_snapshot_1001_20230630105317.dat
  1378571 nb_wac_snapshot_3001_20230630105317.dat
  1375549 nb_wac_snapshot_4001_20230630105317.dat
  1331306 nb_wac_snapshot_6001_20230630105317.dat


select * from int_asos.INT_WAC_SNAP_DNLD;

insert into int_asos.INT_WAC_SNAP_DNLD  
select ITEM, LOC, 'GBP' as CURRENCY_CODE, AV_COST, UNIT_COST, STOCK_ON_HAND, LAST_UPDATE_DATETIME as CREATE_DATETIME from int_asos.INT_WAC_SNAP_B where loc = '6001';


select * from wh;