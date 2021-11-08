function [acc_val, acc_test, out_] = svm_riemann_surrogate(X, y, cv_idx, varargin)
    % concat the test set and update the index
    X_test = varargin{1};
    y_test = varargin{2};
    n_train = size(X, 1);
    n_test = size(X_test, 1);
    X_all = cat( 1, X, X_test );
    cv_idx( n_train+1 : n_train+n_test ) = -1;
    y_all = [y; y_test];

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
    for kk = 1:max( cv_idx )
        train_idx = cv_idx > 0 & cv_idx~=kk;
        valid_idx = cv_idx > 0 & cv_idx==kk;
        test_idx = cv_idx < 0;
        train_label = y_all( train_idx );
        valid_label = y_all( valid_idx );
        test_label = y_all( test_idx );
        
        % validation
        model_precomputed = svmtrain(train_label, [(1:sum( train_idx ))', kernel_(train_idx, :)], ...
            ['-t 4 -c ' num2str(C_) ' -q']);
        [predict_label_L, accuracy_L, dec_values_L] = svmpredict(valid_label, ...
            [(1:sum( valid_idx ))', kernel_(valid_idx, :)], model_precomputed, '-q');
        acc_val = [acc_val, accuracy_L(1)];
        y_val( valid_idx ) = predict_label_L;
        
        % test
        [predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, ...
            [(1:sum( test_idx ))', kernel_(test_idx, :)], model_precomputed, '-q');
        acc_test = [acc_test, accuracy_L(1)];
        y_pred = [y_pred, predict_label_L];

        % save the precomputed model
        out_.model_precomputed{kk} = model_precomputed;
    end
    % save the training kernel
    idx = cv_idx > 0;
    out_.kernel = kernel_(idx, idx);

    % training sensitivity and specificity
    y_all_train = y_all( cv_idx > 0 );
    c = confusionmat(y_all_train, y_val);
    tp = c(1,1);
    tn = c(2,2);
    fp = c(1,2);
    fn = c(2,1);
    sen = tp/(tp+fp);
    spe = tn/(tn+fn);
    disp(['CV sensitivity: ' num2str(sen)])
    disp(['CV specificity: ' num2str(spe)])


    out_.y_pred = y_pred;
    out_.acc_val = acc_val;
    acc_val_mean = mean(acc_val);
    disp(['mean CV accuracy: ' num2str(acc_val_mean)])

    % get the best model test score
    out_.acc_test = acc_test;
    [~,t2] = max( acc_val );
    acc_test_cv = acc_test( t2 );
    out_.model_precomputed = out_.model_precomputed{t2};
    disp(['best CV model test accuracy: ' num2str(acc_test_cv)])
    disp(['best test accuracy: ' num2str( max( acc_test ) )])

    % AUC, F1 score
    [~,~,~,out_.auc] = perfcurve(y_test, y_pred(:,t2), y_test(1));
    disp(['best CV model test AUC: ' num2str(out_.auc)]);
    

    