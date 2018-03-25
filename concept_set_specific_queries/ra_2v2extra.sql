
-- CASE of Rheumatoid Arthritis
-- https://phekb.org/phenotype/rheumatoid-arthritis-ra
drop table my_codes_src_original;
create table my_codes_src_original as
select distinct concept_code as src_concept_code, concept_id as src_concept_id, vocabulary_id as src_vocabulary_id, concept_id, vocabulary_id
from public.concept
where vocabulary_id='ICD9CM' and
concept_code IN (
'714',
'714.0',
'714.1',
'714.2'
);

-- GoldStd
drop table my_codes_src_intent;
create table my_codes_src_intent as
select distinct concept_id
from public.concept
where concept_id IN (
37108590,
37108591,
37108714,
4030552,
37117421,
4102493,
4107913,
4116439,
4114439,
4116148,
4116149,
4116440,
4115050,
4116441,
4116442,
4116443,
4114440,
4116150,
4116444,
4116151,
4115051,
4116445,
4116446,
4116152,
4114441,
4116153,
4114442,
4114443,
4114444,
4035611,
4083556,
78230,
4035427,
4343936,
4344494,
4347065,
4117686,
4115161,
4117687,
4103516,
4147418,
37395590,
4142899,
4162539,
4269880,
4271003,
4270869,
4292371,
4297649,
4299307,
4297651,
4179536,
4179378,
4179528,
4200987,
81097,
4243205,
80809,
4216531,
4311391,
44825676,
44831487,
44821123,
44836170,
1569966,
1569967,
45586833,
1569968,
45606039,
45533689,
45567403,
1569969,
45557752,
45562581,
45548248,
1569970,
45582002,
45567404,
45538622,
1569971,
45548249,
45548250,
45567405,
1569972,
45591685,
45577090,
45543428,
1569973,
45548251,
45572326,
45577091,
1569974,
45533690,
45548252,
45553036,
45577092,
1569975,
45591686,
1569976,
45586834,
45591687,
45582003,
1569977,
45562582,
45582004,
45543429,
1569978,
45543430,
45582005,
45567406,
1569979,
45591688,
45577093,
45577094,
1569980,
45548253,
45548254,
45538623,
1569981,
45577095,
45553037,
45567407,
1569982,
45601274,
45582006,
45606040,
45557754,
1569983,
45572327,
1569984,
45601275,
45553038,
45606041,
1569985,
45596425,
45586835,
45591689,
1569986,
45543431,
45562584,
45606042,
1569987,
45596426,
45606043,
45538624,
1569988,
45577096,
45533691,
45596427,
1569989,
45572328,
45567408,
45591690,
1569990,
45591691,
45538625,
45538626,
45596428,
1569991,
45586836,
1569992,
45562585,
45567409,
45557755,
1569993,
45553039,
45553040,
45533692,
1569994,
45562586,
45572329,
45582007,
1569995,
45582008,
45562587,
45601276,
1569996,
45538627,
45557756,
45548255,
1569997,
45572330,
45562588,
45567410,
1569998,
45572331,
45586837,
45557757,
45577098,
1569999,
45572332,
1570000,
45596429,
45596430,
45596431,
1570001,
45562589,
45606044,
45557758,
1570002,
45567411,
45582009,
45577099,
1570003,
45533693,
45596432,
45606045,
1570004,
45543432,
45572333,
45548256,
1570005,
45567412,
45533694,
45591692,
1570006,
45557759,
45538628,
45572334,
45577100,
1570007,
45567413,
1570008,
45538629,
45606046,
45596433,
1570009,
45567414,
45533695,
45596434,
1570010,
45548257,
45591693,
45538630,
1570011,
45591694,
45538631,
45543433,
1570012,
45591695,
45582010,
45582011,
1570013,
45548258,
45582012,
45562590,
1570014,
45538632,
45582013,
45553041,
45567415,
1570015,
45548259,
1570016,
45596435,
45577101,
45553042,
1570017,
45601277,
45591696,
45591697,
1570018,
45577102,
45601278,
45557760,
1570019,
45591698,
45572335,
45572336,
1570020,
45548260,
45533696,
45567416,
1570021,
45606047,
45591699,
45606048,
1570022,
45553043,
45606049,
45601279,
45567417,
1570023,
45543434,
1570024,
45596436,
45543435,
45567418,
1570025,
45548261,
45572337,
45562591,
1570026,
45606050,
45582014,
45553044,
1570027,
45606051,
45596437,
45582015,
1570028,
45572338,
45538633,
45567419,
1570029,
45548262,
45548263,
45533697,
1570030,
45596438,
45591700,
45596439,
45553045,
1570031,
45553046,
1570032,
45562592,
45533698,
45557761,
1570033,
45601280,
45601281,
45533699,
1570034,
45572339,
45596440,
45553047,
1570035,
45586838,
45582016,
45601282,
1570036,
45606052,
45601283,
45533700,
1570037,
45543436,
45553048,
45548264,
1570038,
45548265,
45586839,
45548266,
45553049,
35208750,
1570039,
1570040,
45596442,
1570041,
45606053,
45533701,
45591701,
1570042,
45557762,
45577104,
45577105,
1570043,
45606054,
45562593,
45577106,
1570044,
45606055,
45572340,
45577107,
1570045,
45557763,
45533702,
45577108,
1570046,
45601284,
45553051,
45538635,
1570047,
45577109,
45567420,
45533703,
45606056,
45572341,
35208751,
1570048,
45606057,
1570049,
45596443,
45591702,
45577111,
1570050,
45577112,
45601285,
45538636,
1570051,
45557764,
45572342,
45606058,
1570052,
45543437,
45606059,
45577113,
1570053,
45586840,
45601286,
45606060,
1570054,
45586841,
45562594,
45562595,
1570055,
45577114,
45586842,
45562596,
45572343,
45572344,
1570056,
45591703,
1570057,
45543438,
45606061,
45548267,
1570058,
45596444,
45553052,
45543439,
1570059,
45577115,
45586843,
45557765,
1570060,
45548268,
45606062,
45586844,
1570061,
45538638,
45596445,
45591704,
1570062,
45553053,
45562597,
45577116,
1570063,
45601287,
45548269,
45572345,
45582017,
45543440,
35208752,
1570064,
45548270,
1570065,
45572346,
45567422,
45601288,
1570066,
45538639,
45562598,
45596446,
1570067,
45577117,
45567423,
45577118,
1570068,
45606063,
45562599,
45577119,
1570069,
45543442,
45543443,
45567424,
1570070,
45601289,
45562600,
45548271,
1570071,
45606064,
45591705,
45567425,
45567426,
45586845,
35208753
);


