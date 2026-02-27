select * from all_tables where table_name like 'NB_SHJI{%';


---  Data for xml

select sh.SHIPMENT, sh.ORDER_NO, sh.ASN as reference_id, to_char(sh.SHIP_DATE+1,'YYYYmmddHHMISS')  as booking_dstamp, 
        s.EXTERNAL_REF_ID as supplier_id, 'A'||s.EXTERNAL_REF_ID as bookref_id, wh.WH_NAME_SECONDARY as site_id
    from rms.shipment sh, sups s, ordhead oh, wh wh
    where sh.order_no = oh.order_no
        and s.supplier = oh.supplier 
        and sh.shipment in (select shipment from skumar.receipt_adj) 
        and sh.order_no is not null 
        and sh.to_loc = wh.wh
        and sh.to_loc IN ('4','1','3')
        and status_code ='I'  order by 1 desc;
       
    --- Validations  -- 

select distinct sh.asn,sh.order_no,nbs.date_24 fc_booking_date,nbs.varchar2_1 fc_booking_ref
   from rms.shipment sh, rms.shipsku sk, rms.nb_shipment_cfa_ext nbs, rms.ordhead oh
   where sh.shipment=sk.shipment
		and sk.shipment=nbs.shipment
		and sh.order_no=oh.order_no
		and nbs.group_id='1010100' 
		and sh.shipment in (select shipment from skumar.receipt_adj);
        
        select * from shipment where asn like '0200000000041531';
        
select * from wh;
select * from rms.shipment where order_no in ('50000738238');
select SHIPMENT,VARCHAR2_1,DATE_24 
    from rms.nb_shipment_cfa_ext where shipment in (select shipment from rms.shipment where order_no in ('50000738238'));


select * from nb_shipment_cfa_ext order by 1 desc; --I84437

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


select count(*) from(Select SHIPMENT,DATE_22,DATE_25 from rms.nb_shipment_cfa_ext where trunc(DATE_25) like '21-NOV-19');

select count(1) from nb_shipment_cfa_ext where trunc(LAST_UPDATE_DATETIME) ='21-NOV-19';

Select SHIPMENT,DATE_22,DATE_25 from rms.nb_shipment_cfa_ext where trunc(DATE_25) like '21-NOV-19';

SELECT DISTINCT SH.ASN,SH.order_no,NBS.DATE_24 FC_BOOKING_DATE,NBS.VARCHAR2_1 FC_BOOKING_REF
FROM RMS.SHIPMENT SH, RMS.SHIPSKU SK, RMS.NB_SHIPMENT_CFA_EXT NBS, RMS.ORDHEAD OH
WHERE SH.SHIPMENT=SK.SHIPMENT
AND SK.SHIPMENT=NBS.SHIPMENT
AND SH.ORDER_NO=OH.ORDER_NO
AND NBS.GROUP_ID='1010100' 
AND SH.ASN='170015165155555';

select * from v$sql order by LAST_LOAD_TIME desc;


select  order_no,status from ordhead where order_no in (50000738238);
select  * from ordhead where order_no in (50000738238);
select * from ordloc where order_no in (50000738238);
select * from shipment where order_no in (50000738238);
select STATUS_CODE,count(1) from shipment where order_no in (50000738238) group by  STATUS_CODE;
select * from shipsku where shipment in (select shipment from shipment where order_no in (50000738238));
select * from shipsku_loc where shipment in (select shipment from shipment where order_no in (50000738238));
select * from RMS.NB_SHIPMENT_CFA_EXT where shipment in (select shipment from shipment where order_no in (50000738238));




Sql id: 3pts9xvchza1g
    select INT_CFAKeyDesc_TBL( INT_CFAKeyDesc_REC('SHIPMENT',NULL,SHIPMENT,NULL)) from SHIPMENT  where 1 = 1 and ASN = '5000103838855577';

Sql id: 562w8j23dz2x4
    SELECT * FROM NB_SHIPMENT_CFA_EXT WHERE 1=1 AND SHIPMENT=25285772 AND group_id IN (1010100) FOR UPDATE NOWAIT	

