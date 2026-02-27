/*                                         
---------------------------Batch name:RMS.admin_api_purge----------------------------------

1.Bulk inserted the records to the tables								      :SVC_PROCESS_TRACKER (Transaction volume:*** records)
2.PL/SQL script execution that will insert the records to the staging table   :rms.svc_cost_susp_sup_head,rms.svc_cost_susp_sup_detail,
                                                                               rms.SVC_PROCESS_TRACKER
3.Batch execution 															  :RMS.admin_api_purge via Automic&Putty.
----------------------------------------------------------------------------------------------*/
--alter session set current_schema=rms;
select * from SVC_PROCESS_TRACKER where file_id in (select file_id from rms.S9T_FOLDER);
select * from rms.S9T_FOLDER;


      select process_id
        from rms.svc_process_tracker
       where  process_destination in('RESA','RMS')
        and (status ='PS'
          or (status = 'PE' and
              action_date < (SYSDATE - '5')))
         and template_key in (select template_key
                                   from rms.s9t_template
                                  where template_type in (select code
                                                            from rms.code_detail
                                                           where code_type in('RMST','RSAT')));

      select process_id
        from rms.svc_process_tracker
       where  process_destination in('RESA','RMS')
        and (status ='PS'
          or (status = 'PE' and
              action_date < (SYSDATE - '7')))
         and template_key in (select template_key
                                   from rms.s9t_template
                                  where template_type in (select code
                                                            from rms.code_detail
                                                           where code_type in('RMST','RSAT')));

set serveroutput on;
set timing on;

declare

l_FILE_ID                rms.SVC_PROCESS_TRACKER.PROCESS_ID%type;
l_PROCESS_ID                rms.SVC_PROCESS_TRACKER.PROCESS_ID%type;
l_PROCESS_DESC              rms.SVC_PROCESS_TRACKER.PROCESS_DESC%TYPE;
l_template_key              rms.SVC_PROCESS_TRACKER.TEMPLATE_KEY%TYPE;
l_date                      rms.period.vdate%TYPE;

cursor c_template is
		select 	RMS.CORESVC_COSTCHG_PSEQ.nextval as PROCESS_ID,
					st.template_key||'_DESC'     			 as PROCESS_DESC,
					st.template_key,
                    rms.S9T_FOLDER_SEQ.nextval as folder_id
			from rms.s9t_template st,rms.period p
			where template_type in (select code
									from rms.code_detail
								   where code_type in('RMST','RSAT')) ;
   
             
begin
for j in 0..2 loop
for k in 0..10 loop
select sysdate-k into l_date from dual;

    for i in c_template loop

		l_PROCESS_ID                    :=i.PROCESS_ID;
		l_PROCESS_DESC				    :=i.PROCESS_DESC;
		l_template_key				    :=i.template_key;
		l_FILE_ID				        :=i.folder_id;
		
        

INSERT INTO rms.SVC_PROCESS_TRACKER(
										PROCESS_ID,
										PROCESS_DESC,
										TEMPLATE_KEY,
										ACTION_TYPE,
										PROCESS_SOURCE,
										PROCESS_DESTINATION,
										ACTION_DATE,
										STATUS,
										USER_ID,
                                        file_id)
VALUES                                   (l_PROCESS_ID,
										l_PROCESS_DESC,
										l_template_key,
										'U',
										'EXT',
										'RMS',
										l_date,
										'PS',
										'PTESTUSER',
                                        l_FILE_ID);
                                        
    insert into S9T_FOLDER (FILE_ID, FILE_NAME, TEMPLATE_KEY, USER_LANG, ODS_BLOB, CREATE_ID, CREATE_DATETIME, S9T_FILE_OBJ)    
    values (l_FILE_ID,
            l_PROCESS_DESC||'.ods',
            l_template_key,
            '1',
            null,
            l_date,
            'PTESTUSER',
            null); 
    
    
end loop;
end loop;
end loop;

exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
end;
/

/* TESTING;
-------
SELECT * from rms.SVC_PROCESS_TRACKER;  */

