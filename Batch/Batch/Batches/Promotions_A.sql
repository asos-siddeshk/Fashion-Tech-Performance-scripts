select zone_id,location,count(1) from ma_asos.ma_stage_simple_promo group by zone_id,location;
select status,count(1) from rpm_stage_simple_promo group by status;

update rpm_stage_simple_promo set status = 'W';

select ZONE_ID, STORE from ma_asos.ma_pricing_defaults ma;

select count(1) from rpm_promo_dtl where trunc(START_DATE) = '27-FEB-23' and state = '3'; --913086

select status,count(1) from rpm_stage_simple_promo group by status;


set serveroutput on;
set timing on;
 
DECLARE
 
   COUNTER         NUMBER(8)     := 0;
   COUNTER_COMMIT  NUMBER(8)     := 1000;
  i1 NUMBER := 10 ;  

 stage_COMMIT  NUMBER(8)     := 0; 
 
l_PROMO_ID                     			ma_asos.ma_stage_simple_promo.PROMO_ID%type;
l_PROMO_DISPLAY_ID                     	ma_asos.ma_stage_simple_promo.PROMO_DISPLAY_ID%type;
l_NAME                    				ma_asos.ma_stage_simple_promo.NAME%type;
l_PROMO_EVENT_ID                     	ma_asos.ma_stage_simple_promo.PROMO_EVENT_ID%type;
l_PROMO_START_DATE                     	ma_asos.ma_stage_simple_promo.PROMO_START_DATE%type;
l_PROMO_END_DATE                     	ma_asos.ma_stage_simple_promo.PROMO_END_DATE%type;
l_PROMO_COMP_ID                     	ma_asos.ma_stage_simple_promo.PROMO_COMP_ID%type;
l_COMP_DISPLAY_ID                     	ma_asos.ma_stage_simple_promo.COMP_DISPLAY_ID%type;
l_PROMO_DTL_ID                     		ma_asos.ma_stage_simple_promo.PROMO_DTL_ID%type;
l_PROMO_DTL_DISPLAY_ID                  ma_asos.ma_stage_simple_promo.PROMO_DTL_DISPLAY_ID%type;
l_APPLY_TO_CODE                     	ma_asos.ma_stage_simple_promo.APPLY_TO_CODE%type;
l_DTL_START_DATE                     	ma_asos.ma_stage_simple_promo.DTL_START_DATE%type;
l_DTL_END_DATE                     		ma_asos.ma_stage_simple_promo.DTL_END_DATE%type;
l_ITEM                     				ma_asos.ma_stage_simple_promo.ITEM%type;
l_ZONE_NODE_TYPE                     	ma_asos.ma_stage_simple_promo.ZONE_NODE_TYPE%type;
l_ZONE_ID                     			ma_asos.ma_stage_simple_promo.ZONE_ID%type;
MA_ZONE_ID                     			ma_asos.ma_stage_simple_promo.ZONE_ID%type;
MA_store                     			ma_asos.ma_stage_simple_promo.location%type;
l_LOCATION                     			ma_asos.ma_stage_simple_promo.LOCATION%type;
l_CHANGE_TYPE                     		ma_asos.ma_stage_simple_promo.CHANGE_TYPE%type;
l_CHANGE_PERCENT                    	ma_asos.ma_stage_simple_promo.CHANGE_PERCENT%type;
l_CHANGE_AMOUNT                     	ma_asos.ma_stage_simple_promo.CHANGE_AMOUNT%type;
l_CURRENCY_CODE                     	ma_asos.ma_stage_simple_promo.CURRENCY_CODE%type;
l_CHANGE_SELLING_UOM                    ma_asos.ma_stage_simple_promo.CHANGE_SELLING_UOM%type;
l_sp_stage_id                           ma_asos.ma_stage_simple_promo.STAGE_SIMPLE_PROMO_ID%type;
 
   
 cursor cur_dept is
		   select ma.ZONE_ID,ma.store from ma_asos.ma_pricing_defaults ma;
           
 cursor c_get_cuitem_sp (l_zone_id rms.rpm_stage_simple_promo.zone_id%type,l_location rms.rpm_stage_simple_promo.location%type) is
			 select rp.PROMO_ID, rp.PROMO_DISPLAY_ID, rp.NAME as promo_name,rp.PROMO_EVENT_ID, rp.START_DATE as PROMO_START_DATE, rp.END_DATE as PROMO_END_DATE, rpc.PROMO_COMP_ID, rpc.COMP_DISPLAY_ID
				   ,rpd.PROMO_DTL_ID, rpd.PROMO_DTL_DISPLAY_ID, rpd.APPLY_TO_CODE, rpd.START_DATE as DTL_START_DATE, rpd.END_DATE as DTL_END_DATE
				   ,rpdmn.ITEM,rpzl.ZONE_NODE_TYPE, rpzl.ZONE_ID, rpzl.LOCATION,rpddl.CHANGE_TYPE, rpddl.CHANGE_PERCENT, rpddl.CHANGE_AMOUNT, rp.CURRENCY_CODE as CURRENCY_CODE, rpddl.CHANGE_SELLING_UOM
			  from rpm_promo rp, rpm_promo_comp rpc, rpm_promo_dtl rpd, rpm_promo_dtl_merch_node rpdmn, rpm_promo_zone_location rpzl, 
					RPM_PROMO_DTL_LIST rpdl,RPM_PROMO_DTL_LIST_GRP rpdlg,  RPM_PROMO_DTL_DISC_LADDER rpddl
			 where rp.promo_id = rpc.promo_id
			   and rpc.PROMO_COMP_ID =rpd.PROMO_COMP_ID
			   and rpd.STATE ='3'
			   and rpd.PROMO_DTL_ID = rpdmn.PROMO_DTL_ID
			and rpd.PROMO_DTL_ID = rpzl.PROMO_DTL_ID
            and (rpzl.ZONE_ID = l_zone_id or rpzl.LOCATION = l_location)
			and rpdlg.PROMO_DTL_ID = rpd.PROMO_DTL_ID
            and trunc(rp.START_DATE) = '27-FEB-2023'
			and rpdl.promo_dtl_list_grp_id = rpdlg.promo_dtl_list_grp_id
			and rpddl.promo_dtl_list_id = rpdl.promo_dtl_list_id 
            and not exists  (select 1 from ma_asos.ma_stage_simple_promo ms where ms.PROMO_COMP_ID=rpc.PROMO_COMP_ID)
            and rownum <= '5000'
            order by PROMO_START_DATE;
	  
