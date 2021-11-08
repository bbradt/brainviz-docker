clear
clc;

addpath(genpath('./support/svmcode'));
addpath( './bin/libsvm-3.24/matlab' )
load support/indices.mat

br={'AU','CC','DM','SC','SM','VI'};
% parpool(6)
for i=1:6
    % domain_selection(br{i}, indices);
end

com66=zeros(66,6,63312);
com12=zeros(12,6,63312);
rmIC={[1],[2:17],[1:5 7],[1 2 4 5],[1:4 6:9],[1:6 8 9]}; %%need to select the optimal component by hand
for i=1:6
    gift_root=['output/' br{i} '/op99/'];
    gift_name=['op' br{i} '99'];
    gift_info=load([gift_root gift_name '_ica_parameter_info.mat']);
    num_comp=gift_info.sesInfo.numComp;
    num_voxel=size(gift_info.sesInfo.mask_ind,1);
    clear gift_info
    comp_to_be_removed=rmIC{i};
    p_num=32;
    n_num=34;
    [com66(:,i,:),label]=get_ica_comp(gift_root, gift_name, comp_to_be_removed, num_comp, num_voxel, p_num, n_num);
    
    giftd_root=['output/' br{i} '/op12/'];
    giftd_name=['op' br{i} '12'];
    num_uk=12;%
    [com12(:,i,:),label_d]=get_ica_comp_validation(giftd_root, giftd_name, comp_to_be_removed, num_comp, num_voxel, num_uk);
end

com_all=[com66;com12];

KN=10;

pred_la=zeros(66,1);

for i=1:KN
    test_id=(indices==i);
    train_id=~test_id;
    train_com=com66(train_id,:,:);
    train_label=label(train_id);
    test_com=com66(test_id,:,:);
    test_label{i}=label(test_id);
    
    [pred_label{i},dec_label{i},dec_values{i},pred_label_d{i},dec_label_d{i},dec_values_d{i}]=svm_manifold_pd(com_all, [1:6], 0, 1, 10, label, indices, i, KN, 12);
    
    pred_la(test_id)=pred_label{i};
    
    test_result=sum(pred_label{i}==test_label{i}')/length(test_label{i});
    disp([' Test result is ' num2str(test_result)]);
    
end
% save
save('tt.mat',...
    'pred_label','dec_label','label','test_label','com66','com12',...
    'dec_values','pred_la','indices','pred_label_d','dec_label_d',...
    'dec_values_d');%%%%

% compute classification metrics
y_pred = vertcat( pred_label{:} );
y = horzcat( test_label{:} );
cp = classperf( y, y_pred )


function [] = domain_selection(br, indices) 

gift_root=['output/' br '/op99/'];%
gift_name=['op' br '99'];%
gift_info=load([gift_root gift_name '_ica_parameter_info.mat']);
num_comp=gift_info.sesInfo.numComp;
num_voxel=size(gift_info.sesInfo.mask_ind,1);
clear gift_info
comp_to_be_removed=[];
p_num=32;%
n_num=34;%
[com,label]=get_ica_comp(gift_root, gift_name, comp_to_be_removed, num_comp, num_voxel, p_num, n_num);
[n,m,v]=size(com);
starting_list=[];
KN=10;
model_id=zeros(1,KN);
pred_la=zeros(n,1);

giftd_root=['output/' br '/op12/'];%
giftd_name=['op' br '12'];%
num_uk=12;%
[com_d,label_d]=get_ica_comp_validation(giftd_root, giftd_name, comp_to_be_removed, num_comp, num_voxel, num_uk);
[n_d,m_d,v_d]=size(com_d);
com_all=[com;com_d];

for i=1:KN
    test_id=(indices==i);
    train_id=~test_id;
    train_com=com(train_id,:,:);
    train_label=label(train_id);
    test_com=com(test_id,:,:);
    test_label=label(test_id);
    %training a model
    [rate{i}, sigma{i}, gama{i}, c{i}, in_list{i}, model{i}]=forward_svm(train_com, train_label, starting_list, indices, i, KN);
    
    % test+diagnosis
    idx=find(rate{i}==max(rate{i}));
    idx=idx(1);
    model_id(i)=idx;
    disp(['Acc is ' num2str(rate{i}(model_id(i))) ' Optimal sigma is ' num2str(sigma{i}(model_id(i))) ' gama is ' num2str(gama{i}(model_id(i))) ' c is ' num2str(c{i}(model_id(i))) ]);
    disp(' list of selection is ');
    disp(in_list{i}{model_id(i)});
    
    [pred_label{i},dec_label{i},dec_values{i},pred_label_d{i},dec_label_d{i},dec_values_d{i}]=svm_manifold_pd(com_all, in_list{i}{idx}, sigma{i}(idx), gama{i}(idx), c{i}(idx), label, indices, i, KN, n_d);
    
    pred_la(test_id)=pred_label{i};
    
    test_result=sum(pred_label{i}==test_label')/length(test_label);
    disp([' Test result is ' num2str(test_result)]);
    
end
    savefile = ['cc' br '.mat']
% save
    save(savefile,...
        'rate','sigma','gama','c','in_list','model','pred_label','dec_label',...
        'dec_values','model_id','pred_la','indices','pred_label_d','dec_label_d',...
        'dec_values_d');%%%%
end
    

