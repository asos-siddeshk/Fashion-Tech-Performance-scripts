--bc8ap7wrgdu6z
select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL 
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('bc8ap7wrgdu6z','b5xa8691aym7v')
and s.snap_id = SQL.snap_id
and s.begin_interval_time> TO_date('01-oct-2020 20:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time< TO_date('02-oct-2020 04:00', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;


create table DM_XREF_STYLE_COLOUR_KEY_bk as
select * from oracnv.DM_XREF_STYLE_COLOUR_KEY;
--drop table DM_XREF_STYLE_COLOUR_KEY_bk;

select * from DM_XREF_STYLE_COLOUR_KEY_bk;

    select distinct EXT_STYLE_NUMBER, EXT_COLOUR_CODE from int_asos.INT_PE_PROM_UPLD intt
        where not exists (select 1 from oracnv.DM_XREF_STYLE_COLOUR_KEY dmt
                     WHERE dmt.style_number = intt.EXT_STYLE_NUMBER
                       AND dmt.colour_code  = intt.EXT_COLOUR_CODE);
    
--INT_PRICING_PROM_SQL.LOAD
    
select count(1) from PTITEMS where PROCESSED is null;
select count(1) from PTITEMS where PROCESSED is not null;
update PTITEMS set PROCESSED= null where PROCESSED is not null;
select * from oracnv.DM_XREF_STYLE_COLOUR_KEY where STYLE_NUMBER='1294120';

drop table PTITEMS;
create table PTITEMS as 
    select * from (SELECT distinct item_parent as item FROM ITEM_MASTER im WHERE CREATE_ID LIKE 'PTEST%' and item_level = '2'
        and exists (select 1 from rms.rpm_future_retail rfr where rfr.item = im.item_parent and rownum <='2') 
        and exists (select 1 from rms.rpm_item_loc ril where ril.item = im.item and rownum <='2') ) where rownum <= '50000';
    
alter table PTITEMS add (Processed varchar2(2));
select count (distinct (item)) from PTITEMS;

--36739
SET SERVEROUTPUT ON;
SET timing ON;
DECLARE
   l_EXT_STYLE_NUMBER   int_asos.INT_PE_PROM_UPLD.EXT_STYLE_NUMBER%type;
   l_EXT_COLOUR_CODE    int_asos.INT_PE_PROM_UPLD.EXT_COLOUR_CODE%type;
   O_rms_item           rms.item_Master.item%type;

  CURSOR C_Item_missing IS
    select distinct EXT_STYLE_NUMBER, EXT_COLOUR_CODE from int_asos.INT_PE_PROM_UPLD intt
        where not exists (select 1 from oracnv.DM_XREF_STYLE_COLOUR_KEY dmt
                     WHERE dmt.style_number = intt.EXT_STYLE_NUMBER
                       AND dmt.colour_code  = intt.EXT_COLOUR_CODE);

  CURSOR C_get_item_option IS
    SELECT item
      FROM PTITEMS where processed is null and rownum <='1';


BEGIN

     FOR rec in C_Item_missing LOOP
        l_EXT_STYLE_NUMBER := rec.EXT_STYLE_NUMBER;
        l_EXT_COLOUR_CODE  := rec.EXT_COLOUR_CODE;
        
          OPEN C_get_item_option;
              FETCH C_get_item_option INTO O_rms_item;
              IF C_get_item_option%NOTFOUND THEN
                CLOSE C_get_item_option;
              END IF;
              CLOSE C_get_item_option;

        MERGE INTO ORACNV.DM_XREF_STYLE_COLOUR_KEY s1 
            USING ( select l_EXT_STYLE_NUMBER as STYLE_NUMBER, l_EXT_COLOUR_CODE as  COLOUR_CODE, O_rms_item as ITEM from dual)  s2 
                ON (s1.STYLE_NUMBER = s2.STYLE_NUMBER and s1.COLOUR_CODE = s2.COLOUR_CODE) 
        WHEN MATCHED THEN UPDATE SET s1.ITEM = s2.ITEM  
        WHEN NOT MATCHED THEN INSERT (DEPARTMENT_NUMBER, ITEM, COLOUR_CODE, STYLE_NUMBER, CREATE_DATE)
            values ( '009', s2.ITEM , s2.COLOUR_CODE,s2.STYLE_NUMBER, sysdate);
    
            update PTITEMS set processed='P' where item = O_rms_item;
            O_rms_item := null;
            l_EXT_STYLE_NUMBER := null;
            l_EXT_COLOUR_CODE := null;
            
end loop;    

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('An error was encountered: '||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

--clean up deadlock
--delete from int_asos.int_pe_simple_promo_stg where INT_STATUS = 'P';
delete from int_asos.int_pe_simple_promo_stg where INT_STATUS = 'P' and (ITEM, ZONE_ID) in (select ITEM, ZONE_ID from  rpm_stage_simple_promo where status = 'F');
delete from  rpm_stage_simple_promo where status = 'F';

--clean up pre batch failure
delete FROM int_asos.int_pe_simple_promo_stg
            WHERE rowid not in
            (SELECT MIN(rowid)
            FROM int_asos.int_pe_simple_promo_stg
            GROUP BY STAGE_SIMPLE_PROMO_ID);

