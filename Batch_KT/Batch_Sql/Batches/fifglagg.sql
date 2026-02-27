create table rpm_event_itemloc_bk as
select * from rpm_event_itemloc;
drop table rpm_event_itemloc_bk;

select * from rpm_event_itemloc;
select count(1) from tran_data; -- 596380
select count(1) from if_tran_data; -- 12211714


select count(1) from stg_fif_gl_data_bk_3012; --8842 -- fifgldnld2
select count(1) from stg_fif_gl_data_bk_3012_2; -- 9426 -- fifgldnld2 post
select count(1) from stg_fif_gl_data_bk_3012_3; -- 9426 -- fifgldnld4
select count(1) from nb_stg_fif_gl_data_bk_3012_b; --103
select count(1) from nb_stg_fif_gl_data_bk_3012_4; -- 9426 -- nb_fifgagg pre
select count(1) from stg_fif_gl_data_bk_3012_5; -- 564 -- nb_fifgagg 

create table nb_stg_fif_gl_data_bk_3012_4 as
select * from nb_stg_fif_gl_data; -- -- nb_fifgagg pre
create table stg_fif_gl_data_bk_3012_5 as -- nb_fifgagg
select * from stg_fif_gl_data; -- 
select * from stg_fif_gl_data; --

create table stg_fif_gl_data_bk_3012_3 as nb_fifgagg
    select * from stg_fif_gl_data; -- 
select count(1) from stg_fif_gl_data; -- 

select * from stg_fif_gl_data; -- 
select * from nb_stg_fif_gl_data; --




/asos/oracle/vpt/data/outbound/Integration/DailyTrans/pending


/asos/oracle/vpt/data/outbound/Integration/GlExtract/pending


/asos/oracle/vpt/data/outbound/Integration/SalRet/pending


