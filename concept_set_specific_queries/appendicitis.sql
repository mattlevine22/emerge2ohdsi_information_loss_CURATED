
-- CASE, 1, Diagnoses of appendicitis (ICD-9=540.XX)
-- https://phekb.org/sites/phenotype/files/appendicitis-algorithm-2016_5-5.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
concept_code like '540%';

-- AppyGoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where concept_id IN (
45601166,
45552925,
45557650,
45567300,
1569579,
920136,
920137,
1569580,
45538522,
45605933,
44831310,
44830151,
44834807,
44830152,
4057524,
4340802,
4340803,
4141626,
4151696,
4117866,
196149,
4177979,
4178300,
193238,
4275886,
4277609,
44784251,
441604,
4222930,
4310400
);


-- AppyMimic
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
4310400
)
order by concept_id;

-- AppyIntent
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
4310400
)
order by concept_id;
