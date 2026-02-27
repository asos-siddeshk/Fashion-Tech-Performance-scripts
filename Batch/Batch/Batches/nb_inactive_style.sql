/*
---------------------------Batch name:RMS.NB_INACTIVE_STYLES----------------------------------
1.Records to be updated in microapp tables									:ma_asos.ma_styles 
2.Batch execution 															:RMS.NB_INACTIVE_STYLES via Automic.
--------------------------------------------------------------------------------------------------

select distinct s.style
                        from ma_asos.ma_styles s,
                             (select item,
                                     uda_text as style
                                from uda_item_ff
                               where uda_id = (select uda_id
                                                 from ma_asos.ma_uda_conf
                                                where uda_type = 'STYLE')
                               union
                              select item,
                                     style
                                from ma_asos.ma_stg_item_head
                               where status = 'W') i
                       where s.style           = i.style
                         and s.create_datetime < add_months(sysdate, -12)
                         and not exists (select 1
                                           from rms.ordhead o,
                                                rms.ordsku os
                                          where o.order_no = os.order_no
                                            and os.item    = i.item
                                            and o.create_datetime > add_months(sysdate, -12));
											
*/


set serveroutput on;
set timing on;

DECLARE

begin

Update ma_asos.ma_styles st
set st.CREATE_DATETIME =add_months(st.CREATE_DATETIME,-25)--'17-APR-16' 
where st.style in (select distinct s.style
                        from ma_asos.ma_styles s,
                             ma_asos.ma_v_item_search i
                       where s.style    = i.style
                         and not exists (select 1
                                           from rms.ordhead o,
                                                rms.ordsku os
                                          where o.order_no = os.order_no
                                            and os.item    = i.item
                                            and o.create_datetime > add_months(sysdate, -12))
                     ) and rownum<=200; 
                     

exception	
when others then

    dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
end;
/

 -- Note: ma_asos.ma_v_item_search not having proper data thats why it failing.
*/

set serveroutput on;
set timing on;

DECLARE

begin

Update ma_asos.ma_styles 
    set CREATE_DATETIME =add_months(ma_asos.ma_styles.CREATE_DATETIME,-25)--'17-APR-16' 
		where style in (select distinct s.style
								from ma_asos.ma_styles s where rownum<=200);

commit;

exception	
when others then

    dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
end;
/		



