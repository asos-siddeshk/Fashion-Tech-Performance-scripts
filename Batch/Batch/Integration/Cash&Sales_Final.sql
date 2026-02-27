create table CASHANDSALES_ALL_CHK_RAM as 
select * from CASHANDSALES_ALL3 where orderid in ('FEB010833493','FEB010833494','FEB014751615','FEB014751616','FEB014751618','FEB010833319','FEB010833495','FEB017826399','FEB017826401','FEB017826403','FEB017826405','FEB017826385','FEB017826387','FEB017826389','FEB017826391','FEB017826393','FEB017826395','FEB017826397');

drop table CASHANDSALES_ALL_CHK_RAM;
create table CASHANDSALES_ALL_CHK_RAM  as
select * from CASHANDSALES_ALL_CHK
union
select * from CASHANDSALES_ALL_CHK2
union
select * from CASHANDSALES_ALL_CHK3;

--660k 

160k * 4

SELECT STOCKREFERENCE, COUNT(1) 
FROM
    skumar.CASHANDSALES_2022_SOAK
--    having count(1) >5
group by STOCKREFERENCE;

SELECT WLOCATION, COUNT(1)/5
 FROM skumar.CASHANDSALES_2022_SOAK
group by WLOCATION;

select * from SKUMAR.CASHANDSALES_ALL_CHK_RAM order by ORDERID;

            "CountyStateProvinceAreaCode": "AU-WA", --FC01 / 
            "CountryCode": "AU",
            ProductId as VariantId 


select * from SKUMAR.CASHANDSALES_ALL_CHK_RAM order by ORDERID;

db.getCollection('exportedRetailCashandSales').find({"OrderID":"JAN010788055"})
db.getCollection('exportedRetailCashandSales').find({"OrderID":"OCT067771412"})
db.getCollection('stockReferenceLookUp').find({"StockReference":"93788044"})
db.getCollection('exportedPrice').find({"SKUItemID":"6653650"})
db.getCollection('paymentRefLookUp').find({"OrderID":"JAN010788055"})
exportedbaseproduct

db.getCollection('exportedbaseproduct').find({"ItemNo":"100640930"})

 --- Smoke tests -- 11-10-2020
create table CASHANDSALES_ALL_CHK_RAM as 
select * from CASHANDSALES_ALL3 where orderid in ('FEB017826399','FEB017826401','FEB017826403','FEB017826405','FEB017826385','FEB017826387','FEB017826389','FEB017826391','FEB017826393','FEB017826395','FEB017826397');

--drop table CASHANDSALES_ALL_CHK;
create table CASHANDSALES_ALL_CHK as 
select * from CASHANDSALES_ALL3;
    
create table CASHANDSALES_ALL_CHK_RET as
select * from CASHANDSALES_ALL_CHK  where ORDERID in ( 
    select * from (select distinct ORDERID from CASHANDSALES_ALL_CHK ) where rownum <= '26000');

select * from all_tables where table_name like '%CASHANDSALES%';
CASHANDSALES_2022
CASHANDSALES_2022_DEC
CASHANDSALES_2022_SOAK
CASHANDSALES_2022_CHK_SCRIPT
CASHANDSALES_2022_NOV
CASHANDSALES_2022_SEP

--drop table CASHANDSALES_ALL_CHK_RET;
select * from CASHANDSALES_2022_SOAK;
select * from CASHANDSALES_2022_DEC;

--First Set-- 

begin
UPDATE skumar.CASHANDSALES_ALL_CHK SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB01','JAN01'),
    ORDERID = replace(ORDERID,'FEB01','JAN01'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB01','JAN01'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB01','JAN01');
UPDATE skumar.CASHANDSALES_ALL_CHK SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB02','JAN02'),
    ORDERID = replace(ORDERID,'FEB02','JAN02'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB02','JAN02'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB02','JAN02');
end;/

