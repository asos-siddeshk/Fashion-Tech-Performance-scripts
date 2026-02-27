select * from repl_results;
select * from svc_repl_roq;

select count(distinct(item_parent)) 
    from item_master where 
    item in (select item from repl_results where (ITEM, MASTER_ITEM) not in (select item,master_item from repl_results_not) and PRIMARY_REPL_SUPPLIER ='1100000086' );

select * from repl_results where (ITEM, MASTER_ITEM) not in (select item,master_item from repl_results_not);
--
create table repl_results_not as select distinct ITEM, MASTER_ITEM from repl_results;
drop table repl_results_not;

-- PO Replenishment
SELECT count(distinct rep.parent)--,rep.item,rep.need_date,count(1)-- ,supp.supplier
FROM
    ma_asos.ma_v_replenishment rep
inner join rms.item_supp_country supp on supp.item=rep.parent
inner join rms.item_master im on im.item_parent=rep.parent
where supp.supplier='1100000086' and rep.item_desc like
'%UploadTest%';

select SCHEDULED_ACTIVE_DATE,count(SCHEDULED_ACTIVE_DATE) from rms.REPL_ATTR_UPDATE_HEAD 
    group by SCHEDULED_ACTIVE_DATE 
    order by SCHEDULED_ACTIVE_DATE; --26576
    
    select count(1) from v_rau_item_stage ;
   select * from repl_item_loc_updates where CREATE_ID!= 'MA_ASOS';

    select count(1) from RMS.REPL_ITEM_LOC where LAST_REVIEW_DATE = '08-MAY-21' ;
    select count(1) from RMS.REPL_ITEM_LOC where NEXT_REVIEW_DATE = '09-MAY-21' ;
    
    select * from RMS.REPL_ITEM_LOC ;

update rms.REPL_ATTR_UPDATE_HEAD set SCHEDULED_ACTIVE_DATE ='09-MAY-21'  where SCHEDULED_ACTIVE_DATE ='08-MAY-21';

drop table d_REPL_ATTR_ID;    
create table d_REPL_ATTR_ID as  select * from rms.REPL_ATTR_UPDATE_HEAD;
delete from REPL_ATTR_UPDATE_LOC where REPL_ATTR_ID in (select REPL_ATTR_ID from d_REPL_ATTR_ID);
delete from REPL_ATTR_UPDATE_ITEM where REPL_ATTR_ID in (select REPL_ATTR_ID from d_REPL_ATTR_ID);
delete from REPL_ATTR_UPDATE_HEAD where REPL_ATTR_ID in (select REPL_ATTR_ID from d_REPL_ATTR_ID);
commit;


select * from all_views where lower(view_name) like 'v_rau_item_stage';
select * from rms.period;

select count(1) from RMS.REPL_ITEM_LOC;  --1275685
select count(1) from rms.REPL_RESULTS;   --97897



select * from REPL_ATTR_UPDATE_item raui where exists (select 1 from rms.REPL_ITEM_LOC ril where ril.ITEM_PARENT =raui.item );
select * from REPL_ATTR_UPDATE_item raui where exists (select 1 from rms.REPL_RESULTS ril where ril.ITEM =raui.item );
select * from REPL_ATTR_UPDATE_item raui where exists (select 1 from rms.REPL_RESULTS ril where ril.MASTER_ITEM =raui.item );

select count(1) from  REPL_ATTR_UPDATE_item raui where exists (select 1 from rms.ITEM_LOC ril where ril.ITEM_PARENT =raui.item and RIL.LOC = '1001' AND ril.CLEAR_IND ='Y' and rownum <= '1');
select count(1) from  REPL_ATTR_UPDATE_item raui where exists (select 1 from rms.ITEM_LOC ril where ril.ITEM_PARENT =raui.item and RIL.LOC = '3001' AND ril.CLEAR_IND ='Y' and rownum <= '1');
select count(1) from  REPL_ATTR_UPDATE_item raui where exists (select 1 from rms.ITEM_LOC ril where ril.ITEM_PARENT =raui.item and RIL.LOC = '4001' AND ril.CLEAR_IND ='Y' and rownum <= '1');

