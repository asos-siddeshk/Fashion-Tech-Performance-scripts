drop table ma_stage_price_change_bk;
create table ma_stage_price_change_bk as
select * from ma_asos.ma_stage_price_change;
delete from ma_asos.ma_stage_price_change;
insert into ma_asos.ma_stage_price_change  select * from ma_stage_price_change_bk ;

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1; --

select * from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1; --

select * from ma_asos.ma_price_change; --439569

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1; --
delete  from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete  from ma_asos.ma_stage_price_change where status='N';

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE='A' group by EFFECTIVE_DATE order by 1; --

01-MAR-20	3134
02-MAR-20	16335

sElEct 3134+16335 from Dual;

delete from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE)= '01-MAR-20' and status ='N' and MESSAGE_TYPE='A' and rownum <= '15319'; --
delete from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE)= '02-MAR-20' and status ='N' and MESSAGE_TYPE='A' and rownum <= '1825'; --

sElEct 18160-16335 from Dual;
18160

create table rpm_price_change_bk as
select * from rpm_price_change where trunc(EFFECTIVE_DATE)= '02-MAR-20'; --480

select * from rpm_price_change_bk where trunc(EFFECTIVE_DATE)= '02-MAR-20'; --18322
select * from rpm_price_change where trunc(EFFECTIVE_DATE)= '02-MAR-20'; --27522

delete from rpm_stage_price_change;
delete from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE) = '02-MAR-20' and rownum <= '7135';
delete from ma_asos.ma_stage_price_change where trunc(EFFECTIVE_DATE) = '';

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1; --


select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1; --

select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS;
select  EFFECTIVE_DATE,count(1) from rms.rpm_stage_price_change group by EFFECTIVE_DATE order by 1; --
select state,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '23-DEC-18' and '30-JAN-19' group by state; -- 5008
select EFFECTIVE_DATE,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '23-DEC-18' and '30-JAN-19' and state ='pricechange.state.approved' group by EFFECTIVE_DATE; -- 5008
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1; --
Update ma_asos.ma_stage_price_change set EFFECTIVE_DATE ='31-JAN-19' where EFFECTIVE_DATE ='28-JAN-19'
    and status ='N' and MESSAGE_TYPE='A'and rownum<='1000';
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE='A' group by EFFECTIVE_DATE order by 1; --

select vdate from rms.period;
select count(1) from ma_asos.ma_price_change; --439569
select count(1) from ma_asos.ma_stage_price_change where status='N';  --6601 / 6601 - Outlet / 6601 - Reprice 

select * from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');

delete  from ma_asos.ma_price_change where RMS_PRICE_CHANGE_ID in (select PRICE_CHANGE_ID from ma_asos.ma_stage_price_change where status='N');
delete  from ma_asos.ma_stage_price_change where status='N';


select * from ma_asos.ma_stage_price_change where status='N' and PRICE_CHANGE_ID in ();
select count(1) from ma_asos.ma_stage_price_change where status='N';

delete from rms.rpm_stage_price_change where status='N';  --


select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1; --

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status!='N' group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE='A' group by EFFECTIVE_DATE order by 1; --
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' and MESSAGE_TYPE!='A' group by EFFECTIVE_DATE order by 1; --
select * from ma_asos.ma_stage_price_change where status ='N';  --90000
select * from ma_asos.ma_stage_price_change where MESSAGE_TYPE='A';  --
select * from ma_asos.ma_stage_price_change where MESSAGE_TYPE!='A';  --
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS;
select count(1) from rms.rpm_stage_price_change where status ='N';
select count(1) from rms.rpm_stage_price_change where status ='W' and ERROR_MESSAGE is null;
select count(1) from rms.rpm_stage_price_change where status ='W' and ERROR_MESSAGE is not null;
select count(1) from rms.rpm_stage_price_change where status ='A';

select * from rms.rpm_stage_price_change where status ='E';

