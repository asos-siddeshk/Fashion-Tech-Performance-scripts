
select * from period;
select * from INT_MV_ITEM_LOC_BUY_PRICE_EOD;

select * from INT_ASOS.INT_PL_SALES_DNLD_STG;

select DLV_COUNTRY,SALES_GROUP,count(1) from INT_ASOS.INT_PL_SALES_DNLD_STG group by DLV_COUNTRY,SALES_GROUP order by 1,2,3;







--RPAS Extract for daily Sales volume 
    SELECT iss.item SKU_ID,
                     NVL(iem.diff_2, 'NONE') SIZE_CODE,
                     NVL(iem2.diff_2, 'NONE') SIZE_GROUP,
                     iem.item_parent OPTION_ID,
                     iss.dlv_country DC_ID,
                     iss.wh FC_ID,
                     TO_CHAR(iss.business_date, 'YYYYMMDD') DAY,
                     SUBSTR(NBS.value_2,0,2) SALES_GROUP,
                     ISS.SALES_TYPE SALES_TYPE,
                     TO_CHAR(SUM(iss.sales_qty), 'FM999999990.0000') SALES_UNITS,
                     TO_CHAR(SUM(iss.sales_retail), 'FM99999999999999990.0000') SALES_RETAIL_VALUE_INC_VAT,
                     TO_CHAR(SUM(iss.sales_retail - NVL(iss.sales_tax,0)), 'FM99999999999999990.0000') SALES_RETAIL_VALUE_EXC_VAT,
                     TO_CHAR(CASE ISS.SALES_TYPE
                                WHEN 'TOTAL' THEN
                                    SUM(ISS.SALES_QTY * ILBP.BUY_UNIT_RETAIL)
                                ELSE
                                    0
                             END, 'FM99999999999999990.0000') SALES_BUY_VALUE,
                     TO_CHAR(SUM(iss.sales_qty * NVL(iss.sales_cost,0)), 'FM99999999999999990.0000') SALES_COST_VALUE
                FROM INT_ASOS.INT_PL_SALES_DNLD_STG         iss,
                     INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD ilbp,
                     RMS.ITEM_MASTER                          iem,
                     RMS.ITEM_MASTER                          iem2,
                     RMS.NB_SYSTEM_PARAMETERS                 nbs
               WHERE iss.item          = ilbp.item
                 AND iss.wh            = ilbp.loc
                 AND iss.item          = iem.item
                 AND iem.item_parent   = iem2.item
                 AND iss.sales_group   = nbs.value_1
                 AND nbs.func_area     = 'RPAS_INTEGRATION'
                 AND nbs.parameter     = 'SALES_RETURNS_GROUP_XREF'
                 AND iss.business_date = GET_VDATE()
               GROUP BY iss.item,
                        NVL(iem.diff_2, 'NONE'),
                        NVL(iem2.diff_2, 'NONE'),
                        iem.item_parent,
                        iss.dlv_country,
                        iss.wh,
                        TO_CHAR(iss.business_date, 'YYYYMMDD'),
                        SUBSTR(NBS.value_2,0,2) ,
                        ISS.SALES_TYPE;

select SALES_GROUP,count(1) from INT_ASOS.INT_PL_SALES_DNLD_STG group by SALES_GROUP order by 1;

select count(distinct(item)) from INT_ASOS.INT_PL_SALES_DNLD_STG;
select * from INT_ASOS.INT_PL_SALES_DNLD_STG;
select count(1) from INT_ASOS.INT_PL_SALES_DNLD_STG where BUSINESS_DATE ='06-MAY-19' ;
select DLV_COUNTRY,SALES_GROUP,BUSINESS_DATE,count(1) from INT_ASOS.INT_PL_SALES_DNLD_STG group by DLV_COUNTRY,SALES_GROUP,BUSINESS_DATE order by 1,3,2;
select * from RMS.NB_SYSTEM_PARAMETERS nbs where nbs.func_area     = 'RPAS_INTEGRATION' AND nbs.parameter     = 'SALES_RETURNS_GROUP_XREF';


