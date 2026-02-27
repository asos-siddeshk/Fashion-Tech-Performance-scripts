select * from all_sequences where sequence_name like 'RPM_PROMO%';

RPM_PROMO_SEQ	751829

select * from rpm_promo where PROMO_ID >= '751829';
select * from all_sequences;
select PROMO_ID from rms.rpm_promo_hist;

select count(1) from rms.RPM_PROMO where promo_id in (select PROMO_ID from rms.rpm_promo_hist);
select count(1) from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist);
select count(1) from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist));
select count(1) from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
select count(1) from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist))));
select count(1) from rms.RPM_PROMO_DTL_MERCH_NODE where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
select count(1) from rms.RPM_PROMO_ZONE_LOCATION where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
select count(1) from rms.RPM_PROMO_DTL_DISC_LADDER where promo_dtl_list_id in (select promo_dtl_list_id from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)))));

select * from promo_arc where L_error_message not like '%S%';


create table RPM_PROMO_DTL_DISC_LADDER_bk as
select * from rms.RPM_PROMO_DTL_DISC_LADDER where promo_dtl_list_id in (select promo_dtl_list_id from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)))));
delete from rms.RPM_PROMO_DTL_DISC_LADDER where promo_dtl_list_id in (select promo_dtl_list_id from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)))));

create table RPM_PROMO_ZONE_LOCATION_BK as
select * from rms.RPM_PROMO_ZONE_LOCATION where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)));
delete from rms.RPM_PROMO_ZONE_LOCATION where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)));

create table RPM_PROMO_DTL_MERCH_NODE_bk as
select * from rms.RPM_PROMO_DTL_MERCH_NODE where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)));
delete from rms.RPM_PROMO_DTL_MERCH_NODE where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)));

create table RPM_PROMO_DTL_LIST_BK as
select * from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist))));
delete from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist))));

create table RPM_PROMO_DTL_LIST_GRP_BK as
select * from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)));
delete from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_hist)));


create table RPM_PROMO_DTL_BK as
select * from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist));
delete from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist));

create table RPM_PROMO_COMP_BK as
select *from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist);
delete from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist);

create table RPM_PROMO_BK as
select * from rms.RPM_PROMO where promo_id in (select PROMO_ID from rms.rpm_promo_hist);
delete from rms.RPM_PROMO where promo_id in (select PROMO_ID from rms.rpm_promo_hist);


delete from rms.RPM_PROMO where promo_id in (select PROMO_ID from rms.rpm_promo_hist);
delete from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist);
delete from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist));
delete from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
delete from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist))));
delete from rms.RPM_PROMO_DTL_MERCH_NODE where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
delete from rms.RPM_PROMO_ZONE_LOCATION where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)));
delete from rms.RPM_PROMO_DTL_DISC_LADDER where promo_dtl_list_id in (select promo_dtl_list_id from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.rpm_promo_comp_hist)))));


  
select * from  promo_check;
  
drop table promo_arc;
create table promo_arc (promo_id NUMBER(10) ,error_message varchar(255));

select rp.PROMO_ID,rpc.PROMO_COMP_ID,count(1) from rpm_promo rp, rpm_promo_comp rpc where rp.promo_id  in (select promo_id from promo_check)
    AND rp.PROMO_ID =rpc.PROMO_ID group by rp.PROMO_ID,rpc.PROMO_COMP_ID;

Drop table  promo_check;
create table promo_check as
select node.item,
       NVL(rzl.location, rzl.zone_id) loc,rp.promo_id, rp.promo_display_id, comp.PROMO_COMP_ID, comp.comp_display_id, comp.customer_type, 
       dtl.promo_dtl_id,dtl.promo_dtl_display_id, dtl.start_date, dtl.end_date,
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
and im.item = '100000001'
--and dtl.PROMO_DTL_ID in (select PROMO_DTL_ID from int_asos.int_pe_simple_promo_stg)
and dtl.promo_dtl_id = expl.promo_dtl_id(+)
order by node.item, rzl.location, approval_date desc, dtl.start_date;


set SERVEROUTPUT ON;
set timing ON;
  DECLARE
  
        L_return_code   varchar2(5)   := null;
        L_error_message varchar2(255) := null;
     l_promo_id     rms.rpm_promo.PROMO_ID%type;
        COUNTER_COMMIT  NUMBER(8)     := 1;
        
     cursor c_get_promo is
           select PROMO_ID from rms.rpm_promo where promo_id not in (select PROMO_ID from ) 

      BEGIN
        FOR cust_ma in c_get_promo Loop
		l_promo_id			:= cust_ma.PROMO_ID; 
         --L_vdate := TO_DATE('20181014', 'YYYYMMDD');

         if rms.RPM_ARCHIVE_PROMOTIONS.ARCHIVE(l_promo_id,L_error_message) = '0' THEN
         
        Update promo_arc set L_error_message= L_error_message where promo_id =l_promo_id;
         else.
        Update promo_arc set L_error_message='S' where promo_id =l_promo_id;

         end if;
       
       	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;	
               
        end loop;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

select * from promo_arc;



drop table RPM_PROMO_DTL_DISC_LADDER_bk;
create table RPM_PROMO_DTL_DISC_LADDER_bk as
select * from rms.RPM_PROMO_DTL_DISC_LADDER ;
delete from rms.RPM_PROMO_DTL_DISC_LADDER where promo_dtl_list_id in (select promo_dtl_list_id from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18')))));

drop table RPM_PROMO_ZONE_LOCATION_BK;
create table RPM_PROMO_ZONE_LOCATION_BK as
select * from rms.RPM_PROMO_ZONE_LOCATION ;
delete from rms.RPM_PROMO_ZONE_LOCATION where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18')));

drop table RPM_PROMO_DTL_MERCH_NODE_bk;
create table RPM_PROMO_DTL_MERCH_NODE_bk as
select * from rms.RPM_PROMO_DTL_MERCH_NODE;
delete from rms.RPM_PROMO_DTL_MERCH_NODE where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18')));

drop table RPM_PROMO_DTL_LIST_BK;
create table RPM_PROMO_DTL_LIST_BK as
select * from rms.RPM_PROMO_DTL_LIST ;
delete from rms.RPM_PROMO_DTL_LIST where promo_dtl_list_grp_id in (select promo_dtl_list_grp_id from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18'))));

drop table RPM_PROMO_DTL_LIST_GRP_BK;
create table RPM_PROMO_DTL_LIST_GRP_BK as
select * from rms.RPM_PROMO_DTL_LIST_GRP ;
delete from rms.RPM_PROMO_DTL_LIST_GRP where PROMO_DTL_ID in (select PROMO_DTL_ID from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18')));

drop table RPM_PROMO_DTL_BK;
create table RPM_PROMO_DTL_BK as
select * from rms.RPM_PROMO_DTL ;
delete from rms.RPM_PROMO_DTL where PROMO_COMP_ID in (select PROMO_COMP_ID from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18'));

drop table RPM_PROMO_COMP_BK;
create table RPM_PROMO_COMP_BK as
select *from rms.RPM_PROMO_COMP;
delete from rms.RPM_PROMO_COMP where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18');

drop table RPM_PROMO_BK;
create table RPM_PROMO_BK as
select * from rms.RPM_PROMO ;
delete from rms.RPM_PROMO where promo_id in (select PROMO_ID from rms.RPM_PROMO where END_DATE <= '15-NOV-18');

   commit;
   