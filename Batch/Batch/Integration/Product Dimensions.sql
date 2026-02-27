select * from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = '02-JUN-20';
select * from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = '30-JUN-20';




select count(1) from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate);
select * from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate);


select * from rib_message where ADAPTER_CLASS_LOCATION = 'rib-rms_XItem_sub';
select count(1) from rib_message where ADAPTER_CLASS_LOCATION = 'rib-rms_XItem_sub';
select count(1) from rib_message where trunc(NEXT_ATTEMPT_TIME) = '30-JUN-20' and ADAPTER_CLASS_LOCATION = 'rib-rms_XItem_sub';
select * from rib_message where trunc(NEXT_ATTEMPT_TIME) = '30-JUN-20';

select * from rib_message where id like '%4111568%';
select * from rib_message_failure where message_num = '274012';

Caused by: com.retek.rib.binding.exception.RIBIntegrationException: Exception while processing request: null - Nested exception: - java.lang.NullPointerException
	at com.retek.rib.binding.subscriber.impl.PlsqlSubscriberCoreServiceImpl.subscribe(PlsqlSubscriberCoreServiceImpl.java:76)
	at com.retek.rib.j2ee.RIBMessageSubscriberEjb$MessageHandler.handleMessage(RIBMessageSubscriberEjb.java:388)


select * from (select distinct im.item from SKUMAR.ordfullfillment ca, rms.item_master im 
        where im.tran_level =2 and im.item_level =2  and im.item = ca.sku
        and not exists (select 1 from rms.ITEM_SUPP_COUNTRY_DIM iscd where iscd.item = ca.sku and trunc(LAST_UPDATE_DATETIME) = trunc(sysdate))
        ) 
        where rownum <= '7';

select count(1) from ITEM_SUPP_COUNTRY_DIM where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate);
select * from rms.ITEM_SUPP_COUNTRY_DIM where item in ('9135137','6261351','6261350','6261348','6261347','6261349');


select * from 
(select distinct(ca.SKU) from SKUMAR.CASHANDSALES_ALL ca where not exists 
(select 1 from rms.ITEM_SUPP_COUNTRY_DIM iscd where iscd.item = ca.sku)) where rownum <= '11900';


desc ITEM_SUPP_COUNTRY_DIM;


create table productdim (item varchar2(25));
delete from productdim where item ='(blank)';
delete from productdim where item ='Grand Total';
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.productdim TO SSHASTRY; 

--Input 
select ca.* from productdim ca where ca.item is not null and 
  exists  (select 1 from rms.ITEM_SUPP_COUNTRY_DIM iscd where iscd.item = ca.item);

--Validations 

select count(1) from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate);
select * from ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) ;


select count(1) from INT_ASOS.ITEM_SUPP_COUNTRY_DIM iscd where trunc(LAST_UPDATE_DATETIME) = trunc(sysdate) and LENGTH is not null;


select * from 