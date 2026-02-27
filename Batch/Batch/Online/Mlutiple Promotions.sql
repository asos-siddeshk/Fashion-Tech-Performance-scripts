select * from rpm_stage_simple_promo_bk2;

drop table rpm_stage_simple_promo_bk2;
create table rpm_stage_simple_promo_bk2 as select * from rpm_stage_simple_promo ;


delete from rpm_stage_simple_promo;

select status,count(1) from rpm_stage_simple_promo group by status;
select item,count(1) from ma_asos.ma_stage_simple_promo where status='N' group by item;
select PROMO_START_DATE,count(1) from ma_asos.ma_stage_simple_promo where status='N' group by PROMO_START_DATE order by 1;
select state,count(1) from rms.rpm_promo_dtl where START_DATE between '16-JAN-24' and '17-JAN-24' group by state;

select * from rpm_stage_simple_promo_bk2;

select promo_dtl_id,count(1) from 
    rpm_promo_item_loc_expl where PROMO_COMP_ID in (select distinct PROMO_COMP_ID from rpm_stage_simple_promo_bk2) group by promo_dtl_id;

select item,count(1) from 
    rpm_promo_item_loc_expl where PROMO_COMP_ID in (select distinct PROMO_COMP_ID from rpm_stage_simple_promo_bk2) group by item;


update rpm_stage_simple_promo_bk2 set PROMO_EVENT_ID='59';

select * from rpm_promo_event;
Update rpm_promo set PROMO_EVENT_ID ='60' where PROMO_EVENT_ID = '59' and 
    PROMO_ID in (select distinct PROMO_ID from rpm_stage_simple_promo);

select * from rpm_promo where PROMO_ID in (select distinct PROMO_ID from rpm_stage_simple_promo_bk2);



---------------------------------------------------------------- Retention period promotions ----------------------------------------------------------------
set serveroutput on;
set timing on;

declare

  COUNTER         NUMBER(8)     := 0;
  COUNTER_COMMIT  NUMBER(8)     := 1;
  stage_COMMIT  NUMBER(8)     := 0;
  
   l_item_id                    rms.rpm_stage_simple_promo.item%type;
   l_stage_simple_promo_id      rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
   l_name                       rms.rpm_stage_simple_promo.name%type;
   l_promo_start_date           rms.rpm_stage_simple_promo.promo_start_date%type;
   l_promo_end_date             rms.rpm_stage_simple_promo.promo_end_date%type;
   l_dtl_start_date             rms.rpm_stage_simple_promo.dtl_start_date%type;
   l_date                       rms.rpm_stage_simple_promo.dtl_start_date%type;
   l_dtl_end_date               rms.rpm_stage_simple_promo.dtl_end_date%type;
   L_PROMO_EVENT_ID             rms.rpm_stage_simple_promo.PROMO_EVENT_ID%type;
   l_zone_id                    rms.rpm_stage_simple_promo.zone_id%type;
   ma_zone_id                   rms.rpm_stage_simple_promo.zone_id%type;
   ma_location                  rms.rpm_stage_simple_promo.location%type;
   l_location                   rms.rpm_stage_simple_promo.location%type;
   l_change_type                rms.rpm_stage_simple_promo.change_type%type;
   l_change_percent             rms.rpm_stage_simple_promo.change_percent%type;
   l_change_amount              rms.rpm_stage_simple_promo.change_amount%type;
   l_currency_code              rms.rpm_stage_simple_promo.currency_code%type;
   l_stage_id                   rms.rpm_stage_simple_promo.stage_id%type :='1';
   l_stage_promo_comp_id        rms.rpm_stage_simple_promo.stage_promo_comp_id%type :='1';
   l_time_dtl                   rms.rpm_stage_simple_promo.timebased_dtl_ind%type;
   l_sp_stage_id                rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
   l_selling_unit_retail        rms.rpm_stage_price_change.change_percent%type;
   l_selling_uom                rms.item_loc.SELLING_UOM%type;
   l_dept                       rms.subclass.dept%type; 
   l_class                      rms.subclass.class%type; 
   l_subclass                   rms.subclass.subclass%type; 
   
    cursor cur_dept is
                select dept,class,subclass,zone_id,store  from (
                   select im.dept,im.class,im.subclass,ma.ZONE_ID,ma.store from rms.subclass im ,ma_asos.ma_pricing_defaults ma where 
                                (dept!='9999' and class!='9999' and subclass!='9999' and ma.store = '20000') 
                                group by im.dept,im.class,im.subclass,ma.ZONE_ID,ma.store) order by 1,2,3,4;
   
                cursor c_get_item_sp (l_dept rms.subclass.dept%type, l_class rms.subclass.class%type, l_subclass rms.subclass.subclass%type, 
                    l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type)is
                       select item,zone_id,location,P_name,currency_code,current_retail,SELLING_UOM from (
                       select distinct im.item,ma.zone_id,ma.store as location,'Promotion: ' as P_name,s.currency_code,il.selling_unit_retail as current_retail,il.SELLING_UOM    
                                     from rms.item_master     im,
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
                                             and not exists (select 1 from rms.rpm_stage_simple_promo rsp where rsp.item = im.item and rsp.LOCATION = l_location) 
                                             and not exists (select 1 from rms.rpm_promo_dtl rpd, rms.rpm_promo_dtl_merch_node rpdmn, rms.rpm_promo_zone_location rpzl,rms.rpm_promo_dtl_list rpdl
                                                                             where rpd.START_DATE >= '20-DEC-2018'
                                                                              and  rpd.END_DATE <= '20-JUN-2019'
                                                                                and rpd.promo_dtl_id = rpzl.promo_dtl_id
                                                                                and rpdmn.promo_dtl_list_id = rpdl.promo_dtl_list_id
                                                                                and rpdmn.item = im.item 
                                                                                and rpzl.location = l_location)) where rownum <= '5';

