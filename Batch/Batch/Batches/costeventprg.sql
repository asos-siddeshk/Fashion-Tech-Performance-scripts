 SELECT count(distinct (cost_event_process_id )) --27000
             FROM cost_event
            WHERE to_date(to_char(create_datetime,'YYYYMMDD'),'YYYYMMDD') < (SELECT vdate - NVL(cost_event_hist_days,0) 
                                                                               FROM period,foundation_unit_options)
              AND event_type in ('CC','CL','CZ','D','DP','ELC','ICZ','MH','NIL','OH','PP','R','RTC','SC','SH','T','TR')
              ORDER BY cost_event_process_id;

/*
---------------------------Batch name:RMS.COSTEVENTPRG----------------------------------
2.Records to be updated in costevent tables								:rms.cost_event. 
3.Batch execution 														:RMS.COSTEVENTPRG via Automic.
--------------------------------------------------------------------------------------------------

testing into driving cursor tables:
-------------------------------


SELECT  event_type
       FROM  cost_event_run_type_config
        ORDER BY event_type;
		
		
we need to check event_type is configured or not in cost_event_run_type_config;	
	
----------- testing data in driving cursor  and releated tables----

select * from rms.cost_event WHERE TRUNC(CREATE_DATETIME)=TRUNC(SYSDATE);

select COUNT(1) from rms.cost_event WHERE TRUNC(CREATE_DATETIME)=TRUNC(SYSDATE);


select * from rms.cost_event WHERE EVENT_TYPE='NIL' AND ;

testing into driving cursor tables:
-------------------------------


SELECT  event_type
       FROM  cost_event_run_type_config
        ORDER BY event_type;



  SELECT cost_event_process_id 
             FROM cost_event
            WHERE to_date(to_char(create_datetime,'YYYYMMDD'),'YYYYMMDD') < (SELECT vdate - NVL(cost_event_hist_days,0) 
                                                                               FROM period,foundation_unit_options)
              AND event_type in ('CC','CL','CZ','D','DP','ELC','ICZ','MH','NIL','OH','PP','R','RTC','SC','SH','T','TR')
              ORDER BY cost_event_process_id;
              
 SELECT  NVL(cost_event_hist_days,0) 
        FROM rms.period,rms.foundation_unit_options;

desc rms.cost_event;  
			  
	  
---------------------------------------		

*/

select trunc(CREATE_DATETIME),count(1) from cost_event group by trunc(CREATE_DATETIME) order by 1; --11-NOV-18	27000

set serveroutput on;
set timing on;

declare
l_date date;
begin
for k in 0 .. 20 loop    
select vdate-20-k into l_date from rms.period;
for i in 0 .. 1499 loop    
insert into rms.cost_event   (
							 COST_EVENT_PROCESS_ID ,
							 ACTION ,
                             EVENT_TYPE,
                   
                             PERSIST_IND,
                             USER_ID,
                             CREATE_DATETIME) 
                         values(
							  RMS.COST_EVENT_PROCESS_ID_SEQ.NEXTVAL,
							 'ADD',
                             'NIL',
                             'Y',
                             'PTUSER',                             
                             l_date                           
							); 
                          
  END LOOP;
  commit;
   END LOOP;
EXCEPTION
when OTHERS THEN
  dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);
  ROLLBACK;
END;
/