select ADJ_DATE,count(1) from inv_adj group by ADJ_DATE order by 1;

   select * FROM int_asos.INT_ITEM_GROUP_EVENT_DNLD_STG;

   delete FROM int_asos.INT_ITEM_GROUP_EVENT_DNLD_STG;

   select * FROM int_asos.INT_ITEM_GROUP_EVENT_DNLD_STG
        WHERE BASE_EXTRACTED_IND = 'Y'
        AND TRANSACTION_DATETIME < GET_VDATE - 30;
        
set serveroutput on;
set timing on; 

BEGIN
 for k in 2..7 loop
INSERT INTO  int_asos.INT_ITEM_GROUP_EVENT_DNLD_STG(SEQ_NO,
     GROUP_TYPE_ID,
     GROUP_ID,
     ITEM,
     ACTION_TYPE,
     BASE_EXTRACTED_IND,    
     TRANSACTION_DATETIME)
    select int_asos.INT_ITEM_GROUP_EVENT_SEQ.NEXTVAL as SEQ_NO,
             mgt.GROUP_TYPE_ID as GROUP_TYPE_ID,
             mgh.GROUP_ID as GROUP_ID,
             im.item as ITEM,
            'GroupDetailCre' as ACTION_TYPE,        
             'Y' AS BASE_EXTRACTED_IND,         
             (select vdate-k from period) AS TRANSACTION_DATETIME
    from ma_asos.MA_GROUP_TYPE mgt,
        ma_asos.MA_GROUP_HEADER mgh,
        ma_asos.MA_GROUP_DETAIL im where rownum<=7000; 

end loop;
commit;

exception	
when others then

    dbms_output.put_line('Exception blcok'||TO_CHAR(SQLCODE)||SQLERRM);
      ROLLBACK;
end;
/



exec system.killsession ('1665');