BEGIN

for k in cur_dept loop
	     ma_zone_id := k.zone_id;
         ma_store:= k.store;

FOR cust_ma in c_get_cuitem_sp(ma_zone_id,ma_store) Loop
            EXIT WHEN c_get_cuitem_sp%NOTFOUND;

				l_PROMO_ID                    	:=		cust_ma.PROMO_ID;
				l_PROMO_DISPLAY_ID              :=		cust_ma.PROMO_DISPLAY_ID;
				l_NAME                     		:=		cust_ma.promo_name;
				l_PROMO_EVENT_ID                :=		cust_ma.PROMO_EVENT_ID;
				l_PROMO_START_DATE              :=		cust_ma.PROMO_START_DATE;
				l_PROMO_END_DATE                :=		cust_ma.PROMO_END_DATE;
				l_PROMO_COMP_ID                 :=		cust_ma.PROMO_COMP_ID;
				l_COMP_DISPLAY_ID               :=		cust_ma.COMP_DISPLAY_ID;
				l_PROMO_DTL_ID                  :=		cust_ma.PROMO_DTL_ID;
				l_PROMO_DTL_DISPLAY_ID          :=		cust_ma.PROMO_DTL_DISPLAY_ID;
				l_APPLY_TO_CODE                 :=		cust_ma.APPLY_TO_CODE;
				l_DTL_START_DATE                :=		cust_ma.DTL_START_DATE;
				l_DTL_END_DATE                  :=		cust_ma.DTL_END_DATE;
				l_ITEM                     		:=		cust_ma.ITEM;
				l_ZONE_NODE_TYPE                :=		cust_ma.ZONE_NODE_TYPE;
				l_ZONE_ID                     	:=		cust_ma.ZONE_ID;
				l_LOCATION                     	:=		cust_ma.LOCATION;
				l_CHANGE_TYPE                   :=		cust_ma.CHANGE_TYPE;
				l_CHANGE_PERCENT                :=		cust_ma.CHANGE_PERCENT;
				l_CHANGE_AMOUNT                 :=		cust_ma.CHANGE_AMOUNT;
				l_CURRENCY_CODE                 :=		cust_ma.CURRENCY_CODE;
				l_CHANGE_SELLING_UOM            :=		cust_ma.CHANGE_SELLING_UOM;
              
         select ma_asos.MA_STAGE_RPM_PROMO_ID_SEQ.nextval into l_sp_stage_id from dual;
         
          insert into ma_asos.ma_stage_simple_promo (PROMO_ID
													, PROMO_DISPLAY_ID
													, NAME
													, PROMO_EVENT_ID
													, PROMO_START_DATE
													, PROMO_END_DATE
													, PROMO_COMP_ID
													, COMP_DISPLAY_ID
													, PROMO_DTL_ID
													, PROMO_DTL_DISPLAY_ID
													, APPLY_TO_CODE
													, DTL_START_DATE
													, DTL_END_DATE
													, ITEM
													, ZONE_NODE_TYPE
													, ZONE_ID
													, LOCATION
													, CHANGE_TYPE
													, CHANGE_PERCENT
													, CHANGE_AMOUNT
													, CURRENCY_CODE
													, CHANGE_SELLING_UOM
                                                    , STAGE_SIMPLE_PROMO_ID
                                                    , MESSAGE_SEQ
                                                    , MESSAGE_TYPE
                                                    , MERCH_TYPE
                                                    , IGNORE_CONSTRAINTS
                                                    , AUTO_APPROVE_IND
                                                    , STATUS
                                                    , TIMEBASED_DTL_IND
                                                    , VENDOR_FUNDED_IND
                                                    , CREATE_DATETIME
                                                    , LAST_UPDATE_DATETIME
                                                    , CREATE_ID
                                                    , LAST_UPDATE_ID)

											values ( l_PROMO_ID 
													, l_PROMO_DISPLAY_ID 
													, l_NAME 
													, l_PROMO_EVENT_ID 
													, l_PROMO_START_DATE 
													, l_PROMO_END_DATE 
													, l_PROMO_COMP_ID 
													, l_COMP_DISPLAY_ID 
													, l_PROMO_DTL_ID 
													, l_PROMO_DTL_DISPLAY_ID 
													, l_APPLY_TO_CODE 
													, l_DTL_START_DATE 
													, l_DTL_END_DATE 
													, l_ITEM 
													, l_ZONE_NODE_TYPE 
													, l_ZONE_ID 
													, l_LOCATION 
													, l_CHANGE_TYPE 
                                                    , l_CHANGE_PERCENT
													, l_CHANGE_AMOUNT 
													, l_CURRENCY_CODE 
													, l_CHANGE_SELLING_UOM
                                                    , l_sp_stage_id
                                                    , 1
                                                    , 'W'
                                                    , '0'
                                                    , 1
                                                    , 1
                                                    , 'N'
                                                    , 1
                                                    , 0
                                                    , sysdate
                                                    , sysdate
                                                    , 'PTUSER'
                                                    , 'PTUSER');
        
        END LOOP;
        END LOOP;   
commit;

EXCEPTION
    when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK; 
END;
/