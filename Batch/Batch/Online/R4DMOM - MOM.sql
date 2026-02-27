
select * from MA_ASOS.MA_STYLES where PRIMARY_COLOUR_ID in (select item from Rms.datasubset_item)
union
select * from MA_ASOS.MA_STYLES where style in (select style from MA_ITEM_ATTRIBUTES where item in (select item from Rms.datasubset_item));



select * from all_tables where table_name like '%STG%ITEM%';

select max(ORDER_NO) from rms.ordhead;
select max(ORDCUST_NO) from rms.ordcust;
select max(ORDCUST_NO) from rms.ordcust_detail;
select max(tsf_NO) from rms.tif_explode;
select max(tsf_NO) from rms.tsfhead;

select * from rms.item_supplier where item in (select item from rms.item_master where item in ('101580262','100000477') or item_parent in ('101580262','100000477') or item_grandparent in ('101580262','100000477'));

update rms.sups set SUP_STATUS = 'A' where supplier_parent in ('1000002496','1000000109');
1100002496,1100005192

select * from rms.sups where supplier in (1100002496,1100005192) or supplier_parent in (1000002496,1000000109);

select * from rms.item_loc where item in (select item from rms.item_master where item in ('101580262','100000477') or item_parent in ('101580262','100000477') or item_grandparent in ('101580262','100000477'));
select * from rms.rpm_stage_item_loc where item in (select item from rms.item_master where item in ('101580262','100000477') or item_parent in ('101580262','100000477') or item_grandparent in ('101580262','100000477'));
select * from rms.rpm_stage_item_loc_clean;
select * from ma_asos.MA_STG_ITEM_HEAD;
select count(1) from ma_asos.MA_BUYING_GROUP;
select count(1) from ma_asos.MA_RMS_ITEM_SEARCH_BASE;

select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE;
select * from rms.item_master ;
101580262

select * from rms.item_master where item in ('101580262','100000477') or item_parent in ('101580262','100000477') or item_grandparent in ('101580262','100000477');
select * from rms.rpm_future_retail where item in (select item from rms.item_master where item in ('101580262','100000477') or item_parent in ('101580262','100000477') or item_grandparent in ('101580262','100000477'));
select * from rms.rpm_item_loc where item in (select item from rms.item_master where item in ('101580262','100000477') or item_parent in ('101580262','100000477') or item_grandparent in ('101580262','100000477'));

select * from rms.rsm_user_role;
select * from rms.rsm_role;
select * from rms.rsm_user_role where id = '90001';
    90001	SiddeshK	8	09-AUG-22 00.00.00.000000000	

delete from rms.rsm_user_role where id = '90001';
Insert into rms.rsm_user_role  (ID,USER_ID,ROLE_ID,START_DATE_TIME,END_DATE_TIME) values (90001,'SiddeshK',8,to_timestamp('09-AUG-22 00.00.00.000000000','DD-MON-RR HH24.MI.SSXFF'),null);


select * from ma_asos.MA_STG_ORDER;

    SELECT * FROM rms.ORDHEAD order by 1 desc;
    SELECT * FROM rms.ORDHEAD order by 1 desc;
    
    select * FROM rms.logger_logs where trunc(TIME_STAMP) =trunc(sysdate) order by TIME_STAMP desc;
    select * FROM ma_asos.ma_logs where trunc(LOG_TS) =trunc(sysdate) order by LOG_TS desc;

select *
    from rms.ordhead 
 where CREATE_DATETIME>= to_date('16-AUG-2023 09.00', 'DD-MON-YYYY hh24:mi');


select * from int_asos.int_tckt_dnld_stage ;

select * from rms.rsm_role;
select * from rms.rsm_user_role;
select * from rms.rsm_role_named_permission;
select * from rms.rsm_hierarchy_permission;



./nb_refresh_result.ksh $UP MA_RMS_ITEM_SEARCH_BASE &


select * from ma_asos.MA_RMS_ITEM_SEARCH_BASE where item_level = '1'; ~5k options

select * from rms.vat_item where item = '100000459';

