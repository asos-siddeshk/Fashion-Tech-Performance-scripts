FUSEUKL	F1000459	ABC Leathers	Exited	1	IN	India	3	3 - Amber
DOTANDC	F1000220	Moda Elissa	Live	1	RO	Romania	3	3 - Amber
DEBATE	F1001272	Bizden Giyim	Live	1	TR	Turkey	2	2 - Red
EVAEUR	F1001167	Eva Jo !!!	Live	1	GR	Greece	3	3 - Amber
GEKOFA2	F1001272	Bizden Giyim	Live	1	TR	Turkey	2	2 - Red



select * from sups;
select * from sups_cfa_ext;
select * from partner;
select * from partner_cfa_ext;

select * from all_tables where table_name like 'CFA%';
select * from CFA_ATTRIB_GROUP;

select * from dba_source where text like '%CODE%' and owner like 'RMS';

select * from ma_asos.MA_SUPPLIER_FACTORY;

select EXTERNAL_REF_ID from rms.sups s where SUP_STATUS ='A' and EXTERNAL_REF_ID is not null and SUPPLIER_PARENT is not null
    and not exists ( select 1 from MA_ASOS.MA_SUPPLIER_FACTORY sf where SF.supplier = s.supplier) and rownum <= '200';
    
select NVL(S.EXTERNAL_REF_ID,S.SUPPLIER) SupplierCode,
       'F'||SF.FACTORY FactoryCode,
       P.PARTNER_DESC FactoryName,
       DECODE(P.STATUS,'A','Live','I','Exited') FactoryStatus,
       '1' PrimaryFactory,
       P.PRINCIPLE_COUNTRY_ID FactoryCountryCode,
       C.COUNTRY_DESC FactoryCountryDescription,
       PCE.VARCHAR2_2 RiskRatingCode,
       PCE.VARCHAR2_2||' '||'-'||' '|| CD.CODE_DESC  RiskRatingDescription 
  from RMS.SUPS S,
       MA_ASOS.MA_SUPPLIER_FACTORY SF,
       RMS.PARTNER P,
       RMS.PARTNER_CFA_EXT PCE,
       RMS.CODE_DETAIL CD,
       RMS.COUNTRY C
where S.SUPPLIER_PARENT IS NOT NULL
   AND s.supplier = sf.supplier
   AND SF.FACTORY = P.PARTNER_ID
   AND P.PARTNER_TYPE = 'FA'
   AND PCE.GROUP_ID = '210100'
   AND P.PARTNER_TYPE = PCE.PARTNER_TYPE
   AND PCE.PARTNER_TYPE='FA'
   AND PCE.PARTNER_ID = P.PARTNER_ID
   AND CD.CODE_TYPE = 'FACR'
   AND CD.CODE = PCE.VARCHAR2_2
  AND P.PRINCIPLE_COUNTRY_ID = C.COUNTRY_ID and rownum <= '2000';

select * from CODE_DETAIL where CODE_TYPE = 'FACR';

select distinct sf.supplier  from MA_ASOS.MA_SUPPLIER_FACTORY SF, rms.sups s where s.supplier = sf.supplier;
select * from MA_ASOS.MA_SUPPLIER_FACTORY;
select * from rms.sups;
select * from rms.partner;
select * from rms.PARTNER_CFA_EXT;
select * from rms.partner;
select * from rms.addr where MODULE like 'PTNR';
select * from rms.country;

merge into rms.partner ipb
using (select KEY_VALUE_2,COUNTRY_ID from rms.addr where MODULE like 'PTNR') inner
on (ipb.PARTNER_ID = inner.KEY_VALUE_2)
  when matched then
    update
       set ipb.PRINCIPLE_COUNTRY_ID            = inner.COUNTRY_ID;


select EXTERNAL_REF_ID from rms.sups s where SUP_STATUS ='A' and EXTERNAL_REF_ID is not null and SUPPLIER_PARENT is not null
    and not exists ( select 1 from MA_ASOS.MA_SUPPLIER_FACTORY sf where SF.supplier = s.supplier) and rownum <= '200';

select * from INT_ASOS.INT_MA_FACTORY_SUPP_UPLD_STG where trunc(CREATE_DATETIME) ='16-SEP-19' order by LAST_UPDATE_DATETIME desc;
select * from INT_ASOS.INT_RMS_FACTORY_EXT_UPLD_STG where trunc(CREATE_DATETIME) ='16-SEP-19' order by LAST_UPDATE_DATETIME desc;
select * from INT_ASOS.INT_RMS_PARTNER_UPLD_STG where trunc(CREATE_DATETIME) ='16-SEP-19' order by LAST_UPDATE_DATETIME desc;


select count(1) from INT_ASOS.INT_MA_FACTORY_SUPP_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);
select count(1) from INT_ASOS.INT_RMS_FACTORY_EXT_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);
select count(1) from INT_ASOS.INT_RMS_PARTNER_UPLD_STG where trunc(CREATE_DATETIME) = trunc(sysdate);




select * from (select NVL(S.EXTERNAL_REF_ID,S.SUPPLIER) SupplierCode,
     'F'||SF.FACTORY FactoryCode,
     P.PARTNER_DESC FactoryName,
     DECODE(P.STATUS,'A','Live','I','Exited') FactoryStatus,
     '1' PrimaryFactory,
     P.PRINCIPLE_COUNTRY_ID FactoryCountryCode,
     C.COUNTRY_DESC FactoryCountryDescription,
     PCE.VARCHAR2_2 RiskRatingCode,
     PCE.VARCHAR2_2||' '||'-'||' '|| CD.CODE_DESC  RiskRatingDescription
from RMS.SUPS S,
     MA_ASOS.MA_SUPPLIER_FACTORY SF,
     RMS.PARTNER P,
     RMS.PARTNER_CFA_EXT PCE,
     RMS.CODE_DETAIL CD,
     RMS.COUNTRY C
where S.SUPPLIER_PARENT IS NOT NULL
 AND s.supplier = sf.supplier
 AND SF.FACTORY = P.PARTNER_ID
 AND P.PARTNER_TYPE = 'FA'
 --and sf.create_id ='EXTRA'
 AND PCE.GROUP_ID = '210100'
 AND P.PARTNER_TYPE = PCE.PARTNER_TYPE
 AND PCE.PARTNER_TYPE='FA'
 AND PCE.PARTNER_ID = P.PARTNER_ID
 AND CD.CODE_TYPE = 'FACR'
 AND CD.CODE = PCE.VARCHAR2_2
AND P.PRINCIPLE_COUNTRY_ID = C.COUNTRY_ID ) where rownum <= '5000';


select * from MA_ASOS.MA_SUPPLIER_FACTORY SF where sf.create_id ='EXTRA';