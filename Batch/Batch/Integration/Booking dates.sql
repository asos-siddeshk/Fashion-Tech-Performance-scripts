select * from all_tables where table_name like 'NB_SHJI{%';


---  Data for xml

select * from shipment where shipment  like '50000738%';

create table int_bookingdates as
select sh.SHIPMENT, sh.ORDER_NO, sh.ASN as reference_id, to_char(sh.SHIP_DATE+1,'YYYYmmddHHMISS')  as booking_dstamp, 
        s.EXTERNAL_REF_ID as supplier_id, 'A'||s.EXTERNAL_REF_ID as bookref_id, wh.WH_NAME_SECONDARY as site_id
    from rms.shipment sh, sups s, ordhead oh, wh wh
    where sh.order_no = oh.order_no
        and s.supplier = oh.supplier 
       -- and oh.order_no in ('50000738238') 
        and sh.order_no is not null 
        and sh.to_loc = wh.wh
        and sh.to_loc IN ('4','1','3')
        and status_code ='I' 
        and rownum <= '6000' order by 1 desc;
       
    --- Validations  -- 

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.int_bookingdates TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.int_bookingdates TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.int_bookingdates TO rdatla; 

    
select * from skumar.int_bookingdates;

select SHIPMENT,VARCHAR2_1,DATE_24 from rms.nb_shipment_cfa_ext where shipment in (select shipment from int_bookingdates);

update rms.nb_shipment_cfa_ext set VARCHAR2_1=null,DATE_24=null  where shipment in (select shipment from int_bookingdates);

Query: 
select * from skumar.int_bookingdates;
Validation:
select sh.asn,sh.order_no,nbs.date_24 fc_booking_date,nbs.varchar2_1 fc_booking_ref
   from rms.shipment sh, rms.nb_shipment_cfa_ext nbs
   where sh.shipment=nbs.shipment
and sh.shipment in (select shipment from skumar.int_bookingdates);
        
        select * from shipment where asn like '0200000000041531';
        
select * from wh;
select * from rms.shipment where order_no in ('50000738238');
select SHIPMENT,VARCHAR2_1,DATE_24 from rms.nb_shipment_cfa_ext where shipment in (select shipment from rms.shipment where order_no in ('50000738238'));


select * from nb_shipment_cfa_ext order by 1; --I84437

select * from sups_cfa_ext;
select * from sups where EXTERNAL_REF_ID is not null;


<dcsextractdata>
   <dataheaders>
       <dataheader>
           <record_type>BKL</record_type>
           <action>E</action>
           <code>Add</code>
           <bookref_id>D0002816</bookref_id>
           <site_id>FC01</site_id>
           <booking_dstamp>20190513102942</booking_dstamp>
           <status>Scheduled</status>
           <location_id>EUROHUB</location_id>
           <no_slots>4</no_slots>
           <estimated_pallets>0</estimated_pallets>
           <estimated_cartons>0</estimated_cartons>
           <actual_pallets>0</actual_pallets>
           <actual_cartons>0</actual_cartons>
           <reference_id>50000678235</reference_id>
           <reference_type>Pre-Advised</reference_type>
           <client_id>ASOS</client_id>
           <supplier_id>ABERFIT</supplier_id>
           <carrier_id>1</carrier_id>
           <station_id>DOCDATA</station_id>
           <user_id>60</user_id>
           <dstamp>20190513102942</dstamp>
           <uploaded>N</uploaded>
           <time_zone_name>Europe/London</time_zone_name>
           <service_level></service_level>
           <trailer_id>ex Holland</trailer_id>
       </dataheader>
   </dataheaders>
</dcsextractdata>


SELECT DISTINCT SH.ASN
FROM 
RMS.SHIPMENT SH,
RMS.SHIPSKU SK,
RMS.NB_SHIPMENT_CFA_EXT NBS,
RMS.ORDHEAD OH
WHERE
SH.SHIPMENT=SK.SHIPMENT
AND SK.SHIPMENT=NBS.SHIPMENT
AND SH.ORDER_NO=OH.ORDER_NO
AND NBS.GROUP_ID='1010100' 
AND OH.CREATE_ID !='ORACNV' and rownum <= '50'
ORDER BY DBMS_RANDOM.VALUE 
;


SELECT DISTINCT SH.ASN,SH.order_no,NBS.DATE_24 FC_BOOKING_DATE,NBS.VARCHAR2_1 FC_BOOKING_REF
FROM RMS.SHIPMENT SH, RMS.SHIPSKU SK, RMS.NB_SHIPMENT_CFA_EXT NBS, RMS.ORDHEAD OH
WHERE SH.SHIPMENT=SK.SHIPMENT
AND SK.SHIPMENT=NBS.SHIPMENT
AND SH.ORDER_NO=OH.ORDER_NO
AND NBS.GROUP_ID='1010100' 
AND SH.ASN='170015165155555';



select  order_no,status from ordhead where order_no in (50000738238);
select  * from ordhead where order_no in (50000738238);
select * from ordloc where order_no in (50000738238);
select * from shipment where order_no in (50000738238);
select STATUS_CODE,count(1) from shipment where order_no in (50000738238) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50000738238));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (50000738238));
select * from RMS.NB_SHIPMENT_CFA_EXT where shipment in (select shipment from shipment where order_no in (50000738238));




