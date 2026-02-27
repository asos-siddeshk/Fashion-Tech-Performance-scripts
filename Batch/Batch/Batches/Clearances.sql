drop  table ma_stage_clearance_bk ;
create table ma_stage_clearance_bk as select * from ma_asos.ma_stage_clearance ;
delete from ma_asos.ma_stage_clearance ;
insert into ma_asos.ma_stage_clearance  select * from ma_stage_clearance_bk ;
insert into ma_asos.ma_stage_price_change  select * from ma_stage_price_change_bk ;

delete from rpm_stage_clearance ;

15-JAN-24	48
16-JAN-24	80
17-JAN-24	32

select rzl.location, count(1) from ma_asos.ma_stage_clearance msc , skulist_detail sd, rpm_zone_location rzl
    where msc.skulist = sd.skulist
        and msc.ZONE_ID = rzl.zone_id
        group by rzl.location; 
        
        
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --
select CHANGE_PERCENT, SKULIST, zone_id, EFFECTIVE_DATE, OUT_OF_STOCK_DATE, RESET_DATE from ma_asos.ma_stage_clearance where status ='N' and message_type ='A' ; --
select EFFECTIVE_DATE, OUT_OF_STOCK_DATE, RESET_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE, OUT_OF_STOCK_DATE, RESET_DATE order by 1,2,3;
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='P' group by EFFECTIVE_DATE order by 1; 
select EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance where status ='W' group by EFFECTIVE_DATE order by 1; --

select EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance where status ='A' group by EFFECTIVE_DATE order by 1; --

select status,count(1) from rms.rpm_stage_clearance group by status order by 1; --
select * from RMS.RPM_STAGE_CLEARANCE_RESET;
select * from ma_asos.ma_stage_clearance;
select * from period;
select state,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '10-JAN-24' and '31-JAN-24' group by state; -- 5008

select * from rms.rpm_clearance where EFFECTIVE_DATE between '15-JAN-24' and '31-JAN-24';
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '15-JAN-24' and '31-JAN-24'  and state ='pricechange.state.approved' group by EFFECTIVE_DATE order by 1; -- 5008

Update ma_asos.ma_stage_clearance set effective_date='16-JAN-24' where status ='N' ;
delete from rms.rpm_stage_clearance;

delete from ma_asos.ma_stage_clearance where status ='N' and trunc(effective_date)>='28-FEB-23' and rownum <= '30';
delete from ma_asos.ma_stage_clearance where skulist='132873';
                
select state,count(1) from rms.rpm_clearance where clearance_id in (select  clearance_id from rms.rpm_stage_clearance) group by state;

select * from rpm_con_check_err where REF_ID ='30990611';
select * from rpm_con_check_err_detail where CON_CHECK_ERR_ID in (select CON_CHECK_ERR_ID from rpm_con_check_err where REF_ID ='30990611');
                
                
                
select sh.SKULIST from rms.skulist_head sh where sh.sKULIST_DESC like '500Clearance%'
    and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.SKULIST = sh.SKULIST )    
    and not exists (select 1 from rms.rpm_clearance rc where rc.EFFECTIVE_DATE between '01-NOV-2021' and '30-NOV-2022' and rc.SKULIST = sh.SKULIST) ;

select * from ma_asos.ma_stage_clearance;

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by EFFECTIVE_DATE order by 1; --
select ZONE_ID,EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance group by ZONE_ID,EFFECTIVE_DATE order by 1; --

                
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER         NUMBER(8)     := 0;
 COUNTER_COMMIT  NUMBER(8)     := 1;
 stage_COMMIT  NUMBER(8)     := 0;
 
   p_clear_stage_id             ma_asos.ma_stage_clearance.stage_clearance_id%type;   
   p_itemlist_id                ma_asos.ma_stage_clearance.skulist%type;
   p_reason_code                ma_asos.ma_stage_clearance.reason_code%type;
   p_Location                   ma_asos.ma_stage_clearance.location%type;
   p_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   p_effective_date             ma_asos.ma_stage_clearance.effective_date%type;  
   p_out_of_stock_date          ma_asos.ma_stage_clearance.out_of_stock_date%type; 
   p_reset_date                 ma_asos.ma_stage_clearance.reset_date%type; 
   p_percent                ma_asos.ma_stage_price_change.change_percent%type;   
   p_status                     ma_asos.ma_stage_price_change.status%type; 
   l_selling_unit_retail   		rms.rpm_stage_clearance.change_amount%type;
   l_selling_uom                rms.item_loc.SELLING_UOM%type;
   l_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   l_location                    ma_asos.ma_stage_clearance.location%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 

	 cursor c_get_loc  is
            select ma.ZONE_ID,ma.store from ma_asos.ma_pricing_defaults ma;
    
	 cursor c_get_cuitem_clr (p_zone_id ma_asos.ma_stage_clearance.zone_id%type)  is
            select sh.SKULIST from rms.skulist_head sh where sh.sKULIST_DESC like '500Clearance%'
                and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.SKULIST = sh.SKULIST and mpc.zone_id = p_zone_id)
                and not exists (select 1 from rms.rpm_clearance rc where rc.EFFECTIVE_DATE between '01-JAN-2024' and '30-MAR-2024'
                         and rc.SKULIST = sh.SKULIST and rc.zone_id = p_zone_id) and rownum <='2';

      