begin

     select  vdate+155 into l_promo_start_date from rms.period; 
     select  vdate+185 into l_promo_end_date from rms.period; 
     select  vdate+155 into l_dtl_start_date from rms.period; 
     select  vdate+185 into l_dtl_end_date from rms.period; 
         

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
                            l_item_id                    := i.item;
                            l_zone_id                    := i.ZONE_ID;
                            l_location                   := i.location;
                            l_name                       := i.p_name;
                            l_currency_code              := i.currency_code;
                            l_selling_unit_retail        := i.CURRENT_RETAIL -(0.75);
                            l_selling_uom                :=i.selling_uom;
                                                            
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
                   
       
     end loop;
     end loop;
    commit;

  
exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/


SELECT  pe.PROMO_EVENT_DISPLAY_ID,p.promo_display_id
  FROM rpm_promo p,
       rpm_promo_event pe,
       rpm_promo_comp pc,
       rpm_promo_dtl pdtl,
       rpm_promo_dtl_list_grp pdlg,
       rpm_promo_dtl_list pdl,
       rpm_promo_dtl_disc_ladder pddl
WHERE  p.PROMO_EVENT_ID                 = pe.PROMO_EVENT_ID
    and p.PROMO_EVENT_ID = '58'
   and p.promo_id                 = pc.promo_id
   and pdtl.promo_comp_id         = pc.promo_comp_id
   and pdtl.promo_dtl_id          = pdlg.promo_dtl_id
   and pdlg.promo_dtl_list_grp_id = pdl.promo_dtl_list_grp_id
   and pdl.promo_dtl_list_id      = pddl.promo_dtl_list_id
   AND pddl.change_type           = 0 -- % off
   and pdtl.state                 = 3 -- approved
   and pc.type                    = 1 -- simple promotion
   and rms.get_vdate                  < p.start_date
GROUP BY pe.PROMO_EVENT_DISPLAY_ID,pc.promo_comp_id,pc.comp_display_id,pc.promo_id,p.promo_display_id
order by pe.PROMO_EVENT_DISPLAY_ID,pc.promo_comp_id,pc.comp_display_id,pc.promo_id,p.promo_display_id;


---------------------------------------------------------------- Promotions Copy Test data ----------------------------------------------------------------
set serveroutput on;
set timing on;

