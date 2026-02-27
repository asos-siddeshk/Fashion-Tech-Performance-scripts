select count(1) from ma_asos.ma_reprice_process_control; --758671

    delete from ma_asos.ma_pricing_rules_method where brand_name ='TWISTED TA';
    delete from ma_asos.ma_pricing_rules_def where rules_method_id in (select id from ma_asos.ma_pricing_rules_method where brand_name ='TWISTED TA');

select * from ma_asos.ma_reprice_process_control; --758671
select EFFECTIVE_DATE,location,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE,location order by 1;   

select state,count(1) from rms.rpm_price_change where EFFECTIVE_DATE between '05-AUG-22' and '12-AUG-22' group by state; -- 5008
pricechange.state.approved	65273
pricechange.state.worksheet	39
pricechange.state.executed	46321

Update ma_asos.MA_PRICE_EVENT_THRESHOLD set PRICE_CHANGE_LOCS='25000';
select * from ma_asos.MA_PRICE_EVENT_THRESHOLD;

select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change group by EFFECTIVE_DATE order by 1;   
select  STATUS,count(1) from rms.rpm_stage_price_change group by STATUS; -- 3000


select im.item_level,count(1) from item_master im  where im.item in (select item from ma_asos.ma_stage_price_change) group by item_level;
select im.item_level,count(1) from item_master im  where im.item =nri.item group by item_level;

begin
delete rpm_stage_item_loc_clean; 
delete rpm_stage_item_loc; 
delete from ma_asos.ma_stage_clearance;
delete from ma_asos.ma_stage_simple_promo;
commit;
end;
/

UI Screen Conversion Factor change -- for Zone

MA_PRICING_BATCH_PROCESSES_SQL.CONVERSION_METH_NEW_ZONE
MA_PRICING_BATCH_PROCESSES_SQL.CONVERSION_METH_CHANGED_FACTOR

select *
     from rms_plsql_batch_config
    where program_name = 'NB_REPRICE_PROCESS';

STATUS_PC_WORKSHEET      CONSTANT MA_PRICE_CHANGE.STATUS%TYPE            := 'W';
STATUS_REPRICE_NEW       CONSTANT MA_REPRICE_PROCESS_CONTROL.STATUS%TYPE := 'N';
STATUS_REPRICE_PROCESS   CONSTANT MA_REPRICE_PROCESS_CONTROL.STATUS%TYPE := 'P';
STATUS_REPRICE_REPROCESS CONSTANT MA_REPRICE_PROCESS_CONTROL.STATUS%TYPE := 'R';
STATUS_REPRICE_ERROR     CONSTANT MA_REPRICE_PROCESS_CONTROL.STATUS%TYPE := 'E';

PROCESS_SINGLE REPRICE_DEL_UNPROCESSED_DATA
PROCESS_MULTI REPRICE_GENERATE_DATA
                                
PROCESS_SINGLE REPRICE_UPDATE_ZONE_FLAGS

PROCESS_MULTI REPRICE_MAIN_PROCESS
ma_reprice_process_control


select * from all_views where lower(view_name) like 'v_cfa_itm_att_g';

SELECT "ITEM","LOC","AVAILABLE_SELL_DATE","GOLIVE_DATE","ON_QUERY","PRICING_METHOD"
	 FROM (SELECT ITEM,
					  LOC,
					  DATE_21    AVAILABLE_SELL_DATE,
					  DATE_22    GOLIVE_DATE,
					  VARCHAR2_1 ON_QUERY,
					  NUMBER_11  PRICING_METHOD
				from ITEM_LOC_CFA_EXT
			  where group_id = 110100);

SELECT * FROM ma_asos.ma_pricing_rules_def ;
SELECT * FROM ma_asos.ma_pricing_methods ;
SELECT * FROM ma_asos.ma_pricing_rules_def;

