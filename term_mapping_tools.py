import os
import psycopg2 #http://initd.org/psycopg/docs/usage.html
import getpass
from psycopg2.extras import RealDictCursor
import pdb
import sys
import subprocess
import pandas as pd


# set global variables
DB = {'NAME': 'ohdsi', 'USER': 'mel2193', 'PORT': 5432, 'PASSWORD': getpass.getpass('Password:')}

LIST_OF_PAT_TABLES = [{'suffix': 'src_original', 'condition_column_name': 'condition_source_concept_id', 'do_conjunction': False},
						{'suffix': 'src_intent', 'condition_column_name': 'condition_source_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_map_no_desc', 'condition_column_name': 'condition_concept_id', 'do_conjunction': True},
						{'suffix': 'sno_map_all_desc', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_map_nodesc_if_desc', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_map_nodesc_if_child', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_pj', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_mimic', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_mimic2', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_mimic_old', 'condition_column_name': 'condition_concept_id', 'do_conjunction': True},
						{'suffix': 'sno_ke_gh_optimal', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal2', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_1a', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_1b', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_1c', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_1d', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_2a', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_2b', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_2c', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False},
						{'suffix': 'sno_ke_gh_optimal_2d', 'condition_column_name': 'condition_concept_id', 'do_conjunction': False}
]

def run_query(query_str):
	'''set up everything to make a database query'''
	query_str = query_str.replace('\n',' ')
	query_str = query_str.replace('\t',' ')
	conn = psycopg2.connect(dbname=DB['NAME'],user=DB['USER'],password=DB['PASSWORD'])
	cur = conn.cursor(cursor_factory=RealDictCursor)
	cur.execute(query_str)
	conn.commit()
	try:
		records = cur.fetchall()
		cur.close()
		conn.close()
		return records
	except:
		cur.close()
		conn.close()
		pass

def run_sql_script(sql_filename):
	print 'running',sql_filename
	call_list = ["psql",DB['NAME'],DB['USER'],"-a","-f",sql_filename]
	subprocess.call(call_list)
	print 'run succeeded!'
	# try:
	# command_str = """psql {dbname} {dbuser} -a -f {sql_filename} &> {sql_log_filename}""".format(dbname=DB['NAME'], dbuser=DB['USER'], sql_filename=sql_filename, sql_log_filename=sql_log_filename)
	# y = os.system(command_str)
	# return
	# except Exception:
	# 	print Exception
	# 	print 'run FAILED'
	# 	pdb.set_trace()
	# 	return


def table_exists(table_name):
	query_str = """SELECT * FROM information_schema.columns WHERE table_name = '{table_name}';""".format(table_name=table_name)
	table_output = run_query(query_str)
	df = pd.DataFrame(table_output)
	return len(df) > 0

def drop_table(table_name):
	if table_exists(table_name):
		drop_query_str = """drop table {table_name};""".format(table_name=table_name)
		run_query(drop_query_str)
	else:
		return

def output_table_summary(codes_table_name, output_filename):

	query_str = """select * from public.concept join {codes_table_name} using (concept_id);""".format(codes_table_name=codes_table_name)
	table_output = run_query(query_str)
	df = pd.DataFrame(table_output)
	if len(df)==0:
		return
	df = df.sort_values(by=['vocabulary_id','concept_id'])
	df.to_csv(output_filename, sep=',', index=False)

def create_eval_table(evaltable_name):
	drop_query_str = """drop table {evaltable_name};""".format(evaltable_name=evaltable_name)
	try:
		run_query(drop_query_str)
		print 'dropped ' + evaltable_name + ' table'
	except:
		print evaltable_name,'already exists...creating new table'
		pass

	query_str = """CREATE table {evaltable_name} (
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
		num_patients_per_comparator_anycodes INTEGER);""".format(evaltable_name=evaltable_name)
	try:
		run_query(query_str)
		print 'CREATED',evaltable_name,'table'
	except:
		print '--failed to create new evaltable:', evaltable_name
		print "Unexpected error:", sys.exc_info()[0]
		raise



