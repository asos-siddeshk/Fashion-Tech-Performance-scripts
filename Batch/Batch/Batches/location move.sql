
delete from rms.rpm_location_move;
select * from rms.rpm_location_move;
select * from rms.period;

select   * from rms.rpm_zone;    
select   * from rms.rpm_zone_location where location ='20002';

select * from all_tables where table_name like '%MOVE%';


select * from rms.RPM_LOCATION_MOVE;
select * from rms.RPM_LOCATION_MOVE_ERROR;
select * from rms.RPM_LOCATION_MOVE_TASK;
select * from rms.RPM_LOC_MOVE_CLEARANCE_EX;
select * from rms.RPM_LOC_MOVE_PRC_CHNG_EX;
select * from rms.RPM_LOC_MOVE_PRC_STRT_ERR;
select * from rms.RPM_LOC_MOVE_PROMO_COMP_DTL_EX;
select * from rms.RPM_LOC_MOVE_PROMO_ERROR;
select * from rms.RPM_LOC_MOVE_PS_OVRLP_ERR;

   
    
set serveroutput on;
set timing on;

declare
	l_location_move_id  	rms.rpm_location_move.location_move_id%type;
	l_location_display_id  	rms.rpm_location_move.location_move_display_id%type;

	cursor c_move is
	 select   ZONE_LOCATION_ID,location,loc_type,zone_id as old_zone_id ,decode(ZONE_ID,101,100,100,101,null) as new_zone_id ,p.vdate+1 as effective_date
            from rms.rpm_zone_location, rms.period p
        where location ='20002';
    
    r_move c_move%ROWTYPE;

Begin 
  open c_move;
  loop 
  fetch c_move into r_move;
        exit when c_move%notfound;

  select RPM_LOCATION_MOVE_SEQ.nextval       into l_location_move_id from dual;
  select RPM_LOC_MOVE_DISPLAY_ID_SEQ.nextval into l_location_display_id from dual;
	
	
	insert into rms.rpm_location_move
										(location_move_id,
										 location_move_display_id,
										 state,
										 zone_location_id,
										 location,
										 loc_type,
										 old_zone_id,
										 new_zone_id,
										 effective_date) 
				
	values 		(l_location_move_id,
				 l_location_display_id,
				 'locationMoveRequest.state.approved',
				 r_move.zone_location_id,
				 r_move.location,
				 r_move.loc_type,
				 r_move.old_zone_id,
				 r_move.new_zone_id,
				 r_move.effective_date);

end loop;				 
close c_move;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;
end;
/