update  ma_asos.ma_pricing_rules_def set FACTOR_CHANGE_IND = 'N' where FACTOR_CHANGE_IND = 'Y';
update  ma_asos.ma_pricing_rules_def set NEW_ZONE_IND = 'N' where NEW_ZONE_IND = 'Y';

  SELECT mprd.*
    FROM ma_asos.ma_pricing_rules_method   mprm,
         ma_asos.ma_pricing_rules_def      mprd
   WHERE mprd.rules_method_id   = mprm.id
     AND (   mprd.new_zone_ind      = 'Y'
          OR mprd.factor_change_ind = 'Y');

  SELECT mprd.*
    FROM ma_asos.ma_pricing_rules_method   mprm,
         ma_asos.ma_pricing_rules_def      mprd
   WHERE mprd.rules_method_id   = mprm.id
     AND (   mprd.new_zone_ind      = 'Y'
          OR mprd.factor_change_ind = 'Y');


2	112


 SELECT mprm.*
    FROM ma_asos.ma_pricing_rules_method   mprm,
         ma_asos.ma_pricing_rules_def      mprd,
         ma_asos.ma_v_rpm_zone_location    mrzl,
         ma_asos.ma_v_pricing_stores       mps
   WHERE mprd.rules_method_id   = mprm.id
     AND (   mprd.new_zone_ind      = 'Y'
          OR mprd.factor_change_ind = 'Y')
     AND mrzl.zone_id           = mprd.zone_id
     --AND mrzl.loc_type          = 'S'
     AND mps.store              = mrzl.location;
     
     
   SELECT /*+ MATERIALIZE */ d.dept
      FROM deps d
     WHERE MOD(ABS(d.dept),16) + 1 = 1;
 
    select * from ma_asos.ma_pricing_rules_method where brand_name ='TWISTED TA';
    select * from ma_asos.ma_pricing_rules_def where rules_method_id in (select id from ma_asos.ma_pricing_rules_method where brand_name ='TWISTED TA');
    
    select * from all_constraints where constraint_name like 'FK_MA_PRICING_RULES_METHOD';
    
    
    
    
          
WITH
  C_dept AS
  (
    SELECT /*+ MATERIALIZE */ d.dept
      FROM deps d
     WHERE dept ='1008'
  ),
  C_zone AS
  (
    SELECT /*+ MATERIALIZE */ mprm.zone_group_id,
           mprd.zone_id,
           mrz.currency_code,
           mprd.conversion_factor,
           mrzl.location,
           mprd.new_zone_ind,
           mprd.factor_change_ind
      FROM ma_asos.ma_pricing_rules_method   mprm,
           ma_asos.ma_pricing_rules_def      mprd,
           ma_asos.ma_v_rpm_zone             mrz,
           ma_asos.ma_v_rpm_zone_location    mrzl,
           ma_asos.ma_v_pricing_stores       mps
     WHERE mprm.pricing_method_id = '3'
       AND mprd.rules_method_id   = mprm.id
       AND (   mprd.new_zone_ind      = 'Y'
            OR mprd.factor_change_ind = 'Y')
       AND mrz.zone_id            = mprd.zone_id
       AND mrzl.zone_id           = mprd.zone_id
       AND mrzl.loc_type          = '0'
       AND mrzl.location          = mps.store
  ),
  C_options as
  (
    SELECT il.item,
           il.loc,
           cz.zone_group_id,
           cz.zone_id,
           cz.currency_code,
           cz.conversion_factor,
           cz.new_zone_ind,
           cz.factor_change_ind
      FROM C_dept          cd,
           item_master     im,
           C_zone          cz,
           item_loc        il,
           ma_asos.v_cfa_itm_att_g vcia
     WHERE im.item_level       < im.tran_level
       AND il.item             = im.item
       AND il.loc_type         = 'S'
       AND il.status           = 'A'
       AND vcia.item           = il.item
       AND vcia.loc            = il.loc
       --AND vcia.loc            = cz.location
       AND vcia.pricing_method = '3'
       AND cd.dept             = im.dept
       AND cz.location         = il.loc
       AND EXISTS (SELECT 1
                     FROM rpm_item_loc ril
                    WHERE ril.item IN (SELECT isku.item
                                         FROM item_master isku
                                        WHERE isku.item_parent = il.item)
                      AND ril.loc  = il.loc
                      AND ril.dept = im.dept
                      AND ROWNUM   < 2)
  )
  /* OPTIONS */
  SELECT co.zone_group_id,
         co.zone_id,
         co.currency_code,
         co.conversion_factor,
         co.loc location,
         co.item,
         co.new_zone_ind,
         co.factor_change_ind
    FROM C_options co
    UNION ALL
  /* SKU EXCEPTIONS */
  SELECT opt.zone_group_id,
         opt.zone_id,
         opt.currency_code,
         opt.conversion_factor,
         opt.loc location,
         opt.item,
         opt.new_zone_ind,
         opt.factor_change_ind
    FROM (SELECT il.item,
                 il.loc,
                 cz.zone_group_id,
                 cz.zone_id,
                 cz.currency_code,
                 cz.conversion_factor,
                 cz.new_zone_ind,
                 cz.factor_change_ind
            FROM C_dept          cd,
                 item_master     im,
                 C_zone          cz,
                 item_loc        il,
                 v_cfa_itm_att_g vcia
           WHERE im.item_level       = im.tran_level
             AND il.item             = im.item
             AND il.loc_type         = 'S'
             AND il.status           = 'A'
             AND vcia.item           = il.item
             AND vcia.loc            = il.loc
             and vcia.loc            = cz.location
             AND vcia.pricing_method = '3'
             AND cd.dept             = im.dept
             AND cz.location         = il.loc
             AND EXISTS (SELECT 1
                           FROM rpm_item_loc ril
                          WHERE ril.item = il.item
                            AND ril.loc  = il.loc
                            AND ril.dept = im.dept
                            AND ROWNUM   < 2)
             AND NOT EXISTS (SELECT /*+ NO_UNNEST */ 1
                               FROM C_options op
                              WHERE op.item = im.item_parent
                                AND op.loc  = il.loc)) opt;
                                

              
