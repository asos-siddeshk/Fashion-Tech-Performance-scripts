set SERVEROUTPUT ON;
set timing ON;
begin
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1011' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='3001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4011' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4012' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1015' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1014' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_A set AV_COST = AV_COST-0.1,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4013' and rownum < ='1200000';
commit;
end;
/

set SERVEROUTPUT ON;
set timing ON;
begin
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1011' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='3001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4001' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4011' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4012' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1015' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='1014' and rownum < ='1200000';
Update int_asos.INT_WAC_SNAP_B set AV_COST = AV_COST-0.2,LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID ='WACSNAPBAT' where loc ='4013' and rownum < ='1200000';
commit;
end;
/

select LOC,count(1) from int_asos.INT_WAC_SNAP_B group by LOC;
select LOC,count(1) from int_asos.INT_WAC_SNAP_A group by LOC;

