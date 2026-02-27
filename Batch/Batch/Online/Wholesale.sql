
IWTDESPATCH.RC13.FC01.20240603010101001

{
  "metadata": {
    "EventName": "IwtDespatchPublished",
    "eventClassification": "FilePublication",
    "entity": "ITL",
    "eventCreatedDateTime": "2022-01-03T12:00:00Z",
    "dataSchemaVersion": 1
  },
  "data": {
    "path": "IWTDESPATCH.RC13.FC01.20240603010101001.XML",
    "fileName": "IWTDESPATCH.RC13.FC01.20240603010101001.XML",
    "blobUri": "https://asbamintstgeuwvpt01.blob.core.windows.net/bam098-iwt-despatch-vpt/IWTDespatch/IWTDESPATCH.RC13.FC01.20240603010101001.XML?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2024-06-29T23:05:59Z&st=2024-05-31T15:05:59Z&spr=https&sig=6YgxrNMrcBHLK8otfw3P314%2Bm8RjHjPe5eRkS1SJ3E8%3D",
    "source": "RC13"
  }
}


Pranav@2024$

select * from code_detail where code_type = 'WFOH';
update code_detail set code_desc='Company' where code_type='WFOH' and code='C';
update code_detail set code_desc='Franchise' where code_type='WFOH' and code='F';

select * from store;

--CREATE STORES 25,72,26,27,69,73,70,71,66,67,68,46,29,13,45,22,47,65,74,75
--######USE FRONT END UI######
--###### See 'Wholesale_Portal_Data_Creation_VPT.docx' Section 1.6######

select * from RMS.WF_CUSTOMER_GROUP;
select * from RMS.WF_CUSTOMER;


select * from  CODE_DETAIL where CODE_TYPE like 'WFCO';
select * from  all_tables where table_name like '%REASON_%'; REQ_IND, THRESHOLD_PERCENT, PARTNER_ORDER_IND, DELIVERY_TYPE) values (1701, 'Y', 'N', 5, 'Y','C');
insert into wholesale.wp_customer_attrib (CUSTOMER_ID, HOLD_IND, PARTNER_ST_REQ_IND, THRESHOLD_PERCENT, PARTNER_ORDER_IND, DELIVERY_TYPE) values (1702, 'Y', 'N', 5, 'Y','C');
insert into wholesale.wp_customer_attrib (CUSTOMER_ID, HOLD_IND, PARTNER_ST_REQ_IND, THRESHOLD_PERCENT, PARTNER_ORDER_IND, DELIVERY_TYPE) values (1703, 'Y', 'N', 5, 'Y','C');

select * from wholesale.wp_customer_dc_st_link; --wp_order_detail

--AS WHOLESALE USER INSERT ADDITIONAL PARTNER & PARTNER GROUP ATTRIBUTES INTO WP_CUSTOMER_DC_ST_LINK


insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30025,'569','Nords DIR EC','568','Nords DIR EC');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30072,'599','Nords DIR WC','808','Nords DIR WC');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30026,'299','Nords FLS','ALL FLS','Nords FLS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30027,'89','Nords WHSE Portland, OR','189','Nords WHSE Portland, OR - RS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30027,'499','Nords WHSE Newark, CA','188','Nords WHSE Newark, CA - RS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30027,'699','Nords WHSE Upper Marlboro, MD','169','Nords WHSE Upper Marlboro, MD - RS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30069,'562','Nords Rack DIR EC','881','Nords Rack DIR EC');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30073,'879','Nords Rack DIR WC','873','Nords Rack DIR WC');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30070,'299','Nords FLS','ALL FLS','Nords FLS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30070,'699','Nords WHSE Upper Marlboro, MD','ALL FLS','Nords FLS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30071,'89','Nords WHSE Portland, OR','179','Nords WHSE Portland, OR - Rack RS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30071,'499','Nords WHSE Newark, CA','178','Nords WHSE Newark, CA - Rack RS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30071,'699','Nords WHSE Upper Marlboro, MD','177','Nords WHSE Upper Marlboro, MD - Rack RS');
insert into wholesale.wp_customer_dc_st_link (CUSTOMER_LOC, PARTNER_DC_ID, PARTNER_DC_DESC, PARTNER_STORE_ID, PARTNER_STORE_DESC) values (30071,'699','Nords WHSE Upper Marlboro, MD','697','Nords WHSE Upper Marlboro, MD - Rack P'||'&'||'H');


--AS RMS USER EXECUTE REQUIRED MATRICES INTO MA_ASOS 
--It is to be confirmed with the ASOS core team (Sue Leach at the moment) on which vwh’s need to be considered for this
--The below statements need to be run where ‘XXXX’ is replaced by the required vwh id
--For VPT we need 3002, 1002, 5002.

