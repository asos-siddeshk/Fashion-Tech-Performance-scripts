


 select * from (select distinct TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS eventDateTime,'MediaComplete' as eventType,
    TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS dateOnStore, il.item_parent  as optionId,il.item as skuid 
        from skumar.pim_product_event_item il where il.item_parent is not null order by  optionId, skuid);

drop table pim_product_event;
create table pim_product_event as
select * from ( select distinct item_parent from livebyfcitem) where rownum<='1000';

select * from pim_product_event;
drop table pim_product_event_item;
create table pim_product_event_item as
select * from item_master where item in (select distinct item_parent from pim_product_event);
insert into pim_product_event_item
select * from item_master where item_parent in (select distinct item_parent from pim_product_event);



GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.pim_product_event_item TO SSHASTRY; 

select * from uda_item_ff where uda_id ='1001' and item ='7489070';


 select * from (select distinct TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS eventDateTime,'MediaComplete' as eventType,
    TO_CHAR(systimestamp,'YYYY-MM-DD\"T\"HH24:MI:SS')||'Z' AS dateOnStore, il.item_parent  as optionId,il.item as skuid 
        from skumar.pim_product_event_item il order by  optionId, skuid);
        

select * from item_master where item in (SELECT item FROM INT_ASOS.INT_ITEM_PIM_EVENT_STG where trunc(EVENT_DATE) = trunc(sysdate));
SELECT * FROM INT_ASOS.INT_ITEM_PIM_EVENT_STG where trunc(EVENT_DATE) = trunc(sysdate);       

SELECT count(1) FROM INT_ASOS.INT_ITEM_PIM_EVENT_STG where trunc(EVENT_DATE) = trunc(sysdate);
        
       /*    
    {
  "eventDateTime": "2019-05-08T10:03:27Z",
  "eventType": "MediaComplete",
  "productId": 35019996,
  "publishStatus": "UnPublished",
  "hints": {
    "productId": 35019996,
    "styleId": "1155585",
    "colourways": [
      {
        "colourwayId": 35019997,
        "optionId": "100415153",
        "variants": [
          {
            "variantId": 35019998,
            "skuId": "102229765"
          }
        ]
      }
    ]
  },
  "correlationId": "289bc6eb-44bf-44e1-afe2-e55b02311805",
  "productLastUpdatedDateTime": "2019-05-08T09:04:34Z",
  "publishedDateTime": "2019-05-09T09:04:34Z",
  "link": {
    "rel": "self",
    "href": "https://sit-product-management-api-tgr.test.digcoreint.com/productmanagement/product/v1/products/35019996"
  },
  "productStatus": "Enrich"
}







