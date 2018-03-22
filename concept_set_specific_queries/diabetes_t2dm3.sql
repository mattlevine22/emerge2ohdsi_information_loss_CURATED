-- NOTE:

-- from Table 4 of T2DM algorithm pdf
-- https://phekb.org/sites/phenotype/files/T2DM-algorithm.pdf
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and 
(concept_code like '250._0%' or
concept_code like '250._2%')
and concept_code NOT IN ('250.10','250.12');

-- DM2GoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
45571656,
45576441,
45605400,
45591028,
45576442,
45557114,
45552387,
45561950,
45561951,
45561952,
45534187,
1567956,
1567957,
45542738,
45586139,
1567958,
45591027,
45595797,
45605401,
1567959,
1567960,
45581352,
45581353,
1567961,
45552385,
45581354,
1567962,
45537961,
45591029,
1567963,
45557112,
45605402,
1567964,
45591030,
45552386,
45595798,
45533019,
1567965,
45605403,
45547625,
45557113,
45537962,
45533020,
45605404,
1567966,
45533021,
45533022,
45576443,
1567967,
1567968,
45600641,
45586140,
1567969,
45547626,
45581355,
45600642,
45547627,
1567970,
45533023,
45566731,
1567971,
45561949,
45591031,
45605405,
45595799,
35206881,
35206882,
1571686,
1571687,
45587292,
45582457,
45567896,
45606547,
45587293,
45582458,
44836914,
44836915,
44836916,
44824073,
44826460,
44832193,
44831045,
44832194,
44819500,
44829879,
44828795,
44833366,
44827616,
44833367,
44831047,
44826461,
44827617,
44829882,
36712670,
45757075,
46274058,
36712686,
36712687,
45757255,
45757277,
45757278,
45757280,
45772060,
45757363,
45757392,
37016163,
45770880,
45757435,
45770881,
45757444,
45757445,
45757446,
45757447,
45770883,
45757449,
45771072,
45757450,
45757474,
43531608,
43530685,
43530689,
43530690,
43531616,
43530656,
45757499,
201530,
4099216,
4099651,
4099217,
4063043,
43531597,
4130162,
4129519,
45770928,
4193704,
4200875,
4196141,
4198296,
4230254,
37016349,
37016354,
37018912,
45772019,
443731,
4222415,
4221495,
376065,
4223463,
443732,
4226121,
443733,
443729,
4140466,
4142579,
4177050,
201826,
40482801,
45763582,
43531010,
43531651,
45766052,
43531562,
37016768,
37018728,
37017432,
45771064,
45769828,
36714116,
45769835,
45769836,
43531577,
43531653,
43531566,
43531559,
43531564,
43531578,
43531588,
4304377,
45773064,
45769872,
45769875,
45769888,
45769889,
45769890,
45769894,
45769905,
45769906,
45770830,
45770831,
45770832,
4321756
);


-- Sheet old "GoldStd"
drop table my_codes_src_intent_old;
create table my_codes_src_intent_old as
select distinct concept_id
from public.concept
where concept_id IN (
45571656,
45576441,
45605400,
45591028,
45576442,
45557114,
45552387,
45561950,
45561951,
45561952,
45534187,
1567956,
1567957,
45542738,
45586139,
1567958,
45591027,
45595797,
45605401,
1567959,
1567960,
45581352,
45581353,
1567961,
45552385,
45581354,
1567962,
45537961,
45591029,
1567963,
45557112,
45605402,
45591030,
45552386,
45595798,
45533019,
1567965,
45605403,
45547625,
45557113,
45537962,
45533020,
45605404,
1567966,
45533021,
45533022,
45576443,
1567967,
1567968,
45600641,
45586140,
1567969,
45547626,
45581355,
45600642,
45547627,
1567970,
45533023,
45566731,
45591031,
45605405,
45595799,
35206881,
35206882,
1571686,
1571687,
45587292,
45582457,
45567896,
45606547,
45582458,
44836914,
44836915,
44836916,
44824073,
44826460,
44832193,
44831045,
44832194,
44819500,
44829879,
44828795,
44833366,
44827616,
44833367,
44831047,
44826461,
44827617,
44829882,
36712670,
45757075,
46274058,
36712686,
36712687,
45757255,
45757277,
45757278,
45757280,
45772060,
45757363,
45757392,
37016163,
45770880,
45757435,
45770881,
45757444,
45757445,
45757446,
45757447,
45770883,
45757449,
45771072,
45757450,
45757474,
43531608,
43530685,
43530689,
43530690,
43531616,
43530656,
45757499,
201530,
4099216,
4099651,
4099217,
4063043,
43531597,
4130162,
4129519,
45770928,
4193704,
4200875,
4196141,
4198296,
4230254,
37016349,
37016354,
37018912,
45772019,
443731,
4222415,
4221495,
376065,
4223463,
443732,
4226121,
443733,
443729,
4140466,
4142579,
4177050,
201826,
40482801,
45763582,
43531010,
43531651,
45766052,
43531562,
37016768,
37018728,
37017432,
45771064,
45769828,
36714116,
45769835,
45769836,
43531577,
43531653,
43531566,
43531559,
43531564,
43531578,
43531588,
4304377,
45773064,
45769872,
45769875,
45769888,
45769889,
45769890,
45769894,
45769905,
45769906,
45770830,
45770831,
45770832,
4321756
);

-- SNO_ke on DB
-- Find the patients who have at least one of these KnowEng selected SNOMED codes

drop table my_codes_sno_ke_pj;
create table my_codes_sno_ke_pj as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from (select distinct concept_id from public.concept where concept_id IN (
0)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
order by concept_id;

-- SNO_ke_gh on DB (NO DESC)
-- Find the patients who have at least one of these KnowEng selected SNOMED codes
drop table my_codes_sno_ke_mimic_old;
create table my_codes_sno_ke_mimic_old as
select distinct x.concept_code as src_concept_code, x.concept_id as src_concept_id, x.vocabulary_id as src_vocabulary_id,
p2.concept_id, p2.vocabulary_id
-- select distinct p2.concept_id
from ( select * from public.concept
where vocabulary_id='ICD9CM' and 
(concept_code like '250._0%' or
concept_code like '250._2%')
and concept_code NOT IN ('250.10','250.12','250.30','250.32','250.50')
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
201530,
443731,
376065,
443732,
443733,
443729,
201826,
40482801,
443767
);

-- technically DM2Intent from the Excel document
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_id IN (443767,376065,443732)
UNION
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
36712670,
45757277,
45757363,
37016163,
45770880,
45757449,
43531608,
43530689,
43531616,
4099216,
43531597,
37016349,
37016354,
37018912,
443731,
4222415,
4226121,
443733,
443729,
4142579,
4177050,
201826,
40482801,
45763582,
43531651,
37018728,
45769835,
45769836,
43531564,
43531578,
43531588,
45769906
)
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
