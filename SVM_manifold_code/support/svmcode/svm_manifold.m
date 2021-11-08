function [rate, sigma, gama, c, pred, model]=svm_manifold(com,label,list, indices, kn_i, kn)%最优的参数

%输入——com：“总”的成分；label：n-1个类标；list：需要的成分ID%
%返回值——最优的3个参数：sigma、gama、c；最优参数对应的svm模型和预测结果（n个）：model、pred；最优参数对应的正确率和AUC：rate、maroc%

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
dist=zeros(n)+eye(n);
for i=1:n-1
    for j=i:n
        if(i<j)
            if(m==1)
                s=svd(ncom(i,:)*ncom(j,:)');
            else
                s=svd(squeeze(ncom(i,:,:))'*squeeze(ncom(j,:,:)));
            end
            dist(i,j)=real(sqrt(sum(s(:).^2)/m));%相似度S
            dist(j,i)=dist(i,j);
            
        end
    end
end

cmin=1;
cmax=1;
cc=10.^(cmin:cmax);

sigm_set=0;
gama_set=1;

predict_label_P=zeros(n,1);
pred=zeros(n,1);

label=label(:);

kn1=kn-1;
kn1_list=1:kn;
kn1_list(kn1_list==kn_i)=[];
kni_list=(indices==kn_i);

% svm based classification

for g=1:length(gama_set)
    gama=gama_set(g);
    for i=1:length(sigm_set)
        sigm=sigm_set(i);
        kernel_=tanh(sigm+gama.*dist);
        for j=1:length(cc)
            for k=1:kn1
                test_list_indx=kn1_list(k);
                test_list=(indices==test_list_indx);
                notr_list=test_list|kni_list;
                train_list=~notr_list;
                train_list(kni_list)=[];
                test_list(kni_list)=[];
                train_sum=sum(train_list);
                test_sum=sum(test_list);
                model_precomputed = svmtrain(label(train_list), [(1:train_sum)', kernel_(train_list,:)], sprintf('-q -t 4 -c %f',cc(j)));
                [predict_label_P(test_list), accuracy_P, dec_values_P] = svmpredict(label(test_list), [(1:test_sum)', kernel_(test_list,:)], model_precomputed, '-q');
            end
            cor(g,i,j)=length(find((label(:)-predict_label_P(:))==0))/n;
        end
    end
end

iidx=find(cor==max(cor(:)));
[q,u,v]=ind2sub(size(cor),iidx);

q=q(1);
u=u(1);
v=v(1);

rate=max(cor(:));
c=cc(v);
sigma=sigm_set(u);
gama=gama_set(q);%找最优参数

kernel_=tanh(sigma+gama.*dist);

for i=1:kn1
    test_list_indx=kn1_list(i);
    test_list=(indices==test_list_indx);
    notr_list=test_list|kni_list;
    train_list=~notr_list;
    train_list(kni_list)=[];
    test_list(kni_list)=[];
    train_sum=sum(train_list);
    test_sum=sum(test_list);
    model{i} = svmtrain(label(train_list), [(1:train_sum)', kernel_(train_list,:)], sprintf('-q -t 4 -c %f',c));
    [pred(test_list), accuracy_P, dec_values_P] = svmpredict(label(test_list), [(1:test_sum)', kernel_(test_list,:)], model{i}, '-q');
end