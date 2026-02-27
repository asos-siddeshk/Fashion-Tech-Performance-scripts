update svc_order_parameter_config set max_chunk_size = 1, max_threads = 20, max_order_no_qty = 1;

select max_chunk_size,max_threads,max_order_no_qty from svc_order_parameter_config;

select *  from rms.ordhead where CREATE_DATETIME>= to_date('24-DEC-2019 10:50', 'DD-MON-YYYY hh24:mi')
                and comment_desc like '%25%';

select coeunt(distinct master_po_no)  from rms.ordhead where CREATE_DATETIME>= to_date('24-DEC-2019 11:30', 'DD-MON-YYYY hh24:mi')
                and comment_desc like '%25%';
select count(distinct master_po_no)  from rms.ordhead where CREATE_DATETIME>= to_date('24-DEC-2019 11:30', 'DD-MON-YYYY hh24:mi')
                and comment_desc like '%100%';                
                
select * from ma_asos.ma_order_mfqueue where MASTER_ORDER_NO= 21065054;

select max_chunk_size,max_threads,max_order_no_qty from svc_order_parameter_config;
CYCLE 1
update svc_order_parameter_config set max_chunk_size = 5, max_threads = 5, max_order_no_qty = 5;

select max_chunk_size,max_threads,max_order_no_qty from svc_order_parameter_config;
CYCLE 2
update svc_order_parameter_config set max_chunk_size = 5, max_threads = 20, max_order_no_qty = 5;

select max_chunk_size,max_threads,max_order_no_qty from svc_order_parameter_config;
CYCLE 3
update svc_order_parameter_config set max_chunk_size = 10, max_threads = 20, max_order_no_qty = 10;

select max_chunk_size,max_threads,max_order_no_qty from svc_order_parameter_config;
CYCLE 4
update svc_order_parameter_config set max_chunk_size = 30, max_threads = 20, max_order_no_qty = 30;