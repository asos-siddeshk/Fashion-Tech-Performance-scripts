select count (distinct (SUPPLIER)) from SUPPLIER_MFQUEUE;
select * from SUPPLIER_MFQUEUE;


SET SERVEROUTPUT ON;
SET timing ON;

DECLARE
    O_status_code     varchar2(250);
    c_commit           NUMBER(10):= 0;
    l_supplier         rms.sups.supplier%type;
  
  cursor C_GET_SUP is 
    select s.SUPPLIER from sups s where s.SUPPLIER_PARENT is not null ;

BEGIN

   DBMS_OUTPUT.PUT_LINE(' Publishing Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
  
for k in C_GET_SUP loop
        l_supplier      := k.SUPPLIER;
        
        
  INSERT /*+ append */ INTO SUPPLIER_MFQUEUE
   (SEQ_NO,
    PUB_STATUS,
    MESSAGE_TYPE,
    SUPPLIER,
    ADDR_SEQ_NO,
    ADDR_TYPE,
    RET_ALLOW_IND,
    ORG_UNIT_ID,
    MESSAGE)
      WITH supp AS (SELECT
  supplier
, 'VendorCre' AS message_type  
, to_number(NULL) AS  addr_seq_no
, to_char(NULL) AS  addr_type
, ret_allow_ind
, to_number(NULL) AS org_unit_id
, XMLElement("VendorHdrDesc",
XMLAttributes('http://www.oracle.com/retail/integration/base/bo/VendorHdrDesc/v1' AS "xmlns:ns1", 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi"),
   XMLForest(
sups.supplier AS "ns1:supplier", 
replace(sups.sup_name,chr(26),'') AS "ns1:sup_name",
sups.sup_name_secondary AS "ns1:sup_name_secondary",
sups.contact_name AS "ns1:contact_name",
sups.contact_phone  AS "ns1:contact_phone", 
sups.contact_fax  AS "ns1:contact_fax",
sups.contact_pager  AS "ns1:contact_pager",
sups.sup_status  AS "ns1:sup_status",
sups.qc_ind AS "ns1:qc_ind", 
sups.qc_pct AS "ns1:qc_pct",
sups.qc_freq  AS "ns1:qc_freq", 
sups.vc_ind  AS "ns1:vc_ind",
sups.vc_pct  AS "ns1:vc_pct", 
sups.vc_freq  AS "ns1:vc_freq", 
sups.currency_code  AS "ns1:currency_code",
sups.lang  AS "ns1:lang",
sups.terms  AS "ns1:terms",
sups.freight_terms  AS "ns1:freight_terms",
sups.ret_allow_ind AS "ns1:ret_allow_ind",
sups.ret_auth_req  AS "ns1:ret_auth_req", 
sups.ret_min_dol_amt  AS "ns1:ret_min_dol_amt",
sups.ret_courier AS "ns1:ret_courier", 
sups.handling_pct  AS "ns1:handling_pct",
sups.edi_po_ind AS "ns1:edi_po_ind",
sups.edi_po_chg  AS "ns1:edi_po_chg",
sups.edi_po_confirm AS "ns1:edi_po_confirm", 
sups.edi_asn  AS "ns1:edi_asn", 
sups.edi_sales_rpt_freq AS "ns1:edi_sales_rpt_freq",
sups.edi_supp_available_ind  AS "ns1:edi_supp_available_ind", 
sups.edi_contract_ind  AS "ns1:edi_contract_ind", 
sups.edi_invc_ind AS "ns1:edi_invc_ind", 
sups.cost_chg_pct_var  AS "ns1:cost_chg_pct_var", 
sups.cost_chg_amt_var  AS "ns1:cost_chg_amt_var",
sups.replen_approval_ind  AS "ns1:replen_approval_ind", 
sups.ship_method  AS "ns1:ship_method",
sups.payment_method AS "ns1:payment_method", 
sups.contact_telex  AS "ns1:contact_telex",
sups.contact_email  AS "ns1:contact_email",
sups.settlement_code AS "ns1:settlement_code",
sups.pre_mark_ind AS "ns1:pre_mark_ind", 
sups.auto_appr_invc_ind  AS "ns1:auto_appr_invc_ind",
sups.dbt_memo_code AS "ns1:dbt_memo_code", 
sups.freight_charge_ind  AS "ns1:freight_charge_ind", 
sups.auto_appr_dbt_memo_ind  AS "ns1:auto_appr_dbt_memo_ind", 
sups.inv_mgmt_lvl  AS "ns1:inv_mgmt_lvl",
sups.backorder_ind  AS "ns1:backorder_ind", 
sups.vat_region  AS "ns1:vat_region", 
sups.prepay_invc_ind  AS "ns1:prepay_invc_ind",
sups.service_perf_req_ind  AS "ns1:service_perf_req_ind",
sups.invc_pay_loc  AS "ns1:invc_pay_loc", 
sups.invc_receive_loc AS "ns1:invc_receive_loc",
sups.addinvc_gross_net  AS "ns1:addinvc_gross_net", 
sups.delivery_policy  AS "ns1:delivery_policy",
sups.comment_desc  AS "ns1:comment_desc",
sups.default_item_lead_time AS "ns1:default_item_lead_time", 
sups.duns_number AS "ns1:duns_number",
sups.duns_loc  AS "ns1:duns_loc", 
sups.bracket_costing_ind  AS "ns1:bracket_costing_ind",
sups.vmi_order_status  AS "ns1:vmi_order_status",
sups.dsd_ind AS "ns1:dsd_supplier_ind",
sups.sup_qty_level AS "ns1:sup_qty_level", 
sups.supplier_parent AS "ns1:supplier_parent")).getclobval() AS MESSAGE 
FROM sups 
WHERE supplier_parent IS NOT NULL
and supplier = l_supplier
UNION ALL
SELECT to_number(key_value_1) AS supplier
, 'VendorAddrCre' AS message_type 
, seq_no AS  addr_seq_no
, addr_type AS  addr_type
, to_char(NULL) AS ret_allow_ind
, to_number(NULL) AS org_unit_id
, XMLELEMENT("VendorAddrDesc",
XMLATTRIBUTES('http://www.oracle.com/retail/integration/base/bo/VendorAddrDesc/v1' AS "xmlns:ns2", 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi"),
   XMLFOREST(
addr.module AS "ns2:module", 
addr.key_value_1  AS "ns2:key_value_1",
addr.key_value_2 AS "ns2:key_value_2",
addr.seq_no  AS "ns2:seq_no",
addr.addr_type AS "ns2:addr_type",
addr.primary_addr_ind  AS "ns2:primary_addr_ind",
replace(addr.add_1,chr(26),'')  AS "ns2:add_1",
replace(addr.add_2,chr(26),'') AS "ns2:add_2",
replace(addr.add_3,chr(26),'') AS "ns2:add_3", 
replace(addr.city,chr(26),'') AS "ns2:city",
replace(addr.state,chr(26),'') AS "ns2:state",
replace(addr.country_id,chr(26),'') AS "ns2:country_id", 
replace(addr.post,chr(26),'')  AS "ns2:post",
replace(addr.contact_name, chr(26),'') AS "ns2:contact_name",
addr.contact_phone  AS "ns2:contact_phone",
replace(addr.contact_telex, chr(26),'') AS "ns2:contact_telex",
replace(addr.contact_fax, chr(26),'') AS "ns2:contact_fax",
addr.contact_email AS "ns2:contact_email",
addr.oracle_vendor_site_id AS "ns2:oracle_vendor_site_id")).getclobval() AS message 
FROM addr 
INNER JOIN sups
ON addr.key_value_1 = sups.supplier
AND addr.module = 'SUPP'
AND  sups.supplier_parent IS NOT NULL
UNION ALL
SELECT
  partner AS supplier
, 'VendorOUCre' AS message_type 
, to_number(NULL) AS  addr_seq_no
, to_char(NULL) AS  addr_type
, to_char(NULL) AS ret_allow_ind
, org_unit_id AS org_unit_id
, XMLElement("VendorOUDesc",
XMLAttributes('http://www.oracle.com/retail/integration/base/bo/VendorOUDesc/v1' AS "xmlns:ns3", 'http://www.w3.org/2001/XMLSchema-instance' AS "xmlns:xsi"),
   XMLForest(
org_unit_id AS "ns3:org_unit_id")).getclobval() AS MESSAGE 
FROM partner_org_unit
WHERE partner_type = 'U'
ORDER BY 1)
   SELECT  SUPPLIER_MFSEQUENCE.NextVal SEQ_NO,
    'U' PUB_STATUS,
    SUPP.MESSAGE_TYPE MESSAGE_TYPE,
    SUPP.SUPPLIER SUPPLIER,
    SUPP.ADDR_SEQ_NO ADDR_SEQ_NO,
    SUPP.ADDR_TYPE ADDR_TYPE,
    SUPP.RET_ALLOW_IND RET_ALLOW_IND,
    SUPP.ORG_UNIT_ID ORG_UNIT_ID,
    SUPP.MESSAGE MESSAGE
    FROM SUPP where supplier = l_supplier;
    
        c_commit :=c_commit + 1;
       IF MOD(c_commit, 5) = 0 THEN
   --  DBMS_OUTPUT.PUT_LINE('c_commit ' || c_commit);
          sys.dbms_lock.sleep(0);
   --  DBMS_OUTPUT.PUT_LINE('Commit: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
           commit;
   --   DBMS_OUTPUT.PUT_LINE('Sleep 1 Ended: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
     continue;
     
       END IF;
    commit;   
    end loop;
  DBMS_OUTPUT.PUT_LINE(' Publishing Completed: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception Block'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/ 