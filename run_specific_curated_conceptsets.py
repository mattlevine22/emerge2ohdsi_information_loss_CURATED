from term_mapping_tools import run_sql_script, create_eval_table, run_mapping

# config
output_dir = './output'
fake_etl_sql_filename = 'src/fake_condition_mappings2.sql'
evaltable_name = 'evaltable_concept_sets'
make_new_fake_condition_table = False # setting to true will erase the previous fake condition table
make_new_evaltable = False # setting to true will erase the table with the name specified in evaltable_name.


# First, create a fake condition occurrence table that runs the ETL properly and adds helpful extra columns
if make_new_fake_condition_table:
	run_sql_script(fake_etl_sql_filename)

# first, create eval table if you haven't already
if make_new_evaltable:
	create_eval_table(evaltable_name)


# Start running individual concept set analyses

############ Heart Failure ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/heart_failure3.sql'
# configure these variables for each new concept set
idx = 380
query_filename = 'HeartFailurePQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxHeartFailure' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_heart_failure/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ No Heart Failure ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/no_heart_failure3.sql'
# configure these variables for each new concept set
idx = 'NULL'
query_filename = 'HeartFailurePQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxNoHeartFailure' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_no_heart_failure/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############## ANY diabetes ##################
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/diabetes_any3.sql'
# configure these variables for each new concept set
idx = 613
query_filename = 'T2dmPQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxDm' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_diabetes_any/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############# T1DM #######
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/diabetes_t1dm3.sql'
# configure these variables for each new concept set
idx = 614
query_filename = 'T2dmPQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxT1dm' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_diabetes_t1dm/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ T2DM ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/diabetes_t2dm3.sql'
# configure these variables for each new concept set
idx = 615
query_filename = 'T2dmPQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxT2dm' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_diabetes_t2dm/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ APPENDICITIS ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/appendicitis.sql'
# configure these variables for each new concept set
idx = 33
query_filename = 'AppendicitisPQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxAppendicitis' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_appendicitis/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ ADHD ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/adhd.sql'
# configure these variables for each new concept set
idx = 22
query_filename = 'AdhdPQ_eMERGE_Local.sql' # file from sunny's big document
concept_set_name = 'DxAdhd' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_adhd/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ CATARACTS ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/cataracts.sql'
# configure these variables for each new concept set
idx = 'NULL'
query_filename = 'NULL' # file from sunny's big document
concept_set_name = 'DxCataracts' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_cataracts/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ BEN KUMMER STROKE ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/KUMMER_stroke.sql'
# configure these variables for each new concept set
idx = 'NULL'
query_filename = 'NULL' # file from sunny's big document
concept_set_name = 'DxKUMMER_stroke' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_KUMMER_stroke/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

############ CHRONS ##############
# SQL script to set up code tables
sql_filename = './src/concept_set_specific_queries/crohns.sql'
# configure these variables for each new concept set
idx = 'NULL'
query_filename = 'NULL' # file from sunny's big document
concept_set_name = 'DxCrohns' # sunny's name in the big document
output_path = '{output_dir}/idx{idx}_crohns/'.format(output_dir=output_dir, idx=idx)
run_mapping(output_path, sql_filename, idx, query_filename, concept_set_name, evaltable_name)