begin
Update CASHANDSALES_ALL_CHK set STOCKREFERENCE=replace(STOCKREFERENCE,'800','71');
Update CASHANDSALES_ALL_CHK set STOCKREFERENCE=replace(STOCKREFERENCE,'801','72');
end;
/
SELECT STOCKREFERENCE, COUNT(*) FROM skumar.CASHANDSALES_ALL_CHK GROUP BY STOCKREFERENCE HAVING COUNT(*) > 3;
select * from CASHANDSALES_ALL_CHK where STOCKREFERENCE= '93816987';

update CASHANDSALES_ALL_CHK set STOCKREFERENCE = '715772800' where STOCKREFERENCE= '71577271' and ORDERID = 'JAN015772800';
update CASHANDSALES_ALL_CHK set STOCKREFERENCE = '725772800' where STOCKREFERENCE= '72577271' and ORDERID = 'JAN025772800';
update CASHANDSALES_ALL_CHK set STOCKREFERENCE = '717771072' where STOCKREFERENCE= '71777172' and ORDERID = 'JAN017780072';


--Second Set-- 
--drop table CASHANDSALES_ALL_CHK21;
select * from CASHANDSALES_ALL_CHK2;
create table CASHANDSALES_ALL_CHK2 as
select * from CASHANDSALES_ALL3  where ORDERID in ( 
    select * from (select distinct ORDERID from CASHANDSALES_ALL3 ) where rownum <= '80000');

begin
UPDATE skumar.CASHANDSALES_ALL_CHK2 SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB01','JAN03'),
    ORDERID = replace(ORDERID,'FEB01','JAN03'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB01','JAN03'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB01','JAN03');
UPDATE skumar.CASHANDSALES_ALL_CHK2 SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB02','JAN04'),
    ORDERID = replace(ORDERID,'FEB02','JAN04'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB02','JAN04'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB02','JAN04');
end;
/

begin
Update CASHANDSALES_ALL_CHK2 set STOCKREFERENCE=replace(STOCKREFERENCE,'800','73');
Update CASHANDSALES_ALL_CHK2 set STOCKREFERENCE=replace(STOCKREFERENCE,'801','74');
end;
/

SELECT STOCKREFERENCE, COUNT(*) FROM skumar.CASHANDSALES_ALL_CHK2 GROUP BY STOCKREFERENCE HAVING COUNT(*) > 3;
select * from CASHANDSALES_ALL_CHK2 where STOCKREFERENCE= '74577374';
update CASHANDSALES_ALL_CHK2 set STOCKREFERENCE = '745780074' where STOCKREFERENCE= '74577374' and ORDERID = 'JAN045780074';


drop table CASHANDSALES_ALL_CHK3;
create table CASHANDSALES_ALL_CHK3 as select * from CASHANDSALES_ALL3 ;
select * from CASHANDSALES_ALL_CHK3;

--Thir Set-- 
begin
UPDATE skumar.CASHANDSALES_ALL_CHK3 SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB01','JAN05'),
    ORDERID = replace(ORDERID,'FEB01','JAN05'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB01','JAN05'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB01','JAN05');
UPDATE skumar.CASHANDSALES_ALL_CHK3 SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'FEB02','JAN06'),
    ORDERID = replace(ORDERID,'FEB02','JAN06'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'FEB02','JAN06'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'FEB02','JAN06');
end;
/

begin
Update CASHANDSALES_ALL_CHK3 set STOCKREFERENCE=replace(STOCKREFERENCE,'800','75');
Update CASHANDSALES_ALL_CHK3 set STOCKREFERENCE=replace(STOCKREFERENCE,'801','76');
end;
/
select * from CASHANDSALES_ALL_CHK3;

SELECT STOCKREFERENCE, COUNT(*) FROM skumar.CASHANDSALES_ALL_CHK3 GROUP BY STOCKREFERENCE HAVING COUNT(*) > 3;
select * from CASHANDSALES_ALL_CHK3 where STOCKREFERENCE= '75377576';
update CASHANDSALES_ALL_CHK3 set STOCKREFERENCE = '753775801' where STOCKREFERENCE= '75377576' and ORDERID = 'JAN053775801';