BEGIN

--for m in 0..4 loop
--    select vdate+m into p_effective_date from rms.period;

for m in 0..1 loop
    select vdate+1+m into p_effective_date from rms.period;
    select vdate+4+m into p_out_of_stock_date from rms.period;
    select vdate+4+m into p_reset_date from rms.period;
    
    for k in c_get_loc loop
 	     p_zone_id := k.zone_id;
         p_Location := k.store;
         
            for cust_ma in c_get_cuitem_clr (p_zone_id)  loop 
                  EXIT WHEN c_get_cuitem_clr%NOTFOUND;
                     p_itemlist_id                := cust_ma.SKULIST;
                                
            select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into p_clear_stage_id from dual;         
             
               COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                                
                  IF MOD(COUNTER_COMMIT, 4) = 0 THEN
                  p_percent := '-25';
                   else if MOD(COUNTER_COMMIT, 4) = 1 THEN
                  p_percent := '-40';
                  else if MOD(COUNTER_COMMIT, 4) = 2 THEN
                  p_percent := '-50';
                  else if MOD(COUNTER_COMMIT, 4) = 3 THEN
                  p_percent := '-70';
                  
                   END IF;	
               END IF;  
               END IF;  
               END IF;
             
             
              insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      skulist,													
                                                      zone_id,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_amount, --change_percent
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_itemlist_id ,
                                                       p_zone_id,
                                                       1,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       2, -- 0
                                                       '0.1', -- p_percent --40
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
    
            
                            END LOOP;   
               
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
                  --  COMMIT;
                  continue;
                   END IF;	
           
      END LOOP; 
      END LOOP; 
  --commit;
  
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/



ALTER SESSION ENABLE PARALLEL DML;
-- These records stuck in conflict check from the past. Each case like this should be investigated after go-live. For now, they can be removed since they did not reach RFR.
DELETE /*+PARALLEL(4)*/ FROM rms.RPM_CLEARANCE RC WHERE NOT EXISTS (SELECT /*+PARALLEL(4)*/ 1 FROM rms.RPM_FUTURE_RETAIL RFR WHERE RFR.CLEARANCE_ID = RC.CLEARANCE_ID)
AND state='pricechange.state.conflictChecking';
COMMIT;

-- The system would keep them for 25 months, but the number of records are way too much for this scenario. Not to mention we have multiple rows for item/zone for different effective date which is not a valid business scenario
DELETE  FROM RPM_CLEARANCE RC  where effective_date < '31-DEC-18' and state='pricechange.state.worksheet';
COMMIT;

--------------------------------- SKULIST ------------------------------------------

select count(skulist) from rms.skulist_head where sKULIST_DESC like '500Clearance%' order by 1 desc;
select count(skulist) from rms.skulist_head where sKULIST_DESC like '10Clearance%' order by 1 desc;
select SKULIST,count(1) from rms.skulist_detail where skulist  in (select skulist from rms.skulist_head where sKULIST_DESC like '500Clearance%') group by SKULIST;
select SKULIST,count(1) from rms.skulist_detail where skulist  in (select skulist from rms.skulist_head where sKULIST_DESC like '10Clearance%') group by SKULIST;

select * from rms.skulist_head where skulist ='1652336';
select * from rms.skulist_criteria where skulist ='1652336';
select * from rms.skulist_detail where skulist ='1652336';

select count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG  where status ='U';
select count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG  where status ='P';

select skulist,item from int_asos.INT_PL_ITEMLIST_UPLD_STG group by skulist,item having count(item) >'1';


select count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U' ; --625046 / 623046

delete from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U'; --625046 / 623046

