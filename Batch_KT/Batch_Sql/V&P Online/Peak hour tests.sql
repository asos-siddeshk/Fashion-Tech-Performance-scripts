select * from v$restore_point;
-------------------------------------------------  Items  -------------------------------------------------
-- 70  Item Creation -- 67
select count(*) from rms.item_master where status ='A' and item_level ='1' and Item_DESC='Item creation Perf Test'
        and CREATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');

select * from rms.item_master where status ='A' and item_level ='1' and Item_DESC LIKE '%Item creation Perf Test%';

select * from rms.item_master where status ='A' and item_level ='1' and Item_DESC LIKE '%Item creation Perf Test%'
        and CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');

select count(*) from rms.item_master where status ='A' and item_level ='1' and Item_DESC LIKE '%Item creation Perf Test%'
        and CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');

db.getCollection('exportedbaseproduct').find({"ItemNo":"104693353"})
db.getCollection('exportedItemLocation').find({"OptionItemID":"104693353"})
        
-- 268 Item Maintain --
select count(*) from rms.item_master where status ='A' and item_level ='1'  
   and LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') and item_desc like '%Edit%'
   order by LAST_UPDATE_DATETIME desc;

-- 268 Mass Maintenance -- 350-- 384
select distinct (item_desc) from rms.item_master where status ='A' and item_level ='1' and ITEM_DESC like '%MAY%' 
   and trunc(LAST_UPDATE_DATETIME)>='04-AUG-2021';


-- 217 Maintain reference --242 -- 1362
select count(*) from rms.item_master  where item_number_type like '%EAN13%' 
   and LAST_UPDATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') order by LAST_UPDATE_DATETIME desc; 


-- 67 Maintain Grouping: --120  --624
select count(distinct group_id) from MA_ASOS.ma_group_detail where 
   LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi'); 

select GROUP_ID,count(1) from MA_ASOS.ma_group_detail where 
   LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') group by GROUP_ID; 
  
select * from MA_ASOS.MA_GROUP_HEADER;

-- 268 Item Reclassify: --319 -- 1512
select count(*) from ma_asos.MA_STG_ITEM_BUY_HIER_RECLASS where LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
    order by last_update_datetime desc;

select * from ma_asos.MA_STG_ITEM_BUY_HIER_RECLASS where LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') ;
delete from ma_asos.MA_STG_ITEM_BUY_HIER_RECLASS where LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');
    
-- 230 Item Gold Seal --284 -- 
    select count(uil.item) from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='1')
    where uda_id = '4001' 
    and uil.LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
  --  and uil.CREATE_DATETIME <> uil.LAST_UPDATE_DATETIME 
  --  and uil.LAST_UPDATE_DATETIME < to_date('15-JUL-2020 15:45', 'DD-MON-YYYY hh24:mi')
    and uil.UDA_VALUE ='2' ; -- gold

select count(uil.item) from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='2')
    where uda_id = '4001' 
    and uil.LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
    and UDA_VALUE ='2' ; -- gold
    

-- 230 Item Blind Gold Seal -- 
select count(uil.item) from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='1')
    where uda_id = '4001' 
    and uil.LAST_UPDATE_DATETIME >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
    --and uil.CREATE_DATETIME <> uil.LAST_UPDATE_DATETIME 
    --and uil.LAST_UPDATE_DATETIME < to_date('15-JUL-2020 15:45', 'DD-MON-YYYY hh24:mi')
    and UDA_VALUE ='1' ; -- Blindgold

select count(uil.item) from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='2')
    where uda_id = '4001' 
    and uil.LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
    and UDA_VALUE ='1' ; -- Blindgold


-- 345/3 115  Item Bulk Blind Gold Seal --1900
select 10 * 50 from dual;

select count(distinct PROCESS_SEQ) from ma_asos.ma_item_mass_mnt_process  mmp 
        where create_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
        and exists (select 1 from ma_asos.MA_ITEM_MASS_MNT_HEADER mmh where mmh.PROCESS_SEQ = mmp.PROCESS_SEQ and mmh.gold_seal ='1');

select * from ma_asos.ma_item_mass_mnt_process;

select count(PROCESS_SEQ) from ma_asos.ma_item_mass_mnt_process  mmp 
        where create_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
        and exists (select 1 from ma_asos.MA_ITEM_MASS_MNT_HEADER mmh where mmh.PROCESS_SEQ = mmp.PROCESS_SEQ and mmh.gold_seal ='1');