select * from CASHANDSALES_ALL_CHK_RAM where STOCKREFERENCE= '95816987';
update CASHANDSALES_ALL_CHK_RAM set STOCKREFERENCE = '753775801' where STOCKREFERENCE= '75377576' and ORDERID = 'JAN053775801';

db.getCollection('exportedRetailCashandSales').find({"OrderID":"JAN010788038"})
db.getCollection('paymentRefLookUp').find({"OrderID":"JAN010788038"})
db.getCollection('stockReferenceLookUp').find({"StockReference":"71788038"})
db.getCollection('stockReferenceLookUp').find({"OrderID":"JAN010788038"})
db.getCollection('paymentRefLookUp').find({})
db.getCollection('exportedRetailCashandSales').find({})
db.getCollection('exportedbaseproduct').find({"ItemNo":"104693343"})

select * from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID;
 


  

/*
1.	Payment:  (No Tran)
		 * INVOICEREFERENCE -> ORDERID
		 * ORDERID -> STOCKREFERENCE
        select distinct INVOICEREFERENCE, PAYMENTREFERENCE, ORDERID,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS:FF\"Z\"') AS Timestamp, STOCKREFERENCE from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID;
        C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustomerOrderPayment\src\test\resources\testdata
        {"InvoiceReference":"9007826387","PaymentReference":"5ce9b91a-d080-415f-9acb-9ebb11bb6273","UserName":"username","ServiceName":"servicename","Id":"GUIDvalue","OrderId":"9007826387","Timestamp":"2020-10-01T14:38:35Z","HostName":"hostname"}

1.	Payment2:  -- gaurantee 
		 * INVOICEREFERENCE -> ORDERID
		 * ORDERID -> STOCKREFERENCE
        select distinct INVOICEREFERENCE, PAYMENTREFERENCE, ORDERID,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS:FF\"Z\"') AS Timestamp, STOCKREFERENCE from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID;
        C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustomerOrderPaymentType2\src\test\resources\testdata
--        {"Id":"a9ddd8e1-12e0-43c3-a407-4b6350821cec","InvoiceReference":"900788038","PaymentGuaranteedTimestamp":"2020-10-01T14:38:35Z","PaymentMethod":"PayPal","PaymentReference":"a9ddd8e1-12e0-43c3-a407-4b6350821cec","Timestamp":"2020-10-01T14:38:35Z"}
    
    {"Id":"29014bf0-21d4-4bdb-b946-0952270e5a03","Timestamp":"2022-02-13T16:00:02.1012886Z","InvoiceReference":"75RPRILGKCG0","OrderId":"705231430","PaymentReference":"21c07b6d-b531-48cb-8b23-4202c8d91783","PaymentMethod":"PayPal","PaymentGuaranteedTimestamp":"2022-02-13T16:00:01.9289267Z"}
    
2.	Order Booked:

        select distinct DISCOUNTTOTALAMOUNT, DISCOUNTCODE, DISCOUNTTYPE, DISCOUNTVALUE,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS') AS timestamp,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS:FF\"Z\"') AS createdDate  from SKUMAR.CASHANDSALES_ALL_CHK
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID)
        select distinct ORDERID, WLOCATION, STOCKREFERENCE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select distinct ORDERID,SKU, QUANTITY, CURRENTPRICE,PRICEVERSIONID  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select distinct ORDERREFERENCE,DELIVERYCOUNTRYCODE, WLOCATION,IDORCONVERSIONID, CURRENCYCODE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERREFERENCE
        
        C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustomerOrder_1_Fields\src\test\resources\testdata

        {"Discount":{"TotalAmount":0.0,"Code":"moreplease","Type":"Percentage","Value":0.0},"Store":"FC01","StockReference":"900788038",
        "Products":[
        {"Quantity":3,"Price":{"Current":12.0,"IsMarkedDown":false,"Previous":12.0,"IsOutletPrice":false,"PriceVersionId":"REGP0000020002000000004298686","Discounted":0.0},"SKU":"6653650","VariantId":33854954},
        {"Quantity":3,"Price":{"Current":12.0,"IsMarkedDown":false,"Previous":12.0,"IsOutletPrice":false,"PriceVersionId":"REGP0000020002000000004298686","Discounted":0.0},"SKU":"6653652","VariantId":33854954},
        {"Quantity":3,"Price":{"Current":12.0,"IsMarkedDown":false,"Previous":12.0,"IsOutletPrice":false,"PriceVersionId":"REGP0000020002000000004298686","Discounted":0.0},"SKU":"6653654","VariantId":33854954}],
        "Total":{"TotalDelivery":9.0,"Total":36.0,"ItemsSubTotal":36.0,"TotalDiscount":0.0},"CreatedDate":"2019-08-27T14:38:35Z","DeliveryAddress":{"CountryCode":"GB"},"OrderReference":"OCT010788038",
        "PaymentReference":"F6D2B742-2743-4930-996F-45CC2C8C86B0","Id":"5910","CurrencyCode":"GBP","ConversionId":5910,"Timestamp":"2020-10-11T11:38:40.000+01:00"}

        
3.	Liability (Stopp):
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID);
        select ORDERID ,ORDERTYPE,WLOCATION,SKU,QUANTITY,'FulfilmentStockForOrderUnconfirmed' as confirmedState,STOCKREFERENCE from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID;
        select distinct WLOCATION,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"') AS allocatedOnDateTimeUtc from SKUMAR.CASHANDSALES_ALL_CHK;

        C:\Users\siddeshk\Desktop\Scripts\CashSales\TestLiability\src\test\resources\testdata
        {"fulfilmentStockForOrder":{"confirmedState":"FulfilmentStockForOrderUnconfirmed","skus":[{"allocatedLocation":"FC01","quantity":3,"skuId":"6653654","status":"UNCONFIRMED"},{"allocatedLocation":"FC01","quantity":3,"skuId":"6653652","status":"UNCONFIRMED"},{"allocatedLocation":"FC01","quantity":3,"skuId":"6653650","status":"UNCONFIRMED"}],"orderId":"900788038","allocatedOnDateTimeUtc":"2020-10-01T14:38:35Z","_id":"123456789-1","version":1}}
        
        
4.	Billed Sale:
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID)
        select ORDERID,WLOCATION,SKU,QUANTITY,'CONFIRMED' as status,STOCKREFERENCE from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select distinct WLOCATION,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"') AS allocatedOnDateTimeUtc from SKUMAR.CASHANDSALES_ALL_CHK

        C:\Users\siddeshk\Desktop\Scripts\CashSales\TestBilledSale\src\test\resources\testdata
        {"fulfilmentStockForOrder":{"_id":"12345678-2","version":1,"allocatedOnDateTimeUtc":"2020-10-01T14:38:35Z","orderId":"900788038","confirmedState":"FulfilmentStockForOrderConfirmed","skus":[{"skuId":"6653654","quantity":3,"status":"CONFIRMED","allocatedLocation":"FC01"},{"skuId":"6653652","quantity":3,"status":"CONFIRMED","allocatedLocation":"FC01"},{"skuId":"6653650","quantity":3,"status":"CONFIRMED","allocatedLocation":"FC01"}]}}

5.	Dispatch:

        select distinct WLOCATION,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"') AS despatchedDateUtc from SKUMAR.CASHANDSALES_ALL_CHK
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID)
        select ORDERID,ORDERTYPE,WLOCATION,SKU,QUANTITY,STOCKREFERENCE  from SKUMAR.CASHANDSALES_ALL_CHK ORDER BY ORDERID
        
        C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCutomerDispatch\src\test\resources\testdata
        {"despatchedDateUtc":"2020-10-01T14:38:35.000+01:00","notifyingWarehouse":"FC01","despatchedItems":[{"orderType":"Consumer","quantity":3,"orderId":"900788038","sku":"6653654"},{"orderType":"Consumer","quantity":3,"orderId":"900788038","sku":"6653652"},{"orderType":"Consumer","quantity":3,"orderId":"900788038","sku":"6653650"}],"trackingUrl":"https://nolp.dhl.de/nextt-online-public/en/search?piececode=442421206501","packageId":"01AB","processType":"Consumer","carrierId":"DHL Weltpaket"}







    
6.	Returns:

    1.  Item Cancel request 
        select distinct DISCOUNTTOTALAMOUNT, DISCOUNTCODE, DISCOUNTTYPE, DISCOUNTVALUE,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS') AS timestamp,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS:FF\"Z\"') AS createdDate  from SKUMAR.CASHANDSALES_ALL_CHK_RET
        select distinct ORDERREFERENCE,DELIVERYCOUNTRYCODE, WLOCATION,IDORCONVERSIONID, CURRENCYCODE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERREFERENCE
        select distinct ORDERID,SKU, QUANTITY, CURRENTPRICE,PRICEVERSIONID  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select distinct ORDERID, WLOCATION, STOCKREFERENCE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        
            C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustItemCancelReq\src\test\resources\testdata
            {"CancellationDate":"2020-10-11T11:05:18:104062Z","CancellationReference":"900788049","CustomerId":900788049,"Id":"900788049","OrderReference":"OCT010788049","Products":[{"Action":{"Code":1},"ActionedBeforeGoodsReceived":false,"GoodsExpected":"NotReceived","Quantity":3,"Reason":{"Code":5},"Sku":"6004805","VariantId":33854954},{"Action":{"Code":1},"ActionedBeforeGoodsReceived":false,"GoodsExpected":"NotReceived","Quantity":3,"Reason":{"Code":5},"Sku":"6004806","VariantId":33854954},{"Action":{"Code":1},"ActionedBeforeGoodsReceived":false,"GoodsExpected":"NotReceived","Quantity":3,"Reason":{"Code":5},"Sku":"6004807","VariantId":33854954}],"ReturnReference":"0ORWWMKXPR2I","SelectedDeliveryOption":{"deliveryOptionId":1},"Store":"FC01","Subscription":{},"Timestamp":"2020-10-11T11:05:18:104062Z"}
            

    2. Item cancelled
        select distinct DISCOUNTTOTALAMOUNT, DISCOUNTCODE, DISCOUNTTYPE, DISCOUNTVALUE,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS') AS timestamp,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS:FF\"Z\"') AS createdDate  from SKUMAR.CASHANDSALES_ALL_CHK
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID)
        select distinct ORDERID, WLOCATION, STOCKREFERENCE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select distinct ORDERID,SKU, QUANTITY, CURRENTPRICE,PRICEVERSIONID  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        select distinct ORDERREFERENCE,DELIVERYCOUNTRYCODE, WLOCATION,IDORCONVERSIONID, CURRENCYCODE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERREFERENCE
    
            C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustItemCancelled\src\test\resources\testdata            
            {"CancellationDate":"2020-10-11T10:57:49:228067Z","CancellationReference":"900788038","CustomerId":900788038,"Id":"900788038","OrderReference":"OCT010788038","Products":[{"Action":{"Code":1},"ActionedBeforeGoodsReceived":false,"GoodsExpected":"NotReceived","Quantity":3,"Reason":{"Code":5},"Sku":"6653650","VariantId":33854954},{"Action":{"Code":1},"ActionedBeforeGoodsReceived":false,"GoodsExpected":"NotReceived","Quantity":3,"Reason":{"Code":5},"Sku":"6653652","VariantId":33854954},{"Action":{"Code":1},"ActionedBeforeGoodsReceived":false,"GoodsExpected":"NotReceived","Quantity":3,"Reason":{"Code":5},"Sku":"6653654","VariantId":33854954}],"ReturnReference":"0ORWWMKXPR2I","SelectedDeliveryOption":{"deliveryOptionId":1},"Store":"FC01","Subscription":{},"Timestamp":"2020-10-11T10:57:49:228067Z"}
        
   
   3.  Item refund Calc
        select distinct DISCOUNTTOTALAMOUNT, DISCOUNTCODE, DISCOUNTTYPE, DISCOUNTVALUE,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS') AS timestamp,TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS:FF\"Z\"') AS createdDate  from SKUMAR.CASHANDSALES_ALL
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK  order by ORDERID)
        select distinct ORDERID, WLOCATION, STOCKREFERENCE  from SKUMAR.CASHANDSALES_ALL_CHK  order by ORDERID
        select distinct ORDERID,SKU, QUANTITY, CURRENTPRICE,PRICEVERSIONID  from SKUMAR.CASHANDSALES_ALL_CHK  order by ORDERID
        select distinct ORDERREFERENCE,DELIVERYCOUNTRYCODE, WLOCATION,IDORCONVERSIONID, CURRENCYCODE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERREFERENCE
        
            C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustRefundCalc\src\test\resources\testdata
            
            {"CalculationDate":"2020-10-11T11:09:10:952228Z","CurrencyCode":"GBP","CustomerId":900788045,"Delivery":{"DeliveryOptionId":1,"RefundCalculation":{"Discounted":0.0,"Price":12.0,"Refunded":12.0,"SalesTax":0.0}},"Discount":{"Code":"moreplease","DiscountType":"Percentage","TotalAmount":0.0,"Value":0.0},"Id":"900788045","OrderReference":"OCT010788045","Products":[{"Quantity":3,"RefundCalculation":{"Discounted":0.0,"Price":12.0,"Refunded":12.0},"Sku":"6653651","VariantId":33854954},{"Quantity":3,"RefundCalculation":{"Discounted":0.0,"Price":12.0,"Refunded":12.0},"Sku":"6653653","VariantId":33854954},{"Quantity":3,"RefundCalculation":{"Discounted":0.0,"Price":4.5,"Refunded":4.5},"Sku":"6711008","VariantId":33854954}],"RefundReference":"900788045","ReturnReference":"0ORWWMKXPR2I","Store":"FC01","Timestamp":"2020-10-11T11:09:10:952228Z","Total":{"Delivery":9.0,"Discount":0.0,"Items":28.5,"Refunded":0.0,"SalesTax":0.0}}
        
    4. Customer Return (XML & JSON)
    
        select * from (select distinct orderid from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID)
        select ORDERID,WLOCATION, ACTION, CODE, SKU,RETURNQTY, USER_DEF_TYPE_4, LOCK_CODE,to_char(systimestamp,'YYYYMMDDHHMISS') as dstamp,STOCKREFERENCE  from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID
        
        
                C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustReturn\src\test\resources\notification_Automation
                {"metadata":{"eventClassification":"FilePublication","dataSchemaVersion":1,"eventName":"BDPublished","eventCreatedDateTime":"2017-08-20T12:00:00Z","entity":"BD"},"data":{"path":"customerreturns/CustRetOCT010788038.xml","fileName":"CustRetOCT010788038.xml","blobUri":"https://asbamintstgeuwvpt01.blob.core.windows.net/bam112-custrettesting/testDir/CustRetOCT010788038.xml?sv=2018-03-28&ss=bfqt&srt=sco&sp=rl&st=2019-08-29T10%3A07%3A54Z&se=2020-08-30T10%3A07%3A00Z&sig=JDStcf04LzOoyb8inCJMeoNA8MeYQR9XAK85NWCbxpk%3D"}}
                C:\Users\siddeshk\Desktop\Scripts\CashSales\TestCustReturn\src\test\resources\testdata_Automation
                            <dcsextractdata>
                                <dataheaders>
                                    <dataheader>
                                        <record_type>ITL</record_type>
                                        <action>E</action>
                                        <code>Receipt Return</code>
                                        <update_qty>1.0</update_qty>
                                        <dstamp>20190508143835</dstamp>
                                        <sku_id>6653654</sku_id>
                                        <site_id>FC01</site_id>
                                        <user_def_type_4>900788038</user_def_type_4>
                                        <lock_code>AQL</lock_code>
                                    </dataheader>
                                </dataheaders>
                            </dcsextractdata>

    
	*/