select DLV_COUNTRY,SALES_GROUP,count(1) from INT_ASOS.INT_PL_SALES_DNLD_STG where BUSINESS_DATE ='06-MAY-19' group by DLV_COUNTRY,SALES_GROUP order by 1,3,2;
select DLV_COUNTRY,SALES_GROUP,BUSINESS_DATE,count(1) from INT_ASOS.INT_PL_SALES_DNLD_STG 
    where BUSINESS_DATE ='06-MAY-19' and DLV_COUNTRY = 'US' group by DLV_COUNTRY,SALES_GROUP,BUSINESS_DATE order by 1,3,2;
--US     
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+MRKTNG' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'US' and SALES_GROUP ='CLR' and rownum <= '33425';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+RPM' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'US' and SALES_GROUP ='CLR' and rownum <= '38568';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='MRKTNG+RPM' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'US' and SALES_GROUP ='MRKTNG' and rownum <= '34568';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+RPM+MRKTNG' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'US' and SALES_GROUP ='MRKTNG' and rownum <= '19056';
--DE     
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+MRKTNG' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'DE' and SALES_GROUP ='CLR' and rownum <= '34567';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+RPM' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'DE' and SALES_GROUP ='CLR' and rownum <= '37689';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='MRKTNG+RPM' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'DE' and SALES_GROUP ='MRKTNG' and rownum <= '33568';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+RPM+MRKTNG' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'DE' and SALES_GROUP ='MRKTNG' and rownum <= '23689';

--GB
select * from INT_ASOS.INT_PL_SALES_DNLD_STG where BUSINESS_DATE ='06-MAY-19' and DLV_COUNTRY = 'GB' and SALES_GROUP ='CLR';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+MRKTNG' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'GB' and SALES_GROUP ='CLR' and rownum <= '49878';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+RPM' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'GB' and SALES_GROUP ='CLR' and rownum <= '51236';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='MRKTNG+RPM' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'GB' and SALES_GROUP ='MRKTNG' and rownum <= '48769';
Update INT_ASOS.INT_PL_SALES_DNLD_STG set SALES_GROUP ='CLR+RPM+MRKTNG' where BUSINESS_DATE ='06-MAY-19' and 
    DLV_COUNTRY = 'GB' and SALES_GROUP ='MRKTNG' and rownum <= '52689';


