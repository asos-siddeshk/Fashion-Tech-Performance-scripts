select * from rms.skulist_head where sKULIST_DESC like '%BulkGoldSeal%';


select * from rms.skulist_head where sKULIST_DESC like 'BulkGoldSeal26%';
select * from rms.skulist_detail where skulist in (select skulist from rms.skulist_head where sKULIST_DESC like 'BulkGoldSeal26%');



create table goldseal (item varchar2(25));
select * from goldseal;

select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where trunc(CREATE_DATETIME) ='18-MAY-21';
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';

       select distinct gs.item  from goldseal gs where 
    exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U'); 
    exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U');

select * from ( select distinct gs.item  from goldseal gs where 
       not exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U') )where rownum <= '50';


Update rms.restart_program_status set PROGRAM_STATUS ='ready for start';
delete from rms.restart_bookmark;
delete from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';

   select RMS.LIST_SEQUENCE.nextval from dual;

set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;

l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist              number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM             VARCHAR2(25);
l_date             date;

CURSOR c_itemlist is
     select * from ( select distinct gs.item  from goldseal gs where 
       not exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U') )where rownum <= '25';
    
    
BEGIN
for m in 0..40 loop 

   select sysdate-m into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'BulkGoldSeal26'||'-'||l_REF_NO;
		I_filename 		:= 'BulkGoldSeal26'||'-'||l_REF_NO;

FOR i in c_itemlist Loop 
            l_item     :=i.item;

insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);

      dbms_output.put_line('1');

 END LOOP;
 END LOOP;

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/