select distinct INVOICEREFERENCE, PAYMENTREFERENCE from CASHANDSALES_ALL_CHK order by 1;--139102
select distinct INVOICEREFERENCE, PAYMENTREFERENCE from CASHANDSALES_ALL_CHK2 order by 1;--139102
select distinct INVOICEREFERENCE, PAYMENTREFERENCE from CASHANDSALES_ALL_CHK3 order by 1; --139102

select distinct INVOICEREFERENCE, PAYMENTREFERENCE from CASHANDSALES_ALL_CHK_RET;
select distinct INVOICEREFERENCE, PAYMENTREFERENCE from CASHANDSALES_ALL_CHK_chck2;

create table PAYMENTREFERENCE (ORDERID varchar2(25),PAYMENTREFERENCE varchar2(255));
drop table PAYMENTREFERENCE;
select * from PAYMENTREFERENCE;


MERGE INTO CASHANDSALES_ALL_CHK_chck2 a
      USING (select * from PAYMENTREFERENCE) b
      ON (a.ORDERID = b.ORDERID)
      WHEN MATCHED THEN
        UPDATE SET
          a.PAYMENTREFERENCE = b.PAYMENTREFERENCE;

select * from CASHANDSALES_ALL_CHK_chck2;
select * from PAYMENTREFERENCE;

