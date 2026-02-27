create or replace PACKAGE BODY WP_SO_IMPORT_SQL AS
--------------------------------------------------------------------------------
FUNCTION GET_CONFIG(O_error_message IN OUT VARCHAR2)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.GET_CONFIG';

BEGIN

 select
    MAX_CHUNK_SIZE,
    MAX_CONCURRENT_THREADS,
    RETRY_WAIT_TIME,
    RETRY_LOCK_ATTEMPTS
 into
    G_chunk_size,
    G_max_threads,
    G_lockwait,
    G_lockattempts
 from wp_plsql_batch_config
    where program_name = 'WP_SO_IMPORT_SQL';

 return true;

EXCEPTION
  when NO_DATA_FOUND then
    O_error_message:='Could not find configuration value for WP_SO_IMPORT_SQL' ||' - '||L_program;
    return false;
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;
END GET_CONFIG;
--------------------------------------------------------------------------------
FUNCTION SIZE_SKU_MAP(O_error_message IN OUT VARCHAR2,
                      I_option IN VARCHAR2,
                      I_size_code IN VARCHAR2,
                      O_sku OUT VARCHAR2)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.SIZE_SKU_MAP';

BEGIN

 SELECT ITEM
 INTO O_sku
 FROM ITEM_MASTER IM
 WHERE im.ITEM_PARENT = I_option
 AND im.diff_2 = I_size_code;

 return true;

EXCEPTION
  when NO_DATA_FOUND then
    O_error_message:='SKU not found for size: ' || I_size_code || ' of the option' ||' - '||L_program;
    return false;
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;
END SIZE_SKU_MAP;
--------------------------------------------------------------------------------
FUNCTION SKU_EAN_CHECK(O_error_message IN OUT VARCHAR2,
                      I_sku IN VARCHAR2)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.SKU_EAN_CHECK';
l_primary_ean VARCHAR2(25);

BEGIN

 SELECT ITEM
 INTO l_primary_ean
 FROM ITEM_MASTER IM
 WHERE im.ITEM_PARENT = I_sku
 AND PRIMARY_REF_ITEM_IND = 'Y';

 return true;

EXCEPTION
  when NO_DATA_FOUND then
    O_error_message:='EAN not found for SKU: ' || I_sku || ' - '||L_program;
    return false;
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;
END SKU_EAN_CHECK;
--------------------------------------------------------------------------------
FUNCTION POPULATE_DTL_OBJECT(O_error_message IN OUT VARCHAR2,
                             I_HEAD_REC IN OUT NOCOPY WP_ORDER_HEAD_REC)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.POPULATE_DTL_OBJECT';
l_sku VARCHAR2(25);
l_po_sku varchar2(25);
L_SUM_QTY NUMBER(10);

CURSOR c_sizes IS
with rws as (
  select I_HEAD_REC.UNITS_BY_SIZE str from dual
)
select size_code, qty
from (
select SUBSTR(value, 1, INSTR(value, ':')-1) AS size_code,
        to_number(SUBSTR(value, INSTR(value, ':')+1)) AS qty
        from (
  select regexp_substr (
           str,
           '[^|]+',
           1,
           level
         ) value
  from   rws
  connect by level <=
    length ( str ) - length ( replace ( str, '|' ) ) + 1))
    where size_code is not null;

l_detail WP_ORDER_DETAIL_REC;
l_po_loc number(10);
l_alloc_loc number(10);
l_po_qty number(10);
l_alc_qty number(10);
l_soh number(10);

BEGIN

    I_HEAD_REC.DETAILS := WP_ORDER_DETAIL_TBL();
    L_SUM_QTY := 0;

    --NOTE
    --DO WE GET UNITS BY SIZE / TOTAL UNITS IF IT'S A CANCEL
    --IF NOT, MOVE BELOW PROCESSING TO AN IF CLAUSE
    --
    FOR C_size IN c_sizes
    loop
    	
    	IF C_size.qty - floor(C_size.qty) > 0 THEN
        	O_error_message := 'Unit quantity is a decimal for size: ' || C_size.size_code;
        	RETURN FALSE;
        ELSIF C_size.qty < 0 THEN
        	O_error_message := 'Unit quantity is a negative value for size: ' || C_size.size_code;
        	RETURN FALSE;
    	END IF;

        select WP_ORDER_DETAIL_REC(NULL,       --ITEM
                                    NULL,       --SOURCE_LOC_TYPE
                                    SS.DELIVERY_FC,       --SOURCE_LOC_ID
                                    I_HEAD_REC.PARTNER_LOC_ID,        --CUSTOMER_LOC
                                    NULL,       --ORIGINAL_QTY
                                    C_size.qty,       --CURRENT_QTY,
                                    NULL,       --ORIGINAL_PARTNER_PRICE
                                    SS.SELL_PRICE,       --CURRENT_PARTNER_PRICE
                                    NULL,       --ORIGINAL_WINDOW_START_DATE,
                                    SS.DELIVERY_NOT_BEFORE_DATE,        --CURRENT_WINDOW_START_DATE
                                    NULL,       --ORIGINAL_WINDOW_END_DATE,
                                    SS.DELIVERY_NOT_AFTER_DATE,     --CURRENT_WINDOW_END_DATE
                                    I_HEAD_REC.CANCEL_REASON,       --CANCEL_REASON
                                    I_HEAD_REC.CANCEL_DATE,       --CANCEL_DATE
                                    C_size.SIZE_CODE,
                                    RRP_GBP,
                                    RRP_EUR,
                                    RRP_USD,
                                    RRP_CAD,
                                    null, --cancelled qty
                                    SS.DC_ID,
                                    SS.STORE_ID,        --PARTNER_STORE_ID
                                    ROWIDTOCHAR(rowid),
                                    SS.INT_STATUS,           --INT_STATUS
                                    NULL        --ERROR_MSG
                                     )
        INTO l_detail
        FROM WP_SO_IMPORT_STG SS
        WHERE SS.rowid = I_HEAD_REC.LOAD_STG_ROWID;

        I_HEAD_REC.DETAILS.extend;
        I_HEAD_REC.DETAILS(I_HEAD_REC.DETAILS.count) := l_detail;

        L_SUM_QTY := L_SUM_QTY + C_size.qty;

    end loop;

    IF L_SUM_QTY <> I_HEAD_REC.PARTNER_TOTAL_UNITS
    THEN
        O_error_message := 'Sum of units by size does not match total units.';
        RETURN FALSE;
    END IF;

    for i in I_HEAD_REC.DETAILS.FIRST .. I_HEAD_REC.DETAILS.LAST
    LOOP

        IF SIZE_SKU_MAP(O_error_message, I_HEAD_REC.option_id, I_HEAD_REC.DETAILS(i).SIZE_CODE, l_sku) = FALSE
        THEN
            RETURN FALSE;
        END IF;
        
        IF SKU_EAN_CHECK(O_error_message, l_sku) = FALSE
        THEN
            RETURN FALSE;
        END IF;

        --validate soh
        IF I_HEAD_REC.SALES_ORDER_TYPE = 'WH' THEN

            BEGIN
                SELECT STOCK_ON_HAND
                INTO l_soh
                FROM ITEM_LOC_SOH ILS
                WHERE ILS.ITEM = l_sku
                AND ILS.LOC = I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID;

                IF l_soh < I_HEAD_REC.DETAILS(i).CURRENT_QTY THEN
                    O_error_message:='Not enough stock for the item: ' || l_sku || ' - ' ||L_program;
                    return false;
                END IF;

        		I_HEAD_REC.DETAILS(i).ITEM := l_sku;

                EXCEPTION
                WHEN NO_DATA_FOUND then
                    O_error_message:='Not enough stock for the item: ' || l_sku || ' - ' ||L_program;
                    return false;
            END;

        --validate SKU-s are the same on the Supplier PO
        ELSIF I_HEAD_REC.SALES_ORDER_TYPE = 'PO' THEN

        	BEGIN

        		SELECT ITEM,
        		       LOCATION,
        		       QTY_ORDERED
        		INTO l_po_sku,
        		     l_po_loc,
        		     l_po_qty
        		FROM ORDLOC
        		WHERE ORDER_NO = I_HEAD_REC.ORDER_NO
        		AND ITEM = l_sku;

        		EXCEPTION
        		WHEN NO_DATA_FOUND then
        		    O_error_message:='Could not find SKU on Supplier PO' ||' - '||L_program;
        		    return false;
        		WHEN TOO_MANY_ROWS then
        		    O_error_message:='Supplier PO has more than one location' ||' - '||L_program;
        		    return false;

        	END;

        	I_HEAD_REC.DETAILS(i).ITEM := l_sku;

        	--validate po loc
        	IF I_HEAD_REC.PO_TYPE = 'D' AND I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID <> l_po_loc
        	THEN
        	    O_error_message:='Delivery FC does not match Supplier PO location.' ||' - '||L_program;
        	    return false;
        	ELSIF I_HEAD_REC.PO_TYPE = 'S'
        	THEN
        	    BEGIN

        	        SELECT ALD.TO_LOC,
        	               SUM(QTY_ALLOCATED)
        	        INTO l_alloc_loc,
        	             l_alc_qty
        	        FROM ALLOC_HEADER ALH,
        	             ALLOC_DETAIL ALD
        	        WHERE ALH.ALLOC_NO = ALD.ALLOC_NO
        	        AND   ALH.ORDER_NO = I_HEAD_REC.ORDER_NO
        	        AND   ALH.ITEM = I_HEAD_REC.DETAILS(i).ITEM
        	        AND   ALH.WH = l_po_loc
        	        GROUP BY ALD.TO_LOC;

        	    EXCEPTION
        	    WHEN NO_DATA_FOUND then
        	        O_error_message:='Could not find allocation for the Supplier PO' ||' - '||L_program;
        	        return false;
        	    END;

        	    IF I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID <> l_alloc_loc
        	    THEN
        	        O_error_message:='Delivery FC does not match Allocation final location.' ||' - '||L_program;
        	        return false;
        	    END IF;

        	    IF I_HEAD_REC.ACTION_TYPE = Gv_create AND nvl(l_alc_qty,0) <> nvl(l_po_qty,0) THEN
        	        O_error_message:='Not 100% allocation to final destination for item: ' || I_HEAD_REC.DETAILS(i).ITEM ||' - '||L_program;
        	        return false;
        	    END IF;

        	ELSIF I_HEAD_REC.PO_TYPE not in ('D','S') THEN
        	    O_error_message:='Supplier PO is not Direct / Split' ||' - '||L_program;
        	    return false;
        	END IF;

        END IF;

    END LOOP;

 return true;