select * from ma_asos.ma_pricing_rules_def where RULES_METHOD_ID='2' and FACTOR_CHANGE_IND ='Y';
Update ma_asos.ma_pricing_rules_def set FACTOR_CHANGE_IND ='N' where RULES_METHOD_ID='2' and FACTOR_CHANGE_IND ='Y';


Update ma_asos.ma_pricing_rules_def 
set CONVERSION_FACTOR = CONVERSION_FACTOR+'1',
	factor_change_ind = 'Y'
where RULES_METHOD_ID ='2' and rownum<='1' and zone_id between 99 and 105;

SELECT /*+ MATERIALIZE */ mprm.zone_group_id,
           mprd.zone_id,
           mrz.currency_code,
           mprd.conversion_factor,
           mrzl.location,
           mprd.new_zone_ind,
           mprd.factor_change_ind
      FROM ma_asos.ma_pricing_rules_method   mprm,
           ma_asos.ma_pricing_rules_def      mprd,
           ma_asos.ma_v_rpm_zone             mrz,
           ma_asos.ma_v_rpm_zone_location    mrzl,
           ma_asos.ma_v_pricing_stores       mps
     WHERE  mprd.rules_method_id   = mprm.id
       AND (   mprd.new_zone_ind      = 'Y'
            OR mprd.factor_change_ind = 'Y')
       AND mrz.zone_id            = mprd.zone_id
       AND mrzl.zone_id           = mprd.zone_id
       AND mrzl.loc_type          = '0'
       AND mrzl.location          = mps.store;


         select item from 
            (select distinct item from rms.item_master im where dept = l_dept and item_level in ('1') and im.status ='A' and im.CREATE_ID = 'ORACNV'
                    and exists (select 1 from rms.ITEM_LOC_CFA_EXT ile where ile.group_id = l_group_id and ile.loc  = '20013'
                                    and ile.item =im.item)
                    and item not in  (select item from skumar.nb_reprice_items where dept = l_dept)) 
                                where rownum<=100;

SELECT * from item_master_op;

	SELECT distinct item
				  FROM skumar.item_master_op op
				 WHERE not exists (select 1 from skumar.nb_reprice_items ni where ni.item = op.item);-- AND DRIVER_VALUE = '1003';

-- Reprice 
select count(1) from ma_asos.ma_reprice_process_control; --508680
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_price_change where status ='N' group by EFFECTIVE_DATE order by 1;   

select * from ma_asos.ma_stage_price_change op where EFFECTIVE_DATE <='11-MAR-20'
 and exists (select 1 from skumar.nb_reprice_items ni where ni.item = op.item);;   




