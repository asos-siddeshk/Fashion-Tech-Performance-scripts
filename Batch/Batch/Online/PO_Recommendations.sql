alter session set current_schema=int_asos;

/*

alter table e2e_Items_lee add ERROR_MESSAGE varchar2(255);

begin
delete from ma_asos.MA_ORDER_REC_DETAIL_STG where order_rec_no in (select order_rec_no from ma_asos.MA_ORDER_REC_HEAD_STG where option_id  in (select option_id from e2e_Items_lee) and REC_SOURCE = 'P');
delete from ma_asos.MA_ORDER_REC_HEAD_STG where option_id  in (select option_id from e2e_Items_lee) and REC_SOURCE = 'P';
commit;
end;
/

SELECT IM.ITEM, CASE WHEN IM.ITEM_LEVEL = 1 THEN 'OPTION' WHEN IM.ITEM_LEVEL = 2 THEN 'SKU' END TYPE_OF_ITEM, im.DIVISION,dn.DIV_NAME,im.GROUP_NO, g.GROUP_NAME, IM.DEPT PRODUCT_GROUP,d.dept_name  PRODUCT_GROUP_DESC,IM.CLASS "CATEGORY",c.class_name CATEGORY_NAME, IM.SUBCLASS SUB_CATEGORY, s.sub_name SUB_CATEGORY_NAME,IM.BRAND_NAME BRAND, IM.ITEM_DESC ITEM_DESCRIPTION,IM.SHORT_DESC SHORT_DESCRIPTION, IM.DIFF_1 COLOUR,IM.DIFF_2 SIZE_GROUP,UDA_ATTRIB.SUPER_STYLE,        UDA_ATTRIB.STYLE,UDA_ATTRIB.BUSINESS_MODEL,UDA_ATTRIB.BUYING_GROUP,        UDA_ATTRIB.BUYING_SUBGROUP,UDA_ATTRIB.BUYING_SET
  FROM v_ITEM_MASTER IM,
       (SELECT ITEM,
               MAX(CASE WHEN UDA_ID = 1002 THEN UDA_TEXT END) SUPER_STYLE,
               MAX(CASE WHEN UDA_ID = 1003 THEN UDA_TEXT END) STYLE,
               MAX(CASE WHEN UDA_ID = 2010 THEN UDA_TEXT END) BUSINESS_MODEL,
               MAX(CASE WHEN UDA_ID = 2020 THEN UDA_TEXT END) BUYING_GROUP,
               MAX(CASE WHEN UDA_ID = 2030 THEN UDA_TEXT END) BUYING_SUBGROUP,
               MAX(CASE WHEN UDA_ID = 2040 THEN UDA_TEXT END) BUYING_SET
         FROM (SELECT ITEM,UDA_ID,
                      UDA_TEXT 
                 FROM UDA_ITEM_FF 
                WHERE UDA_ID IN (2010,2020,2030,2040,1002,1003))
             GROUP BY ITEM) UDA_ATTRIB,
        deps d,
         class c,
         subclass s,
         groups g,
         division dn
  WHERE IM.ITEM = UDA_ATTRIB.ITEM
    and im.division = dn.division
    and im.division = g.division
    and im.GROUP_NO = g.GROUP_NO
    and d.GROUP_NO = g.GROUP_NO
    and im.dept=d.dept
    and d.dept =c.dept
    and d.dept =S.dept
    and im.class=c.class
    and im.class=s.class
    and im.subclass=s.subclass
    and s.class=S.class
    and im.item ='100000011'
  ORDER BY DIVISION, GROUP_NO, PRODUCT_GROUP, CATEGORY, SUB_CATEGORY,TYPE_OF_ITEM;   


select * from item_supplier where item ='4301606';
select ITEM_PARENT, DIFF_2 from item_master where item ='4301606';

select * from ma_asos.MA_ORDER_REC_HEAD_STG where option_id ='100000011';
select * from ma_asos.MA_ORDER_REC_DETAIL_STG where order_rec_no in (select order_rec_no from ma_asos.MA_ORDER_REC_HEAD_STG where option_id ='100000011');


select * from ma_asos.MA_ORDER_REC_HEAD_STG where option_id  in (select option_id from e2e_Items_lee);
select * from ma_asos.MA_ORDER_REC_DETAIL_STG where order_rec_no in (select order_rec_no from ma_asos.MA_ORDER_REC_HEAD_STG where option_id  in (select option_id from e2e_Items_lee));

select * from ma_asos.MA_PO_APPROVAL_LIMIT_HEAD;
select * from ma_asos.MA_PO_APPROVAL_LIMIT_DETAIL;

*/