select * from int_asos.INT_PL_ITEMLIST_UPLD_STG;
select STATUS,count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG group by STATUS;
select REF_NO,count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U' group by REF_NO;

delete from int_asos.INT_PL_ITEMLIST_UPLD_STG where REF_NO in 
(select REF_NO from (select REF_NO,count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U' group by REF_NO having count(1) < '450')) ;

update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;

select item,count(1) from rms.skulist_detail where item in (select item from rms.item_master where item_level ='1') group by item having count(1)> '1';


drop table del_skulist;
create table del_skulist as
select SKULIST from rms.skulist_detail where skulist  in  
 (select skulist from rms.skulist_head where sKULIST_DESC like '500Clearance%') 
 group by SKULIST having count(1)<= '400';

begin
delete from rms.skulist_detail where skulist in (select skulist from DEL_SKULIST );
delete from rms.skulist_criteria where skulist in (select skulist from DEL_SKULIST );
delete from rms.skulist_head where skulist in (select skulist from DEL_SKULIST );
commit;
end;
/
drop table DEL_SKULIST;

drop table INT_PL_ITEMLIST_UPLD_STG_bk;
create table INT_PL_ITEMLIST_UPLD_STG_bk as
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG ;
truncate table int_asos.INT_PL_ITEMLIST_UPLD_STG;
insert into int_asos.INT_PL_ITEMLIST_UPLD_STG select * from INT_PL_ITEMLIST_UPLD_STG_bk;

 --Itmelist creations 

select REF_NO,count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U' group by REF_NO;

delete from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';

select count(skulist) from rms.skulist_head where sKULIST_DESC like '500Clearance%' order by 1 desc;
select count(1) from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';


set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;

l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist           number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM              VARCHAR2(25);
l_date              date;
l_dept              rms.subclass.dept%type; 
l_class             rms.subclass.class%type; 
l_subclass          rms.subclass.subclass%type; 
   
    cursor cur_dept is
		select dept,class from (
		   --select im.dept,im.class from rms.subclass im where (dept!='9999' and class!='9999' and subclass!='9999') group by im.dept,im.class
             select dept,class,count(1) from item_master where status ='A' and item_level ='1' group by dept,class having count(1) >= '500'
          ) order by 1,2;
            
            
CURSOR c_itemlist (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type) is
	select 	im.item
	from rms.item_master im
	where  im.dept =  l_dept
         and im.class = l_class
         and im.item_level = '1' and im.status ='A'
         and not exists (select 1  from rms.skulist_detail sd where sd.item = im.item)
         and not exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG mpc where mpc.item = im.item )
       and rownum<=500;

BEGIN


for j in 0..0 loop

for k in cur_dept loop 
  l_dept := k.dept;
  l_class := k.class;    
  
   select sysdate into l_date from dual;
   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= '500Clearance'||'-'||l_REF_NO;
		I_filename 		:= '500Clearance'||'-'||l_REF_NO;
        
FOR i in c_itemlist(l_dept,l_class) Loop 
      EXIT WHEN c_itemlist%NOTFOUND;
      l_item     :=i.item;
	
insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);
	   									   
 END LOOP;
  COUNTER_COMMIT:= COUNTER_COMMIT+1;
       
        IF MOD(COUNTER_COMMIT, 10) = 0 THEN
        COMMIT;
        END IF; 
 END LOOP;
  END LOOP;
  COMMIT;
 
EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/


drop table skulist_loc;
create table skulist_loc as
    select distinct rc.skulist,rc.zone_id from rpm_clearance rc where rc.skulist is not null 
            and rc.state ='pricechange.state.executed' and rc.RESET_DATE <= '25-JAN-19'
                and exists (select 1 from skulist_detail sk where rc.skulist = sk.skulist group by skulist having count(skulist) between '400' and '500');