select * from ma_asos.ma_transit_matrix where RECEIVING_POINT in (select VALUE_1 from rms.NB_SYSTEM_PARAMETERS where func_area = 'BUY_VALUE');

INSERT INTO ma_asos.ma_transit_matrix (select shipping_point,  "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, XXXX "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select XXXX "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 1001);

commit;



select * from WH where wh in (select VALUE_1 from rms.NB_SYSTEM_PARAMETERS where func_area = 'BUY_VALUE');


select distinct RECEIVING_POINT from ma_asos.ma_transit_matrix where RECEIVING_POINT in (select VALUE_1 from rms.NB_SYSTEM_PARAMETERS where func_area = 'BUY_VALUE');

INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 1002 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 3002 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 3001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 4002 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 4001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 5002 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 5001 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 6001 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 6002 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 8001 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 3001);
INSERT INTO ma_asos.ma_transit_matrix (select shipping_point, 8002 "receiving_point", shipping_method, freight_forwarder, cy_cut_off, vessel_departure, origin_dwell, total_days from ma_asos.ma_transit_matrix where receiving_point = 3001);



INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 1002 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 3002 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 3001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 4002 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 4001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 5001 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 6001 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 6002 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 1001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 8001 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 3001);
INSERT INTO ma_asos.ma_freight_matrix (select shipping_point, 8002 "receiving_point", delivery_method, freight_forwarder, carton_fill_rate, cost_component, currency from ma_asos.ma_freight_matrix where receiving_point = 3001);

select * from ma_asos.ma_hndlcost_matrix;
INSERT INTO ma_asos.ma_hndlcost_matrix (select 1002 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 1001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 3002 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 3001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 4002 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 4001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 5002 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 1001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 5001 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 1001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 6001 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 1001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 6002 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 1001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 8001 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 3001);
INSERT INTO ma_asos.ma_hndlcost_matrix (select 8002 "warehouse", rate, cost_component, currency from ma_asos.ma_hndlcost_matrix where warehouse = 3001);
commit;





drop table GL_CROSS_REF_UNMASKING_LOCATIONS;

CREATE TABLE "FIF_GL_CROSS_REF_AUX_V2" 
AS (SELECT * FROM FIF_GL_CROSS_REF WHERE 1 = 0);

CREATE TABLE "SA_FIF_GL_CROSS_REF_AUX" 
AS (SELECT * FROM SA_FIF_GL_CROSS_REF WHERE 1 = 0);

CREATE TABLE "GL_CROSS_REF_UNMASKING_LOCATIONS"
(RMS_ID           NUMBER,
 LOCATION_CODE    VARCHAR(25)
);


-- UK
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1001, 'LOC04');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1002, 'LOC26');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (6001, 'LOC22');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (6002, 'LOC33');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1014, 'LOC19');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1016, 'LOC34');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1015, 'LOC19');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1011, 'LOC05');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (5001, 'LOC29');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (5002, 'LOC32');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (1012, 'LOC21');
-- EU
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (4001, 'LOC07');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (4002, 'LOC25');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (4012, 'LOC16');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (10004, 'LOC07');
-- US
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (3001, 'LOC17');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (3002, 'LOC24');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (3003, 'LOC30');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (3004, 'LOC35');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (8001, 'LOC31');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (8002, 'LOC36');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (10033, 'LOC30');
insert into "GL_CROSS_REF_UNMASKING_LOCATIONS" (RMS_ID, LOCATION_CODE) values (10003, 'LOC17');


drop table GL_CROSS_REF_NEW_VIRTUAL_WH;
CREATE TABLE "GL_CROSS_REF_NEW_VIRTUAL_WH"
(NEW_LOCATION               NUMBER,
 NEW_LOC_CODE               VARCHAR2(25),
 COPY_LOCATION              NUMBER,
 COPY_LOC_CODE              VARCHAR2(25),
 COUNTRY                    VARCHAR2(2),
 DO_COPY_ALL                CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_1              CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_2              CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_3              CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_4              CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_5              CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_6              CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_7              CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_8              CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_9_TC_37        CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_9_TC_37_38     CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_10             CHAR(1) DEFAULT 'Y'
);

insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (1002, 'LOC26', 1001, 'LOC04', 'UK');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (6002, 'LOC33', 6001, 'LOC22', 'UK');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (1016, 'LOC34', 1014, 'LOC19', 'UK');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (5001, 'LOC29', 1001, 'LOC04', 'UK');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (5002, 'LOC32', 1001, 'LOC04', 'UK');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (4002, 'LOC25', 4001, 'LOC07', 'EU');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (3002, 'LOC24', 3001, 'LOC17', 'US');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (3003, 'LOC30', 3001, 'LOC17', 'US');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (3004, 'LOC35', 3001, 'LOC17', 'US');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (8001, 'LOC31', 3001, 'LOC17', 'US');
insert into "GL_CROSS_REF_NEW_VIRTUAL_WH" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, COPY_LOC_CODE, COUNTRY) values (8002, 'LOC36', 3001, 'LOC17', 'US');

