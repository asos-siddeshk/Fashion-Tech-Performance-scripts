select ACTIVE_DATE,count(1) from cost_susp_sup_head group by ACTIVE_DATE order by ACTIVE_DATE; --26-AUG-18	13500
select vdate-99 from rms.period;
/*
select    (select vdate from rms.period)   as ACTIVE_DATE,
        ITEM, SUPPLIER, ORIGIN_COUNTRY_ID, UNIT_COST          
            from item_supp_country where rownum<='13500';
            
            select * from item_supp_country;
           
   SELECT to_char(period.vdate + 1,'YYYYMMDD'),
               to_char(period.vdate - 1,'YYYYMMDD'),
               retention_of_rejected_cost_chg
          FROM period,
               purge_config_options;
                --20181029	20181027	99

select ACTIVE_DATE,count(1) from cost_susp_sup_head group by ACTIVE_DATE;
select vdate-99 from period;
Update cost_susp_sup_head set status ='D' where ACTIVE_DATE <='22-JUL-18';

 SELECT cssh.cost_change
         FROM cost_susp_sup_head cssh
        WHERE cssh.status in ('D','C','E')
           OR (cssh.status = 'R' AND ((TO_DATE(:ps_tomorrow,'YYYYMMDD') - cssh.active_date)
                                      > :pi_days_reject_held));
                                      
*/

set serveroutput on;
set timing on;

declare

l_COST_CHANGE               rms.cost_susp_sup_head.COST_CHANGE%type;
l_SUPPLIER                  rms.cost_susp_sup_detail.SUPPLIER%type;
l_ORIGIN_COUNTRY_ID         rms.cost_susp_sup_detail.ORIGIN_COUNTRY_ID%type;
l_ITEM                      rms.cost_susp_sup_detail.ITEM%type;
l_UNIT_COST                 rms.cost_susp_sup_detail.UNIT_COST%type;
l_ACTIVE_DATE				rms.cost_susp_sup_head.ACTIVE_DATE%type;

cursor c1 is 
select     RMS.cc_sequence.NEXTVAL         as  COST_CHANGE,           
            (select vdate from rms.period) as ACTIVE_DATE,
            isc.ITEM as item, 
            isc.SUPPLIER as SUPPLIER, 
            isc.ORIGIN_COUNTRY_ID as ORIGIN_COUNTRY_ID, 
            isc.UNIT_COST+5 as UNIT_COST          
    from item_supp_country isc where rownum<='200'
    and not exists(select 1 from cost_susp_sup_detail csd where csd.item = isc.item);


begin
for k in 0..10 loop
for i in c1 loop

l_COST_CHANGE                   :=i.COST_CHANGE;
l_ACTIVE_DATE                   :=i.ACTIVE_DATE-k;
l_ITEM                          :=i.ITEM;
l_SUPPLIER                      :=i.SUPPLIER;
l_ORIGIN_COUNTRY_ID             :=i.ORIGIN_COUNTRY_ID;     
l_UNIT_COST                     :=i.UNIT_COST; 

insert into rms.cost_susp_sup_head(
							 COST_CHANGE ,
							 COST_CHANGE_DESC ,
                             REASON,
                             ACTIVE_DATE,
                             STATUS,
                             COST_CHANGE_ORIGIN,
                             CREATE_DATE,CREATE_ID) 
                     values( l_COST_CHANGE,
                             'XCOSTCHPURG',
                              10,
                              l_ACTIVE_DATE,
                             'R',
                             'SUP',
                             l_ACTIVE_DATE,
                            'PTUSER'); 
  
  insert into rms.cost_susp_sup_detail(
							   COST_CHANGE         ,
                                SUPPLIER            ,
                                ORIGIN_COUNTRY_ID   ,
                                ITEM                ,
                                UNIT_COST           ,
                                RECALC_ORD_IND      ,
                                DEFAULT_BRACKET_IND  )
                         values(
							 l_COST_CHANGE,
							 l_SUPPLIER,
                             l_ORIGIN_COUNTRY_ID,
                              l_ITEM,
                             l_UNIT_COST,
                             'N',
                             'N');                         
  END LOOP;
  END LOOP;
commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/
