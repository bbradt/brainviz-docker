function [com,label]=get_ica_comp(gift_root, gift_name, comp_to_be_removed, num_comp, num_voxel, p_num, n_num)

%% select data of patients and normals
disp(['The number of BP is ' num2str(p_num)]);
disp(['The number of UP is ' num2str(n_num)]);
%%
com=zeros(p_num+n_num,num_comp,num_voxel);

% this is special designed to read old data
for i=1:p_num+n_num
    disp(['+++++++ ' num2str(i) ' +++++++']);
    load([gift_root gift_name '_ica_c' num2str(i) '-1.mat'],'ic');
    com(i,:,:)=ic;
    clear ic;
end

%remove components
if ~isempty(comp_to_be_removed)
    com(:,comp_to_be_removed,:)=[];
end

% load label information
label=[ones(1,p_num) 2.*ones(1,n_num)];