def create_patient_table(codes_table_name, patient_table_name, condition_column_name, do_conjunction=False, codes_column_name='concept_id'):
	drop_query_str = """drop table {patient_table_name};""".format(patient_table_name=patient_table_name)
	try:
		run_query(drop_query_str)
		print 'dropped ' + patient_table_name + ' table'
	except:
		pass

	query_str = """CREATE table {patient_table_name} as
	select distinct person_id, condition_source_vocabulary_id
	from full_fake_condition_occurrence
	where {condition_column_name} IN (select {codes_column_name} from {codes_table_name})
	order by person_id;""".format(patient_table_name=patient_table_name,
								condition_column_name=condition_column_name,
								codes_column_name=codes_column_name,
								codes_table_name=codes_table_name)
	# try:
	run_query(query_str)
	print 'CREATED',patient_table_name,'table'
	# except Exception:
	# 	print Exception
	# 	print 'failed to create',patient_table_name
	# 	pdb.set_trace()

	if not do_conjunction:
		return
	print 'Now creating the conjunction table...'
	# pdb.set_trace()
	# note that conjunction is only set up to work with NODESC (i.e. it does the ANDs, but not any ORs within the ANDs)
	patient_table_name_conj = patient_table_name + '_conj'
	drop_query_str = """drop table {patient_table_name_conj};""".format(patient_table_name_conj=patient_table_name_conj)
	try:
		run_query(drop_query_str)
		print 'dropped ' + patient_table_name_conj + ' table'
	except:
		pass

	query_str = """CREATE table {patient_table_name_conj} as
		select distinct person_id, src_concept_code, condition_source_vocabulary_id
		from (
			select distinct src_concept_code, src_concept_id, src_vocabulary_id, ARRAY_AGG(concept_id) as concept_id_list, vocabulary_id
			from {codes_table_name}
			group by src_concept_code, src_concept_id, src_vocabulary_id, vocabulary_id
		) as conj_codes
		left join (
			select distinct p1.person_id, f1.condition_source_vocabulary_id, ARRAY_AGG(f1.{condition_column_name}) as code_list
			from {patient_table_name} as p1
			left join full_fake_condition_occurrence as f1 using (person_id)
			group by person_id, condition_start_date, visit_occurrence_id, f1.condition_source_vocabulary_id
		) as pats_conj
		on pats_conj.code_list @> conj_codes.concept_id_list
		order by person_id;""".format(patient_table_name_conj=patient_table_name_conj,
								patient_table_name=patient_table_name,
								codes_table_name=codes_table_name,
								condition_column_name=condition_column_name)
	try:
		run_query(query_str)
		print 'CREATED',patient_table_name_conj,'table'
	except:
		print 'failed to create conjunction table',patient_table_name_conj

def compare_patient_tables(reference_table_name, comparator_table_name, idx, query_filename, concept_set_name, evaltable_name):
	# # check if idx is specified as an integer...if not, it will be entered as null.
	# try:
	# 	idx += 1
	# except TypeError:
	# 	idx = 'NULL'
	query_str = """INSERT INTO {evaltable_name} (idx, src_file_name, concept_set_name, reference, comparator, icd9_gain, icd9_loss, anycodes_gain, anycodes_loss, num_patients_per_reference_icd9, num_patients_per_reference_anycodes, num_patients_per_comparator_icd9, num_patients_per_comparator_anycodes)
	Values ({idx}, '{query_filename}', '{concept_set_name}',
	'{reference_table_name}',
	'{comparator_table_name}',
	(select count(distinct person_id) from
		(SELECT distinct person_id FROM {comparator_table_name} where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT distinct person_id FROM {reference_table_name} where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(distinct person_id) from
		(SELECT distinct person_id FROM {reference_table_name} where condition_source_vocabulary_id = 'ICD9CM'
			except SELECT distinct person_id FROM {comparator_table_name} where condition_source_vocabulary_id = 'ICD9CM') x),
	(select count(distinct person_id) from
		(SELECT distinct person_id FROM {comparator_table_name} except SELECT distinct person_id FROM {reference_table_name}) x),
	(select count(distinct person_id) from
		(SELECT distinct person_id FROM {reference_table_name} except SELECT distinct person_id FROM {comparator_table_name}) x),
	(select count(distinct person_id) from {reference_table_name} where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(distinct person_id) from {reference_table_name}),
	(select count(distinct person_id) from {comparator_table_name} where condition_source_vocabulary_id = 'ICD9CM'),
	(select count(distinct person_id) from {comparator_table_name})
	);""".format(evaltable_name = evaltable_name,
		idx = idx,
		query_filename = query_filename,
		concept_set_name = concept_set_name,
		comparator_table_name = comparator_table_name,
		reference_table_name = reference_table_name)
	try:
		run_query(query_str)
		print 'Comparison was successful'
	except:
		print 'failed to compare tables:',reference_table_name,comparator_table_name
		# print sys.exc_info()[0]

