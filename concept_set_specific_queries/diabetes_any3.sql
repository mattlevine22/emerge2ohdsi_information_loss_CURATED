-- NOTE:

-- from Table 9 of T2DM algorithm pdf
-- https://phekb.org/sites/phenotype/files/T2DM-algorithm.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
(concept_code like '250%' or
concept_code like '648.8%' or
concept_code like '648.0%' or
concept_code IN ('790.21','790.22','790.2','790.29','791.5','277.7','V18.0','V77.1')
);

-- Sheet "GoldStd", Intent='y'
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
0
);

-- SNO_ke on DB
-- Find the patients who have at least one of these KnowEng selected SNOMED codes

-- SNO_ke_gh on DB (NO DESC)
-- Find the patients who have at least one of these KnowEng selected SNOMED codes
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct src_concept_code, src_concept_id, src_vocabulary_id, p2.concept_id, p2.vocabulary_id
-- select distinct p2.concept_id
from ( select src_concept_code, src_concept_id, src_vocabulary_id from my_codes_src_original) x
left join public.concept_relationship as r1 on x.src_concept_id = r1.concept_id_1
left join public.concept as p2 on p2.concept_id = r1.concept_id_2
where r1.relationship_id = 'Maps to'
and r1.invalid_reason is null
order by src_concept_code;


-- SNO_ke_gh on DB (NO DESC included if code has child)
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_id IN (
0)
order by concept_id;