select * from rms.rpm_item_zone_price where item = '100000459';
select * from rms.rpm_merch_retail_def;
select * from rms.rpm_zone_location;
select * from rms.mv_currency_conversion_rates;

exec dbms_mview.refresh('MV_CURRENCY_CONVERSION_RATES');
exec dbms_mview.refresh('MV_LOC_PRIM_ADDR');
exec dbms_mview.refresh('MV_LOC_SOB');

select * from rms.sups where sup_name like 'ABC Telecom';

select * from ma_asos.ma_pricing_defaults; --1051
select * from ma_asos.ma_v_rpm_zone;
select * from rms.vat_deps where dept = '1051';
select * from rms.store;

select distinct key_value_1 from rms.addr where module like 'ST';
select * from RMS.STORE;
select * from rms.wh;

   SELECT mvim.dept
      FROM ma_asos.ma_v_item_master mvim
     WHERE mvim.item = '100000459'
     UNION
    SELECT msih.dept
      FROM ma_asos.ma_stg_item_head msih
     WHERE msih.item = '100000459';
     
    select * from rms.RPM_FUTURE_RETAIL;    
    select * from rms.RPM_ITEM_ZONE_PRICE;    
    select * from rms.rpm_zone_future_retail;
    
select * from all_sequences where sequence_name like 'RPM%FUT%';
select * from all_sequences where sequence_name like 'RPM_ITEM_ZONE_PRICE_SEQ%';

Update all_sequences set LAST_NUMBER = '202986591' where sequence_name = 'RPM_ZONE_FUTURE_RETAIL_SEQ';



alter sequence rms.RPM_ITEM_ZONE_PRICE_SEQ increment by 1;
select rms.RPM_FUTURE_RETAIL_SEQ.nextval from dual;

    
set SERVEROUTPUT ON;
set timing on;
DECLARE
  last_used  number(25);
  curr_seq   number(25);
BEGIN
  SELECT 3494390976 INTO last_used FROM dual;
  
  LOOP
    SELECT rms.RPM_FUTURE_RETAIL_SEQ.NEXTVAL INTO curr_seq FROM dual;
   -- dbms_output.put_line('Curr Seq: '||curr_seq);
    IF curr_seq >= last_used THEN EXIT;
    END IF;
  END LOOP;
commit;
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
END;
/


Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' ;
delete from rms.restart_bookmark;


select * from rms.period;
update rms.SYSTEM_VARIABLES set ( 
   LAST_EOM_HALF_NO       , 
   LAST_EOM_MONTH_NO      , 
   LAST_EOM_DATE          , 
   NEXT_EOM_DATE          , 
   LAST_EOM_START_HALF    , 
   LAST_EOM_END_HALF      , 
   LAST_EOM_START_MONTH   , 
   LAST_EOM_MID_MONTH     , 
   LAST_EOM_NEXT_HALF_NO  , 
   LAST_EOM_DAY           , 
   LAST_EOM_WEEK          , 
   LAST_EOM_MONTH         , 
   LAST_EOM_YEAR          , 
   LAST_EOM_WEEK_IN_HALF  , 
   LAST_EOW_DATE          ) = ( 
select p.half_no -  
          decode( p.curr_454_month_in_half, 1, 
                  decode( mod(p.half_no,10), 1, 9, 1), 
                  0 )                                           LAST_EOM_HALF_NO,    
       decode( p.curr_454_month_in_half, 1,  
               6, 
               p.curr_454_month_in_half - 1)                    LAST_EOM_MONTH_NO,        
       p.start_454_month - 1                                    LAST_EOM_DATE,       
       p.end_454_month                                          NEXT_EOM_DATE,     
       add_months( p.start_454_half, 
                   decode( p.curr_454_month_in_half, 1, -6, 0)) LAST_EOM_START_HALF,          
       add_months( p.end_454_half, 
                   decode( p.curr_454_month_in_half, 1, -6, 0)) LAST_EOM_END_HALF,          
       add_months( p.start_454_month, -1)                       LAST_EOM_START_MONTH,       
       add_months( p.start_454_month, -1) + 14                  LAST_EOM_MID_MONTH,       
       p.half_no + 
          decode( p.curr_454_month_in_half, 1,  
                  0,
                  decode( mod(p.half_no,10), 1,1, 9))           LAST_EOM_NEXT_HALF_NO,
       decode( to_char(p.start_454_month-1,'DD'),  
               '28', 7, 
               mod( to_char(p.start_454_month-1,'DD'),28) )     LAST_EOM_DAY,          
       decode( to_char(p.start_454_month-1,'DD'),  
               '28', 4, 5)                                      LAST_EOM_WEEK,         
       to_char(p.start_454_month-1,'MM')                        LAST_EOM_MONTH,        
       to_char(p.start_454_month-1,'YYYY')                      LAST_EOM_YEAR,        
       ceil( ( p.start_454_month - 1 - add_months( p.start_454_half, 
               decode( p.curr_454_month, 1, -6, 0))  
               )/7 )                                            LAST_EOM_WEEK_IN_HALF,                               
       p.start_454_month - 1 + trunc(to_char(p.vdate,'DD')/7)*7 LAST_EOW_DATE  
from rms.PERIOD p 
);

