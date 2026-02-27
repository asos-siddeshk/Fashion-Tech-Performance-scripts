select * from rib_message order by 1 desc;
select * from rib_message_failure where message_num >= '65952330' order by 1 desc;


update rib_message set MAX_ATTEMPTS = '9' where message_num >= '65992059';
select * from shipment where order_no >500060600795;

select * from all_tables where table_name like  '%ALLOC%' and owner like 'RMS';

select * from NB_ALLOC_DETAIL_CFA_EXT where alloc_no in (select alloc_no from alloc_header where order_no in (select order_no from ordhead where order_no= '500060703683'));
select * from NB_ALLOC_HEADER_CFA_EXT where alloc_no in (select alloc_no from alloc_header where order_no in (select order_no from ordhead where order_no= '500060703683'));

select * from shipment where asn = '42153121422308';
select * from ordhead where order_no= '500060703683';
select * from alloc_header where order_no in (select order_no from ordhead where order_no= '500060703683');
select * from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from ordhead where order_no= '500060703683'));


select order_no from skumar.shipment_temp_5may;
select * from shipment where order_no >500060680169;


create table shipment_temp_5may as 
select SHIPMENT, ORDER_NO from shipment where order_no >500060680169;

drop table bam132_ship;
create table bam132_ship as 
select shipment from shipment where order_no in (select order_no from skumar.shipment_temp_5may)
union
select shipment from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from skumar.shipment_temp_5may));

select * from shipment where asn in ('42153121422313','42153121422315');
select * from ordloc where order_no in ('500060703690','500060703691');
select * from alloc_detail where alloc_no  in (select alloc_no  from alloc_header where order_no in ('500060703690','500060703691'));

drop table bam132_ship;

create table bam132_ship as 
select shipment from shipment where order_no in (select order_no from skumar.shipment_temp_5may)
union
select shipment from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from skumar.shipment_temp_5may));

create table bam132_ship as 
select shipment from shipment where order_no in ('500060703688')
union
select shipment from shipsku where distro_no in (select alloc_no from alloc_header where order_no in ('500060703688'));

select count(1) from alloc_header where order_no in (select order_no from skumar.shipment_temp_5may);
select count(1) from shipment where order_no in (select order_no from skumar.shipment_temp_5may);
select count(1) from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from skumar.shipment_temp_5may));
select count(shipment) from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from skumar.shipment_temp_5may));


select * from v_cfa_ship_dates_g where shipment in (select shipment from bam132_ship)order by 1;
select * from v_cfa_ship_dates_2_g where shipment in (select shipment from bam132_ship) order by 1;
select * from v_cfa_ship_dates_3_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_4_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_5_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_6_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_shipsku_distro_g where shipment in (select shipment from bam132_ship);
select * from  nb_shipment_cfa_ext where shipment in (select shipment from bam132_ship);
select * from  nb_shipsku_cfa_ext where shipment in (select shipment from bam132_ship);
select * from  shipsku where shipment in (select shipment from bam132_ship);

select * from rib_message where message_num >= '65952330' order by 1 desc;
select * from rib_message_failure where message_num > '65952330' order by 1 desc;

select * from v_cfa_ship_dates_3_g;

select * from shipment where asn = '42153121422308';
select * from ordhead where order_no= '500060703683';
select * from alloc_header where order_no in (select order_no from ordhead where order_no= '500060703683');
select * from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from ordhead where order_no= '500060703683'));

select * from shipsku where distro_no in (select alloc_no from alloc_header where order_no in (select order_no from ordhead where order_no >500060600795));
select * from all_views where lower(view_name) like 'v_cfa_ship_dates_3_g';;
              
drop table before_bam132;
create table before_bam132 as
select * from v_cfa_ship_dates_g where shipment in (select shipment from bam132_ship);

select * from before_bam132;

select * from v_cfa_ship_dates_g where shipment in (select shipment from bam132_ship);

select * from rib_message where message_num >= '65992058' order by 1 desc;
select * from rib_message_failure where message_num >= '65992058' order by 1 desc;

      select *
         from nb_iwt_milestone_xref
      where milestone_type = 'DATE';

select * from all_views where lower(view_name) like 'v_cfa_ship_dates_6_g';

select * from shipment where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_2_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_3_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_4_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_5_g where shipment in (select shipment from bam132_ship );
select * from v_cfa_ship_dates_6_g where shipment in (select shipment from bam132_ship );
select * from  nb_shipment_cfa_ext where shipment in (select shipment from bam132_ship);


select * from  nb_shipment_cfa_ext where shipment in (select shipment from shipment where order_no is not null);

insert into nb_shipment_cfa_ext
select shipment,1010200,VARCHAR2_1, VARCHAR2_2, VARCHAR2_3, VARCHAR2_4, VARCHAR2_5, VARCHAR2_6, VARCHAR2_7, VARCHAR2_8, VARCHAR2_9, VARCHAR2_10, NUMBER_11, NUMBER_12, NUMBER_13, NUMBER_14, NUMBER_15, NUMBER_16, NUMBER_17, NUMBER_18, NUMBER_19, NUMBER_20, '04-DEC-23' as DATE_21, DATE_22, DATE_23, DATE_24, DATE_25, sysdate, sysdate, 'USER' as CREATE_ID, 'USER' as LAST_UPDATE_ID
from nb_shipment_cfa_ext nsce where shipment in (select shipment from bam132_ship) and group_id = '1010100'
and not exists (select 1 from nb_shipment_cfa_ext nsc where nsc.shipment = nsce.shipment and group_id = '1010200');

