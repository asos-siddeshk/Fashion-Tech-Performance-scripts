select count(1) from cust_tsf_upld;
select FROM_LOC,count(1) from cust_tsf_upld group by FROM_LOC;
select * from cust_tsf_upld;

delete from cust_tsf_upld;


set SERVEROUTPUT ON;
set timing ON;
DECLARE
  O_ERROR_MESSAGE       varchar2(255) := NULL;
  O_AVAILABLE           number(20,4) := NULL;
  l_ITEM                rms.item_loc.item%type;
  l_wh                 rms.item_loc.loc%type;
  l_LOC_TYPE            varchar2(1):= 'W';
  v_Return              BOOLEAN;

  CURSOR C_LOC IS
    SELECT wh  FROM WH where STOCKHOLDING_IND ='Y' and wh in ('1001','4001','3001','6001');

  CURSOR C_ITEMLOC (l_wh rms.wh.wh%type)IS
    SELECT item,loc FROM ITEM_LOC_soh WHERE LOC_TYPE ='W' and loc = l_wh and stock_on_hand>='150' and rownum<='20000';    

BEGIN

for k in C_LOC loop
    l_wh := k.wh;

for i in C_ITEMLOC (l_wh) loop
 l_item := i.item;
 
  v_Return := RMS.ITEMLOC_QUANTITY_SQL.GET_LOC_CURRENT_AVAIL(O_ERROR_MESSAGE => O_ERROR_MESSAGE,
                                O_AVAILABLE => O_AVAILABLE,
                                I_ITEM => l_ITEM,
                                I_LOC => l_wh,
                                I_LOC_TYPE => l_LOC_TYPE);
	IF (v_Return) THEN 
		insert into cust_tsf_upld (item_id,from_loc,to_loc,quantity) values (l_item,l_wh,null,O_AVAILABLE);
	ELSE
		continue;
    END IF;

	end loop;
	end loop;
commit;

exception
   when others then
      dbms_output.put_line('exception block'||to_char(sqlcode)||sqlerrm);
      rollback;

end;
/