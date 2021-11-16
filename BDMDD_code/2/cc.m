clear
clc;
diary cc.txt
load cmat.mat
starting_list=[];
KN=10;
model_id=zeros(1,KN);
indices=crossvalind('Kfold',label,KN);
pred_la=zeros(n,1);

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
    
    % save
    save(['cc',num2str(i),'.mat'],...
        'rate','sigma','gama','c','in_list','model','pred_label','dec_label',...
        'dec_values','model_id','pred_la','indices','pred_label_d','dec_label_d',...
        'dec_values_d');
end
diary off