  select tbl.rule_package_name,
         tbl.rule_execute_name,
         tbl.from_loc,
         tbl.from_loc_type,
         tbl.to_loc,
         tbl.to_loc_type,
         tbl.execution_order,
         tbl.rule_control_id
    from (select nrch.rule_package_name,
                 nrch.rule_package_name || '.' || nrch.pre_function_name rule_execute_name,
                 nrch.from_loc,
                 nrch.from_loc_type,
                 nrch.to_loc,
                 nrch.to_loc_type,
                 0 execution_order,
                 nrch.rule_control_id
            from nb_rules_control_head nrch
           where get_vdate              between nrch.start_date and nrch.end_date
             and nrch.pre_function_name is not null
           union all
          select nrch.rule_package_name,
                 nrch.rule_package_name || '.' || nrcd.rule_function_name rule_execute_name,
                 nrch.from_loc,
                 nrch.from_loc_type,
                 nrch.to_loc,
                 nrch.to_loc_type,
                 nrcd.execution_order,
                 nrch.rule_control_id
            from nb_rules_control_head nrch,
                 nb_rules_control_detail nrcd
           where nrch.rule_control_id    = nrcd.rule_control_id
             and nrcd.active_ind         = 'Y'
             and get_vdate               between nrch.start_date and nrch.end_date
             and nrch.post_function_name is not null
             and nrch.pre_function_name  is not null
           union all
          select nrch.rule_package_name,
                 nrch.rule_package_name || '.' || nrch.post_function_name rule_execute_name,
                 nrch.from_loc,
                 nrch.from_loc_type,
                 nrch.to_loc,
                 nrch.to_loc_type,
                 null execution_order,
                 nrch.rule_control_id
            from nb_rules_control_head nrch
           where get_vdate               between nrch.start_date and nrch.end_date
             and nrch.post_function_name is not null
         ) tbl
   group by tbl.rule_package_name,
            tbl.rule_execute_name,
            tbl.from_loc,
            tbl.from_loc_type,
            tbl.to_loc,
            tbl.to_loc_type,
            tbl.execution_order,
            tbl.rule_control_id
   order by tbl.rule_control_id,
            tbl.execution_order asc nulls last;



SELECT * FROM nb_rules_control_head ;
UPDATE nb_rules_control_head SET START_DATE = '08-MAY-2020',END_DATE = '10-MAY-2021';

UPDATE nb_rules_control_head SET START_DATE = null,END_DATE = null;



NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.PRE_PROCESS_ORPHAN	    3001	W	1001	W	0	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.CHECK_TSF_EXPECTED_QTY	3001	W	1001	W	1	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.CHECK_IN_TRANSIT_QTY	    3001	W	1001	W	2	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.CHECK_AQL_INV_STATUS_QTY	3001	W	1001	W	3	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.CHECK_ASN_FOB	            3001	W	1001	W	4	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.CHECK_ASN_DDP	            3001	W	1001	W	5	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.CHECK_RETURN_STOCK	    3001	W	1001	W	6	1
NB_ORPHAN_SKU_SQL	NB_ORPHAN_SKU_SQL.POST_PROCESS_ORPHAN	    3001	W	1001	W		1

update nb_item_loc_zero_avail_days set TOTAL_COUNT =4 where MAX_DAYS is null;

select * from nb_item_loc_zero_avail_days;
select * from nb_orphan_gtt;

select * from int_asos.int_stg_man_tsf_upld;

DECLARE
  O_ERROR_MESSAGE VARCHAR2(255);
  I_FROM_LOC NUMBER;
  I_TO_LOC NUMBER;
  v_Return BOOLEAN;
BEGIN

for m in 0..0 loop
  O_ERROR_MESSAGE := NULL;
  I_FROM_LOC := 3001;
  I_TO_LOC := 1001;

  v_Return := RMS.NB_ORPHAN_SKU_SQL.PRE_PROCESS_ORPHAN(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_FROM_LOC => I_FROM_LOC,
    I_TO_LOC => I_TO_LOC);
 
IF (v_Return) THEN 
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'FALSE');
  END IF;

DBMS_OUTPUT.PUT_LINE('O_ERROR_MESSAGE = ' || O_ERROR_MESSAGE);
end loop;

END;