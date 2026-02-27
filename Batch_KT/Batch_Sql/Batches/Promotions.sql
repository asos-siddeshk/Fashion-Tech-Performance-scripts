drop table ma_stage_simple_promo_bk;
create table ma_stage_simple_promo_bk as
select * from ma_asos.ma_stage_simple_promo;
delete from ma_asos.ma_stage_simple_promo;
INSERT INTO ma_asos.ma_stage_simple_promo SELECT * FROM ma_stage_simple_promo_bk;


select PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status='N' group by PROMO_START_DATE order by 1;
select state,count(1) from rms.rpm_promo_dtl where START_DATE between '10-JAN-19' and '25-JAN-19' group by state;
select START_DATE,count(1) from rms.rpm_promo_dtl where START_DATE between '10-JAN-19' and '31-JAN-19' and state ='3' group by START_DATE order by 1;
select START_DATE,count(1) from rms.rpm_promo_dtl where START_DATE between '10-JAN-19' and '31-JAN-19' and state!='3' group by START_DATE order by 1;
select state,count(1) from rms.rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo where status ='A') group by state;
select state,count(1) from rms.rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo) group by state;



delete from ma_asos.ma_stage_simple_promo where status ='N';
select * from ma_asos.ma_stage_simple_promo where status ='N'; --
--Update rms.rpm_stage_simple_promo set PROMO_EVENT_ID ='80',status ='N',STAGE_ID=rownum where status ='E'; --
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' group by PROMO_START_DATE order by 1; --
select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status!='N' group by PROMO_START_DATE order by 1; --
select * from ma_asos.ma_stage_simple_promo where MESSAGE_TYPE='A';  --
select * from ma_asos.ma_stage_simple_promo where MESSAGE_TYPE!='A';  --
select  * from rms.rpm_stage_simple_promo;
select *  from rms.rpm_stage_simple_promo where status ='E';
select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;

select count(1) from rpm_stage_simple_promo where status ='N';
select count(1) from rpm_stage_simple_promo where status ='E';
select count(1) from rpm_stage_simple_promo where status ='W' and ERROR_MESSAGE is null;
select count(1) from rpm_stage_simple_promo where status ='A';
select * from rpm_stage_simple_promo where status ='W' and ERROR_MESSAGE is not null;
delete from rms.rpm_stage_simple_promo where status !='N';
delete from rms.rpm_stage_simple_promo;

   Update rms.rpm_stage_simple_promo set stage_id= rownum where status ='N'; 
  COMMIT; 


delete from ma_asos.ma_stage_simple_promo;
select PROMO_START_DATE,count(1) from rms.rpm_stage_simple_promo group by PROMO_START_DATE order by 1; --16076 --16684

select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;
select state,count(1) from rms.rpm_promo_dtl where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.rpm_stage_simple_promo where status ='A')
    group by state;

select * from rms.period;
--delete from ma_asos.ma_stage_simple_promo where PROMO_START_DATE ='08-NOV-18'; --

select distinct PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status ='N' group by PROMO_START_DATE order by 1; --

 ----- Copy ---- Global --------