select EFFECTIVE_DATE,count(1) from rms.rpm_stage_price_change group by EFFECTIVE_DATE order by 1; --16076 --16684
select state,count(1) from rpm_price_change where price_change_id in (select  price_change_id from rms.rpm_stage_price_change) group by state;
select * from rpm_price_change where EFFECTIVE_DATE between '09-MAY-21' and '10-MAY-21' order by 1 desc;
select state,count(1) from rpm_price_change where EFFECTIVE_DATE between '09-MAY-21' and '10-MAY-21' group by state; -- 5008
select EFFECTIVE_DATE,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '10-JAN-19' and '25-JAN-19' and state ='pricechange.state.approved' group by EFFECTIVE_DATE; -- 5008


select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' --and MESSAGE_TYPE='A'  
group by EFFECTIVE_DATE order by 1; --

select * from period;
select * from ma_asos.ma_pricing_defaults;



--alter session set current_schema=int_asos;

----------------------------------------------------------------A ----------------------------------------------------------------
set serveroutput on;
set timing on;
 
DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1;
  
   p_pc_s_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_item_id                    ma_asos.ma_price_change.item%type;
   p_zone_id                    ma_asos.ma_price_change.zone_id%type;
   p_location                   ma_asos.ma_price_change.location%type;
   p_effective_date             ma_asos.ma_price_change.effective_date%type;  
   p_current_retail             ma_asos.ma_price_change.current_price%type;
   p_new_retail              	ma_asos.ma_price_change.current_price%type;
   p_pc_d_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_pc_stage_id                ma_asos.ma_price_change.price_change_id%type;
   p_pc_c_stage_id              ma_asos.ma_price_change.CUST_ATTR_ID%type;
   p_currency_code 				ma_asos.ma_price_change.currency_code%type;
   P_PC_TRAN_ID                 ma_asos.ma_price_change.TRANS_ID%type;
   P_TRAN_ID                    ma_asos.ma_price_change.TRANS_ID%type;
   O_error_message              ma_asos.MA_LOGS.MSG_CODE%TYPE;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                   rms.subclass.subclass%type; 
   ma_zone_id              	    rms.rpm_stage_clearance.zone_id%type;
   ma_location              	rms.rpm_stage_clearance.location%type;

		  
	 cursor cur_dept is --16991
		select dept,class,subclass,zone_id,store from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			dept!='9999'  or subclass!='9999'or class!='9999' 
            group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) 
                where rownum <= '2000';
	
	CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type,l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
                select * from ( select im.item,
                                            ma.zone_id,
                                            s.currency_code,
                                            il.loc as location,
                                            il.selling_unit_retail as current_retail,
                                            il.selling_unit_retail + 2 as new_retail
                      from skumar.item_master_op             im,
                           ma_asos.ma_pricing_defaults ma,
                           rms.item_loc                il,
                           rms.store                   s
                     where im.item_level < im.tran_level
                       and im.dept = l_dept
                       and im.class = l_class
                       and im.subclass = l_subclass
                       and il.item = im.item
                       and il.loc = l_location
                       and s.store = il.loc
                       and ma.store = il.loc
                       and not exists (select 1 from ma_asos.ma_price_change mc
                             where mc.item = im.item
                               and mc.LOCATION = il.loc
                               and mc.EFFECTIVE_DATE between '01-FEB-2021' and '30-JUN-2021')) where rownum <= 5;

 
 				 
BEGIN    

for j in 0..0 loop

    select vdate+1 into p_effective_date from rms.period;
      
