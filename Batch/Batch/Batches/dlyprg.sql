drop table DAILY_PURGE_b;

create table DAILY_PURGE_b as  
    select item from rms.item_master where item between '0002621140138' and '0261088580004';

select count(1) from DAILY_PURGE_b where rownum<=13500;
delete from DAILY_PURGE;
select count(1) from rms.vDAILY_PURGE;
select * from rms.DAILY_PURGE;

INSERT INTO rms.DAILY_PURGE (KEY_VALUE, TABLE_NAME, DELETE_TYPE,DELETE_ORDER)
    SELECT item ,'ITEM_MASTER' as TABLE_NAME,'D' as DELETE_TYPE ,2 as DELETE_ORDER
    FROM item_master where item_level = '1' and rownum<=25;

select count(1) from DAILY_PURGE;
select * from DAILY_PURGE;RPM_ROLLUP
delete from DAILY_PURGE_error_log;
select * from store;
select * from DAILY_PURGE;

insert into daily_purge
    select substr(to_char(dept,'0999'),2,4)||';'||substr(to_char(class, '0999'),2,4)|| ';' ||substr(to_char(subclass, '0999'),2,4) as 	        key_value,'SUBCLASS','D',1
	from rms.subclass
	where subclass ='9999' and rownum <='10';

insert into daily_purge
    select store as key_value,'STORE','D',1
    from store
    where store ='30075';