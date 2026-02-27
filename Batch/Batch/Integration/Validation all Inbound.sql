-- Booking dates
select SHIPMENT,VARCHAR2_1,DATE_24 from rms.nb_shipment_cfa_ext where shipment in (select shipment from int_bookingdates);

-- Supplier factory 
select count(1) from INT_ASOS.INT_MA_FACTORY_SUPP_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);
select count(1) from INT_ASOS.INT_RMS_FACTORY_EXT_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);
select count(1) from INT_ASOS.INT_RMS_PARTNER_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);


-- Shipping date
select distinct sh.asn,sh.order_no,nbs.date_24 fc_booking_date,nbs.varchar2_1 fc_booking_ref
   from rms.shipment sh, rms.shipsku sk, rms.nb_shipment_cfa_ext nbs, rms.ordhead oh
   where sh.shipment=sk.shipment
		and sk.shipment=nbs.shipment
		and sh.order_no=oh.order_no
		and nbs.group_id='1010100' 
		and sh.shipment in (select shipment from skumar.receipt_adj);
        
-- receipt adjustments
select STATUS_CODE,count(1) from SHIPMENT where shipment in (select shipment from skumar.receipt_adj) group by STATUS_CODE;


-- Product Dimensions
select count(1) from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate);

-- PIM Product Event
SELECT * FROM INT_ASOS.INT_ITEM_PIM_EVENT_STG where trunc(EVENT_DATE) = trunc(sysdate);       

-- Manual tsf
select STATUS,count(1) from int_asos.int_stg_man_tsf_upld where trunc(CREATE_DATETIME) = trunc(sysdate) group  by STATUS;  

-- iwtreceipt
select count(1) from doc_close_queue where doc in (select tsf_no from skumar.iwtreceipt) and doc_type ='T';

--iwt dispatch
select count(distinct(shipment)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath);
select count(distinct(shipment)) from shipsku where distro_no in (select tsf_no from skumar.iwtdispath_jb);

--iwt receipt closure
select count(1) from INT_ASOS.INT_RECEIPT_CLOSE_HEAD where shipment in 
    (select distinct sh.shipment from shipment sh where sh.BOL_NO in (select consignment from skumar.iwtreceiptclosure));

--iwt dispath closure
select count(distinct(tsf_no)) from  tsfdetail where tsf_no in (select tsf_no from skumar.iwtdispath_cls) and TSF_QTY = SHIP_QTY;


--inv adjutsments
select count(1) from inv_adj where trunc(CREATE_DATETIME) = trunc(sysdate); 

-- Fullfillment orders
select count(1) from ordcust_detail where ORDCUST_NO in (select ORDCUST_NO from ordcust where tsf_no > '7099060944');
select count(1) from ordcust where tsf_no > '7059810671'; --240261


 --- RIB 
select * from rib_message where MESSAGE_NUM>'638778' group by FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE;

select FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE, count(1) from rib_message where MESSAGE_NUM>'638778' group by FAMILY, TYPE, TOPIC_NAME, THREAD_VALUE;