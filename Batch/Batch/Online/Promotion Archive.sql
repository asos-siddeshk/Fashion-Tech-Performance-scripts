desc rpm_promo;
select * from promo_arc;


create table promo_arc (promo_id NUMBER(10),L_error_message varchar2(255));


set SERVEROUTPUT ON;
set timing ON;
  DECLARE
  
        L_return_code   varchar2(5)   := null;
        L_error_message varchar2(255) := null;
     l_promo_id     rms.rpm_promo.PROMO_ID%type;
        COUNTER_COMMIT  NUMBER(8)     := 1;
        
     cursor c_get_promo is

select distinct promo_id from RMS.RPM_PROMO_comp where promo_comp_id in (select promo_comp_id from RMS_SSET.RPM_PROMO_comp_hist where promo_id in ('67759','67817','67827','67950','67977','67991','67997'));

      BEGIN
        FOR cust_ma in c_get_promo Loop
		l_promo_id			:= cust_ma.PROMO_ID; 
         --L_vdate := TO_DATE('20181014', 'YYYYMMDD');

         if rms.RPM_ARCHIVE_PROMOTIONS.ARCHIVE(l_promo_id,L_error_message) = '0' THEN
         
        insert into promo_arc (promo_id,L_error_message) values (l_promo_id,L_error_message);
         else
          insert into promo_arc (promo_id,L_error_message) values (l_promo_id,'S');

         end if;
       
       	COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 1000) = 0 THEN
				COMMIT;
			   END IF;	
               
        end loop;

EXCEPTION
 
   when OTHERS THEN
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;
 
END;
/