EXCEPTION
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;

END POPULATE_DTL_OBJECT;
--------------------------------------------------------------------------------
FUNCTION POPULATE_HEAD_OBJECT(O_error_message IN OUT VARCHAR2,
                              I_HEAD_REC IN OUT NOCOPY WP_ORDER_HEAD_REC)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.POPULATE_HEAD_OBJECT';
L_po_status VARCHAR2(1);
L_po_type varchar2(1);
l_status varchar2(1);
l_release_ind varchar2(1);
l_customer_id NUMBER(10);
l_is_despatched VARCHAR2(1);
l_is_posted VARCHAR2(1);

CURSOR C_customer_id IS
SELECT WF_CUSTOMER_ID
FROM STORE
WHERE STORE = I_HEAD_REC.PARTNER_LOC_ID;

CURSOR C_is_despatched (i_wp_so_no number) IS
SELECT 'Y'
FROM DUAL
WHERE EXISTS (SELECT 'X'
              FROM NB_WP_RMS_XREF XR,
                   WF_ORDER_HEAD WOH
              WHERE WOH.WF_ORDER_NO = XR.XREF_WF_ORDER_NO
              AND XR.SALES_ORDER_NO = i_wp_so_no
              AND WOH.STATUS in ('D', 'P'));

CURSOR C_is_posted (i_wp_so_no number) IS
SELECT 'Y'
FROM DUAL
WHERE EXISTS (SELECT 'X'
              FROM NB_WP_RMS_XREF XR,
                   NB_WF_BILL_EXT WBS
              WHERE WBS.DISTRO_NO = XR.XREF_ALLOC_NO
              AND XR.SALES_ORDER_NO = i_wp_so_no
              AND WBS.EXTRACTED_IND = 'Y');

BEGIN

    BEGIN
    --determine action type and SALES_ORDER_NO
        SELECT SALES_ORDER_NO,
               STATUS,
               RELEASE_IND
        INTO I_HEAD_REC.SALES_ORDER_NO,
             l_status,
             l_release_ind
        FROM WP_ORDER_HEAD
        WHERE EXTERNAL_ORDER_NO = I_HEAD_REC.EXTERNAL_ORDER_NO;

        IF l_status = WP_ORDER_APPROVAL_SQL.CANCELLED OR l_release_ind = 'Y'
        THEN
            O_error_message := 'Sales Order cannot be modified due to its status.' ||' - '||L_program;
            return false;
        END IF;

        open C_is_despatched(I_HEAD_REC.SALES_ORDER_NO);
    	fetch C_is_despatched into l_is_despatched;
    	IF C_is_despatched%NOTFOUND THEN
        	l_is_despatched := 'N';
    	END IF;
    	close C_is_despatched;

        IF l_is_despatched = 'Y'
        THEN
            O_error_message := 'Sales Order cannot be modified due to its status.' ||' - '||L_program;
            return false;
        END IF;

        open C_is_posted(I_HEAD_REC.SALES_ORDER_NO);
    	fetch C_is_posted into l_is_posted;
    	IF C_is_posted%NOTFOUND THEN
        	l_is_posted := 'N';
    	END IF;
    	close C_is_posted;

        IF l_is_posted = 'Y'
        THEN
            O_error_message := 'Sales Order cannot be modified due to its status.' ||' - '||L_program;
            return false;
        END IF;

        I_HEAD_REC.ACTION_TYPE := GV_update;

        EXCEPTION
            WHEN NO_DATA_FOUND then
                I_HEAD_REC.ACTION_TYPE := Gv_create;
    END;

    open C_customer_id;
    fetch C_customer_id into l_customer_id;
    IF C_customer_id%NOTFOUND THEN
        o_error_message := 'Could not find customer id for partner location.';
        close C_customer_id;
        return false;
    END IF;
    close C_customer_id;

    I_HEAD_REC.CUSTOMER_ID := l_customer_id;

    --CANCELED?
    --PARTNER
    IF I_HEAD_REC.PARTNER_CANCEL_REASON IS NOT NULL THEN
        I_HEAD_REC.CANCEL_REASON := I_HEAD_REC.PARTNER_CANCEL_REASON;
        I_HEAD_REC.CANCEL_DATE := I_HEAD_REC.PARTNER_CANCEL_DATE;
    END IF;

    --ORDER ROW
    IF I_HEAD_REC.ORDER_ROW_CANCEL_REASON IS NOT NULL THEN
        I_HEAD_REC.CANCEL_REASON := I_HEAD_REC.ORDER_ROW_CANCEL_REASON;
        I_HEAD_REC.CANCEL_DATE := I_HEAD_REC.ORDER_ROW_CANCEL_DATE;
    END IF;

    --ORDER NO and type FETCH
    IF I_HEAD_REC.SALES_ORDER_TYPE = 'PO' THEN
        BEGIN

        	SELECT OH.ORDER_NO,
        	       OH.PO_TYPE,
        	       OH.STATUS
        	INTO I_HEAD_REC.ORDER_NO,
        	     I_HEAD_REC.PO_TYPE,
        	     L_po_status
        	FROM V_CFA_PO_DATE_G CF,
        	     ORDHEAD OH
        	WHERE CF.WHOLESALE_ROW_CODE_ID = I_HEAD_REC.ORDER_ROW_CODE
        	AND CF.ORDER_NO = OH.ORDER_NO
        	--AND OH.STATUS = 'A'
        	;
	
        	EXCEPTION
        	when NO_DATA_FOUND then
        	    O_error_message:='Could not find Supplier PO for the wholesale Order Row Code' ||' - '||L_program;
        	    return false;
        	when TOO_MANY_ROWS then
        	    O_error_message:='More than one Supplier PO is having this Order Row Code.' ||' - '||L_program;
        	    return false;
        END;

    	IF L_po_status <> 'A' THEN
    		IF I_HEAD_REC.ACTION_TYPE = GV_CREATE THEN
    			O_error_message:='Could not find approved Supplier PO for the wholesale order row code.' ||' - '||L_program;
    	        return false;
    	    ELSE
    	    	IF I_HEAD_REC.CANCEL_REASON IS NULL THEN
    	    		O_error_message:='Supplier PO must be in approved status, only cancellation is allowed on this Sales Order.' ||' - '||L_program;
    	        return false;
    	    	END IF;
    		END IF;
    	END IF;
    	

    END IF;

    IF I_HEAD_REC.ACTION_TYPE = GV_CREATE THEN

        BEGIN

        SELECT CODE, CODE_DESC
        INTO I_HEAD_REC.CONTEXT_TYPE,
             I_HEAD_REC.CONTEXT_VALUE
        FROM CODE_DETAIL
        WHERE CODE_TYPE = 'CNTX'
        AND CODE = 'WSALE';

        EXCEPTION
            when NO_DATA_FOUND then
                O_error_message:='Could not determine CONTEXT TYPE / VALUE' ||' - '||L_program;
                return false;
        END;


        --FREIGHT
        BEGIN

        SELECT VALUE_1
        INTO I_HEAD_REC.FREIGHT
        FROM WP_SYSTEM_PARAMETERS
        WHERE FUNC_AREA = 'FREIGHT'
        AND PARAMETER = 'FREIGHT_TYPE'
        AND VALUE_3 = 'D';

        EXCEPTION
            when NO_DATA_FOUND then
                O_error_message:='Could not determine freight type' ||' - '||L_program;
                return false;
        END;

    END IF;

    IF POPULATE_DTL_OBJECT(o_error_message, I_HEAD_REC) = FALSE
    THEN
        return false;
    END IF;

    --DEFAULT SETS
    BEGIN
        SELECT cr.exchange_rate
        into I_HEAD_REC.EXCHANGE_RATE
                                          FROM mv_currency_conversion_rates cr
                                         WHERE cr.from_currency  = I_HEAD_REC.CURRENCY_CODE
                                           AND cr.to_currency    = 'GBP'
                                           AND cr.exchange_type  = 'C'
                                           AND cr.effective_date = (SELECT MAX(cr_aux.effective_date)
                                                                      FROM mv_currency_conversion_rates cr_aux
                                                                     WHERE cr_aux.from_currency = cr.from_currency
                                                                       AND cr_aux.to_currency   = cr.to_currency
                                                                       AND cr_aux.exchange_type = cr.exchange_type);

    EXCEPTION
        when NO_DATA_FOUND then
            O_error_message:='Could not determine exchange rate' ||' - '||L_program;
            return false;
    END;

    --order type
    I_HEAD_REC.ORDER_TYPE := 'X';
    --I_HEAD_REC.RELEASE_IND := 'N';
    --I_HEAD_REC.HOLD_IND := 'N';
    --I_HEAD_REC.REDIST_IND := 'N';

    --I_HEAD_REC.STATUS := 'W';


 return true;

