function [predict_label_L, accuracy_L, dec_values_L, prob_est_L] = svm_riemann_surrogate_test_only(X, y, X_test, precomputed_model, precomputed_kernel)
    % concat the test set and update the index
    n_train = size(X, 1);
    n_test = size(X_test, 1);
    y_test = zeros(n_test, size(y, 2));
    %disp("Shapes\n\tTrain")
    %disp(size(X))
    %disp("Shapes\n\tTest")
    %disp(size(X_test))
    X_all = cat( 1, X, X_test );
    cv_idx( n_train+1 : n_train+n_test ) = -1;
    test_label = y_test;

    % compute kernel
    [n_sub, n_ic, n_voxels] = size(X_all);
    C_ = 10;
    sigma_ = 0;
    gamma_ = 1;
    % normalize
    X_norm = zeros( n_sub, n_voxels, n_ic );
    kernel_ = NaN*ones(n_test, n_sub);
    %disp('SUM NAN')
    %disp(sum(sum(isnan(kernel_))))
    if ~strcmp(precomputed_kernel, 'NONE')
        kf=load(precomputed_kernel);
        nn = size(kf.kernel, 1);
        %disp('LOAD SHAPE')
        %disp(size(kf.kernel))
        kernel_(1:nn, 1:nn) = kf.kernel;
    end
    %disp('SUM NAN')
    %disp(sum(sum(isnan(kernel_))))
    for ii = 1:n_sub
        if n_ic == 1
            tmp = squeeze( X_all( ii, :, : ) );
        else
            tmp = squeeze( X_all( ii, :, : ) )';
        end
        X_norm( ii, :, : ) = tmp*(tmp'*tmp)^(-1/2);
    end
    % compute distance
    disp('Recomputing Kernel')
    dist_ = eye( n_sub );
    for ii = 1:n_test
        for jj = ii:n_sub
            if ~isnan(kernel_(ii,jj))
                continue;
            end
            %disp('NaN!')
            %disp(ii)
            %disp(jj)
            %if ii < jj
                if n_ic == 1
                    ss_ = svd( squeeze( X_norm(ii,:,:) ) * squeeze( X_norm(jj,:,:) )' );
                else
                    ss_ = svd( squeeze( X_norm(ii,:,:) )' * squeeze( X_norm(jj,:,:) ) );
                end
                dist_(ii,jj) = real( sqrt( sum( ss_(:).^2 ) / n_ic ) );
                % dist_(jj,ii) = dist_(ii,jj);
                kernel_(ii, jj) = tanh(sigma_ + gamma_ * dist(ii, jj));
                % kernel_(jj, ii) = kernel_(ii, jj);
            %end
        end
    end
    %kernel_ = tanh( sigma_ + gamma_ * dist_ );

    % cross validation
    acc_val = [];
    acc_test = [];
    y_pred = [];
    y_val = [];
        
    % validation
    disp('Loading model')
    %model_precomputed = libsvmloadmodel(precomputed_model, size(X_test));
    load(precomputed_model)
    disp('Making predictions')
    [predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, ...
        kernel_, model_precomputed, '-b 1');
    
    

    