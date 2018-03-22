-- DIABETES ANY
-- from Table 9 of T2DM algorithm pdf
-- https://phekb.org/sites/phenotype/files/T2DM-algorithm.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_id
from public.concept
where vocabulary_id='ICD9CM' and 
(concept_code like '250%' or
concept_code like '648.8%' or
concept_code like '648.0%' or
concept_code IN ('790.21','790.22','790.2','790.29','791.5','277.7','V18.0','V77.1')
);

-- 44819500
-- 44819501
-- 44819502
-- 44819503
-- 44819504
-- 44820682
-- 44820683
-- 44820684
-- 44820685
-- 44821617
-- 44821787
-- 44822099
-- 44822104
-- 44822934
-- 44822935
-- 44822936
-- 44823246
-- 44823247
-- 44823798
-- 44824071
-- 44824072
-- 44824073
-- 44824074
-- 44824634
-- 44824637
-- 44825264
-- 44826459
-- 44826460
-- 44826461
-- 44826981
-- 44827615
-- 44827616
-- 44827617
-- 44828793
-- 44828794
-- 44828795
-- 44829117
-- 44829305
-- 44829878
-- 44829879
-- 44829880
-- 44829881
-- 44829882
-- 44830221
-- 44831045
-- 44831046
-- 44831047
-- 44831389
-- 44831390
-- 44831602
-- 44832190
-- 44832191
-- 44832192
-- 44832193
-- 44832194
-- 44832532
-- 44832533
-- 44833365
-- 44833366
-- 44833367
-- 44833368
-- 44834548
-- 44834549
-- 44836084
-- 44836914
-- 44836915
-- 44836916
-- 44836917
-- 44836918
-- 44836935
-- 44837245


-- DIABETES T1DM
-- from Table 3 of T2DM algorithm pdf
-- https://phekb.org/sites/phenotype/files/T2DM-algorithm.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_id
from public.concept
where vocabulary_id='ICD9CM' and 
(concept_code like '250._1%' or
concept_code like '250._3%');

-- 44819501
-- 44819502
-- 44819504
-- 44820682
-- 44820683
-- 44820684
-- 44821787
-- 44822934
-- 44822935
-- 44822936
-- 44824071
-- 44825264
-- 44829881
-- 44831046
-- 44832190
-- 44832191
-- 44832192
-- 44833368
-- 44834549
-- 44836918


-- DIABETES T2DM
-- from Table 4 of T2DM algorithm pdf
-- https://phekb.org/sites/phenotype/files/T2DM-algorithm.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_id
from public.concept
where vocabulary_id='ICD9CM' and 
(concept_code like '250._0%' or
concept_code like '250._2%')
and concept_code NOT IN ('250.10','250.12');

-- 44819500
-- 44824073
-- 44826460
-- 44826461
-- 44827616
-- 44827617
-- 44828795
-- 44829879
-- 44829882
-- 44831045
-- 44831047
-- 44832193
-- 44832194
-- 44833366
-- 44833367
-- 44836914
-- 44836915
-- 44836916