EXCEPTION
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;

END POPULATE_HEAD_OBJECT;
--------------------------------------------------------------------------------
FUNCTION PERSIST_UPDATE(O_error_message IN OUT VARCHAR2,
                        I_HEAD_REC IN OUT NOCOPY WP_ORDER_HEAD_REC)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.PERSIST_UPDATE';

CURSOR C_woh_rec IS
SELECT  SALES_ORDER_NO,
        EXTERNAL_ORDER_NO,
        CUSTOMER_ID,
        SALES_ORDER_TYPE,
        ORDER_NO,
        ORDER_ROW_CODE,
        STATUS,
        ORDER_TYPE,
        CURRENCY_CODE,
        EXCHANGE_RATE,
        COMMENTS,
        HOLD_IND,
        REDIST_IND,
        PARTNER_ORDER_NO,
        CONTEXT_TYPE,
        CONTEXT_VALUE,
        RELEASE_IND,
        RELEASE_DATE,
        CANCEL_REASON,
        CANCEL_DATE,
        FREIGHT,
        CREATE_ID,
        CREATE_DATETIME,
        LAST_UPDATE_ID,
        LAST_UPDATE_DATETIME,
        PARTNER_DEPT_NO
FROM WP_ORDER_HEAD WOH
WHERE WOH.SALES_ORDER_NO = I_HEAD_REC.SALES_ORDER_NO;

CURSOR C_wod_rec(i_item varchar2, i_SOURCE_LOC_ID number)  IS
SELECT SALES_ORDER_NO,
       ITEM,
       SOURCE_LOC_TYPE,
       SOURCE_LOC_ID,
       CUSTOMER_LOC,
       ORIGINAL_QTY,
       CURRENT_QTY,
       ORIGINAL_PARTNER_PRICE,
       CURRENT_PARTNER_PRICE,
       ORIGINAL_WINDOW_START_DATE,
       CURRENT_WINDOW_START_DATE,
       ORIGINAL_WINDOW_END_DATE,
       CURRENT_WINDOW_END_DATE,
       CANCEL_REASON,
       CANCEL_DATE,
       RRP_GBP,
       RRP_EUR,
       RRP_USD,
       RRP_CAD,
       CANCELLED_QTY,
       PARTNER_DC_ID,
       PARTNER_STORE_ID,
       CREATE_ID,
       CREATE_DATETIME,
       LAST_UPDATE_ID,
       LAST_UPDATE_DATETIME
FROM WP_ORDER_DETAIL WOD
WHERE WOD.SALES_ORDER_NO = I_HEAD_REC.SALES_ORDER_NO
AND ITEM = i_item
AND SOURCE_LOC_ID = i_SOURCE_LOC_ID;

L_H_REC WP_ORDER_HEAD%ROWTYPE;
L_D_REC WP_ORDER_DETAIL%ROWTYPE;

L_H_NEED_UPDATE BOOLEAN := FALSE;
L_D_NEED_UPDATE BOOLEAN := FALSE;

