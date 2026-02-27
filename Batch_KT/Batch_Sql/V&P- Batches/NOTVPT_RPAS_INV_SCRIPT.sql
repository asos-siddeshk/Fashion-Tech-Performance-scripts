SELECT  * FROM int_asos.INT_PL_INVENTORY_DNLD_STG ;

select * from rms.item_master where item_level ='2';

insert into int_asos.INT_PL_INVENTORY_DNLD_STG
select im.item as SKU_ID, im.DEPT, im.DIFF_2 SIZE_CODE, im2.diff_2 as SIZE_GROUP, im2.item OPTION_ID,ils.loc FC_ID,vdate DAY_ID,
    ils.AV_COST, il.SELLING_UNIT_RETAIL BUY_PRICE, 
    ils.STOCK_ON_HAND*ils.AV_COST TRADEABLE_STOCK_COST, ils.STOCK_ON_HAND*il.SELLING_UNIT_RETAIL TRADEABLE_STOCK_BUY, ils.STOCK_ON_HAND TRADEABLE_STOCK_UNITS,
    ils.NON_SELLABLE_QTY*ils.AV_COST NON_TRADEABLE_COST, ils.NON_SELLABLE_QTY*il.SELLING_UNIT_RETAIL NON_TRADEABLE_BUY, ils.NON_SELLABLE_QTY NON_TRADEABLE_UNITS,
    ils.NON_SELLABLE_QTY*ils.AV_COST NON_SALEABLE_COST, ils.NON_SELLABLE_QTY*il.SELLING_UNIT_RETAIL NON_SALEABLE_BUY, ils.NON_SELLABLE_QTY NON_SALEABLE_UNITS,
    ils.IN_TRANSIT_QTY*ils.AV_COST INTAKE_COST, ils.IN_TRANSIT_QTY*il.SELLING_UNIT_RETAIL INTAKE_BUY, ils.IN_TRANSIT_QTY INTAKE_UNITS, 
    ils.IN_TRANSIT_QTY*ils.AV_COST INV_ADJ_COST, ils.IN_TRANSIT_QTY*il.SELLING_UNIT_RETAIL INV_ADJ_BUY, ils.IN_TRANSIT_QTY INV_ADJ_UNITS, 
    ils.TSF_EXPECTED_QTY*ils.AV_COST TSF_IN_COST, ils.TSF_EXPECTED_QTY*il.SELLING_UNIT_RETAIL TSF_IN_BUY, ils.TSF_EXPECTED_QTY TSF_IN_UNITS, 
    ils.TSF_RESERVED_QTY*ils.AV_COST TSF_OUT_COST,ils.TSF_RESERVED_QTY*il.SELLING_UNIT_RETAIL TSF_OUT_BUY, ils.TSF_RESERVED_QTY TSF_OUT_UNITS, 
    ils.TSF_EXPECTED_QTY*ils.AV_COST ALLOC_IN_COST, ils.TSF_EXPECTED_QTY*il.SELLING_UNIT_RETAIL ALLOC_IN_BUY, ils.TSF_EXPECTED_QTY ALLOC_IN_UNITS, 
    ils.TSF_RESERVED_QTY*ils.AV_COST ALLOC_OUT_COST,ils.TSF_RESERVED_QTY*il.SELLING_UNIT_RETAIL ALLOC_OUT_BUY, ils.TSF_RESERVED_QTY ALLOC_OUT_UNITS,
    sysdate as CREATE_DATETIME
    from rms.item_master im, 
        rms.item_master im2,
        rms.item_loc_soh ils,
        rms.item_loc il,
        rms.period
        where im.item ='679671' 
    and im.item_parent = im2.item
        and ils.item = im.item
        and ils.loc_type ='W'
        and ils.item =il.item
        and ils.loc =il.loc;
                
select * from rms.item_loc_soh;

