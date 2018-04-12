
-- Diagnoses of crohns disease
-- https://phekb.org/phenotype/crohns-disease-demonstration-project
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
concept_code IN (
'555',
'555.0',
'555.1',
'555.2',
'555.9'
);

-- CrohnGoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
46274073,
46269874,
46269875,
46269876,
46269877,
46269878,
46269879,
46269880,
46269881,
46269882,
46269883,
46269884,
46269885,
46269886,
46269887,
46269888,
46269889,
46269890,
46269891,
4055884,
4055020,
4122617,
4340114,
4342643,
201606,
4244235,
4242392,
4264850,
4246693,
4131542,
4212991,
4212992,
4142544,
4177488,
4210469,
195585,
4266370,
4323289,
195575,
36715915,
36716695,
194684,
36716986,
4239382,
44834811,
44827872,
44820945,
44825522,
44822028,
1569610,
1569611,
45533598,
1569612,
45601172,
45543315,
45591593,
45557653,
45586716,
45538530,
1569613,
45576986,
1569614,
45596325,
45576987,
45548159,
45596326,
45581901,
45562489,
1569615,
45596327,
1569616,
45567306,
45533600,
45601174,
45533601,
45601175,
45581902,
1569617,
45601176,
1569618,
45567307,
45557654,
45543316,
45562491,
45576988,
45572211,
45755435,
45596324,
45601173,
45533599,
45562490
);


-- CrohnMimic
-- Crohn: USE ALL DESCENDANTS FOR THIS ONE
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
201606
)
order by concept_id;

-- CrohnIntent
-- Crohn: USE ALL DESCENDANTS FOR THIS ONE
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
201606,
46269889
)
order by concept_id;

