%% Batch script for running gica

icasso_opts.sel_mode = 'randinit';
icasso_opts.num_ica_runs = 10;
icasso_opts.min_cluster_size = 8;
icasso_opts.max_cluster_size = 10;

mst_opts.num_ica_runs = 10;
%% Design matrix/matrices
keyword_designMatrix = 'no';

%% Performance type
perfType = 1;
%% Reliability analysis
which_analysis = 1;
%% Output directory
outputDir = '/out';

%% Output files prefix
prefix = 'gica_cmd';

dataSelectionMethod = 4;

%% Input file patterns
input_data_file_patterns = {'/input_data/test_subject/test_session/test_func_pp_2/SmNSprest.nii';
};

%% Dummy scans
dummy_scans = 0;
%% Input mask
maskFile = '';

%% Group PCA type 
group_pca_type = 'subject specific';
%% PCA Algorithm
pcaType = 'Standard';
%% ICA Algorithm
algoType = 16;
%% Back-reconstruction type
backReconType = 1;
%% Pre-processing type
preproc_type = 1;
%% Number of data reduction steps
numReductionSteps = 2;
%% MDL Estimation 
doEstimation = 0;
%% Number of PC in the first PCA step
numOfPC1 = 53;
%% Number of PC in the second PCA step
numOfPC2 = 53;
%% Scaling type 
scaleType = 0;
%% Spatial references 
refFiles = {'/brainforge/backend_env/brainforge/test_data/NeuroMark.nii';
};

%% Report generator 
display_results = 1;
%% Network summary options 
network_summary_opts.comp_network_names = {};

network_summary_opts.threshold = 1;
network_summary_opts.conn_threshold = 0.0;
network_summary_opts.save_info = 1;
network_summary_opts.format = 'html';
network_summary_opts.convert_to_z = 'yes';