select skulist,count(1) from skulist_detail where skulist in (
 select distinct rc.skulist  from rpm_clearance rc where rc.skulist is not null and rc.state ='pricechange.state.executed' and rc.RESET_DATE <= '10-JAN-19'
                and exists (select 1 from skulist_detail sk where rc.skulist = sk.skulist group by skulist having count(skulist) between '400' and '500')) group by skulist;







 --- Custom Clearance MA_STAGE ---
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER         NUMBER(8)     := 0;
 COUNTER_COMMIT  NUMBER(8)     := 1;
 stage_COMMIT  NUMBER(8)     := 0;
 
   p_clear_stage_id             ma_asos.ma_stage_clearance.stage_clearance_id%type;   
   p_itemlist_id                ma_asos.ma_stage_clearance.skulist%type;
   p_reason_code                ma_asos.ma_stage_clearance.reason_code%type;
   p_Location                   ma_asos.ma_stage_clearance.location%type;
   p_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   p_effective_date             ma_asos.ma_stage_clearance.effective_date%type;  
   p_out_of_stock_date          ma_asos.ma_stage_clearance.out_of_stock_date%type := null; 
   p_reset_date                 ma_asos.ma_stage_clearance.reset_date%type := null; 
   p_percent                    ma_asos.ma_stage_price_change.change_percent%type := null;    
   p_status                     ma_asos.ma_stage_price_change.status%type; 
   l_selling_unit_retail   		rms.rpm_stage_clearance.change_amount%type;
   l_selling_uom                rms.item_loc.SELLING_UOM%type;
   l_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   l_location                   ma_asos.ma_stage_clearance.location%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 

	 cursor c_get_loc  is

            select SKULIST, ZONE_ID from skulist_loc where 
                 skulist not in (select skulist  from ma_asos.ma_stage_clearance where status ='N') and rownum <='30';
    
    
BEGIN

for m in 0..2 loop

   select vdate+1+m into p_effective_date from rms.period;
   select vdate+3+m into p_out_of_stock_date from rms.period;
   select vdate+3+m into p_reset_date from rms.period;

    
    for k in c_get_loc loop
 	     p_zone_id := k.zone_id;
         p_itemlist_id := k.SKULIST;
         
                               
            select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into p_clear_stage_id from dual;         
             
               COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                                
                  IF MOD(COUNTER_COMMIT, 4) = 0 THEN
                  p_percent := '-25';
                   else if MOD(COUNTER_COMMIT, 4) = 1 THEN
                  p_percent := '-40';
                  else if MOD(COUNTER_COMMIT, 4) = 2 THEN
                  p_percent := '-50';
                  else if MOD(COUNTER_COMMIT, 4) = 3 THEN
                  p_percent := '-70';
                  
                   END IF;	
               END IF;  
               END IF;  
               END IF;
             
             
              insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      skulist,													
                                                      zone_id,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_percent,
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_itemlist_id ,
                                                       p_zone_id,
                                                       1,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       0,
                                                       p_percent, 
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
          
         
                            END LOOP;   
                                             END LOOP;   
               
              commit;
              
           

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

select reset_date,count(1) from ma_asos.ma_stage_clearance where status ='N' group by reset_date order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --

 ---  Option levels
 
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance  group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='P' group by EFFECTIVE_DATE order by 1; 
select EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance group by EFFECTIVE_DATE order by 1; --
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select state,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '20-JAN-19' group by state; -- 5008
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '20-JAN-19'  and state ='pricechange.state.approved' group by EFFECTIVE_DATE order by 1; -- 5008

select count(1) from ma_asos.ma_stage_clearance where status ='N';  --337560
delete  from ma_asos.ma_stage_clearance where status='N';  --90000
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status!='N' group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --
select * from ma_asos.ma_stage_clearance where status ='N';  --90000
select * from ma_asos.ma_stage_clearance where MESSAGE_TYPE='A';  --
select * from ma_asos.ma_stage_clearance where MESSAGE_TYPE!='A' and status ='N';  --

delete from ma_asos.ma_stage_clearance where MESSAGE_TYPE!='A' and status ='N';  --

select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select count(1) from rms.RPM_STAGE_CLEARANCE where status ='N';
select count(1) from rms.RPM_STAGE_CLEARANCE where status ='W' and ERROR_MESSAGE is null;
select count(1) from rms.RPM_STAGE_CLEARANCE where status ='W' and ERROR_MESSAGE is not null;
select count(1) from rms.RPM_STAGE_CLEARANCE where status ='A';
select state,count(1) from rms.rpm_clearance where clearance_id in (select  clearance_id from rms.rpm_stage_clearance) group by state;

Update rms.rpm_stage_clearance set status ='N';
delete from rms.rpm_stage_clearance where status ='W';
delete from rms.rpm_stage_clearance where status ='W';

select EFFECTIVE_DATE,count(1) from rms.rpm_stage_clearance group by EFFECTIVE_DATE order by 1; --16076 --16684
select state,count(1) from rms.rpm_clearance where clearance_id in (select  clearance_id from rms.rpm_stage_clearance) group by state;
select * from rms.rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '20-JAN-19' order by 1 desc;
select state,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '20-JAN-19' group by state; -- 5008
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '23-DEC-18' and '20-JAN-19' and state ='pricechange.state.approved' group by EFFECTIVE_DATE; -- 5008