drop table CASHANDSALES_ALL_CHK_chck2;
create table CASHANDSALES_ALL_CHK_chck2 as
select * from CASHANDSALES_ALL_CHK_RET where STOCKREFERENCE between '932760112' and '932760176';


begin
Update CASHANDSALES_ALL_CHK_chck2 set STOCKREFERENCE=replace(STOCKREFERENCE,'01','02');
UPDATE skumar.CASHANDSALES_ALL_CHK_chck2 SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'OCT10','OCT11'),
    ORDERID = replace(ORDERID,'OCT10','OCT11'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'OCT10','OCT11'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'OCT10','OCT11');
commit;
end;
/


select * from CASHANDSALES_ALL_CHK; -- laibility & billed sale  
select * from CASHANDSALES_ALL_CHK2; -- dispatch & return
select * from CASHANDSALES_ALL_CHK3; -- order book & paymnt

/*

Pre activities
1. Set  -> orderBookedDirectory
1. Set  -> Payment
2. Set  -> orderBookedDirectory
2. Set  -> Payment

Peak Hour tests
2. Set  -> dispatchDirectory -- 60k
1. Set  -> liabilityDirectory --80k
1. Set  -> liabilityDirectory --60k

3. Set  -> orderBookedDirectory --80k
3. Set  -> orderBookedDirectory --60k
3. Set ->  payments --80k
3. Set ->  payments --60k
1. Set  -> billedSaleDirectory --80k
1. Set  -> billedSaleDirectory --60k


140 liability - 40 per sec
140 orderBooked - 40 per sec
140 payments - 40  per sec
140 billedSale - 40 per sec
 60 dispatch  - 16 per sec
 
 
*/ 