update rms.restart_program_status set program_status= 'ready for start';
delete from rms.restart_bookmark;
select * from rms.restart_bookmark;
select * from rms.restart_program_status;

set serveroutput on;
set timing on;

declare
 COUNTER_COMMIT  NUMBER(10)     := 1;
l_repl_attr_id		rms.REPL_ATTR_UPDATE_ITEM.repl_attr_id%type;
l_item				rms.REPL_ATTR_UPDATE_ITEM.item%type;
l_dept				rms.REPL_ATTR_UPDATE_ITEM.dept%type;
l_class				rms.REPL_ATTR_UPDATE_ITEM.class%type;
l_subclass			rms.REPL_ATTR_UPDATE_ITEM.subclass%type;
l_loc				rms.REPL_ATTR_UPDATE_LOC.loc%type;
l_loc_type			rms.REPL_ATTR_UPDATE_LOC.loc_type%type := 'W';
L_SUPPLIER          rms.REPL_ATTR_UPDATE_HEAD.SUPPLIER%TYPE;
L_ORIGIN_COUNTRY_ID rms.REPL_ATTR_UPDATE_HEAD.ORIGIN_COUNTRY_ID%TYPE;
abcd date;

cursor c_loc is
 select wh from rms.wh where wh in ('1001','4001','3001');
 
cursor c_rplatupd(l_loc rms.REPL_ATTR_UPDATE_LOC.loc%type) is
	select im.item,
				im.dept,
				im.class,
				im.subclass,
				isl.supplier,
				isl.origin_country_id
			from rms.item_master im
                  INNER JOIN rms.item_supp_country_loc isl on ( isl.item =im.item and isl.loc = l_loc and isl.supplier= '1100000086') 
			where im.item_level = '1'
                    and im.status ='A' 
                    and im.item_desc like'%UploadTest%'
                    and not exists (select 1 from rms.REPL_ATTR_UPDATE_ITEM raui where raui.item=im.item )
                    and not exists (select 1 from rms.repl_item_loc raui where raui.item_parent=im.item )
					and rownum<=20; -- Change for number of records

cursor c_repl_atr_id_seq is
    select rms.REPL_ATTR_UPD_ID_SEQ.nextval REPL_ATTR_ID from dual;

begin

for i in 0..5 loop
for m in 0..2 loop
  select vdate into abcd from rms.period;
  
for k in c_loc loop
        l_loc           :=k.wh;

