
select tran_date,count(1) from rms.TRAN_DATA_HISTORY group by tran_date order by 1;  


/*
---------------------------Batch name:RMS.salprg----------------------------------
2.Records to be removed from in rms.key_map_gl tables,rms.TRAN_DATA_HISTORY			
3.Batch execution 														            :RMS.salprg via Automic.
--------------------------------------------------------------------------------------------------
*/

alter session set current_schema=rms;

set serveroutput on;
set timing on;

 DECLARE

V_Dept        Rms.Tran_Data.Dept%Type;
V_Loc         Rms.Tran_Data.Location%Type;
V_Tran_Code   Rms.Tran_Data.Tran_Code%Type;
V_Class       Rms.Tran_Data.Class%Type;
V_Subclass    Rms.Tran_Data.Subclass%Type;
V_Units       Rms.Tran_Data.Units%Type;
V_Loc_Type    Rms.Tran_Data.Loc_Type%Type;
v_item        Rms.Tran_Data.item%Type;
V_Total_Cost  Rms.Tran_Data.TOTAL_COST%Type;
V_TOTAL_RETAIL Rms.Tran_Data.TOTAL_RETAIL%Type;


cursor C_item is
select DEPT,item,
location,
TRAN_CODE,
CLASS,
SUBCLASS,
LOC_TYPE,
UNITS,
Total_Cost,
TOTAL_RETAIL
from RMS.TRAN_DATA where rownum<=5;
 
BEGIN
dbms_output.put_line('begin'||SYSTIMESTAMP);

for i in C_item loop 

    v_dept:=I.dept;
    v_loc:=I.LOCATION;
    v_tran_code:=I.tran_code;
    v_class:=I.CLASS;
    v_subclass:=I.subclass;
    v_units:=I.units;
    V_Loc_Type:=i.LOC_TYPE;
    v_tran_code:=i.tran_code;
    v_item:=i.item;
    V_Total_Cost:=i.Total_Cost;
    V_TOTAL_RETAIL:=i.TOTAL_RETAIL;
    
    
insert into rms.TRAN_DATA_HISTORY (DEPT,            
                                    CLASS    ,            
                                    SUBCLASS ,            
                                    LOC_TYPE ,            
                                    LOCATION ,            
                                    TRAN_DATE,            
                                    POST_DATE,                                         
                                    UNITS    ,
                                    TRAN_CODE,
                                    TRAN_DATA_TIMESTAMP,
                                    PGM_NAME)            
                            values(V_Dept,
                                   v_class,
                                   V_SUBCLASS,
                                   V_Loc_Type,
                                   v_loc,
                                ADD_MONTHS(SYSDATE,-50),
                                ADD_MONTHS(SYSDATE,-50),
                                v_units,
                                v_tran_code,
                                ADD_MONTHS(SYSDATE,-50),
                                'STOCK_ORDER_RCV_SQL.DETAIL_PROCESSING'
                              );
                                
INSERT INTO rms.key_map_gl (REFERENCE_TRACE_ID,
                            REFERENCE_TRACE_TYPE,
                            DEPT,
                            PROCESSED_DATE,
                            LOCATION,
                            LOC_TYPE,
                            COST_RETAIL_FLAG,
                            PGM_NAME)
                VALUES(RMS.TRACE_REFKEY_SEQUENCE.NEXTVAL,
                          'GID',
                          v_dept,
                          ADD_MONTHS(SYSDATE,-50),
                          V_LOC,
                          'W',
                          'C',
                          'STOCK_ORDER_RCV_SQL.DETAIL_PROCESSING');
    
END LOOP;

EXCEPTION

when OTHERS THEN

  dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);

ROLLBACK;
END;
/


----------------------releted tables----------------


select count(1) from rms.TRAN_DATA_HISTORY;  20160913--34998466
select count(1) from rms.key_map_gl where PGM_NAME='STOCK_ORDER_RCV_SQL.DETAIL_PROCESSING';
select count(1) from rms.TRAN_DATA_HISTORY where PGM_NAME='STOCK_ORDER_RCV_SQL.DETAIL_PROCESSING';--246527

-------------------cursor queries--------
SELECT TO_CHAR(p.vdate - so.tran_data_retained_days_no,'YYYYMMDD')
        FROM rms.period p,
             rms.system_options so;
			 
DELETE FROM key_map_gl
                     WHERE processed_date < TO_DATE(:ps_max_date,'YYYYMMDD')
                       AND reference_trace_type in ('GIT','GID','GIM')
                       AND ROWNUM <= :pi_commit_max_ctr;			 
			 
			 
			 
             