drop table GL_CROSS_REF_STOCK_BUCKET_ADJ;
CREATE TABLE "GL_CROSS_REF_STOCK_BUCKET_ADJ"
(LOCATION       NUMBER,
 LOCATION_CODE  VARCHAR2(25),
 DO_COPY        CHAR(1) DEFAULT 'Y'
);



insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (1001, 'LOC04');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (1002, 'LOC26');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (6001, 'LOC22');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (6002, 'LOC33');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (1014, 'LOC19');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (1016, 'LOC34');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (5001, 'LOC29');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (5002, 'LOC32');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (4001, 'LOC07');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (4002, 'LOC25');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (3001, 'LOC17');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (3002, 'LOC24');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (3003, 'LOC30');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (3004, 'LOC35');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (8001, 'LOC31');
insert into "GL_CROSS_REF_STOCK_BUCKET_ADJ" (LOCATION, LOCATION_CODE) values (8002, 'LOC36');


drop table GL_CROSS_REF_NEW_SALES_STORES;
CREATE TABLE "GL_CROSS_REF_NEW_SALES_STORES"
(NEW_LOCATION           NUMBER,
 NEW_LOC_CODE           VARCHAR2(25),
 COPY_LOCATION          NUMBER,
 DO_COPY_FOR_EACH_FC    CHAR(1) DEFAULT 'Y',
 DO_COPY_FOR_FC_STORE   CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_1          CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_2          CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_3          CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_4          CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_5          CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_6          CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_7          CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_8          CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_9          CHAR(1) DEFAULT 'Y',      
 DO_COPY_REQ_10         CHAR(1) DEFAULT 'Y' 
);

insert into "GL_CROSS_REF_NEW_SALES_STORES" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION) values (10033, 'LOC30', 10003);

drop table GL_CROSS_REF_NEW_PARTNER_STORES;
-- New Wholesale Stores / Partner Stores 
CREATE TABLE "GL_CROSS_REF_NEW_PARTNER_STORES"
(NEW_LOCATION       NUMBER,
 DO_COPY_ALL        CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_1      CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_2      CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_3      CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_4      CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_5_22   CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_5_44   CHAR(1) DEFAULT 'Y', 
 DO_COPY_REQ_6      CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_7      CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_8      CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_9      CHAR(1) DEFAULT 'Y',      
 DO_COPY_REQ_10     CHAR(1) DEFAULT 'Y' 
);

insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30025);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30069);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30070);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30071);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30072);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30073);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30026);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30027);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30066);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30067);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30068);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30029);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30013);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30022);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30045);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30046);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30047);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30065);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30074);
insert into "GL_CROSS_REF_NEW_PARTNER_STORES" (NEW_LOCATION) values (30075);

-- New physical FCs and RCs (For ReSA requirements but used in RMS_007_FC_STORES too)
drop table GL_CROSS_REF_NEW_FC_AND_RC;
CREATE TABLE "GL_CROSS_REF_NEW_FC_AND_RC"
(NEW_LOCATION       NUMBER,
 NEW_LOC_CODE       VARCHAR2(25),
 COPY_LOCATION      NUMBER,
 FC_OR_RC_CODE      NUMBER,
 TYPE_LOCATION      VARCHAR(5),
 DO_COPY_REQ_4      CHAR(1) DEFAULT 'Y',  
 DO_COPY_REQ_5      CHAR(1) DEFAULT 'Y',
 DO_COPY_REQ_7      CHAR(1) DEFAULT 'Y'
);

insert into "GL_CROSS_REF_NEW_FC_AND_RC" (NEW_LOCATION, NEW_LOC_CODE, COPY_LOCATION, FC_OR_RC_CODE, TYPE_LOCATION) values (10033, 'LOC30', 10003, 17, 'FC');


select * from das.store;
select * from wholesale.WP_SKU_INT_SIZES;
select * from wholesale.WP_SKU_INT_SIZES;


insert into wholesale.WP_SKU_INT_SIZES 
select item,DIFF_2,'EU'||DIFF_2,'US'||DIFF_2,user,sysdate,user,sysdate from das.item_master where item_level = tran_level 
    and item_parent in ('129234623'); 

SELECT * FROM das.ITEM_MASTER WHERE ITEM_PARENT = '129234623' AND STATUS = 'A';


