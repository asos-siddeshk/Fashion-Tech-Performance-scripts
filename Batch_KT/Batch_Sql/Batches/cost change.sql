
select * from COST_EVENT_RUN_TYPE_CONFIG;
select * from rms.COST_EVENT where EVENT_TYPE ='CC' order by 1 desc;
select * from rms.COST_EVENT_COST_CHG order by 1 desc;
select * from rms.svc_cost_susp_sup_head;
select * from rms.svc_cost_susp_sup_detail;
select * from rms.cost_susp_sup_head where trunc(active_date)='28-JAN-19' and status ='A' order by 1 desc;
select * from rms.cost_susp_sup_detail where trunc(active_date)='28-JAN-19' and status ='A' order by 1 desc;
select * from rms.cost_susp_sup_detail order by 1 desc;
select * from restart_control where program_name like 'sccext';

Update cost_susp_sup_head set status ='R' where trunc(active_date)!='02-JAN-19' and status ='A';
status ='E' and active_date ='03-DEC-18' and APPROVAL_DATE is null;

select * from rms.cost_susp_sup_detail order by 1 desc;
select * from rms.cost_susp_sup_detail order by 1 desc;

select * from rms.item_master where item_parent ='100045158';
select * from rms.future_cost where item ='3333129' order by ACTIVE_DATE desc;
select * from rms.future_cost where item ='452305' order by ACTIVE_DATE desc;


select * from cost_event_run_type_config where event_run_type ='BATCH';

    SELECT ce.cost_event_process_id
        FROM cost_event ce,
             cost_event_run_type_config cec,
             (SELECT ced.cost_event_process_id cost_event_process_id,
                     ced.deal_id key_value
                FROM cost_event_deal ced
              UNION ALL
              SELECT cecc.cost_event_process_id cost_event_process_id,
                     cecc.cost_change key_value
                FROM cost_event_cost_chg cecc
             ) cekv
       WHERE NVL(ce.override_run_type,cec.event_run_type) = 'BATCH'
         AND cec.event_type = ce.event_type
         AND ce.rowid not in (SELECT ce1.rowid
                              FROM cost_event ce1,
                                   cost_event_result cer
                             WHERE ce1.cost_event_process_id = cer.cost_event_process_id)
         AND cekv.cost_event_process_id(+) = ce.cost_event_process_id
      ORDER BY ce.cost_event_process_id;



select * from rms.COST_EVENT_RUN_TYPE_CONFIG;
update rms.COST_EVENT_RUN_TYPE_CONFIG set EVENT_RUN_TYPE ='BATCH' where event_type ='CC';

select * from cost_event_deal;

delete  FROM cost_event_deal where deal_id not in (SELECT d.deal_id
        FROM deal_head d
       where status ='A' and deal_id between 110001 and   120005 );
                
             select * from deal_head where status ='A' and deal_id between 110001 and   120005 order by 1 desc ;
                
----This script create shipment------------------------------

--Note: After this script excution created records in rms.cost_susp_sup_head,rms.cost_susp_sup_detail with status 'A'

--alter session set current_schema=rms;


set serveroutput on;
set timing on;

declare

l_PROCESS_ID                rms.svc_cost_susp_sup_head.PROCESS_ID%type;
l_CHUNK_ID                  rms.svc_cost_susp_sup_head.CHUNK_ID%type:=1;
l_ROW_SEQ                   rms.svc_cost_susp_sup_head.ROW_SEQ%type := 1;
l_ACTION                    rms.svc_cost_susp_sup_head.ACTION%type:='NEW';
l_PROCESS$STATUS            rms.svc_cost_susp_sup_head.PROCESS$STATUS%type:='N';
l_COST_CHANGE               rms.svc_cost_susp_sup_head.COST_CHANGE%type;
l_COST_CHANGE_DESC          rms.svc_cost_susp_sup_head.COST_CHANGE_DESC%type:='COST_CHANGE';
l_REASON                    rms.svc_cost_susp_sup_head.REASON%type:=10;
l_ACTIVE_DATE               rms.svc_cost_susp_sup_head.ACTIVE_DATE%type;
l_STATUS                    rms.svc_cost_susp_sup_head.STATUS%type:='A';
l_COST_CHANGE_ORIGIN        rms.svc_cost_susp_sup_head.COST_CHANGE_ORIGIN%type:='SUP';
l_SUPPLIER                  rms.svc_cost_susp_sup_detail.SUPPLIER%type;
l_ORIGIN_COUNTRY_ID         rms.svc_cost_susp_sup_detail.ORIGIN_COUNTRY_ID%type;
l_ITEM                      rms.svc_cost_susp_sup_detail.ITEM%type;
l_UNIT_COST                 rms.svc_cost_susp_sup_detail.UNIT_COST%type;
l_COST_CHANGE_TYPE          rms.svc_cost_susp_sup_detail.COST_CHANGE_TYPE%type:='F';
I_RECALC_ORD_IND            rms.svc_cost_susp_sup_detail.RECALC_ORD_IND%type:='N';
I_DEFAULT_BRACKET_IND       rms.svc_cost_susp_sup_detail.DEFAULT_BRACKET_IND%TYPE:='N';
I_TEMPLATE_KEY              rms.SVC_PROCESS_TRACKER.TEMPLATE_KEY%TYPE:='CCOST';
I_ACTION_TYPE               rms.SVC_PROCESS_TRACKER.ACTION_TYPE%TYPE:='U';
I_USER_ID                   rms.SVC_PROCESS_TRACKER.USER_ID%TYPE:='PTUSER';
L_error_message             VARCHAR2(3200);
l_datetime date;

