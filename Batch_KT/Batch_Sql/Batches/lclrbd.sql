select * from rms.LOC_LIST_HEAD;
select * from rms.loc_list_criteria;
select * from rms.LOC_LIST_DETAIL where loc_list not in (1,5053);


/*
---------------------------Batch name:RMS.lclrbld----------------------------------
2.Records to be updated in costevent tables								:rms.lclrbld. 
3.Batch execution 														:RMS.lclrbld via Automic.
--------------------------------------------------------------------------------------------------
*/


set serveroutput on;
set timing on;

declare
	l_loc_list     Rms.Loc_List_Head.loc_list%type;	
	   
cursor C_LOC_LIST is
	 select loc_list  from Rms.Loc_List_Head where loc_list not 
				in (select loc_list from rms.loc_list_criteria);
		
begin
begin
for i in 1 .. 1 ---- change the valume wise records here 
loop    
begin
insert into rms.LOC_LIST_HEAD(
							 LOC_LIST,
							 LOC_LIST_DESC,
							 CREATE_DATE,
							 CREATE_ID,
							 STATIC_IND,
							 BATCH_REBUILD_IND,    
							 LAST_REBUILD_DATE,
							 USER_SECURITY_IND,
							 SOURCE,
							 COMMENT_DESC,
							 FILTER_ORG_ID) 
values(
							RMS.LOC_LIST_SEQUENCE.nextval,
							'Location list',
							SYSDATE,
							'PTUSER' ,
							'N',
							'Y',
							SYSDATE,
							'N',
							'RMS',
							'Location list rebuild',
							1); 
dbms_output.put_line( 'LOC_LIST ' || i );
exception	
when others then
    dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);

      ROLLBACK;
end;
end loop;
end;
 
for i in C_LOC_LIST loop 

l_loc_list:=i.loc_list;
    
   Insert into rms.loc_list_criteria (LOC_LIST,LOC_TYPE,SEQ_NO,
                                      OPEN_PARENTHESIS,
                                      ELEMENT,
                                      COMPARISON,
                                      VALUE,
                                      CLOSE_PARENTHESIS,
                                      LOGIC_OPERATION,
                                      RELATED_VALUE) 
								values (l_loc_list,
										'S',
										1,
										'(',
										'LNG',
										'EQ',
										'1',
										')',
										null,
										null);
		end loop;
 
exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/


testing 
-------
select * from rms.LOC_LIST_HEAD;
select * from rms.loc_list_criteria;
select * from rms.LOC_LIST_DETAIL ;