for k in cur_dept loop
  l_dept := k.dept;
    l_class := k.class;
      l_subclass := k.subclass;
	     ma_zone_id := k.zone_id;
         ma_location := k.store;
         
         
   FOR cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass,ma_zone_id,ma_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
        
        select ma_asos.MA_PRICE_CHANGE_TRANS_SEQ.nextval into  p_pc_tran_id from dual;
   
                p_item_id                   := cust_ma.item;  
                p_zone_id                   := cust_ma.zone_id;
                p_Location                  := cust_ma.location;
                p_current_retail            := cust_ma.current_retail;
				p_new_retail             	:= cust_ma.new_retail;
				p_CURRENCY_CODE             := cust_ma.currency_code; 							
                
                select rms.RPM_PRICE_CHANGE_DISPLAY_SEQ.nextval into p_pc_d_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_SEQ.nextval into p_pc_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_CUST_ATTR_SEQ.nextval into p_pc_c_stage_id from dual;
   
                insert into ma_asos.ma_price_change ( 	trans_id        , 
														price_change_id , 
														zone_group_id   , 
														zone_id         , 
														location        , 
														currency_code   , 
														item            , 
														effective_date  , 
														reason_code     , 
														status          ,
														new_price           ,
														new_margin          ,
														create_datetime     ,
														last_update_datetime,
														create_id           ,
														last_update_id      ,
														rms_price_change_id ,
                                                        CURRENT_PRICE, 
                                                        CURRENT_MARGIN,
                                                        CUST_ATTR_ID,
                                                        CONV_LANDED_VALUE)
                                values                  (p_pc_tran_id,
														p_pc_d_stage_id,
														2,
														p_zone_id,
														p_location,
														p_currency_code,
														p_item_id,
														p_effective_date,
														12,
														'W',
														p_new_retail,
														((p_current_retail-p_new_retail)/p_current_retail),
														sysdate,
														sysdate,
														'PTUSER',
														'PTUSER',
														p_pc_stage_id,
                                                        p_current_retail,
                                                        ((p_current_retail+p_new_retail)/p_current_retail),
                                                        p_pc_c_stage_id,
                                                        ((p_current_retail+p_new_retail)/p_current_retail)-((p_current_retail-p_new_retail)/p_current_retail) );
														
           
				if ma_asos.ma_pricing_sql.update_pricing_change(O_error_message,p_pc_tran_id,'A') = false then
							--   dbms_output.put_line( p_pc_tran_id||': Failed'||O_error_message);
            continue;
                               else 
                            --  dbms_output.put_line('Sucess' || p_pc_tran_id);
            continue;
				end if;

	
 
END LOOP; 

        COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 5) = 0 THEN
				continue; 
                COMMIT;
			   END IF;	
  END LOOP; 
    END LOOP; 
    
    COMMIT;
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/




---------------------------------------------------------------- Not class,subclass ----------------------------------------------------------------
set serveroutput on;
set timing on;
 
DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1;
  
   p_pc_s_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_item_id                    ma_asos.ma_price_change.item%type;
   p_zone_id                    ma_asos.ma_price_change.zone_id%type;
   p_location                   ma_asos.ma_price_change.location%type;
   p_effective_date             ma_asos.ma_price_change.effective_date%type;  
   p_current_retail             ma_asos.ma_price_change.current_price%type;
   p_new_retail              	ma_asos.ma_price_change.current_price%type;
   p_pc_d_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_pc_stage_id                ma_asos.ma_price_change.price_change_id%type;
   p_pc_c_stage_id              ma_asos.ma_price_change.CUST_ATTR_ID%type;
   p_currency_code 				ma_asos.ma_price_change.currency_code%type;
   P_PC_TRAN_ID                 ma_asos.ma_price_change.TRANS_ID%type;
   P_TRAN_ID                    ma_asos.ma_price_change.TRANS_ID%type;
   O_error_message              ma_asos.MA_LOGS.MSG_CODE%TYPE;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                   rms.subclass.subclass%type; 
   ma_zone_id              	    rms.rpm_stage_clearance.zone_id%type;
   ma_location              	rms.rpm_stage_clearance.location%type;

		  
	 cursor cur_dept is --16991
		select dept,zone_id,store from (
		   select distinct im.dept,ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			dept!='9999'  or subclass!='9999'or class!='9999' 
            group by im.dept,ma.ZONE_ID,ma.store);
	
	CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
                select * from ( select im.item,
                                            ma.zone_id,
                                            s.currency_code,
                                            il.loc as location,
                                            il.selling_unit_retail as current_retail,
                                            il.selling_unit_retail + 2 as new_retail
                      from skumar.item_master_op             im,
                           ma_asos.ma_pricing_defaults ma,
                           rms.item_loc                il,
                           rms.store                   s
                     where im.item_level < im.tran_level
                       and im.dept = l_dept
                       and il.item = im.item
                       and il.loc = l_location
                       and s.store = il.loc
                       and ma.store = il.loc
                       and not exists (select 1 from rms.rpm_price_change mpc
                             where mpc.item = im.item
                               and mpc.LOCATION = il.loc
                               and mpc.EFFECTIVE_DATE between '01-FEB-2021' and '30-JUN-2021')
                       and not exists (select 1 from ma_asos.ma_price_change mc
                             where mc.item = im.item
                               and mc.LOCATION = il.loc
                               and mc.EFFECTIVE_DATE between '01-FEB-2021' and '30-JUN-2021')) where rownum <= 1;

 
 				 