select  * from nb_reprice_items; --437878
select count(1) from nb_reprice_items; --437878

set serveroutput on;
set timing on;

DECLARE
c_commit  	        NUMBER(5)                     := 100;
l_dept				rms.DEPS.dept%type;
l_item				rms.ITEM_LOC_CFA_EXT.item%type;
l_loc				rms.ITEM_LOC_CFA_EXT.loc%type  := '20014';
l_golive_date		rms.ITEM_LOC_CFA_EXT.date_22%type;
l_date		        rms.ITEM_LOC_CFA_EXT.date_22%type;
l_group_id		        rms.ITEM_LOC_CFA_EXT.group_id%type := '110100';


cursor c_price is
         select item from 
            (select distinct item from skumar.item_master_op im where 
                    exists (select 1 from rms.ITEM_LOC_CFA_EXT ile where ile.group_id = l_group_id and ile.loc  = l_loc and ile.item =im.item)
                    and item not in (select distinct item from skumar.nb_reprice_items nri where nri.item= im.item)) 
                    where rownum<=122;

Begin

dbms_output.put_line('Start time:'||SYSTIMESTAMP);

for m in 0..0  loop
  for i in c_price  loop
  l_item:=i.item;
  
Update rms.ITEM_LOC_CFA_EXT ilce 
	set ilce.NUMBER_11 ='2' 
	where ilce.group_id = l_group_id and ilce.loc  = l_loc and (ilce.NUMBER_11 != '3' or ilce.NUMBER_11 is null)
     and ilce.item = l_item;

    insert into nb_reprice_items values (l_item);
    
    end loop; 
 end loop;  
      dbms_output.put_line('End time:'||SYSTIMESTAMP);
   --commit;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/


set serveroutput on;
set timing on;

DECLARE
c_commit  	        NUMBER(5)                     := 100;
l_dept				rms.DEPS.dept%type;
l_item				rms.ITEM_LOC_CFA_EXT.item%type;
l_loc				rms.ITEM_LOC_CFA_EXT.loc%type  := '20014';
l_golive_date		rms.ITEM_LOC_CFA_EXT.date_22%type;
l_date		        rms.ITEM_LOC_CFA_EXT.date_22%type;
l_group_id		        rms.ITEM_LOC_CFA_EXT.group_id%type := '110100';


cursor c_dept is 
		SELECT distinct dept
				  FROM skumar.item_master_op op
				 WHERE not exists (select 1 from skumar.nb_reprice_items ni where ni.item = op.item);-- AND DRIVER_VALUE = '1003';

cursor c_price (l_dept rms.DEPS.dept%type)is
         select item from 
            (select distinct item from skumar.item_master_op im where dept = l_dept --and item_level in ('1') and im.status ='A' and im.CREATE_ID = 'ORACNV'
                    and exists (select 1 from rms.ITEM_LOC_CFA_EXT ile where ile.group_id = l_group_id and ile.loc  = l_loc and ile.item =im.item)
                    and item not in (select distinct item from skumar.nb_reprice_items where dept = l_dept)) 
                    where rownum<=1000;

Begin

dbms_output.put_line('Start time:'||SYSTIMESTAMP);

for m in 0..0  loop
for k in c_dept loop
  l_dept := k.dept;

  for i in c_price(l_dept) loop
  
  l_item:=i.item;
  
  
Update rms.ITEM_LOC_CFA_EXT ilce 
	set ilce.NUMBER_11 ='3' 
	where ilce.group_id = l_group_id and ilce.loc  = l_loc and (ilce.NUMBER_11 != '3' or ilce.NUMBER_11 is null)
     and ilce.item = l_item;

    insert into nb_reprice_items values (l_item);
    
   c_commit :=c_commit + 1;
       IF MOD(c_commit, 100) = 0 THEN
        COMMIT;
       END IF;
 
  
 end loop; 
 end loop; 
 end loop;  
      dbms_output.put_line('End time:'||SYSTIMESTAMP);
   commit;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/



truncate table nb_reprice_items;