set serveroutput on;
set timing on;
declare

  COUNTER         NUMBER(8)     := 0;
  COUNTER_COMMIT  NUMBER(8)     := 1;
  stage_COMMIT  NUMBER(8)       := 0;

 l_stage_simple_promo_id          	ma_asos.ma_stage_simple_promo.stage_simple_promo_id%type;
 l_stage_process_id           		ma_asos.ma_stage_simple_promo.stage_process_id%type;
 l_message_seq_id         			ma_asos.ma_stage_simple_promo.message_seq%type;
 l_comp_display_id           		ma_asos.ma_stage_simple_promo.comp_display_id%type;
 l_item          					ma_asos.ma_stage_simple_promo.item%type;
 l_location           				ma_asos.ma_stage_simple_promo.location%type;
 l_new_location           			ma_asos.ma_stage_simple_promo.location%type;
 l_apply_to_code           			ma_asos.ma_stage_simple_promo.apply_to_code%type;
 l_promo_start_date           		ma_asos.ma_stage_simple_promo.promo_start_date%type;
 l_promo_end_date           		ma_asos.ma_stage_simple_promo.promo_end_date%type;
 l_change_type           			ma_asos.ma_stage_simple_promo.change_type%type;
 l_change_percent           		ma_asos.ma_stage_simple_promo.change_percent%type;
 l_process_id           			ma_asos.ma_stage_simple_promo.process_id%type;
 l_stage_id          				ma_asos.ma_stage_simple_promo.stage_id%type;
 l_stage_promo_comp_id          	ma_asos.ma_stage_simple_promo.stage_promo_comp_id%type;
 L_PROMO_NAME      					ma_asos.ma_stage_simple_promo.name%type;
 l_promo_event_id           		ma_asos.ma_stage_simple_promo.promo_event_id%type;
 l_dtl_start_date           		ma_asos.ma_stage_simple_promo.dtl_start_date%type;
 l_dtl_end_date           			ma_asos.ma_stage_simple_promo.dtl_end_date%type;
 l_promo_display_id           		ma_asos.ma_stage_simple_promo.promo_display_id%type;
 l_currency_code		           	ma_asos.ma_stage_simple_promo.currency_code%type;

		cursor cur_promo is --2613
		select   rpc.comp_display_id,rpdmn.item, rpzl.location,rpd.apply_to_code,rp.start_date as promo_start_date, rp.end_date as promo_end_date,
           rpddl.change_type,rpddl.change_percent, rp.name as promo_name,rp.promo_event_id,rpd.start_date as dtl_start_date, 
           rpd.end_date as dtl_end_date,rp.promo_display_id
              from rms.rpm_promo rp, rms.rpm_promo_comp rpc, rms.rpm_promo_dtl rpd, rms.rpm_promo_dtl_merch_node rpdmn, rms.rpm_promo_zone_location rpzl, 
					rms.rpm_promo_dtl_list rpdl, rms.rpm_promo_dtl_list_grp rpdlg, rms.rpm_promo_dtl_disc_ladder rpddl
			 where rp.promo_id = rpc.promo_id
			   and rpc.promo_comp_id =rpd.promo_comp_id
			   and rpd.state ='3'
               and rpddl.change_type           = 0 -- % off
               and rpc.type                    = 1 -- simple promotion
			   and rpd.promo_dtl_id = rpdmn.promo_dtl_id
                 and rpd.promo_dtl_id = rpzl.promo_dtl_id
                and rpdlg.promo_dtl_id = rpd.promo_dtl_id     
                and trunc(rp.start_date) ='10-MAY-21'
                and rpzl.location ='20001'
                and rpdl.promo_dtl_list_grp_id = rpdlg.promo_dtl_list_grp_id
                and rpddl.promo_dtl_list_id = rpdl.promo_dtl_list_id and rownum<='900' 
                and not exists (select 1 from ma_asos.ma_stage_simple_promo mpc where mpc.item = rpdmn.item)
                and not exists (select 1 from rms.rpm_promo_item_loc_expl rpc where rpc.item = rpdmn.item and rpc.LOCATION! = '20001')
                  order by promo_start_date,item,location;

        cursor c_get_currency_code (l_location rms.rpm_stage_simple_promo.location%type)is
		    select distinct s.currency_code from rms.store s where s.store != l_location;

         cursor c_get_store (l_location rms.rpm_stage_simple_promo.location%type, l_currency_code rms.rpm_stage_simple_promo.currency_code%type)is
                select m.STORE,s.currency_code from ma_asos.ma_pricing_defaults m,  rms.store s 
                    where s.store =m.store and
                          s.store != l_location and s.currency_code = l_currency_code;

begin