def run_remap(source_table_name, mapped_table_name, output_filename, remap_to_any_codes=False, codes_column_name='concept_id'):
	query_str = """drop table tmp1;"""
	try:
		run_query(query_str)
	except:
		pass

	query_str = """
	CREATE table tmp1 AS
	SELECT mapped_concept_id, src_concept_id, src_concept_code, remapped_concept_id, remapped_concept_code, remapped_concept_name, remapped_vocabulary_id, remapped_mapped_from_invalid_reason
	FROM (SELECT src_concept_code, src_concept_id, {codes_column_name} as mapped_concept_id FROM {mapped_table_name}) x
	LEFT JOIN (
	SELECT concept_id_1 AS mapped_concept_id, concept_id_2 AS remapped_concept_id, invalid_reason AS remapped_mapped_from_invalid_reason
	FROM public.concept_relationship
	WHERE relationship_id = 'Mapped from'
	AND invalid_reason IS NULL
	) foo USING (mapped_concept_id)
	LEFT JOIN
		(SELECT concept_id AS remapped_concept_id, concept_name AS remapped_concept_name, domain_id AS remapped_domain_id, vocabulary_id AS remapped_vocabulary_id, standard_concept, concept_code as remapped_concept_code, invalid_reason as remapped_code_invalid_reason
		FROM public.concept
		) goo USING (remapped_concept_id)
	ORDER BY src_concept_code, remapped_concept_code;""".format(mapped_table_name=mapped_table_name, codes_column_name=codes_column_name)

	try:
		run_query(query_str)
	except:
		try:
			query_str = """CREATE table tmp1 AS
			SELECT mapped_concept_id, remapped_concept_id, remapped_concept_code, remapped_concept_name, remapped_vocabulary_id, remapped_mapped_from_invalid_reason
			FROM (SELECT {codes_column_name} as mapped_concept_id FROM {mapped_table_name}) x
			LEFT JOIN (
			SELECT concept_id_1 AS mapped_concept_id, concept_id_2 AS remapped_concept_id, invalid_reason AS remapped_mapped_from_invalid_reason
			FROM public.concept_relationship
			WHERE relationship_id = 'Mapped from'
			AND invalid_reason IS NULL
			) foo USING (mapped_concept_id)
			LEFT JOIN
				(SELECT concept_id AS remapped_concept_id, concept_name AS remapped_concept_name, domain_id AS remapped_domain_id, vocabulary_id AS remapped_vocabulary_id, standard_concept, concept_code as remapped_concept_code, invalid_reason as remapped_code_invalid_reason
				FROM public.concept
				) goo USING (remapped_concept_id)
			ORDER BY mapped_concept_id, remapped_concept_code;""".format(mapped_table_name=mapped_table_name, codes_column_name=codes_column_name)
			run_query(query_str)
		except:
			print "Unexpected error:", sys.exc_info()[0]
			raise


	query_str = """drop table remapped_codes_not_in_src;"""
	try:
		run_query(query_str)
	except:
		pass

	if remap_to_any_codes:
		query_str = """CREATE table remapped_codes_not_in_src as
		select remap.remapped_concept_id, src.src_concept_id
		from (select distinct src_concept_id from {source_table_name}) src
		full outer join (select distinct remapped_concept_id from tmp1) remap
		on src.src_concept_id = remap.remapped_concept_id
		where remapped_concept_id is not null
		or src_concept_id is not null;""".format(source_table_name=source_table_name)
	else:
		query_str = """CREATE table remapped_codes_not_in_src as
		select remap.remapped_concept_id, src.src_concept_id
		from (select distinct src_concept_id from {source_table_name}) src
		full outer join (select distinct remapped_concept_id from tmp1
			where remapped_vocabulary_id = 'ICD9CM') remap
		on src.src_concept_id = remap.remapped_concept_id
		where remapped_concept_id is not null
		or src_concept_id is not null;""".format(source_table_name=source_table_name)
	try:
		run_query(query_str)
	except:
		print "Unexpected error:", sys.exc_info()[0]
		raise


	query_list = ["""ALTER TABLE remapped_codes_not_in_src
	ADD COLUMN code_type VARCHAR(25),
	ADD COLUMN in_src_concept_set INTEGER;""",
	"""UPDATE remapped_codes_not_in_src
		set code_type = 'REMAP'
		where src_concept_id is null;""",
	"""UPDATE remapped_codes_not_in_src
		set in_src_concept_set = 0
		where src_concept_id is null;""",
	"""UPDATE remapped_codes_not_in_src
		set code_type = 'BOTH'
		where src_concept_id is not null and remapped_concept_id is not null;""",
	"""UPDATE remapped_codes_not_in_src
		set in_src_concept_set = 1
		where src_concept_id is not null and remapped_concept_id is not null;""",
	"""UPDATE remapped_codes_not_in_src
		set code_type = 'SOURCE'
		where remapped_concept_id is null;""",
	"""UPDATE remapped_codes_not_in_src
		set in_src_concept_set = 1
		where remapped_concept_id is null;""",
	"""UPDATE remapped_codes_not_in_src
		set src_concept_id = remapped_concept_id
		where src_concept_id is null;""",
	"""ALTER TABLE remapped_codes_not_in_src
	DROP COLUMN remapped_concept_id;"""]
	for query_str in query_list:
		try:
			run_query(query_str)
		except:
			print "Unexpected error:", sys.exc_info()[0]
			raise

	query_str = """DROP TABLE tmp_pats;"""
	try:
		run_query(query_str)
	except:
		pass

	query_str = """CREATE table tmp_pats as
	select distinct src_concept_id, person_id, in_src_concept_set
	from remapped_codes_not_in_src
	left join full_fake_condition_occurrence on
	(remapped_codes_not_in_src.src_concept_id = full_fake_condition_occurrence.condition_source_concept_id)
	where person_id is not null;"""
	try:
		run_query(query_str)
	except:
		print "Unexpected error:", sys.exc_info()[0]
		raise

	query_str = """drop table goo;"""
	try:
		run_query(query_str)
	except:
		pass

	query_str = """CREATE table goo as
		select ARRAY_AGG(tmp_pats.src_concept_id) as code_list, person_id, MAX(in_src_concept_set) as contains_src_code
	from tmp_pats
	where person_id is not null
	group by person_id;"""
	try:
		run_query(query_str)
	except:
		print "Unexpected error:", sys.exc_info()[0]
		raise

	query_str = """drop table remapped_code_impact;"""
	try:
		run_query(query_str)
	except:
		pass

	query_str = """CREATE table remapped_code_impact as
		select tmp1.src_concept_code, tmp1.src_concept_id, r1.*, p.*
		from (select code_list, count(distinct person_id) as num_patients, contains_src_code
			from goo
			group by code_list, contains_src_code) r1
		left join public.concept as p on p.concept_id = ANY(r1.code_list)
		left join tmp1 on concept_id = tmp1.remapped_concept_id
		order by contains_src_code ASC, num_patients DESC, src_concept_code ASC;"""
	# -- https://stackoverflow.com/questions/2486725/postgresql-join-with-array-type-with-array-elements-order-how-to-implement
	try:
		run_query(query_str)
	except:
		try:
			query_str = """CREATE table remapped_code_impact as
				select r1.*, p.*
				from (select code_list, count(distinct person_id) as num_patients, contains_src_code
					from goo
					group by code_list, contains_src_code) r1
				left join public.concept as p on p.concept_id = ANY(r1.code_list)
				order by contains_src_code ASC, num_patients DESC, code_list ASC;"""
			run_query(query_str)
		except:
			print "Unexpected error:", sys.exc_info()[0]
			raise

	try:
		query_str = """select * from remapped_code_impact;"""
		table_output = run_query(query_str)
		df = pd.DataFrame(table_output)
		if len(df)==0:
			return
		# all code-list contributions in whole patient number
		# pdb.set_trace()
		# temporary column type that turns list into string to be able to count unique rows
		df['code_list_str'] = df.code_list.apply(lambda codelist: ",".join(str(code) for code in codelist)) #"".join(row['code_list']))

		total_orig_pats = float(df.loc[df['contains_src_code']==1,['code_list_str','num_patients']].drop_duplicates().num_patients.sum())
		num_pats_gained = float(df.loc[df['contains_src_code']==0,['code_list_str','num_patients']].drop_duplicates().num_patients.sum())

		df['frac_patients_gained'] = num_pats_gained / total_orig_pats
		df['fraction_of_gain_per_remap'] = 0
		df.loc[df['contains_src_code']==0,'fraction_of_gain_per_remap'] = df.loc[df['contains_src_code']==0,'num_patients']/num_pats_gained

		df = df.sort_values(by=['contains_src_code','fraction_of_gain_per_remap','code_list_str'],ascending=[True,False,True])
		# df = df.rename(columns={'concept_id': 'concept_id'})
		df = df.drop('code_list_str', 1)
		df.to_csv(output_filename, sep='|', index=False)

		# need columns that explain how the codes arrived (for the case of auto-mappings)

	except:
		# pdb.set_trace()
		print "Can't copy remapped_code_impact table to file using python right now..."
		print "Unexpected error:", sys.exc_info()[0]
		raise