BEGIN    

for j in 1..7 loop

    select vdate+j into p_effective_date from rms.period;
      
for k in cur_dept loop
  l_dept := k.dept;
	     ma_zone_id := k.zone_id;
         ma_location := k.store;
         
         
   FOR cust_ma in c_get_cuitem_pc(l_dept,ma_zone_id,ma_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
        
        select ma_asos.MA_PRICE_CHANGE_TRANS_SEQ.nextval into  p_pc_tran_id from dual;
   
                p_item_id                   := cust_ma.item;  
                p_zone_id                   := cust_ma.zone_id;
                p_Location                  := cust_ma.location;
                p_current_retail            := cust_ma.current_retail;
				p_new_retail             	:= cust_ma.new_retail;
				p_CURRENCY_CODE             := cust_ma.currency_code; 							
                
                select rms.RPM_PRICE_CHANGE_DISPLAY_SEQ.nextval into p_pc_d_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_SEQ.nextval into p_pc_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_CUST_ATTR_SEQ.nextval into p_pc_c_stage_id from dual;
   
                insert into ma_asos.ma_price_change ( 	trans_id        , 
														price_change_id , 
														zone_group_id   , 
														zone_id         , 
														location        , 
														currency_code   , 
														item            , 
														effective_date  , 
														reason_code     , 
														status          ,
														new_price           ,
														new_margin          ,
														create_datetime     ,
														last_update_datetime,
														create_id           ,
														last_update_id      ,
														rms_price_change_id ,
                                                        CURRENT_PRICE, 
                                                        CURRENT_MARGIN,
                                                        CUST_ATTR_ID,
                                                        CONV_LANDED_VALUE)
                                values                  (p_pc_tran_id,
														p_pc_d_stage_id,
														2,
														p_zone_id,
														p_location,
														p_currency_code,
														p_item_id,
														p_effective_date,
														12,
														'W',
														p_new_retail,
														((p_current_retail-p_new_retail)/p_current_retail),
														sysdate,
														sysdate,
														'PTUSER',
														'PTUSER',
														p_pc_stage_id,
                                                        p_current_retail,
                                                        ((p_current_retail+p_new_retail)/p_current_retail),
                                                        p_pc_c_stage_id,
                                                        ((p_current_retail+p_new_retail)/p_current_retail)-((p_current_retail-p_new_retail)/p_current_retail) );
														
           
				if ma_asos.ma_pricing_sql.update_pricing_change(O_error_message,p_pc_tran_id,'A') = false then
							--   dbms_output.put_line( p_pc_tran_id||': Failed'||O_error_message);
            continue;
                               else 
                            --  dbms_output.put_line('Sucess' || p_pc_tran_id);
            continue;
				end if;

	
 
END LOOP; 

        COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				continue; 
                COMMIT;
			   END IF;	
  END LOOP; 
    END LOOP; 
    
    COMMIT;
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/


---------------- 

----------------------------------------------------------------W ----------------------------------------------------------------
set serveroutput on;
set timing on;
 
DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1;
  
   p_pc_s_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_item_id                    ma_asos.ma_price_change.item%type;
   p_zone_id                    ma_asos.ma_price_change.zone_id%type;
   p_location                   ma_asos.ma_price_change.location%type;
   p_effective_date             ma_asos.ma_price_change.effective_date%type;  
   p_current_retail             ma_asos.ma_price_change.current_price%type;
   p_new_retail              	ma_asos.ma_price_change.current_price%type;
   p_pc_d_stage_id              ma_asos.ma_price_change.price_change_id%type;
   p_pc_stage_id                ma_asos.ma_price_change.price_change_id%type;
   p_pc_c_stage_id              ma_asos.ma_price_change.CUST_ATTR_ID%type;
   p_currency_code 				ma_asos.ma_price_change.currency_code%type;
   P_PC_TRAN_ID                 ma_asos.ma_price_change.TRANS_ID%type;
   P_TRAN_ID                    ma_asos.ma_price_change.TRANS_ID%type;
   O_error_message              ma_asos.MA_LOGS.MSG_CODE%TYPE;
       l_dept                	rms.subclass.dept%type; 
   l_class                	rms.subclass.class%type; 
   l_subclass               rms.subclass.subclass%type; 
	      ma_zone_id              	rms.rpm_stage_clearance.zone_id%type;
          ma_location              	rms.rpm_stage_clearance.location%type;


		  
	 cursor cur_dept is --16991
		select dept,zone_id,store from (
		   select distinct im.dept,ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999'  or subclass!='9999'or class!='9999') --and ma.store = '20006'
            group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store);
	
	CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
                        select * from ( select im.item,
                                            ma.zone_id,
                                            s.currency_code,
                                            il.loc as location,
                                            il.selling_unit_retail as current_retail,
                                            il.selling_unit_retail + 2 as new_retail
                      from skumar.item_master_op             im,
                           ma_asos.ma_pricing_defaults ma,
                           rms.item_loc                il,
                           rms.store                   s
                     where im.item_level < im.tran_level
                       and im.dept = l_dept
                       and il.item = im.item
                       and il.loc = l_location
                       and s.store = il.loc
                       and ma.store = il.loc
                       and not exists (select 1 from ma_asos.ma_price_change mc
                             where mc.item = im.item
                               and mc.LOCATION = il.loc
                               and mc.EFFECTIVE_DATE between '01-MAY-2021' and '30-AUG-2021')) where rownum <= 10;

 
 				 
BEGIN    

for j in 2..10 loop
    select vdate+j into p_effective_date from rms.period;
      
for k in cur_dept loop
  l_dept := k.dept;
	     ma_zone_id := k.zone_id;
         ma_location := k.store;
         
         
   FOR cust_ma in c_get_cuitem_pc(l_dept,ma_zone_id,ma_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
        
        select ma_asos.MA_PRICE_CHANGE_TRANS_SEQ.nextval into  p_pc_tran_id from dual;
   
                p_item_id                   := cust_ma.item;  
                p_zone_id                   := cust_ma.zone_id;
                p_Location                  := cust_ma.location;
                p_current_retail            := cust_ma.current_retail;
				p_new_retail             	:= cust_ma.new_retail;
				p_CURRENCY_CODE             := cust_ma.currency_code; 							
                
                select rms.RPM_PRICE_CHANGE_DISPLAY_SEQ.nextval into p_pc_d_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_SEQ.nextval into p_pc_stage_id from dual;
                select rms.RPM_PRICE_CHANGE_CUST_ATTR_SEQ.nextval into p_pc_c_stage_id from dual;
   
                insert into ma_asos.ma_price_change ( 	trans_id        , 
														price_change_id , 
														zone_group_id   , 
														zone_id         , 
														location        , 
														currency_code   , 
														item            , 
														effective_date  , 
														reason_code     , 
														status          ,
														new_price           ,
														new_margin          ,
														create_datetime     ,
														last_update_datetime,
														create_id           ,
														last_update_id      ,
														rms_price_change_id ,
                                                        CURRENT_PRICE, 
                                                        CURRENT_MARGIN,
                                                        CUST_ATTR_ID,
                                                        CONV_LANDED_VALUE)
                                values                  (p_pc_tran_id,
														p_pc_d_stage_id,
														2,
														p_zone_id,
														p_location,
														p_currency_code,
														p_item_id,
														p_effective_date,
														12,
														'W',
														p_new_retail,
														((p_current_retail-p_new_retail)/p_current_retail),
														sysdate,
														sysdate,
														'PTUSER',
														'PTUSER',
														p_pc_stage_id,
                                                        p_current_retail,
                                                        ((p_current_retail+p_new_retail)/p_current_retail),
                                                        p_pc_c_stage_id,
                                                        ((p_current_retail+p_new_retail)/p_current_retail)-((p_current_retail-p_new_retail)/p_current_retail) );
														

 
   END LOOP; 
    COMMIT;

  END LOOP; 
    END LOOP; 
    
    COMMIT;
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

------------------------------------------------------------ Retention period ----------------------------------------------------------------
select count(1) from rms.rpm_stage_price_change;
select change_type,count(1) from rms.rpm_stage_price_change group by change_type;
select effective_date,count(1) from rms.rpm_stage_price_change group by effective_date;
select * from option_item;


set serveroutput on;
set timing on;
 
DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1;

	l_stage_price_change_id   ma_asos.ma_stage_price_change.stage_price_change_id%type; 
	l_item                    ma_asos.ma_stage_price_change.item%type;
	l_location                ma_asos.ma_stage_price_change.location%type;
	l_zone_id                 ma_asos.ma_stage_price_change.zone_id%type;
	l_effective_date          ma_asos.ma_stage_price_change.effective_date%type;
	l_change_amount           ma_asos.ma_stage_price_change.change_amount%type;
	l_change_selling_uom      ma_asos.ma_stage_price_change.change_selling_uom%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 
	 
 
	
     CURSOR c_get_cuitem_pc   is 
		  select  ITEM, LOCATION,CHANGE_AMOUNT,change_selling_uom from (
                select distinct im.item,il.loc as location,il.selling_unit_retail as CHANGE_AMOUNT,il.SELLING_UOM as change_selling_uom
                        from rms.item_master     im,
                        ma_asos.ma_pricing_defaults ma ,
                             rms.item_loc il ,
                             rms.store s,
                             skumar.option_item oi
                        where oi.item= im.item and il.item_parent = im.item
                         and s.store = il.loc
                         and ma.store = il.loc
                         and il.loc = '20000'
                         and not exists (select 1 from rms.rpm_stage_price_change rspc  where rspc.item = im.item and rspc.location = il.loc)
                         and im.item_level < im.tran_level ) where rownum<=100
                          order by item, 
                                location;

BEGIN    

for j in 0..4 loop
    select vdate+1 into l_effective_date from rms.period;

for k in cur_dept_p loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
        l_location  := k.store;
           
           
		for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
                l_item                      := cust_ma.item;  
                l_Location                  := cust_ma.location;
				l_CHANGE_AMOUNT           	:= cust_ma.CHANGE_AMOUNT;
                l_change_selling_uom        := cust_ma.change_selling_uom;
                
        select rms.RPM_STAGE_PRICE_CHANGE_SEQ.nextval into l_stage_price_change_id from dual;
        
            insert into rms.rpm_stage_price_change  (stage_price_change_id , 
                                                        reason_code           ,
                                                        item                  ,
                                                        location              ,
                                                        zone_node_type        ,
                                                        effective_date        ,
                                                        change_type           ,
                                                        change_amount         ,
                                                        change_selling_uom    ,
                                                        change_percent        ,
                                                        null_multi_ind        ,
                                                        ignore_constraints    ,
                                                        auto_approve_ind      ,
                                                        status                ,
                                                        vendor_funded_ind     )
                                                values (l_stage_price_change_id,
                                                        12,
                                                        l_item,
                                                        l_location,
                                                        '0',
                                                        l_effective_date,
                                                        0,
                                                        null,
                                                        null,
                                                        '30',
                                                        0,
                                                        1,
                                                        1,
                                                        'N',
                                                        0);         
       
 
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                           IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                            COMMIT;
                           END IF;	
          END LOOP; 
          END LOOP; 

for k in cur_dept_f loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
        l_location  := k.store;

		for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
                l_item                      := cust_ma.item;  
                l_Location                  := cust_ma.location;
				l_CHANGE_AMOUNT           	:= cust_ma.CHANGE_AMOUNT+2;
                l_change_selling_uom        := cust_ma.change_selling_uom;
                
        select rms.RPM_STAGE_PRICE_CHANGE_SEQ.nextval into l_stage_price_change_id from dual;
        
            insert into rms.rpm_stage_price_change  (stage_price_change_id , 
                                                        reason_code           ,
                                                        item                  ,
                                                        location              ,
                                                        zone_node_type        ,
                                                        effective_date        ,
                                                        change_type           ,
                                                        change_amount         ,
                                                        change_selling_uom    ,
                                                        change_percent        ,
                                                        null_multi_ind        ,
                                                        ignore_constraints    ,
                                                        auto_approve_ind      ,
                                                        status                ,
                                                        vendor_funded_ind      )
                                                values (l_stage_price_change_id,
                                                        12,
                                                        l_item,
                                                        l_location,
                                                        '0',
                                                        l_effective_date,
                                                        2,
                                                        l_CHANGE_AMOUNT,
                                                        l_change_selling_uom,
                                                        null,
                                                        0,
                                                        1,
                                                        1,
                                                        'N',
                                                        0);         
       
 
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                           IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
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




set serveroutput on;
set timing on;
 
DECLARE

	COUNTER_COMMIT  NUMBER(8)     := 1;

	l_stage_price_change_id   ma_asos.ma_stage_price_change.stage_price_change_id%type; 
	l_item                    ma_asos.ma_stage_price_change.item%type;
	l_location                ma_asos.ma_stage_price_change.location%type;
	l_zone_id                 ma_asos.ma_stage_price_change.zone_id%type;
	l_effective_date          ma_asos.ma_stage_price_change.effective_date%type;
	l_change_amount           ma_asos.ma_stage_price_change.change_amount%type;
	l_change_selling_uom      ma_asos.ma_stage_price_change.change_selling_uom%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 
	 
 
		cursor cur_dept_a is --2613
		select dept,class,subclass,zone_id,store  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 1001 and 1051 and rownum<='1'
			group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) order by 1,2,3,4;
   
		cursor cur_dept_p is --7007
		select dept,class,subclass,zone_id,store  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 1052 and 2010 and rownum<='1'
			group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) order by 1,2,3,4;
   
		cursor cur_dept_f is -- 6643
		select dept,class,subclass,zone_id,store  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 2011 and 2156 and rownum<='1'
			group by im.dept,im.class,im.subclass, ma.ZONE_ID,ma.store) order by 1,2,3,4;

	
     CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type,
                        l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.zone_id%type)is
		  select  ITEM, LOCATION,CHANGE_AMOUNT,change_selling_uom from (
                select distinct im.item,il.loc as location,il.selling_unit_retail as CHANGE_AMOUNT,il.SELLING_UOM as change_selling_uom
                        from rms.item_master     im,
                        ma_asos.ma_pricing_defaults ma ,
                             rms.item_loc il ,
                             rms.store s
                        where im.dept =  l_dept
                         and im.class = l_class
                         and im.subclass = l_subclass
                         and il.item_parent = im.item
                         and il.selling_unit_retail  >='3' 
                         and il.loc = l_location
                         and s.store = il.loc
                         and ma.store = il.loc
                         and not exists (select 1 from rms.item_loc il where il.item_parent = im.item and (il.promo_retail is null or il.CLEAR_IND ='Y') and il.loc = l_location and rownum <= '1')
                         and not exists (select 1 from rms.rpm_stage_simple_promo rpc  where rpc.item = im.item and rpc.location = il.loc)
                         and not exists (select 1 from rms.rpm_stage_price_change rspc  where rspc.item = im.item and rspc.location = il.loc)
                         and not exists (select 1 from rms.rpm_stage_clearance rcl  where rcl.item = im.item and rcl.location = il.loc)
                         and not exists (select 1 from ma_asos.ma_stage_price_change mpc where mpc.item = im.item  and mpc.location = il.loc)
                         and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.item = im.item  and mpc.location = il.loc) 
                         and im.item_level < im.tran_level ) where rownum<=5
                          order by item, 
                                location;

