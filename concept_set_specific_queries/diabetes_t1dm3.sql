-- NOTE:

-- from Table 3 of T2DM algorithm pdf
-- https://phekb.org/sites/phenotype/files/T2DM-algorithm.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
(concept_code like '250._1%' or
concept_code like '250._3%');

-- DM1GoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
45773567,
45757073,
45757074,
46269764,
45757266,
45770902,
45757362,
45757393,
45757432,
37016179,
37016180,
43530660,
45757507,
45757535,
201531,
4099214,
4096668,
4099215,
4063042,
4047906,
45757604,
4102018,
36713094,
45757674,
443412,
4151281,
4152858,
37016348,
37016353,
4295011,
439770,
4222553,
435216,
4225055,
4224254,
373999,
4222687,
318712,
4228112,
377821,
200687,
4224709,
4143689,
4143857,
443592,
40484648,
201254,
43531008,
43531009,
45763583,
45763584,
45763585,
43531565,
45766051,
37016767,
37017429,
37017431,
45771067,
45769829,
45769830,
37018566,
45769832,
45769833,
45769834,
36715571,
45769837,
36717215,
45769873,
45771533,
45769876,
45769891,
45771068,
45769892,
45773576,
45769901,
45771075,
45769902,
45769903,
45769904,
45773688,
44820682,
44821787,
44824071,
44822934,
44832190,
44832191,
44832192,
44820683,
44822935,
44834549,
44822936,
44820684,
44831046,
44819501,
44825264,
44819502,
44836918,
44833368,
44829881,
44819504,
1567940,
1567941,
45600636,
45557110,
1567942,
45552379,
45547621,
45600637,
1567943,
1567944,
45552381,
45542736,
1567945,
45595793,
45591026,
1567946,
45561947,
45605397,
1567947,
45595794,
45537958,
1567948,
45576437,
45571654,
45552382,
45576438,
1567949,
45600638,
45576439,
45595795,
45533017,
45561948,
45586138,
1567950,
45547622,
45542737,
45581349,
1567951,
1567952,
45576440,
45537960,
1567953,
45600639,
45605398,
45581350,
45566729,
1567954,
45557111,
45547623,
1567955,
45552383,
45600640,
45533018,
45547624,
35206878,
35206879,
1571684,
1571685,
45548715,
45587291,
45539105,
45543921,
45606546,
45577566,
45576436,
45755355,
45542735,
45586137,
45552380,
45533016,
45595796,
45537959,
45571655,
45552384,
45581351,
45558213
);


-- Sheet old "GoldStd", Intent='y'
drop table my_codes_src_intent_old;
create table my_codes_src_intent_old as
select distinct concept_id
from public.concept
where concept_id IN (
45773567,
45757073,
45757074,
46269764,
45757266,
45770902,
45757362,
45757393,
45757432,
37016179,
37016180,
43530660,
45757507,
45757535,
201531,
4099214,
4096668,
4099215,
4063042,
4047906,
45757604,
4102018,
36713094,
45757674,
443412,
4151281,
4152858,
37016348,
37016353,
4295011,
439770,
4222553,
435216,
4225055,
4224254,
373999,
4222687,
318712,
4228112,
377821,
200687,
4224709,
4143689,
4143857,
443592,
40484648,
201254,
43531008,
43531009,
45763583,
45763584,
45763585,
43531565,
45766051,
37016767,
37017429,
37017431,
45771067,
45769829,
45769830,
37018566,
45769832,
45769833,
45769834,
36715571,
45769837,
36717215,
45769873,
45771533,
45769876,
45769891,
45771068,
45769892,
45773576,
45769901,
45771075,
45769902,
45769903,
45769904,
45773688,
44820682,
44821787,
44824071,
44822934,
44832190,
44832191,
44832192,
44820683,
44822935,
44834549,
44822936,
44820684,
44831046,
44819501,
44825264,
44819502,
44836918,
44833368,
44829881,
44819504,
1567940,
1567941,
45600636,
45557110,
1567942,
45552379,
45547621,
45600637,
1567943,
1567944,
1567945,
45595793,
45591026,
1567946,
45561947,
45605397,
1567947,
45595794,
45537958,
45576437,
45571654,
45576438,
1567949,
45600638,
45576439,
45595795,
45533017,
45561948,
45586138,
1567950,
45547622,
45542737,
45581349,
1567951,
1567952,
45576440,
45537960,
1567953,
45600639,
45605398,
45581350,
45566729,
1567954,
45557111,
45547623,
45552383,
45600640,
45533018,
45547624,
35206878,
35206879,
1571684,
1571685,
45548715,
45587291,
45539105,
45543921,
45577566,
45576436,
45755355,
45542735,
45586137,
45552380,
45533016,
45595796,
45537959,
45571655,
45552384,
45581351,
45558213
);

-- SNO_ke on DB
-- Find the patients who have at least one of these KnowEng selected SNOMED codes

-- SNO_ke_gh on DB (NO DESC)
-- Find the patients who have at least one of these KnowEng selected SNOMED codes
drop table my_codes_sno_ke_mimic_old;
create table my_codes_sno_ke_mimic_old as
select distinct x.concept_code as src_concept_code, x.concept_id as src_concept_id, x.vocabulary_id as src_vocabulary_id,
p2.concept_id, p2.vocabulary_id
-- select distinct p2.concept_id
from ( select * from public.concept
where vocabulary_id='ICD9CM' and
(concept_code like '250._1%' or
concept_code like '250._3%')
and concept_code NOT IN ('250.31')
) x
left join public.concept_relationship as r1 on x.concept_id = r1.concept_id_1
left join public.concept as p2 on p2.concept_id = r1.concept_id_2
where r1.relationship_id = 'Maps to'
and r1.invalid_reason is null
order by p2.concept_id;

drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id
from public.concept
where concept_id IN (
201531,
439770,
435216,
373999,
318712,
4228112,
377821,
200687,
443592,
40484648,
201254
);

-- technically DM1Intent2 from the Excel document
-- NOTE this does not match what is on Atlas.org (I think because of vocabulary version reasons)
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_id IN (435216,201254)
UNION
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
46269764,
45770902,
45757362,
45757393,
45757432,
43530660,
45757507,
201531,
4099214,
4096668,
4099215,
4063042,
4047906,
4102018,
45757674,
443412,
4151281,
4152858,
37016348,
37016353,
439770,
373999,
318712,
377821,
200687,
4224709,
4143689,
443592,
40484648,
43531008,
43531009,
45763585,
43531565,
45766051,
37017429,
45771067,
45769830,
45769832,
45769833,
45769834,
36715571,
45769837,
36717215,
45769876,
45769891,
45771068,
45769892,
45773576,
45769901,
45771075,
45769902,
45769903,
45769904,
45773688
)
order by concept_id;


-- technically DM1Intent3 from the Excel document
-- NOTE this does not match what is on Atlas.org (I think because of vocabulary version reasons)
drop table my_codes_sno_ke_gh_optimal2;
create table my_codes_sno_ke_gh_optimal2 as
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
201254,
200687,
377821,
318712,
435216,
40484648
)
and c2.concept_id NOT in (4145827,37396268)
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


