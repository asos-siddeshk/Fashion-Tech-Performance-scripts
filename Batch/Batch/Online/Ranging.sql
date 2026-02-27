drop table item_loc_ranging;
create table item_loc_ranging as
    select * from item_master_op where rownum <= '10';

select im2.item,'20015',im2.item_level from item_loc_ranging im, item_master im2 where im.item = im2.item or im2.item_parent = im.item;

desc item_loc_ranging;

drop table ranging_status;
create table ranging_status(item VARCHAR2(25), error_msg varchar2(255)); 





SET timing ON;
SET SERVEROUTPUT ON;
DECLARE
   O_error_message     VARCHAR2(255) := NULL;
   c_commit  	       NUMBER(8):= 0;
   l_item              VARCHAR2(25);

   Cursor C_GET_ITEMS is
            select item from item_options;   
BEGIN

 FOR i in C_GET_ITEMS LOOP
                       l_item := i.item;

    if NEW_ITEM_LOC(O_error_message,l_item,
'30022',
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
sysdate,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null) = FALSE then
            
                    insert into skumar.ranging_status values (l_item,L_error_message);
                  else 
                    continue;
                  end if;   
            
--     c_commit :=c_commit + 1;
--   IF MOD(c_commit, 1000) = 0 THEN
--    COMMIT;
--   END IF;

   END LOOP;
    COMMIT;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/





SET timing ON;
SET SERVEROUTPUT ON;
DECLARE
   O_error_message     VARCHAR2(255) := NULL;
   c_commit  	       NUMBER(8):= 0;
   l_item              VARCHAR2(25);

   Cursor C_GET_ITEMS is
            select item from item_options WHERE ITEM = '100008484';

  TYPE l_item_ids_t IS TABLE OF item_master.item%TYPE;
       l_item_ids        l_item_ids_t;
   
BEGIN
   OPEN C_GET_ITEMS;
   LOOP 
      FETCH C_GET_ITEMS BULK COLLECT INTO l_item_ids LIMIT 100;
      EXIT WHEN l_item_ids.count = 0;

        FOR idx IN l_item_ids.FIRST.. l_item_ids.LAST
        LOOP
            l_item := l_item_ids(idx);

      if NEW_ITEM_LOC(O_error_message,
                      l_item_ids(idx),
                      '30022',
                      NULL, NULL, null, NULL,
                      NULL, NULL, NULL,
                      NULL, NULL,
                      NULL, NULL, NULL, NULL,
                      NULL,
                      NULL, NULL, NULL, NULL, NULL, NULL,
                      NULL, NULL, NULL, NULL, NULL, NULL,
                      NULL, NULL, NULL, NULL, NULL, NULL,
                      NULL, NULL, NULL, NULL, NULL) = FALSE then
            insert into skumar.ranging_status values (l_item,L_error_message);
       else  
            continue;
    end if;   
            
   END LOOP;
   END LOOP;
   COMMIT;

EXCEPTION
   when OTHERS THEN
      dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/

100	30022
100	30029
100	30013
102	30025
102	30026
117	30076
118	30077

select * from rms.rpm_zone_location order by 2,3;

select * from RMS.STORE;

select LOC,COUNT(1) from rms.item_loc where loc in (select store from rms.store where STORE_TYPE = 'F') 
    and item_parent is null 
    GROUP BY LOC;

select LOC,count(*) from rms.item_loc where loc in (select store from rms.store where STORE_TYPE = 'F') 
    and item_parent is null 
    GROUP BY LOC;

select count(1) from rms.rpm_item_loc where loc in (select store from rms.store where STORE_TYPE = 'F');
select * from all_tables where table_name like '%RED%';
select distinct item from skumar.processed_item pi where status ='R' order by 1 ;        

select * from item_loc where loc in (select store from store where store between 30013 and 30078)  
    AND ITEM IN (SELECT ITEM FROM ITEM_MASTER WHERE ITEM = '100008484' OR ITEM_PARENT = '100008484');

select * from item_loc where loc in (select store from store where store between 30013 and 30078);
select item from item_options;
select * from rms.rpm_zone_location order by 2,3;

select count(im2.item)  from skumar.item_options im, rms.item_master im2  where im.item = im2.item or im2.item_parent = im.item;
          
select * from item_options iop where not exists (select 1 from rms.item_loc where il.item = iop.item and il.loc = '');

select * from rms.rpm_zone_location where locATION in (select store from rms.store where STORE_TYPE = 'F') order by 2,3;

SELECT * FROM DBA_SOURCE WHERE TEXT LIKE '%NEW_ITEM_LOC%';