BEGIN    

for j in 0..1 loop
    select vdate+1 into l_effective_date from rms.period;

for k in cur_dept_a loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
           l_location  := k.store;
           
           
		for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
                l_item                      := cust_ma.item;  
                l_Location                  := cust_ma.location;
				l_CHANGE_AMOUNT           	:= cust_ma.CHANGE_AMOUNT;
                l_change_selling_uom        := cust_ma.change_selling_uom;
                
        select rms.RPM_STAGE_PRICE_CHANGE_SEQ.nextval into l_stage_price_change_id from dual;
        
            insert into rms.rpm_stage_price_change  (stage_price_change_id , 
                                                        reason_code           ,
                                                        item                  ,
                                                        location              ,
                                                        zone_node_type        ,
                                                        effective_date        ,
                                                        change_type           ,
                                                        change_amount         ,
                                                        change_selling_uom    ,
                                                        change_percent        ,
                                                        null_multi_ind        ,
                                                        ignore_constraints    ,
                                                        auto_approve_ind      ,
                                                        status                ,
                                                        vendor_funded_ind     )
                                                values (l_stage_price_change_id,
                                                        12,
                                                        l_item,
                                                        l_location,
                                                        '0',
                                                        l_effective_date,
                                                        1,
                                                        '2',
                                                        null,
                                                        null,
                                                        0,
                                                        1,
                                                        1,
                                                        'N',
                                                        0);         
       
 
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                           IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                            COMMIT;
                           END IF;	
              END LOOP; 
              END LOOP; 

