drop table approvd_clr;
create table approvd_clr as
select  CLEARANCE_ID, state        
    from rms.rpm_clearance rpc 
         where state ='pricechange.state.approved' and trunc(EFFECTIVE_DATE) > '23-DEC-18' 
    and zone_node_type ='0' and skulist is null;
    
    select state,count(1) from rpm_clearance where clearance_id in (select clearance_id from approvd_clr ) group by state;
    select status,count(1) from rpm_stage_clearance where clearance_id in (select clearance_id from approvd_clr ) group by status;
    delete from rpm_stage_clearance;
    
    select CLEARANCE_ID, CLEARANCE_DISPLAY_ID, ITEM, ZONE_ID, ZONE_NODE_TYPE, EFFECTIVE_DATE, OUT_OF_STOCK_DATE, RESET_DATE, CHANGE_TYPE, CHANGE_AMOUNT from  rpm_stage_clearance;
  
    insert into rpm_stage_clearance 
    (stage_clearance_id,CLEARANCE_ID, CLEARANCE_DISPLAY_ID, ITEM, ZONE_ID, ZONE_NODE_TYPE, EFFECTIVE_DATE, OUT_OF_STOCK_DATE, 
    RESET_DATE, CHANGE_TYPE, CHANGE_AMOUNT,AUTO_APPROVE_IND,status)
    select CLEARANCE_ID as stage_clearance_id ,
            CLEARANCE_ID, 
            CLEARANCE_DISPLAY_ID,
            ITEM, 
            zone_id, 
            zone_node_type,
            EFFECTIVE_DATE, 
            OUT_OF_STOCK_DATE, 
            RESET_DATE, 
            CHANGE_TYPE, 
            CHANGE_AMOUNT,1,'A'              
    from rms.rpm_clearance rpc     
     where state ='pricechange.state.approved' and trunc(EFFECTIVE_DATE) > '23-DEC-18' 
    and zone_node_type ='1' and skulist is null;
    
    
    
    
    
    
    select count(sh.SKULIST) from rms.skulist_head sh where sh.sKULIST_DESC like '10Clearance%'
                and not exists (select 1 from skumar.ma_stage_clearance_bk mpc where mpc.SKULIST = sh.SKULIST);
        
    
    
select * from rpm_clearance where clearance_id ='30990611';
select status,count(1) from rpm_stage_clearance group by status;
    
select EFFECTIVE_DATE,count(1) from ma_asos.ma_stage_clearance where status ='N'  group by EFFECTIVE_DATE order by 1;  
select  STATUS,count(1) from rms.rpm_stage_clearance group by STATUS;
select EFFECTIVE_DATE,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '24-DEC-18' and '20-JAN-19'  and state ='pricechange.state.approved' group by EFFECTIVE_DATE order by 1; -- 5008
select state,count(1) from rms.rpm_clearance where EFFECTIVE_DATE between '24-DEC-18' and '20-JAN-19' group by state; -- 5008

select clearance_id from rpm_stage_clearance ;

select clearance_id from rms.rpm_clearance where 
        clearance_id in (select  clearance_id from rms.rpm_stage_clearance) and state ='pricechange.state.worksheet';

select * from rpm_con_check_err where REF_ID ='30990611';
select * from rpm_con_check_err_detail where CON_CHECK_ERR_ID in (select CON_CHECK_ERR_ID from rpm_con_check_err where REF_ID ='30990611');

select skulist,zone_id from rpm_clearance where clearance_id ='29561537';
select skulist,zone_id from rpm_clearance where clearance_id ='30990611';

select * from rpm_clearance;