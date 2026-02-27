select * from tsf_del;
set SERVEROUTPUT ON;
set timing ON;
Declare 
   L_error_message RTK_ERRORS.RTK_TEXT%TYPE;
  
   cursor C_GET_TSF is 
     select tsh.tsf_no,
            tsh.status,  
            tsh.tsf_type
       from tsfhead tsh
      where status ='I' and rownum <= '10' order by 1;

Begin 
for m in 0..10 loop

   for rec in C_GET_TSF loop      
      if TRANSFER_SQL.DELETE_CANCELLED_TSF(L_error_message,
                                           rec.tsf_no,
                                           NULL,
                                           rec.status,
                                           rec.tsf_type) = FALSE then
                                           
        insert into skumar.tsf_del values (rec.tsf_no,L_error_message);
      else 
        insert into skumar.tsf_del values (rec.tsf_no,'S');
      end if;   
   end loop;
   
      end loop;
   commit;
   
end;   
/