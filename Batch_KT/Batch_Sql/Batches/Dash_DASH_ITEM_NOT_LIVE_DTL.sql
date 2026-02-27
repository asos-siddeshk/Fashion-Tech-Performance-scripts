SELECT *
    FROM dash_asos.DASH_REFRESH_CONFIG where RESULT_SYNONYM like 'DASH_ITEM_NOT_LIVE_DTL';

select * from dash_asos.DASH_ITEM_NOT_LIVE_DTL;
select * from dash_asos.DASH_R_ITEM_NOT_LIVE_TAB_A;
select * from dash_asos.DASH_R_ITEM_NOT_LIVE_TAB_B;
select * from dash_asos.DASH_V_R_ITEM_NOT_LIVE;

select * from all_synonyms where upper(SYNONYM_NAME) like 'DASH_ITEM_NOT_LIVE_DTL';    
select * from all_views where upper(view_name) like 'DASH_V_R_ITEM_NOT_LIVE';    

select item,loc,DATE_21, DATE_22 from dash_asos.item_loc_cfa_ext where item= '100000035';


set serveroutput on;
set timing on;

declare

  COUNTER         NUMBER(8)     := 0;
  COUNTER_COMMIT  NUMBER(8)     := 1000;
  i1 NUMBER := 10 ;  

 stage_COMMIT  NUMBER(8)     := 0;
 
   l_item_id               rms.rpm_stage_clearance.item%type;
   l_effective_date        rms.rpm_stage_clearance.effective_date%type;
   l_dept                	rms.subclass.dept%type; 
   l_class                	rms.subclass.class%type; 
   l_subclass               rms.subclass.subclass%type; 
   
    cursor cur_dept is
	select dept,class,subclass   from (
		   select distinct im.dept,im.class,im.subclass  from rms.item_master im where 
			status ='A' and item_level =tran_level 
			group by im.dept,im.class,im.subclass having (count(im.subclass)) >='100') where rownum <='50' order by 1,2,3;
	
                
    CURSOR c_get_cuitem_clr (l_dept rms.subclass.dept%type,l_class rms.subclass.class%type,l_subclass rms.subclass.subclass%type)is
            select      im.item
				from rms.item_loc_cfa_ext il,
					 rms.item_master     im
				where il.item             = im.item
				 and im.dept =l_dept
                  and im.class =l_class
                   and im.subclass =l_subclass
				 and im.item_level = '1'
                 and im.tran_level = '2'
                 and rownum<=15
                  order by item;

begin
  
    for m in 0..0 loop

for k in cur_dept loop

  l_dept := k.dept;
    l_class := k.class;
      l_subclass := k.subclass;	  
      
		for l_loop in c_get_cuitem_clr(l_dept,l_class,l_subclass) loop 
		
    		l_item_id			:= l_loop.item;
            
            update rms.item_loc_cfa_ext set DATE_21 = get_vdate-1, DATE_22 = get_vdate 
                where item= l_item_id and loc in ('1001');
            
            update rms.item_loc_cfa_ext set DATE_21 = get_vdate-1, DATE_22 = get_vdate+3 
                where item= l_item_id and loc in ('1011','1012','3001','3011','4001','4011','4012');
                
                dbms_output.put_line('Item'||l_item_id);
                
        COUNTER_COMMIT :=COUNTER_COMMIT + 1;
			   IF MOD(COUNTER_COMMIT, 10) = 0 THEN
				COMMIT;
			   END IF;
		  end loop;

    end loop;  
		    end loop; 
            
exception

   when others then
   
      dbms_output.put_line('Exception blcok'||dbms_utility.FORMAT_ERROR_BACKTRACE||dbms_utility.format_error_stack);
      ROLLBACK;

end;
/