BEGIN

    OPEN C_woh_rec;
    FETCH C_woh_rec INTO L_H_REC;
    CLOSE C_woh_rec;

    --validation of non modifiable columns
    --CUSTOMER ID
    IF L_H_REC.CUSTOMER_ID <> I_HEAD_REC.CUSTOMER_ID
    THEN
        O_error_message := 'Customer ID cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;

    --SALES_ORDER_TYPE
    IF L_H_REC.SALES_ORDER_TYPE <> I_HEAD_REC.SALES_ORDER_TYPE
    THEN
        O_error_message := 'Sales Order Type cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;

    --ORDER_NO
    IF L_H_REC.ORDER_NO <> I_HEAD_REC.ORDER_NO
    THEN
        O_error_message := 'Supplier PO number cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;

    --ORDER_TYPE
    IF L_H_REC.ORDER_TYPE <> I_HEAD_REC.ORDER_TYPE
    THEN
        O_error_message := 'Order Type number cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;

    --ORDER_ROW_CODE
    IF L_H_REC.ORDER_ROW_CODE <> I_HEAD_REC.ORDER_ROW_CODE
    THEN
        O_error_message := 'Order Row Code number cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;
    /*
    --HOLD_IND
    IF L_H_REC.HOLD_IND <> I_HEAD_REC.HOLD_IND
    THEN
        O_error_message := 'Hold Indicator cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;
    */

    /*
    --REDIST_IND
    IF L_H_REC.REDIST_IND <> I_HEAD_REC.REDIST_IND
    THEN
        O_error_message := 'Redist Indicator cannot be modified on the existing Sales Order.';
        RETURN FALSE;
    END IF;
    */

    --IS THERE AN UPADTE
    --EXTERNAL_ORDER_NO
    IF L_H_REC.EXTERNAL_ORDER_NO <> I_HEAD_REC.EXTERNAL_ORDER_NO
    THEN
        L_H_NEED_UPDATE := TRUE;
    --CURRENCY_CODE
    ELSIF L_H_REC.CURRENCY_CODE <> I_HEAD_REC.CURRENCY_CODE
    THEN
        L_H_NEED_UPDATE := TRUE;
    --EXCHANGE_RATE
    ELSIF L_H_REC.EXCHANGE_RATE <> I_HEAD_REC.EXCHANGE_RATE
    THEN
        L_H_NEED_UPDATE := TRUE;
    --CANCEL_REASON
    ELSIF NVL(L_H_REC.CANCEL_REASON,'') <> NVL(I_HEAD_REC.CANCEL_REASON,'')
    THEN
        L_H_NEED_UPDATE := TRUE;
    --CANCEL_DATE
    ELSIF NVL(L_H_REC.CANCEL_DATE,to_date('1999-01-01','YYYY-MM-DD')) <> NVL(I_HEAD_REC.CANCEL_DATE,to_date('1999-01-01','YYYY-MM-DD'))
    THEN
        L_H_NEED_UPDATE := TRUE;
    /*
    --COMMENTS
    ELSIF L_H_REC.COMMENTS <> I_HEAD_REC.COMMENTS
    THEN
        L_H_NEED_UPDATE := TRUE;
    --PARTNER_DC_ID
    ELSIF L_H_REC.PARTNER_DC_ID <> I_HEAD_REC.PARTNER_DC_ID
    THEN
        L_H_NEED_UPDATE := TRUE;
    --PARTNER_STORE_ID
    ELSIF L_H_REC.PARTNER_STORE_ID <> I_HEAD_REC.PARTNER_STORE_ID
    THEN
        L_H_NEED_UPDATE := TRUE;
    */
    --PARTNER_ORDER_NO
    ELSIF L_H_REC.PARTNER_ORDER_NO <> I_HEAD_REC.PARTNER_ORDER_NO
    THEN
        L_H_NEED_UPDATE := TRUE;
    /*
    --FREIGHT
    ELSIF L_H_REC.FREIGHT <> I_HEAD_REC.FREIGHT
    THEN
        L_H_NEED_UPDATE := TRUE;
    */
    END IF;

    FOR I IN I_HEAD_REC.DETAILS.FIRST .. I_HEAD_REC.DETAILS.LAST
    LOOP

        OPEN C_wod_rec(I_HEAD_REC.DETAILS(i).ITEM, I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID);
        FETCH C_wod_rec INTO L_D_REC;
        IF C_wod_rec%NOTFOUND THEN
        	INSERT INTO WP_ORDER_DETAIL(SALES_ORDER_NO,
      	                              ITEM,
      	                              SOURCE_LOC_TYPE,
      	                              SOURCE_LOC_ID,
      	                              CUSTOMER_LOC,
      	                              ORIGINAL_QTY,
      	                              CURRENT_QTY,
      	                              ORIGINAL_PARTNER_PRICE,
      	                              CURRENT_PARTNER_PRICE,
      	                              ORIGINAL_WINDOW_START_DATE,
      	                              CURRENT_WINDOW_START_DATE,
      	                              ORIGINAL_WINDOW_END_DATE,
      	                              CURRENT_WINDOW_END_DATE,
      	                              CANCEL_REASON,
      	                              CANCEL_DATE,
                                      RRP_GBP,
                                      RRP_EUR,
                                      RRP_USD,
                                      RRP_CAD,
                                      CANCELLED_QTY,
                                      PARTNER_DC_ID,
                                      PARTNER_STORE_ID,
      	                              CREATE_ID,
      	                              CREATE_DATETIME,
      	                              LAST_UPDATE_ID,
      	                              LAST_UPDATE_DATETIME)
      	  VALUES(I_HEAD_REC.SALES_ORDER_NO,
      	         I_HEAD_REC.DETAILS(i).ITEM,
      	         'WH',
      	         I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID,
      	         I_HEAD_REC.DETAILS(i).CUSTOMER_LOC,
      	         I_HEAD_REC.DETAILS(i).CURRENT_QTY,       --ORIGINAL_QTY
      	         I_HEAD_REC.DETAILS(i).CURRENT_QTY,       --CURRENT_QTY
      	         I_HEAD_REC.DETAILS(i).CURRENT_PARTNER_PRICE,     --ORIGINAL_PARTNER_PRICE
      	         I_HEAD_REC.DETAILS(i).CURRENT_PARTNER_PRICE,
      	         I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_START_DATE,     --ORIGINAL_WINDOW_START_DATE
      	         I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_START_DATE,
      	         I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_END_DATE,     --ORIGINAL_WINDOW_END_DATE
      	         I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_END_DATE,
      	         I_HEAD_REC.CANCEL_REASON,
      	         I_HEAD_REC.CANCEL_DATE,
      	         I_HEAD_REC.DETAILS(i).RRP_GBP,
      	         I_HEAD_REC.DETAILS(i).RRP_EUR,
      	         I_HEAD_REC.DETAILS(i).RRP_USD,
      	         I_HEAD_REC.DETAILS(i).RRP_CAD,
                 --I_HEAD_REC.DETAILS(i).CANCELLED_QTY,
                 NULL, --cancelled qty
                 I_HEAD_REC.DETAILS(i).PARTNER_DC_ID,
                 I_HEAD_REC.DETAILS(i).PARTNER_STORE_ID,
      	         USER,
      	         SYSDATE,
      	         USER,
      	         SYSDATE);

      	         IF C_wod_rec%ISOPEN THEN
      	         CLOSE C_wod_rec;
      	         END IF;
      	         CONTINUE;

        END IF;
        CLOSE C_wod_rec;

        L_D_NEED_UPDATE := FALSE;

        IF I_HEAD_REC.DETAILS(i).SOURCE_LOC_TYPE <> L_D_REC.SOURCE_LOC_TYPE
        THEN
            O_error_message := 'Source Loc Type cannot be modified on the existing Sales Order.';
            RETURN FALSE;
        END IF;

        IF I_HEAD_REC.DETAILS(i).CUSTOMER_LOC <> L_D_REC.CUSTOMER_LOC
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).CURRENT_QTY <> L_D_REC.CURRENT_QTY
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).CURRENT_PARTNER_PRICE <> L_D_REC.CURRENT_PARTNER_PRICE
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_START_DATE <> L_D_REC.CURRENT_WINDOW_START_DATE
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_END_DATE <> L_D_REC.CURRENT_WINDOW_END_DATE
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF NVL(I_HEAD_REC.DETAILS(i).CANCEL_REASON,'') <> NVL(L_D_REC.CANCEL_REASON,'')
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF NVL(I_HEAD_REC.DETAILS(i).CANCEL_DATE,to_date('1999-01-01','YYYY-MM-DD')) <> NVL(L_D_REC.CANCEL_DATE,to_date('1999-01-01','YYYY-MM-DD'))
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).RRP_GBP <> L_D_REC.RRP_GBP
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).RRP_EUR <> L_D_REC.RRP_EUR
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).RRP_USD <> L_D_REC.RRP_USD
        THEN
            L_D_NEED_UPDATE := TRUE;
        ELSIF I_HEAD_REC.DETAILS(i).RRP_CAD <> L_D_REC.RRP_CAD
        THEN
            L_D_NEED_UPDATE := TRUE;
        END IF;

        IF L_D_NEED_UPDATE
        THEN

            IF I_HEAD_REC.DETAILS(i).CANCEL_REASON IS NOT NULL 
            THEN
                I_HEAD_REC.DETAILS(i).CANCELLED_QTY := L_D_REC.CURRENT_QTY;
            END IF;

            UPDATE WP_ORDER_DETAIL WOD
            SET --WOD.CUSTOMER_LOC = I_HEAD_REC.DETAILS(i).CUSTOMER_LOC,
                WOD.CURRENT_QTY = I_HEAD_REC.DETAILS(i).CURRENT_QTY,
                WOD.CURRENT_PARTNER_PRICE = I_HEAD_REC.DETAILS(i).CURRENT_PARTNER_PRICE,
                WOD.CURRENT_WINDOW_START_DATE = I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_START_DATE,
                WOD.CURRENT_WINDOW_END_DATE = I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_END_DATE,
                WOD.CANCEL_REASON = I_HEAD_REC.DETAILS(i).CANCEL_REASON,
                WOD.CANCEL_DATE = I_HEAD_REC.DETAILS(i).CANCEL_DATE,
                WOD.RRP_GBP = I_HEAD_REC.DETAILS(i).RRP_GBP,
                WOD.RRP_EUR = I_HEAD_REC.DETAILS(i).RRP_EUR,
                WOD.RRP_USD = I_HEAD_REC.DETAILS(i).RRP_USD,
                WOD.RRP_CAD = I_HEAD_REC.DETAILS(i).RRP_CAD,
                WOD.CANCELLED_QTY = I_HEAD_REC.DETAILS(i).CANCELLED_QTY
            WHERE WOD.SALES_ORDER_NO = I_HEAD_REC.SALES_ORDER_NO
            AND   WOD.ITEM = I_HEAD_REC.DETAILS(i).ITEM
            AND   WOD.SOURCE_LOC_ID = I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID;
        END IF;

    END LOOP;

    IF L_H_NEED_UPDATE
    THEN
        UPDATE WP_ORDER_HEAD WOH
        SET WOH.EXTERNAL_ORDER_NO = I_HEAD_REC.EXTERNAL_ORDER_NO,
            WOH.CURRENCY_CODE = I_HEAD_REC.CURRENCY_CODE,
            WOH.EXCHANGE_RATE = I_HEAD_REC.EXCHANGE_RATE,
            WOH.CANCEL_REASON = I_HEAD_REC.CANCEL_REASON,
            WOH.COMMENTS = I_HEAD_REC.COMMENTS,
            --WOH.PARTNER_DC_ID = I_HEAD_REC.PARTNER_DC_ID,
            --WOH.PARTNER_STORE_ID = I_HEAD_REC.PARTNER_STORE_ID,
            WOH.PARTNER_ORDER_NO = I_HEAD_REC.PARTNER_ORDER_NO,
            WOH.CANCEL_DATE = I_HEAD_REC.CANCEL_DATE
        WHERE WOH.SALES_ORDER_NO = I_HEAD_REC.SALES_ORDER_NO;
    END IF;

   return true;