for i in c_rplatupd(l_loc) loop 

        l_item				:=i.item;
        l_dept          	:=i.dept;
        l_class         	:=i.class;
        l_subclass      	:=i.subclass;
        l_supplier      	:=i.supplier;
        l_origin_country_id :=i.origin_country_id;

     open c_repl_atr_id_seq;
	 fetch c_repl_atr_id_seq into l_repl_attr_id;
	 close c_repl_atr_id_seq;
     
        insert into rms.REPL_ATTR_UPDATE_HEAD(  repl_attr_id 			, 
                                                scheduled_active_date 	,--get_vdate+1
                                                action 					,
                                                mra_update  			,
                                                mra_restore  			, 
                                                repl_method_ind			,
                                                stock_cat				,
                                                repl_order_ctrl			,
                                                activate_date 			,--get_vdate+1
                                                deactivate_date			,--get_vdate+3
                                                pres_stock				,
                                                repl_method				,
                                                min_stock,
                                                max_stock,
                                                incr_pct,
                                                non_scaling_ind ,
                                                max_scale_value,
                                                pickup_lead_time,
                                                supplier,
                                                origin_country_id ,
                                                review_cycle,
                                                update_days_ind 		, 
                                                monday_ind				, 
                                                tuesday_ind			 	, 
                                                wednesday_ind		 	, 
                                                thursday_ind		 	, 
                                                friday_ind			 	, 
                                                saturday_ind		 	, 
                                                sunday_ind 			 	, 
                                                default_pack_ind  ,
                                                remove_pack_ind ,
                                                use_tolerance_ind  ,
                                                create_date,
                                                create_id,
                                                sch_rpl_desc ,
                                                mult_runs_per_day_ind ,
                                                tsf_zero_soh_ind  	)
					values    (l_repl_attr_id,
								to_date(abcd),
								'A',
								'N',
								'N',
								'Y',
								'W',
								'A',
								to_date(abcd),
								to_date(abcd+40),
								0,
								'M',
								200,
								500,
								50,
								'N',
								0,
                                0,
								l_supplier,
								l_origin_country_id,
								'1',
								'N',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
                                'N',
                                'N',
								'N',
								SYSDATE,
								'PTUSER',
								'REPL_PT:'||l_repl_attr_id,
								'N',
								'N');
                                        
        insert into rms.REPL_ATTR_UPDATE_ITEM(	
                                            item        ,     
                                            repl_attr_id,
                                            dept        ,
                                            class       ,
                                            subclass    )
						values(
								l_item,
                                l_repl_attr_id,
								l_dept,
								l_class,
								l_subclass);
										
        insert into rms.REPL_ATTR_UPDATE_LOC(LOC,
                                         LOC_TYPE,
                                         REPL_ATTR_ID)
					values(	l_loc,
							l_loc_type,
							l_repl_attr_id);
															
  
              	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 500) = 0 THEN
				COMMIT;
			   END IF;	 
 	end loop;
	end loop;
	end loop;
    end loop;

exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/





insert into clear_item
select distinct item_parent from rms.item_loc il where item_parent is not null and il.clear_ind ='N' and rownum <= '10000'
    and not exists (select 1 from clear_item ci where ci.item_parent =il.item_parent);


select count(1) from clear_item;

set serveroutput on;
set timing on;

declare
 COUNTER_COMMIT  NUMBER(10)     := 1;
l_repl_attr_id		rms.REPL_ATTR_UPDATE_ITEM.repl_attr_id%type;
l_item				rms.REPL_ATTR_UPDATE_ITEM.item%type;
l_dept				rms.REPL_ATTR_UPDATE_ITEM.dept%type;
l_class				rms.REPL_ATTR_UPDATE_ITEM.class%type;
l_subclass			rms.REPL_ATTR_UPDATE_ITEM.subclass%type;
l_loc				rms.REPL_ATTR_UPDATE_LOC.loc%type;
l_loc_type			rms.REPL_ATTR_UPDATE_LOC.loc_type%type := 'W';
L_SUPPLIER          rms.REPL_ATTR_UPDATE_HEAD.SUPPLIER%TYPE;
L_ORIGIN_COUNTRY_ID rms.REPL_ATTR_UPDATE_HEAD.ORIGIN_COUNTRY_ID%TYPE;
abcd date;

cursor c_loc is
 select wh into l_loc from rms.wh where wh in (1001,4001,3001);
 
cursor c_rplatupd(l_loc rms.REPL_ATTR_UPDATE_LOC.loc%type) is
	select im.item,
				im.dept,
				im.class,
				im.subclass,
				isl.supplier,
				isl.origin_country_id
			from rms.item_master im
                  INNER JOIN rms.item_supp_country_loc isl on ( isl.item =im.item and isl.loc = l_loc) 
			where im.item_level <= '1'
                    and im.status ='A' 
                    and not exists (select 1 from rms.REPL_ATTR_UPDATE_ITEM raui where raui.item=im.item )
                    and not exists (select 1 from rms.repl_item_loc raui where raui.item_parent=im.item )
                    and exists (select 1 from clear_item il where il.item_parent=im.item)
					and rownum<=100; -- Change for number of records

cursor c_repl_atr_id_seq is
    select rms.REPL_ATTR_UPD_ID_SEQ.nextval REPL_ATTR_ID from dual;

