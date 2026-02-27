
   
    select distinct item from rms.rpm_clearance where item in (select item from rms.item_master where item_desc like '%Martens%' and item_level = '1') and reset_date = '06-FEB-24' order by 1 desc;


select * from rms.rpm_zone_location where location between 20000 and 21000;

select * from rms.item_loc where item in (select item from rms.item_master where item in ('101340330','101235939','101193131','101051384','101051342','101051333') or item_parent in ('101340330','101235939','101193131','101051384','101051342','101051333')) and loc between 20000 and 21000;
select * from rms.price_hist where item in (select item from rms.item_master where item in ('101340330','101235939','101193131','101051384','101051342','101051333') or item_parent in ('101340330','101235939','101193131','101051384','101051342','101051333')) and loc between 20000 and 21000 order by ACTION_DATE desc;;

select * from rms.rpm_clearance where item in (select item from rms.item_master where item in ('101340330','101235939','101193131','101051384','101051342','101051333') or item_parent in ('101340330','101235939','101193131','101051384','101051342','101051333')) and state ! = 'pricechange.state.worksheet';
select * from rms.rpm_clearance_reset where item in (select item from rms.item_master where item in ('101340330','101235939','101193131','101051384','101051342','101051333') or item_parent in ('101340330','101235939','101193131','101051384','101051342','101051333'));
select FUTURE_RETAIL_ID, ITEM, LOCATION, ACTION_DATE, SELLING_RETAIL, SELLING_RETAIL_CURRENCY, CLEAR_RETAIL, CLEAR_RETAIL_CURRENCY, SIMPLE_PROMO_RETAIL, SIMPLE_PROMO_RETAIL_CURRENCY from rms.rpm_future_retail where item in ('101340330','101235939','101193131','101051384','101051342','101051333') 
and SELLING_RETAIL <> CLEAR_RETAIL
order by ACTION_DATE desc;

select * from rms.rpm_promo_item_loc_expl where item in ('101340330','101235939','101193131','101051384','101051342','101051333') ;


99	20000
100	20001
101	20002
102	20009
103	20004
104	20006
105	20005
106	20007
107	20008
108	20003
109	20012
110	20011
111	20010
112	20013
113	20014
114	20015





select * from all_sequences where sequence_owner like 'RMS' and sequence_name like 'LOGGER%';  
select * from rms.rpm_future_retail where item = '119926375' order by action_date;

select * from rms.rpm_clearance;
select * from rms.rpm_clearance where clearance_id  >= '313053466' ;

select * from rms.logger_logs where id  >= '505702388' order by 1 desc;
select * from rms.logger_logs where trunc(TIME_STAMP) = trunc(sysdate) order by 1 desc;
select state,count(1) from RMS.rpm_clearance where CLEARANCE_ID > '313053466' group by state;

select effective_date,zone_id,state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '17-JAN-23' group by effective_date,zone_id,state order by 1,3,2;
select state,create_id,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '17-JAN-23' group by create_id,state;
select state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '17-JAN-23' group by state;
select effective_date,state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '17-JAN-23' group by effective_date,state;

select effective_date,zone_id,state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' group by effective_date,zone_id,state order by 1,3,2;
select state,create_id,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' group by create_id,state;
select state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' group by state;
select effective_date,state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' group by effective_date,state;

select state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '19-JAN-23' group by state;
select effective_date,state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '19-JAN-23' group by effective_date,state;



select distinct rc.CLEARANCE_ID, rc.CLEARANCE_DISPLAY_ID, rc.STATE, rc.ITEM, rc.ZONE_ID, rc.EFFECTIVE_DATE, --rc.CHANGE_TYPE,
    rc.CHANGE_PERCENT, CREATE_DATE, rc.CREATE_ID, rc.APPROVAL_DATE, rc.APPROVAL_ID, rcce.MESSAGE_KEY
    from rms.rpm_clearance rc,rms.rpm_con_check_err rcce
    where rc.STATE! = 'pricechange.state.approved'
        and  trunc(rc.CREATE_DATE) = '19-JAN-23' 
    and rcce.message_key not in ('event_causes_clearance_retail_less_than_prior_clearance','future_retail_price_change_rule24','event_causes_clearance_retail_less_than_regular','future_retail_price_change_rule5')
    and rcce.REF_ID (+) = rc.CLEARANCE_ID order by 1 desc; -- 5000
    
