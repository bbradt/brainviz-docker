function kernel_ = compute_kernel_riemann(X, sigma_, gamma_)
    % compute kernel
    [n_sub, n_ic, n_voxels] = size(X);
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