begin

for i in 0..1 loop
for m in 0..5 loop
  select vdate into abcd from rms.period;
  
for k in c_loc loop
        l_loc           :=k.wh;

for i in c_rplatupd(l_loc) loop 

        l_item				:=i.item;
        l_dept          	:=i.dept;
        l_class         	:=i.class;
        l_subclass      	:=i.subclass;
        l_supplier      	:=i.supplier;
        l_origin_country_id :=i.origin_country_id;

     open c_repl_atr_id_seq;
	 fetch c_repl_atr_id_seq into l_repl_attr_id;
	 close c_repl_atr_id_seq;
     
            INsert into rms.REPL_ATTR_UPDATE_HEAD(  repl_attr_id 			, 
                                                scheduled_active_date 	,--get_vdate+1
                                                action 					,
                                                mra_update  			,
                                                mra_restore  			, 
                                                repl_method_ind			,
                                                stock_cat				,
                                                repl_order_ctrl			,
                                                activate_date 			,--get_vdate+1
                                                deactivate_date			,--get_vdate+3
                                                pres_stock				,
                                                repl_method				,
                                                min_stock,
                                                max_stock,
                                                incr_pct,
                                                non_scaling_ind ,
                                                max_scale_value,
                                                pickup_lead_time,
                                                supplier,
                                                origin_country_id ,
                                                review_cycle,
                                                update_days_ind 		, 
                                                monday_ind				, 
                                                tuesday_ind			 	, 
                                                wednesday_ind		 	, 
                                                thursday_ind		 	, 
                                                friday_ind			 	, 
                                                saturday_ind		 	, 
                                                sunday_ind 			 	, 
                                                default_pack_ind  ,
                                                remove_pack_ind ,
                                                use_tolerance_ind  ,
                                                create_date,
                                                create_id,
                                                sch_rpl_desc ,
                                                mult_runs_per_day_ind ,
                                                tsf_zero_soh_ind  	)
					values    (l_repl_attr_id,
								to_date(abcd),
								'A',
								'N',
								'N',
								'Y',
								'W',
								'A',
								to_date(abcd),
								to_date(abcd+4),
								0,
								'M',
								1000,
								5000,
								50,
								'N',
								0,
                                0,
								l_supplier,
								l_origin_country_id,
								'1',
								'N',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
                                'N',
                                'N',
								'N',
								SYSDATE,
								'PTUSER',
								'REPL_PT:'||l_repl_attr_id,
								'N',
								'N');
                                        
        insert into rms.REPL_ATTR_UPDATE_ITEM(	
                                            item        ,     
                                            repl_attr_id,
                                            dept        ,
                                            class       ,
                                            subclass    )
						values(
								l_item,
                                l_repl_attr_id,
								l_dept,
								l_class,
								l_subclass);
										
        insert into rms.REPL_ATTR_UPDATE_LOC(LOC,
                                         LOC_TYPE,
                                         REPL_ATTR_ID)
					values(	l_loc,
							l_loc_type,
							l_repl_attr_id);
															
  
  	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;	 
 	end loop;
	end loop;
	end loop;
    	end loop;
exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/