-- Eric Jin's concept set on atlas
drop table my_codes_sno_ke_pj;
create table my_codes_sno_ke_pj as
select distinct public.concept_ancestor.descendant_concept_id as concept_id
from (select distinct concept_id from public.concept where concept_id IN (
0
)
) x
left join public.concept_ancestor on x.concept_id = public.concept_ancestor.ancestor_concept_id
order by concept_id;

-- Mimic
drop table my_codes_sno_ke_mimic;
create table my_codes_sno_ke_mimic as
select distinct concept_id
from public.concept
where concept_id IN (
4291025,
80809,
81097,
78230
)
order by concept_id;

-- Intent2v2extra (dropped 256197, added 4344166)
drop table my_codes_sno_ke_gh_optimal;
create table my_codes_sno_ke_gh_optimal as
select distinct concept_id
from public.concept
where concept_id IN (
80809,
4344166
)
UNION
select distinct c2.concept_id
from public.concept as c1
left join public.concept_ancestor as a1 on c1.concept_id = a1.ancestor_concept_id
left join public.concept c2 on c2.concept_id = a1.descendant_concept_id
where c2.invalid_reason is null
and c1.concept_id IN (
37395590,
4200987,
4035427,
78230,
4114444,
4083556,
37117421,
4035611,
81097,
4107913,
4102493,
4114443,
4142899,
4179528,
4030552,
4243205,
4216531
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
