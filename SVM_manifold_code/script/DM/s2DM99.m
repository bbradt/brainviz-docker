%% run this m file after step 1 is initialized, input should be the step1 files
clc
clear
addpath(genpath('/trdapps/linux-x86_64/matlab/toolboxes/GroupICATv4.0b/'));
addpath('/trdapps/linux-x86_64/matlab/toolboxes/spm12/');
icatb_read_batch_file('/data/users2/salman/projects/multiclass/SVM_manifold_code/script/DM/s1DM99.m');%%%%
icatb_batch_file_run('/data/users2/salman/projects/multiclass/SVM_manifold_code/script/DM/s1DM99.m');%%%%
