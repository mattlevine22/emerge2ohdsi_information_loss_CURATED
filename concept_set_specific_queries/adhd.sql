
-- CASE, 1, Diagnoses of adhd (note, leaves out 314.00)
-- https://phekb.org/phenotype/adhd-phenotype-algorithm
-- ADHD Algorithm.docx. Table 1.
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
concept_code IN (
'314',
'314.0',
'314.01',
'314.1',
'314.2',
'314.8',
'314.9'
);

-- AdhdGoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where concept_id IN (
440086,
437261,
438132,
4041692,
4049391,
4149904,
438409,
44784525,
4253962,
44825316,
44821835,
44822997,
44821836,
44829952,
44833427,
44827676,
1568263,
35207263,
45552506,
35207264,
35207265,
45581476,
45605518,
45586262,
45533124
);


-- Eric Jin's concept set on atlas
drop table my_codes_sno_ke_pj;
create table my_codes_sno_ke_pj as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from (select distinct concept_id from public.concept where concept_id IN (
438132,
437261,
440086,
438409
)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
order by concept_id;

-- AdhdMimic
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id
from public.concept
where concept_id IN (
437261,
438132,
438409
)
order by concept_id;

-- AdhdIntent
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_id IN (
437261,
438132,
4041692,
4049391,
4149904,
438409,
44784525,
4253962
)
order by concept_id;