/*



set serveroutput on;
set timing on;

declare
 COUNTER_COMMIT  NUMBER(10)     := 1;
l_repl_attr_id		rms.REPL_ATTR_UPDATE_ITEM.repl_attr_id%type;
l_item				rms.REPL_ATTR_UPDATE_ITEM.item%type;
l_dept				rms.REPL_ATTR_UPDATE_ITEM.dept%type;
l_class				rms.REPL_ATTR_UPDATE_ITEM.class%type;
l_subclass			rms.REPL_ATTR_UPDATE_ITEM.subclass%type;
l_loc				rms.REPL_ATTR_UPDATE_LOC.loc%type;
l_loc_type			rms.REPL_ATTR_UPDATE_LOC.loc_type%type := 'W';
L_SUPPLIER          rms.REPL_ATTR_UPDATE_HEAD.SUPPLIER%TYPE;
L_ORIGIN_COUNTRY_ID rms.REPL_ATTR_UPDATE_HEAD.ORIGIN_COUNTRY_ID%TYPE;
abcd date;

cursor c_loc is
    select distinct im.dept,im.class,im.subclass,wh.wh from rms.wh, rms.subclass im where wh in (1001,4001,3001)  --and rownum <='150' 
            order by 1,2,3,4; 
 
cursor c_rplatupd(l_loc rms.REPL_ATTR_UPDATE_LOC.loc%type,l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type) is
	select im.item,
				im.dept,
				im.class,
				im.subclass,
				isl.supplier,
				isl.origin_country_id
			from rms.item_master im
                  INNER JOIN rms.item_supp_country_loc isl on ( isl.item =im.item and isl.loc = l_loc) 
			where im.item_level = im.tran_level 
                    and im.status ='A' 
                   	 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                    and not exists (select 1 from rms.item_loc il where il.item=im.item and il.loc =l_loc and il.clear_ind ='Y')
                    and not exists (select 1 from rms.REPL_ATTR_UPDATE_item it where it.item=im.item)
					and rownum<=10; -- Change for number of records

cursor c_repl_atr_id_seq is
    select rms.REPL_ATTR_UPD_ID_SEQ.nextval REPL_ATTR_ID from dual;

begin

for i in 0..7 loop
for m in 0..2 loop
 
  select vdate into abcd from rms.period;
  
for k in c_loc loop
        l_loc           :=k.wh;
        l_dept          	:=k.dept;
        l_class         	:=k.class;
        l_subclass      	:=k.subclass;

for i in c_rplatupd(l_loc,l_dept,l_class,l_subclass) loop 

        l_item				:=i.item;
        l_dept          	:=i.dept;
        l_class         	:=i.class;
        l_subclass      	:=i.subclass;
        l_supplier      	:=i.supplier;
        l_origin_country_id :=i.origin_country_id;

     open c_repl_atr_id_seq;
	 fetch c_repl_atr_id_seq into l_repl_attr_id;
	 close c_repl_atr_id_seq;
     
            INsert into rms.REPL_ATTR_UPDATE_HEAD(  repl_attr_id 			, 
                                                scheduled_active_date 	,--get_vdate+1
                                                action 					,
                                                mra_update  			,
                                                mra_restore  			, 
                                                repl_method_ind			,
                                                stock_cat				,
                                                repl_order_ctrl			,
                                                activate_date 			,--get_vdate+1
                                                deactivate_date			,--get_vdate+3
                                                pres_stock				,
                                                repl_method				,
                                                min_stock,
                                                max_stock,
                                                incr_pct,
                                                non_scaling_ind ,
                                                max_scale_value,
                                                pickup_lead_time,
                                                supplier,
                                                origin_country_id ,
                                                review_cycle,
                                                update_days_ind 		, 
                                                monday_ind				, 
                                                tuesday_ind			 	, 
                                                wednesday_ind		 	, 
                                                thursday_ind		 	, 
                                                friday_ind			 	, 
                                                saturday_ind		 	, 
                                                sunday_ind 			 	, 
                                                default_pack_ind  ,
                                                remove_pack_ind ,
                                                use_tolerance_ind  ,
                                                create_date,
                                                create_id,
                                                sch_rpl_desc ,
                                                mult_runs_per_day_ind ,
                                                tsf_zero_soh_ind  	)
					values    (l_repl_attr_id,
								to_date(abcd),
								'A',
								'N',
								'N',
								'Y',
								'W',
								'A',
								to_date(abcd),
								to_date(abcd+4),
								0,
								'M',
								10,
								500,
								50,
								'N',
								0,
                                0,
								l_supplier,
								l_origin_country_id,
								'1',
								'N',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
								'Y',
                                'N',
                                'N',
								'N',
								SYSDATE,
								'PTUSER',
								'REPL_PT:'||l_repl_attr_id,
								'N',
								'N');
                                        
        insert into rms.REPL_ATTR_UPDATE_ITEM(	
                                            item        ,     
                                            repl_attr_id,
                                            dept        ,
                                            class       ,
                                            subclass    )
						values(
								l_item,
                                l_repl_attr_id,
								l_dept,
								l_class,
								l_subclass);
										
        insert into rms.REPL_ATTR_UPDATE_LOC(LOC,
                                         LOC_TYPE,
                                         REPL_ATTR_ID)
					values(	l_loc,
							l_loc_type,
							l_repl_attr_id);
															
  
  	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;	 
 	end loop;
	end loop;
	end loop;
    	end loop;
      commit;

exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/

*/