cursor c_cost_change is
    select   RMS.CORESVC_COSTCHG_PSEQ.nextval    as PROCESS_ID,
             RMS.cc_sequence.NEXTVAL             as  COST_CHANGE, 
            im.ITEM 
        from item_supp_country isc , item_master im 
        where isc.item = im.item and item_level ='1' --and isc.supplier = '1100000086'     
        and im.status ='A' and not exists (select 1 from rms.cost_susp_sup_detail cssd where cssd.item =im.item) 
        and rownum<='1000';

cursor c_item(l_item  rms.svc_cost_susp_sup_detail.ITEM%type) is
    select   isc.SUPPLIER as SUPPLIER, 
                isc.ORIGIN_COUNTRY_ID as ORIGIN_COUNTRY_ID, 
                isc.UNIT_COST+5 as UNIT_COST          
    from item_supp_country isc 
    where isc.item =l_item;

begin

for j in 0..0 loop
	select vdate+1 into l_ACTIVE_DATE from rms.period;
	select vdate into L_DATETIME from rms.period;

for k in c_cost_change loop

l_item                          :=k.item;
l_PROCESS_ID                    :=k.PROCESS_ID;
l_COST_CHANGE                   :=k.COST_CHANGE;


		Insert into rms.svc_cost_susp_sup_head (PROCESS_ID,CHUNK_ID,ROW_SEQ,ACTION,PROCESS$STATUS,COST_CHANGE,COST_CHANGE_DESC,REASON,ACTIVE_DATE,STATUS,
		COST_CHANGE_ORIGIN,APPROVAL_DATE,APPROVAL_ID,CREATE_ID,CREATE_DATETIME,LAST_UPD_ID,LAST_UPD_DATETIME)
		values (l_PROCESS_ID,
				l_CHUNK_ID,
				l_ROW_SEQ,
				l_ACTION,
				l_PROCESS$STATUS,
				l_COST_CHANGE,
				l_COST_CHANGE_DESC ||': '||l_COST_CHANGE,
				l_REASON,
				l_ACTIVE_DATE,
				l_STATUS,
				l_COST_CHANGE_ORIGIN,
				L_DATETIME,
				'PTUSER',
				'PTUSER',
				L_DATETIME,
				'PTUSER',
				L_DATETIME);
        
for i in c_item(l_item) loop

l_SUPPLIER                      :=i.SUPPLIER;
l_ORIGIN_COUNTRY_ID             :=i.ORIGIN_COUNTRY_ID;     
l_UNIT_COST                     :=i.UNIT_COST; 

		Insert into rms.svc_cost_susp_sup_detail (PROCESS_ID,CHUNK_ID,ROW_SEQ,ACTION,PROCESS$STATUS,COST_CHANGE,SUPPLIER,ORIGIN_COUNTRY_ID,ITEM,UNIT_COST,COST_CHANGE_TYPE,
		COST_CHANGE_VALUE,RECALC_ORD_IND,DEFAULT_BRACKET_IND,CREATE_ID,CREATE_DATETIME,LAST_UPD_ID,LAST_UPD_DATETIME) 
		values (l_PROCESS_ID,
				l_CHUNK_ID,
				l_ROW_SEQ,
				l_ACTION,
				l_PROCESS$STATUS,
				l_COST_CHANGE,
				l_SUPPLIER,
				l_ORIGIN_COUNTRY_ID,
				l_ITEM,
				l_UNIT_COST,
				l_COST_CHANGE_TYPE,
				l_UNIT_COST,
				I_RECALC_ORD_IND,
				I_DEFAULT_BRACKET_IND,
				'PTUSER',
				L_DATETIME,
				'PTUSER',
				L_DATETIME);   
    l_ROW_SEQ := l_ROW_SEQ+1;
            end loop; 
   
        
        INSERT INTO rms.SVC_PROCESS_TRACKER(PROCESS_ID, PROCESS_DESC, TEMPLATE_KEY,ACTION_TYPE,ACTION_DATE,STATUS,USER_ID)
        VALUES ( l_PROCESS_ID,
                l_COST_CHANGE_DESC,
                I_TEMPLATE_KEY,
                I_ACTION_TYPE,
                L_DATETIME,
                'PS',
                I_USER_ID);
        
            if RMS.CORESVC_COSTCHG.PROCESS(L_error_message,l_PROCESS_ID)=true then

            dbms_output.put_line ('Completed: ' ||l_PROCESS_ID);   
            else 
            dbms_output.put_line ('Failed:' ||L_error_message);
            end if; 
         l_ROW_SEQ := 1; 

     end loop; 
   commit;
     end loop;
     
exception            
when others then
dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
ROLLBACK;
end;
/