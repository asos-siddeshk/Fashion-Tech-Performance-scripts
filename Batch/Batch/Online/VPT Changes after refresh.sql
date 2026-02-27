db.getCollection('exportedExchangeRate').find({"properties.TOCURRENCY":"AUD","properties.TOCURRENCY":"GBP"})

select * from v$restore_point;
select * from item_master where item_parent in ('101067032');

select * from ma_asos.MA_STG_ITEM_BARCODE where option_id ='100927520';
select * from ma_asos.MA_STG_ITEM_HEAD where item ='100927520';
select * from ma_asos.MA_STG_ITEM_RANGE where item ='100927520';
select * from ma_asos.MA_STG_ITEM_SIZE where option_id ='100927520';
select * from ma_asos.MA_STG_ITEM_SUP where item ='100927520';
select * from ma_asos.MA_STG_ITEM_UDA where item ='100927520';
select * from ma_asos.MA_STG_ITEM_COMMODITY_CODES where item ='100927520';
select * from ma_asos.MA_STG_ITEM_LOC_REPL_DAY where item ='100927520';


select * from MA_ASOS.MA_BUYING_GROUP;

select * from MA_ASOS.MA_BUYING_GROUP;


-- Changes


Update partner set CURRENCY_CODE ='GBP',PRINCIPLE_COUNTRY_ID='GB', VAT_REGION ='1001',STATUS='A' where PARTNER_ID='F100836';
update addr set COUNTRY_ID ='GB' where KEY_VALUE_2='F100836';

