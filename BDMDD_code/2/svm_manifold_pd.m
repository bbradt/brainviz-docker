function [pred_label,dec_label,dec_values,pred_label_d,dec_label_d,dec_values_d]=svm_manifold_pd(com, list, sigma, gama, c, label, indices, kn_i, kn, n_d)

%get the number of subjects
[n,m,v]=size(com);

%get the number of components of each individual
m=length(list);

ncom=zeros(n,v,m);

% normalizing
for i=1:n
    if(m==1)
        tmp=(squeeze(com(i,list,:)));
        ncom(i,:)=tmp*(tmp'*tmp)^(-1/2);
    else
        tmp=(squeeze(com(i,list,:)))';
        ncom(i,:,:)=tmp*(tmp'*tmp)^(-1/2);
    end
end

%using projection matric to compute the distance
dist=eye(n);
for i=1:n-1
    for j=i:n
        if(i<j)
            if(m==1)
                s=svd(ncom(i,:)*ncom(j,:)');
            else
                s=svd(squeeze(ncom(i,:,:))'*squeeze(ncom(j,:,:)));
            end
            dist(i,j)=real(sqrt(sum(s(:).^2)/m));%ÏàËÆ¶ÈS
            dist(j,i)=dist(i,j);
        end
    end
end

kernel_=tanh(sigma+gama.*dist);

label=label(:);

kn1=kn-1;
kn1_list=1:kn;
kn1_list(kn1_list==kn_i)=[];
kni_list=(indices==kn_i);
% test+diagnosis number
test_sum=sum(kni_list);
inl=length(indices);
d_sum=n-inl;
% test+diagnosis
dec_label=zeros(test_sum,kn1);
dec_values=zeros(test_sum,kn1);%%%%
dec_label_d=zeros(n_d,kn1);
dec_values_d=zeros(n_d,kn1);%%%%

% test
for k=1:kn1
    t_list_indx=kn1_list(k);
    t_list=(indices==t_list_indx);
    notr_list=t_list|kni_list;
    train_list=~notr_list;
    train_sum=sum(train_list);
%     p_list=train_list|kni_list;
    model_precomputed = svmtrain(label(train_list), [(1:train_sum)', kernel_(train_list,train_list)], sprintf('-q -t 4 -c %f',c));
    [dec_label(:,k), accuracy_P, dec_values(:,k)] = svmpredict(label(kni_list), [(1:test_sum)', kernel_(kni_list,train_list)], model_precomputed, '-q');
end

pred_label=zeros(test_sum,1);
for i=1:test_sum
    tpred_table=tabulate(dec_label(i,:));
    [abc1,tpred_idx]=max(tpred_table(:,2));
    pred_label(i)=tpred_table(tpred_idx,1);%
end

% diagnosis
for j=1:kn1
    t_list_indx=kn1_list(j);
    t_list=(indices==t_list_indx);
    notr_list=t_list|kni_list;
    train_list=~notr_list;
    train_sum=sum(train_list);
    dp_list=[find(train_list==1)',((inl+1):n)];
    kernel_k=kernel_(1:inl,dp_list);
    kernel_d=kernel_(inl+1:end,dp_list);
    model_precomputed = svmtrain(label(train_list), [(1:train_sum)', kernel_k(train_list,:)], sprintf('-q -t 4 -c %f',c));
    [dec_label_d(:,j), accuracy_P, dec_values_d(:,j)] = svmpredict(ones(d_sum,1), [(1:d_sum)', kernel_d], model_precomputed, '-q');
end

pred_label_d=zeros(d_sum,1);
for i=1:d_sum
    tpred_table=tabulate(dec_label_d(i,:));
    [abc1,tpred_idx]=max(tpred_table(:,2));
    pred_label_d(i)=tpred_table(tpred_idx,1);%
end