update rms.SYSTEM_VARIABLES set  
   LAST_EOW_DATE     = LAST_EOW_DATE_UNIT;



select * from rms.rpm_stage_clearance;
select * from rms.rpm_clearance where item ='100000477';
select * from rms.rpm_future_retail where item ='100000477';

insert into rms.rpm_stage_clearance (stage_clearance_id,
                reason_code,
                item,
                zone_id,
                Location,
                zone_node_type,
                effective_date,
                out_of_stock_date,
                reset_date,
                change_type,
                change_percent,
                change_amount,
                auto_approve_ind,
                status,
                VENDOR_FUNDED_IND) 
                Values
(               1,--stage_clearance_id
                3,--reason_code
                '100000477',--item
                '100',--zone_id
                null,--Location
                '1',--zone_node_type
                '28-JUL-23',--effective_date
                '28-DEC-23',--out_of_stock_date
                '28-DEC-23',--reset_date
                '0',--change_type
                '-30',--change_percent
                null,--change_amount
                1,--auto_approve_ind
                'N',--status
                0);--VENDOR_FUNDED_IND);


select * from rms.store;
select * from rms.rpm_stage_simple_promo;
select status from rms.rpm_stage_simple_promo;


select * from rms.rpm_stage_simple_promo;



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
				values ( 1
						,1
						,1
						,'CHECK'
						,0 
						,0 
						,'20001'
						,2 
						,'10-JUL-2023'
						,to_date('15-JUL-2023') + 1 - 1/(24*60)  
						,'100000477'
						,1 
						,0 
						,null
						,'-40' 
						,1 
						,'N' 
						,0 
						,'10-JUL-2023'
						,to_date('15-JUL-2023') + 1 - 1/(24*60) 
						,0 
						,'GBP'
						,null
						,'EA');


select status,count(1) from rms.ordhead group by status;

select * from rms.ordsku os, rms.ordhead oh where os.order_no = oh.order_no and oh.status='C' and os.item in (select item from rms.item_master);

select order_no, supplier, LAST_UPDATE_ID, CREATE_DATETIME, MASTER_PO_NO from rms.ordhead order by 1 desc;

select * from rms.sups where sup_status ='A' and supplier_parent is not null;

select * from rms.ordhead where order_no = '50000090012';
select * from rms.ordloc where order_no = '50000090012';
select * from rms.ordsku where order_no = '50000090012';



select * from MA_ASOS.MA_STG_ORDER order by 1 desc;
select * from MA_ASOS.MA_STG_ORDER order by 1 desc;
select * from all_sequences where sequence_name like 'ORDER%';
select * from rms.logger_logs order by 1 desc;


select * from rms.repl_results;


SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_NAME LIKE 'LOGGER%';
select * from rms.logger_logs where id > 823773 order by id desc;