declare

            COUNTER                     NUMBER(8)     := 0;
            COUNTER_COMMIT              NUMBER(8)     := 1;
            stage_COMMIT                NUMBER(8)     := 0;
 
        l_sp_stage_id      				rms.rpm_stage_simple_promo.stage_simple_promo_id%type;
        l_promo_id	      				rms.rpm_stage_simple_promo.PROMO_ID%type;
        l_promo_comp_id	      			rms.rpm_stage_simple_promo.PROMO_COMP_ID%type;
        l_comp_display_id	      		rms.rpm_stage_simple_promo.COMP_DISPLAY_ID%type;
        l_merch_type	      			rms.rpm_stage_simple_promo.MERCH_TYPE%type;
        l_item	      					rms.rpm_stage_simple_promo.ITEM%type;
        l_zone_node_type	      		rms.rpm_stage_simple_promo.ZONE_NODE_TYPE%type;
        l_location	      				rms.rpm_stage_simple_promo.LOCATION%type;
        l_apply_to_code	      			rms.rpm_stage_simple_promo.APPLY_TO_CODE%type;
        l_promo_start_date	      		rms.rpm_stage_simple_promo.PROMO_START_DATE%type;
        l_promo_end_date	      		rms.rpm_stage_simple_promo.PROMO_END_DATE%type;
        l_ignore_constraints	      	rms.rpm_stage_simple_promo.IGNORE_CONSTRAINTS%type;
        l_change_type	      			rms.rpm_stage_simple_promo.CHANGE_TYPE%type;
        l_change_percent	      		rms.rpm_stage_simple_promo.CHANGE_PERCENT%type;
        l_change_selling_uom	      	rms.rpm_stage_simple_promo.CHANGE_SELLING_UOM%type;
        l_auto_approve_ind	      		rms.rpm_stage_simple_promo.AUTO_APPROVE_IND%type;
        l_timebased_dtl_ind	      		rms.rpm_stage_simple_promo.TIMEBASED_DTL_IND%type;
        l_thread_num	      			rms.rpm_stage_simple_promo.THREAD_NUM%type;
        l_exclusion_created	      		rms.rpm_stage_simple_promo.EXCLUSION_CREATED%type;
        l_name	      					rms.rpm_stage_simple_promo.NAME%type;
        l_promo_event_id	      		rms.rpm_stage_simple_promo.PROMO_EVENT_ID%type;
        l_dtl_start_date	      		rms.rpm_stage_simple_promo.DTL_START_DATE%type;
        l_dtl_end_date	      			rms.rpm_stage_simple_promo.DTL_END_DATE%type;
        l_vendor_funded_ind	      	  	rms.rpm_stage_simple_promo.VENDOR_FUNDED_IND%type;
        l_currency_code	      		  	rms.rpm_stage_simple_promo.CURRENCY_CODE%type;
        l_promo_display_id	          	rms.rpm_stage_simple_promo.PROMO_DISPLAY_ID%type;
      
    cursor cur_promo is 
            
            select PROMO_ID, PROMO_COMP_ID, COMP_DISPLAY_ID, MERCH_TYPE, ITEM, ZONE_NODE_TYPE, LOCATION, APPLY_TO_CODE, PROMO_START_DATE, PROMO_END_DATE, IGNORE_CONSTRAINTS, CHANGE_TYPE, CHANGE_PERCENT, CHANGE_SELLING_UOM, AUTO_APPROVE_IND, STATUS, TIMEBASED_DTL_IND, THREAD_NUM, EXCLUSION_CREATED, NAME, PROMO_EVENT_ID, DTL_START_DATE, DTL_END_DATE, PROMO_SECONDARY_IND, COMP_SECONDARY_IND, VENDOR_FUNDED_IND, CURRENCY_CODE, PROMO_DISPLAY_ID
                 from rpm_stage_simple_promo_bk2 where status = 'A';

    cursor cur_item is 
            select im.item from item_master_op im where 
               not exists (select 1 from rms.rpm_promo_item_loc_expl rsp where rsp.item = im.item)
               and not exists (select 1 from rms.rpm_stage_simple_promo rs where rs.item = im.item) and  rownum <= '500';
    