def run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name, sql_prep_filename, sql_cleanup_filename=None):

	# make output directory
	if not os.path.exists(output_path):
		os.makedirs(output_path)

	# Drop temporary tables
	run_sql_script(sql_prep_filename)

	# Call psql script to initialize needed tables
	run_sql_script(sql_filename)
	# command_str = """psql {dbname} {dbuser} -a -f {sql_filename} &> {sql_log_filename}""".format(dbname=DB['NAME'], dbuser=DB['USER'], sql_filename=sql_filename, sql_log_filename=sql_log_filename)
	# os.system(command_str)

	# create each patient table for the different concept sets
	for my_run in LIST_OF_PAT_TABLES:
		codes_table_name = 'my_codes_' + my_run['suffix']
		if not table_exists(codes_table_name):
			print my_run['suffix']
			print codes_table_name
			print "{codes_table_name} does not exist".format(codes_table_name=codes_table_name)
			continue
		fname = 'concept_set_{codes_table_name}.csv'.format(codes_table_name=codes_table_name)
		output_filename = os.path.join(output_path, fname)
		try:
			output_table_summary(codes_table_name, output_filename)
		except:
			pdb.set_trace()
		patient_table_name = 'pats_' + my_run['suffix']
		condition_column_name = my_run['condition_column_name']
		do_conjunction = my_run['do_conjunction']
		create_patient_table(codes_table_name, patient_table_name, condition_column_name, do_conjunction=do_conjunction)

	# compare patient cohort tables agains original source codes
	seed_suffix = 'src_original'
	reference_table_name = 'pats_' + seed_suffix
	for comp in LIST_OF_PAT_TABLES:
		if comp['suffix'] is seed_suffix or comp['suffix'] is 'src_intent':
			continue

		if comp['do_conjunction']:
			conj_suffix_list = ['','_conj']
		else:
			conj_suffix_list = ['']

		for conj_suffix in conj_suffix_list:
			comparator_table_name = 'pats_' + comp['suffix'] + conj_suffix
			print 'COMPARING',reference_table_name,'vs',comparator_table_name
			compare_patient_tables(reference_table_name, comparator_table_name, idx, query_filename, concept_set_name, evaltable_name)

	# compare patient cohort tables agains KE-intended original source codes
	seed_suffix = 'src_intent'
	reference_table_name = 'pats_' + seed_suffix
	for comp in LIST_OF_PAT_TABLES:
		if comp['suffix'] is seed_suffix:
			continue

		if comp['do_conjunction']:
			conj_suffix_list = ['','_conj']
		else:
			conj_suffix_list = ['']

		for conj_suffix in conj_suffix_list:
			comparator_table_name = 'pats_' + comp['suffix'] + conj_suffix
			print 'COMPARING',reference_table_name,'vs',comparator_table_name
			compare_patient_tables(reference_table_name, comparator_table_name, idx, query_filename, concept_set_name, evaltable_name)

	my_suffices = ['src_original','src_intent']
	for seed_suffix in my_suffices:
		source_table_name = 'my_codes_' + seed_suffix
		for comp in LIST_OF_PAT_TABLES:
			if comp['suffix'] in my_suffices:
				continue

			mapped_table_name = 'my_codes_' + comp['suffix']

			if not table_exists(mapped_table_name):
				print "{mapped_table_name} does not exist".format(mapped_table_name=mapped_table_name)
				continue

			print 'ANALYZING ICD9CM REMAP FOR',source_table_name,'vs',mapped_table_name

			# remap to ICD9 codes
			fname = 'remapped_icd9_code_impact_REF{seed_suffix}_VS{comp_suffix}.csv'.format(seed_suffix=seed_suffix, comp_suffix=comp['suffix'])
			output_filename = os.path.join(output_path, fname)
			run_remap(source_table_name, mapped_table_name, output_filename, remap_to_any_codes=False)

			# remap to any codes (especially interested in finding the ICD10s)
			print 'Now doing any-code remap...'
			fname = 'remapped_any_code_impact_REF{seed_suffix}_VS{comp_suffix}.csv'.format(seed_suffix=seed_suffix, comp_suffix=comp['suffix'])
			output_filename = os.path.join(output_path, fname)
			run_remap(source_table_name, mapped_table_name, output_filename, remap_to_any_codes=True)

			# run reverse
			try:
				print 'ANALYZING ICD9CM REMAP FOR',mapped_table_name,'vs',source_table_name
				# remap to ICD9 codes
				fname = 'remapped_icd9_code_impact_REF{comp_suffix}_VS{seed_suffix}.csv'.format(seed_suffix=seed_suffix, comp_suffix=comp['suffix'])
				output_filename = os.path.join(output_path, fname)
				run_remap(mapped_table_name, source_table_name, output_filename, remap_to_any_codes=False)

				print 'Now doing any-code remap...'
				# remap to any codes (especially interested in finding the ICD10s)
				fname = 'remapped_any_code_impact_REF{comp_suffix}_VS{seed_suffix}.csv'.format(seed_suffix=seed_suffix, comp_suffix=comp['suffix'])
				output_filename = os.path.join(output_path, fname)
				run_remap(mapped_table_name, source_table_name, output_filename, remap_to_any_codes=True)
			except:
				print 'Unable to run remap in reverse'

	# run cleanup
	for my_run in LIST_OF_PAT_TABLES:
		codes_table_name = 'my_codes_' + my_run['suffix']
		patient_table_name = 'pats_' + my_run['suffix']
		drop_table(codes_table_name)
		drop_table(patient_table_name)

	if sql_cleanup_filename:
		run_sql_script(sql_cleanup_filename)