select * from ma_asos.ma_item_mass_mnt_process  mmp 
        where create_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
        and exists (select 1 from ma_asos.MA_ITEM_MASS_MNT_HEADER mmh where mmh.PROCESS_SEQ = mmp.PROCESS_SEQ and mmh.gold_seal ='1');


-- 30 Item UnGold--73 -- 246

select count(uil.item) from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='1')
    where uda_id = '4001' 
    and uil.create_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
 --   and uil.CREATE_DATETIME <> uil.LAST_UPDATE_DATETIME 
 --   and uil.LAST_UPDATE_DATETIME < to_date('15-JUL-2020 15:45', 'DD-MON-YYYY hh24:mi')
    and UDA_VALUE ='3' ; -- Ungold

select count(uil.item) from rms.uda_item_lov uil
    inner join rms.item_master im on (uil.item=im.item and im.item_level ='2')
    where uda_id = '4001' 
    and uil.create_datetime>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
    and UDA_VALUE ='3' ; -- Ungold


--250 Item Upload --1200 -- 4800


select count(*) from rms.item_master where status ='A' 
    and item_level ='1' 
    and upper(Item_DESC) like '%UPLOAD%'
    and CREATE_DATETIME>=to_date('04-AUG-2021 08.40', 'DD-MON-YYYY hh24:mi');

select count(*) from rms.item_master where status ='A' 
    and item_level ='1' 
    and upper(Item_DESC) like '%UPLOAD%'
    and CREATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');


    --Input_data-- Item Inductions -- 
        select * from rms.item_master im where im.status ='A' 
            and im.item_level ='1' 
            and upper(im.Item_DESC) like '%UPLOAD%'
            and im.CREATE_ID like 'PTESTUSER%'
            and not exists (select 1 from rms.item_master im2 where im2.item_parent = im.item);
    
-- 600 Item inductions --467-- 2747
select count( distinct item_parent) from rms.item_master im 
  where im.status ='A' 
    and im.item_level ='2' 
    and upper(im.Item_DESC) like '%UPLOAD%'
    and im.CREATE_ID like 'PTESTUSER%'
    and CREATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');

select * from rms.item_master im 
  where im.item = '101235971' or im.item_parent = '101235971';

select * from ma_asos.ma_logs where trunc(LOG_TS) = trunc(sysdate);

------------------------------------------------- Purchase Order-------------------------------------------------

-- 173 PO Creation: -- 165 -- 1683
select count(*)/3 
from rms.ordhead 
 where CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');
   and comment_desc like '%PO Create';

select distinct MASTER_PO_NO from rms.ordhead 
 where CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
   and comment_desc like '%PO Create';
   
select distinct MASTER_PO_NO from rms.ordhead 
 where CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
   and comment_desc like '%PO Create 20 sku%';

-- 1982 PO Update- 1782 --11874 -- 6288

select count(*) from rms.ordhead oh where LAST_UPDATE_DATETIME>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
    and comment_Desc like '%PO Update%';

select count(*) from rms.ordhead oh where LAST_UPDATE_DATETIME>=to_date('10-JUN-2021 14:00', 'DD-MON-YYYY hh24:mi')
and comment_Desc like '%[REASON_CODE%';

select * from ordhead where last_update_datetime>=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
        and comment_desc like '%PO Update%'; -- Validate

-- 248 PO Replenishment  -- 1573
select count(*) from rms.ordhead where last_update_datetime >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
        and comment_Desc like '%Replenishment%'; 

-- 1684 PO Planning  --2530 - -8509   
select count(*) from rms.ordhead where last_update_datetime >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
                and comment_Desc like '%Planning%';

select * from rms.ordhead where last_update_datetime >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');

-- 372 PO Excel upload --789 --2983
select count(*) from rms.ordhead where last_update_datetime >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
                and comment_Desc like '%Upload%'; 

select count(*) from rms.ordhead where last_update_datetime >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
                and comment_Desc like '%PO Upload%'; 

--25 sku--1
select count(distinct master_po_no)  from rms.ordhead where CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
                and comment_desc like '%20%';
select * from ordloc where order_no ='50004662600';