--- Item list creations ------
drop table INT_PL_ITEMLIST_UPLD_STG_bk;
create table INT_PL_ITEMLIST_UPLD_STG_bk as
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG ;
truncate table int_asos.INT_PL_ITEMLIST_UPLD_STG;
insert into int_asos.INT_PL_ITEMLIST_UPLD_STG select * from INT_PL_ITEMLIST_UPLD_STG_bk;

set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;

l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist              number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM             VARCHAR2(25);
l_date             date;

CURSOR c_itemlist is

	select 	im.item
	from rms.item_master im
	where  im.item_level = '1' and im.status ='A'
    and not exists (select 1  from rms.skulist_detail sd where sd.item = im.item)
           and not exists (select 1 from rms.rpm_stage_simple_promo rpc  where rpc.item = im.item )
                 and not exists (select 1 from ma_asos.ma_stage_price_change mpc where mpc.item = im.item )
                 and not exists (select 1 from ma_asos.ma_stage_simple_promo msp where msp.item = im.item ) 
                 and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.item = im.item  ) 
		   and rownum<=1000;

BEGIN
for m in 0..1000 loop 

   select sysdate-m into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'Clearance'||'-'||l_REF_NO;
		I_filename 		:= 'Clearance'||'-'||l_REF_NO;
        
FOR i in c_itemlist Loop 
            l_item     :=i.item;
					

insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);
		
     
           
       									   
 END LOOP;
  COUNTER_COMMIT:= COUNTER_COMMIT+1;
        
         IF MOD(COUNTER_COMMIT, 2) = 0 THEN
        COMMIT;
       END IF; 
 END LOOP;
  
EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/



---- Clearance Creations -------
drop table ma_stage_clearance_bk;
create table ma_stage_clearance_bk as
select * from ma_asos.ma_stage_clearance;
truncate table ma_asos.ma_stage_clearance;
insert into ma_asos.ma_stage_clearance select * from ma_stage_clearance_bk ;

select * from ma_asos.ma_stage_clearance;
select * from rpm_stage_clearance ;
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='P' group by EFFECTIVE_DATE order by 1; --
delete from ma_asos.ma_stage_clearance;
delete from rpm_stage_clearance ;

delete from ma_asos.ma_stage_clearance where status = 'N';
delete from skumar.ma_stage_clearance_bk where skulist is not null;

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --


--- Clearances - Itemlist levels --


select sh.SKULIST from rms.skulist_head sh where sh.sKULIST_DESC like '10Clearance%'
                and not exists (select 1 from skumar.ma_stage_clearance_bk mpc where mpc.SKULIST = sh.SKULIST);
                
set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER         NUMBER(8)     := 0;
 COUNTER_COMMIT  NUMBER(8)     := 1;
 stage_COMMIT  NUMBER(8)     := 0;
 
   p_clear_stage_id             ma_asos.ma_stage_clearance.stage_clearance_id%type;   
   p_itemlist_id                ma_asos.ma_stage_clearance.skulist%type;
   p_reason_code                ma_asos.ma_stage_clearance.reason_code%type;
   p_Location                   ma_asos.ma_stage_clearance.location%type;
   p_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   p_effective_date             ma_asos.ma_stage_clearance.effective_date%type;  
   p_out_of_stock_date          ma_asos.ma_stage_clearance.out_of_stock_date%type; 
   p_reset_date                 ma_asos.ma_stage_clearance.reset_date%type; 
   p_change_percent             ma_asos.ma_stage_price_change.change_percent%type;   
   p_status                     ma_asos.ma_stage_price_change.status%type; 
   l_selling_unit_retail   		rms.rpm_stage_clearance.change_amount%type;
   l_selling_uom                rms.item_loc.SELLING_UOM%type;
   l_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   l_location                    ma_asos.ma_stage_clearance.location%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 

	 cursor c_get_loc  is
            select ma.ZONE_ID,ma.store from ma_asos.ma_pricing_defaults ma where rownum<='5';
    
	 cursor c_get_cuitem_clr (p_zone_id ma_asos.ma_stage_clearance.zone_id%type)  is
            select sh.SKULIST from rms.skulist_head sh where sh.sKULIST_DESC like 'Clearance%'
                and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.SKULIST = sh.SKULIST and mpc.zone_id = p_zone_id)
                and not exists (select 1 from skumar.ma_stage_clearance_bk mpc where mpc.SKULIST = sh.SKULIST and mpc.zone_id = p_zone_id)
                and not exists (select 1 from rms.rpm_clearance rc where rc.SKULIST = sh.SKULIST and rc.zone_id = p_zone_id)
                and rownum <='1' order by sh.SKULIST desc;
      
