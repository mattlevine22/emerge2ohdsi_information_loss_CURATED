
-- Diagnoses of cataracts (note, difficult to determine difference between a code "not included" and an "exclusion code")
-- https://phekb.org/phenotype/cataracts
-- GH read the document and created his best implementation.
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
concept_code IN (
'366.10',
'366.12',
'366.13',
'366.14',
'366.15',
'366.16',
'366.17',
'366.18',
'366.19',
'366.21',
'366.30',
'366.41',
'366.45',
'366.8',
'366.9'
);

-- CataGoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
'4001501',
'4007451',
'4007944',
'4006784',
'375256',
'376400',
'4008296',
'4048060',
'4048386',
'36712945',
'36712946',
'36712947',
'37108933',
'37108934',
'37108935',
'37108936',
'4103579',
'4109424',
'439297',
'4109544',
'376973',
'381566',
'4108983',
'4070182',
'4070183',
'45757567',
'376117',
'4334868',
'4334869',
'4334870',
'4051632',
'4130588',
'379811',
'4105159',
'4210432',
'4152554',
'4199963',
'4197734',
'374646',
'381295',
'4230930',
'4259620',
'4221495',
'4225656',
'376979',
'380722',
'40479994',
'40482507',
'438749',
'376688',
'36713345',
'36713528',
'36713529',
'36713858',
'37111463',
'37111464',
'372624',
'4301387',
'432895',
'377285',
'4317977',
'4319588',
'4319589',
'44835867',
'44831165',
'44830010',
'44830011',
'44831166',
'44828913',
'44819629',
'44828914',
'44827724',
'44828915',
'44826580',
'44824186',
'44837041',
'44831167',
'44823055',
'44830013',
'44828917',
'44828918',
'44833484',
'44819630',
'44823056',
'44830014',
'44819631',
'44837043',
'44827725',
'45566724',
'45542732',
'45552382',
'45595798',
'45566734',
'1568646',
'1568647',
'1568648',
'45591297',
'45552638',
'45557376',
'45567013',
'1568649',
'45576700',
'45586421',
'45591298',
'45562204',
'1568650',
'45538241',
'45547840',
'45605643',
'45581626',
'1568651',
'45547841',
'45547842',
'45581627',
'45591299',
'1568652',
'45557377',
'45600888',
'45596049',
'45533277',
'1568653',
'45562206',
'45591300',
'45600889',
'45547843',
'1568654',
'1568655',
'45557378',
'45605645',
'45562207',
'45557379',
'45552639',
'35207543',
'1568656',
'1568666',
'45571927',
'45557382',
'45538243',
'45543007',
'1568667',
'45586423',
'45591303',
'45605649',
'45552642',
'45538244',
'45600891',
'1568668',
'45557383',
'45576703',
'45543009',
'45586424',
'1568669',
'45591304',
'45576704',
'45533282',
'45600892',
'1568670',
'45552643',
'45562214',
'45596055',
'45591305',
'1568671',
'45557384',
'35207544',
'35207545',
'35207548',
'45562203',
'45576699',
'45581628',
'45562205',
'45605644',
'45552640',
'45581629',
'45596054',
'45562213',
'45552644',
'45605651',
'45571931',
'45533286',
'45552647',
'45586428'
);


-- Eric Jin's concept set on atlas
-- http://www.ohdsi.org/web/atlas/#/cohortdefinition/143084
drop table my_codes_sno_ke_pj;
create table my_codes_sno_ke_pj as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from (select distinct concept_id from public.concept where concept_id IN (
372905,4280227,373770,4070182,4152554,443569,376688,37108935,45770920,36716448,381392,4069803,37395848,4210432,37396246,37108936,4109424,4323127,4100889,36715408,4105600,4069800,37396376,36715527,4319589,441006,381279,45757344,4230391,4070185,4105159,40482880,377274,37395915,4225656,4001501,380722,375256,4007944,4220818,4334130,4070183,372624,4154554,37396330,36716388,40487893,376117,37111650,381295,36713473,4100720,4317977,4102697,4007451,376400,37117168,4230930,44783428,4006784,4197734,36716387,4274483,372315,4051632,4099981,375546,378534,37111464,4199963,37111463,4060974,4048060,4334869,381566,44783427,37396247,36716124,4103579,377864,36717554,36712946,436118,4317976,4334870,40482507,36713803,4334867,4108983,376973,36716389,4109548,45757716,45765456,438749,443791,36713858,36714335,373769,4334868,4048386,4319588,36715121,377285,4259620,36714026,45757718,36713528,4219330,36712947,4301387,376979,379811,4225524,4217520,376399,375545,436976,37111654,37108934,439297,36716390,441846,40479994,36713345,4130588,45757567,4109544,36712945,36715372,4334129,37116290,374646,435810,4102696,4221495,4008296,37108933,36713529,4068699,432895,434145
)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
order by concept_id;

-- CataMimic
-- NOTE: GH says try with and without 375545.
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id
from public.concept
where concept_id IN (
381295,
40482507,
375256,
438749,
432895,
439297,
377285,
379811,
376400,
380722,
376973,
376979,
374646,
375545
)
order by concept_id;

-- CataIntent
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_id IN (
'4001501',
'4007451',
'4007944',
'4006784',
'375256',
'376400',
'45757344',
'4008296',
'4048060',
'4048386',
'36712945',
'36712946',
'36712947',
'37108933',
'37108934',
'37108935',
'37108936',
'375545',
'4103579',
'4109424',
'439297',
'4109544',
'376973',
'381566',
'4108983',
'4070182',
'4070183',
'45757567',
'376117',
'4334868',
'4334869',
'4334870',
'4051632',
'4130588',
'379811',
'4105159',
'4210432',
'4152554',
'4199963',
'4197734',
'374646',
'381295',
'4230930',
'4259620',
'4221495',
'4225656',
'376979',
'380722',
'40479994',
'40482507',
'438749',
'376688',
'36713345',
'36713528',
'36713529',
'36713858',
'37111463',
'37111464',
'372624',
'4301387',
'432895',
'377285',
'4317977',
'4319588',
'4319589'
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