db.getCollection('publishedPriceDLBAM').find({"OptionItemId":"100256318"})
db.getCollection('exportedPrice').find({"OptionItemId":"100256318"})


select WLOCATION, DISCOUNTTOTALAMOUNT, DISCOUNTCODE, DISCOUNTTYPE, DISCOUNTVALUE, SKU, QUANTITY, CURRENTPRICE, PRICEVERSIONID 
 from SKUMAR.CASHANDSALES_ALL_CHK order by ORDERID;

PRMP00000200000000000 22231032 20211010000000
 22231032

SELECT * FROM rpm_promo_item_loc_expl where item in (select item from item_master where item ='11110815' or item_parent ='101202328');

SELECT * FROM rpm_future_retail where item in (select item from item_master where item ='11110815');
select * from item_master where item ='101202328' or item_parent ='101202328';

30519397	30519397
PRMP00000200040000000 30519397 20210915020000


PROMO_DTL_DISPLAY_ID, START_DATE
RPM_PROMO_DTL

SELECT  ITEM from RPM_PROMO_DTL_MERCH_NODE, ;

SELECT * FROM RPM_PROMO WHERE promo_id =57299;
select * from rpm_promo_comp where promo_id =57299;
SELECT * FROM RPM_PROMO_DTL WHERE promo_comp_id IN (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =57299) an;
SELECT * FROM RPM_PROMO_DTL_MERCH_NODE WHERE PROMO_DTL_ID in (select PROMO_DTL_ID from RPM_PROMO_DTL where promo_comp_id in (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =57299 ));
SELECT * FROM RPM_PROMO_DTL_LIST_GRP WHERE PROMO_DTL_ID in (select PROMO_DTL_ID from RPM_PROMO_DTL where promo_comp_id in (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =57299 ));
SELECT * FROM RPM_PROMO_ZONE_LOCATION WHERE PROMO_DTL_ID in (select PROMO_DTL_ID from RPM_PROMO_DTL where promo_comp_id in (SELECT promo_comp_id  FROM RPM_PROMO_COMP WHERE PROMO_ID =57299 ));
select * from rpm_promo_dtl_list where promo_dtl_list_id in (select promo_dtl_list_id from rpm_promo_dtl_merch_node where promo_dtl_id in (select promo_dtl_id from rpm_promo_dtl where promo_comp_id in (select promo_comp_id  from rpm_promo_comp where promo_id =57299 )));
select * from rpm_promo_dtl_disc_ladder where promo_dtl_list_id in (select promo_dtl_list_id from rpm_promo_dtl_merch_node where promo_dtl_id in (select promo_dtl_id from rpm_promo_dtl where promo_comp_id in (select promo_comp_id  from rpm_promo_comp where promo_id =57299 )));
select * from rpm_promo_comp_thresh_link where promo_comp_id in (select promo_comp_id  from rpm_promo_comp where promo_id =57299 );

