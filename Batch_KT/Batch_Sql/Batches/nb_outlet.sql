select * from all_views where upper(view_name) like 'V_CFA_ITM_ATT_G';

 select mso.outlet_days_pc, --28
         mso.pe_code_id --21
    from ma_asos.ma_system_options mso;

  select muc.uda_id --3023
    from rms.ma_uda_conf muc
   where muc.uda_type = 'PRICE_ESTABLISHMENT';
   
 --V_CFA_IL_OUTLET_G 
 SELECT "ITEM","LOC","OUTLET_PRICE","RRP"
	 FROM (SELECT ITEM, LOC, NUMBER_12 OUTLET_PRICE, NUMBER_11 RRP
				from ITEM_LOC_CFA_EXT
			  where group_id = 110200 and item  in ('100295652','100302542','100302544','100302636','100302641'));

 select * from ITEM_LOC_CFA_EXT where group_id = '110200' and ;
 
  --V_CFA_ITM_ATT_G
  SELECT "ITEM","LOC","AVAILABLE_SELL_DATE","GOLIVE_DATE","ON_QUERY","PRICING_METHOD"
	 FROM (SELECT ITEM,
					  LOC,
					  DATE_21    AVAILABLE_SELL_DATE,
					  DATE_22   GOLIVE_DATE,
					  VARCHAR2_1 ON_QUERY,
					  NUMBER_11  PRICING_METHOD
				from ITEM_LOC_CFA_EXT
			  where group_id = 110100  and item  in ('100197744','100197745','100197930','100198034','100198035'));            
              

  --V_CFA_ITM_OUTLET_G
  SELECT "ITEM","OUTLET_PRICE_EFFECTIVE_DATE"
	 FROM (SELECT ITEM, DATE_21 OUTLET_PRICE_EFFECTIVE_DATE
				from ITEM_MASTER_CFA_EXT
			  where group_id = 10200 and item  in (select item from item_master where item in ('100197744','100197745','100197930','100198034','100198035')
              or item_parent in ('100197744','100197745','100197930','100198034','100198035')));


SELECT ITEM, DATE_21 OUTLET_PRICE_EFFECTIVE_DATE
				from ITEM_MASTER_CFA_EXT
			  where group_id = '10200' and DATE_21 =(select (sysdate-22)+28 from dual);
              
              select sysdate-22 from dual;
              
--ma_v_uda_item_lov  
select item,
       uda_id,
       uda_value,
       create_datetime,
       last_update_datetime,
       last_update_id,
       create_id
  from uda_item_lov where  item ='100013858';
          
            
            
set serveroutput on;
set timing on;

DECLARE
  c_commit  	        NUMBER(5)                     := 100;
l_dept				rms.DEPS.dept%type;
l_item				rms.ITEM_LOC_CFA_EXT.item%type;
l_loc				rms.ITEM_LOC_CFA_EXT.loc%type;
l_golive_date		rms.ITEM_LOC_CFA_EXT.date_22%type;
l_date		        rms.ITEM_LOC_CFA_EXT.date_22%type;

cursor c_dept is 
		SELECT distinct DRIVER_VALUE
				  FROM rms.v_restart_dept
				 WHERE driver_name = 'DEPT';

cursor c_outlet (l_dept rms.DEPS.dept%type)is
 select item from 
            (select distinct item from rms.item_master im where im.dept = l_dept and item_level in ('1') and im.status ='A'
           --  and item  in ('100012640','100018165','100018446','100018523','100020913'));
                    and exists (select 1 from rms.ITEM_LOC_CFA_EXT ile where ile.group_id = '110100' and ile.item =im.item)
                    and exists (select 1 from rms.ITEM_LOC_CFA_EXT ile2 where ile2.group_id = '110200' 
                            and ile2.item =im.item and ile2.NUMBER_12 is not null)
                    and exists (select 1 from rms.ITEM_MASTER_CFA_EXT imc where imc.group_id = '10200' and imc.item =im.item and imc.DATE_21 is null)
                                    )  where rownum<=10;
                                   
                                 

Begin

dbms_output.put_line('Start time:'||SYSTIMESTAMP);

    select vdate-27 into l_date from rms.period;