select * from ma_asos.ma_stage_clearance;    
select state,count(1) from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' group by state;


select * from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' and item = '100210687';
select * from rms.rpm_future_retail where item ='100210687' and location in ('103','20004','20003');

select * from RMS.rpm_clearance where trunc(CREATE_DATE) = '18-JAN-23' and item = '123650910';
select * from rms.rpm_future_retail where item ='123650910' and location in ('105','20005');    
select * from rms.rpm_future_retail where item ='123650910' and location in ('103','20004','20003');    
select * from rms.rpm_zone_location where zone_id ='103';

select * from all_tables where owner like 'RMS' and table_name like '%BULK%';  
select * from RMS.RPM_BULK_CC_PE_CHUNK order by 1 desc;
select * from RMS.RPM_BULK_CC_TASK order by 1 desc;

select * from RMS.rpm_bulk_cc_pe where user_name not in ('NewItemLocationBatch','Injector') order by 1 desc;
select status,count(1) from RMS.rpm_bulk_cc_pe_thread  group by status;
select * from RMS.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='45302997' order by 1 desc;
select PRICE_EVENT_START_DATE,count(1) from RMS.rpm_bulk_cc_pe_thread group by PRICE_EVENT_START_DATE;
select PRICE_EVENT_START_DATE,count(1) from Vrpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='45302997' group by PRICE_EVENT_START_DATE;
select * from RMS.rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='45302997';
select status,count(1) from RMS.rpm_bulk_cc_pe_thread  group by status;
select * from RMS.rpm_bulk_cc_pe_item where BULK_CC_PE_ID in (select BULK_CC_PE_ID from rpm_bulk_cc_pe_thread where trunc(PRICE_EVENT_START_DATE) = '27-JAN-2019');
select count(1) from rms.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='45302997'  order by 1 desc; --1 21 89 039
select * from RMS.RPM_PE_CC_LOCK ;
select count(1) from RMS.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='45302997'  order by 1 desc;
select * from RMS.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='45302997'  order by 1 desc;
select * from RMS.rpm_bulk_cc_pe_location where BULK_CC_PE_ID ='45302997'  order by 1 desc;
select ITEM_PARENT,count(1) from RMS.rpm_bulk_cc_pe_item where BULK_CC_PE_ID ='45302997' group by ITEM_PARENT order by 2 desc;
select ITEM_PARENT,count(1) from rpm_bulk_cc_pe_item group by ITEM_PARENT order by 2 desc;



select TASK_ID, STATUS, OWNER, COMMAND_CLASS, to_char(PROCESS_START_DATE,'YYYY/MM/DD HH:MI:SS') as PROCESS_START_DATE, to_char(PROCESS_END_DATE,'YYYY/MM/DD HH:MI:SS') as PROCESS_END_DATE
    from RMS.rpm_task where rownum <='3000' order by 1 desc ;

select state,count(1) from rpm_clearance where CLEARANCE_ID > '284032919' group by state;

select distinct rc.CLEARANCE_ID, rc.CLEARANCE_DISPLAY_ID, rc.STATE, rc.ITEM, rc.ZONE_ID, rc.EFFECTIVE_DATE, --rc.CHANGE_TYPE,
    rc.CHANGE_PERCENT, CREATE_DATE, rc.CREATE_ID, rc.APPROVAL_DATE, rc.APPROVAL_ID, rcce.MESSAGE_KEY
    from rms.rpm_clearance rc,rms.rpm_con_check_err rcce
    where rc.STATE! = 'pricechange.state.approved'
    --and trunc(rc.CREATE_DATE) = '10-JAN-23' 
    and rc.clearance_id >= '284032919'
    and rcce.message_key not in ('event_causes_clearance_retail_less_than_prior_clearance','future_retail_price_change_rule24')
    and rcce.REF_ID (+) = rc.CLEARANCE_ID order by 1 desc; -- 5000


select * from rpm_clearance where CLEARANCE_ID > '284032919' group by ZONE_ID,CREATE_ID;
select ZONE_ID,CREATE_ID, count(1) from rpm_clearance where CLEARANCE_ID > '284032919' group by ZONE_ID,CREATE_ID;