for k in cur_dept_p loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
        l_location  := k.store;
           
           
		for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
                l_item                      := cust_ma.item;  
                l_Location                  := cust_ma.location;
				l_CHANGE_AMOUNT           	:= cust_ma.CHANGE_AMOUNT;
                l_change_selling_uom        := cust_ma.change_selling_uom;
                
        select rms.RPM_STAGE_PRICE_CHANGE_SEQ.nextval into l_stage_price_change_id from dual;
        
            insert into rms.rpm_stage_price_change  (stage_price_change_id , 
                                                        reason_code           ,
                                                        item                  ,
                                                        location              ,
                                                        zone_node_type        ,
                                                        effective_date        ,
                                                        change_type           ,
                                                        change_amount         ,
                                                        change_selling_uom    ,
                                                        change_percent        ,
                                                        null_multi_ind        ,
                                                        ignore_constraints    ,
                                                        auto_approve_ind      ,
                                                        status                ,
                                                        vendor_funded_ind     )
                                                values (l_stage_price_change_id,
                                                        12,
                                                        l_item,
                                                        l_location,
                                                        '0',
                                                        l_effective_date,
                                                        0,
                                                        null,
                                                        null,
                                                        '30',
                                                        0,
                                                        1,
                                                        1,
                                                        'N',
                                                        0);         
       
 
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                           IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                            COMMIT;
                           END IF;	
          END LOOP; 
          END LOOP; 

