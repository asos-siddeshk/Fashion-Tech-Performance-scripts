DROP TABLE cust_tsf_upld;
create table cust_tsf_upld (item_id          varchar2(25),       
                            from_loc         number(10)  ,      
                            to_loc           number(10)  ,   
                            quantity         number(20,4),
                            error             varchar2(255));

select count(1) from cust_tsf_upld;
delete from cust_tsf_upld;
delete from int_asos.int_stg_man_tsf_upld;
select count(1) from int_asos.int_stg_man_tsf_upld ;
select * from int_asos.int_stg_man_tsf_upld where fileorder by 1 desc;

set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE varchar2(255) := NULL;
  O_AVAILABLE number(20,4) := NULL;
  l_ITEM rms.item_loc.item%type;
  l_LOC  rms.item_loc.item%type;
  l_LOC_TYPE varchar2(1):= 'W';
  v_Return  BOOLEAN;

  CURSOR C_ITEMLOC IS
    SELECT item,loc FROM ITEM_LOC_soh WHERE LOC_TYPE ='W' and loc ='4001' and stock_on_hand>='50' and rownum<='10000';
    
BEGIN

for i in C_ITEMLOC loop
 l_item := i.item;
 l_loc  := i.loc;
 
  v_Return := RMS.ITEMLOC_QUANTITY_SQL.GET_LOC_CURRENT_AVAIL(O_ERROR_MESSAGE => O_ERROR_MESSAGE,
                                O_AVAILABLE => O_AVAILABLE,
                                I_ITEM => l_ITEM,
                                I_LOC => l_LOC,
                                I_LOC_TYPE => l_LOC_TYPE);
	IF (v_Return) THEN 
		insert into cust_tsf_upld (item_id,from_loc,to_loc,quantity) values (l_item,l_loc,null,O_AVAILABLE);
	ELSE
		insert into cust_tsf_upld (item_id,from_loc,to_loc,error) values (l_item,l_loc,null,O_ERROR_MESSAGE);
	   END IF;

	end loop;

commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/

GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cust_tsf_upld TO RCHANDEL; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cust_tsf_upld TO SSHASTRY; 
GRANT SELECT,INSERT,UPDATE,DELETE ON SKUMAR.cust_tsf_upld TO rdatla; 

select ITEM_ID, FROM_LOC, 1001 as TO_LOC, 1  as QUANTITY from cust_tsf_upld where  rownum<=6000;
select * from wh;
select * from cust_tsf_upld where from_LOC ='4001' and QUANTITY >='3' and rownum<=6000;

select ITEM_ID as SKU,FROM_LOC ,  '1001' as TO_LOC,  1 as QUANTITY from skumar.cust_tsf_upld where FROM_LOC ='4001' and QUANTITY >='3' and rownum<=6000;

