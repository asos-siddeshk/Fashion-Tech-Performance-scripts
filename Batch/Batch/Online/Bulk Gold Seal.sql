select * from all_tables where table_name like '%BULK%';

create table bulk_gold_item  (item varchar2(25));
truncate table bulk_gold_item;


SELECT DISTINCT REF_NO, FILENAME
      FROM int_asos.INT_PL_ITEMLIST_UPLD_STG
      WHERE STATUS = 'U';
      
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);
select * from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';
delete  from int_asos.INT_PL_ITEMLIST_UPLD_STG where status ='U';


Update rms.restart_program_status set PROGRAM_STATUS ='ready for start';
delete from rms.restart_bookmark;

     select distinct gs.item  from bulk_gold_item gs where --rownum <= '10' and 
        not exists (select 1 from rms.skulist_head sh, skulist_detail sd where sh.sKULIST_DESC like 'Bulk Gold seal%' and sh.SKULIST = sd.SKULIST and sd.item = gs.item) ;
        
        and not exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U');


select * from skulist_head where SKULIST_DESC like '%Gold%';
select * from skulist_head where SKULIST_DESC like 'BulkGoldSeal%';
select * from rms.skulist_detail where skulist in (select skulist from rms.skulist_head where sKULIST_DESC like 'BulkGoldSeal%');

delete from rms.skulist_head where sKULIST_DESC like 'BulkGoldSeal%';
delete from rms.skulist_detail where skulist in (select skulist from rms.skulist_head where sKULIST_DESC like 'BulkGoldSeal%');
delete from rms.skulist_criteria where skulist in (select skulist from rms.skulist_head where sKULIST_DESC like 'BulkGoldSeal%');



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
     select distinct gs.item  from bulk_gold_item gs where rownum <= '15' 
        --and not exists (select 1 from rms.skulist_head sh, skulist_detail sd where sh.sKULIST_DESC like 'Bulk Gold seal%' and sh.SKULIST = sd.SKULIST and sd.item = gs.item) 
        and not exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U');
    
BEGIN
for m in 0..100 loop 

   select sysdate-m into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'BulkGoldSeal'||'-'||l_REF_NO;
		I_filename 		:= 'BulkGoldSeal'||'-'||l_REF_NO;

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

 END LOOP;
 END LOOP;


EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/