0xe3ded740       142  package body RMS.SQL_LIB.CREATE_MSG
0xc3bd5cd0     16367  package body RMS.CORESVC_PO.EXEC_ORH_INS
0xc3bd5cd0     17312  package body RMS.CORESVC_PO.PROCESS_ORH
0xc3bd5cd0     15477  package body RMS.CORESVC_PO.PROCESS_PO_DATA
0xc3bd5cd0     15573  package body RMS.CORESVC_PO.PROCESS_PO_THREAD
0xc3bd5cd0      1526  package body RMS.CORESVC_PO.PROCESS
0xca4debb0       178  package body RMS.PO_INDUCT_SQL.EXEC_ASYNC
0xcb599fa8       561  package body MA_ASOS.MA_ORDERS_SQL.PROCESS_QUEUE_RECORD
0xcb599fa8      1084  package body MA_ASOS.MA_ORDERS_SQL.PUB_ORDER_MSG
0xcb599fa8       806  package body MA_ASOS.MA_ORDERS_SQL.PUB_ORDER_MSG


select * from v$session where username is not null and status = 'ACTIVE' order by logon_time, sid;


    select * FROM rms.logger_logs where trunc(TIME_STAMP) =trunc(sysdate) order by TIME_STAMP desc;
    select * FROM ma_asos.ma_logs where trunc(LOG_TS) =trunc(sysdate) order by LOG_TS desc;
    select * FROM ma_asos.ma_logs order by LOG_TS desc;

select * from rms.ordhead;

@0PACKAGE_ERROR@1ORA-00001: unique constraint (RMS.UK_ORDSKU_HTS) violated@2CORESVC_PO.EXEC_ORH_INS

  object      line  object
  handle    number  name
0xeec854c8       142  package body RMS.SQL_LIB.CREATE_MSG
0xc132a9a0     16367  package body RMS.CORESVC_PO.EXEC_ORH_INS
0xc132a9a0     17312  package body RMS.CORESVC_PO.PROCESS_ORH
0xc132a9a0     15477  package body RMS.CORESVC_PO.PROCESS_PO_DATA
0xc132a9a0     15573  package body RMS.CORESVC_PO.PROCESS_PO_THREAD
0xc132a9a0      1526  package body RMS.CORESVC_PO.PROCESS
0xbd859a48       178  package body RMS.PO_INDUCT_SQL.EXEC_ASYNC
0xc7f95208       561  package body MA_ASOS.MA_ORDERS_SQL.PROCESS_QUEUE_RECORD
0xc7f95208      1084  package body MA_ASOS.MA_ORDERS_SQL.PUB_ORDER_MSG
0xc7f95208       806  package body MA_ASOS.MA_ORDERS_SQL.PUB_ORDER_MSG
0xbd9c1018         1  anonymous block

SELECT * FROM rms.ITEM_SUPPLIER WHERE ITEM = '133519186';
SELECT * FROM RMS.ITEM_SUPPLIER WHERE ITEM = '133519186';
SELECT * FROM RMS.ITEM_SUPP_country_loc WHERE ITEM = '133519186';
SELECT * FROM RMS.ITEM_SUPP_country WHERE ITEM = '133519186';

select * from ma_asos.ma_stg_order where master_order_no = '22883391';
select * from ma_asos.ma_stg_sizing_sku where master_order_no = '22883391';
select * from ma_asos.ma_stg_order_rec_rpl where master_order_no = '22883391';
select * from ma_asos.ma_stg_order_drops_detail where master_order_no = '22883391';
select * from ma_asos.ma_stg_cost_expense_detail where master_order_no = '22883391';
select * from ma_asos.ma_ordsku_hts where master_order_no = '22883391';
select * from ma_asos.ma_v_option_supplier where item = '133519186';

select * from ma_asos.MA_V_ITEM_HTS where item = '133519186';

select * from rms.V_IM_ITEM_SUPP_COUNTRY_LOC where item = '133519186';
select * from rms.ITEM_SUPP_COUNTRY_LOC where item = '133519186';
select * from rms.ITEM_SUPP_COUNTRY where item = '133519186';


select * from ma_asos.ma_order_pub_info where order_no in (select order_no from ma_asos.ma_stg_sizing_sku where master_order_no = '22883391');

select * from ma_asos.ma_order_mfqueue where master_order_no = '22883391';
select * from ma_asos.ma_ordsku_hts_assess where master_order_no = '22883391';
select * from ma_asos.ma_ordsku_hts where master_order_no = '22883391';