EXCEPTION
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;
END PERSIST_UPDATE;
--------------------------------------------------------------------------------
FUNCTION PERSIST_CREATE(O_error_message IN OUT VARCHAR2,
                        I_HEAD_REC IN OUT NOCOPY WP_ORDER_HEAD_REC)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.PERSIST_CREATE';

BEGIN

    INSERT INTO WP_ORDER_HEAD(SALES_ORDER_NO,
                                EXTERNAL_ORDER_NO,
                                CUSTOMER_ID,
                                SALES_ORDER_TYPE,
                                ORDER_NO,
                                ORDER_ROW_CODE,
                                STATUS,
                                ORDER_TYPE,
                                CURRENCY_CODE,
                                EXCHANGE_RATE,
                                COMMENTS,
                                HOLD_IND,
                                REDIST_IND,
                                --PARTNER_DC_ID,
                                --PARTNER_STORE_ID,
                                PARTNER_ORDER_NO,
                                CONTEXT_TYPE,
                                CONTEXT_VALUE,
                                RELEASE_IND,
                                RELEASE_DATE,
                                CANCEL_REASON,
                                CANCEL_DATE,
                                FREIGHT,
                                CREATE_ID,
                                CREATE_DATETIME,
                                LAST_UPDATE_ID,
                                LAST_UPDATE_DATETIME)
    VALUES(I_HEAD_REC.SALES_ORDER_NO,
           I_HEAD_REC.EXTERNAL_ORDER_NO,
           I_HEAD_REC.CUSTOMER_ID,
           I_HEAD_REC.SALES_ORDER_TYPE,
           I_HEAD_REC.ORDER_NO,
           I_HEAD_REC.ORDER_ROW_CODE,
           WP_ORDER_APPROVAL_SQL.WORKSHEET,
           I_HEAD_REC.ORDER_TYPE,
           I_HEAD_REC.CURRENCY_CODE,
           I_HEAD_REC.EXCHANGE_RATE,
           I_HEAD_REC.COMMENTS,
           --I_HEAD_REC.HOLD_IND,
           'N',
           --I_HEAD_REC.REDIST_IND,
           'N',
           --I_HEAD_REC.PARTNER_DC_ID,
           --NULL,--I_HEAD_REC.PARTNER_STORE_ID,
           I_HEAD_REC.PARTNER_ORDER_NO,
           I_HEAD_REC.CONTEXT_TYPE,
           I_HEAD_REC.CONTEXT_VALUE,
           --I_HEAD_REC.RELEASE_IND,
           'N',
           I_HEAD_REC.RELEASE_DATE,
           I_HEAD_REC.CANCEL_REASON,
           I_HEAD_REC.CANCEL_DATE,
           I_HEAD_REC.FREIGHT,
           USER,
           SYSDATE,
           USER,
           SYSDATE);

    FOR i IN I_HEAD_REC.DETAILS.FIRST .. I_HEAD_REC.DETAILS.LAST
    LOOP
        INSERT INTO WP_ORDER_DETAIL(SALES_ORDER_NO,
                                    ITEM,
                                    SOURCE_LOC_TYPE,
                                    SOURCE_LOC_ID,
                                    CUSTOMER_LOC,
                                    ORIGINAL_QTY,
                                    CURRENT_QTY,
                                    ORIGINAL_PARTNER_PRICE,
                                    CURRENT_PARTNER_PRICE,
                                    ORIGINAL_WINDOW_START_DATE,
                                    CURRENT_WINDOW_START_DATE,
                                    ORIGINAL_WINDOW_END_DATE,
                                    CURRENT_WINDOW_END_DATE,
                                    CANCEL_REASON,
                                    CANCEL_DATE,
                                    RRP_GBP,
                                    RRP_EUR,
                                    RRP_USD,
                                    RRP_CAD,
                                    CANCELLED_QTY,
                                    PARTNER_DC_ID,
                                    PARTNER_STORE_ID,
                                    CREATE_ID,
                                    CREATE_DATETIME,
                                    LAST_UPDATE_ID,
                                    LAST_UPDATE_DATETIME)
        VALUES(I_HEAD_REC.SALES_ORDER_NO,
               I_HEAD_REC.DETAILS(i).ITEM,
               'WH',
               I_HEAD_REC.DETAILS(i).SOURCE_LOC_ID,
               I_HEAD_REC.DETAILS(i).CUSTOMER_LOC,
               I_HEAD_REC.DETAILS(i).CURRENT_QTY,       --ORIGINAL_QTY
               I_HEAD_REC.DETAILS(i).CURRENT_QTY,       --CURRENT_QTY
               I_HEAD_REC.DETAILS(i).CURRENT_PARTNER_PRICE,     --ORIGINAL_PARTNER_PRICE
               I_HEAD_REC.DETAILS(i).CURRENT_PARTNER_PRICE,
               I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_START_DATE,     --ORIGINAL_WINDOW_START_DATE
               I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_START_DATE,
               I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_END_DATE,     --ORIGINAL_WINDOW_END_DATE
               I_HEAD_REC.DETAILS(i).CURRENT_WINDOW_END_DATE,
               I_HEAD_REC.CANCEL_REASON,
               I_HEAD_REC.CANCEL_DATE,
               I_HEAD_REC.DETAILS(i).RRP_GBP,
               I_HEAD_REC.DETAILS(i).RRP_EUR,
               I_HEAD_REC.DETAILS(i).RRP_USD,
               I_HEAD_REC.DETAILS(i).RRP_CAD,
               NULL,
               I_HEAD_REC.DETAILS(i).PARTNER_DC_ID,
               I_HEAD_REC.DETAILS(i).PARTNER_STORE_ID,
               USER,
               SYSDATE,
               USER,
               SYSDATE);
    END LOOP;

 return true;

EXCEPTION
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;
END PERSIST_CREATE;
--------------------------------------------------------------------------------
FUNCTION PERSIST_DATA(O_error_message IN OUT VARCHAR2,
                      I_HEAD_REC IN OUT NOCOPY WP_ORDER_HEAD_REC)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.PERSIST_DATA';