SELECT  SKU_ID,
                    SIZE_CODE,
                    SIZE_GROUP,
                    OPTION_ID,
                    FC_ID,
                    TO_CHAR(DAY_ID,'YYYYMMDD') DAY_ID,
                    TO_CHAR(TRADEABLE_STOCK_COST,'FM99999999999999990.0000') TRADEABLE_STOCK_COST,
                    TO_CHAR(TRADEABLE_STOCK_BUY,'FM99999999999999990.0000') TRADEABLE_STOCK_BUY,
                    TO_CHAR(TRADEABLE_STOCK_UNITS,'FM999999990.0000') TRADEABLE_STOCK_UNITS,
                    TO_CHAR(NON_TRADEABLE_COST,'FM99999999999999990.0000') NON_TRADEABLE_COST,
                    TO_CHAR(NON_TRADEABLE_BUY,'FM99999999999999990.0000') NON_TRADEABLE_BUY,
                    TO_CHAR(NON_TRADEABLE_UNITS,'FM999999990.0000') NON_TRADEABLE_UNITS,
                    TO_CHAR(NON_SALEABLE_COST,'FM99999999999999990.0000') NON_SALEABLE_COST,
                    TO_CHAR(NON_SALEABLE_BUY,'FM99999999999999990.0000') NON_SALEABLE_BUY,
                    TO_CHAR(NON_SALEABLE_UNITS,'FM999999990.0000') NON_SALEABLE_UNITS,
                    TO_CHAR(INTAKE_COST,'FM99999999999999990.0000') INTAKE_COST,
                    TO_CHAR(INTAKE_BUY,'FM99999999999999990.0000') INTAKE_BUY,
                    TO_CHAR(INTAKE_UNITS,'FM999999990.0000') INTAKE_UNITS,
                    TO_CHAR(INV_ADJ_COST,'FM99999999999999990.0000') INV_ADJ_COST,
                    TO_CHAR(INV_ADJ_BUY,'FM99999999999999990.0000') INV_ADJ_BUY,
                    TO_CHAR(INV_ADJ_UNITS,'FM999999990.0000') INV_ADJ_UNITS,
                    TO_CHAR(TSF_IN_COST,'FM99999999999999990.0000') TSF_IN_COST,
                    TO_CHAR(TSF_IN_BUY,'FM99999999999999990.0000') TSF_IN_BUY,
                    TO_CHAR(TSF_IN_UNITS,'FM999999990.0000') TSF_IN_UNITS,
                    TO_CHAR(TSF_OUT_COST,'FM99999999999999990.0000') TSF_OUT_COST,
                    TO_CHAR(TSF_OUT_BUY,'FM99999999999999990.0000') TSF_OUT_BUY,
                    TO_CHAR(TSF_OUT_UNITS,'FM999999990.0000') TSF_OUT_UNITS,
                    TO_CHAR(ALLOC_IN_COST,'FM99999999999999990.0000') ALLOC_IN_COST,
                    TO_CHAR(ALLOC_IN_BUY,'FM99999999999999990.0000') ALLOC_IN_BUY,
                    TO_CHAR(ALLOC_IN_UNITS,'FM999999990.0000') ALLOC_IN_UNITS,
                    TO_CHAR(ALLOC_OUT_COST,'FM99999999999999990.0000') ALLOC_OUT_COST,
                    TO_CHAR(ALLOC_OUT_BUY,'FM99999999999999990.0000') ALLOC_OUT_BUY,
                    TO_CHAR(ALLOC_OUT_UNITS,'FM999999990.0000') ALLOC_OUT_UNITS 
    FROM INT_ASOS.INT_PL_INVENTORY_DNLD_STG;
 
 
 SELECT COUNT(1) FROM INT_ASOS.INT_PL_INVENTORY_DNLD_STG;
  -- 27988022
  
   select 27988022-(SELECT COUNT(1)  FROM INT_ASOS.INT_PL_INVENTORY_DNLD_STG) from dual;
  
set serveroutput on;
set timing on;

DECLARE
COUNTER_COMMIT  NUMBER(8)     := 1;
l_dept                rms.subclass.dept%type; 
l_class               rms.subclass.class%type; 
l_subclass            rms.subclass.subclass%type; 
l_item                INT_ASOS.INT_PL_INVENTORY_DNLD_STG.SKU_ID%type;

       
     cursor cur_dept  is --2613
		select dept,class,subclass from (
		   select distinct im.dept,im.class,im.subclass  from rms.subclass im  where 
            exists (select 1 from rms.item_master im2 where im2.dept = im.dept and im2.class = im.class and im2.subclass =im.subclass and 
               item_level = '2' and status ='A') 
			group by im.dept,im.class,im.subclass) order by 1,2,3;
            
      CURSOR c_get_cuitem_pc (l_dept rms.subclass.dept%type,
                                l_class rms.subclass.class%type,
                                l_subclass rms.subclass.subclass%type)is
				select  im.item 
				from rms.item_master     im
				where im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
                and not exists (select 1 from INT_ASOS.INT_PL_INVENTORY_DNLD_STG ispd where ispd.SKU_ID = im.item)
					 and im.item_level = im.tran_level AND STATUS ='A' and rownum<='50'
                  order by item;
            

