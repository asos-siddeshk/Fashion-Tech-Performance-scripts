select to_number(value_1) as days , (select value from v$parameter where name like '%service_name%') DB_SERVICE
from nb_system_parameters
where func_area = 'FIN_DAS'
and parameter = 'WD_RETENTION_PERIOD';

select /*+ PARALLEL (ia, 8) */min(POST_DATE) from int_asos.INT_WD_RETURN ia;
select vdate from period;

select /*+ PARALLEL (ia, 4) */count(*) from int_asos.INT_WD_REFUND ia;      
select /*+ PARALLEL (ia, 4) */count(*) from int_asos.INT_WD_RETURN ia;      
select /*+ PARALLEL (ia, 4) */count(*) from int_asos.INT_WD_LIABILITY ia;   
select /*+ PARALLEL (ia, 4) */count(*) from int_asos.INT_WD_SHIPPED_SALE ia;


UPDATE nb_system_parameters set value_1=365
where func_area = 'FIN_DAS'
and parameter = 'WD_RETENTION_PERIOD';
commit;


./int_saexpwebdep_purge.ksh /@int_asos_rms INT_WD_REFUND &

./int_saexpwebdep_purge.ksh /@int_asos_rms INT_WD_RETURN &

./int_saexpwebdep_purge.ksh /@int_asos_rms INT_WD_LIABILITY &

./int_saexpwebdep_purge.ksh /@int_asos_rms INT_WD_SHIPPED_SALE &