BEGIN

    IF I_HEAD_REC.ACTION_TYPE = GV_create THEN
        I_HEAD_REC.SALES_ORDER_NO := WP_SALES_ORDER_NO_SEQ.NEXTVAL();
        IF PERSIST_CREATE(O_error_message,I_HEAD_REC) = FALSE THEN
            return false;
        END IF;

        IF WP_ORDER_APPROVAL_SQL.APPROVE_ORDER(O_error_message,I_HEAD_REC.SALES_ORDER_NO) = FALSE
        THEN
            RETURN FALSE;
        END IF;

    ELSIF I_HEAD_REC.ACTION_TYPE = GV_update THEN
        IF PERSIST_UPDATE(O_error_message,I_HEAD_REC) = FALSE THEN
            return false;
        END IF;

        IF I_HEAD_REC.CANCEL_REASON IS NOT NULL THEN
            IF WP_ORDER_APPROVAL_SQL.CANCEL_ORDER(O_error_message,I_HEAD_REC.SALES_ORDER_NO) = FALSE
            THEN
                RETURN FALSE;
            END IF;
        END IF;

    ELSE
        O_error_message := 'Unknown action type';
        return false;
    END IF;

 return true;

EXCEPTION
  when OTHERS then
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
    RETURN FALSE;
END PERSIST_DATA;
--------------------------------------------------------------------------------
FUNCTION PRE_VALIDATIONS(O_error_message      IN OUT VARCHAR2)

RETURN BOOLEAN
IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.VALIDATIONS';

BEGIN

    /*
    * mandatory fields validations BEGIN
    */
    --option id
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Option ID is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND OPTION_ID IS NULL;

    --order row code
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Order Row Code is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND ORDER_ROW_CODE IS NULL
    AND SALES_ORDER_TYPE = 'PO';

    --sales order type
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Sales Order Type is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND SALES_ORDER_TYPE IS NULL;

    --sales order id
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Sales Order ID is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND SALES_ORDER_ID IS NULL;

    --UNITS_BY_SIZE
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Units by Size is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND UNITS_BY_SIZE IS NULL;

    --partner id
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Partner ID (store) is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND PARTNER_ID IS NULL;

    --delivery window not provided correctly
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Delivery window not provided correctly.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND ((DELIVERY_NOT_BEFORE_DATE IS NULL) OR (DELIVERY_NOT_BEFORE_DATE IS NULL));

    --delivery window end date earlier then start date
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Delivery Not After date is earlier than Not Before date.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND DELIVERY_NOT_AFTER_DATE < DELIVERY_NOT_BEFORE_DATE;

    --RRP GBP
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'RRP GBP not provided / not a valid value.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NVL(RRP_GBP,-1) <= 0;

    --RRP EUR
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'RRP EUR not provided / not a valid value.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NVL(RRP_EUR,-1) <= 0;

    --RRP USD
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'RRP USD not provided / not a valid value.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NVL(RRP_USD,-1) <= 0;

    --RRP CAD
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'RRP CAD not provided / not a valid value.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NVL(RRP_CAD,-1) <= 0;

    /*
    --STORE id
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Store ID is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND STORE_ID IS NULL;
    */

    --FC id
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Delivery FC ID is not provided.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND DELIVERY_FC IS NULL;

    --cancel reasons + dates
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Cancel reason code / date is not provided',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND ((PARTNER_CANCEL_ID IS NULL AND PARTNER_CANCEL_DATE IS NOT NULL)
        OR (PARTNER_CANCEL_ID IS NOT NULL AND PARTNER_CANCEL_DATE IS NULL)
        OR (ORDER_ROW_CANCEL_ID IS NULL AND ORDER_ROW_CANCEL_DATE IS NOT NULL)
        OR (ORDER_ROW_CANCEL_ID IS NOT NULL AND ORDER_ROW_CANCEL_DATE IS NULL));

    --cancel reasons + total qty
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Cancel reason code provided, but total quantity is not cleared to 0.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND ((PARTNER_CANCEL_ID IS NOT NULL AND PARTNER_TOTAL_UNITS > 0) OR (ORDER_ROW_CANCEL_ID IS NOT NULL AND PARTNER_TOTAL_UNITS > 0));

    /*
    * mandatory fields validations END
    */

    --PARTNER MATCH (store match)
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Could not find partner (store) in RMS.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND PARTNER_ID NOT IN (SELECT STORE FROM STORE);

    --PARTNER MATCH
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Could not find customer for partner (store) in RMS.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND PARTNER_ID NOT IN (SELECT STORE FROM STORE WHERE WF_CUSTOMER_ID IS NOT NULL);

    --store valid?
    /*
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Store is not found in RMS.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND STORE_ID NOT IN (SELECT STORE FROM STORE);
    */

    --units valid?
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Units is not a valid value.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NVL(PARTNER_TOTAL_UNITS,-1) < 0;

    --sell price valid?
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Sell Price is not provided / not a valid value.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NVL(SELL_PRICE,-1) <= 0;

    --option id valid?
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Option ID is invalid.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND OPTION_ID NOT IN (SELECT ITEM FROM ITEM_MASTER WHERE ITEM = OPTION_ID AND ITEM_LEVEL < TRAN_LEVEL AND STATUS = 'A');

    --delivery fc id exists in RMS as virtual wh linked with ?Wholesale? channel.
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Delivery FC ID is not found in RMS / not a wholesale FC',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND DELIVERY_FC NOT IN (SELECT WH FROM WH WHERE CHANNEL_ID = (SELECT CHANNEL_ID FROM CHANNELS WHERE UPPER(CHANNEL_NAME) = 'WHOLESALE'));

    /*
    --partner - dc - store is valid combination
    UPDATE WP_SO_IMPORT_STG SS
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Invalid Partner - DC - Store combination.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND NOT EXISTS (SELECT 'X'
                    FROM WP_CUSTOMER_DC_ST_LINK L
                    WHERE L.CUSTOMER_ID = SS.PARTNER_ID
                    --AND L.PARTNER_DC_ID = SS.DELIVERY_FC
                    AND L.PARTNER_STORE_ID = SS.STORE_ID);
    */

    --reason code invalid
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_error,
        INT_ERROR_MSG = 'Invalid cancel reason code.',
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new
    AND ((PARTNER_CANCEL_DATE IS NOT NULL AND PARTNER_CANCEL_ID NOT IN (SELECT CODE FROM CODE_DETAIL WHERE CODE_TYPE = 'WFCO'))
        OR (ORDER_ROW_CANCEL_DATE IS NOT NULL AND ORDER_ROW_CANCEL_ID NOT IN (SELECT CODE FROM CODE_DETAIL WHERE CODE_TYPE = 'WFCO')));

    --update to validated where there was no error
    UPDATE WP_SO_IMPORT_STG
    SET INT_STATUS = GV_validated,
        LAST_UPDATE_ID = USER,
        LAST_UPDATE_DATETIME = sysdate
    WHERE INT_STATUS = GV_new;

    RETURN TRUE;

END PRE_VALIDATIONS;
--------------------------------------------------------------------------------
FUNCTION PROCESS_STG(O_error_message  IN OUT NOCOPY VARCHAR2)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.PROCESS_STG';

CURSOR c_stage_records_for_ohead IS
    SELECT
        WP_ORDER_HEAD_REC(
        NULL,        --SALES_ORDER_NO
        SS.SALES_ORDER_ID,      --EXTERNAL_ORDER_NO
        --SS.PARTNER_ID,
        SS.PARTNER_ID,		--PARTNER_LOC_ID
        NULL,       --CUSTOMER_ID
        SS.SALES_ORDER_TYPE,
        NULL,       --ORDER_NO
        SS.ORDER_ROW_CODE,
        NULL,        --STATUS
        NULL,       --ORDER_TYPE
        NULL,       --PO_TYPE
        SS.PARTNER_CURRENCY,     --CURRENCY_CODE
        NULL,       --EXCHANGE_RATE
        NULL,       --COMMENTS
        NULL,       --HOLD_IND
        NULL,       --REDIST_IND
        --SS.DC_ID,       --PARTNER_DC_ID
        --NULL,       --PARTNER_DC_ID
        --SS.STORE_ID,        --PARTNER_STORE_ID
        --SS.PARTNER_ID,        --PARTNER_STORE_ID
        SS.PARTNER_ORDER_NO,
        NULL,       --CONTEXT_TYPE
        NULL,       --CONTEXT_VALUE
        NULL,       --RELEASE_IND
        NULL,       --RELEASE_DATE,
        NULL,       --CANCEL_REASON
        NULL,       --CANCEL_DATE
        SS.PARTNER_CANCEL_ID,        --PARTNER_CANCEL_REASON
        SS.PARTNER_CANCEL_DATE,        --PARTNER_CANCEL_DATE
        SS.ORDER_ROW_CANCEL_ID,        --ORDER_ROW_CANCEL_REASON
        SS.ORDER_ROW_CANCEL_DATE,        --ORDER_ROW_CANCEL_DATE
        SS.PARTNER_TOTAL_UNITS,
        SS.UNITS_BY_SIZE,
        SS.OPTION_ID,
        NULL,       --FREIGHT
        NULL,       --WP_ORDER_DETAIL_TBL
        ROWIDTOCHAR(rowid),
        SS.INT_STATUS,           --INT_STATUS
        NULL,        --ERROR_MSG
        NULL        --ACTION_TYPE
        )
    FROM WP_SO_IMPORT_STG ss
    WHERE SS.INT_STATUS = GV_validated
    ORDER BY BATCH_SEQ_NO,
             SEQ_NO;

