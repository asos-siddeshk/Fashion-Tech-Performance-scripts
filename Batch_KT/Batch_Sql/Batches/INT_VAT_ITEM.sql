select count(distinct(item)) from int_asos.INT_VAT_ITEM; --6300232
select count(1) from int_asos.INT_VAT_ITEM; --6300232


select im.item from item_master im where item_level = '1'  --and --CREATE_ID != 'ORACNV'
    and exists (select 1 from INT_ASOS.INT_VAT_ITEM ivt where ivt.item = im.item) ;

select * from vat_item where item in 
(select item from item_master where item ='100008785' or item_parent = '100008785') and vat_code = 'IEGS';

update vat_item set VAT_RATE= '29',LAST_UPDATE_DATETIME=sysdate,LAST_UPDATE_ID='SKUMAR' where item in  
    (select item from item_master where item ='100008785' or item_parent = '100008785') and vat_code = 'IEGS';

select * from rms.restart_program_status where PROGRAM_STATUS!='ready for start';

select THREAD_VAL, PROGRAM_NAME, to_char(START_TIME,'dd-mon-yy hh:mi:ss am') START_TIME,
    to_char(FINISH_TIME,'dd-mon-yy hh:mi:ss am') FINISH_TIME 
from rms.restart_program_history where program_name like '%nb_vatupd%' order by 1 ;

select * from rms.restart_program_status where program_name like '%vat%';
select * from rms.restart_bookmark where restart_name like '%nb_vat%';

Update rms.restart_program_status set PROGRAM_STATUS ='ready for start' where program_name like '%nb_vatupd%';
delete from rms.restart_bookmark where restart_name like '%nb_vatupd%';

select * from rms.restart_bookmark;

./nb_vatupd userid/passwd /orabin/app/oracle/product/retail/batch/external/data/out full

   2092740 nb_vatupdates_20201002114051_10_16_full.dat
   2091893 nb_vatupdates_20201002114051_11_16_full.dat
   2090840 nb_vatupdates_20201002114051_1_16_full.dat
   2088731 nb_vatupdates_20201002114051_12_16_full.dat
   2086167 nb_vatupdates_20201002114051_13_16_full.dat
   2088741 nb_vatupdates_20201002114051_14_16_full.dat
   2090775 nb_vatupdates_20201002114051_15_16_full.dat
   2091932 nb_vatupdates_20201002114051_2_16_full.dat
   2090240 nb_vatupdates_20201002114051_3_16_full.dat
   2089716 nb_vatupdates_20201002114051_4_16_full.dat
   2086587 nb_vatupdates_20201002114051_5_16_full.dat
   2086146 nb_vatupdates_20201002114051_6_16_full.dat
   2089862 nb_vatupdates_20201002114051_7_16_full.dat
   2089677 nb_vatupdates_20201002114051_8_16_full.dat
   2093174 nb_vatupdates_20201002114051_9_16_full.dat
   2088651 nb_vatupdates_20201002114052_16_16_full.dat
    33435872
    select 33316780-33435872 from dual; ---119092
select 951908*35 from dual; --2020048.23529411764705882352941176470588
select * from vat_item where item ='100021380';
select count(1) from item_master where item_level ='1'; -- 951475

select item_level,count(1) from rms.item_master group by item_level;

./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &
./nb_vatupd $UP /orabin/app/oracle/product/retail/batch/external/data/out full &


/asos/oracle/vpt/data/outbound/Integration/VAT_Updates/pending



chmod 777 nb_vatupdates_20201002114051_14_16_full.dat
chmod 777 nb_vatupdates_20201002114051_8_16_full.dat
chmod 777 nb_vatupdates_20201002114051_3_16_full.dat
chmod 777 nb_vatupdates_20201002114051_12_16_full.dat
chmod 777 nb_vatupdates_20201002114051_9_16_full.dat
chmod 777 nb_vatupdates_20201002114051_5_16_full.dat
chmod 777 nb_vatupdates_20201002114051_10_16_full.dat
chmod 777 nb_vatupdates_20201002114051_6_16_full.dat
chmod 777 nb_vatupdates_20201002114051_13_16_full.dat
chmod 777 nb_vatupdates_20201002114051_7_16_full.dat
chmod 777 nb_vatupdates_20201002114051_15_16_full.dat
chmod 777 nb_vatupdates_20201002114051_4_16_full.dat
chmod 777 nb_vatupdates_20201002114051_11_16_full.dat
chmod 777 nb_vatupdates_20201002114051_2_16_full.dat
chmod 777 nb_vatupdates_20201002114052_16_16_full.dat
chmod 777 nb_vatupdates_20201002114051_1_16_full.dat


