select count(1) from rms.ITEMLOC_MFQUEUE;

select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL 
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('a2vm8cv6wj548')
and s.snap_id = SQL.snap_id
and s.begin_interval_time> TO_date('12-feb-2024 09:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time< TO_date('12-feb-2024 19:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;


select * from rms.brand where brand_name in ('BEAUUT','BOLONGARO','BOLONGARO TREVOR SPORT','BRAVE S PE','BRAVE S PL','BRAVE SOUL','DONTTT',
'DONTTT MAT','DONTTT PET','DONTTT PLU','DONTTT TAL','FRENCH CON','TB CURVE','TB FITNESS','TB MATERNI','TB PETITE','TB TALL','TBFITNESSC','TBFITNESSM','TBFITNESSP','TBFITNESST',
'THREADBARE','THREADBARE PLUS FITNESS','TRUFFLE');


select im.BRAND_NAME,b.brand_description, count(1) from rms.item_master im, rms.brand b 
    where im.brand_name = b.BRAND_NAME and b.brand_name in ('BEAUUT','BOLONGARO','BOLONGARO TREVOR SPORT','BRAVE S PE','BRAVE S PL','BRAVE SOUL','DONTTT',
'DONTTT MAT','DONTTT PET','DONTTT PLU','DONTTT TAL','FRENCH CON','TB CURVE','TB FITNESS','TB MATERNI','TB PETITE','TB TALL','TBFITNESSC','TBFITNESSM','TBFITNESSP','TBFITNESST',
'THREADBARE','THREADBARE PLUS FITNESS','TRUFFLE') and im.item_level = '2' group by im.BRAND_NAME,b.brand_description order by 1; 


-- DROP TABLE nb_outlet_phaseout;
CREATE TABLE nb_outlet_phaseout
(
  PARAMETER_TYPE  VARCHAR2(50),
  PARAMETER_VALUE VARCHAR2(30),
  ENABLED         VARCHAR2(1)     
);

select * from nb_outlet_phaseout;
delete from nb_outlet_phaseout where PARAMETER_TYPE ='BRAND_NAME';

--insert into nb_outlet_phaseout select 'BRAND_NAME',BRAND_NAME,'Y' from rms.brand  where brand_description in (select brand from brandname);

insert into nb_outlet_phaseout values ('BRAND_NAME','BEAUUT','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','BOLONGARO','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','BOLONGARO TREVOR SPORT','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','BRAVE S PE','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','BRAVE S PL','Y');

--2
delete from nb_outlet_phaseout where PARAMETER_TYPE ='BRAND_NAME';
insert into nb_outlet_phaseout values ('BRAND_NAME','BRAVE SOUL','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT MAT','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT PET','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT PLU','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT TAL','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','FRENCH CON','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TB CURVE','Y');

3
delete from nb_outlet_phaseout where PARAMETER_TYPE ='BRAND_NAME';
insert into nb_outlet_phaseout values ('BRAND_NAME','TB FITNESS','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TB MATERNI','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TB PETITE','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TB TALL','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESSC','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESSM','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESSP','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESST','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','THREADBARE','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','THREADBARE PLUS FITNESS','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TRUFFLE','Y');


/**************
--insert brand values into param table
************/

Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20000','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20001','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20002','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20003','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20004','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20005','Y'); 
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20006','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20007','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20008','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20009','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20010','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20011','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20012','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20013','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20014','Y');
Insert into NB_OUTLET_PHASEOUT (PARAMETER_TYPE,PARAMETER_VALUE,ENABLED) values ('PRICING_STORE','20015','Y');

commit;



set serveroutput on
DECLARE

 CURSOR C_get_cfa_data 
     IS
 SELECT item,
        loc 
  FROM  rms.item_loc_cfa_ext il 
 WHERE  group_id='110200' 
   AND NUMBER_11 is not null
   AND loc IN ( SELECT TO_NUMBER(PARAMETER_VALUE)
                  FROM skumar.nb_outlet_phaseout
                 WHERE PARAMETER_TYPE = 'PRICING_STORE'
                   AND ENABLED = 'Y'				 
			  ) 
   AND EXISTS ( SELECT 1 from
                 ( SELECT item 
				     FROM item_master a 
					WHERE brand_name in ( SELECT PARAMETER_VALUE
                                            FROM skumar.nb_outlet_phaseout
                                           WHERE PARAMETER_TYPE = 'BRAND_NAME'
                                             AND ENABLED = 'Y'
									    ) 
					  AND item_level<=tran_level
                      AND EXISTS ( SELECT 1 
					                 FROM rms.uda_item_ff b
                                    WHERE uda_id=2010 
									  AND uda_text in ('23','37')
                                      AND a.item=b.item 
                                  )
		          ) a
                WHERE il.item = a.item
               );

 TYPE l_item_loc_type IS TABLE OF C_get_cfa_data%ROWTYPE;

 l_item_loc_tbl l_item_loc_type;  

BEGIN

 OPEN C_get_cfa_data;
 
 LOOP
 
  FETCH C_get_cfa_data BULK COLLECT INTO l_item_loc_tbl LIMIT 1000;
  
  EXIT WHEN l_item_loc_tbl.COUNT = 0;
  
  FORALL indx IN 1..l_item_loc_tbl.COUNT
  UPDATE rms.item_loc_cfa_ext
     SET number_11 = null
   WHERE group_id='110200'
     AND item = l_item_loc_tbl(indx).item
     AND loc = l_item_loc_tbl(indx).loc;

    insert into skumar.processed_itemloc values (l_item_loc_tbl(indx).item,systimestamp,'P',null,l_item_loc_tbl(indx).loc);
    
  COMMIT;	 
 
 END LOOP;
 
EXCEPTION

 WHEN OTHERS THEN

  DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);


