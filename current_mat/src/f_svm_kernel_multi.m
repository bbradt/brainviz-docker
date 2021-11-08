function acc_ = svm_kernel_multi(X_sm, X_fnc, y, cv_idx, concat_mode)
    % compute kernel
    C_ = 10;
    sigma_ = 0;
    gamma_ = 1;

    % compute kernel
    [n_sub, n_ic_sm, n_voxels] = size(X_sm);
    % normalize
    X_sm_norm = zeros( n_sub, n_voxels, n_ic_sm );
    for ii = 1:n_sub
        if n_ic_sm == 1
            tmp = squeeze( X_sm( ii, :, : ) );
        else
            tmp = squeeze( X_sm( ii, :, : ) )';
        end
        X_sm_norm( ii, :, : ) = tmp*(tmp'*tmp)^(-1/2);
    end

    [n_sub, n_ic_fnc, n_voxels] = size(X_fnc);
    X_fnc_norm = zeros( n_sub, n_voxels, n_ic_fnc );
    for ii = 1:n_sub
        if n_ic_fnc == 1
            tmp = squeeze( X_fnc( ii, :, : ) );
        else
            tmp = squeeze( X_fnc( ii, :, : ) )';
        end
        X_fnc_norm( ii, :, : ) = tmp*(tmp'*tmp)^(-1/2);
    end

    % compute distance
    dist_ = eye( n_sub );
    for ii = 1:n_sub-1
        for jj = ii:n_sub
            if ii < jj
                if n_ic_sm == 1
                    ss_sm = svd( squeeze( X_sm_norm(ii,:,:) ) * squeeze( X_sm_norm(jj,:,:) )' );
                else
                    ss_sm = svd( squeeze( X_sm_norm(ii,:,:) )' * squeeze( X_sm_norm(jj,:,:) ) );
                end
                if n_ic_fnc == 1
                    ss_fnc = svd( squeeze( X_fnc_norm(ii,:,:) ) * squeeze( X_fnc_norm(jj,:,:) )' );
                else
                    ss_fnc = svd( squeeze( X_fnc_norm(ii,:,:) )' * squeeze( X_fnc_norm(jj,:,:) ) );
                end
                ss_ = [ss_sm; ss_fnc];
                dist_(ii,jj) = real( sqrt( sum( ss_(:).^2 ) / (n_ic_sm + n_ic_fnc) ) );
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