select im.dept,count(1) from item_master im, nb_reprice_items nri where im.item =nri.item group by dept;
select count(1) from nb_reprice_items; --11976
--create table nb_reprice_items (item varchar2(25));

select * from  ITEM_LOC_CFA_EXT ilce 
	where ilce.group_id = '110100' and ilce.loc  = '20013' and ilce.NUMBER_11!='3' 
    and ilce.item in (select item from nb_reprice_items); -- 7957

select count(1) from  ITEM_LOC ilce  where ilce.loc  = '20013' and ilce.item in (select item from nb_reprice_items); -- 7957 --28336
select count(1) from  ITEM_LOC ilce  where ilce.loc  = '20013' and ilce.ITEM_PARENT in (select item from nb_reprice_items); -- 7957 -- 157865
-- pr Zon

          
WITH
  C_dept AS
  (
    SELECT /*+ MATERIALIZE */ d.dept
      FROM deps d
     WHERE dept ='1013'
  ),
  C_zone AS
  (
    SELECT /*+ MATERIALIZE */ mprm.zone_group_id,
           mprd.zone_id,
           mrz.currency_code,
           mprd.conversion_factor,
           mrzl.location,
           mprd.new_zone_ind,
           mprd.factor_change_ind
      FROM ma_asos.ma_pricing_rules_method   mprm,
           ma_asos.ma_pricing_rules_def      mprd,
           ma_asos.ma_v_rpm_zone             mrz,
           ma_asos.ma_v_rpm_zone_location    mrzl,
           ma_asos.ma_v_pricing_stores       mps
     WHERE mprm.pricing_method_id = '3'
       AND mprd.rules_method_id   = mprm.id
       AND (   mprd.new_zone_ind      = 'Y'
            OR mprd.factor_change_ind = 'Y')
       AND mrz.zone_id            = mprd.zone_id
       AND mrzl.zone_id           = mprd.zone_id
       AND mrzl.loc_type          = '0'
       AND mrzl.location          = mps.store
  ),
  C_options as
  (
    SELECT il.item,
           il.loc,
           cz.zone_group_id,
           cz.zone_id,
           cz.currency_code,
           cz.conversion_factor,
           cz.new_zone_ind,
           cz.factor_change_ind
      FROM C_dept          cd,
           item_master     im,
           C_zone          cz,
           item_loc        il,
           ma_asos.v_cfa_itm_att_g vcia
     WHERE im.item_level       < im.tran_level
       AND il.item             = im.item
       AND il.loc_type         = 'S'
       AND il.status           = 'A'
       AND vcia.item           = il.item
       AND vcia.loc            = il.loc
       AND vcia.loc            = cz.location
       AND vcia.pricing_method = '3'
       AND cd.dept             = im.dept
       AND cz.location         = il.loc
       AND EXISTS (SELECT 1
                     FROM rpm_item_loc ril
                    WHERE ril.item IN (SELECT isku.item
                                         FROM item_master isku
                                        WHERE isku.item_parent = il.item)
                      AND ril.loc  = il.loc
                      AND ril.dept = im.dept
                      AND ROWNUM   < 2)
  )
  /* OPTIONS */
  SELECT co.zone_group_id,
         co.zone_id,
         co.currency_code,
         co.conversion_factor,
         co.loc location,
         co.item,
         co.new_zone_ind,
         co.factor_change_ind
    FROM C_options co
    UNION ALL
  /* SKU EXCEPTIONS */
  SELECT opt.zone_group_id,
         opt.zone_id,
         opt.currency_code,
         opt.conversion_factor,
         opt.loc location,
         opt.item,
         opt.new_zone_ind,
         opt.factor_change_ind
    FROM (SELECT il.item,
                 il.loc,
                 cz.zone_group_id,
                 cz.zone_id,
                 cz.currency_code,
                 cz.conversion_factor,
                 cz.new_zone_ind,
                 cz.factor_change_ind
            FROM C_dept          cd,
                 item_master     im,
                 C_zone          cz,
                 item_loc        il,
                 v_cfa_itm_att_g vcia
           WHERE im.item_level       = im.tran_level
             AND il.item             = im.item
             AND il.loc_type         = 'S'
             AND il.status           = 'A'
             AND vcia.item           = il.item
             AND vcia.loc            = il.loc
             and vcia.loc            = cz.location
             AND vcia.pricing_method = '3'
             AND cd.dept             = im.dept
             AND cz.location         = il.loc
             AND EXISTS (SELECT 1
                           FROM rpm_item_loc ril
                          WHERE ril.item = il.item
                            AND ril.loc  = il.loc
                            AND ril.dept = im.dept
                            AND ROWNUM   < 2)
             AND NOT EXISTS (SELECT /*+ NO_UNNEST */ 1
                               FROM C_options op
                              WHERE op.item = im.item_parent
                                AND op.loc  = il.loc)) opt;
                                