Pre -- Modify index 

RPLATUPD 

SELECT distinct rau_head.repl_attr_id,
             vris.item,
             rau_head.action
    FROM v_restart_store_wh vrsw,
             v_rau_item_stage vris,
             repl_attr_update_loc rau_loc,
             repl_attr_update_head rau_head,
             period per
       WHERE rau_head.repl_attr_id = vris.repl_attr_id
         AND rau_loc.repl_attr_id = vris.repl_attr_id
         AND rau_head.scheduled_active_date = per.vdate
         AND NOT EXISTS (SELECT 'X'
                           FROM repl_attr_update_exclude rau_excl
                          WHERE rau_excl.repl_attr_id = rau_head.repl_attr_id
                            AND rau_excl.item = vris.item
                            AND rau_excl.location = rau_loc.loc
                            AND rau_excl.loc_type = rau_loc.loc_type
                            AND rownum = 1)
         AND EXISTS (SELECT 'x'
                       FROM item_loc il
                      WHERE il.item = vris.item
                        AND il.loc = rau_loc.loc
                        AND il.loc_type = rau_loc.loc_type
                        AND rownum = 1);

post -- Purge older records.

pre  -- uptdate null locations & deletes 
rilmaint
  SELECT rilu.item,
             NVL(rilu.supplier, -1),
             NVL(rilu.origin_country_id, '-1'),
             NVL(rilu.location, -1),
             NVL(rilu.loc_type, '-1')
        FROM repl_item_loc_updates rilu,
             repl_item_loc ril
       WHERE rilu.change_type != 'LKITEM'
         AND ril.item (+) = rilu.item
         AND ril.location(+) = rilu.location ;
         
post -- Modify index & trunc table repl_item_loc_updates

select * from repl_item_loc_updates;

Pre 
select * from rpl_net_inventory_tmp;

select * from rpl_distro_tmp;
select * from rpl_alloc_in_tmp;

replroq   -- Store level replenishments

select * from svc_repl_roq;
select * from repl_item_loc where item in (select item from item_master where item ='100689074' or item_parent = '100689074');
select * from repl_day where item in (select item from item_master where item ='100689074' or item_parent = '100689074');

Pre

BATCH_REQEXT 

Post 

replext

select ril.item                                         I_item,
            ril.location                                     I_locn,
            ril.loc_type                                     I_locn_type,
            ril.primary_repl_supplier                        I_primary_repl_supplier,
            ril.origin_country_id                            I_origin_country_id,
            ril.review_cycle                                 I_review_cycle,
            ril.stock_cat                                    I_stock_cat,
            ril.repl_order_ctrl                              I_repl_order_ctrl,
            ril.source_wh                                    I_source_wh,
            ril.activate_date                                I_activate_date,
            ril.deactivate_date                              I_deactivate_date
       from repl_item_loc ril,
            repl_day rdy
      where ril.item = rdy.item
        and ril.status = 'A'
        and ril.location = rdy.location
        and rdy.weekday = TO_NUMBER('7')
        and ril.loc_type = 'W' and ril.stock_cat = 'W'
        and ril.activate_date <= '08-MAY-21'
        and NVL(ril.deactivate_date, ('09-MAY-21'))
                > '08-MAY-21';