select node.item,
       NVL(rzl.location, rzl.zone_id) loc,rp.promo_id, rp.promo_display_id, comp.PROMO_COMP_ID, comp.comp_display_id, comp.customer_type, 
       dtl.promo_dtl_id,dtl.promo_dtl_display_id, dtl.start_date, dtl.end_date,
       dsc.change_type, NVL(dsc.change_percent, dsc.change_amount) discount, dtl.price_guide_id,
       decode(dtl.state, 0, 'worksheet', 1, 'rejected', 2, 'submitted', 3, 'approved', 
                         4, 'cancelled', 5, 'active', 6, 'complete', 7, 'conflict checking', 8, 'pending', 'n/a') state,
       DECODE(expl.promo_dtl_id, null, 'NO', 'YES') flowed,
       dtl.create_id, to_char(dtl.approval_date, 'DD/Mon/YYYY: HH24:MM:SS') approval_date,
       dtl.approval_id, to_char(dtl.create_date, 'DD/Mon/YYYY: HH24:MM:SS') create_date
from rpm_promo_dtl dtl,
     rpm_promo_dtl_merch_node node,
     rpm_promo_zone_location rzl,
     rpm_promo_dtl_list_grp grp,
     rpm_promo_dtl_list lst,
     rpm_promo_dtl_disc_ladder dsc,
     rpm_promo_comp comp,
     rpm_promo rp,
     item_master im,
     rpm_promo_item_loc_expl expl
where node.promo_dtl_id = dtl.promo_dtl_id
and rzl.promo_dtl_id = dtl.promo_dtl_id
and node.promo_dtl_id = rzl.promo_dtl_id
and grp.promo_dtl_id = dtl.promo_dtl_id
and lst.promo_dtl_list_grp_id = grp.promo_dtl_list_grp_id
and lst.promo_dtl_list_id = dsc.promo_dtl_list_id
and comp.promo_comp_id = dtl.promo_comp_id
and rp.promo_id = comp.promo_id
and im.item = node.item
--and im.item = '101202328'
and dtl.promo_dtl_display_id in ('22231032')
and dtl.promo_dtl_id = expl.promo_dtl_id(+)
order by node.item, rzl.location, approval_date desc, dtl.start_date;