select * from ma_asos.ma_v_supplier_factory order by 1 desc;

select * from ma_asos.ma_order_mfqueue order by 1 desc;
select * from rms.ordhead order by 1 desc;
select * from rms.ordhead where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ORDSKU where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ORDLOC where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ordloc_exp where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ordsku_hts where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ordsku_hts where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');


select * from rms.CORESVC_ERROR_MAPPING;
select * from rms.RTK_ERRORS_TL;
select * from rms.RTK_ERRORS;
select * from all_tables where table_name like '%ERRORS%';



select * from rms.item_master where item in (select item from rms.ORDSKU_HTS where order_no in (select order_no from rms.ordhead where master_po_no = '22883391'));;
select * from rms.item_supp_country_loc where item in ('133519186');

Update rms.item_supp_country_loc set PRIMARY_LOC_IND = 'N'  where loc = '5001' and item in (select item from rms.item_master where item = '133519186' or item_parent = '133519186');

select * from rms.item_hts where item in ('133519186');;
select * from rms.country;
select * from rms.hts where hts in ('6201409090','6210503500'); --AM	Armenia
select * from rms.system_options;
select * from ma_asos.ma_stg_reason_code;

select * from rms.svc_process_tracker order by 1 desc;
select * from rms.svc_ordhead order by 1 desc;

select * from rms.svc_orddetail where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.svc_ordhead where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ordloc_exp where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.svc_ordsku_hts where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.svc_ordsku_hts_assess where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
svc_ordsku_hts_assess
svc_ordsku_hts

select * from rms.ordsku_hts where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');
select * from rms.ordsku_hts_assess where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');

select * from ma_asos.ma_v_wh_cnt;

select * from rms.svc_ordsku_hts_assess where order_no in (select order_no from rms.ordhead where master_po_no = '22883391');



select * from ma_asos.ma_styles where PRIMARY_COLOUR_ID = '133440487';

select * from ma_asos.ma_superstyles;

select * from ma_asos.ma_styles where STYLE = '993244'; --100431681
select * from rms.item_master where item = '100431681';



insert into ma_asos.ma_styles
select MA_ASOS.MA_STYLE_SEQ.nextval,SHORT_DESC,dept,class,subclass,'A',sysdate,sysdate,'MANUALUPD','MANUALUPD',Item
    from rms.item_master where item not in (select PRIMARY_COLOUR_ID from ma_asos.ma_styles) and item_level = '1' and item = '133440487';


select count(Item) from rms.item_master where item not in (select PRIMARY_COLOUR_ID from ma_asos.ma_styles) and item_level = '1';
select * from rms.item_master where item not in (select PRIMARY_COLOUR_ID from ma_asos.ma_styles) and item_level = '1';

select * from ma_asos.ma_styles where PRIMARY_COLOUR_ID in ('100048232','100069999','100083732','100096669','100096699');


select * from all_sequences where sequence_name like '%STY%';
select * from all_tables where COLUMN_NAME like 'STYLE';
select * from all_tab_columns where COLUMN_NAME like 'STYLE';

select * from ma_asos.MA_STYLES where PRIMARY_COLOUR_ID = '133440487';
select * from ma_asos.MA_V_STYLES where item = '133440487';
select * from ma_asos.ma_item_attributes where item = '133440487';

select * from all_views where view_name like 'MA_V_PRIMARY_OPTION_COLOURS';

select * from ma_asos.MA_V_STYLES where item = '133440487'; --500624186
select * from ma_asos.ma_item_attributes where item = '133440487'; --500624186


select * from ma_asos.MA_STYLES ms where not exists (select 1 from ma_asos.ma_item_attributes mia where mia.style = ms.style);
select * from ma_asos.ma_item_attributes ms where not exists (select 1 from ma_asos.MA_STYLES mia where mia.style = ms.style);
select * from ma_asos.MA_STYLES ms where PRIMARY_COLOUR_ID not in (select item from rms.item_master); 
    exists (select 1 from ma_asos.ma_item_attributes mia where mia.style = ms.style);



select * from rms.COST_SUSP_SUP_DETAIL
