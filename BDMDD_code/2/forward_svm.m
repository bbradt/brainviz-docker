function [rate, sigma, gama, c, in_list, model]=forward_svm(com, label, starting_list, indices, kn_i, kn)

%get the number of subjects
[n,m,v]=size(com);

%forwards selection
if( (nargin==2) || (isempty(starting_list)))
    in_list{1}=[];
    out_list{1}=1:m;
    
    for i=1:m
        n_test=length(out_list{i});
        
        disp(['***** Start to forward selection : Round ' num2str(i) '*****']);
        for j=1:n_test
            [trate(j), tsigma(j), tgama(j), tc(j), pred, tmodel{j}]=svm_manifold(com,label,[in_list{i} out_list{i}(j)], indices, kn_i, kn);
        end
        
        idx=find(trate==max(trate));
        idx=idx(1);
        
        rate(i)=trate(idx);
        sigma(i)=tsigma(idx);
        gama(i)=tgama(idx);
        c(i)=tc(idx);
        in_list{i}=[in_list{i} out_list{i}(idx)];
        out_list{i}=out_list{i}([1:idx-1 idx+1:end]);
        
        if(i<m)
            in_list{i+1}=in_list{i};
            out_list{i+1}=out_list{i};
        end
        model{i}=tmodel{idx};
        disp(['     Round ' num2str(i) ' : Acc = ' num2str(rate(i)) ' Select IC ' num2str(in_list{i})]);
        clear trate tsigma tc pred tmodel idx idx1
    end
    
else
    in_list{1}=starting_list;
    out_list{1}=1:m;
    for i=1:length(starting_list)
        id=find(out_list{1}==starting_list(i));
        out_list{1}=out_list{1}([1:id-1 id+1:end]);
    end
    
    [rate(1), sigma(1), gama(1), c(1),pred, model{1}]=svm_manifold(com,label,in_list{1});
    
    for i=1:length(out_list{1})
        disp(['***** Start to forward selection : Round ' num2str(i) '*****']);
        n_test=length(out_list{i});
        for j=1:n_test
            [trate(j), tsigma(j), tgama(j), tc(j),pred, tmodel{j}]=svm_manifold(com,label,[in_list{i} out_list{i}(j)], indices, kn_i, kn);
        end
        
        idx=find(trate==max(trate));
        idx=idx(1);
        rate(i+1)=trate(idx);
        sigma(i+1)=tsigma(idx);
        gama(i+1)=tgama(idx);
        c(i+1)=tc(idx);
        in_list{i+1}=[in_list{i} out_list{i}(idx)];
        out_list{i+1}=out_list{i}([1:idx-1 idx+1:end]);
        model{i+1}=tmodel{idx};
        disp(['     Round ' num2str(i) ' : Acc = ' num2str(rate(i+1)) ' Select IC ' num2str(in_list{i+1})]);
        clear trate tsigma tc pred tmodel idx idx1
    end
end