grep -i '100001360' ./*



/orabin/app/oracle/product/retail/batch/external/data/out


select * from dba_source where text like '%INT_VAT_ITEM%';

select count(1) from vat_item where item in (select distinct item from INT_ASOS.INT_VAT_ITEM);
select count(1) from INT_ASOS.INT_VAT_ITEM;


select int_asos.INT_VAT_ITEM_SEQ.NEXTVAL,'N', from dual;

select * from INT_ASOS.INT_VAT_ITEM;
select * from vat_item where item not in (select distinct item from INT_ASOS.INT_VAT_ITEM);

VAT_REGION, ACTIVE_DATE, VAT_TYPE, VAT_CODE, VAT_RATE, REVERSE_VAT_IND, CREATE_DATE, CREATE_ID

insert into INT_ASOS.INT_VAT_ITEM
select rownum+4300000 as sl_no,'N' as UPDATE_TYPE, ITEM, VAT_REGION, ACTIVE_DATE, VAT_TYPE, VAT_CODE, VAT_RATE, sysdate as CREATE_DATETIME, 'MA_ASOS' as CREATE_USER from intitemins;

select * from item_master where item_level = '1'  and CREATE_ID != 'ORACNV';

drop table intitem;
create table intitem as 
select im.item from item_master im where item_level = '1'  and CREATE_ID != 'ORACNV'
    and not exists (select 1 from INT_ASOS.INT_VAT_ITEM ivt where ivt.item = im.item) and rownum <= '25000';


drop table intitemins ;
create table intitemins as
select * 
    from (
    SELECT                  vi.ITEM ,
                         vi.VAT_REGION ,
                         MAX(vi.ACTIVE_DATE) as ACTIVE_DATE,
                         vi.VAT_TYPE,
                         vi.VAT_CODE ,
                         vi.VAT_RATE 
        FROM VAT_ITEM vi, ITEM_MASTER im, VAT_REGION vr, intitem intt
           WHERE vi.ITEM = im.ITEM
             and vi.item = intt.item
             AND vi.VAT_REGION = vr.VAT_REGION
             AND im.ITEM_LEVEL < im.TRAN_LEVEL
             AND im.STATUS = 'A'
             AND vi.ACTIVE_DATE <= GET_VDATE() + 1
       and vi.active_date = (
           SELECT
             MAX(active_date)
                FROM
                    vat_item vi2
                WHERE
                    vi2.item = vi.item
                    AND vi2.vat_type = vi.vat_type
                    AND vi2.vat_region = vi.vat_region
                    AND vi2.vat_code = vi.vat_code
                    AND vi2.ACTIVE_DATE <= GET_VDATE() + 1
       ) GROUP BY vi.ITEM, vi.VAT_REGION,  vi.VAT_TYPE, vi.VAT_CODE, vi.VAT_RATE
           ORDER BY vi.ITEM, vi.VAT_REGION, vi.VAT_TYPE,  vi.VAT_CODE );




SELECT /*+ FULL(ivi) LEADING(ivi,im) */ ivi.UPDATE_TYPE || '|' ||
                 ivi.ITEM || '|' ||
                         ivi.VAT_REGION || '|' ||
                         vr.VAT_REGION_NAME || '|' ||
                         ivi.ACTIVE_DATE || '|' ||
                         ivi.VAT_TYPE || '|' ||
                         ivi.VAT_CODE || '|' ||
                         ivi.VAT_RATE || CHR(10) AS rec
        FROM INT_VAT_ITEM ivi, ITEM_MASTER im, VAT_REGION vr
           WHERE ivi.ITEM = im.ITEM
             AND ivi.VAT_REGION = vr.VAT_REGION
                 AND im.ITEM_LEVEL < im.TRAN_LEVEL
                 AND im.STATUS = 'A'
                 AND mod(ivi.ITEM, :ps_num_threads) = TO_NUMBER(:ps_thread_val) - 1
           ORDER BY ivi.ITEM, ivi.VAT_REGION, ivi.VAT_TYPE,  ivi.VAT_CODE;