BEGIN

for m in 0..14 loop

    select vdate+1+m into p_effective_date from rms.period;
    select vdate+4+m into p_out_of_stock_date from rms.period;
    select vdate+4+m into p_reset_date from rms.period;
    
    for k in c_get_loc loop
 	     p_zone_id := k.zone_id;
         p_Location := k.store;
         
            for cust_ma in c_get_cuitem_clr (p_zone_id)  loop 
                  EXIT WHEN c_get_cuitem_clr%NOTFOUND;
                     p_itemlist_id                := cust_ma.SKULIST;
                                
            select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into p_clear_stage_id from dual;         
             
              insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      skulist,													
                                                      zone_id,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_amount,
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_itemlist_id ,
                                                       p_zone_id,
                                                       1,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       2,
                                                       '0.1',
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
    
       insert into skumar.ma_stage_clearance_bk (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      skulist,													
                                                      zone_id,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_amount,
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_itemlist_id ,
                                                       p_zone_id,
                                                       1,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       2,
                                                       '.1',
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
    
    
                            END LOOP;   
               
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
                  --  COMMIT;
                  continue;
                   END IF;	
           
      END LOOP; 
      END LOOP; 
 commit;
  
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/




--- Clearances - Option levels --

set serveroutput on;
set timing on;
 
DECLARE
 
 COUNTER         NUMBER(8)     := 0;
 COUNTER_COMMIT  NUMBER(8)     := 1;
 stage_COMMIT  NUMBER(8)     := 0;
 
   p_clear_stage_id             ma_asos.ma_stage_clearance.stage_clearance_id%type;   
   p_item_id                    ma_asos.ma_stage_clearance.item%type;
   p_reason_code                ma_asos.ma_stage_clearance.reason_code%type;
   p_Location                   ma_asos.ma_stage_clearance.location%type;
   p_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   p_effective_date             ma_asos.ma_stage_clearance.effective_date%type;  
   p_out_of_stock_date          ma_asos.ma_stage_clearance.out_of_stock_date%type; 
   p_reset_date                 ma_asos.ma_stage_clearance.reset_date%type; 
   p_change_percent             ma_asos.ma_stage_price_change.change_percent%type;   
   p_status                     ma_asos.ma_stage_price_change.status%type; 
   l_selling_unit_retail   		rms.rpm_stage_clearance.change_amount%type;
   l_selling_uom                rms.item_loc.SELLING_UOM%type;
   l_zone_id                    ma_asos.ma_stage_clearance.zone_id%type;
   l_location                    ma_asos.ma_stage_clearance.location%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 

		cursor cur_dept_a is --2613
		select dept,class,subclass,zone_id,store  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 1001 and 1051 and rownum<='100'
			group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) order by 1,2,3,4;
   
		cursor cur_dept_p is --7007
		select dept,class,subclass,zone_id,store  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 1052 and 2010 and rownum<='200'
			group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) order by 1,2,3,4;
   
		cursor cur_dept_f is -- 6643
		select dept,class,subclass,zone_id,store  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 2011 and 2156 and rownum<='200'
			group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) order by 1,2,3,4;

	
	 
	 cursor c_get_cuitem_clr (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type,
                            l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
				select  ITEM, LOCATION, zone_id,SELLING_UNIT_RETAIL from (
                select distinct im.item,ma.zone_id,il.loc as location,il.selling_unit_retail as selling_unit_retail
                        from rms.item_master     im,
                        ma_asos.ma_pricing_defaults ma ,
                             rms.item_loc il             
                        where im.dept =  l_dept
                         and im.class = l_class
                         and im.subclass = l_subclass
                         and im.item_level < im.tran_level 
                         and il.item = im.item
                         and il.selling_unit_retail  >='3' 
                         and il.loc = l_location
                         and ma.store = il.loc
                     --    and not exists (select 1 from rms.item_loc il where il.item_parent = im.item and (il.promo_retail is null or il.CLEAR_IND ='Y') and il.loc = l_location and rownum <= '1')
                         and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.item = im.item  and mpc.location = il.loc) 
                         and rownum<=1 )
                          order by item, 
                                location;
      
