-- NOTE:
-- Codes are taken from Excel spreadsheet: "Heart Failure icd9 snomed"

-- Sheet "GoldStd", Original='y'
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where concept_id IN (
44820869,
44820870,
44823119,
44824250,
44824251,
44826642,
44827794,
44827795,
44827796,
44830086,
44831248,
44831249,
44831250,
44832381,
44833573,
44833574,
44834732,
44835943,
44835944);

-- Sheet "GoldStd", Intent='y'
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where concept_id IN (
45581779,
45567179,
45543181,
45576879,
1569178,
35207792,
1569179,
45586587,
45543182,
45576878,
45567180,
1569180,
45601038,
45548022,
45533456,
45562355,
1569181,
45533457,
45591469,
45586588,
45567181,
35207793,
44824250,
44826642,
44827794,
44834732,
44830086,
44820869,
44831248,
44833573,
44831249,
44831250,
44824251,
44835943,
44835944,
44833574,
44832381,
44827795,
44820870,
44823119,
44827796,
4023479,
4009047,
43021840,
43020421,
43021841,
43021842,
44782718,
44782719,
44782733,
4111554,
4108244,
4108245,
44782713,
4199500,
4267800,
443580,
443587,
319835,
4311437,
4139864,
40479192,
40479576,
40482727,
40480602,
40480603,
40481042,
40481043,
444031,
4206009,
442310,
43021825,
43021826,
44782655,
44784442,
45766164,
36713488,
4327205,
316139,
439846,
4229440,
4242669,
43022068);

-- SNO_ke on DB
drop table my_codes_sno_ke_pj;
create table my_codes_sno_ke_pj as
select distinct public.concept_ancestor.descendant_concept_id as concept_id, public.concept.vocabulary_id
from (select distinct concept_id from public.concept where concept_id IN (
443580,
439846,
316139,
443587,
319835,
40482727,
40479192,
40479576,
44782719,
40480603,
40480602,
40481043,
44782733,
40481042,
44782718)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
left join public.concept on public.concept_ancestor.descendant_concept_id = public.concept.concept_id
order by concept_id;

-- SNO_ke_gh on DB (NO DESC)
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id, vocabulary_id
from public.concept
where concept_id IN (
316139,
319835,
439846,
443580,
40480603,
40479192,
40480602,
443587,
40481042,
40479576,
40481043,
40482727,
44782718,
44782719,
44782733)
order by concept_id;


-- SNO_ke_gh on DB (NO DESC included if code has child)
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id, vocabulary_id
from public.concept
where concept_id IN (
44784442,
40481042,
4009047,
45773075,
4103448,
4185565,
316139,
43021840,
4108244,
40486933,
4108245,
45766165,
45766164,
44782655,
43021842,
44782719,
43022068,
4327205,
4111554,
4267800,
43020421,
40480602,
40479576,
45766166,
43021841,
319835,
36712929,
4206009,
443587,
4023479,
4199500,
44782733,
40480603,
40479192,
443580,
40481043,
444031,
40482727,
45766167,
4139864,
439846,
4311437,
44782718,
4242669)
order by concept_id;