SET SERVEROUTPUT ON;
SET timing ON;

DECLARE
    O_status_code     varchar2(250);
	l_SKU               VARCHAR2(25) := null;
    l_SIZE_CODE         VARCHAR2(10) := null;
    l_SIZE_QTY          NUMBER(12,4) := 10000;
	l_OPTION_ITEM       VARCHAR2(25) := null;
    l_OPTION_QTY        NUMBER(12,4) := 10000;
    l_SUPPLIER_SITE     NUMBER(10) := null;
    l_FINAL_LOCATION    NUMBER(10) := '1001';
    l_FINAL_LOC_TYPE    VARCHAR2(1) := 'W';
    l_SIZE_PROFILE      VARCHAR2(10) := null;
    l_HANDOVER_DATE         DATE  := null;
    l_HANDOVER_WINDOW_START DATE := null ;
    l_HANDOVER_WINDOW_END   DATE := null ;
	COUNTER_COMMIT  NUMBER(8)     := 1;
   
	l_INT_PORECDTLDESC_REC 	"INT_PORECDTLDESC_REC";
	l_INT_PORECDTLDESC_TBL 	"INT_PORECDTLDESC_TBL";
	l_INT_PORECDESC_REC 	"INT_PORECDESC_REC" := null;
	
      O_ERROR_MESSAGE1 VARCHAR2(255);
  v_Return1 BOOLEAN;
      O_ERROR_MESSAGE2 VARCHAR2(255);
  v_Return2 BOOLEAN;
  
  cursor C_GET_ITEM is 
		select im.ITEM_PARENT, eil.RetailSKUID, im.DIFF_2,iss.supplier
			from skumar.e2e_Items_lee eil, rms.item_master im, rms.item_supplier iss 
			where eil.RetailSKUID = im.item	
				and im.item = iss.item
               	and iss.PRIMARY_SUPP_IND ='Y'
                and eil.ERROR_MESSAGE is null
                order by 1,2;

BEGIN

  for k in C_GET_ITEM loop      

	select sysdate+1+COUNTER_COMMIT into l_HANDOVER_DATE from dual;
	
		COUNTER_COMMIT :=COUNTER_COMMIT + 1;
	
			IF MOD(COUNTER_COMMIT, 20) = 0 THEN
				select sysdate+COUNTER_COMMIT into l_HANDOVER_DATE from dual;
			--commit;
			END IF;	
                 
                    l_SKU               := k.RetailSKUID;
                    l_SIZE_CODE         := k.DIFF_2;
                    l_OPTION_ITEM       := k.ITEM_PARENT;
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
                                        Update skumar.e2e_Items_lee set ERROR_MESSAGE = 'Success' where  RetailSKUID = l_SKU;
                                  ELSE
                                        Update skumar.e2e_Items_lee set ERROR_MESSAGE = O_ERROR_MESSAGE2 where  RetailSKUID = l_SKU;
                                  END IF;
					
                  ELSE
					Update skumar.e2e_Items_lee set ERROR_MESSAGE = O_ERROR_MESSAGE1 where  RetailSKUID = l_SKU;
                  END IF;                                                     
                      
                                        
    end loop;
 commit;
 
 
 
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/ 