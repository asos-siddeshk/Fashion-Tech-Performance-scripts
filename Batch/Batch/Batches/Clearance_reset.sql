select status,count(1) from rms.rpm_stage_clearance_reset group by status;
select status,count(1) from ma_asos.Ma_stage_clearance_reset group by status;
select status,count(1) from ma_asos.Ma_clearance_reset group by status;
select * from ma_asos.Ma_clearance_reset;
select * from ma_asos.Ma_stage_clearance_reset;
select * from rms.rpm_stage_clearance_reset;

Update ma_asos.MA_PRICE_EVENT_THRESHOLD set clearance_reset_locs='25000';
select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;

select * from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='1125040';
select * from rms.rpm_clearance_reset where CLEARANCE_ID in (select PRICE_EVENT_ID from rpm_bulk_cc_pe_thread where BULK_CC_PE_ID ='1125040');

select EFFECTIVE_DATE,state,count(1) from rms.rpm_clearance_reset 
   where CLEARANCE_ID in (select PRICE_EVENT_ID from rpm_bulk_cc_pe_thread) group by EFFECTIVE_DATE,state;

 SELECT EFFECTIVE_DATE,COUNT(1) FROM rpm_clearance_reset
   WHERE state='pricechange.state.approved'
   AND trunc(EFFECTIVE_DATE)> = '02-MAR-2020' group by EFFECTIVE_DATE;

    SELECT EFFECTIVE_DATE,COUNT(1) FROM rpm_clearance
    WHERE state='pricechange.state.approved'
    AND trunc(EFFECTIVE_DATE)> = '02-MAR-2020' group by EFFECTIVE_DATE;

select * from rms.rpm_clearance_reset where trunc(APPROVAL_DATE)=trunc(sysdate);
select * from rms.rpm_clearance_reset where item = '6859562';

--select STATE, EFFECTIVE_DATE,count(1) from rms.rpm_clearance_reset group by STATE, EFFECTIVE_DATE;
select status,count(1) from rms.rpm_stage_clearance_reset group by status;
select * from rpm_stage_clearance;
delete from rpm_stage_clearance_reset;

   
insert into rms.rpm_stage_clearance_reset(stage_clearance_reset_id, 
                                        skulist                 , 
                                        zone_id                 , 
                                        zone_node_type          , 
                                        effective_date          , 
                                        status                  ) 
select rms.rpm_stage_clearance_reset_seq.nextval,
        skulist,
        zone_id,
        '1',
        '23-DEC-18',
        'N' from rpm_stage_clearance rsc 
        where not exists (select 1 from rms.rpm_stage_clearance_reset rscr where rsc.skulist = rscr.skulist);
        
--./injectorPriceEventBatch.sh rpmbatch status=N event_type=NR
select count(1) from rms.rpm_stage_clearance_reset where status ='N';
select count(1) from rms.rpm_stage_clearance_reset where status ='E' and ERROR_MESSAGE is not null;
select * from rms.rpm_stage_clearance_reset where status ='W';
delete from rms.rpm_stage_clearance_reset where status ='N' and EFFECTIVE_DATE! ='03-DEC-18';
select count(1) from rms.rpm_stage_clearance_reset where status ='W' and ERROR_MESSAGE is null; --104932
select count(1) from rms.rpm_stage_clearance_reset where status ='W' and ERROR_MESSAGE is not null;
select count(1) from rms.rpm_stage_clearance_reset where status ='A'; --84150


set serveroutput on;
set timing on;
 
declare
 
 counter         					number(8)     := 0;
 l_item          					rms.rpm_stage_clearance_reset.item%type;
 l_location      					rms.rpm_stage_clearance_reset.location%type;
 l_date date;					
 l_stage_clearance_reset_id 		rms.rpm_stage_clearance_reset.stage_clearance_reset_id%type;
 l_zone_node_type   				rms.rpm_stage_clearance_reset.zone_node_type%type;
   

	cursor cur_dept_a is --2613
        select item,location,zone_node_type from rms.rpm_clearance_reset rc where effective_date is null and state like 'pricechange.state.approved' 
            and not exists (select 1 from rms.rpm_stage_clearance_reset rcr where  rcr.item =rc.item and rc.location=rcr.location)
            and rownum<='20000' order by clearance_id;
            
   begin

for k in 0..4 loop 

    select vdate+1 into l_date from period;

for j in cur_dept_a loop 

    l_item 			:= j.item;
    l_location 		:= j.location;
    l_zone_node_type:= j.zone_node_type;
	
    select rms.rpm_stage_clearance_reset_seq.nextval into l_stage_clearance_reset_id from dual;
    
insert into rms.rpm_stage_clearance_reset (stage_clearance_reset_id, 
                                        item                    , 
                                        location                , 
                                        zone_node_type          , 
                                        effective_date          , 
                                        status                  )
                            values (l_stage_clearance_reset_id,
                                    l_item,
                                    l_location,
                                    l_zone_node_type,
                                    l_date,
                                    'N');
                                    
end loop;
commit;
  end loop;
exception
 
   when others then
      dbms_output.put_line('exception blcok'||dbms_utility.format_error_backtrace||dbms_utility.format_error_stack);
      rollback;
 
end;
/



  select *
     from rms_plsql_batch_config
    where program_name = 'NB_CLEARANCE_RESET';


