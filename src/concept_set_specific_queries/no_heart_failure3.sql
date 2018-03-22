-- NOTE:
-- Codes are taken from Excel spreadsheet: "Heart Failure icd9 snomed"

-- Sheet "GoldStdControl", Original='y'
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where concept_id IN (
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
44827796);

-- Sheet "GoldStdIntent", Intent='y'
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where concept_id IN (
45538369,
45572075,
45552780,
45567169,
45533440,
45548015,
45581779,
45567179,
45543181,
45576879,
45553639,
35207669,
35207673,
35207674,
1569148,
45572083,
45557540,
45586576,
45601029,
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
45601110,
45567255,
1569425,
35210517,
44823108,
44833557,
44823110,
44831230,
44819692,
44819693,
44819695,
44820856,
44819696,
44824235,
44825435,
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
4004279,
44782428,
4014159,
4023479,
4009047,
43021840,
43020421,
43021841,
43021842,
4134890,
4030258,
44782718,
44782719,
44782733,
36712927,
36712928,
36712929,
44782728,
439698,
439696,
439694,
4111554,
4108244,
4108245,
4071869,
44782713,
4124705,
4103448,
4172864,
4079695,
4079296,
4199500,
4141124,
141038,
4233424,
4231738,
4267800,
4273632,
139036,
4259490,
443580,
443587,
319835,
4311437,
4138307,
4139864,
4142561,
4184497,
4185565,
40479192,
40479576,
40482727,
4195785,
40480602,
40480603,
40481042,
40481043,
40482857,
40486933,
444101,
43021735,
43022054,
43021736,
43020657,
444031,
312927,
4177493,
314378,
4206009,
4205558,
442310,
4264636,
43530961,
4284562,
43021825,
43021826,
44782655,
44784442,
45766164,
45766165,
45766166,
45766167,
45773075,
45766964,
36713488,
4215802,
36716182,
36716748,
44784345,
4327205,
312338,
4193236,
4195892,
4215446,
315295,
316994,
4307356,
316139,
439846,
4229440,
4233224,
4242669,
43022068);


-- Sheet "KEoptimalControl", Original='y'
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct public.concept_ancestor.descendant_concept_id as concept_id, public.concept.vocabulary_id
from (select distinct concept_id from public.concept where concept_id IN (
316139,
139036,
141038)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
left join public.concept on public.concept_ancestor.descendant_concept_id = public.concept.concept_id
order by concept_id;


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


-- SNO_map on DB (ALL DESC)
drop table my_codes_sno_map_all_desc;
create table my_codes_sno_map_all_desc as
select distinct src_concept_code, src_concept_id, src_vocabulary_id,
p1.descendant_concept_id as concept_id, a1.vocabulary_id as vocabulary_id
from (
select s1.src_concept_code, s1.src_concept_id, s1.src_vocabulary_id, public.concept_relationship.concept_id_2 as concept_id
from my_codes_src_original as s1
left join public.concept_relationship on s1.src_concept_id = public.concept_relationship.concept_id_1
where relationship_id = 'Maps to'
and invalid_reason is null) x
left join public.concept_ancestor as p1 on x.concept_id = p1.ancestor_concept_id
left join public.concept a1 on a1.concept_id = p1.descendant_concept_id
order by src_concept_code;

-- SNO_map on DB (NO DESC)
drop table my_codes_sno_map_no_desc;
create table my_codes_sno_map_no_desc as
select distinct src_concept_code, src_concept_id, src_vocabulary_id, concept_id_2 as concept_id, p2.vocabulary_id
-- my_codes_src_original.concept_id as source_concept_id, public.concept_relationship.concept_id_2 as concept_id
from my_codes_src_original
left join public.concept_relationship as r1 on my_codes_src_original.src_concept_id = r1.concept_id_1
left join public.concept as p2 on p2.concept_id = r1.concept_id_2
where r1.relationship_id = 'Maps to'
and r1.invalid_reason is null
order by src_concept_code;

drop table tmp;
create table tmp as
select distinct concept_id, descendant_concept_id, min_levels_of_separation
from my_codes_sno_map_no_desc
left join public.concept_ancestor on concept_id = ancestor_concept_id
where min_levels_of_separation > 0;

alter table tmp
	add column has_desc INTEGER,
	add column has_child INTEGER;
update tmp
	set has_desc = 1
		where descendant_concept_id in (select concept_id from my_codes_sno_map_no_desc);
update tmp
	set has_child = 1
		where descendant_concept_id in (select concept_id from my_codes_sno_map_no_desc)
		and min_levels_of_separation = 1;

drop table desc_table;
create table desc_table as 
select concept_id, MAX(has_desc) as has_desc, MAX(has_child) as has_child
from tmp
group by concept_id
order by concept_id;
drop table tmp;

-- SNO_ke_gh on DB (NO DESC included if code has child)
drop table my_codes_sno_map_nodesc_if_desc;
create table my_codes_sno_map_nodesc_if_desc as
select distinct c0.src_concept_code, c0.src_concept_id, c0.src_vocabulary_id, 
public.concept_ancestor.descendant_concept_id as concept_id,
public.concept.vocabulary_id as vocabulary_id
from my_codes_sno_map_no_desc as c0
left join desc_table as d1 USING (concept_id)
left join public.concept_ancestor on c0.concept_id = public.concept_ancestor.ancestor_concept_id
left join public.concept on public.concept_ancestor.descendant_concept_id = public.concept.concept_id
where has_desc is null
UNION
select distinct src_concept_code, src_concept_id, src_vocabulary_id, concept_id, vocabulary_id
from my_codes_sno_map_no_desc
order by src_concept_code;

drop table my_codes_sno_map_nodesc_if_child;
create table my_codes_sno_map_nodesc_if_child as
select distinct c0.src_concept_code, c0.src_concept_id, c0.src_vocabulary_id, 
public.concept_ancestor.descendant_concept_id as concept_id,
public.concept.vocabulary_id as vocabulary_id
from my_codes_sno_map_no_desc as c0
left join desc_table as d1 USING (concept_id)
left join public.concept_ancestor on c0.concept_id = public.concept_ancestor.ancestor_concept_id
left join public.concept on public.concept_ancestor.descendant_concept_id = public.concept.concept_id
where has_child is null
UNION
select distinct src_concept_code, src_concept_id, src_vocabulary_id, concept_id, vocabulary_id
from my_codes_sno_map_no_desc
order by src_concept_code;


