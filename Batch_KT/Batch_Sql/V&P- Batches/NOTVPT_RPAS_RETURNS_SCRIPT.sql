
SELECT irs.item SKU_ID,
                     NVL(iem.diff_2, 'NONE') SIZE_CODE,
                     NVL(iem2.diff_2, 'NONE') SIZE_GROUP,
                     iem.item_parent OPTION_ID,
                     irs.dlv_country DC_ID,
                     wh.primary_vwh FC_ID,
                     TO_CHAR(irs.business_date, 'YYYYMMDD') DAY,
                     SUBSTR(NBS.value_2,0,2) RETURN_GROUP,
                     IRS.RETURN_TYPE RETURN_TYPE,
                     IRS.RETURN_AGE RETURN_AGE,
                     TO_CHAR(SUM(irs.return_qty) * -1, 'FM999999990.0000') RETURNS_UNITS,
                     TO_CHAR(SUM(irs.return_retail), 'FM99999999999999990.0000') RETURNS_RET_VAL_INC_VAT,
                     TO_CHAR(SUM(irs.return_retail - NVL(irs.return_tax,0)), 'FM99999999999999990.0000') RETURNS_RET_VAL_EXC_VAT,
                     TO_CHAR(CASE IRS.RETURN_TYPE
                                WHEN 'TOTAL' THEN
                                    SUM(IRS.RETURN_QTY * ILBP.BUY_UNIT_RETAIL)
                                ELSE
                                    0
                             END, 'FM99999999999999990.0000') RETURN_BUY_VALUE,
                     TO_CHAR(CASE IRS.RETURN_TYPE
                                WHEN 'TOTAL' THEN
                                    SUM(IRS.RETURN_QTY * NVL(IRS.RETURN_COST,0))
                                ELSE
                                    0
                              END , 'FM99999999999999990.0000') RETURN_COST_VALUE
                 FROM INT_ASOS.INT_PL_RETURNS_DNLD_STG       irs,
                       RMS.WH                                   wh,
                       INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD ilbp,
                       RMS.ITEM_MASTER                          iem,
                       RMS.ITEM_MASTER                          iem2,
                       RMS.NB_SYSTEM_PARAMETERS                 nbs
                   WHERE irs.return_wh     = wh.wh
                     AND irs.item          = ilbp.item
                     AND wh.primary_vwh    = ilbp.loc
                     AND iem.item_parent   = iem2.item
                     AND iem.item          = irs.item
                     AND irs.return_group  = nbs.value_1
                     AND wh.wh             = irs.return_wh
                     AND nbs.func_area     = 'RPAS_INTEGRATION'
                     AND nbs.parameter     = 'SALES_RETURNS_GROUP_XREF'
                     AND irs.business_date = GET_VDATE()
                    GROUP BY irs.item,
                             NVL(iem.diff_2, 'NONE'),
                             NVL(iem2.diff_2, 'NONE'),
                             iem.item_parent,
                             irs.dlv_country,
                             wh.primary_vwh,
                             TO_CHAR(irs.business_date, 'YYYYMMDD'),
                             SUBSTR(NBS.value_2,0,2),
                             IRS.RETURN_TYPE,
                             IRS.RETURN_AGE;

select count(1) from INT_ASOS.INT_PL_RETURNS_DNLD_STG;
select DLV_COUNTRY,RETURN_GROUP,count(1) from INT_ASOS.INT_PL_RETURNS_DNLD_STG group by DLV_COUNTRY,RETURN_GROUP order by 1,2,3;



--- WH - GB --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_RETURNS_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_RETURNS_DNLD_STG.dlv_country%type := 'GB';
l_return_wh           INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_WH%type := '1';
l_business_date       INT_ASOS.INT_PL_RETURNS_DNLD_STG.business_date%type :='06-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_RETAIL%type;
l_store_day_seq_no    INT_ASOS.INT_PL_RETURNS_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_RETURNS_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
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
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc ='1001'
                and not exists (select 1 from INT_ASOS.INT_PL_RETURNS_DNLD_STG ispd where ispd.item = im.item  and ispd.RETURN_WH = l_return_wh)
					 and im.item_level = im.tran_level and rownum<='1'
                  order by item;
            

