select * from SUPP_ASOS.SC_SYSTEM_PARAMETERS  where FUNC_AREA='UPLD_ASN' and PARAMETER='THRESHOLD';

update SUPP_ASOS.SC_SYSTEM_PARAMETERS set VALUE_1= '1000' where FUNC_AREA='UPLD_ASN' and PARAMETER='THRESHOLD';


 select * from (select  * from ordhead oh where oh.status ='A' and oh.supplier = '1100000086' 
        and oh.CREATE_DATETIME >= to_date('29-NOV-2021 09:15', 'DD-MON-YYYY hh24:mi')
    and not exists (select 1 from shipment asp where  asp.order_no = oh.order_no)) ;


select * from ALL_TAB_COLUMNS where column_name like 'PARAMETER';

 select distinct mv.BUYING_GROUP,oh.order_no, vDate as ASN_Handover_Date from 
       ordhead oh, ordloc ol,  ma_asos.MA_V_BUYERARCHY mv, rms.PERIOD
     where oh.order_no (+) = ol.order_no
          and oh.order_no in ( select ORDER_NO from bulk_asn) 
          and ol.item = mv.item;

drop table bulk_asn;

truncate table bulk_asn;
create table bulk_asn as
 select * from (select ORDER_NO from ordhead oh where oh.status ='A' and oh.supplier = '1100000086' 
        and oh.CREATE_DATETIME >= to_date('29-NOV-2021 09:15', 'DD-MON-YYYY hh24:mi')
    and not exists (select 1 from shipment asp where  asp.order_no = oh.order_no)) ;

 select * from (select ORDER_NO from ordhead oh where oh.status ='A' and oh.supplier = '1100000086' 
        and oh.CREATE_DATETIME >= to_date('29-NOV-2021 09:00', 'DD-MON-YYYY hh24:mi')
    and not exists (select 1 from shipment asp where  asp.order_no = oh.order_no)); 


drop table goldseal2;
drop table orditemloc;
drop table orditemloc_d;

create table orditemloc as 
    select oh.order_no,od.item,od.location,oh.supplier 
        from ordloc od ,ordhead oh where oh.order_no = od.order_no and oh.status ='A'
         and oh.order_no in ( select ORDER_NO from bulk_asn) ;

create table orditemloc_d as 
 select oil.*,DIVISION, DEPT, CLASS, SUBCLASS from orditemloc oil, v_item_master im where oil.item= im.item;


create table goldseal2 as 
select distinct ITEM_parent as ITEM 
 from item_master im where item in (select distinct ITEM from orditemloc_d);

select * from all_views where OWNER like 'MA_ASOS';
select * from ma_asos.MA_V_BUYERARCHY;


drop table goldseal2;
create table goldseal2 (item varchar2(25));
select * from goldseal2;

select * from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where  ispg.status ='U';
select * from SKULIST_HEAD;

set serveroutput on;
set timing on;

DECLARE

COUNTER_COMMIT  NUMBER(10)     := 0;

l_ref_no          	number(10)    := null;
l_itemlist_desc   	varchar2(120) := null;
l_status 			varchar2(1)   := 'U';
l_skulist              number(8)  := null;   
i_filename          VARCHAR2(255) := null;   
l_ITEM             VARCHAR2(25);
l_date             date;

CURSOR c_itemlist is
     select * from ( select distinct gs.item  from goldseal2 gs where 
       not exists (select 1 from int_asos.INT_PL_ITEMLIST_UPLD_STG ispg where ispg.item = gs.item and ispg.status ='U')) ;
    
BEGIN
for m in 0..0 loop 

   select sysdate-m into l_date from dual;

   select RMS.LIST_SEQUENCE.nextval into l_REF_NO from dual;
   		l_itemlist_desc	:= 'ASNUPGoldSeal'||'-'||l_REF_NO;
		I_filename 		:= 'ASNUPGoldSeal'||'-'||l_REF_NO;

FOR i in c_itemlist Loop 
            l_item     :=i.item;

insert into int_asos.INT_PL_ITEMLIST_UPLD_STG (REF_NO,
											   itemlist_desc,
											   item,
											   status,
											   skulist,
											   filename,
											   create_datetime,
											   last_updatetime)
							values			 (l_REF_NO,
                                              l_itemlist_desc,
											   l_item,
											   'U',
											   l_skulist,
											   I_filename,
											   l_date,
											   l_date);

      dbms_output.put_line('1');

 END LOOP;
 END LOOP;

EXCEPTION

   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;

END;
/