for k in c_dept loop
  l_dept := k.DRIVER_VALUE;

  for i in c_outlet(l_dept) loop
  
  l_item:=i.item;
  
  
   Update rms.uda_item_lov set uda_value ='1'  where uda_id ='3023' and uda_value != '1'
		and item in  (select item from rms.item_master im where im.item =l_item or im.item_parent =l_item );
	
   
	 Update rms.ITEM_LOC_CFA_EXT set DATE_22 = l_date where item in 
        (select item from rms.item_master im where im.item =l_item or im.item_parent =l_item ) and group_id = '110100';
        
  
       insert into nb_outlet_items values (l_item);


   c_commit :=c_commit + 1;
       IF MOD(c_commit, 5) = 0 THEN
        COMMIT;
       END IF;
 
  
 end loop; 
 end loop;  
 commit;
      dbms_output.put_line('End time:'||SYSTIMESTAMP);
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/

truncate table nb_outlet_items;

select im.dept,count(1) from item_master im, nb_outlet_items nri where im.item =nri.item group by dept;
select item from nb_outlet_items;
select count(1)*13 from nb_outlet_items;
select count(1) from nb_outlet_items;

--create table nb_outlet_items (item varchar2(25));
     
 select mvil.item                               item,
         mvil.loc                                location,
         mvrz.zone_group_id                      zone_group_id,
         mvrz.zone_id                            zone_id,
         mvrz.currency_code                      currency_code,
         (select min(vcia.GOLIVE_DATE) + 28
            from ma_asos.V_CFA_ITM_ATT_G vcia
           where vcia.item = mvil.item
             and vcia.GOLIVE_DATE is not null)   effective_date
    from ma_asos.ma_v_item_master       mvim,
         ma_asos.ma_v_item_loc          mvil,
         ma_asos.v_cfa_itm_outlet_g     vcio,
         ma_asos.v_cfa_il_outlet_g      vcilo,
         ma_asos.ma_system_options      mso,
         ma_asos.ma_v_rpm_zone          mvrz,
         ma_asos.ma_v_rpm_zone_location mvrzl,
         ma_asos.ma_v_pricing_stores    mvps
   where mvim.item_level                        < mvim.tran_level
     and mvim.status                            = 'A'
     and mvil.item                              = mvim.item
     and mvil.loc                               = mvps.store
     and vcio.item                              = mvim.item
     and vcio.outlet_price_effective_date      is null
     and vcilo.item                             = mvil.item
     and vcilo.loc                              = mvil.loc
     and vcilo.outlet_price                    is not null
     --and mvim.item in  ('100197744','100197745','100197930','100198034','100198035')
      --and MOD(ABS(mvps.store),I_num_threads) + 1 = I_thread_val
     and mvrzl.location                         = mvil.loc
     and mvrz.zone_group_id                     = mso.prim_zone_group_id
     and mvrz.zone_id                           = mvrzl.zone_id
     and exists (select 1
                   from V_CFA_ITM_ATT_G vcia
                  where vcia.item         = mvim.item
                    and vcia.golive_date is not null
                    and rownum            < 2)
     and exists (select 1
                   from ma_asos.ma_v_uda_item_lov lv
                  where lv.uda_id    = 3023
                    and lv.item      = mvim.item
                    and lv.uda_value = 1
                    and rownum       < 2)
     and exists (select 1
                   from rpm_item_loc     ril,
                        ma_asos.ma_v_item_master im
                  where ril.item       = im.item
                    and ril.loc        = mvil.loc
                    and im.item_parent = mvil.item
                    and im.status      = 'A'
                    and rownum         < 2)
   order by mvil.item,
            mvil.loc;
            
            
            
select * from ma_asos.ma_reprice_process_control;
            
            
            select item from nb_outlet_items;
            
            
    -- REMOVE ITEMS FROM CURSOR    
SELECT ITEM,LOC,DATE_22 FROM rms.ITEM_LOC_CFA_EXT where item in (select item from nb_outlet_items)
    and group_id = '110100';

select count(1) from nb_outlet_items;

DROP TABLE OUTLET_DEL;        
    CREATE TABLE OUTLET_DEL AS select item from nb_outlet_items WHERE ROWNUM <= '4798';

begin
UPDATE rms.ITEM_LOC_CFA_EXT  SET DATE_22 = '29-FEB-20' where item in (select item from OUTLET_DEL)
         and group_id = '110100';
DELETE FROM nb_outlet_items WHERE item in (select item from OUTLET_DEL);
commit;
end;
/