begin
   
   for j in 0..1 loop
   
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Returns
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
     --   dbms_output.put_line('Insert block');

            insert into INT_ASOS.INT_PL_RETURNS_DNLD_STG 
            (    ITEM            ,
                    DLV_COUNTRY     ,
                    RETURN_WH       ,
                    BUSINESS_DATE   ,
                    RETURN_GROUP    ,
                    RETURN_TYPE     ,
                    RETURN_AGE      ,
                    RETURN_QTY      ,
                    RETURN_RETAIL   ,
                    RETURN_TAX      ,
                    RETURN_COST     ,
                    STORE_DAY_SEQ_NO,
                    TRAN_SEQ_NO     ,
                    ITEM_SEQ_NO     ,
                    DISCOUNT_SEQ_NO ,
                    RMS_PROMO_TYPE  ,
                    DISC_TYPE       ,
                    REV_NO          ,
                    CREATE_DATETIME )
            values (l_item            , 
            l_dlv_country     , 
            l_return_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '1'               , 
            '-1'  , 
            l_sales_retail  , 
            (l_sales_retail*10)/100 , 
            (l_sales_retail*70)/100, 
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
  END LOOP; 
  END LOOP; 
    
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
l_item                INT_ASOS.INT_PL_RETURNS_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_RETURNS_DNLD_STG.dlv_country%type := 'US';
l_return_wh           INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_WH%type := '3';
l_business_date       INT_ASOS.INT_PL_RETURNS_DNLD_STG.business_date%type :='06-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_RETAIL%type;
l_store_day_seq_no    INT_ASOS.INT_PL_RETURNS_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_RETURNS_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
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
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                 and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc ='3001'
                and not exists (select 1 from INT_ASOS.INT_PL_RETURNS_DNLD_STG ispd where ispd.item = im.item  and ispd.RETURN_WH = l_return_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..25 loop
   
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Returns
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
     --   dbms_output.put_line('Insert block');

            insert into INT_ASOS.INT_PL_RETURNS_DNLD_STG 
            (    ITEM            ,
                    DLV_COUNTRY     ,
                    RETURN_WH       ,
                    BUSINESS_DATE   ,
                    RETURN_GROUP    ,
                    RETURN_TYPE     ,
                    RETURN_AGE      ,
                    RETURN_QTY      ,
                    RETURN_RETAIL   ,
                    RETURN_TAX      ,
                    RETURN_COST     ,
                    STORE_DAY_SEQ_NO,
                    TRAN_SEQ_NO     ,
                    ITEM_SEQ_NO     ,
                    DISCOUNT_SEQ_NO ,
                    RMS_PROMO_TYPE  ,
                    DISC_TYPE       ,
                    REV_NO          ,
                    CREATE_DATETIME )
            values (l_item            , 
            l_dlv_country     , 
            l_return_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '1'               , 
            '-1'  , 
            l_sales_retail  , 
            (l_sales_retail*10)/100 , 
            (l_sales_retail*70)/100, 
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
  END LOOP; 
  END LOOP; 
    
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
l_item                INT_ASOS.INT_PL_RETURNS_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_RETURNS_DNLD_STG.dlv_country%type := 'DE';
l_return_wh           INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_WH%type := '4';
l_business_date       INT_ASOS.INT_PL_RETURNS_DNLD_STG.business_date%type :='06-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_RETAIL%type;
l_store_day_seq_no    INT_ASOS.INT_PL_RETURNS_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_RETURNS_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
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
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc ='4001'
                and not exists (select 1 from INT_ASOS.INT_PL_RETURNS_DNLD_STG ispd where ispd.item = im.item  and ispd.RETURN_WH = l_return_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..25 loop
   
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Returns
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
     --   dbms_output.put_line('Insert block');

            insert into INT_ASOS.INT_PL_RETURNS_DNLD_STG 
            (    ITEM            ,
                    DLV_COUNTRY     ,
                    RETURN_WH       ,
                    BUSINESS_DATE   ,
                    RETURN_GROUP    ,
                    RETURN_TYPE     ,
                    RETURN_AGE      ,
                    RETURN_QTY      ,
                    RETURN_RETAIL   ,
                    RETURN_TAX      ,
                    RETURN_COST     ,
                    STORE_DAY_SEQ_NO,
                    TRAN_SEQ_NO     ,
                    ITEM_SEQ_NO     ,
                    DISCOUNT_SEQ_NO ,
                    RMS_PROMO_TYPE  ,
                    DISC_TYPE       ,
                    REV_NO          ,
                    CREATE_DATETIME )
            values (l_item            , 
            l_dlv_country     , 
            l_return_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '1'               , 
            '-1'  , 
            l_sales_retail  , 
            (l_sales_retail*10)/100 , 
            (l_sales_retail*70)/100, 
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
  END LOOP; 
  END LOOP; 
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/





 --- Late sales  --

--- WH - GB --
set serveroutput on;
set timing on;

DECLARE
	COUNTER_COMMIT  NUMBER(8)     := 1;
l_item                INT_ASOS.INT_PL_RETURNS_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_RETURNS_DNLD_STG.dlv_country%type := 'GB';
l_return_wh           INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_WH%type := '1';
l_business_date       INT_ASOS.INT_PL_RETURNS_DNLD_STG.business_date%type :='05-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_RETAIL%type;
l_store_day_seq_no    INT_ASOS.INT_PL_RETURNS_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_RETURNS_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
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
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc ='1001'
                and not exists (select 1 from INT_ASOS.INT_PL_RETURNS_DNLD_STG ispd where ispd.item = im.item  and ispd.RETURN_WH = l_return_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..10 loop
   
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Returns
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
     --   dbms_output.put_line('Insert block');

            insert into INT_ASOS.INT_PL_RETURNS_DNLD_STG 
            (    ITEM            ,
                    DLV_COUNTRY     ,
                    RETURN_WH       ,
                    BUSINESS_DATE   ,
                    RETURN_GROUP    ,
                    RETURN_TYPE     ,
                    RETURN_AGE      ,
                    RETURN_QTY      ,
                    RETURN_RETAIL   ,
                    RETURN_TAX      ,
                    RETURN_COST     ,
                    STORE_DAY_SEQ_NO,
                    TRAN_SEQ_NO     ,
                    ITEM_SEQ_NO     ,
                    DISCOUNT_SEQ_NO ,
                    RMS_PROMO_TYPE  ,
                    DISC_TYPE       ,
                    REV_NO          ,
                    CREATE_DATETIME )
            values (l_item            , 
            l_dlv_country     , 
            l_return_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '1'               , 
            '-1'  , 
            l_sales_retail  , 
            (l_sales_retail*10)/100 , 
            (l_sales_retail*70)/100, 
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
  END LOOP; 
  END LOOP; 
    
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
l_item                INT_ASOS.INT_PL_RETURNS_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_RETURNS_DNLD_STG.dlv_country%type := 'US';
l_return_wh           INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_WH%type := '3';
l_business_date       INT_ASOS.INT_PL_RETURNS_DNLD_STG.business_date%type :='05-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_RETAIL%type;
l_store_day_seq_no    INT_ASOS.INT_PL_RETURNS_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_RETURNS_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
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
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                 and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc ='3001'
                and not exists (select 1 from INT_ASOS.INT_PL_RETURNS_DNLD_STG ispd where ispd.item = im.item  and ispd.RETURN_WH = l_return_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..5 loop
   
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Returns
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
     --   dbms_output.put_line('Insert block');

            insert into INT_ASOS.INT_PL_RETURNS_DNLD_STG 
            (    ITEM            ,
                    DLV_COUNTRY     ,
                    RETURN_WH       ,
                    BUSINESS_DATE   ,
                    RETURN_GROUP    ,
                    RETURN_TYPE     ,
                    RETURN_AGE      ,
                    RETURN_QTY      ,
                    RETURN_RETAIL   ,
                    RETURN_TAX      ,
                    RETURN_COST     ,
                    STORE_DAY_SEQ_NO,
                    TRAN_SEQ_NO     ,
                    ITEM_SEQ_NO     ,
                    DISCOUNT_SEQ_NO ,
                    RMS_PROMO_TYPE  ,
                    DISC_TYPE       ,
                    REV_NO          ,
                    CREATE_DATETIME )
            values (l_item            , 
            l_dlv_country     , 
            l_return_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '1'               , 
            '-1'  , 
            l_sales_retail  , 
            (l_sales_retail*10)/100 , 
            (l_sales_retail*70)/100, 
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
  END LOOP; 
  END LOOP; 
    
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
l_item                INT_ASOS.INT_PL_RETURNS_DNLD_STG.item%type;
l_dlv_country         INT_ASOS.INT_PL_RETURNS_DNLD_STG.dlv_country%type := 'DE';
l_return_wh           INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_WH%type := '4';
l_business_date       INT_ASOS.INT_PL_RETURNS_DNLD_STG.business_date%type :='05-MAY-19';
l_sales_retail        INT_ASOS.INT_PL_RETURNS_DNLD_STG.RETURN_RETAIL%type;
l_store_day_seq_no    INT_ASOS.INT_PL_RETURNS_DNLD_STG.store_day_seq_no%type;
l_tran_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.tran_seq_no%type;
l_item_seq_no         INT_ASOS.INT_PL_RETURNS_DNLD_STG.item_seq_no%type := 1;
l_DISCOUNT_SEQ_NO     INT_ASOS.INT_PL_RETURNS_DNLD_STG.DISCOUNT_SEQ_NO%type := 1;
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
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
				select  im.item , 
                        nvl(il.BUY_UNIT_RETAIL,'5') as BUY_UNIT_RETAIL
				from INT_ASOS.INT_MV_ITEM_LOC_BUY_PRICE_EOD il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                   and il.loc ='4001'
                and not exists (select 1 from INT_ASOS.INT_PL_RETURNS_DNLD_STG ispd where ispd.item = im.item  and ispd.RETURN_WH = l_return_wh)
					 and im.item_level = im.tran_level and rownum<='3'
                  order by item;
            

begin
   
   for j in 0..5 loop
   
    for m in cur_store_day loop
        l_store_day_seq_no      := m.store_day_seq_no;
        
     -- Regular Returns
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        select rms.SA_TRAN_SEQ_NO_SEQUENCE.nextval into l_tran_seq_no from dual;
        
            for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            l_sales_retail              := cust_ma.BUY_UNIT_RETAIL;
            
     --   dbms_output.put_line('Insert block');

            insert into INT_ASOS.INT_PL_RETURNS_DNLD_STG 
            (    ITEM            ,
                    DLV_COUNTRY     ,
                    RETURN_WH       ,
                    BUSINESS_DATE   ,
                    RETURN_GROUP    ,
                    RETURN_TYPE     ,
                    RETURN_AGE      ,
                    RETURN_QTY      ,
                    RETURN_RETAIL   ,
                    RETURN_TAX      ,
                    RETURN_COST     ,
                    STORE_DAY_SEQ_NO,
                    TRAN_SEQ_NO     ,
                    ITEM_SEQ_NO     ,
                    DISCOUNT_SEQ_NO ,
                    RMS_PROMO_TYPE  ,
                    DISC_TYPE       ,
                    REV_NO          ,
                    CREATE_DATETIME )
            values (l_item            , 
            l_dlv_country     , 
            l_return_wh              , 
            l_business_date   , 
            'REGULAR'         ,  
            'TOTAL'           , 
            '1'               , 
            '-1'  , 
            l_sales_retail  , 
            (l_sales_retail*10)/100 , 
            (l_sales_retail*70)/100, 
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
  END LOOP; 
  END LOOP; 
    
EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/
