select * from all_tables where table_name like '%CASHANDSALES%';
CASHANDSALES_2022_CHK_SCRIPT

CASHANDSALES_2022
CASHANDSALES_2022_DEC
CASHANDSALES_2022_SOAK
CASHANDSALES_2022_NOV
CASHANDSALES_2022_SEP


select distinct ORDERID,DELIVERYCOUNTRYCODE from CASHANDSALES_2022 where DELIVERYCOUNTRYCODE = 'GB';

create table CASHANDSALES_GST_AFS as
select * from CASHANDSALES_2022 where DELIVERYCOUNTRYCODE = 'GB';



select * from CASHANDSALES_GST_AFS;
select * from CASHANDSALES_2022_SEP;
select * from CASHANDSALES_2022_SOAK;

drop table CASHANDSALES_GST_AFS;
create table CASHANDSALES_GST_AFS as
select * from CASHANDSALES_2022  where ORDERID in ( 
    select * from (select distinct ORDERID from CASHANDSALES_2022) where rownum <= '2000');


--First Set-- 

UPDATE skumar.CASHANDSALES_GST_AFS SET INVOICEREFERENCE = replace(INVOICEREFERENCE,'OCT04','JAN01'),
    ORDERID = replace(ORDERID,'OCT04','JAN01'),
    ORDERREFERENCE = replace(ORDERREFERENCE,'OCT04','JAN01'),
    USER_DEF_TYPE_4 = replace(USER_DEF_TYPE_4,'OCT04','JAN01');

Update CASHANDSALES_GST_AFS set STOCKREFERENCE=replace(STOCKREFERENCE,'890','900');

SELECT STOCKREFERENCE, COUNT(*) FROM skumar.CASHANDSALES_GST_AFS GROUP BY STOCKREFERENCE HAVING COUNT(*) > 5;



select * from CASHANDSALES_GST_AFS where ORDERID= 'JAN010790546';
select * from CASHANDSALES_GST_AFS where STOCKREFERENCE = '900164900';

update CASHANDSALES_GST_AFS set STOCKREFERENCE = '901164900' where STOCKREFERENCE= '900164900' and ORDERID = 'JAN010789550';


select * from CASHANDSALES_GST_AFS;


              <xs:element name="Seller">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="Id" />
                    <xs:element name="Description" type="xs:string"/>
                  </xs:sequence>
                </xs:complexType>


select * from CASHANDSALES_GST_AFS;

/*
{ "PackageId": "FAKE_CONTAINER_FC06_419943156", -- Dispatchid
  "OrderId": "419943156", - -Stock xref
  "OrderReference": "8TPCGXXC03TK", -- orderid
  "TaxJurisdictionISOCode": "GB",  --GB --  JE, GG
  "ParentOrderReference": null,
  "ParentOrderId": null,
  "ReplacementOrderReference": null,
  "ReplacementOrderId": null,
  "DateUtc": "2023-10-11T08:12:33Z",
  "Items": [ { "Sku": "118742507", "VariantId": 202808330, "Quantity": 1   }]} */

select distinct WLOCATION,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS despatchedDateUtc from SKUMAR.CASHANDSALES_GST_AFS;

-- Dispatch
select * from (select distinct orderid,STOCKREFERENCE, 'Dispatch_'||ORDERID as PackageId,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS DateUtc, DELIVERYCOUNTRYCODE as TaxJurisdictionISOCode from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID);
select * from (select distinct ORDERID, SKU, QUANTITY from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID);

select * from (select distinct ORDERID from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID);

create table CASHANDSALES_GST_AFS_PAYCNF as 
select * from SKUMAR.CASHANDSALES_GST_AFS where orderid in ('JAN010788038',
'JAN010788044',
'JAN010788680',
'JAN010788681',
'JAN010789550',
'JAN010789551',
'JAN010790240',
'JAN010790241',
'JAN010790243',
'JAN010790245',
'JAN010790247',
'JAN010790248',
'JAN010790250',
'JAN010790780',
'JAN010790783');



select * from (select distinct orderid,STOCKREFERENCE, 'Dispatch_'||ORDERID as PackageId,TO_CHAR(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS DateUtc, DELIVERYCOUNTRYCODE as TaxJurisdictionISOCode from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID);
select * from (select distinct ORDERID, SKU, QUANTITY from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID);



select ORDERID,SKU, SELLERID, SOURCEDESC, SOURCEID, SELLERDESC from SKUMAR.CASHANDSALES_GST_AFS;

select ORDERID, SKU, SOURCEID, SOURCEDESC, SELLERID, SELLERDESC from SKUMAR.CASHANDSALES_GST_AFS;


ALTER TABLE CASHANDSALES_GST_AFS 
ADD (
SOURCEDESC                           VARCHAR2(25),
SOURCEID                           VARCHAR2(25),
SELLERDESC                           VARCHAR2(25));
ALTER TABLE CASHANDSALES_GST_AFS 
ADD (
ROW_NUM NUMBER(2));

Update SKUMAR.CASHANDSALES_GST_AFS set  SOURCEID = null,SELLERDESC =null,SELLERID = null,SOURCEDESC = null;

Update SKUMAR.CASHANDSALES_GST_AFS set  SOURCEID = 'ASOSUK',SOURCEDESC ='ASOSUK' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS) where rownum <= '500');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SCAAFS',SELLERDESC ='SCALPERS' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '500');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SUP',SELLERDESC ='SUP' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '100');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SPE',SELLERDESC ='SPE' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '100');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'KIC',SELLERDESC ='KIC' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '100');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'CCC',SELLERDESC ='CCC' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '100');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'CCC',SELLERDESC ='CCC' where SELLERID is null and SOURCEID is null and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '100');