select * from ma_asos.ma_pricing_rules_def mprd
   WHERE (   mprd.new_zone_ind         = 'Y'
          OR mprd.factor_change_ind    = 'Y')
     AND EXISTS (SELECT 1
                   FROM ma_asos.ma_pricing_rules_method   mprm
                  WHERE mprm.pricing_method_id = (SELECT mpm.id
                                                    FROM ma_asos.ma_pricing_methods mpm
                                                   WHERE mpm.code_pricing_method = 'CC')
                    AND mprd.rules_method_id   = mprm.id);
                    
                    
                    select * from ma_asos.ma_reprice_process_control;
                    
                    
                    
select il.item,il.loc from nb_reprice_items nb , item_loc il, item_master im where im.item = nb.item and il.item_parent = im.item
    and il.loc ='20006' and il.status!='A';

update item_loc set status='A' where (item,loc) in 
    (select il.item,il.loc from nb_reprice_items nb , item_loc il, item_master im where im.item = nb.item and il.item_parent = im.item
        and il.loc ='20006' and il.status!='A');

update item_loc set status='A' where (item,loc) in 
    (select il.item,il.loc from nb_reprice_items nb , item_loc il, item_master im where im.item = nb.item and il.item_parent = im.item
        and il.loc ='20006' and il.status!='A');


Update rms.ITEM_LOC_CFA_EXT ilce 
	set ilce.NUMBER_11 = '3'
	where ilce.group_id = '110100' and ilce.loc  = '20006' --and ilce.NUMBER_11 ='3' 
    and ilce.item in ( select item from nb_reprice_items);

Update rms.ITEM_LOC_CFA_EXT ilce 
	set ilce.NUMBER_11 = null
	where ilce.group_id = 110100 and ilce.loc  = 20006 --and ilce.NUMBER_11 ='3' 
    and ilce.item in ( select item from nb_reprice_items);
    
select * from ma_asos.ma_reprice_process_control;

select * from  ITEM_LOC_CFA_EXT ilce 
	where ilce.group_id = '110100' and ilce.loc  = '20006'-- and ilce.NUMBER_11 ='3' 
    and ilce.item in ('100301636','100156932','100018629','100513973','100027093','100471621','100010655','100826511'); -- 7957


select * from  ITEM_LOC_CFA_EXT ilce 
	where ilce.group_id = '110100' and ilce.loc  = '20006'-- and ilce.NUMBER_11 ='3' 
    and ilce.item in (select item from nb_reprice_items); -- 7957
    
    
select * from  nb_reprice_items 
	where item not in (select item from ITEM_LOC_CFA_EXT where group_id = '110100' and loc  = '20006' and NUMBER_11 ='3'); -- 7957


set serveroutput on;
set timing on;

DECLARE
l_ITEM              VARCHAR2(25);

CURSOR c_dept is 

select item from  nb_reprice 
	where item not in (select item from ITEM_LOC_CFA_EXT where group_id = '110100' and loc  = '20006'); -- 7957

    
BEGIN
for m in c_dept loop 
    
    l_ITEM :=  m.item;

insert into ITEM_LOC_CFA_EXT
    (ITEM, LOC, GROUP_ID, NUMBER_11,DATE_21, DATE_22)
values			 
    (l_ITEM,'20006','110100','3','15-NOV-18','15-NOV-18');
    

 END LOOP;

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/




select im.item_level,count(1) from item_master im, ITEM_LOC_CFA_EXT nri where im.item =nri.item 
and nri.group_id = '110100'
and nri.NUMBER_11 ='3'
and nri.loc = '20006'
group by item_level;


