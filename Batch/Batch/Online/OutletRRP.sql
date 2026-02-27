/*

    select count(1) from rms.item_loc_cfa_ext where item in (select item from rms.item_master where brand_name = 'BEAUUT') --163468
        and group_id='110200' AND NUMBER_11 is not null;

    select count(1) from rms.item_loc_cfa_ext where item in (select item from rms.item_master where brand_name = 'BEAUUT') --163468
        and group_id='110200' AND NUMBER_11 >= '0';

SELECT count(1) --124185
  FROM  rms.item_loc_cfa_ext il 
 WHERE  group_id='110200' 
   AND NUMBER_11 is not null
   AND loc IN ( SELECT TO_NUMBER(PARAMETER_VALUE)
                  FROM rms.nb_outlet_phaseout
                 WHERE PARAMETER_TYPE = 'PRICING_STORE'
                   AND ENABLED = 'Y') 
   AND EXISTS ( SELECT 1 from
                 ( SELECT item 
				     FROM rms.item_master a 
					WHERE brand_name in ( SELECT PARAMETER_VALUE
                                            FROM rms.nb_outlet_phaseout
                                           WHERE PARAMETER_TYPE = 'BRAND_NAME'
                                             AND ENABLED = 'Y'
									    ) 
					  AND item_level<=tran_level
                      AND EXISTS ( SELECT 1 
					                 FROM rms.uda_item_ff b
                                    WHERE uda_id='2010'
									  AND uda_text in ('23','37')
                                      AND a.item=b.item 
                                  )
		          ) a
                WHERE il.item = a.item
               );


select item_level,count(1) from rms.item_master where item in 
                 ( SELECT item 
				     FROM rms.item_master a 
					WHERE brand_name in ( SELECT PARAMETER_VALUE
                                            FROM rms.nb_outlet_phaseout
                                           WHERE PARAMETER_TYPE = 'BRAND_NAME'
                                             AND ENABLED = 'Y'
									    ) 
					  AND item_level<=tran_level
                      AND EXISTS ( SELECT 1 
					                 FROM rms.uda_item_ff b
                                    WHERE uda_id='2010'
									  AND uda_text in ('23','37')
                                      AND a.item=b.item 
                                  )
		          ) group by item_level;
                              
                              
select * from rms.


delete FROM nb_outlet_phaseout where PARAMETER_TYPE = 'BRAND_NAME';
delete FROM nb_outlet_phaseout where PARAMETER_TYPE = 'PRICING_STORE';

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

insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESSM','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT MAT','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESSP','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESSC','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TBFITNESST','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','TB MATERNI','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','THREADBARE PLUS FITNESS','Y');
insert into nb_outlet_phaseout values ('BRAND_NAME','DONTTT TAL','Y');

select * from nb_outlet_phaseout;

select * from item_mfqueue; 
select * from ma_asos.
2010	BUSINESS MODEL ID

select * from uda;
*/ 
select * from ma_asos.ma_v_business_model;

set serveroutput on
DECLARE

 CURSOR C_get_cfa_data 
     IS
 SELECT item,
        loc 
  FROM  item_loc_cfa_ext il 
 WHERE  group_id='110200' 
   AND NUMBER_11 is not null
   AND loc IN ( SELECT TO_NUMBER(PARAMETER_VALUE)
                  FROM nb_outlet_phaseout
                 WHERE PARAMETER_TYPE = 'PRICING_STORE'
                   AND ENABLED = 'Y') 
   AND EXISTS ( SELECT 1 from
                 ( SELECT item 
				     FROM item_master a 
					WHERE brand_name in ( SELECT PARAMETER_VALUE
                                            FROM nb_outlet_phaseout
                                           WHERE PARAMETER_TYPE = 'BRAND_NAME'
                                             AND ENABLED = 'Y'
									    ) 
					  AND item_level<=tran_level
                      AND EXISTS ( SELECT 1 
					                 FROM uda_item_ff b
                                    WHERE uda_id='2010'
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
  UPDATE item_loc_cfa_ext
     SET number_11 = null
   WHERE group_id='110200'
     AND item = l_item_loc_tbl(indx).item
     AND loc = l_item_loc_tbl(indx).loc;

  COMMIT;	 
 
 END LOOP;
 
EXCEPTION

 WHEN OTHERS THEN

  DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);


END;
/