select status,count(1) from ma_asos.Ma_clearance_reset group by status;
select * from ma_asos.Ma_stage_clearance_reset;
select * from ma_asos.Ma_clearance_reset;
select * from rpm_stage_clearance_reset where item = '7107460';
select status,count(1) from rms.rpm_stage_clearance_reset group by status;
select * from rpm_clearance_reset where item = '7107460';
select * from rpm_future_retail where item = '7107460';


  SELECT clr_reset_daily_limit,
           clearance_reset_locs 
    FROM ma_asos.ma_price_event_threshold; --1000000	5000

Update ma_asos.MA_PRICE_EVENT_THRESHOLD set clearance_reset_locs='25000';
select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;

  SELECT *
    FROM ma_asos.ma_price_event_threshold; --1000000	5000


  SELECT *
    FROM nb_system_parameters s
   WHERE s.func_area = 'CLEARANCE_RESET';

    SELECT COUNT(1) FROM rpm_clearance_reset
    WHERE state='pricechange.state.approved'
    AND trunc(EFFECTIVE_DATE) = '05-MAR-2020';

  SELECT rcr.clearance_id                              clearance_reset_id,
         rcr.item                                      item,
         im.item_parent                                item_parent,
         rcr.location                                  location,
         rcr.zone_node_type                            zone_node_type,
         rc.effective_date                effective_date
    FROM rpm_clearance_reset rcr,
         item_master         im,
         rpm_clearance       rc
   WHERE rcr.state                   = 'pricechange.state.approved'
     AND rcr.effective_date          IS NULL
     AND im.item                     = rcr.item
     AND im.item_level               = im.tran_level
     AND rc.clearance_display_id     = SUBSTR(rcr.clearance_display_id,instr(rcr.clearance_display_id,':')+1,100)
     -- no sales in last L_sales_months months
     AND NOT EXISTS (SELECT 1
                       FROM ma_asos.ma_v_item_loc_soh   ils_sales
                      WHERE ils_sales.item              = rcr.item
                        AND ils_sales.loc_type          = 'S'
                        AND NVL(ils_sales.last_sold,
                                to_date('1900','YYYY')) > TRUNC(ADD_MONTHS('01-MAR-2020', -12))
                        AND ROWNUM < 2)
     -- stock below L_stock_level units
     AND NVL((SELECT SUM(ils_stock.stock_on_hand)
                FROM ma_asos.ma_v_item_loc_soh   ils_stock
               WHERE ils_stock.item     = rcr.item
                 AND ils_stock.loc_type = 'W'), 0) <= '0';
     -- multithreading
  --   AND ROWNUM <= ROUND(L_clr_rownum,0);



  SELECT clearance_reset_id,
         item,
         location,
         zone_node_type,
         effective_date
    FROM (
          SELECT clearance_reset_id,
                 item,
                 location,
                 zone_node_type,
                 effective_date,
                 dense_rank() over (ORDER BY effective_date ASC) ranking
            FROM (
                  SELECT clearance_reset_id,
                         item,
                         location,
                         zone_node_type,
                         MAX(effective_date) OVER (PARTITION BY item_parent, location) effective_date
                    FROM (
                          SELECT mcr.clearance_reset_id,
                                 mcr.item,
                                 mcr.item_parent,
                                 mcr.location,
                                 mcr.zone_node_type,
                                 mcr.effective_date
                            FROM ma_asos.ma_clearance_reset mcr
                           WHERE mcr.status = 'N'
                             AND NOT EXISTS (SELECT 1
                                               FROM item_master        im,
                                                    ma_asos.ma_clearance_reset mclr
                                              WHERE im.item_parent   = mcr.item_parent
                                                AND mclr.item(+)     = im.item
                                                AND mclr.location(+) = mcr.location
                                                AND mclr.item        IS NULL
                                                AND ROWNUM           < 2)
                             -- multithreading
--                             AND MOD(ABS(mcr.item_parent),'8') + 1 = '5'
                         )
                 )
         )
   WHERE ranking = 1;
  --


  SELECT rcr.clearance_id                              clearance_reset_id,
         rcr.item                                      item,
         im.item_parent                                item_parent,
         rcr.location                                  location,
         rcr.zone_node_type                            zone_node_type,
         rc.effective_date                effective_date
    FROM rpm_clearance_reset rcr,
         item_master         im,
         rpm_clearance       rc
   WHERE rcr.state                   = 'pricechange.state.approved'
     AND rcr.effective_date          IS NULL
     AND im.item                     = rcr.item
     AND im.item_level               = im.tran_level;
     -- no sales in last L_sales_months months
     AND NOT EXISTS (SELECT 1
                       FROM ma_asos.ma_v_item_loc_soh   ils_sales
                      WHERE ils_sales.item              = rcr.item
                        AND ils_sales.loc_type          = 'S'
                        AND NVL(ils_sales.last_sold,
                                to_date('1900','YYYY')) > TRUNC(ADD_MONTHS('01-MAR-2020', -12))
                        AND ROWNUM < 2)
     -- stock below L_stock_level units
     AND NVL((SELECT SUM(ils_stock.stock_on_hand)
                FROM ma_asos.ma_v_item_loc_soh   ils_stock
               WHERE ils_stock.item     = rcr.item
                 AND ils_stock.loc_type = 'W'), 0) <= '0';



select * from rpm_clearance_reset where item in (select item from item_master where item_level = '1');

select * from rpm_clearance_reset where item in (select item from item_master where item_level = '1');