L_WP_ORDER_HEAD_TBL WP_ORDER_HEAD_TBL := WP_ORDER_HEAD_TBL();

L_error_text VARCHAR2(255);
L_rowid rowid;

BEGIN

 if G_chunk_size is null
   then
        if GET_CONFIG(O_error_message) = false then
            return false;
        end if;
 end if;

 IF PRE_VALIDATIONS(O_error_message) = FALSE
 THEN
    RETURN FALSE;
 END IF;

 OPEN c_stage_records_for_ohead;
    LOOP
        FETCH c_stage_records_for_ohead BULK COLLECT INTO L_WP_ORDER_HEAD_TBL LIMIT G_chunk_size;
        EXIT WHEN L_WP_ORDER_HEAD_TBL.COUNT = 0;

        FOR I IN L_WP_ORDER_HEAD_TBL.FIRST .. L_WP_ORDER_HEAD_TBL.LAST
        LOOP
            SAVEPOINT BEFORE_HEAD;
            IF POPULATE_HEAD_OBJECT(O_error_message,
                                    L_WP_ORDER_HEAD_TBL(I)) = FALSE
            THEN
                L_WP_ORDER_HEAD_TBL(I).INT_STATUS := GV_error;
                L_WP_ORDER_HEAD_TBL(I).ERROR_MSG := O_error_message;
                O_error_message := null;
                CONTINUE;
            END IF;

            IF PERSIST_DATA(O_error_message,
                            L_WP_ORDER_HEAD_TBL(I)) = FALSE
            THEN
                L_WP_ORDER_HEAD_TBL(I).INT_STATUS := GV_error;
                L_WP_ORDER_HEAD_TBL(I).ERROR_MSG := O_error_message;
                O_error_message := null;
                ROLLBACK TO BEFORE_HEAD;
                CONTINUE;
            END IF;

        END LOOP;

        FORALL I IN L_WP_ORDER_HEAD_TBL.FIRST .. L_WP_ORDER_HEAD_TBL.LAST
            UPDATE WP_SO_IMPORT_STG
            SET INT_STATUS = DECODE(L_WP_ORDER_HEAD_TBL(I).int_status,GV_error,GV_error,GV_processed),
                INT_ERROR_MSG = L_WP_ORDER_HEAD_TBL(I).ERROR_MSG,
                LAST_UPDATE_ID = USER,
                LAST_UPDATE_DATETIME = sysdate
            WHERE rowid = L_WP_ORDER_HEAD_TBL(I).LOAD_STG_ROWID;


    END LOOP;
    CLOSE c_stage_records_for_ohead;

    --ARCHIVE
    insert into WP_SO_IMPORT_ARCH (SEQ_NO,
                                   BATCH_SEQ_NO,
                                   ORDER_ROW_ID,
                                   ORDER_ROW_TIMESTAMP,
                                   ORDER_ROW_CODE,
                                   RRP_GBP,
                                   RRP_EUR,
                                   RRP_USD,
                                   RRP_CAD,
                                   DESPATCH_MONTH,
                                   OPTION_ID,
                                   DC_ID,
                                   SALES_ORDER_TYPE,
                                   MANUAL_STATUS_ID,
                                   ORDER_ROW_CANCEL_ID,
                                   ORDER_ROW_CANCEL_DATE,
                                   PARTNER_CANCEL_ID,
                                   PARTNER_CANCEL_DATE,
                                   PARTNER_ORDER_NO,
                                   SALES_ORDER_ID,
                                   PARTNER_ID,
                                   DELIVERY_FC,
                                   STORE_ID,
                                   DELIVERY_NOT_BEFORE_DATE,
                                   DELIVERY_NOT_AFTER_DATE,
                                   PARTNER_CURRENCY,
                                   SELL_PRICE,
                                   PARTNER_TOTAL_UNITS,
                                   UNITS_BY_SIZE,
                                   INT_STATUS,
                                   INT_ERROR_MSG,
                                   FILENAME,
                                   CREATE_ID,
                                   CREATE_DATETIME,
                                   LAST_UPDATE_ID,
                                   LAST_UPDATE_DATETIME,
                                   EXTRACTED_IND)
     SELECT SEQ_NO,
            BATCH_SEQ_NO,
            ORDER_ROW_ID,
            ORDER_ROW_TIMESTAMP,
            ORDER_ROW_CODE,
            RRP_GBP,
            RRP_EUR,
            RRP_USD,
            RRP_CAD,
            DESPATCH_MONTH,
            OPTION_ID,
            DC_ID,
            SALES_ORDER_TYPE,
            MANUAL_STATUS_ID,
            ORDER_ROW_CANCEL_ID,
            ORDER_ROW_CANCEL_DATE,
            PARTNER_CANCEL_ID,
            PARTNER_CANCEL_DATE,
            PARTNER_ORDER_NO,
            SALES_ORDER_ID,
            PARTNER_ID,
            DELIVERY_FC,
            STORE_ID,
            DELIVERY_NOT_BEFORE_DATE,
            DELIVERY_NOT_AFTER_DATE,
            PARTNER_CURRENCY,
            SELL_PRICE,
            PARTNER_TOTAL_UNITS,
            UNITS_BY_SIZE,
            INT_STATUS,
            INT_ERROR_MSG,
            FILENAME,
            CREATE_ID,
            CREATE_DATETIME,
            LAST_UPDATE_ID,
            LAST_UPDATE_DATETIME,
            'N'
     FROM WP_SO_IMPORT_STG WHERE INT_STATUS in (GV_Error, GV_Processed);

     delete from WP_SO_IMPORT_STG WHERE INT_STATUS in (GV_Error, GV_Processed);

    RETURN TRUE;