insert into nb_shipment_cfa_ext
select shipment,1010300,VARCHAR2_1, VARCHAR2_2, VARCHAR2_3, VARCHAR2_4, VARCHAR2_5, VARCHAR2_6, VARCHAR2_7, VARCHAR2_8, VARCHAR2_9, VARCHAR2_10, NUMBER_11, NUMBER_12, NUMBER_13, NUMBER_14, NUMBER_15, NUMBER_16, NUMBER_17, NUMBER_18, NUMBER_19, NUMBER_20, null as DATE_21, DATE_22, DATE_23, DATE_24, DATE_25, sysdate, sysdate, 'USER' as CREATE_ID, 'USER' as LAST_UPDATE_ID
from nb_shipment_cfa_ext nsce where shipment in (select shipment from bam132_ship) and group_id = '1010100'
and not exists (select 1 from nb_shipment_cfa_ext nsc where nsc.shipment = nsce.shipment and group_id = '1010300');

insert into nb_shipment_cfa_ext
select shipment,1010400,VARCHAR2_1, VARCHAR2_2, VARCHAR2_3, VARCHAR2_4, VARCHAR2_5, VARCHAR2_6, VARCHAR2_7, VARCHAR2_8, VARCHAR2_9, VARCHAR2_10, NUMBER_11, NUMBER_12, NUMBER_13, NUMBER_14, NUMBER_15, NUMBER_16, NUMBER_17, NUMBER_18, NUMBER_19, NUMBER_20, null as DATE_21, DATE_22, DATE_23, DATE_24, DATE_25, sysdate, sysdate, 'USER' as CREATE_ID, 'USER' as LAST_UPDATE_ID
from nb_shipment_cfa_ext nsce where shipment in (select shipment from bam132_ship) and group_id = '1010100'
and not exists (select 1 from nb_shipment_cfa_ext nsc where nsc.shipment = nsce.shipment and group_id = '1010400');

insert into nb_shipment_cfa_ext
select shipment,1010500,VARCHAR2_1, VARCHAR2_2, VARCHAR2_3, VARCHAR2_4, VARCHAR2_5, VARCHAR2_6, VARCHAR2_7, VARCHAR2_8, VARCHAR2_9, VARCHAR2_10, NUMBER_11, NUMBER_12, NUMBER_13, NUMBER_14, NUMBER_15, NUMBER_16, NUMBER_17, NUMBER_18, NUMBER_19, NUMBER_20, null as DATE_21, '04-DEC-23' as DATE_22, '04-DEC-23' as DATE_23, DATE_24, '04-DEC-23' as DATE_25, sysdate, sysdate, 'USER' as CREATE_ID, 'USER' as LAST_UPDATE_ID
from nb_shipment_cfa_ext nsce where shipment in (select shipment from bam132_ship) and group_id = '1010100'
and not exists (select 1 from nb_shipment_cfa_ext nsc where nsc.shipment = nsce.shipment and group_id = '1010500');

insert into nb_shipment_cfa_ext
select shipment,1010600,VARCHAR2_1, VARCHAR2_2, VARCHAR2_3, VARCHAR2_4, VARCHAR2_5, VARCHAR2_6, VARCHAR2_7, VARCHAR2_8, VARCHAR2_9, VARCHAR2_10, NUMBER_11, NUMBER_12, NUMBER_13, NUMBER_14, NUMBER_15, NUMBER_16, NUMBER_17, NUMBER_18, NUMBER_19, NUMBER_20, null as DATE_21, DATE_22, DATE_23, DATE_24, DATE_25, sysdate, sysdate, 'USER' as CREATE_ID, 'USER' as LAST_UPDATE_ID
from nb_shipment_cfa_ext nsce where shipment in (select shipment from bam132_ship) and group_id = '1010100'
and not exists (select 1 from nb_shipment_cfa_ext nsc where nsc.shipment = nsce.shipment and group_id = '1010600');


select * from  nb_shipment_cfa_ext where shipment in (select shipment from bam132_ship);

select * from rib_message where message_num >= '65952330' order by 1 desc;
select * from rib_message_failure where message_num >= '65952330' order by 1 desc;

select asn_pub_method from SUPP_ASOS.sc_system_options;
select * from  supp_asos.SC_ASNIN_MILESTONES where asn in ('42153121411904');
select * from  supp_asos.rib_message where message_num > '5';
select * from  supp_asos.rib_message_failure where message_num > '5';
select * from supp_asos.shipment where asn in ('42153121411904');
select * from supp_asos.shipsku where shipment in (select shipment from supp_asos.shipment where asn in ('42153121411904'));
select * from supp_asos.nb_shipment_cfa_ext where shipment in (select shipment from supp_asos.shipment where asn in ('42153121411904'));

SELECT * FROM supp_asos.SC_ASNIN WHERE ASN_NBR = '42153121411904';
SELECT * FROM supp_asos.SC_ASNIN_ITEM WHERE ASN_NBR = '42153121411904';
SELECT * FROM supp_asos.sc_asnin_milestones  WHERE asn = '42153121422308';
SELECT * FROM supp_asos.SC_ASNIN_ITEM_BOOKED_QTY  WHERE asn = '42153121422308';
SELECT * FROM supp_asos.sc_asnin_milestones;

SELECT * FROM supp_asos.SC_ASNIN_MILESTONE_XREF;