END;
/



/* 

select count(1) from rms.ITEMLOC_MFQUEUE;
select count(im.item) from  rms.item_master im, rms.brand b where im.brand_name = b.BRAND_NAME and b.brand_name in ('BEAUUT','BOLONGARO','BOLONGARO TREVOR SPORT','BRAVE S PE','BRAVE S PL','BRAVE SOUL','DONTTT', 'DONTTT MAT','DONTTT PET','DONTTT PLU','DONTTTTAL','FRENCH CON','TB CURVE','TB FITNESS','TB MATERNI','TB PETITE','TB TALL','TBFITNESSC','TBFITNESSM','TBFITNESSP','TBFITNESST', 'THREADBARE','THREADBARE PLUS FITNESS','TRUFFLE') 
            and im.item_level = '1'  and not exists (select 1 from skumar.processed_itemloc pi where pi.item_parent = im.item);


select count(1) from rms.ITEMLOC_MFQUEUE;

select count(1) from processed_itemloc;

delete from processed_itemloc;
select * from processed_itemloc;
select * from item_master;

MERGE INTO processed_itemloc D
   USING (SELECT item,item_parent FROM item_master) S
   ON (D.item= S.item)
   WHEN MATCHED THEN UPDATE SET d.ITEM_PARENT =s.ITEM_PARENT;
     

select count(1) from rms.ITEMLOC_MFQUEUE;
select * from rms.rib_message_failure order by 1 desc;


select count(im.item) from  rms.item_master im, rms.brand b where im.brand_name = b.BRAND_NAME and b.brand_name in ('BEAUUT','BOLONGARO','BOLONGARO TREVOR SPORT','BRAVE S PE','BRAVE S PL','BRAVE SOUL','DONTTT', 'DONTTT MAT','DONTTT PET','DONTTT PLU','DONTTTTAL','FRENCH CON','TB CURVE','TB FITNESS','TB MATERNI','TB PETITE','TB TALL','TBFITNESSC','TBFITNESSM','TBFITNESSP','TBFITNESST', 'THREADBARE','THREADBARE PLUS FITNESS','TRUFFLE') 
            and im.item_level = '1'  and not exists (select 1 from skumar.processed_itemloc pi where pi.item_parent = im.item);


ALTER TABLE processed_itemloc 
ADD item_parent varchar2(25);

ALTER TABLE processed_itemloc 
ADD loc NUMBER(10);
select * from store;
desc store;
set serveroutput on
set timing on

DECLARE

  c_commit              NUMBER(10)                    := 0;
  l_item                rms.ITEM_MASTER.ITEM%TYPE ;
  l_item_parent         rms.ITEM_MASTER.ITEM%TYPE ;

Cursor c_get_item_parent is
 select im.item  from  rms.item_master im, rms.brand b where im.brand_name = b.BRAND_NAME and b.brand_name in ('BEAUUT','BOLONGARO','BOLONGARO TREVOR SPORT','BRAVE S PE','BRAVE S PL','BRAVE SOUL','DONTTT', 'DONTTT MAT','DONTTT PET','DONTTT PLU','DONTTTTAL','FRENCH CON','TB CURVE','TB FITNESS','TB MATERNI','TB PETITE','TB TALL','TBFITNESSC','TBFITNESSM','TBFITNESSP','TBFITNESST', 'THREADBARE','THREADBARE PLUS FITNESS','TRUFFLE')
            and im.item_level = '1' and not exists (select 1 from skumar.processed_itemloc pi where pi.item_parent = im.item);

    Cursor C_get_item (l_item_parent      rms.ITEM_MASTER.ITEM%TYPE) is
        select item from rms.ITEM_MASTER where  item_level=tran_level and item =l_item_parent or item_parent =l_item_parent order by 1 ;


Begin    
 
 
 for k in c_get_item_parent
 loop
    l_item_parent := k.item;
      
  for   c1 in C_get_item(l_item_parent)
  loop
     L_item        := c1.item;

 INSERT  INTO rms.ITEMLOC_MFQUEUE
   (SEQ_NO,
    ITEM,
    LOC,
    LOC_TYPE,
    PHYSICAL_LOC,
    LOCAL_ITEM_DESC,
    LOCAL_SHORT_DESC,
    STATUS,
    PRIMARY_SUPP,
    PRIMARY_CNTRY,
    RECEIVE_AS_TYPE,
    TAXABLE_IND,
    SOURCE_METHOD,
    SOURCE_WH,
    PRIMARY_REPL_SUPPLIER,
    REPL_METHOD,
    REJECT_STORE_ORDER_IND,
    NEXT_DELIVERY_DATE,
    MESSAGE_TYPE,
    THREAD_NO,
    FAMILY,
    CUSTOM_MESSAGE_TYPE,
    PUB_STATUS,
    TRANSACTION_TIME_STAMP,
    STORE_PRICE_IND,
    UNIT_RETAIL,
    SELLING_UNIT_RETAIL,
    SELLING_UOM,
    MULT_RUNS_PER_DAY_IND,
    UIN_TYPE,
    UIN_LABEL,
    CAPTURE_TIME,
    EXT_UIN_IND,
    RANGED_IND,
    RETURNABLE_IND)
      WITH itl AS   (SELECT rms.ITEM_MASTER.item AS item,
                      item_loc.loc  AS loc,
                      loc.physical_loc             AS physical_loc,
                      item_loc.loc_type            AS loc_type,
                      item_loc.local_item_desc     AS local_item_desc,
                      item_loc.local_short_desc    AS local_short_desc,
                      item_loc.status              AS status,
                      item_loc.primary_supp        AS primary_supp,
                      item_loc.primary_cntry       AS primary_cntry,
                      item_loc.receive_as_type     AS receive_as_type,
                      item_loc.taxable_ind         AS taxable_ind,
                      item_loc.source_method       AS source_method,
                      item_loc.source_wh           AS source_wh,
                      item_loc.store_price_ind     AS store_price_ind,
                      item_loc.unit_retail         AS unit_retail,
                      item_loc.selling_unit_retail AS selling_unit_retail,
                      item_loc.selling_uom         AS selling_uom,
                      item_loc.uin_type            AS uin_type,
                      item_loc.uin_label           AS uin_label,
                      rms.item_loc.capture_time        AS capture_time,
                      rms.item_loc.ext_uin_ind         AS ext_uin_ind,
                      rms.item_loc.ranged_ind          AS ranged_ind,
                      mod(rms.ITEM_MASTER.item, rib_settings.num_threads)+ 1 AS thread_no
                      FROM rms.ITEM_MASTER
                         CROSS JOIN rms.rib_settings
                            INNER JOIN rms.item_loc
                                    ON rms.ITEM_MASTER.item  = rms.item_loc.item
                                   INNER JOIN ( SELECT wh.physical_wh AS physical_loc,
                                                    wh.wh AS loc
                                             FROM rms.wh
                                             WHERE wh.physical_wh <> wh.wh
                                             UNION ALL
                                             SELECT STORE.STORE AS physical_loc,
                                                   STORE.STORE AS loc
                                             FROM rms.STORE) loc
            ON    rms.item_loc.loc = loc.loc      
                 WHERE rms.ITEM_MASTER.item_level = rms.ITEM_MASTER.tran_level
                   AND rib_settings.family = 'itemloc'
                   and rms.ITEM_MASTER.item=L_item)
   SELECT  rms.ITEMLOC_MFSEQUENCE.NextVal SEQ_NO,
    ITL.ITEM ITEM,
    ITL.LOC LOC,
    ITL.LOC_TYPE LOC_TYPE,
    ITL.PHYSICAL_LOC PHYSICAL_LOC,
    ITL.LOCAL_ITEM_DESC LOCAL_ITEM_DESC,
    ITL.LOCAL_SHORT_DESC LOCAL_SHORT_DESC,
    ITL.STATUS STATUS,
    ITL.PRIMARY_SUPP PRIMARY_SUPP,
    ITL.PRIMARY_CNTRY PRIMARY_CNTRY,
    ITL.RECEIVE_AS_TYPE RECEIVE_AS_TYPE,
    ITL.TAXABLE_IND TAXABLE_IND,
    ITL.SOURCE_METHOD SOURCE_METHOD,
    ITL.SOURCE_WH SOURCE_WH,
    NULL PRIMARY_REPL_SUPPLIER,
    NULL REPL_METHOD,
    NULL REJECT_STORE_ORDER_IND,
    NULL NEXT_DELIVERY_DATE,
    'ItemLocCre' MESSAGE_TYPE,
    ITL.THREAD_NO THREAD_NO,
    'ItemLoc' FAMILY,
    'N' CUSTOM_MESSAGE_TYPE,
    'U' PUB_STATUS,
    SYSDATE TRANSACTION_TIME_STAMP,
    ITL.STORE_PRICE_IND STORE_PRICE_IND,
    ITL.UNIT_RETAIL UNIT_RETAIL,
    ITL.SELLING_UNIT_RETAIL SELLING_UNIT_RETAIL,
    SELLING_UOM SELLING_UOM,
    'N' MULT_RUNS_PER_DAY_IND,
    ITL.UIN_TYPE UIN_TYPE,
    ITL.UIN_LABEL UIN_LABEL,
    ITL.CAPTURE_TIME CAPTURE_TIME,
    ITL.EXT_UIN_IND EXT_UIN_IND,
    ITL.RANGED_IND RANGED_IND,
    NULL RETURNABLE_IND
    FROM ITL;

end loop;
 
  c_commit :=c_commit + 1;
       IF MOD(c_commit, 10) = 0 THEN
       commit;
        continue;
       END IF;

    insert into skumar.processed_itemloc values (l_item,systimestamp,'P',l_item_parent);

end loop;
commit;
      

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

*/