END PROCESS_STG;
--------------------------------------------------------------------------------
/*
--------------------------------------------------------------------------------
FUNCTION PROCESS_STG(O_error_message  IN OUT NOCOPY VARCHAR2)
RETURN BOOLEAN IS

L_program VARCHAR2(400) := 'WP_SO_IMPORT_SQL.PROCESS_STG';

CURSOR c_orderrows IS
    SELECT DISTINCT SS.ORDER_ROW_CODE
    FROM WP_SO_IMPORT_STG ss
    WHERE SS.INT_STATUS = GV_validated
    ORDER BY BATCH_SEQ_NO,
             SEQ_NO;

CURSOR c_stage_records_for_ohead(i_order_row_code VARCHAR2) IS
    SELECT
        WP_ORDER_HEAD_REC(
        NULL,        --SALES_ORDER_NO
        SS.SALES_ORDER_ID,      --EXTERNAL_ORDER_NO
        SS.PARTNER_ID,
        NULL,       --CUSTOMER_ID
        SS.SALES_ORDER_TYPE,
        NULL,       --ORDER_NO
        SS.ORDER_ROW_CODE,
        NULL,        --STATUS
        NULL,       --ORDER_TYPE
        NULL,       --PO_TYPE
        SS.PARTNER_CURRENCY,     --CURRENCY_CODE
        NULL,       --EXCHANGE_RATE
        NULL,       --COMMENTS
        NULL,       --HOLD_IND
        NULL,       --REDIST_IND
        SS.DC_ID,       --PARTNER_DC_ID
        SS.STORE_ID,        --PARTNER_STORE_ID
        SS.PARTNER_ORDER_NO,
        NULL,       --CONTEXT_TYPE
        NULL,       --CONTEXT_VALUE
        NULL,       --RELEASE_IND
        NULL,       --RELEASE_DATE,
        NULL,       --CANCEL_REASON
        NULL,       --CANCEL_DATE
        SS.PARTNER_CANCEL_ID,        --PARTNER_CANCEL_REASON
        SS.PARTNER_CANCEL_DATE,        --PARTNER_CANCEL_DATE
        SS.ORDER_ROW_CANCEL_ID,        --ORDER_ROW_CANCEL_REASON
        SS.ORDER_ROW_CANCEL_DATE,        --ORDER_ROW_CANCEL_DATE
        SS.PARTNER_TOTAL_UNITS,
        SS.UNITS_BY_SIZE,
        SS.OPTION_ID,
        NULL,       --FREIGHT
        NULL,       --WP_ORDER_DETAIL_TBL
        ROWIDTOCHAR(rowid),
        SS.INT_STATUS,           --INT_STATUS
        NULL,        --ERROR_MSG
        NULL        --ACTION_TYPE
        )
    FROM WP_SO_IMPORT_STG ss
    WHERE SS.INT_STATUS = GV_validated
    ORDER BY BATCH_SEQ_NO,
             SEQ_NO;

L_WP_ORDER_HEAD_TBL WP_ORDER_HEAD_TBL := WP_ORDER_HEAD_TBL();

L_error_text VARCHAR2(255);
L_rowid rowid;
l_rec_cnt number(10);
l_month number(10);

BEGIN

 if G_chunk_size is null
   then
        if GET_CONFIG(O_error_message) = false then
            return false;
        end if;
 end if;

 IF PRE_VALIDATIONS(O_error_message) = FALSE
 THEN
    RETURN FALSE;
 END IF;

 l_rec_cnt := 0;

 FOR C_ORC IN c_orderrows
 LOOP

 OPEN c_stage_records_for_ohead(C_ORC.ORDER_ROW_CODE);
 	LOOP
 		FETCH c_stage_records_for_ohead BULK COLLECT INTO L_WP_ORDER_HEAD_TBL;
 		EXIT WHEN L_WP_ORDER_HEAD_TBL.COUNT = 0;

 		l_rec_cnt := l_rec_cnt + L_WP_ORDER_HEAD_TBL.COUNT;

 		SAVEPOINT BEFORE_SALES_ORDER

 		FOR I IN L_WP_ORDER_HEAD_TBL.FIRST .. L_WP_ORDER_HEAD_TBL.LAST
        LOOP
            SAVEPOINT BEFORE_HEAD;
            IF POPULATE_HEAD_OBJECT(O_error_message,
                                    L_WP_ORDER_HEAD_TBL(I)) = FALSE
            THEN
                L_WP_ORDER_HEAD_TBL(I).INT_STATUS := GV_error;
                L_WP_ORDER_HEAD_TBL(I).ERROR_MSG := O_error_message;
                O_error_message := null;
                CONTINUE;
            END IF;

            IF PERSIST_DATA(O_error_message,
                            L_WP_ORDER_HEAD_TBL(I)) = FALSE
            THEN
                L_WP_ORDER_HEAD_TBL(I).INT_STATUS := GV_error;
                L_WP_ORDER_HEAD_TBL(I).ERROR_MSG := O_error_message;
                O_error_message := null;
                ROLLBACK TO BEFORE_HEAD;
                CONTINUE;
            END IF;

        END LOOP;

        --check despatch month
        BEGIN

        	SELECT DISTINCT MONTH(WOD.CURRENT_WINDOW_START_DATE)
        	INTO l_month
        	FROM WP_ORDER_DETAIL WOD,
        	     WP_ORDER_HEAD WOH
        	WHERE WOH.ORDER_ROW_CODE = C_ORC.ORDER_ROW_CODE
        	AND WOH.SALES_ORDER_NO = WOD.SALES_ORDER_NO;

        	EXCEPTION
        	WHEN TOO_MANY_ROWS then

            	ROLLBACK TO BEFORE_SALES_ORDER;
            	O_error_message:='Despatch month would be different on the Sales Orders for this Order Row Code.' ||' - '||L_program;
            	--update to Error
            	FOR I IN L_WP_ORDER_HEAD_TBL.FIRST .. L_WP_ORDER_HEAD_TBL.LAST
        		LOOP
        			L_WP_ORDER_HEAD_TBL(I).INT_STATUS := GV_error;
                	L_WP_ORDER_HEAD_TBL(I).ERROR_MSG := O_error_message;
                	--O_error_message := null;
        		END LOOP;
            --return false;

        END;

        FORALL I IN L_WP_ORDER_HEAD_TBL.FIRST .. L_WP_ORDER_HEAD_TBL.LAST
            UPDATE WP_SO_IMPORT_STG
            SET INT_STATUS = DECODE(L_WP_ORDER_HEAD_TBL(I).int_status,GV_error,GV_error,GV_processed),
                INT_ERROR_MSG = L_WP_ORDER_HEAD_TBL(I).ERROR_MSG,
                LAST_UPDATE_ID = USER,
                LAST_UPDATE_DATETIME = sysdate
            WHERE rowid = L_WP_ORDER_HEAD_TBL(I).LOAD_STG_ROWID;

            insert into WP_SO_IMPORT_ARCH
            select stg.* from WP_SO_IMPORT_STG stg, TABLE(L_WP_ORDER_HEAD_TBL)  recs
            where chartorowid(recs.LOAD_STG_ROWID) = stg.rowid;

            delete from WP_SO_IMPORT_STG where rowid in (
            	select chartorowid(recs.LOAD_STG_ROWID) from TABLE(L_WP_ORDER_HEAD_TBL)  recs
            );




 	END LOOP;

 	IF l_rec_cnt >= G_chunk_size THEN
        l_rec_cnt := 0;
    END IF;

 CLOSE c_stage_records_for_ohead;

 END LOOP;

 RETURN TRUE;

END PROCESS_STG;
*/
--------------------------------------------------------------------------------
FUNCTION PURGE_IMPORT_ARCH (O_ERROR_MESSAGE IN OUT VARCHAR2) RETURN BOOLEAN
IS
    l_program VARCHAR2(100) := 'WP_SO_IMPORT_SQL.PURGE_IMPORT_ARCH';
    l_purge_days WP_SYSTEM_PARAMETERS.VALUE_1%TYPE := null;

  BEGIN
    BEGIN
		SELECT VALUE_1
        INTO l_purge_days
        FROM WP_SYSTEM_PARAMETERS
        WHERE FUNC_AREA = 'WP_SO_IMPORT_SQL'
        AND   PARAMETER = 'PURGE_DAYS';

        EXCEPTION WHEN NO_DATA_FOUND THEN
        O_ERROR_MESSAGE := 'Purge days is not configured in WP_SYSTEM_PARAMETERS table.';
       RETURN FALSE;
    END;

    DELETE FROM WP_SO_IMPORT_ARCH WHERE SEQ_NO IN
	(SELECT SEQ_NO
	FROM WP_SO_IMPORT_ARCH
	WHERE INT_STATUS = 'P'
	UNION ALL
	SELECT ER.SEQ_NO
	FROM WP_SO_IMPORT_ARCH ER,
		 (SELECT SEQ_NO, BATCH_SEQ_NO, SALES_ORDER_ID FROM WP_SO_IMPORT_ARCH WHERE INT_STATUS = 'P') PA
	WHERE ER.INT_STATUS = 'E'
	AND ER.SALES_ORDER_ID = PA.SALES_ORDER_ID
	AND ER.SEQ_NO < PA.SEQ_NO
	AND ER.BATCH_SEQ_NO < PA.BATCH_SEQ_NO)
	AND SYSDATE - LAST_UPDATE_DATETIME >= l_purge_days;
    RETURN TRUE;

    EXCEPTION
      WHEN OTHERS THEN
        O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
        RETURN FALSE;

END PURGE_IMPORT_ARCH;
--------------------------------------------------------------------------------
END;
/