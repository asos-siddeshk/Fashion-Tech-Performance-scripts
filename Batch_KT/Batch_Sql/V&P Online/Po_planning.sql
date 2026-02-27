select count(1) from rms.item_master where status ='A' and item_level ='1' --and Item_DESC LIKE '%Item creation Perf Test%'
        and CREATE_DATETIME>= to_date('17-MAY-2021 08.59', 'DD-MON-YYYY hh24:mi');

select * from division;



select * from skumar.ITEM_MASTER_OP im
    inner join (select item_parent,count(1) from rms.item_master  
        group by item_parent having count(1)=7) fab
    on fab.item_parent=im.item;


alter session set current_schema=int_asos;

select * from ma_asos.MA_ORDER_REC_HEAD_STG where REC_SOURCE = 'P' and option_id ='100000526';
select * from ma_asos.MA_ORDER_REC_DETAIL_STG where ORDER_REC_NO in (select ORDER_REC_NO from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'P' and option_id ='100000526'); 

--{{Item.SID01_POPlanning_Item_Number#csv.Item_Number}}


https://vptpreuwortlgw.services.kingsway.asos.com/Rms/faces/RmsLogin

select * from rms.if_errors;



--The combination of Shipping Point, Shipping Method and Freight Forwarder does not exist in the transit time matrix.

select * from all_tables where table_name like '%MATR%';

select * from ma_asos.MA_TRANSIT_MATRIX where SHIPPING_POINT = 'UNIUN';
select * from ma_asos.MA_TRANSIT_MATRIX where SHIPPING_POINT = 'RUKS2' and freight_forwarder = '1';
select * from ma_asos.MA_TRANSIT_MATRIX where SHIPPING_POINT = 'RUKS2' and freight_forwarder = '5';
select * from ma_asos.MA_TRANSIT_MATRIX where SHIPPING_POINT = 'UNIUN' and freight_forwarder = '1';

select * from ma_asos.MA_TRANSIT_MATRIX where SHIPPING_POINT = 'RUKS2' and freight_forwarder = '5';

Insert into ma_asos.MA_TRANSIT_MATRIX (SHIPPING_POINT,RECEIVING_POINT,SHIPPING_METHOD,FREIGHT_FORWARDER,CY_CUT_OFF,VESSEL_DEPARTURE,ORIGIN_DWELL,TOTAL_DAYS) values ('RUKS2',1001,'30','5','SUNDAY','SUNDAY',0,1);
Insert into ma_asos.MA_TRANSIT_MATRIX (SHIPPING_POINT,RECEIVING_POINT,SHIPPING_METHOD,FREIGHT_FORWARDER,CY_CUT_OFF,VESSEL_DEPARTURE,ORIGIN_DWELL,TOTAL_DAYS) values ('RUKS2',3001,'30','5','SUNDAY','SUNDAY',0,1);
Insert into ma_asos.MA_TRANSIT_MATRIX (SHIPPING_POINT,RECEIVING_POINT,SHIPPING_METHOD,FREIGHT_FORWARDER,CY_CUT_OFF,VESSEL_DEPARTURE,ORIGIN_DWELL,TOTAL_DAYS) values ('RUKS2',4001,'30','5','SUNDAY','SUNDAY',0,1);


select * from rms.partner;
select * from rms.code_detail where code_type like 'SHPM';

                
The combination of Shipping Point, Shipping Method and Freight Forwarder does not exist in the transit time matrix;



select * from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'P' and option_id ='100876439';
select * from ma_asos.MA_ORDER_REC_DETAIL_STG  where ORDER_REC_NO  in (select ORDER_REC_NO from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'P' and option_id ='100876439'); 


select * from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'P' and trunc(CREATE_DATETIME)> ='17-MAY-21';
select * from ma_asos.MA_ORDER_REC_DETAIL_STG  where ORDER_REC_NO  in (select ORDER_REC_NO from ma_asos.MA_ORDER_REC_HEAD_STG  where REC_SOURCE = 'P' and trunc(CREATE_DATETIME) ='17-MAY-21'); 

select * from ordhead;

alter session set current_schema=int_asos;
              
SET SERVEROUTPUT ON;
SET timing ON;

DECLARE

    O_status_code               varchar2(250);
	l_Item                      rms.item_master.item%type;
	l_SKU                       rms.item_master.item%type;
    l_SIZE_CODE                 VARCHAR2(10) := null;
    l_SIZE_QTY                  NUMBER(12,4) := 10;
	l_OPTION_ITEM               rms.item_master.item%type;
    l_OPTION_QTY                NUMBER(12,4) := 70;
    l_SUPPLIER_SITE             NUMBER(10) := null;
    l_FINAL_LOCATION            NUMBER(10) := '1001';
    l_FINAL_LOC_TYPE            VARCHAR2(1) := 'W';
    l_SIZE_PROFILE              VARCHAR2(10) := null;
    l_HANDOVER_DATE             DATE  := null;
    l_HANDOVER_WINDOW_START     DATE := null ;
    l_HANDOVER_WINDOW_END       DATE := null ;
	COUNTER_COMMIT              NUMBER(8)     := 1;
	l_COMMIT                    NUMBER(8)     := 1;
   
	l_INT_PORECDTLDESC_REC 	"INT_PORECDTLDESC_REC";
	l_INT_PORECDTLDESC_TBL 	"INT_PORECDTLDESC_TBL";
	l_INT_PORECDESC_REC 	"INT_PORECDESC_REC" := null;
	
      O_ERROR_MESSAGE1 VARCHAR2(255);
  v_Return1 BOOLEAN;
      O_ERROR_MESSAGE2 VARCHAR2(255);
  v_Return2 BOOLEAN;
  
      cursor C_GET_ITEM_PAR is 
                select distinct im.item_parent,iss.supplier
                        from skumar.item_master_op so, rms.item_master im, rms.item_supplier iss 
                        where so.item= im.item_parent	
                            and im.item_parent = iss.item
                            and iss.supplier = '1100000086'
                            and im.CREATE_DATETIME>= to_date('17-MAY-2021 08.20', 'DD-MON-YYYY hh24:mi')
                            and iss.PRIMARY_SUPP_IND ='Y'
--                            and not exists (select 1 from ma_asos.MA_ORDER_REC_DETAIL_STG mrd, ma_asos.MA_ORDER_REC_HEAD_STG mrh where mrh.ORDER_REC_NO = mrd.ORDER_REC_NO and mrh.REC_SOURCE= 'P' and mrh.OPTION_ID= so.item and mrd.SIZE_CODE = im.diff_2) 
                          -- and rownum <= '2500' 
                            order by 1,2;

      cursor C_GET_ITEM_SKU (L_item rms.item_master.item%type) is 
                select im.item, im.DIFF_2 from rms.item_master im where im.item_parent = l_item 
                      order by 1,2;

BEGIN

  for k in C_GET_ITEM_PAR loop      

            l_OPTION_ITEM       := k.item_parent;
            l_SUPPLIER_SITE     := k.supplier;

	select sysdate+50 into l_HANDOVER_DATE from dual;
	select sysdate+50 into l_HANDOVER_WINDOW_START from dual;
	select sysdate+100 into l_HANDOVER_WINDOW_END from dual;  
 
    l_INT_PORECDTLDESC_REC := "INT_PORECDTLDESC_REC"(null,null,null);
	l_INT_PORECDTLDESC_TBL := "INT_PORECDTLDESC_TBL"();
    
     for j in C_GET_ITEM_SKU (l_OPTION_ITEM)  loop 
          EXIT WHEN C_GET_ITEM_SKU%NOTFOUND;
                    l_SKU               := j.item;
                    l_SIZE_CODE         := j.DIFF_2;

            l_INT_PORECDTLDESC_REC.SKU :=l_SKU;
            l_INT_PORECDTLDESC_REC.SIZE_CODE :=l_SIZE_CODE;
            l_INT_PORECDTLDESC_REC.SIZE_QTY := l_SIZE_QTY;
 
            l_INT_PORECDTLDESC_TBL.EXTEND();
            l_INT_PORECDTLDESC_TBL(l_INT_PORECDTLDESC_TBL.COUNT) := l_INT_PORECDTLDESC_REC; 

         END LOOP;     
    		      
                  l_INT_PORECDESC_REC := "INT_PORECDESC_REC"( l_OPTION_ITEM,
																l_OPTION_QTY,
																l_SUPPLIER_SITE,
																l_FINAL_LOCATION,
																l_FINAL_LOC_TYPE,
																l_SIZE_PROFILE,
																l_HANDOVER_DATE,
																l_HANDOVER_WINDOW_START,
																l_HANDOVER_WINDOW_END,
																l_INT_PORECDTLDESC_TBL);
	 
              v_Return1 := INT_ASOS.INT_PL_PO_REC_SQL.VALIDATE_PO_REC(I_PORECDESC => l_INT_PORECDESC_REC,
                                                                     O_ERROR_MESSAGE => O_ERROR_MESSAGE1);
                                                                                                                       
                        IF (v_Return1) THEN 
                         v_Return2 := INT_ASOS.INT_PL_PO_REC_SQL.PERSIST_PO_REC(I_PORECDESC => l_INT_PORECDESC_REC,
                                                            O_ERROR_MESSAGE => O_ERROR_MESSAGE2);
														
                                  IF (v_Return2) THEN 
                                        continue;
                                  ELSE
                                        insert into rms.if_errors values ('Planning1','17-MAY-21',l_SKU,O_ERROR_MESSAGE2); 
                                  END IF;
					
                  ELSE
					insert into rms.if_errors values ('Planning2','17-MAY-21',l_SKU,O_ERROR_MESSAGE1); 
                  END IF;                                                     
                      
                                        
    end loop;
  --commit;
 
 
 
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/ 


select * from rms.if_errors;


/* Old 
                
SET SERVEROUTPUT ON;
SET timing ON;

DECLARE
    O_status_code     varchar2(250);
	l_SKU               VARCHAR2(25) := null;
    l_SIZE_CODE         VARCHAR2(10) := null;
    l_SIZE_QTY          NUMBER(12,4) := 100;
	l_OPTION_ITEM       VARCHAR2(25) := null;
    l_OPTION_QTY        NUMBER(12,4) := 100;
    l_SUPPLIER_SITE     NUMBER(10) := null;
    l_FINAL_LOCATION    NUMBER(10) := '1001';
    l_FINAL_LOC_TYPE    VARCHAR2(1) := 'W';
    l_SIZE_PROFILE      VARCHAR2(10) := null;
    l_HANDOVER_DATE         DATE  := null;
    l_HANDOVER_WINDOW_START DATE := null ;
    l_HANDOVER_WINDOW_END   DATE := null ;
	COUNTER_COMMIT  NUMBER(8)     := 1;
	l_COMMIT  NUMBER(8)     := 1;
   
	l_INT_PORECDTLDESC_REC 	"INT_PORECDTLDESC_REC";
	l_INT_PORECDTLDESC_TBL 	"INT_PORECDTLDESC_TBL";
	l_INT_PORECDESC_REC 	"INT_PORECDESC_REC" := null;
	
      O_ERROR_MESSAGE1 VARCHAR2(255);
  v_Return1 BOOLEAN;
      O_ERROR_MESSAGE2 VARCHAR2(255);
  v_Return2 BOOLEAN;
  
  cursor C_GET_ITEM is 
	select im.item_parent, im.item, im.DIFF_2 ,iss.supplier
			from skumar.item_master_op so, rms.item_master im, rms.item_supplier iss 
			where so.item= im.item_parent	
				and im.item_parent = iss.item
               -- and so.item = '100876439'
                and iss.supplier = '1100000118'
               	and iss.PRIMARY_SUPP_IND ='Y'
                and not exists (select 1 from ma_asos.MA_ORDER_REC_DETAIL_STG mrd, ma_asos.MA_ORDER_REC_HEAD_STG mrh 
            where mrh.ORDER_REC_NO = mrd.ORDER_REC_NO and mrh.REC_SOURCE= 'P' and mrh.OPTION_ID= so.item and mrd.SIZE_CODE = im.diff_2) 
               and rownum <= '1000' 
                order by 1,2;

BEGIN

  for k in C_GET_ITEM loop      

	select sysdate+5 into l_HANDOVER_DATE from dual;
	select sysdate+5 into l_HANDOVER_WINDOW_START from dual;
	select sysdate+10 into l_HANDOVER_WINDOW_END from dual;  
    
		COUNTER_COMMIT :=COUNTER_COMMIT + 1;
	
	     
                    l_SKU               := k.item;
                    l_SIZE_CODE         := k.DIFF_2;
                    l_OPTION_ITEM       := k.item_parent;
                    l_SUPPLIER_SITE     := k.supplier;

    
    l_INT_PORECDTLDESC_REC := "INT_PORECDTLDESC_REC"(null,null,null);
	l_INT_PORECDTLDESC_TBL := "INT_PORECDTLDESC_TBL"();

	l_INT_PORECDTLDESC_REC.SKU :=l_SKU;
    l_INT_PORECDTLDESC_REC.SIZE_CODE :=l_SIZE_CODE;
    l_INT_PORECDTLDESC_REC.SIZE_QTY :=l_SIZE_QTY;
	
    l_INT_PORECDTLDESC_TBL.EXTEND();
    l_INT_PORECDTLDESC_TBL(l_INT_PORECDTLDESC_TBL.COUNT) := l_INT_PORECDTLDESC_REC; 
    
    
    		      l_INT_PORECDESC_REC := "INT_PORECDESC_REC"( l_OPTION_ITEM,
																l_OPTION_QTY,
																l_SUPPLIER_SITE,
																l_FINAL_LOCATION,
																l_FINAL_LOC_TYPE,
																l_SIZE_PROFILE,
																l_HANDOVER_DATE,
																l_HANDOVER_WINDOW_START,
																l_HANDOVER_WINDOW_END,
																l_INT_PORECDTLDESC_TBL);
	 
              v_Return1 := INT_ASOS.INT_PL_PO_REC_SQL.VALIDATE_PO_REC(I_PORECDESC => l_INT_PORECDESC_REC,
                                                                     O_ERROR_MESSAGE => O_ERROR_MESSAGE1);
                                                                                                                       
                        IF (v_Return1) THEN 
                         v_Return2 := INT_ASOS.INT_PL_PO_REC_SQL.PERSIST_PO_REC(I_PORECDESC => l_INT_PORECDESC_REC,
                                                            O_ERROR_MESSAGE => O_ERROR_MESSAGE2);
														
                                  IF (v_Return2) THEN 
                                        continue;
                                  ELSE
                                        insert into rms.if_errors values ('Planning1','12-MAR-20',l_SKU,O_ERROR_MESSAGE2); 
                                  END IF;
					
                  ELSE
					insert into rms.if_errors values ('Planning2','12-MAR-20',l_SKU,O_ERROR_MESSAGE1); 
                  END IF;                                                     
                      
                                        
    end loop;
  --commit;
 
 
 
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/ 


select * from rms.if_errors;