BEGIN

for m in 0..1 loop

for j in 0..5 loop

    select vdate+11+m into p_effective_date from rms.period;
    select vdate+22+m+j into p_out_of_stock_date from rms.period;
    select vdate+22+m+j into p_reset_date from rms.period;
    
    
    for k in cur_dept_a loop
            l_dept      := k.dept;
            l_class     := k.class;
            l_subclass  := k.subclass;
            l_zone_id   := k.zone_id;
            l_location   := k.store;
            
            for cust_ma in c_get_cuitem_clr(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
                  EXIT WHEN c_get_cuitem_clr%NOTFOUND;
                     p_item_id                := cust_ma.item;
                     p_zone_id                := cust_ma.zone_id;
                     p_location               := cust_ma.location;
                     l_selling_unit_retail	  := cust_ma.selling_unit_retail -1.5;	
                                
            select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into p_clear_stage_id from dual;         
             
              insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      item,													
                                                      location,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_amount,
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_item_id ,
                                                       p_location ,
                                                       0,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       1,
                                                       '-0.95',
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
    
                            END LOOP;   
               
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
                    COMMIT;
                   END IF;	
           
      END LOOP; 
      
    for k in cur_dept_p loop
            l_dept      := k.dept;
            l_class     := k.class;
            l_subclass  := k.subclass;
            l_zone_id  := k.zone_id;
            l_location   := k.store;
            
            for cust_ma in c_get_cuitem_clr(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
                   EXIT WHEN c_get_cuitem_clr%NOTFOUND;
                     p_item_id                := cust_ma.item;
                     p_zone_id                := cust_ma.zone_id;
                     p_location               := cust_ma.location;
                     l_selling_unit_retail	  := cust_ma.selling_unit_retail;	
                                
            select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into p_clear_stage_id from dual;         
             
              insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      item,													
                                                      location,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_percent,
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_item_id ,
                                                       p_location ,
                                                       0,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       0,
                                                       '-50',
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
    
                            END LOOP;   
        COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
                    COMMIT;
                   END IF;	
           
      END LOOP; 
    
    for k in cur_dept_f loop
            l_dept      := k.dept;
            l_class     := k.class;
            l_subclass  := k.subclass;
            l_zone_id  := k.zone_id;
            l_location   := k.store;
            
            for cust_ma in c_get_cuitem_clr(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
                    EXIT WHEN c_get_cuitem_clr%NOTFOUND;
                    p_item_id                := cust_ma.item;
                     p_zone_id                := cust_ma.zone_id;
                     p_location               := cust_ma.location;
                     l_selling_unit_retail	  := cust_ma.selling_unit_retail -1.8;	
                                
            select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into p_clear_stage_id from dual;         
             
              insert into ma_asos.ma_stage_clearance (stage_clearance_id,                                                  
                                                      message_seq,                                                  
                                                      message_type,
                                                      reason_code,												
                                                      item,													
                                                      location,													
                                                      zone_node_type,											
                                                      effective_date,
                                                      out_of_stock_date,
                                                      reset_date,
                                                      change_type,
                                                      change_amount,
                                                      auto_approve_ind,
                                                      status,
                                                      vendor_funded_ind,
                                                      create_datetime,
                                                      last_update_datetime,
                                                      create_id,
                                                      last_update_id)
    
                                    values            (p_clear_stage_id ,
                                                       1,
                                                       'A', 
                                                       20,
                                                       p_item_id ,
                                                       p_location ,
                                                       0,
                                                       p_effective_date,
                                                       p_out_of_stock_date,
                                                       p_reset_date,
                                                       2,
                                                       l_selling_unit_retail,
                                                       1,
                                                      'N',
                                                       0,
                                                       sysdate,
                                                       sysdate,
                                                       'PTUSER',
                                                       'PTUSER');
    
                            END LOOP;   
        COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
                    COMMIT;
                   END IF;	
           
      END LOOP; 
     
  END LOOP; 
    END LOOP; 
  commit;
  
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/


------------------- Retention period  Clearance s



set serveroutput on;
set timing on;

declare

  COUNTER         NUMBER(8)     := 0;
  COUNTER_COMMIT  NUMBER(8)     := 1000;
  i1 NUMBER := 10 ;  

  stage_COMMIT  NUMBER(8)     := 0;
 
   l_item_id               rms.rpm_stage_clearance.item%type;
   l_effective_date        rms.rpm_stage_clearance.effective_date%type;
   l_selling_unit_retail   rms.rpm_stage_clearance.change_amount%type;
   l_outofstock_date       rms.rpm_stage_clearance.out_of_stock_date%type;
   l_reset_date       	   rms.rpm_stage_clearance.reset_date%type; 
   l_reasoncode            rms.rpm_stage_clearance.reason_code%type;
   l_zone_id               rms.rpm_stage_clearance.zone_id%type;
      ma_zone_id              	rms.rpm_stage_clearance.zone_id%type;
   l_location              rms.rpm_stage_clearance.location%type;
   l_change_percent        rms.rpm_stage_clearance.change_percent%type;
   l_clear_stage_id		   rms.rpm_stage_clearance.stage_clearance_id%type;
   l_dept                	rms.subclass.dept%type; 
   l_class                	rms.subclass.class%type; 
   l_subclass               rms.subclass.subclass%type; 
   
    cursor cur_dept is
	select dept,class,subclass,zone_id  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID from skumar.item_master_op im, ma_asos.ma_pricing_defaults ma 
            group by im.dept,im.class,im.subclass, ma.ZONE_ID ) 
            --where rownum<= '1000' 
            order by 1,2,3,4;
                
    CURSOR c_get_cuitem_clr (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type,l_zone_id rms.rpm_stage_simple_promo.zone_id%type)is
            select      im.item,
                        ma.zone_id,
						ma.store as location,
						il.selling_unit_retail as current_retail
				from rms.item_loc        il,
					 skumar.item_master_op     im,
					 ma_asos.ma_pricing_defaults ma,
					 rms.rpm_zone_location rzl
				where il.item             = im.item
				 and im.dept =l_dept
                 and im.class =l_class
                 and im.subclass =l_subclass
				 and il.clear_ind ='N'
				 and il.selling_unit_retail >= '8'
				 and il.loc = ma.store
				 and rzl.location = ma.store
				 and rzl.zone_id =ma.zone_id
                 and ma.zone_id =l_zone_id
                 and not exists (select 1 from rms.rpm_stage_clearance rpc  where rpc.item = im.item and rpc.location = ma.store)
                	  and rownum<=1
                  order by item,
						zone_id, 
						location;


begin
  
    for m in 0..1 loop

    select vdate+1+m   into l_effective_date from rms.period;
    select vdate+5+m into l_outofstock_date from rms.period;
    select vdate+5+m into l_reset_date from rms.period;   


for k in cur_dept loop
  l_dept := k.dept;
    l_class := k.class;
      l_subclass := k.subclass;	  
         ma_zone_id := k.zone_id;
      
		for l_loop in c_get_cuitem_clr(l_dept,l_class,l_subclass,ma_zone_id) loop 
		   EXIT WHEN c_get_cuitem_clr%NOTFOUND;
    		l_item_id			:= l_loop.item;
			l_zone_id			:= l_loop.zone_id;
            l_location			:= l_loop.location;

			l_selling_unit_retail	:= l_loop.current_retail-1.5;	

		select rms.RPM_STAGE_CLEARANCE_SEQ.nextval into l_clear_stage_id from dual;
			
			insert into rms.rpm_stage_clearance (stage_clearance_id,
												reason_code,
												item,
												Location,
												zone_node_type,
												effective_date,
												out_of_stock_date,
												reset_date,
												change_type,
												CHANGE_PERCENT,
												auto_approve_ind,
												status,
												vendor_funded_ind)
			values (l_clear_stage_id,
					l_reasoncode,
					l_item_id,
					l_location,
					0, 
					l_effective_date,
					l_outofstock_date,
					l_reset_date,
					0,
					'-40',
					1,
					'N',
					0);
	
		   COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 4) = 0 THEN
				COMMIT;
			   END IF;
		  end loop;

    end loop;  
		    end loop; 
            
exception

   when others then
   
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;

end;
/

select * from rpm_stage_clearance;

delete from rpm_stage_clearance;



select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-15';  --   1549
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-16';  --  11955
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-17';  --  46528
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-18';  -- 262524
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-19'; -- 2661953
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-20'; -- 6873053    7M
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-21'; --13203128   13M
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-22'; --17418830   17M
select count(1) from  rpm_clearance where trunc(EFFECTIVE_DATE)<= '26-MAR-23'; --23292294   23M



select count(1) from  rpm_clearance; --23292301

select count(1) from  rpm_clearance_reset where trunc(EFFECTIVE_DATE)<= '26-MAR-15' ; --1549

select * from rpm_future_retail;