--- WH - GB --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_SALES_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_SALES_DNLD_STG.dlv_country%type := 'GB';
l_wh                  INT_ASOS.INT_PL_SALES_DNLD_STG.wh%type := '1001';
l_business_date       INT_ASOS.INT_PL_SALES_DNLD_STG.business_date%type :='06-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_SALES_DNLD_STG.sales_retail%type;
l_store_day_seq_no    INT_ASOS.INT_PL_SALES_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_SALES_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 

    cursor cur_store_day  is  
		select 1 as store_day_seq_no from dual ;
        
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc =l_wh
                and not exists (select 1 from INT_ASOS.INT_PL_SALES_DNLD_STG ispd where ispd.item = im.item  and ispd.wh = l_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..1 loop
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '3'               , 
            3*l_sales_retail +10  , 
            l_sales_retail  , 
            3*l_sales_retail -10  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            null              , 
            null              , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Clearance Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'CLR'         ,  
            'CLR'           , 
            '3'               , 
            3*l_sales_retail  , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'CLR'             , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Promotional Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'RPM'         ,  
            'RPM'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '9999'            , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
    
      -- Marketing Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'MRKTNG'         ,  
            'MRKTNG'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'MRKTNG'          , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
        
                   
  END LOOP; 
  END LOOP; 
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

--- WH - US --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_SALES_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_SALES_DNLD_STG.dlv_country%type := 'US';
l_wh                  INT_ASOS.INT_PL_SALES_DNLD_STG.wh%type := '3001';
l_business_date       INT_ASOS.INT_PL_SALES_DNLD_STG.business_date%type :='06-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_SALES_DNLD_STG.sales_retail%type;
l_store_day_seq_no    INT_ASOS.INT_PL_SALES_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_SALES_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 

    cursor cur_store_day  is  
		select 2 as store_day_seq_no from dual ;
        
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc =l_wh
                and not exists (select 1 from INT_ASOS.INT_PL_SALES_DNLD_STG ispd where ispd.item = im.item  and ispd.wh = l_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..1 loop
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '3'               , 
            3*l_sales_retail +10  , 
            l_sales_retail  , 
            3*l_sales_retail -10  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            null              , 
            null              , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Clearance Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'CLR'         ,  
            'CLR'           , 
            '3'               , 
            3*l_sales_retail  , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'CLR'             , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Promotional Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'RPM'         ,  
            'RPM'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '9999'            , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
    
      -- Marketing Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'MRKTNG'         ,  
            'MRKTNG'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'MRKTNG'          , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
        
                   
  END LOOP; 
  END LOOP; 
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

--- WH - DE --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_SALES_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_SALES_DNLD_STG.dlv_country%type := 'DE';
l_wh                  INT_ASOS.INT_PL_SALES_DNLD_STG.wh%type := '4001';
l_business_date       INT_ASOS.INT_PL_SALES_DNLD_STG.business_date%type :='06-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_SALES_DNLD_STG.sales_retail%type;
l_store_day_seq_no    INT_ASOS.INT_PL_SALES_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_SALES_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 

    cursor cur_store_day  is  
		select 3 as store_day_seq_no from dual ;
        
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc =l_wh
                and not exists (select 1 from INT_ASOS.INT_PL_SALES_DNLD_STG ispd where ispd.item = im.item  and ispd.wh = l_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..1 loop
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '3'               , 
            3*l_sales_retail +10  , 
            l_sales_retail  , 
            3*l_sales_retail -10  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            null              , 
            null              , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Clearance Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'CLR'         ,  
            'CLR'           , 
            '3'               , 
            3*l_sales_retail  , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'CLR'             , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Promotional Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'RPM'         ,  
            'RPM'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '9999'            , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
    
      -- Marketing Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'MRKTNG'         ,  
            'MRKTNG'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'MRKTNG'          , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
        
                   
  END LOOP; 
  END LOOP; 
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/



 -- Late sales --

--- WH - GB --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_SALES_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_SALES_DNLD_STG.dlv_country%type := 'GB';
l_wh                  INT_ASOS.INT_PL_SALES_DNLD_STG.wh%type := '1001';
l_business_date       INT_ASOS.INT_PL_SALES_DNLD_STG.business_date%type :='05-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_SALES_DNLD_STG.sales_retail%type;
l_store_day_seq_no    INT_ASOS.INT_PL_SALES_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_SALES_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 

    cursor cur_store_day  is  
		select 4 as store_day_seq_no from dual ;
        
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc =l_wh
                and not exists (select 1 from INT_ASOS.INT_PL_SALES_DNLD_STG ispd where ispd.item = im.item  and ispd.wh = l_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..1 loop
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '3'               , 
            3*l_sales_retail +10  , 
            l_sales_retail  , 
            3*l_sales_retail -10  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            null              , 
            null              , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Clearance Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'CLR'         ,  
            'CLR'           , 
            '3'               , 
            3*l_sales_retail  , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'CLR'             , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Promotional Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'RPM'         ,  
            'RPM'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '9999'            , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
    
      -- Marketing Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'MRKTNG'         ,  
            'MRKTNG'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'MRKTNG'          , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
        
                   
  END LOOP; 
  END LOOP; 
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

--- WH - US --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_SALES_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_SALES_DNLD_STG.dlv_country%type := 'US';
l_wh                  INT_ASOS.INT_PL_SALES_DNLD_STG.wh%type := '3001';
l_business_date       INT_ASOS.INT_PL_SALES_DNLD_STG.business_date%type :='05-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_SALES_DNLD_STG.sales_retail%type;
l_store_day_seq_no    INT_ASOS.INT_PL_SALES_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_SALES_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 

    cursor cur_store_day  is  
		select 5 as store_day_seq_no from dual ;
        
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc =l_wh
                and not exists (select 1 from INT_ASOS.INT_PL_SALES_DNLD_STG ispd where ispd.item = im.item  and ispd.wh = l_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..1 loop
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '3'               , 
            3*l_sales_retail +10  , 
            l_sales_retail  , 
            3*l_sales_retail -10  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            null              , 
            null              , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Clearance Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'CLR'         ,  
            'CLR'           , 
            '3'               , 
            3*l_sales_retail  , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'CLR'             , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Promotional Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'RPM'         ,  
            'RPM'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '9999'            , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
    
      -- Marketing Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'MRKTNG'         ,  
            'MRKTNG'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'MRKTNG'          , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
        
                   
  END LOOP; 
  END LOOP; 
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/

--- WH - DE --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_SALES_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_SALES_DNLD_STG.dlv_country%type := 'DE';
l_wh                  INT_ASOS.INT_PL_SALES_DNLD_STG.wh%type := '4001';
l_business_date       INT_ASOS.INT_PL_SALES_DNLD_STG.business_date%type :='05-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_SALES_DNLD_STG.sales_retail%type;
l_store_day_seq_no    INT_ASOS.INT_PL_SALES_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_SALES_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_SALES_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 

    cursor cur_store_day  is  
		select 6 as store_day_seq_no from dual ;
        
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc =l_wh
                and not exists (select 1 from INT_ASOS.INT_PL_SALES_DNLD_STG ispd where ispd.item = im.item  and ispd.wh = l_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..1 loop
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '3'               , 
            3*l_sales_retail +10  , 
            l_sales_retail  , 
            3*l_sales_retail -10  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            null              , 
            null              , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Clearance Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'CLR'         ,  
            'CLR'           , 
            '3'               , 
            3*l_sales_retail  , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'CLR'             , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
           
     -- Promotional Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'RPM'         ,  
            'RPM'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '9999'            , 
            null              , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
    
      -- Marketing Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
            insert into INT_ASOS.INT_PL_SALES_DNLD_STG 
            (    ITEM            , 
            DLV_COUNTRY     , 
            WH              , 
            BUSINESS_DATE   , 
            SALES_GROUP     , 
            SALES_TYPE      , 
            SALES_QTY       , 
            SALES_RETAIL    , 
            SALES_TAX       , 
            SALES_COST      , 
            STORE_DAY_SEQ_NO, 
            TRAN_SEQ_NO     , 
            ITEM_SEQ_NO     , 
            DISCOUNT_SEQ_NO , 
            RMS_PROMO_TYPE  , 
            DISC_TYPE       , 
            REV_NO         ,
            CREATE_DATETIME)
            values (l_item            , 
            l_dlv_country     , 
            l_wh              , 
            l_business_date   , 
            'MRKTNG'         ,  
            'MRKTNG'           , 
            '1'               , 
            1*l_sales_retail , 
            0  , 
            0  , 
            l_store_day_seq_no, 
            l_tran_seq_no     , 
            l_item_seq_no     , 
            l_DISCOUNT_SEQ_NO     , 
            '1004'            , 
            'MRKTNG'          , 
            null              ,
            sysdate             ); 
            
            l_item_seq_no := l_item_seq_no+1;
            
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
            l_item_seq_no :=1;
              END LOOP; 
        
                   
  END LOOP; 
  END LOOP; 
    commit;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/


