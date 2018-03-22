
-- Tab 2 from Ben Kummer's excel doc: comparison_XLsnomed_vsSQLstatementsnomed.xls
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
concept_code IN (
'433.01',
'433.11',
'433.21',
'433.31',
'433.81',
'433.91',
'434.01',
'434.11',
'434.91',
'434.91',
'436'
);

-- AdhdGoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
0);


-- Eric Jin's concept set on atlas
drop table my_codes_sno_ke_pj;
create table my_codes_sno_ke_pj as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from (select distinct concept_id from public.concept where concept_id IN (
0)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
order by concept_id;

-- AdhdMimic
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id
from public.concept
where concept_id IN (
0)
order by concept_id;

-- Tab 1 from Ben Kummer's excel doc: comparison_XLsnomed_vsSQLstatementsnomed.xls
-- The central SNOMED code list (header that says “additional curation”), not the left-most.
-- These are all SNOMED codes, not OMOP codes.
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_code IN (
'1055001',
'2972007',
'14309005',
'15742000',
'18322005',
'21258007',
'24654003',
'25133001',
'26954004',
'28366008',
'28790007',
'30713003',
'41713005',
'42970005',
'43658003',
'48248005',
'54519002',
'57981008',
'63795001',
'64586002',
'65084004',
'67992007',
'69533002',
'69798007',
'70607008',
'71444005',
'73192008',
'75138007',
'75543006',
'78569004',
'82797006',
'87555007',
'88922007',
'89980009',
'90520006',
'93396008',
'95455008',
'95457000',
'95458005',
'95459002',
'95460007',
'95461006',
'95830009',
'111297002',
'127170005',
'155388006',
'155401002',
'155405006',
'186317009',
'191505005',
'192759008',
'192760003',
'192771002',
'194496001',
'195180004',
'195182007',
'195183002',
'195185009',
'195186005',
'195189003',
'195190007',
'195191006',
'195194003',
'195195002',
'195212005',
'195213000',
'195214006',
'195215007',
'195216008',
'195217004',
'195229008',
'195230003',
'195232006',
'195233001',
'195234007',
'195236009',
'195247002',
'195599001',
'195600003',
'200258006',
'200259003',
'200260008',
'230222003',
'230223008',
'230224002',
'230225001',
'230285003',
'230523009',
'230691006',
'230692004',
'230693009',
'230694003',
'230695002',
'230696001',
'230698000',
'230699008',
'230700009',
'230701008',
'230702001',
'230703006',
'230714009',
'230715005',
'230720005',
'230721009',
'230722002',
'230723007',
'230731002',
'230732009',
'230735006',
'230739000',
'233964008',
'237701005',
'266253001',
'266254007',
'266312006',
'270883006',
'275434003',
'276219001',
'276220007',
'276221006',
'281240008',
'288723005',
'297138001',
'297157005',
'302878004',
'302880005',
'302881009',
'302904002',
'307363008',
'307766002',
'307767006',
'312586003',
'371040005',
'371041009',
'371121002',
'373606000',
'408664007',
'413102000',
'413758000',
'422504002',
'426107000',
'426651005',
'427020007',
'427296003',
'432504007',
'441526008',
'444657001',
'472746006',
'699706000',
'702374000',
'703161008',
'703180005',
'703184001',
'703206009',
'703311009',
'703312002',
'705128004',
'705130002',
'716051003',
'722929005',
'722930000',
'724424009',
'724425005',
'724426006',
'724429004',
'724993002',
'724994008',
'733199002',
'7931000119101',
'9611000119107',
'9901000119100',
'34181000119102',
'34181000119102',
'34191000119104',
'99451000119105',
'125081000119106',
'140911000119109',
'140921000119102',
'149821000119103',
'285161000119105',
'285171000119104',
'285191000119103',
'285201000119100',
'293811000119100',
'293831000119105',
'419691000000103',
'419701000000103',
'426661000000105',
'444581000000106',
'509351000000105',
'509371000000101',
'16023911000119100',
'16026951000119100',
'16026991000119100',
'20059004'
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
