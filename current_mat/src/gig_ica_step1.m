outputDir = '/data/users2/salman/projects/treatment_response/current_mat/results/zfu_136_nm_ref';
prefix = 'nmref136';
refFiles='/data/users2/zfu/Matlab/GSU/Neuromark_wt/ICA/Template/Neuromark_all.nii';

parallel_info.mode = 'serial';
parallel_info.num_workers = 32;

modalityType = 'fMRI';
dataSelectionMethod = 4;
numOfSess = 1;
dummy_scans = 0;
keyword_designMatrix = 'no';
input_design_matrices = {};
group_ica_type = 'spatial';
algoType = 16;
which_analysis = 2;
icasso_opts.sel_mode = 'randinit';  
icasso_opts.num_ica_runs = 10; 
icasso_opts.min_cluster_size = 8; 
icasso_opts.max_cluster_size = 10; 
preproc_type = 1;
maskFile ='/data/users2/zfu/Matlab/GSU/Neuromark/Results/Subject_selection/OSUCH/comm_mask_OSUCH.nii';
pcaType = 1;
pca_opts.stack_data = 'yes';
pca_opts.precision = 'double';
pca_opts.tolerance = 1e-4;
pca_opts.max_iter = 1000;
group_pca_type = 'subject specific';
backReconType = 5;
scaleType = 2;
numReductionSteps = 2;
doEstimation = 0; 
estimation_opts.PC1 = 'max';
estimation_opts.PC2 = 'mean';
numOfPC1 = 120;
numOfPC2 = 100;
perfType = 3;

t1 = readcell( '/data/users2/salman/projects/treatment_response/current_mat/results/zfu_ica_subjects.csv');
% for ii = 1:length( t1.Var1 )
%     ee = exist( t1.Var1{ii}, 'file' );
% end
input_data_file_patterns = t1(2:end,3);
