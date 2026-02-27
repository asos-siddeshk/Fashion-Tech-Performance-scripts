--4077
--exec system.killsession ('4077');

update rms.SYSTEM_VARIABLES set ( 
   LAST_EOM_HALF_NO       , 
   LAST_EOM_MONTH_NO      , 
   LAST_EOM_DATE          , 
   NEXT_EOM_DATE          , 
   LAST_EOM_START_HALF    , 
   LAST_EOM_END_HALF      , 
   LAST_EOM_START_MONTH   , 
   LAST_EOM_MID_MONTH     , 
   LAST_EOM_NEXT_HALF_NO  , 
   LAST_EOM_DAY           , 
   LAST_EOM_WEEK          , 
   LAST_EOM_MONTH         , 
   LAST_EOM_YEAR          , 
   LAST_EOM_WEEK_IN_HALF  , 
   LAST_EOW_DATE          ) = ( 
select p.half_no -  
          decode( p.curr_454_month_in_half, 1, 
                  decode( mod(p.half_no,10), 1, 9, 1), 
                  0 )                                           LAST_EOM_HALF_NO,    
       decode( p.curr_454_month_in_half, 1,  
               6, 
               p.curr_454_month_in_half - 1)                    LAST_EOM_MONTH_NO,        
       p.start_454_month - 1                                    LAST_EOM_DATE,       
       p.end_454_month                                          NEXT_EOM_DATE,     
       add_months( p.start_454_half, 
                   decode( p.curr_454_month_in_half, 1, -6, 0)) LAST_EOM_START_HALF,          
       add_months( p.end_454_half, 
                   decode( p.curr_454_month_in_half, 1, -6, 0)) LAST_EOM_END_HALF,          
       add_months( p.start_454_month, -1)                       LAST_EOM_START_MONTH,       
       add_months( p.start_454_month, -1) + 14                  LAST_EOM_MID_MONTH,       
       p.half_no + 
          decode( p.curr_454_month_in_half, 1,  
                  0,
                  decode( mod(p.half_no,10), 1,1, 9))           LAST_EOM_NEXT_HALF_NO,
       decode( to_char(p.start_454_month-1,'DD'),  
               '28', 7, 
               mod( to_char(p.start_454_month-1,'DD'),28) )     LAST_EOM_DAY,          
       decode( to_char(p.start_454_month-1,'DD'),  
               '28', 4, 5)                                      LAST_EOM_WEEK,         
       to_char(p.start_454_month-1,'MM')                        LAST_EOM_MONTH,        
       to_char(p.start_454_month-1,'YYYY')                      LAST_EOM_YEAR,        
       ceil( ( p.start_454_month - 1 - add_months( p.start_454_half, 
               decode( p.curr_454_month, 1, -6, 0))  
               )/7 )                                            LAST_EOM_WEEK_IN_HALF,                               
       p.start_454_month - 1 + trunc(to_char(p.vdate,'DD')/7)*7 LAST_EOW_DATE  
from rms.PERIOD p 
);

update rms.SYSTEM_VARIABLES set  
   LAST_EOW_DATE     = LAST_EOW_DATE_UNIT;
   


   select * from rms.SYSTEM_VARIABLES;
   select * from rms.period; 23-OCT-23
   
   select * from RMS.CALENDAR where year_454 ='2022'; --04-NOV-18
   select * from daily_data_temp;
   select * from salweek_c_week;
   select * from salweek_c_daily;
   select * from salweek_restart_dept;
   
   
   
   --26,270 rows
select * from week_data where location = 20010;
--6,684 rows
select count(1) from month_data where location = 20010;
--0 rows
select count(1) from month_data_budget where location = 20010;

--1,671 rows
select count(1) from half_data where location = 20010;
--0 rows
select count(1) from half_data_budget where location = 20010;

   
   
select * from rms.SYSTEM_VARIABLES;
select * from rms.period; --14-NOV-23