--100 po--13
select count(distinct master_po_no) from rms.ordhead where CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
                and comment_desc like '%100%';

select master_po_no from rms.ordhead where CREATE_DATETIME>= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
                and comment_desc like '%100%';

select distinct MASTER_PO_NO from rms.ordhead where  comment_desc like '%100%';

------------------------------------------------- Supplier -------------------------------------------------


--2533 Create asn --1284 -- 10402

select count(*) from SUPP_ASOS.sc_asnin  --2788
    where  CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi'); 

--Amend asn ---- 8380

select count(*) from SUPP_ASOS.sc_asnin --520
    where  trunc(CREATE_DATETIME) <> trunc(LAST_UPDATE_DATETIME)
    and LAST_UPDATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi'); 



------------------------------------------------- Price change -------------------------------------------------

--84 1259 Create Price  17000
 
    select count(1) from ma_asos.ma_price_change where  Status='P' and 
        CREATE_DATETIME  >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
        and place_of_creation = 'M';
        
    select * from ma_asos.ma_price_change;
    select status,count(1) from ma_asos.ma_price_change
            where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') group by status;

    select status,count(1) from ma_asos.ma_price_change
            where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') and CREATE_ID!='PTUSER' group by status;

    select CREATE_ID, count(1) from ma_asos.ma_price_change
            where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') and CREATE_ID!='PTUSER' group by CREATE_ID ;
    
    select STATUS,EFFECTIVE_DATE,count(1) from ma_asos.ma_price_change where trunc(CREATE_DATETIME) = trunc(sysdate) 
    group by STATUS,EFFECTIVE_DATE order by 1;


    select im.dept,pc.EFFECTIVE_DATE,pc.CREATE_ID,pc.status, count(1) from ma_asos.ma_price_change pc, item_master im 
            where im.item= pc.item and pc.CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
            group by im.dept,pc.EFFECTIVE_DATE,pc.CREATE_ID,pc.status ;

    select pc.EFFECTIVE_DATE,pc.CREATE_ID,pc.status, count(1) from ma_asos.ma_price_change pc
            where pc.CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
            group by pc.EFFECTIVE_DATE,pc.CREATE_ID,pc.status ;
            
 select dept,count(1) from item_master where item in 
    (select distinct item from ma_asos.ma_price_change where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')) 
    group by dept;



           
            
-- 315 Maintain Price --778
    select count(1) from ma_asos.ma_price_change where  status='P' and 
        LAST_UPDATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
--        and LAST_UPDATE_DATETIME < to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') 
        and trunc(CREATE_DATETIME) <> trunc(LAST_UPDATE_DATETIME);

    select * from ma_asos.ma_price_change where 
        trunc(LAST_UPDATE_DATETIME) = '21-MAY-2021' order by 1 desc; 

--46/2062 Copy Promotion --1224
    select count(1) from ma_asos.ma_stage_simple_promo where last_update_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi');

    select COMP_DISPLAY_ID,count(1) from ma_asos.ma_stage_simple_promo where last_update_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') group by COMP_DISPLAY_ID;
    
    update ma_asos.ma_stage_simple_promo 
        set CREATE_DATETIME =to_date('21-MAY-2021 09:00', 'DD-MON-YYYY hh24:mi'), LAST_UPDATE_DATETIME= to_date('21-MAY-2021 09:00', 'DD-MON-YYYY hh24:mi');

--3300 Price Upload--9050 -- 2600
  
    select count(*) from ma_asos.ma_price_change where create_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
        and place_of_creation='U';
    
    select * from ma_asos.ma_price_change where create_datetime >=to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi')
        and place_of_creation='U';

        
    
--Upload Brand Conversion --58 -ff- 292
    select count(*) from ma_asos.MA_PRICING_RULES_METHOD
        where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi'); -- verify

    select * from ma_asos.MA_PRICING_RULES_METHOD
        where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi'); -- verify

    select count(*) from ma_asos.MA_PRICING_RULES_METHOD
        where CREATE_DATETIME >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi'); -- verify

-- 71 Cost Change --132-- 431
  select count(1) from ma_asos.ma_cost_change where CREATE_DATETIME  >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') ;

  select * from ma_asos.ma_cost_change where CREATE_DATETIME  >= to_date('04-AUG-2021 10.40', 'DD-MON-YYYY hh24:mi') ;
