set serveroutput on;
set timing on;
DECLARE
   O_error_message       VARCHAR2(255);
BEGIN

  -- populate RPM_FUTURE_RETAIL_GTT table
   if STO_UTILITIES_SQL.POPULATE_GTT('3210000',
                                     O_error_message) = FALSE then
              DBMS_OUTPUT.PUT_LINE(O_error_message);
   end if;
   
EXCEPTION
   when OTHERS THEN
      dbms_output.put_line(TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/


select * from ;

Select * from 
         (select  item, diff_id, location, zone_node_type, action_date, cnt 
         From (Select Fr.Item, Fr.Diff_Id, Fr.Location, Fr.Zone_Node_Type, Fr.Action_Date, Count(*) Cnt 
         from rms.rpm_future_retail fr 
         GROUP BY fr.item, fr.diff_id, fr.LOCATION, fr.zone_node_type, fr.action_date) 
         where cnt > 1);
         
         
        delete FROM rpm_future_retail 
		WHERE item = '5879327' and rowid not in
		(SELECT MIN(rowid)
		FROM rpm_future_retail fr where item ='5879327'
		GROUP BY fr.item, fr.diff_id, fr.LOCATION, fr.zone_node_type, fr.action_date);	
        
        
select * from rpm_item_loc where item in (select item from item_master where item_level!=tran_level);
Select * From Item_Master Where Item  In (Select Item from rpm_item_loc) and  Status = 'A' And Item_Level!= Tran_Level And Sellable_Ind = 'Y';
Select * From Item_Loc Where (Item,Loc) Not In (Select Item,Loc From Price_Hist);
Select * From Item_Loc Where (Item,Loc) Not In (Select Item,Loc From Item_Loc_Soh);
Select * From Item_Loc Where (Item,Loc) Not In (Select Item,Loc From Item_Supp_Country_Loc);
Select * From Price_Hist Where (Item,Loc) Not In (Select Item,Loc From Item_Loc) and loc !=0;
Select * From Item_Loc_Soh Where (Item,Loc) Not In (Select Item,Loc From Item_Loc);
select * from item_supp_country_loc where (item,loc) not in (select item,loc from Item_Loc);
select * from rpm_future_retail where max_hier_level is NULL or cur_hier_level is NULL;

select * from   item_loc il  , 
				   (select item , 
						   dept 
				   from    item_master 
				   where   status       = 'A' 
					   and item_level   = tran_level 
					   and sellable_ind = 'Y' 
				   ) im 
			where  il.item = im.item 
			   and not exists 
				   (select 'x' 
				   from    rpm_item_loc ril 
				   where   ril.item =il.item 
					   and ril.loc  =il.loc
					   AND ril.dept = im.dept 
				   ) ;

select *
        from item_master im, 
             item_loc il 
        where im.status                = 'A' 
          and im.item_level            = im.tran_level 
          and im.sellable_ind          = 'Y' 
          and im.orderable_ind         = 'Y' 
          AND im.item                  = il.item 
          and not exists (select 'x' 
        from future_cost rfr 
        where rfr.item = il.item 
        and rfr.active_date <= '26-DEC-15'
        and rfr.location          = il.loc 
        AND rfr.supplier          = il.primary_supp 
        AND rfr.origin_country_id = il.primary_cntry);


select * from  (select dept from deps minus  select dept from rpm_dept_aggregation);

select * from (select dept||'/'||class||'/'||subclass from subclass minus select dept||'/'||class||'/'||subclass from rpm_merch_retail_def_expl);

select *
        from item_master im, 
             item_loc il 
        where im.status                = 'A' 
          and im.item_level            = im.tran_level 
          and im.sellable_ind          = 'Y' 
          and im.orderable_ind         = 'Y' 
          AND im.item                  = il.item 
          and not exists (select 'x' 
        from future_cost rfr 
        Where Rfr.Item = Il.Item 
        and rfr.active_date <= '25-DEC-15'
        and rfr.location          = il.loc 
        AND rfr.supplier          = il.primary_supp 
        AND rfr.origin_country_id = il.primary_cntry);




Queries used in RPM.

1. Clearance: 
select * from rpm_clearance where item in (100015565);
select * from rpm_clearance_reset where item in (100015565);
select * from rpm_future_retail where item in (100015565);
SELECT * FROM RPM_PRICE_EVENT_PAYLOAD order by 1 desc;
SELECT * FROM RPM_CLEARANCE_PAYLOAD WHERE price_event_payload_id in(59023,59019,59016);


2.	Price Change

select * from RPM_PRICE_CHANGE where item in (100013834,100013835);
select * from rpm_future_retail where item in (100013834,100013835);
select * from rpm_price_event_payload order by 1 desc;
SELECT * FROM RPM_PRICE_CHG_PAYLOAD where price_event_payload_id in (20078);


3.	Promotion ---
Query to verify promotion status using promotion component display id:
select node.item, decode(item_level, tran_level, 'TRAN', 'PARENT') item_type,
       NVL(rzl.location, rzl.zone_id) loc, rp.promo_display_id, comp.comp_display_id, comp.customer_type, 
       dtl.promo_dtl_display_id, dtl.start_date, dtl.end_date,
       dsc.change_type, NVL(dsc.change_percent, dsc.change_amount) discount, dtl.price_guide_id,
       decode(dtl.state, 0, 'worksheet', 1, 'rejected', 2, 'submitted', 3, 'approved', 
                         4, 'cancelled', 5, 'active', 6, 'complete', 7, 'conflict checking', 8, 'pending', 'n/a') state,
       DECODE(expl.promo_dtl_id, null, 'NO', 'YES') flowed,
       dtl.create_id, to_char(dtl.approval_date, 'DD/Mon/YYYY: HH24:MM:SS') approval_date,
       dtl.approval_id, to_char(dtl.create_date, 'DD/Mon/YYYY: HH24:MM:SS') create_date
from rpm_promo_dtl dtl,
     rpm_promo_dtl_merch_node node,
     rpm_promo_zone_location rzl,
     rpm_promo_dtl_list_grp grp,
     rpm_promo_dtl_list lst,
     rpm_promo_dtl_disc_ladder dsc,
     rpm_promo_comp comp,
     rpm_promo rp,
     item_master im,
     rpm_promo_item_loc_expl expl
where node.promo_dtl_id = dtl.promo_dtl_id
and rzl.promo_dtl_id = dtl.promo_dtl_id
and node.promo_dtl_id = rzl.promo_dtl_id
and grp.promo_dtl_id = dtl.promo_dtl_id
and lst.promo_dtl_list_grp_id = grp.promo_dtl_list_grp_id
and lst.promo_dtl_list_id = dsc.promo_dtl_list_id
and comp.promo_comp_id = dtl.promo_comp_id
and rp.promo_id = comp.promo_id
and im.item = node.item
and im.item = '1181765'
--and comp.comp_display_id = '2138586'
and dtl.promo_dtl_id = expl.promo_dtl_id(+)
order by node.item, rzl.location, approval_date desc, dtl.start_date;

SELECT * FROM RPM_PROMO WHERE promo_id =59084;
select * from rpm_promo_comp where promo_id =59084 and comp_display_id = '451515';
SELECT * FROM RPM_PROMO_DTL WHERE promo_comp_id IN (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =59084 and comp_display_id = '451515');
SELECT * FROM RPM_PROMO_DTL_MERCH_NODE WHERE PROMO_DTL_ID in (select PROMO_DTL_ID from RPM_PROMO_DTL where promo_comp_id in (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =59084 and comp_display_id = '451515'));
SELECT * FROM RPM_PROMO_DTL_LIST_GRP WHERE PROMO_DTL_ID in (select PROMO_DTL_ID from RPM_PROMO_DTL where promo_comp_id in (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =59084 and comp_display_id = '451515'));
SELECT * FROM RPM_PROMO_ZONE_LOCATION WHERE PROMO_DTL_ID in (select PROMO_DTL_ID from RPM_PROMO_DTL where promo_comp_id in (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =59084 and comp_display_id = '451515'));
select * from rpm_promo_dtl_list where promo_dtl_list_id in (select promo_dtl_list_id from rpm_promo_dtl_merch_node where promo_dtl_id in (select promo_dtl_id from rpm_promo_dtl where promo_comp_id in (select promo_comp_id  from rpm_promo_comp where promo_id =59084 and comp_display_id = '451515')));
select * from rpm_promo_dtl_disc_ladder where promo_dtl_list_id in (select promo_dtl_list_id from rpm_promo_dtl_merch_node where promo_dtl_id in (select promo_dtl_id from rpm_promo_dtl where promo_comp_id in (select promo_comp_id  from rpm_promo_comp where promo_id =59084 and comp_display_id = '451515')));
select * from rpm_promo_comp_thresh_link where promo_comp_id in (select promo_comp_id  from rpm_promo_comp where promo_id =59084 and comp_display_id = '451515');

SELECT * FROM RPM_PROMO_DTL_PAYLOAD where promo_id ='59084' and comp_display_id = '451515') order by 1 desc;
SELECT * FROM RPM_PROMO_DTL_LIST_GRP_PAYLOAD where promo_dtl_payload_id in (SELECT promo_dtl_payload_id FROM RPM_PROMO_DTL_PAYLOAD where promo_id ='59084' and comp_display_id = '451515'));
SELECT * FROM RPM_PROMO_ITEM_LOC_SR_PAYLOAD  where promo_dtl_payload_id in (SELECT promo_dtl_payload_id FROM RPM_PROMO_DTL_PAYLOAD where promo_id ='59084' and comp_display_id = '451515'));
select * from rpm_promo_location_payload where promo_dtl_payload_id in (select promo_dtl_payload_id from rpm_promo_dtl_payload where promo_id ='59084' and comp_display_id = '451515'));
select * from rpm_promo_dtl_mn_payload where promo_dtl_payload_id in (select promo_dtl_payload_id from rpm_promo_dtl_payload where promo_id ='59084' and comp_display_id = '451515'));
select * from rpm_promo_dtl_prc_rng_payload where promo_dtl_payload_id in (SELECT promo_dtl_payload_id FROM RPM_PROMO_DTL_PAYLOAD where promo_id ='59084' and comp_display_id = '451515'));
SELECT * FROM RPM_PROMO_DTL_LIST_PAYLOAD where promo_dtl_list_grp_payload_id in (SELECT promo_dtl_list_grp_payload_id FROM RPM_PROMO_DTL_LIST_GRP_PAYLOAD where promo_dtl_payload_id in (SELECT promo_dtl_payload_id FROM RPM_PROMO_DTL_PAYLOAD where promo_id ='59084' and comp_display_id = '451515'));
SELECT * FROM RPM_PROMO_DISC_LDR_PAYLOAD where promo_dtl_list_payload_id in (SELECT promo_dtl_list_payload_id FROM RPM_PROMO_DTL_LIST_PAYLOAD where promo_dtl_list_grp_payload_id in (SELECT promo_dtl_list_grp_payload_id FROM RPM_PROMO_DTL_LIST_GRP_PAYLOAD where promo_dtl_payload_id in (SELECT promo_dtl_payload_id FROM RPM_PROMO_DTL_PAYLOAD where promo_id ='59084' and comp_display_id = '451515')));
select * from rpm_promo_item_payload where promo_dtl_list_payload_id in (select promo_dtl_list_payload_id from rpm_promo_dtl_list_payload where promo_dtl_list_grp_payload_id in (select promo_dtl_list_grp_payload_id from rpm_promo_dtl_list_grp_payload where promo_dtl_payload_id in (select promo_dtl_payload_id from rpm_promo_dtl_payload where promo_id ='59084' and comp_display_id = '451515')));
select * from rpm_threshold_int_payload where promo_dtl_payload_id in (select promo_dtl_payload_id from rpm_promo_dtl_payload where promo_id ='59084' and comp_display_id = '451515'));