Sql id: f5r2674cwk45a
    merge into NB_SHIPMENT_CFA_EXT ext using (select 1010100 group_id, NULL varchar2_1, NULL varchar2_2, NULL varchar2_3, NULL varchar2_4, NULL varchar2_5, NULL varchar2_6, NULL varchar2_7, NULL varchar2_8, NULL varchar2_9, NULL varchar2_10, NULL number_11, NULL number_12, NULL number_13, NULL number_14, NULL number_15, NULL number_16, NULL number_17, NULL number_18, NULL number_19, NULL number_20, '20190127000000' date_21, '20191031000000' date_22, NULL date_23, NULL date_24, '20191121102356' date_25 from dual) tmp on (SHIPMENT = 25285772 and ext.group_id = tmp.group_id) when matched then update set ext.varchar2_1 = tmp.varchar2_1, ext.varchar2_2 = tmp.varchar2_2, ext.varchar2_3 = tmp.varchar2_3, ext.varchar2_4 = tmp.varchar2_4, ext.varchar2_5 = tmp.varchar2_5, ext.varchar2_6 = tmp.varchar2_6, ext.varchar2_7 = tmp.varchar2_7, ext.varchar2_8 = tmp.varchar2_8, ext.varchar2_9 = tmp.varchar2_9, ext.varchar2_10= tmp.varchar2_10, ext.number_11  = tmp.number_11, ext.number_12  = tmp.number_12, ext.number_13  = tmp.number_13, ext.number_14  = tmp.number_14, ext.number_15  = tmp.number_15, ext.number_16  = tmp.number_16, ext.number_17  = tmp.number_17, ext.number_18  = tmp.number_18, ext.number_19  = tmp.number_19, ext.number_20  = tmp.number_20, ext.date_21    = tmp.date_21, ext.date_22    = tmp.date_22, ext.date_23    = tmp.date_23, ext.date_24    = tmp.date_24, ext.date_25    = tmp.date_25 when not matched then insert (SHIPMENT, group_id, varchar2_1, varchar2_2, varchar2_3, varchar2_4, varchar2_5, varchar2_6, varchar2_7, varchar2_8, varchar2_9, varchar2_10,number_11, number_12, number_13, number_14, number_15, number_16, number_17, number_18, number_19, number_20, date_21, date_22, date_23, date_24, date_25)values(25285772, 1010100, tmp.varchar2_1, tmp.varchar2_2, tmp.varchar2_3, tmp.varchar2_4, tmp.varchar2_5, tmp.varchar2_6, tmp.varchar2_7, tmp.varchar2_8, tmp.varchar2_9, tmp.varchar2_10,tmp.number_11, tmp.number_12, tmp.number_13, tmp.number_14, tmp.number_15, tmp.number_16, tmp.number_17, tmp.number_18, tmp.number_19, tmp.number_20, tmp.date_21, tmp.date_22, tmp.date_23, tmp.date_24, tmp.date_25)	

Sql id: f2m6shgy7swm5
    select att.view_col_name, att.data_type, piv.attrib_value from cfa_ext_entity ext, cfa_attrib_group_set gst, cfa_attrib_group grp, cfa_attrib att, (select group_id, attrib_col, attrib_value from (select group_id, varchar2_1, varchar2_2, varchar2_3, varchar2_4, varchar2_5, varchar2_6, varchar2_7, varchar2_8, varchar2_9, varchar2_10, to_char(number_11) number_11, to_char(number_12) number_12, to_char(number_13) number_13, to_char(number_14) number_14, to_char(number_15) number_15, to_char(number_16) number_16, to_char(number_17) number_17, to_char(number_18) number_18, to_char(number_19) number_19, to_char(number_20) number_20, to_char(date_21, 'YYYYMMDDHH24MISS') date_21, to_char(date_22, 'YYYYMMDDHH24MISS') date_22, to_char(date_23, 'YYYYMMDDHH24MISS') date_23, to_char(date_24, 'YYYYMMDDHH24MISS') date_24, to_char(date_25, 'YYYYMMDDHH24MISS') date_25 from NB_SHIPMENT_CFA_EXT where SHIPMENT = 25286996 ) ext unpivot  (attrib_value for attrib_col in (varchar2_1  as 'VARCHAR2_1', varchar2_2  as 'VARCHAR2_2', varchar2_3  as 'VARCHAR2_3', varchar2_4  as 'VARCHAR2_4', varchar2_5  as 'VARCHAR2_5', varchar2_6  as 'VARCHAR2_6', varchar2_7  as 'VARCHAR2_7', varchar2_8  as 'VARCHAR2_8', varchar2_9  as 'VARCHAR2_9', varchar2_10 as 'VARCHAR2_10', number_11   as 'NUMBER_11', number_12   as 'NUMBER_12', number_13   as 'NUMBER_13', number_14   as 'NUMBER_14', number_15   as 'NUMBER_15', number_16   as 'NUMBER_16', number_17   as 'NUMBER_17', number_18   as 'NUMBER_18', number_19   as 'NUMBER_19', number_20   as 'NUMBER_20', date_21     as 'DATE_21', date_22     as 'DATE_22', date_23     as 'DATE_23', date_24     as 'DATE_24', date_25     as 'DATE_25'))) piv where ext.base_rms_table   = 'SHIPMENT'and ext.ext_entity_id    = gst.ext_entity_id and gst.group_set_id     = NVL(1010001,gst.group_set_id) and gst.group_set_id     = grp.group_set_id and ((gst.active_ind      = 'Y' and grp.active_ind      = 'Y' and att.active_ind      = 'Y') or 'N'= 'Y') and att.group_id         = grp.group_id and piv.attrib_col(+)    = att.storage_col_name and piv.group_id(+)      = att.group_id order by att.group_id ;
    

select count(*) from v$sql where executions=1;

select * from v$sql where executions=1;

select * from (select sql_id,max(child_number) from v$sql group by sql_id order by 2 desc); where rownum <= 10;


SELECT first_load_time, sql_text 
   FROM v$sql 
  WHERE first_load_time > to_char(sysdate-1/(24*6), 'YYYY-MM-DD/HH24:MI:SS');