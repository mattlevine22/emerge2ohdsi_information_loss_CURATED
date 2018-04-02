
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
select distinct concept_id
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
