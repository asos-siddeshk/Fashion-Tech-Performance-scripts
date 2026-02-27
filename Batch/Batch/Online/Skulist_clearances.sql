
--- Item list creations ------
drop table INT_PL_ITEMLIST_UPLD_STG_bk;
create table INT_PL_ITEMLIST_UPLD_STG_bk as
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG ;
delete int_asos.INT_PL_ITEMLIST_UPLD_STG where STATUS = 'U';

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
select item from optionlist_2209;

BEGIN

   select sysdate into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'Optionlist2209'||'-'||l_REF_NO;
		I_filename 		:= 'Optionlist2209'||'-'||l_REF_NO;
        
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
       
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
END;
/



---- Clearance Creations -------

select * from ma_stage_clearance_bk;
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
delete from ma_asos.ma_stage_clearance ;
delete from skumar.ma_stage_clearance_bk where skulist is not null;

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N' group by EFFECTIVE_DATE order by 1; --

delete from ma_asos.ma_stage_clearance where EFFECTIVE_DATE = '16-DEC-18' and skulist is not null and rownum <='15';
delete from skumar.ma_stage_clearance_bk where EFFECTIVE_DATE = '16-DEC-18' and skulist is not null and rownum <='15';

--- Clearances - Itemlist levels --

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
            select ma.ZONE_ID,ma.store from ma_asos.ma_pricing_defaults ma ;
    
	 cursor c_get_cuitem_clr (p_zone_id ma_asos.ma_stage_clearance.zone_id%type)  is
            select sh.SKULIST from rms.skulist_head sh where sh.sKULIST_DESC like 'Clearance%'
                and not exists (select 1 from ma_asos.ma_stage_clearance mpc where mpc.SKULIST = sh.SKULIST and mpc.zone_id = p_zone_id)
                and not exists (select 1 from skumar.ma_stage_clearance_bk mpc where mpc.SKULIST = sh.SKULIST and mpc.zone_id = p_zone_id) and rownum <='2' ;
      
BEGIN

for m in 0..6 loop

    select vdate+1+m into p_effective_date from rms.period;
    select vdate+2+m into p_out_of_stock_date from rms.period;
    select vdate+2+m into p_reset_date from rms.period;
    
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
                                                       '-40',
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
                                                       '-40',
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
  commit;
  
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/



