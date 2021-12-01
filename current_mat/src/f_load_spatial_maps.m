% loading all ICs
function X = load_spatial_maps( file_pat, ic_idx, n_voxels, sub_idx )
    disp( 'loading spatial maps' ) 
    n_sub = length( sub_idx );
    n_ic = length( ic_idx );
    
    X = NaN*ones( n_sub, n_ic, n_voxels );
    % load subject data
    
    %p = gcp('nocreate');
    %if isempty(p)
    %    parpool( str2num( getenv('SLURM_CPUS_PER_TASK') ) );
    %end

    for jj = 1:length( sub_idx )
        t1 = strrep( fullfile( file_pat ), '$1', num2str( sub_idx(jj) ) );
        t1 = load(t1);
        if isfield(t1, 'compSet')
            t1 = t1.compSet;
        end
        X( jj, :, : ) = t1.ic(ic_idx, :);
    end
        
    