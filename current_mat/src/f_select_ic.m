% loading best ICs
% X should be already thresholded, and only ICs should be selected (no noise)
function [X_out, mask_] = f_select_ic( X, y, ic_labels, cv_idx )
    domains = unique( sort( ic_labels(:,2) ) );
    n_domains = length( domains );
    [n_sub, n_ic, n_voxels] = size(X);

    % ic dimension mask
    if getenv('OSUCH_DEBUG')
        disp('entering debug mode')
        mask_ = randi(n_ic, 2, 1);
        X_out = X( :, mask_, : );
        return
    end
    
    p = gcp('nocreate');
    if isempty(p)
        parpool( str2num( getenv('SLURM_CPUS_PER_TASK') ) );
    end

    % cycle through domains
    mask_ = {};
    parfor dd = 1:length(domains)
        ic_idx = find( strcmp( ic_labels(:,2), domains{dd} ) );
        n_ic_dom = numel( ic_idx );
        disp( ['finding best IC out of ' num2str(n_ic_dom) ' in ' domains{dd}] )

        % find best IC
        acc_ = [];
        for jj = 1:n_ic_dom
            disp(['checking IC ' num2str(jj) ' of ' num2str(n_ic_dom)])
            acc_ = [acc_; f_svm_riemann( X( :, ic_idx( jj ) , : ), y, cv_idx )];
        end
        [t1, t2] = max( acc_ );
        disp( ['best IC in ' domains{dd} ': ' num2str(t2)] )
        mask_{ dd } = ic_idx(t2);
    end
    
    mask_ = cell2mat( mask_ );
    X_out = X( :, mask_, : );
    