% loading all ICs
function X = f_load_spatial_maps_nii( file_pat, ic_idx, n_voxels, sub_idx )
    disp( 'loading spatial maps' ) 
    n_sub = length( sub_idx );
    n_ic = length( ic_idx );
    
    X = NaN*ones( n_sub, n_ic, n_voxels );
    % load subject data

    for jj = 1:length( sub_idx )        
        t1 = strrep( fullfile( file_pat ), '$1', num2str( sub_idx(jj) ) );
        D = icatb_loadData(t1);
        Dr = squeeze(D);
        X( jj, :, : ) = Dr;
        disp('X shape');
        disp(size(X));
    end
        
    