for k in cur_dept_f loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
        l_location  := k.store;

		for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass,l_zone_id,l_location) loop 
            EXIT WHEN c_get_cuitem_pc%NOTFOUND;
                l_item                      := cust_ma.item;  
                l_Location                  := cust_ma.location;
				l_CHANGE_AMOUNT           	:= cust_ma.CHANGE_AMOUNT+2;
                l_change_selling_uom        := cust_ma.change_selling_uom;
                
        select rms.RPM_STAGE_PRICE_CHANGE_SEQ.nextval into l_stage_price_change_id from dual;
        
            insert into rms.rpm_stage_price_change  (stage_price_change_id , 
                                                        reason_code           ,
                                                        item                  ,
                                                        location              ,
                                                        zone_node_type        ,
                                                        effective_date        ,
                                                        change_type           ,
                                                        change_amount         ,
                                                        change_selling_uom    ,
                                                        change_percent        ,
                                                        null_multi_ind        ,
                                                        ignore_constraints    ,
                                                        auto_approve_ind      ,
                                                        status                ,
                                                        vendor_funded_ind      )
                                                values (l_stage_price_change_id,
                                                        12,
                                                        l_item,
                                                        l_location,
                                                        '0',
                                                        l_effective_date,
                                                        2,
                                                        l_CHANGE_AMOUNT,
                                                        l_change_selling_uom,
                                                        null,
                                                        0,
                                                        1,
                                                        1,
                                                        'N',
                                                        0);         
       
 
                COUNTER_COMMIT :=COUNTER_COMMIT + 1;
                           IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
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