select * from rpm_future_retail where item in ('132794334') order by 1;
select * from RPM_CUST_SEGMENT_PROMO_FR where item in ('132794334') order by 1;
select * from rpm_promo_item_loc_expl where item in ('132794334') order by 1;


4.	Conflict check ---

select * from RPM_CON_CHECK_ERR order by 1 desc;
select * from rpm_con_check_err_detail order by 1 desc;

5.	Task 
SELECT task_id,                
       status        ,         
       description   ,         
       owner         ,         
       to_char(date_published,'dd-mon-yy hh:mi:ss am') date_published ,         
       to_char(process_start_date,'dd-mon-yy hh:mi:ss am') process_start_date,
       to_char(process_end_date,'dd-mon-yy hh:mi:ss am') process_end_date,
       command_class          ,
       parent_task_id 
  FROM rpm_task --where Description like '%1351317%' and rownum <= 500
ORDER BY task_id desc;



select calendar.c_date,
       NVL(promo_cnt_start.cnt,0) promo_count_start,
       NVL(promo_cnt_end.cnt,0) promo_count_end,
       NVL(clearance_count.cnt,0) clearance_count,
       NVL(price_change_count.cnt,0) pc_count,
       NVL(clearance_reset_count.cnt,0) CR_count
  from (select TRUNC(start_date) st_date, count(1) cnt from rpm_promo_dtl where state = '3' and trunc(start_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by start_date) promo_cnt_start,
       (select TRUNC(end_date) end_date, count(1) cnt from rpm_promo_dtl where state = '3' and trunc(end_date) between to_date(:begin_date, 'mm/dd/yyyy') and to_date(:end_date, 'mm/dd/yyyy') group by end_date) promo_cnt_end,  
       (select trunc(effective_date) st_date, count(1) cnt from rpm_clearance where state = 'pricechange.state.approved' group by effective_date) clearance_count,
       (select trunc(effective_date) st_date, count(1) cnt from rpm_price_change where state = 'pricechange.state.approved' group by effective_date) price_change_count,
       (select trunc(effective_date) st_date, count(1) cnt from rpm_clearance_reset where state = 'pricechange.state.approved' group by effective_date) clearance_reset_count,       
        (SELECT to_date(:begin_date, 'mm/dd/yyyy') + ROWNUM - 1 c_date
         FROM dual
         CONNECT BY LEVEL <= to_date(:end_date, 'mm/dd/yyyy') 
                        - to_date(:begin_date, 'mm/dd/yyyy') + 1) calendar
where calendar.c_date = promo_cnt_start.st_date(+)
   and calendar.c_date = promo_cnt_end.end_date (+)
   and calendar.c_date = price_change_count.st_date(+)
   and calendar.c_date = clearance_count.st_date(+)
   and calendar.c_date = clearance_reset_count.st_date(+)
order by calendar.c_date;

