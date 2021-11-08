outputDir = '/data/users2/salman/projects/multiclass/SVM_manifold_code/output/VI/op12';%%%%%%%%%
prefix = 'opVI12';%%%%%%%%%

functional_main = '/data/analysis/collaboration/NeuroMark/Data/OSUCH/PrepData_backup/unk12/';

modalityType = 'fMRI';
dataSelectionMethod = 1;
sub_fold = dir(functional_main);
sub_fold = sub_fold(3:end);
Sub = length(sub_fold); 
numOfSess = 1;

dummy_scans = 0;
keyword_designMatrix = 'no';
input_design_matrices = {};
group_ica_type = 'spatial';
parallel_info.mode = 'serial';
parallel_info.num_workers = 8;
algoType = 16;
which_analysis = 2;
icasso_opts.sel_mode = 'randinit';  
icasso_opts.num_ica_runs = 10; 
icasso_opts.min_cluster_size = 8; 
icasso_opts.max_cluster_size = 10; 
preproc_type = 1;
maskFile ='/data/users2/salman/projects/multiclass/SVM_manifold_code/generate_mask/mean2.nii';
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%me
refFiles='/data/users2/salman/projects/multiclass/SVM_manifold_code/script/VI/VI.nii';%%%%%%%%%
sourceDir_filePattern_flagLocation{1}='/data/analysis/collaboration/NeuroMark/Data/OSUCH/PrepData_backup/unk12/';
sourceDir_filePattern_flagLocation{2}='*.nii';
sourceDir_filePattern_flagLocation{3}='data_in_subject_folder';
sourceDir_filePattern_flagLocation{4}=[];