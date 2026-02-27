
set serveroutput on;
set timing on;
 
DECLARE 

I_MASTER_PO_NO     int_asos.INT_TCKT_DNLD_STAGE.MASTER_PO_NO%TYPE;
I_ORDER            int_asos.INT_TCKT_DNLD_STAGE.ORDER_NO%TYPE;
I_SUPPLIER         int_asos.INT_TCKT_DNLD_STAGE.SUPPLIER%TYPE := null;
O_ERROR_MESSAGE       VARCHAR2(32000):= null;


      CURSOR cur_ord IS  
      
     select order_no, master_po_no,SUPPLIER from rms.ordhead oh
        where oh.status ='A' and CREATE_DATETIME>= to_date('01-JAN-2021 13:30', 'DD-MON-YYYY hh24:mi') and rownum<='5000'
            and exists (select 1 from ordloc ol where ol.order_no = oh.order_no and CANCEL_CODE is null and rownum<='1')
                        ORDER BY master_po_no desc ;
       
 BEGIN           
    for i in cur_ord loop
            I_MASTER_PO_NO := i.MASTER_PO_NO;
            I_ORDER := i.order_no;
            I_SUPPLIER := i.SUPPLIER;
            

        if (int_asos.INT_PO_SEND_TCKT_REQ (I_ORDER,I_MASTER_PO_NO, I_SUPPLIER, O_ERROR_MESSAGE)=FALSE)

    then   dbms_output.put_line('Failed:  '||I_MASTER_PO_NO ||'-'|| O_error_message);
    else    dbms_output.put_line('Success: '||I_MASTER_PO_NO);
        end if;
end loop;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SUBSTR(SQLERRM, 1, 255));
END;
/

delete from int_asos.int_tckt_dnld_stage ;
select count(1) from int_asos.int_tckt_dnld_stage;

select * from ordloc where order_no in (select order_no from int_asos.int_tckt_dnld_stage) and CANCEL_DATE is not null;

 select order_no, master_po_no,SUPPLIER from rms.ordhead oh
        where oh.status ='A' and rownum<='2800'
and exists (select 1 from ordloc ol where ol.order_no = oh.order_no and CANCEL_CODE is null and rownum<='1')
            ORDER BY master_po_no desc ;
            
            select * from ordhead where order_no ='50000619617';
            select * from ordloc where order_no ='50000619617';
   
            
            
select * from ordhead where order_no in (select order_no from int_asos.int_tckt_dnld_stage) and status ='C';            
select * from ordloc where order_no in (select order_no from int_asos.int_tckt_dnld_stage);

select * from int_asos.int_tckt_dnld_stage where order_no ='50000943803';


select ORDER_NO, count(1) from check_num group by order_no;

delete from int_asos.int_tckt_dnld_stage where order_no in 
(select distinct ORDER_NO from check_num where order_no in (select order_no from ordhead where status!='A'));


drop table check_num;

create table check_num as
SELECT      th.ticket_type_id tkt_type_id,
             ol.item,
             sum(ROUND((1 + (NVL(TICKET_OVERAGE,0)/100)) * ol.qty_ordered)) qty,
             ol.loc_type,
             ol.location location,
             oh.order_no,
             th.sel_ind,
             OH.MASTER_PO_NO,
             GARMENT_LABEL_REQ_IND
       FROM   rms.sups s,
              rms.sups_cfa_ext cfa,
             rms.int_tckt_supp_xref xref,
              rms.ticket_type_head th,
              Ma_asos.ma_cfa_conf mc,
             (SELECT DISTINCT TICKET_SYSTEM,
                                MASTER_PO_NO,
                                SUPPLIER,
                                TICKET_OVERAGE,
                                GARMENT_LABEL_REQ_IND FROM rms.int_tckt_dnld_stage st, rms.code_detail cdt WHERE
                                cdt.code = st.TICKET_SYSTEM
                                AND upper(cdt.code_desc) = upper('LABELON'))  stg,
              rms.ordhead oh,
              rms.ordloc ol,
              rms.code_detail cdt
       WHERE  th.ticket_type_id = xref.ticket_type_id
              AND cfa.varchar2_1 = xref.ticket_system
              AND s.supplier = cfa.supplier
              AND cfa.group_id = mc.group_id
              AND stg.TICKET_SYSTEM = cdt.code
              AND cdt.code_desc = 'LABELON'
              AND cdt.code_type='TKTS'
              AND stg.TICKET_SYSTEM = XREF.TICKET_SYSTEM
              AND ol.order_no = oh.order_no
              AND oh.master_po_no = stg.master_po_no
              AND stg.supplier = s.supplier
              AND oh.status!='W'
              AND mc.cfa_type = 'TICKET_SYSTEM'
     GROUP BY
               th.ticket_type_id,
             ol.item,
             ol.loc_type,
             ol.location ,
             oh.order_no,
             th.sel_ind,
             OH.MASTER_PO_NO,
             GARMENT_LABEL_REQ_IND ORDER BY MASTER_PO_NO,ORDER_NO,ITEM ASC;
             
             
             
             
             select * from rms.alloc_chrg where ALLOC_NO in (select ALLOC_NO from rms.alloc_header where order_no in (select order_no from ordhead where MASTER_PO_NO in 
(select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A'));


select distinct a.comp_id,
             a.comp_currency
        from alloc_chrg a,
             elc_comp e
       where a.alloc_no    in (select ALLOC_NO from rms.alloc_header where order_no in (select order_no from ordhead where MASTER_PO_NO in 
(select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A'))
         and a.comp_id      = e.comp_id
         and e.up_chrg_type = 'E';
         
         select e.calc_basis,
             i.comp_rate,
             i.comp_currency,
             i.per_count,
             i.per_count_uom
        from elc_comp e,
             item_chrg_detail i
       where i.item     = I_item
         and i.from_loc = I_from_loc
         and i.to_loc   = I_to_loc
         and i.comp_id  = I_comp_id
         and i.comp_id  = e.comp_id;
         
         
         select * from elc_comp where comp_id in ('TRSPRT','HNDLGUK'); --EA
         select * from alloc_chrg where PER_COUNT_UOM is not null;
         select * from alloc_chrg where PER_COUNT_UOM is not null and ALLOC_NO in (select ALLOC_NO from rms.alloc_header where order_no in (select order_no from ordhead where MASTER_PO_NO in 
(select DRIVER_VALUE from int_asos.INT_V_RESTART_ORDER where THREAD_VAL ='2') and status ='A'));
         
         create table alloc_chrg_null as
         select * from alloc_chrg where PER_COUNT_UOM is null;
         select * from alloc_chrg_null;
              select * from alloc_chrg where PER_COUNT_UOM is not null;
         Update alloc_chrg set PER_COUNT=1, PER_COUNT_UOM='EA' where PER_COUNT_UOM is  null;