for k in cur_promo loop

    l_comp_display_id 	    :=k.comp_display_id ;
    l_item 	                :=k.item ;
    l_location 	            :=k.location ;
    l_apply_to_code 	    :=k.apply_to_code ;
    l_promo_start_date 	    :=k.promo_start_date ;
    l_promo_end_date 	    :=k.promo_end_date ;
    l_change_type 	        :=k.change_type ;
    l_change_percent 	    :=k.change_percent ;
    l_promo_name 	        :=k.promo_name ;
    l_promo_event_id 	    :=k.promo_event_id ;
    l_dtl_start_date 	    :=k.dtl_start_date ;
    l_dtl_end_date 	        :=k.dtl_end_date ;
    l_promo_display_id	    :=k.promo_display_id;

        	for m in c_get_currency_code(l_location) loop 
                l_currency_code := m.currency_code;

             select ma_asos.ma_stage_rpm_promo_id_seq.nextval into l_stage_id from dual;
             select ma_asos.ma_promo_comp_seq.nextval into l_stage_promo_comp_id from dual;
             select rms.rpm_promo_display_id_seq.nextval into l_promo_display_id from dual;

                for i in c_get_store(l_location,l_currency_code) loop 
                        l_new_location := i.store;
                        l_currency_code := i.currency_code;

                select ma_asos.ma_stage_rpm_promo_id_seq.nextval into l_stage_simple_promo_id from dual;
                select ma_asos.ma_process_id_seq.nextval into l_stage_process_id from dual;
                select ma_asos.ma_rpm_message_seq.nextval into l_message_seq_id from dual;
                select ma_asos.ma_injector_process_id_seq.nextval into l_process_id from dual;

                    insert into ma_asos.ma_stage_simple_promo(	
                                    stage_simple_promo_id        , 
                                    stage_process_id,
                                    message_seq                  , 
                                    message_type                 , 
                                    comp_display_id ,
                                    merch_type                   , 
                                    item                         , 
                                    zone_node_type               , 
                                    location                     , 
                                    apply_to_code                , 
                                    promo_start_date             , 
                                    promo_end_date               , 
                                    ignore_constraints           , 
                                    change_type                  , 
                                    change_percent                , 
                                    auto_approve_ind             , 
                                    process_id ,
                                    status                       , 
                                    timebased_dtl_ind            , 
                                    stage_id                     , 
                                    stage_promo_comp_id          , 
                                    name                         , 
                                    description                  , 
                                    promo_comp_name              , 
                                    promo_event_id               , 
                                    dtl_start_date               , 
                                    dtl_end_date                 , 
                                    promo_secondary_ind          , 
                                    comp_secondary_ind ,
                                    vendor_funded_ind            , 
                                    promo_display_id ,
                                    currency_code                , 
                                    create_datetime              , 
                                    last_update_datetime         , 
                                    create_id                    , 
                                    last_update_id )
                values (l_stage_simple_promo_id
                        , l_stage_process_id
                        , l_message_seq_id
                        , 'A'
                        , l_comp_display_id
                        , 0
                        , l_item
                        , 0
                        , l_new_location
                        , l_apply_to_code
                        , l_promo_start_date
                        , to_date(l_promo_end_date) + 1 - 1/(24*60)
                        , 1
                        , l_change_type
                        , l_change_percent
                        , 1
                        , l_process_id
                        , 'N'
                        , 1
                        , l_stage_id
                        , l_stage_promo_comp_id
                        , l_promo_name
                        , l_promo_name
                        , l_promo_name
                        , l_promo_event_id
                        , l_dtl_start_date
                        , to_date(l_dtl_end_date) + 1 - 1/(24*60)
                        , 0
                        , 0
                        , 0
                        , l_promo_display_id
                        , l_currency_code
                        , sysdate
                        , sysdate
                        , 'PTUSER'
                        , 'PTUSER' );

			   COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;

		end loop;

 end loop;
	 end loop;

exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/

     select  * from rms.period; 

---------------------------------------------------------------- Retention period promotions ----------------------------------------------------------------
set serveroutput on;
set timing on;

