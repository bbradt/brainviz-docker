function [com,label]=get_ica_comp_validation(giftd_root, giftd_name, comp_to_be_removed, num_comp, num_voxel, num_uk)

%% select data of patients and normals
disp(['The number of UK is ' num2str(num_uk)]);
%%
com=zeros(num_uk,num_comp,num_voxel);

% this is special designed to read old data
for i=1:num_uk
    disp(['+++++++ ' num2str(i) ' +++++++']);
    load([giftd_root giftd_name '_ica_c' num2str(i) '-1.mat'],'ic');
    com(i,:,:)=ic;
    clear ic;
end

%remove components
if ~isempty(comp_to_be_removed)
    com(:,comp_to_be_removed,:)=[];
end

% load label information
label=ones(1,num_uk);
