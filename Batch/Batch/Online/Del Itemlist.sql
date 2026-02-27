create table del_skulist as
select distinct sh.SKULIST --, sh.SKULIST_DESC, DIVISION, DEPT, CLASS, SUBCLASS 
from rms.skulist_detail sd, rms.skulist_head sh, rms.v_item_master im 
    where sh.skulist = sd.skulist and sh. sKULIST_DESC like 'APCMass Search%' and sd.item = im.item ;


set serveroutput on;
set timing on;
DECLARE
    counter             NUMBER(10)                    := 0;
    c_commit  	        NUMBER(10)                     := 0;
    l_asn_num           rms.skulist_detail.skulist%type;
    
    cursor c_ord is
       select SKULIST from del_skulist;

BEGIN    

FOR k in c_ord loop
    l_asn_num    :=  k.SKULIST;
       
delete from skulist_detail where skulist = l_asn_num;
delete from skulist_criteria where skulist = l_asn_num;
delete from skulist_head where skulist = l_asn_num;

     counter   := counter + 1; 
		    c_commit :=c_commit + 1;
       IF MOD(c_commit, 50) = 0 THEN
        COMMIT;
       END IF;
	   
   END LOOP;
commit;

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
END;
/