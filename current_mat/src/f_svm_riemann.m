function acc_ = svm_riemann(X, y, cv_idx)
    % compute kernel
    [n_sub, n_ic, n_voxels] = size(X);
    C_ = 10;
    sigma_ = 0;
    gamma_ = 1;
    % normalize
    X_norm = zeros( n_sub, n_voxels, n_ic );
    for ii = 1:n_sub
        if n_ic == 1
            tmp = squeeze( X( ii, :, : ) );
        else
            tmp = squeeze( X( ii, :, : ) )';
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
    acc_ = [];
    for kk = 1:max( cv_idx )
        train_idx = cv_idx~=kk;
        test_idx = cv_idx==kk;
        train_label = y( train_idx );
        test_label = y( test_idx );
        model_precomputed = svmtrain(train_label, [(1:sum( train_idx ))', kernel_(train_idx, :)], ...
            ['-t 4 -c ' num2str(C_) ' -q']);
        [predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, ...
            [(1:sum( test_idx ))', kernel_(test_idx, :)], model_precomputed, '-q');
        acc_ = [acc_, accuracy_L(1)];
    end
    acc_ = mean(acc_);
    disp(['mean CV accuracy: ' num2str(acc_)])