SELECT * FROM das.ITEM_MASTER;


select * from wholesale.WP_SO_FILE_UPLD order by 3 desc;
select * from wholesale.WP_SO_IMPORT_STG where batch_seq_no = '20230728092920';
select * from wholesale.WP_SO_IMPORT_ARCH where batch_seq_no = '20230728092920';

select INT_STATUS, INT_ERROR_MSG,count(1) from wholesale.WP_SO_IMPORT_ARCH where batch_seq_no = '20230208091607' group by INT_STATUS, INT_ERROR_MSG;

select * from wholesale.WP_SO_IMPORT_ARCH where INT_STATUS = 'E' and int_error_msg like 'ORA-01403%' and batch_seq_no = '20230208091607';
select * from wholesale.WP_SO_IMPORT_ARCH where order_row_code = '#7CHOW6';
select * from rms.ordhead_cfa_ext;



select s.begin_interval_time, sql.sql_id as sql_id, sql.EXECUTIONS_TOTAL 
from dba_hist_sqlstat sql, dba_hist_snapshot s
where sql_id in ('gyxdxnk1aavbf')
and s.snap_id = SQL.snap_id
and s.begin_interval_time >= TO_date('17-feb-2023 11:00', 'dd-mon-yyyy hh24:mi')
and s.begin_interval_time <= TO_date('17-feb-2023 11:50', 'dd-mon-yyyy hh24:mi') order by s.begin_interval_time;


select * from all_views where view_name like 'WP_V_R_SALES_ORDER_RELEASE';

select * from WHOLESALE.WP_V_R_SALES_ORDER_RELEASE;
select count(1) from WHOLESALE.WP_V_R_UNPRODUCTIVE_STOCK;




select * from wholesale.WP_SYSTEM_PARAMETERS;

select * from wholesale.WP_SYSTEM_PARAMETERS where func_area = 'VIRTUAL_WH';
Insert into wholesale.WP_SYSTEM_PARAMETERS (FUNC_AREA,PARAMETER,DESCRIPTION,VALUE_1,VALUE_2,VALUE_3,VALUE_4,LAST_UPDATE_ID,LAST_UPDATE_DATE) values ('VIRTUAL_WH','WH_DEFAULT_DAYS','Default number of processing days for Sales Order in each ASOS wholesale virtual warehouse','6002','21',null,null,'WHOLESALE',sysdate);
Insert into wholesale.WP_SYSTEM_PARAMETERS (FUNC_AREA,PARAMETER,DESCRIPTION,VALUE_1,VALUE_2,VALUE_3,VALUE_4,LAST_UPDATE_ID,LAST_UPDATE_DATE) values ('VIRTUAL_WH','WH_DEFAULT_DAYS','Default number of processing days for Sales Order in each ASOS wholesale virtual warehouse','4002','21',null,null,'WHOLESALE',sysdate);
Insert into wholesale.WP_SYSTEM_PARAMETERS (FUNC_AREA,PARAMETER,DESCRIPTION,VALUE_1,VALUE_2,VALUE_3,VALUE_4,LAST_UPDATE_ID,LAST_UPDATE_DATE) values ('VIRTUAL_WH','WH_DEFAULT_DAYS','Default number of processing days for Sales Order in each ASOS wholesale virtual warehouse','1016','21',null,null,'WHOLESALE',sysdate);
Insert into wholesale.WP_SYSTEM_PARAMETERS (FUNC_AREA,PARAMETER,DESCRIPTION,VALUE_1,VALUE_2,VALUE_3,VALUE_4,LAST_UPDATE_ID,LAST_UPDATE_DATE) values ('VIRTUAL_WH','WH_DEFAULT_DAYS','Default number of processing days for Sales Order in each ASOS wholesale virtual warehouse','3004','21',null,null,'WHOLESALE',sysdate);





select * from das.item_loc_soh where item_parent = '129358363';



select * from wholesale.wp_order_head where sales_order_no = '3907';
select * from wholesale.wp_order_detail where sales_order_no = '3907';
select * from wholesale.wp_customer_dc_st_link; --wp_order_detail

-Sales Order 3907 – Missing mandatory Partner DC No. or Partner Store No.




select * from wholesale.wp_errors where text like '%MISS_PARTNER_STORE%';

select * from dba_source where text like '%MISS_PARTNER_STORE%';


PBI: 
Test Execution Hours: 
Defects Open/Closed: 
Business engagements/Initiatives:


Patch validation tests completed – Batch, Microapps, ASOS Net, Dashboards, Wholesale.
3 Production incidents were reviewed & few tests planned for PO bulk cancel .
29 Open defects, agreeing for resolution process.
Purging/archiving of table vol growth, New epic raised, SA's planning for new framework within T&R.



