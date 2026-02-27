
select * from rms.nb_system_parameters where func_area like '%PRICE_EXTRACTS%';
select * from rms.nb_system_parameters where func_area like '%PRICE_EVENTS_EMAIL_NOTIFICATION%';

Update rms.nb_system_parameters set VALUE_1= 'siddeshk@asos.com'
    where func_area like '%PRICE_EXTRACTS%';

select * from period;
select * from int_asos.int_batch_queue order by 1 desc;
select * from int_asos.int_batch_queue where SEQ_NO = '2455';


"com.oracle.suppliercollab.email.sender.EmailSenderFailed: The creating email function failed! 
535 Authentication failed: The provided authorization grant is invalid, expired, or revoked
"

delete from int_asos.int_batch_queue where seq_no =2443;

./nb_prepost.ksh $UP set PRICE_EVENTS_EMAIL_NOTIFICATION T &




INT_BATCH_SCHEDULER_SQL.PRE_POST_PROCESS



select int_asos.INT_BATCH_QUEUE_SEQ.NEXTVAL from dual;




select * from int_asos.INT_V_PE_BLOCKED_ITEM_ZONES