begin
                                        
    for k in cur_promo loop
    
            l_promo_id	      			:= k.PROMO_ID;
            l_promo_comp_id	      		:= k.COMP_DISPLAY_ID;
            l_comp_display_id	      	:= k.PROMO_COMP_ID;
            l_merch_type	      		:= k.MERCH_TYPE;
            l_zone_node_type	      	:= k.ZONE_NODE_TYPE;
            l_location	      			:= k.LOCATION;
            l_apply_to_code	      		:= k.APPLY_TO_CODE;
            l_promo_start_date	      	:= k.PROMO_START_DATE;
            l_promo_end_date	      	:= k.PROMO_END_DATE;
            l_ignore_constraints	    := k.IGNORE_CONSTRAINTS;
            l_change_type	      		:= k.CHANGE_TYPE;
            l_change_percent	      	:= k.CHANGE_PERCENT;
            l_change_selling_uom	    := k.CHANGE_SELLING_UOM;
            l_auto_approve_ind	      	:= k.AUTO_APPROVE_IND;
            l_timebased_dtl_ind	      	:= k.TIMEBASED_DTL_IND;
            l_thread_num	      		:= k.THREAD_NUM;
            l_exclusion_created	      	:= k.EXCLUSION_CREATED;
            l_name	      				:= k.NAME;
            l_promo_event_id	      	:= k.PROMO_EVENT_ID;
            l_dtl_start_date	      	:= k.DTL_START_DATE;
            l_dtl_end_date	      		:= k.DTL_END_DATE;
            l_vendor_funded_ind	      	:= k.VENDOR_FUNDED_IND;
            l_currency_code	      		:= k.CURRENCY_CODE;
            l_promo_display_id	        := k.PROMO_DISPLAY_ID;
    
    
    for j in cur_item loop
            l_item	      				:= j.ITEM;
                                                            
        select rms.RPM_STAGE_PROMO_SIMPLE_SEQ.nextval into l_sp_stage_id from dual;
            
        insert into rms.rpm_stage_simple_promo( stage_simple_promo_id 
                                                    , promo_id
                                                    , comp_display_id
                                                    , promo_comp_id
                                                    , merch_type
                                                    , item
                                                    , zone_node_type
                                                    , location
                                                    , apply_to_code
                                                    , promo_start_date
                                                    , promo_end_date
                                                    , ignore_constraints
                                                    , change_type
                                                    , change_percent
                                                    , change_selling_uom
                                                    , auto_approve_ind
                                                    , status
                                                    , timebased_dtl_ind
                                                    , thread_num
                                                    , exclusion_created
                                                    , name
                                                    , promo_event_id
                                                    , dtl_start_date
                                                    , dtl_end_date
                                                    , promo_secondary_ind
                                                    , COMP_SECONDARY_IND
                                                    , vendor_funded_ind
                                                    , currency_code
                                                    , promo_display_id )
                            values ( l_sp_stage_id
                                    , l_promo_id		
                                    , l_promo_comp_id	
                                    , l_comp_display_id	
                                    , l_merch_type	
                                    , l_item			
                                    , l_zone_node_type	
                                    , l_location		
                                    , l_apply_to_code	
                                    , l_promo_start_date	
                                    , to_date(l_promo_end_date) + 1 - 1/(24*60)
                                    , l_ignore_constraints
                                    , l_change_type	
                                    , l_change_percent	
                                    , l_change_selling_uom
                                    , l_auto_approve_ind	
                                    , 'N'		
                                    , l_timebased_dtl_ind	
                                    , l_thread_num	
                                    , l_exclusion_created	
                                    , l_name			
                                    , l_promo_event_id	
                                    , l_dtl_start_date	
                                    , to_date(l_dtl_end_date) + 1 - 1/(24*60)
                                    , '0'
                                    , '0'
                                    , l_vendor_funded_ind	
                                    , l_currency_code	
                                    , l_promo_display_id );

               COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT,10) = 0 THEN
                        COMMIT;
               END IF;
                   
       
     end loop;
     end loop;
    commit;

  
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

            COUNTER                     NUMBER(8)     := 0;
            COUNTER_COMMIT              NUMBER(8)     := 1;
            stage_COMMIT                NUMBER(8)     := 0;
 
        l_promo_comp_id	      			rms.rpm_stage_simple_promo.PROMO_COMP_ID%type;
        
        cursor cur_promo is 
            select promo_comp_id  from rpm_stage_simple_promo_bk2;
begin

for k in cur_promo loop
            l_promo_comp_id	      		:= k.PROMO_COMP_ID;
       
        Update rpm_promo_dtl set STATE ='0' where state ='3' and promo_comp_id =l_promo_comp_id and rownum <= '25';    

end loop;
  
exception
   when others then
         dbms_output.put_line('exception blcok'||to_char(sqlcode)||sqlerrm);
rollback;

end;
/
