% loading best ICs
function X = load_best_spatial_maps( file_pat, y, sub_idx, cv_idx, n_voxels, ic_labels, domains, perc_ ) 
    n_domains = length( domains );
    n_sub = length(y);
    out_vox = floor( n_voxels * perc_ );

    X = NaN*ones( n_sub, n_domains, out_vox );
    % cycle through domains
    for dd = 1:length(domains)
        ic_idx = strcmp( ic_labels(:,2), domains{dd} );
        n_ic = sum( ic_idx );
        disp( ['finding best IC out of ' num2str(n_ic) ' in ' domains{dd}] )
        Xd = zeros( n_sub, n_ic, n_voxels );
        % load subject data
        x_idx = 1;
        for jj = 1:length( sub_idx )
            t1 = strrep( fullfile( file_pat ), '$1', num2str( sub_idx(jj) ) );
            t1 = load(t1);
            if isfield(t1, 'compSet')
                t1 = t1.compSet;
            end
            Xd( x_idx, :, : ) = t1.ic(ic_idx, :);
            x_idx = x_idx + 1;
        end

        % threshold spatial map- select a % of voxels
        disp('thresholding spatial maps')
        Xd = f_threshold_sm( Xd, y, perc_ );
        
        % find best IC
        acc_ = [];
        for jj = 1:n_ic
            disp(['checking IC ' num2str(jj) ' of ' num2str(n_ic)])
            acc_ = [acc_; f_svm_riemann( Xd(:,jj,:), y, cv_idx )];
        end
        [t1, t2] = max( acc_ );
        disp( ['best IC in ' domains{dd} ': ' num2str(t2)] )
        X( :, dd, : ) = Xd( :, t2, : );
    end
    