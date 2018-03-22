-- NOTE:
-- Codes are taken from Excel spreadsheet: "Heart Failure icd9 snomed"

-- Sheet "GoldStd", Original='y'
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_id
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
select distinct concept_id
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
select distinct public.concept_ancestor.descendant_concept_id as concept_id
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
order by concept_id;

-- SNO_ke_gh on DB (NO DESC)
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id
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
select distinct concept_id
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

-- SNO_map on DB (ALL DESC)
drop table my_codes_sno_map_all_desc;
create table my_codes_sno_map_all_desc as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from (
select public.concept_relationship.concept_id_2 as concept_id
from my_codes_src_original
left join public.concept_relationship on my_codes_src_original.concept_id = public.concept_relationship.concept_id_1
where relationship_id = 'Maps to'
and invalid_reason is null) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
order by concept_id;

-- SNO_map on DB (NO DESC)
drop table my_codes_sno_map_no_desc;
create table my_codes_sno_map_no_desc as
select distinct public.concept_relationship.concept_id_2 as concept_id
from my_codes_src_original
left join public.concept_relationship on my_codes_src_original.concept_id = public.concept_relationship.concept_id_1
where relationship_id = 'Maps to'
and invalid_reason is null
order by concept_id;

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
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from ( select distinct concept_id from desc_table where has_desc is null) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
UNION
select distinct concept_id from my_codes_sno_map_no_desc
order by concept_id;

drop table my_codes_sno_map_nodesc_if_child;
create table my_codes_sno_map_nodesc_if_child as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from ( select distinct concept_id from desc_table where has_child is null) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
UNION
select distinct concept_id from my_codes_sno_map_no_desc
order by concept_id;


-- get patient tables
drop table pats_src_original;
create table pats_src_original as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_source_concept_id IN (select concept_id from my_codes_src_original)
	order by person_id;

drop table pats_src_intent;
create table pats_src_intent as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_source_concept_id IN (select concept_id from my_codes_src_intent)
	order by person_id;


drop table pats_sno_ke_pj;
create table pats_sno_ke_pj as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_ke_pj)
	order by person_id;

drop table pats_sno_ke_mimic;
create table pats_sno_ke_mimic as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_ke_mimic) 
	order by person_id;

drop table pats_sno_map_no_desc;
create table pats_sno_map_no_desc as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_map_no_desc)
	order by person_id;

drop table pats_sno_map_all_desc;
create table pats_sno_map_all_desc as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_map_all_desc)
	order by person_id;

drop table pats_sno_map_nodesc_if_desc;
create table pats_sno_map_nodesc_if_desc as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_map_nodesc_if_desc)
	order by person_id;

drop table pats_sno_map_nodesc_if_child;
create table pats_sno_map_nodesc_if_child as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_map_nodesc_if_child)
	order by person_id;

drop table pats_sno_ke_gh_optimal;
create table pats_sno_ke_gh_optimal as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where condition_concept_id IN (select concept_id from my_codes_sno_ke_gh_optimal)
	order by person_id;


----------------------- CASE TABLE -------------------------------
create table if NOT EXISTS evaltable_concept_sets (
	idx INTEGER,
	src_file_name VARCHAR(50),
	concept_set_name VARCHAR(50),
	reference VARCHAR(50),
	comparator VARCHAR(50),
	icd9_gain INTEGER,
	icd9_loss INTEGER,
	anycodes_gain INTEGER,
	anycodes_loss INTEGER,
	num_patients_per_reference_icd9 INTEGER,
	num_patients_per_reference_anycodes INTEGER,
	num_patients_per_comparator_icd9 INTEGER,
	num_patients_per_comparator_anycodes INTEGER
);

-- 1. SNOMED-AUTO-MAP: No Desc
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'SOURCE',
	'pats_sno_map_no_desc', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_no_desc where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original 
			except SELECT person_id FROM pats_sno_map_no_desc where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_no_desc except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_sno_map_no_desc) x),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original),
	(select count(person_id) from pats_sno_map_no_desc where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_no_desc)
	);

-- 2. SNOMED-AUTO-MAP: All Desc
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'SOURCE',
	'pats_sno_map_all_desc', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_all_desc where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original
		except SELECT person_id FROM pats_sno_map_all_desc where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_all_desc except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_sno_map_all_desc) x),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original),
	(select count(person_id) from pats_sno_map_all_desc where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_all_desc)
	);


-- 3. SNOMED-AUTO-MAP: No Desc if Child below
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'SOURCE',
	'pats_sno_map_nodesc_if_child', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_child where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original
			except SELECT person_id FROM pats_sno_map_nodesc_if_child where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_child except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_sno_map_nodesc_if_child) x),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original),
	(select count(person_id) from pats_sno_map_nodesc_if_child where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_nodesc_if_child)
	);

