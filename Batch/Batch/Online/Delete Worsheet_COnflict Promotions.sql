select * from rpm_promo;

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


select PROMO_DTL_ID from promo_check;

set serveroutput on;
set timing on;
DECLARE

   l_promo_dtl_id               NUMBER (10) := NULL;
   l_promo_dtl_list_id          NUMBER (10) := NULL;

   CURSOR c_get_dtl_list IS
      SELECT promo_dtl_list_id,promo_dtl_id
        FROM rpm_promo_dtl_merch_node
       WHERE promo_dtl_id  in (select promo_dtl_id from RPM_PROMO_DTL where promo_dtl_id in (select PROMO_DTL_ID from promo_check) and state ='0');

BEGIN

FOR L_loop in c_get_dtl_list
	Loop 
		l_promo_dtl_id:=L_loop.promo_dtl_id;
		l_promo_dtl_list_id:=L_loop.promo_dtl_list_id;
	

		INSERT INTO RPM_PROMO_DTL_DISC_LADDER_bk
        SELECT *
          FROM rpm_promo_dtl_disc_ladder
         WHERE promo_dtl_list_id = l_promo_dtl_list_id;

      INSERT INTO RPM_PROMO_DTL_MERCH_NODE_bk
        SELECT *
          FROM rpm_promo_dtl_merch_node
         WHERE promo_dtl_id = l_promo_dtl_id;

      INSERT INTO RPM_PROMO_DTL_LIST_BK
        SELECT *
          FROM rpm_promo_dtl_list
         WHERE promo_dtl_list_id = l_promo_dtl_list_id;

      INSERT INTO RPM_PROMO_DTL_LIST_GRP_BK
        SELECT *
          FROM rpm_promo_dtl_list_grp
         WHERE promo_dtl_id = l_promo_dtl_id;

      INSERT INTO RPM_PROMO_ZONE_LOCATION_BK
        SELECT *
          FROM rpm_promo_zone_location
         WHERE promo_dtl_id = l_promo_dtl_id;

      INSERT INTO RPM_PROMO_DTL_BK
        SELECT *
          FROM rpm_promo_dtl
         WHERE promo_dtl_id = l_promo_dtl_id;

      DELETE
        FROM rpm_promo_dtl_disc_ladder
       WHERE promo_dtl_list_id = l_promo_dtl_list_id;

      DELETE
        FROM rpm_promo_dtl_merch_node
       WHERE promo_dtl_id = l_promo_dtl_id;

      DELETE
        FROM rpm_promo_dtl_list
       WHERE promo_dtl_list_id = l_promo_dtl_list_id;

      DELETE
        FROM rpm_promo_dtl_list_grp
       WHERE promo_dtl_id = l_promo_dtl_id;

      DELETE
        FROM rpm_promo_zone_location
       WHERE promo_dtl_id = l_promo_dtl_id;

      DELETE
        FROM rpm_promo_dtl
       WHERE promo_dtl_id = l_promo_dtl_id;


	END LOOP;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line(TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/