select im.item_level,count(1) from item_master im, nb_reprice nri where im.item =nri.item group by item_level;


create table nb_reprice (item varchar2(25));
select im.dept,count(1) from item_master im, nb_reprice nri where im.item =nri.item group by dept;
select count(1) from nb_reprice; --11976
(select item from item_master where dept = '');
    
select im.item from item_master im, nb_reprice nri where im.item =nri.item and dept = '1110' ;
select count(im.item) from ma_asos.ma_stage_price_change im2, item_master im where  im.item =im2.item and dept = '1110' ;

select count(1) from  ITEM_LOC ilce  where ilce.loc  = '20006' and ilce.item in (select im.item from item_master im, nb_reprice nri where im.item =nri.item and dept = '1110'); --
select count(1) from  ITEM_LOC ilce  where ilce.loc  = '20006' and ilce.ITEM_PARENT in (select im.item from item_master im, nb_reprice nri where im.item =nri.item and dept = '1110');  --1036


select count(item) from item_master where item in (select item  from nb_reprice);
select count(item) from item_master where item_parent in (select item  from nb_reprice);


select im.item from nb_reprice IM where 
not exists (select 1 from 
ITEM_LOC_CFA_EXT nri where im.item =nri.item 
and nri.group_id = '110100'
and nri.NUMBER_11 ='3'
and nri.loc = '20006');


INSeRT INTO nb_reprice
select ITeM from  item_master_op 
	where item not in (select item from nb_reprice) and ROWNUM <= '50000'; -- 7957


select * FROM ITEM_LOC_CFA_EXT where item IN (select im.item from nb_reprice IM where 
not exists (select 1 from 
ITEM_LOC_CFA_EXT nri where im.item =nri.item 
and nri.group_id = '110100'
and nri.NUMBER_11 ='3'
and nri.loc = '20006') 
and loc = '20006')
ANd NUMBER_11 IS NULL
ANd group_id = '110100';


deLeTe FROM nb_reprice where item IN (100000003,100000004,100000005);

set serveroutput on;
set timing on;

DECLARE
c_commit  	        NUMBER(8)                     := 100;
l_dept				rms.DEPS.dept%type;
l_item				rms.ITEM_LOC_CFA_EXT.item%type;
l_loc				rms.ITEM_LOC_CFA_EXT.loc%type  := '20006';
l_golive_date		rms.ITEM_LOC_CFA_EXT.date_22%type;
l_date		        rms.ITEM_LOC_CFA_EXT.date_22%type;
l_group_id		        rms.ITEM_LOC_CFA_EXT.group_id%type := '110100';


cursor c_price  is
select im.item from nb_reprice IM where 
not exists (select 1 from  ITEM_LOC_CFA_EXT nri where im.item =nri.item 
and nri.group_id = '110100'
and nri.NUMBER_11 ='3'
and nri.loc = '20006');

Begin

dbms_output.put_line('Start time:'||SYSTIMESTAMP);

for i in c_price loop
  l_item:=i.item;
  
MERGE INTO ITEM_LOC_CFA_EXT R
   USING (select '110100' AS group_id,'3' AS NUMBER_11,'20006' AS loc,ITeM  from item_master im where im.item = l_item OR  item_parent = l_item) S
  ON (R.group_id = S.group_id
   and R.loc = S.loc
   and R.item = S.item)
   WHEN MATCHED THEN UPDATE SET R.NUMBER_11 = S.NUMBER_11
   WHEN NOT MATCHED THEN INSERT (R.ITEM, R.LOC, R.GROUP_ID,R.NUMBER_11,R.DATE_21, R.DATE_22)
   VALUES (S.ITEM, S.LOC, S.GROUP_ID,S.NUMBER_11,'07-SEP-16','17-SEP-16')
     ;
--  select count(1) from nb_reprice; --11976

   c_commit :=c_commit + 1;
       IF MOD(c_commit, 10000) = 0 THEN
        COMMIT;
       END IF;
  
 end loop;  
      dbms_output.put_line('End time:'||SYSTIMESTAMP);
   commit;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception block'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/



select * FROM  ALL_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE 'ILE_ITL_FK';