Insert into ma_asos.ma_supplier_factory (SUPPLIER,FACTORY,STATUS,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID)
    values (1100000086,'F100836','A',to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');
    
update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');
drop table uda_item_defaults_bk;
create table uda_item_defaults_bk as select * from rms.uda_item_defaults ;
delete from rms.uda_item_defaults;
insert into uda_item_defaults select * from uda_item_defaults_bk ;

select * from UDA_VALUES where UDA_ID ='5003';
select * from UDA where UDA_ID ='5003';

delete from UDA_VALUES where UDA_ID ='5003';
delete from uda where UDA_ID ='5003';

Insert into uda (UDA_ID,UDA_DESC,MODULE,DISPLAY_TYPE,DATA_TYPE,DATA_LENGTH,SINGLE_VALUE_IND,FILTER_ORG_ID,FILTER_MERCH_ID,FILTER_MERCH_ID_CLASS,FILTER_MERCH_ID_SUBCLASS,CREATE_ID,CREATE_DATETIME) values 
(5003,'AUTO_EAN','ITEM','LV','ALPHA',null,'N',null,null,null,null,'ORACNV',to_date('24-MAY-19','DD-MON-RR'));
Insert into UDA_VALUES (UDA_ID,UDA_VALUE,UDA_VALUE_DESC,CREATE_ID,CREATE_DATETIME) values 
(5003,'2','N','ORACNV',to_date('24-MAY-19','DD-MON-RR'));
Insert into UDA_VALUES (UDA_ID,UDA_VALUE,UDA_VALUE_DESC,CREATE_ID,CREATE_DATETIME) values 
(5003,'1','Y','ORACNV',to_date('24-MAY-19','DD-MON-RR'));


Update MA_ASOS.MA_BUYING_SET set BRAND_NAME='ASOS' where BUYING_SET_name like 'Main%' and BUYING_GROUP = '128';
select * from brand where BRAND_NAME like 'ASOS';
select * from brand where BRAND_NAME like 'TRAN%';
update brand set BRAND_DESCRIPTION = 'ASOS' where BRAND_NAME = 'ASOS';
update brand set BRAND_NAME = 'TRANSFER' where BRAND_NAME = 'TRAINERSPO';

Insert into brand (BRAND_NAME,BRAND_DESCRIPTION,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) values 
('TRANSFER','TRANSFER',to_date('30-SEP-19','DD-MON-RR'),to_date('04-MAY-21','DD-MON-RR'),'ORACNV','EMMA.WEST');

    --

select * from DIFF_GROUP_HEAD where diff_group_id = '3100';
select * from DIFF_GROUP_DETAIL where diff_group_id = '3100';


select * from DIFF_GROUP_HEAD where diff_group_id = '2001';
select * from DIFF_GROUP_DETAIL where diff_group_id = '2001';
select * from DIFF_GROUP_HEAD where diff_group_id = '3064';
select * from DIFF_GROUP_DETAIL where diff_group_id = '3064';

select * from all_tables where table_name like '%SIZ%';

select * from DIFF_GROUP_HEAD where diff_group_id = '3064';
select * from DIFF_GROUP_DETAIL where diff_group_id = '3064';
select * from MA_ASOS.MA_SIZE_GROUP_CONF Where SIZE_GROUP_ID = '3064';


delete from DIFF_GROUP_DETAIL where diff_group_id = '3064';
delete from DIFF_GROUP_HEAD where diff_group_id = '3064';
delete from MA_ASOS.MA_SIZE_GROUP_CONF Where SIZE_GROUP_ID = '3064';
Insert into DIFF_GROUP_HEAD (DIFF_GROUP_ID,DIFF_TYPE,DIFF_GROUP_DESC,CREATE_DATETIME,LAST_UPDATE_ID,LAST_UPDATE_DATETIME,FILTER_ORG_ID,FILTER_MERCH_ID,FILTER_MERCH_ID_CLASS,FILTER_MERCH_ID_SUBCLASS,CREATE_ID) 
    values ('3064','S','Waist Plus W30L36-W48L34',to_date('30-SEP-19','DD-MON-RR'),'ORACNV',to_date('30-SEP-19','DD-MON-RR'),null,null,null,null,'ORACNV');

insert into DIFF_GROUP_DETAIL (DIFF_ID, DIFF_GROUP_ID, DISPLAY_SEQ, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME, CREATE_ID)
 select diff_id,3064,DISPLAY_SEQ, CREATE_DATETIME, LAST_UPDATE_ID, LAST_UPDATE_DATETIME, CREATE_ID from DIFF_GROUP_DETAIL where diff_group_id = '3100';
    
db.getCollection('exportedDiffGroup').find({"diff_group_id":"3100"})


    
select * from rms.MERCH_HIER_DEFAULT;

drop table MA_RULE_SET_UDA_bk;

create table MA_RULE_SET_UDA_bk as  select * from ma_asos.MA_RULE_SET_UDA;
select * from ma_asos.MA_RULE_SET_UDA where dept = '1051' and class = '7';

select * from all_tables where table_name like '%UDA%' and owner like 'MA_ASOS';

delete from ma_asos.MA_RULE_SET_UDA where dept = '1051' and class = '7';

select * from ma_asos.MA_UDA_CONF;

select * from HTS order by 1,2;

Insert into hts (HTS,IMPORT_COUNTRY_ID,EFFECT_FROM,EFFECT_TO,HTS_DESC,CHAPTER,UNITS,UNITS_1,UNITS_2,UNITS_3,DUTY_COMP_CODE,MORE_HTS_IND,QUOTA_CAT,QUOTA_IND,AD_IND,CVD_IND) values 
('4202929190','US',to_date('01-JAN-00','DD-MON-RR'),to_date('31-DEC-99','DD-MON-RR'),'TOILET BAG / IPAD SLEEVE -TEXT','42',1,'EA',null,null,'7','N',null,'N','N','N');


select * from all_views where view_name like '%HTS%';
select * from ma_asos.MA_V_ITEM_HTS where hts = '4202929190';
select * from V_HTS_TL where hts = '4202929190';


select * from all_views where view_name like '%COMM%' and owner like 'MA_ASOS';
select * from all_tables where table_name like '%COMM%' and owner like 'MA_ASOS';
select * from ma_asos.MA_COMMODITY_CODES where commodity_code ='4202929190'; 

Insert into ma_asos.MA_COMMODITY_CODES (GENDER,PRODUCT_TYPE,PRODUCT_DESCRIPTION,CONSTRUCTION,MAIN_FIBRE,IMPORT_COUNTRY,COMMODITY_CODE,EXTRA_INFORMATION,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) values ('3','236','WAISTPACK','3',null,'US','4202929190',null,to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');
Insert into ma_asos.MA_COMMODITY_CODES (GENDER,PRODUCT_TYPE,PRODUCT_DESCRIPTION,CONSTRUCTION,MAIN_FIBRE,IMPORT_COUNTRY,COMMODITY_CODE,EXTRA_INFORMATION,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) values ('3','71','MAKE UP BAGS','3','TX','US','4202929190',null,to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');
Insert into hts (HTS,IMPORT_COUNTRY_ID,EFFECT_FROM,EFFECT_TO,HTS_DESC,CHAPTER,UNITS,UNITS_1,UNITS_2,UNITS_3,DUTY_COMP_CODE,MORE_HTS_IND,QUOTA_CAT,QUOTA_IND,AD_IND,CVD_IND) values 
('4202929190','US',to_date('01-JAN-00','DD-MON-RR'),to_date('31-DEC-99','DD-MON-RR'),'TOILET BAG / IPAD SLEEVE -TEXT','42',1,'EA',null,null,'7','N',null,'N','N','N');





  -- Purchase Order



 -- Price changes (Retention period)
select * from item_master_op;


drop table item_master_op;

create table item_master_op as
  select item,DEPT, CLASS, SUBCLASS, STATUS,ITEM_LEVEL, TRAN_LEVEL from item_master where item_level = '1' and status = 'A';

drop table option_item_counts;
create table option_item_counts as 
select im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET, count(1) as count_options
    from v_item_master im, ma_asos.ma_v_item ma where im.item = ma.item and im.item_level = '1' and im.status = 'A'
    group by im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET;

select * from option_item_counts;


drop table option_item;
create table option_item as 
select im.item, im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET
    from v_item_master im, ma_asos.ma_v_item ma,item_master_op op where op.item = ma.item and im.item = ma.item 
     and im.DIVISION = '1' and BUSINESS_MODEL = '1';

select * from option_item;


Update partner set CURRENCY_CODE ='GBP',PRINCIPLE_COUNTRY_ID='GB', VAT_REGION ='1001',STATUS='A' where PARTNER_ID='F100836';
update addr set COUNTRY_ID ='GB' where KEY_VALUE_2='F100836';
Insert into ma_asos.ma_supplier_factory (SUPPLIER,FACTORY,STATUS,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) 
    values (1100000086,'F100836','A',to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');

select * from vat_region;
select * from addr where KEY_VALUE_2='F100836';
select * from partner where partner_id= 'F100836';

select * from ma_asos.ma_supplier_factory where supplier = '1100000086' and  factory = 'F100836'; --F102340
select * from ma_asos.ma_supplier_factory;


Insert into ma_asos.ma_supplier_factory (SUPPLIER,FACTORY,STATUS,CREATE_DATETIME,LAST_UPDATE_DATETIME,CREATE_ID,LAST_UPDATE_ID) 
    values (1100000086,'F100836','A',to_date('01-OCT-19','DD-MON-RR'),to_date('01-OCT-19','DD-MON-RR'),'ORACNV','ORACNV');


Insert into ma_asos.MA_TRANSIT_MATRIX 
(SHIPPING_POINT,RECEIVING_POINT,SHIPPING_METHOD,FREIGHT_FORWARDER,CY_CUT_OFF,VESSEL_DEPARTURE,ORIGIN_DWELL,TOTAL_DAYS) values ('UNIUN',4001,'30','1','SUNDAY','SUNDAY',0,1);

select OWNER, TABLE_NAME,NUM_ROWS from all_tables where OWNER like 'SKUMAR';


update ma_asos.MA_SIZE_PROFILE_head set PRODUCT_GROUP='1006',CATEGORY='5',SUBCATEGORY= '1' 
 where SIZE_PROFILE in ('4010151206190','3010151206190','1010151206190');




select count(*)--/3 
from rms.ordhead 
 where CREATE_DATETIME>= to_date('07-MAY-2021 12.59', 'DD-MON-YYYY hh24:mi')
   and comment_desc like '%PO Create';







create table reclass_ord_rec as
 select ITEM, BUSINESS_MODEL, BUYING_GROUP, BUYING_SUBGROUP, BUYING_SET from  ma_asos.ma_stg_item_buy_hier_reclass;

TRUNCATE table reclass_ord_rec;

select * from option_item where item in (select item from  reclass_ord_rec);

select im.item, im.DIVISION, im.DEPT, im.CLASS, im.SUBCLASS, ma.BUSINESS_MODEL, ma.BUYING_GROUP, ma.BUYING_SUBGROUP, ma.BUYING_SET, im.item_level
    from v_item_master im, ma_asos.ma_v_item ma,item_master_op op where op.item = ma.item and im.item = ma.item 
     and im.item in (select item from  reclass_ord_rec);

select * from ma_asos.ma_item_attributes;


truncate table reclass_ord_rec;
create table reclass_ord_rec as
select item from item_master where item in (select OPTION_ID from ma_asos.ma_order_rec_head_stg) 
    and dept = '1006' and rownum <= '1000';


select count(1),BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET from ma_asos.ma_item_attributes where item in (select item from item_master 
 where item in  (select distinct item from  ma_asos.ma_stg_item_buy_hier_reclass))
     group by BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET
     order by BUSINESS_MODEL,BUYING_GROUP,BUYING_SUBGROUP,BUYING_SET;

select *  from  ma_asos.ma_stg_item_buy_hier_reclass;
delete from  ma_asos.ma_stg_item_buy_hier_reclass;

set serveroutput on;
set timing on;
declare
	l_process_seq        ma_asos.ma_stg_item_buy_hier_reclass.process_seq%type;  
	l_item               ma_asos.ma_stg_item_buy_hier_reclass.item%type;  
	l_status             ma_asos.ma_stg_item_buy_hier_reclass.status%type 			:='A';              
	l_new_brand_name     ma_asos.ma_stg_item_buy_hier_reclass.new_brand_name%type	:='7X';   
	l_business_model	 ma_asos.ma_stg_item_buy_hier_reclass.business_model%type	:='1';
	l_buying_group		 ma_asos.ma_stg_item_buy_hier_reclass.buying_group%type		:='104';
	l_buying_subgroup	 ma_asos.ma_stg_item_buy_hier_reclass.buying_subgroup%type	:='1';
	l_buying_set		 ma_asos.ma_stg_item_buy_hier_reclass.buying_set%type		:='6';
    L_EFFECTIVE_DATE     ma_asos.ma_stg_item_buy_hier_reclass.EFFECTIVE_DATE%type;
		   
cursor c_buy_reclass is
     select IM.ITEM,p.vdate+1 as effective_date
        from reclass_ord_rec im, rms.period p 
        where  not exists (Select 1 from ma_asos.ma_stg_item_buy_hier_reclass r where r.item=im.item and PROCESS_STATUS= 'N')
               and not exists (Select 1 from RECLASS_item rr where rr.item=im.item ) ;
	
begin  
for i in c_buy_reclass loop 
	l_item:= i.item;
	l_effective_date     := i.effective_date;

	 select ma_asos.MA_PROCESS_ID_SEQ.nextval into l_process_seq from dual;
    
   insert into ma_asos.ma_stg_item_buy_hier_reclass(process_seq          , 
													item                 , 
													status               , 
													business_model       , 
													buying_group         , 
													buying_subgroup      , 
													buying_set           , 
													effective_date       , 
													new_brand_name       ,
                                                    process_status,
													create_datetime      , 
													last_update_datetime , 
													create_id            , 
													last_update_id )
                            values					(l_process_seq,
                                                     l_item,
                                                     l_status,
                                                     l_business_model,
                                                     l_buying_group,
                                                     l_buying_subgroup,
                                                     l_buying_set,
                                                     l_effective_date,
                                                     l_new_brand_name,
                                                     'N',
                                                     sysdate,
                                                     sysdate,
                                                     'PTUSER',
                                                     'PTUSER' );
    	end loop;
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/









drop table if_tran_data_bk_reten;

create table if_tran_data_bk_reten as
select * from rms.if_tran_data;


select * from period;
select * from daily_data;
select * from tran_data_a;
select * from tran_data_b;
select * from if_tran_data_bk_reten;

begin
insert into tran_data_b (ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, TRAN_DATE, TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, 
REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TIMESTAMP, REF_PACK_NO,TOTAL_COST_EXCL_ELC)
select ITEM, DEPT, CLASS, SUBCLASS, PACK_IND, LOC_TYPE, LOCATION, TRAN_DATE+1, TRAN_CODE, ADJ_CODE, UNITS, TOTAL_COST, TOTAL_RETAIL, REF_NO_1, 
REF_NO_2, GL_REF_NO, OLD_UNIT_RETAIL, NEW_UNIT_RETAIL, PGM_NAME, SALES_TYPE, VAT_RATE, AV_COST, TRAN_DATA_TIMESTAMP+1, REF_PACK_NO, null as TOTAL_COST_EXCL_ELC
from if_tran_data_bk_reten;

commit;
end;
/

select * from period;
delete from daily_data where data_date ='08-MAY-21';




`