begin
   
   for j in 0..100 loop
     -- Regular Sales
    for k in cur_dept loop
        l_dept      := k.dept;
        l_class     := k.class;
        l_subclass  := k.subclass;
       
        for cust_ma in c_get_cuitem_pc(l_dept,l_class,l_subclass) loop 
            l_item                      := cust_ma.item;  
            
          insert into int_asos.INT_PL_INVENTORY_DNLD_STG
select im.item as SKU_ID, im.DEPT, im.DIFF_2 SIZE_CODE, im2.diff_2 as SIZE_GROUP, im2.item OPTION_ID,ils.loc FC_ID,vdate DAY_ID,
    ils.AV_COST, il.SELLING_UNIT_RETAIL BUY_PRICE, 
    ils.STOCK_ON_HAND*ils.AV_COST TRADEABLE_STOCK_COST, ils.STOCK_ON_HAND*il.SELLING_UNIT_RETAIL TRADEABLE_STOCK_BUY, ils.STOCK_ON_HAND TRADEABLE_STOCK_UNITS,
    ils.NON_SELLABLE_QTY*ils.AV_COST NON_TRADEABLE_COST, ils.NON_SELLABLE_QTY*il.SELLING_UNIT_RETAIL NON_TRADEABLE_BUY, ils.NON_SELLABLE_QTY NON_TRADEABLE_UNITS,
    ils.NON_SELLABLE_QTY*ils.AV_COST NON_SALEABLE_COST, ils.NON_SELLABLE_QTY*il.SELLING_UNIT_RETAIL NON_SALEABLE_BUY, ils.NON_SELLABLE_QTY NON_SALEABLE_UNITS,
    ils.IN_TRANSIT_QTY*ils.AV_COST INTAKE_COST, ils.IN_TRANSIT_QTY*il.SELLING_UNIT_RETAIL INTAKE_BUY, ils.IN_TRANSIT_QTY INTAKE_UNITS, 
    ils.IN_TRANSIT_QTY*ils.AV_COST INV_ADJ_COST, ils.IN_TRANSIT_QTY*il.SELLING_UNIT_RETAIL INV_ADJ_BUY, ils.IN_TRANSIT_QTY INV_ADJ_UNITS, 
    ils.TSF_EXPECTED_QTY*ils.AV_COST TSF_IN_COST, ils.TSF_EXPECTED_QTY*il.SELLING_UNIT_RETAIL TSF_IN_BUY, ils.TSF_EXPECTED_QTY TSF_IN_UNITS, 
    ils.TSF_RESERVED_QTY*ils.AV_COST TSF_OUT_COST,ils.TSF_RESERVED_QTY*il.SELLING_UNIT_RETAIL TSF_OUT_BUY, ils.TSF_RESERVED_QTY TSF_OUT_UNITS, 
    ils.TSF_EXPECTED_QTY*ils.AV_COST ALLOC_IN_COST, ils.TSF_EXPECTED_QTY*il.SELLING_UNIT_RETAIL ALLOC_IN_BUY, ils.TSF_EXPECTED_QTY ALLOC_IN_UNITS, 
    ils.TSF_RESERVED_QTY*ils.AV_COST ALLOC_OUT_COST,ils.TSF_RESERVED_QTY*il.SELLING_UNIT_RETAIL ALLOC_OUT_BUY, ils.TSF_RESERVED_QTY ALLOC_OUT_UNITS,
    sysdate as CREATE_DATETIME
    from rms.item_master im, 
        rms.item_master im2,
        rms.item_loc_soh ils,
        rms.item_loc il,
        rms.period
        where im.item =l_item
    and im.item_parent = im2.item
        and ils.item = im.item
        and ils.loc_type ='W'
        and ils.item =il.item
        and ils.loc =il.loc;
        
            COUNTER_COMMIT :=COUNTER_COMMIT + 1;
               IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
                COMMIT;
               END IF;	
            END LOOP; 
           
   END LOOP; 
  END LOOP; 
  COMMIT;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;           
            