declare

  COUNTER         NUMBER(8)     := 0;
  COUNTER_COMMIT  NUMBER(8)     := 1;
  stage_COMMIT  NUMBER(8)     := 0;
  
   l_item_id               	rms.rpm_stage_simple_promo.item%type;
   l_stage_simple_promo_id 	rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
   l_name					rms.rpm_stage_simple_promo.name%type;
   l_promo_start_date 		rms.rpm_stage_simple_promo.promo_start_date%type;
   l_promo_end_date 		rms.rpm_stage_simple_promo.promo_end_date%type;
   l_dtl_start_date 		rms.rpm_stage_simple_promo.dtl_start_date%type;
   l_date 		            rms.rpm_stage_simple_promo.dtl_start_date%type;
   l_dtl_end_date 			rms.rpm_stage_simple_promo.dtl_end_date%type;
   L_PROMO_EVENT_ID         rms.rpm_stage_simple_promo.PROMO_EVENT_ID%type;
   l_zone_id              	rms.rpm_stage_simple_promo.zone_id%type;
   ma_zone_id              	rms.rpm_stage_simple_promo.zone_id%type;
   ma_location             	rms.rpm_stage_simple_promo.location%type;
   l_location              	rms.rpm_stage_simple_promo.location%type;
   l_change_type 			rms.rpm_stage_simple_promo.change_type%type;
   l_change_percent        	rms.rpm_stage_simple_promo.change_percent%type;
   l_change_amount        	rms.rpm_stage_simple_promo.change_amount%type;
   l_currency_code  		rms.rpm_stage_simple_promo.currency_code%type;
   l_stage_id				rms.rpm_stage_simple_promo.stage_id%type :='1';
   l_stage_promo_comp_id	rms.rpm_stage_simple_promo.stage_promo_comp_id%type :='1';
   l_time_dtl				rms.rpm_stage_simple_promo.timebased_dtl_ind%type;
   l_sp_stage_id 			rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
   l_selling_unit_retail   rms.rpm_stage_price_change.change_percent%type;
   l_selling_uom           rms.item_loc.SELLING_UOM%type;
   l_dept                	rms.subclass.dept%type; 
   l_class                	rms.subclass.class%type; 
   l_subclass               rms.subclass.subclass%type; 
   
    cursor cur_dept is
		select dept,class,subclass,zone_id,store  from (
		   select im.dept,im.class,im.subclass,ma.ZONE_ID,ma.store from skumar.item_master_op im ,ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') --and ma.store = '20001' --
            --and rownum <= '1500'
			group by im.dept,im.class,im.subclass,ma.ZONE_ID,ma.store) order by 1,2,3,4;
   
	cursor c_get_item_sp (l_dept rms.subclass.dept%type, l_class rms.subclass.class%type, l_subclass rms.subclass.subclass%type, 
                    l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
   select item,zone_id,location,P_name,currency_code,current_retail,SELLING_UOM from (
   select distinct im.item,ma.zone_id,ma.store as location,'Promotion: ' as P_name,s.currency_code,il.selling_unit_retail as current_retail,il.SELLING_UOM    
                 from skumar.item_master_op     im,
                             ma_asos.ma_pricing_defaults ma ,
                             rms.item_loc il ,
                             rms.store s
                        where im.dept =  l_dept
                         and im.class = l_class
                         and im.subclass = l_subclass
                         and im.item_level = '1'
                         and im.status ='A'
                         and il.item = im.item
                         and il.loc = l_location
                         and s.store = il.loc
                         and ma.store = il.loc
                         and not exists (select 1 from rms.rpm_stage_simple_promo rsp where rsp.item = im.item ) 
                         and not exists (select 1 from rms.rpm_promo_item_loc_expl rpl where rpl.item = im.item and rpl.DETAIL_START_DATE >= '08-MAY-2021'
                                                          and  rpl.DETAIL_END_DATE <= '20-FEB-2022')) where rownum <= '2';

begin

--for j in 0..5 loop
For m in 0..2 loop

     select  vdate+1+m into l_promo_start_date from rms.period; 
     select  vdate+30+m into l_promo_end_date from rms.period; 
     select  vdate+1+m into l_dtl_start_date from rms.period; 
     select  vdate+30+m into l_dtl_end_date from rms.period; 
         
     select  vdate+1 into l_date from rms.period; 

    select PROMO_EVENT_ID into  l_promo_event_id  from rms.rpm_promo_event
                  where START_DATE <= l_promo_start_date
                    and END_DATE   >= l_promo_end_date and rownum <= '1';
                        
                                        
for k in cur_dept loop
  l_dept := k.dept;
    l_class := k.class;
      l_subclass := k.subclass;
         ma_zone_id := k.zone_id;         
         ma_location := k.store;
         
		for i in c_get_item_sp (l_dept,l_class,l_subclass,ma_zone_id,ma_location) loop 
        EXIT WHEN c_get_item_sp%NOTFOUND;
			l_item_id				:= i.item;
			l_zone_id				:= i.ZONE_ID;
            l_location				:= i.location;
			l_name					:= i.p_name;
			l_currency_code  		:= i.currency_code;
			l_selling_unit_retail  	:= i.CURRENT_RETAIL -(0.75);
			l_selling_uom			:=i.selling_uom;
			
		select rms.RPM_STAGE_PROMO_SIMPLE_SEQ.nextval into l_sp_stage_id from dual;
			
				insert into rms.rpm_stage_simple_promo( stage_simple_promo_id
														,stage_id 
														,stage_promo_comp_id
														,name
														,merch_type
														,zone_node_type
														,location
														,apply_to_code
														,promo_start_date
														,promo_end_date
														,item 
														,ignore_constraints
														,change_type
														,change_amount
														,change_percent
														,auto_approve_ind
														,status
														,timebased_dtl_ind
														,dtl_start_date
														,dtl_end_date
														,vendor_funded_ind
														,currency_code
														,promo_event_id
														,CHANGE_SELLING_UOM)
				values ( l_sp_stage_id
						,l_stage_id 
						,l_stage_promo_comp_id 
						,l_name||l_sp_stage_id
						,0 
						,0 
						,l_location 
						,2 
						,l_promo_start_date 
						,to_date(l_promo_end_date) + 1 - 1/(24*60)  
						,l_item_id 
						,1 
						,0 
						,null
						,'-70' 
						,1 
						,'N' 
						,0 
						,l_dtl_start_date 
						,to_date(l_dtl_end_date) + 1 - 1/(24*60) 
						,0 
						,l_currency_code
						,l_promo_event_id
						,l_selling_uom);

               COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT,10) = 0 THEN
                COMMIT;
               END IF;
	   
	          stage_COMMIT := stage_COMMIT+1;
              
	   IF MOD(stage_COMMIT,1) = 0 THEN
		l_stage_id := l_stage_id+1;

        
       END IF;
       
		end loop;
         
 end loop;
    commit;
	 end loop;
	-- end loop;
	
   Update rms.rpm_stage_simple_promo set stage_id= rownum where status ='N'; 
  COMMIT; 
  
exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/


/*

---- New Promotions  --------
set serveroutput on;
set timing on;

declare

  COUNTER         NUMBER(8)     := 0;
  COUNTER_COMMIT  NUMBER(8)     := 1;
  stage_COMMIT  NUMBER(8)       := 0;
  
   l_item_id               	rms.rpm_stage_simple_promo.item%type;
   l_stage_simple_promo_id 	rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
   l_message_seq_id			ma_asos.ma_stage_simple_promo.message_seq%type;
   l_name					rms.rpm_stage_simple_promo.name%type;
   l_promo_start_date 		rms.rpm_stage_simple_promo.promo_start_date%type;
   l_promo_end_date 		rms.rpm_stage_simple_promo.promo_end_date%type;
   l_dtl_start_date 		rms.rpm_stage_simple_promo.dtl_start_date%type;
   l_dtl_end_date 			rms.rpm_stage_simple_promo.dtl_end_date%type;
   l_zone_id              	rms.rpm_stage_simple_promo.zone_id%type;
   l_zone              	rms.rpm_stage_simple_promo.zone_id%type;
   l_location              	rms.rpm_stage_simple_promo.location%type;
   l_change_type 			rms.rpm_stage_simple_promo.change_type%type;
   l_currency_code  		rms.rpm_stage_simple_promo.currency_code%type;
   l_stage_id				rms.rpm_stage_simple_promo.stage_id%type :='1';
   l_stage_promo_comp_id	rms.rpm_stage_simple_promo.stage_promo_comp_id%type :='1';
   l_time_dtl				rms.rpm_stage_simple_promo.timebased_dtl_ind%type;
   l_sp_stage_id 			rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
   l_selling_unit_retail   rms.rpm_stage_simple_promo.change_amount%type;
   l_selling_uom           rms.item_loc.SELLING_UOM%type;
   l_dept                	    rms.subclass.dept%type; 
   l_class                	    rms.subclass.class%type; 
   l_subclass                	    rms.subclass.subclass%type; 
    l_date_1 date;
    l_date_2 date;
    

		cursor cur_dept_a is --2613
		select dept,class,subclass,zone_id  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 1001 and 1051 
			group by im.dept,im.class,im.subclass, ma.ZONE_ID) order by 1,2,3,4;
   
		cursor cur_dept_p is --7007
		select dept,class,subclass,zone_id  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 1052 and 2010 
			group by im.dept,im.class,im.subclass, ma.ZONE_ID) order by 1,2,3,4;
   
		cursor cur_dept_f is -- 6643
		select dept,class,subclass,zone_id  from (
		   select distinct im.dept,im.class,im.subclass, ma.ZONE_ID from rms.subclass im, ma_asos.ma_pricing_defaults ma where 
			(dept!='9999' and class!='9999' and subclass!='9999') and dept between 2011 and 2156 
			group by im.dept,im.class,im.subclass, ma.ZONE_ID) order by 1,2,3,4;


   cursor c_get_item_sp (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type,l_zone_id rms.rpm_stage_simple_promo.zone_id%type)is
	select          im.item,
						ma.zone_id, 
                        'Promotion: ' as p_name,
						ma.store as location,
                        l_date_1 as promo_start_date, 
                        l_date_2 as promo_end_date,--to_char(promo_end_date, 'dd-mon-yyyy hh:mi:ss')
                        l_date_1 as dtl_start_date, 
                        l_date_2 as dtl_end_date, --to_char(dtl_end_date, 'dd-mon-yyyy hh:mi:ss'),
						rz.currency_code,
                        il.selling_unit_retail as selling_unit_retail,
                        il.selling_uom
        from         rms.item_loc        il,
					 rms.item_master     im,
					 ma_asos.ma_pricing_defaults ma,
					 rms.rpm_zone_location rzl,
                     rms.rpm_zone rz,
					 rms.store s
				where il.item             = im.item
				 and im.dept =  l_dept
                 and im.class = l_class
                 and im.subclass = l_subclass
				 and il.promo_retail is null 
                 and il.selling_unit_retail  >='3'
                 and il.clear_ind ='N'
				 and il.loc = ma.store
				 and rzl.location = ma.store
				 and ma.store=s.store
				 and rzl.zone_id =ma.zone_id
                 and rzl.zone_id =rz.zone_id
                 and ma.zone_id = l_zone_id 
                 and not exists (select 1 from rms.rpm_stage_simple_promo rpc  where rpc.item = im.item and rpc.location = ma.store)
                 and not exists (select 1 from rms.rpm_stage_price_change rspc  where rspc.item = im.item and rspc.location = ma.store)
                 and not exists (select 1 from rms.rpm_stage_clearance rcl  where rcl.item = im.item and rcl.location = ma.store)
                 and not exists (select 1 from ma_asos.ma_stage_simple_promo mpc where mpc.item = im.item  and mpc.location = ma.store)
				 and im.item_level = im.tran_level and rownum<=2
                  order by item,
						zone_id, 
						location;
                        
begin

for m in 0..5 loop
for j in 0..1 loop

        select vdate+1+m into l_date_1 from rms.period;
        select vdate+4+m into l_date_2 from rms.period;

  COUNTER_COMMIT :=0;    
 
for k in cur_dept_a loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
        
		for i in c_get_item_sp(l_dept,l_class,l_subclass,l_zone_id) loop 
        EXIT WHEN c_get_item_sp%NOTFOUND;
			l_item_id				:= i.item;
			l_zone_id				:= i.zone_id;
			l_location				:= i.location;
			l_name					:= i.p_name;
			l_promo_start_date 		:= i.promo_start_date ;   
			l_promo_end_date  		:= i.promo_end_date ;
			l_dtl_start_date  		:= i.dtl_start_date ;
			l_dtl_end_date 			:= i.dtl_end_date ;
			l_currency_code  		:= i.currency_code;
			l_selling_unit_retail  	:= i.selling_unit_retail - 1.5;
			l_selling_uom			:=i.selling_uom;
			
		select ma_asos.MA_STAGE_RPM_PROMO_ID_SEQ.nextval into l_sp_stage_id from dual;
		select ma_asos.MA_PROCESS_ID_SEQ.nextval into l_message_seq_ID from dual;
			
		insert into ma_asos.ma_stage_simple_promo(stage_simple_promo_id        , 
                    message_seq                  , 
                    message_type                 , 
                    merch_type                   , 
                    item                         , 
                    zone_node_type               , 
                    location                     , 
                    apply_to_code                , 
                    promo_start_date             , 
                    promo_end_date               , 
                    ignore_constraints           , 
                    change_type                  , 
                   change_percent,-- change_amount                , 
                    change_selling_uom           , 
                    auto_approve_ind             , 
                    status                       , 
                    timebased_dtl_ind            , 
                    stage_id                     , 
                    stage_promo_comp_id          , 
                    name                         , 
                    description                  , 
                    promo_comp_name              , 
                    promo_event_id               , 
                    dtl_start_date               , 
                    dtl_end_date                 , 
                    promo_secondary_ind          , 
                    vendor_funded_ind            , 
                    currency_code                , 
                    create_datetime              , 
                    last_update_datetime         , 
                    create_id                    , 
                    last_update_id)
values (l_sp_stage_id
            , l_message_seq_ID
            , 'A'
            , 0
            , l_item_id
            , 0
            , l_location
            , 2
            , l_promo_start_date
            , to_date(l_promo_end_date) + 1 - 1/(24*60)
            , 1
            , 0
            , '-30'
            , null--l_selling_uom
            , 1
            , 'N'
            , 1
            , l_stage_id
            , l_stage_promo_comp_id
            , l_name||l_sp_stage_id
            , l_name||l_sp_stage_id
            , l_name||l_sp_stage_id
            , 2
            , l_dtl_start_date
            , to_date(l_dtl_end_date) + 1 - 1/(24*60)
            , 0
            , 0
            , l_currency_code
            , sysdate
            , sysdate
            , 'PTUSER'
            , 'PTUSER' );

			   COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;

  stage_COMMIT := stage_COMMIT+1;
	   IF MOD(stage_COMMIT, 1) = 0 THEN
		l_stage_id := l_stage_id+1;
  -- l_stage_promo_comp_id := l_stage_promo_comp_id+1;
       END IF;
       
		end loop;
       
 end loop;

for k in cur_dept_p loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;
        
		for i in c_get_item_sp(l_dept,l_class,l_subclass,l_zone_id) loop 
        EXIT WHEN c_get_item_sp%NOTFOUND;
			l_item_id				:= i.item;
			l_zone_id				:= i.zone_id;
			l_location				:= i.location;
			l_name					:= i.p_name;
			l_promo_start_date 		:= i.promo_start_date ;   
			l_promo_end_date  		:= i.promo_end_date ;
			l_dtl_start_date  		:= i.dtl_start_date ;
			l_dtl_end_date 			:= i.dtl_end_date ;
			l_currency_code  		:= i.currency_code;
			l_selling_unit_retail  	:= i.selling_unit_retail;
			l_selling_uom			:=i.selling_uom;
			
		select ma_asos.MA_STAGE_RPM_PROMO_ID_SEQ.nextval into l_sp_stage_id from dual;
		select ma_asos.MA_PROCESS_ID_SEQ.nextval into l_message_seq_ID from dual;
			
		insert into ma_asos.ma_stage_simple_promo(stage_simple_promo_id        , 
                    message_seq                  , 
                    message_type                 , 
                    merch_type                   , 
                    item                         , 
                    zone_node_type               , 
                    location                     , 
                    apply_to_code                , 
                    promo_start_date             , 
                    promo_end_date               , 
                    ignore_constraints           , 
                    change_type                  , 
                    change_percent               , 
                    change_selling_uom           , 
                    auto_approve_ind             , 
                    status                       , 
                    timebased_dtl_ind            , 
                    stage_id                     , 
                    stage_promo_comp_id          , 
                    name                         , 
                    description                  , 
                    promo_comp_name              , 
                    promo_event_id               , 
                    dtl_start_date               , 
                    dtl_end_date                 , 
                    promo_secondary_ind          , 
                    vendor_funded_ind            , 
                    currency_code                , 
                    create_datetime              , 
                    last_update_datetime         , 
                    create_id                    , 
                    last_update_id)
values (l_sp_stage_id
            , l_message_seq_ID
            , 'A'
            , 0
            , l_item_id
            , 0
            , l_location
            , 2
            , l_promo_start_date
            , to_date(l_promo_end_date) + 1 - 1/(24*60)
            , 1
            , 0
            , '-40'
            , null
            , 1
            , 'N'
            , 1
            , l_stage_id
            , l_stage_promo_comp_id
            , l_name||l_sp_stage_id
            , l_name||l_sp_stage_id
            , l_name||l_sp_stage_id
            , 2
            , l_dtl_start_date
            , to_date(l_dtl_end_date) + 1 - 1/(24*60)
            , 0
            , 0
            , l_currency_code
            , sysdate
            , sysdate
            , 'PTUSER'
            , 'PTUSER' );

			   COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;

  stage_COMMIT := stage_COMMIT+1;
	   IF MOD(stage_COMMIT, 1) = 0 THEN
		l_stage_id := l_stage_id+1;
  -- l_stage_promo_comp_id := l_stage_promo_comp_id+1;
       END IF;
       
		end loop;
       
 end loop;

for k in cur_dept_f loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
        l_zone_id  := k.zone_id;

		for i in c_get_item_sp(l_dept,l_class,l_subclass,l_zone_id) loop 
        EXIT WHEN c_get_item_sp%NOTFOUND;
			l_item_id				:= i.item;
			l_zone_id				:= i.zone_id;
			l_location				:= i.location;
			l_name					:= i.p_name;
			l_promo_start_date 		:= i.promo_start_date ;   
			l_promo_end_date  		:= i.promo_end_date ;
			l_dtl_start_date  		:= i.dtl_start_date ;
			l_dtl_end_date 			:= i.dtl_end_date ;
			l_currency_code  		:= i.currency_code;
			l_selling_unit_retail  	:= i.selling_unit_retail - 1.5;
			l_selling_uom			:=i.selling_uom;
			
		select ma_asos.MA_STAGE_RPM_PROMO_ID_SEQ.nextval into l_sp_stage_id from dual;
		select ma_asos.MA_PROCESS_ID_SEQ.nextval into l_message_seq_ID from dual;
			
		insert into ma_asos.ma_stage_simple_promo(stage_simple_promo_id        , 
                    message_seq                  , 
                    message_type                 , 
                    merch_type                   , 
                    item                         , 
                    zone_node_type               , 
                    location                     , 
                    apply_to_code                , 
                    promo_start_date             , 
                    promo_end_date               , 
                    ignore_constraints           , 
                    change_type                  , 
                   change_percent, --change_amount                , 
                    change_selling_uom           , 
                    auto_approve_ind             , 
                    status                       , 
                    timebased_dtl_ind            , 
                    stage_id                     , 
                    stage_promo_comp_id          , 
                    name                         , 
                    description                  , 
                    promo_comp_name              , 
                    promo_event_id               , 
                    dtl_start_date               , 
                    dtl_end_date                 , 
                    promo_secondary_ind          , 
                    vendor_funded_ind            , 
                    currency_code                , 
                    create_datetime              , 
                    last_update_datetime         , 
                    create_id                    , 
                    last_update_id)
values (l_sp_stage_id
            , l_message_seq_ID
            , 'A'
            , 0
            , l_item_id
            , 0
            , l_location
            , 2
            , l_promo_start_date
            , to_date(l_promo_end_date) + 1 - 1/(24*60)
            , 1
            , 0
            , '-50'-- , l_selling_unit_retail
            , null -- , l_selling_uom
            , 1
            , 'N'
            , 1
            , l_stage_id
            , l_stage_promo_comp_id
            , l_name||l_sp_stage_id
            , l_name||l_sp_stage_id
            , l_name||l_sp_stage_id
            , 2
            , l_dtl_start_date
            , to_date(l_dtl_end_date) + 1 - 1/(24*60)
            , 0
            , 0
            , l_currency_code
            , sysdate
            , sysdate
            , 'PTUSER'
            , 'PTUSER' );

			   COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 50) = 0 THEN
				COMMIT;
			   END IF;

  stage_COMMIT := stage_COMMIT+1;
	   IF MOD(stage_COMMIT, 1) = 0 THEN
		l_stage_id := l_stage_id+1;
  -- l_stage_promo_comp_id := l_stage_promo_comp_id+1;
       END IF;
       
		end loop;
       
 end loop;
 end loop;
  end loop;
  
  Update ma_asos.ma_stage_simple_promo set STAGE_ID =rownum where status ='N';
commit;
	
exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/

  Update rpm_stage_simple_promo set STAGE_ID =rownum where status ='N';

select  STATUS,count(1) from rms.rpm_stage_simple_promo group by STATUS;
select count(1) from rpm_stage_simple_promo where status ='N';
select count(1) from rpm_stage_simple_promo where status ='E';
select count(1) from rpm_stage_simple_promo where status ='W' and ERROR_MESSAGE is null;
select count(1) from rpm_stage_simple_promo where status ='A';
select * from rpm_stage_simple_promo where status ='W' and ERROR_MESSAGE is not null;
delete from rms.rpm_stage_simple_promo where status !='N';
delete from rms.rpm_stage_simple_promo;
