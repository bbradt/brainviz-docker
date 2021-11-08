function [predict_label_L, accuracy_L, dec_values_L] = svm_riemann_surrogate_test_only(X, y, X_test)
    % concat the test set and update the index
    n_train = size(X, 1);
    n_test = size(X_test, 1);
    y_test = zeros(n_test, size(y, 2))
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
    for ii = 1:n_sub
        if n_ic == 1
            tmp = squeeze( X_all( ii, :, : ) );
        else
            tmp = squeeze( X_all( ii, :, : ) )';
        end
        X_norm( ii, :, : ) = tmp*(tmp'*tmp)^(-1/2);
    end
    % compute distance
    dist_ = eye( n_sub );
    for ii = 1:n_sub-1
        for jj = ii:n_sub
            if ii < jj
                if n_ic == 1
                    ss_ = svd( squeeze( X_norm(ii,:,:) ) * squeeze( X_norm(jj,:,:) )' );
                else
                    ss_ = svd( squeeze( X_norm(ii,:,:) )' * squeeze( X_norm(jj,:,:) ) );
                end
                dist_(ii,jj) = real( sqrt( sum( ss_(:).^2 ) / n_ic ) );
                dist_(jj,ii) = dist_(ii,jj);
            end
        end
    end
    kernel_ = tanh( sigma_ + gamma_ * dist_ );

    % cross validation
    acc_val = [];
    acc_test = [];
    y_pred = [];
    y_val = [];
        
    % validation
    model_precomputed = load('/data/users1/salman/projects/treatment_response/current_mat/results/trained_models/ad-ms_sm_masked/model_precomputed.mat');
        
    [predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, ...
        [(1:sum( test_idx ))', kernel_(test_idx, :)], model_precomputed, '-q');
    
    

    