-- 4. SNOMED-AUTO-MAP: No Desc if Desc below
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'SOURCE',
	'pats_sno_map_nodesc_if_desc', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_desc where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original
			except SELECT person_id FROM pats_sno_map_nodesc_if_desc where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_desc except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_sno_map_nodesc_if_desc) x),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original),
	(select count(person_id) from pats_sno_map_nodesc_if_desc where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_nodesc_if_desc)
	);

-- 5. SNOMED-KE: mimic original ICD9
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'SOURCE',
	'pats_sno_ke_mimic', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_mimic where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original
			except SELECT person_id FROM pats_sno_ke_mimic where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_mimic except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_sno_ke_mimic) x),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original),
	(select count(person_id) from pats_sno_ke_mimic where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_ke_mimic),
	);

-- 6. SNOMED-KE: optimize author's intent
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'SOURCE'
	,'pats_sno_ke_gh_optimal',
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_gh_optimal where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original
			except SELECT person_id FROM pats_sno_ke_gh_optimal where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_gh_optimal except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_sno_ke_gh_optimal) x),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original),
	(select count(person_id) from pats_sno_ke_gh_optimal where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_ke_gh_optimal)
	);
-- -----------------------------
-- 0. Original ICD9 source codes
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_src_original', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_original where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_original except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_src_original) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_src_original where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_original)
	);

-- 1. SNOMED-AUTO-MAP: No Desc
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_sno_map_no_desc', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_no_desc where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_sno_map_no_desc where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_no_desc except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_sno_map_no_desc) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_sno_map_no_desc where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_no_desc)
	);

-- 2. SNOMED-AUTO-MAP: All Desc
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_sno_map_all_desc', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_all_desc where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
		except SELECT person_id FROM pats_sno_map_all_desc where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_all_desc except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_sno_map_all_desc) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_sno_map_all_desc where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_all_desc)
	);


-- 3. SNOMED-AUTO-MAP: No Desc if Child below
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_sno_map_nodesc_if_child', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_child where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_sno_map_nodesc_if_child where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_child except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_sno_map_nodesc_if_child) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_sno_map_nodesc_if_child where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_nodesc_if_child)
	);

-- 4. SNOMED-AUTO-MAP: No Desc if Desc below
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_sno_map_nodesc_if_desc', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_desc where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_sno_map_nodesc_if_desc where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_map_nodesc_if_desc except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_sno_map_nodesc_if_desc) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_sno_map_nodesc_if_desc where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_map_nodesc_if_desc)
	);

-- 5. SNOMED-KE: mimic original ICD9
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_sno_ke_mimic', 
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_mimic where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_sno_ke_mimic where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_mimic except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_sno_ke_mimic) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_sno_ke_mimic where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_ke_mimic)
	);

-- 6. SNOMED-KE: optimize author's intent
INSERT INTO evaltable_concept_sets (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
Values (380, 'HeartFailurePQ_eMERGE_Local.sql', 'DxHeartFailure',
	'INTENT',
	'pats_sno_ke_gh_optimal',
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_gh_optimal where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT person_id FROM pats_sno_ke_gh_optimal where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_sno_ke_gh_optimal except SELECT person_id FROM pats_src_intent) x),
	(select count(person_id) from 
		(SELECT person_id FROM pats_src_intent except SELECT person_id FROM pats_sno_ke_gh_optimal) x),
	(select count(person_id) from pats_src_intent where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_src_intent),
	(select count(person_id) from pats_sno_ke_gh_optimal where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(person_id) from pats_sno_ke_gh_optimal)
	);

-- Number of SOURCE patients:
select count(distinct person_id) from pats_src_original;
-- case table SOURCE

-- Number of INTENT patients:
select count(distinct person_id) from pats_src_intent;
-- case table SOURCE



-- NOW, which remapped codes contribute these extras?
create table tmp_remapped as
select distinct idx, src_file_name, concept_set_name, concept_id, concept_code, src_concept_name, num_patients_per_concept_set_src_only, num_patients_per_concept_set_both, num_patients_per_concept_set_map_only, fraction_patient_gain_from_map, remapped_concept_id, remapped_concept_code, remapped_concept_name, remapped_vocabulary_id, fraction_of_gain_per_remap
from emerge_final_icd_table
where idx = 380 and fraction_of_gain_per_remap > 0 and remapped_is_in_concept_set = 0
order by fraction_patient_gain_from_map DESC, idx ASC, fraction_of_gain_per_remap DESC, concept_id ASC;

\copy tmp_remapped TO '/home/mel2193/terminology_information_loss/output/idx380_heart_failure_remapping.csv' DELIMITER '|' CSV HEADER;

drop table tmp_remapped;


-- 