desc CASHANDSALES_GST_AFS;

-- orderbooked 

-- product -- 
sELECT distinct ORDERID, sku as  ProductId, sku as  VariantId,   sku, QUANTITY, Ean, CURRENTPRICE, Previous,'0.0' as RRP , 'true' as  IsMarkedDown, 'false' as IsOutletPrice, PriceVersionId, IDORCONVERSIONID as ConversionId, wlocation as Warehouse
, SOURCEID, SOURCEDESC, SELLERID, SELLERDESC FROM skumar.CASHANDSALES_GST_AFS order by ORDERID;

--TotalsBySeller--
SELECT distinct ORDERID, sourceid,SELLERID, sum(CURRENTPRICE) as ItemsTotal, 
sum(PRICETOPAY) as DeliveryTotal,
sum(DISCOUNTVALUE) as DiscountTotal,
sum(CURRENTPRICE + PRICETOPAY) as GrandTotal, 
null SalesTaxTotal  
FROM skumar.CASHANDSALES_GST_AFS group by ORDERID,SOURCEID,SELLERID order by ORDERID;

--TotalsBySeller--
SELECT distinct ORDERID FROM skumar.CASHANDSALES_GST_AFS;

select ORDERID, SKU, SOURCEID, SOURCEDESC, SELLERID, SELLERDESC from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID, ROW_NUM;


create table CASHANDSALES_GST_AFS_NUM as 
SELECT ORDERID, SKU,
      ROW_NUMBER() OVER (PARTITION BY ORDERID ORDER BY sku) AS row_num
    FROM SKUMAR.CASHANDSALES_GST_AFS;
    
select * from  CASHANDSALES_GST_AFS_NUM; 
select * from  CASHANDSALES_GST_AFS; 



MERGE INTO CASHANDSALES_GST_AFS a USING (
  SELECT *  FROM CASHANDSALES_GST_AFS_NUM) b
ON (a.ORDERID = b.ORDERID and a.SKU = b.SKU)
WHEN  MATCHED THEN
  UPDATE SET 
    a.row_num = b.row_num;
    
    
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SCAAFS',SELLERDESC ='SCALPERS' where SELLERID is null and SOURCEID is null and row_num <= '3' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '200');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SUP',SELLERDESC ='SUP' where SELLERID is null and SOURCEID is null and row_num > '3' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '200');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SCAAFS',SELLERDESC ='SCALPERS' where SELLERID is null and SOURCEID is null and row_num <= '3' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '200');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'SPE',SELLERDESC ='SPE' where row_num > '3' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '50');
Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'KIC',SELLERDESC ='KIC' where row_num > '3' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '50');

Update SKUMAR.CASHANDSALES_GST_AFS set  SELLERID = 'KIC',SELLERDESC ='KIC' where row_num > '3' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '100');

select * from CASHANDSALES_GST_AFS where SELLERID ='SPE'  and SOURCEID is null and row_num >= '4' and ORDERID in (select * from (select distinct ORDERID from CASHANDSALES_GST_AFS where SELLERID is null and SOURCEID is null) where rownum <= '5');


select * from SKUMAR.CASHANDSALES_GST_AFS;

-- product -- 
sELECT distinct ORDERID, sku as  ProductId, sku as  VariantId,   sku, QUANTITY, Ean, CURRENTPRICE, Previous,'0.0' as RRP , 'true' as  IsMarkedDown, 'false' as IsOutletPrice, PriceVersionId, IDORCONVERSIONID as ConversionId, wlocation as Warehouse
, SOURCEID, SOURCEDESC, SELLERID, SELLERDESC FROM skumar.CASHANDSALES_GST_AFS order by ORDERID;

--TotalsBySeller--
SELECT distinct ORDERID, SELLERID, sum(CURRENTPRICE) as ItemsTotal, 
sum(PRICETOPAY) as DeliveryTotal,
sum(DISCOUNTVALUE) as DiscountTotal,
sum(CURRENTPRICE + PRICETOPAY) as GrandTotal, 
null SalesTaxTotal  
FROM skumar.CASHANDSALES_GST_AFS group by ORDERID,SELLERID order by ORDERID;

select ORDERID, SKU, SOURCEID, SOURCEDESC, SELLERID, SELLERDESC from SKUMAR.CASHANDSALES_GST_AFS order by ORDERID, ROW_NUM;
select * from CASHANDSALES_GST_AFS where ORDERID= 'JAN010790986';



