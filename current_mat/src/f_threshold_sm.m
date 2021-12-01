% threshold voxels based on group difference
function [X_out, mask_] = threshold_sm( X, y, perc_ ) 
    disp( 'thresholding voxels based on group difference' )
    [n_sub, n_ic, n_voxels] = size(X);
    
    % how many voxels to select?
    if perc_ < 1
        out_vox = floor( n_voxels * perc_ );
    elseif perc_ == 1
        % consider all voxels
        X_out = X;
        mask_ = ones( n_ic, n_voxels );
        return
    else
        % number of voxels has been specified, i.e. in case of test set
        out_vox = perc_;
    end
    %X_out = NaN*ones( n_sub, n_ic, out_vox );
    X_out = zeros( n_sub, n_ic, out_vox );
    mask_ = zeros( n_ic, n_voxels );
    %X_out = X;
    %mask_ = ones(n_ic, n_voxels);
    
    for ii = 1:n_ic
        t1 = reshape( X( :, ii, : ), n_sub, n_voxels);
        t2 = repmat(y, 1, n_voxels);
        [~, p] = ttest2(t1, t2);
        [~, idx] = sort( p );
        X_sorted = X( :, ii, idx );
        disp('X_sorted shape')
        disp(size(X_sorted))
        whos t1 t2 p idx
        X_out( :, ii, 1:out_vox ) = X(:, ii, 1:out_vox);
        mask_( ii, 1:out_vox ) = 1;
    end
