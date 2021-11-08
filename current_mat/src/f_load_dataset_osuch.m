function params = load_dataset_osuch( classes_ )
    domains = {'AU','CC','DM','SC','SM','VI'};
    training_data_path = '../../SVM_manifold_code/output/{}/op99';
    testing_data_path = '../../SVM_manifold_code/output/{}/op12';
    n_bd = 32;
    n_mdd = 34;
    n_voxels = 63312;
    selected_ics = [2 1 6 3 5 7];
    n_ic = length( selected_ics );

    delete(gcp('nocreate'));
    parpool( str2num( getenv('SLURM_CPUS_PER_TASK') ) );

    disp( 'load spatial maps' )
    n_sub = n_bd + n_mdd;
    nic = length( selected_ics );
    X = NaN*ones( n_sub, nic, n_voxels );
    for dd = 1:length( domains )
        parfor ii = 1:n_sub
            t1 = strrep( training_data_path, '{}', domains{dd} );
            t2 = 'op$199_ica_c$2-1.mat';
            t2 = strrep( t2, '$1', domains{dd} );
            t2 = strrep( t2, '$2', num2str( ii ) );
            ff = fullfile( t1, t2 );
            disp( ['loading ', ff] )
            t1 = load( ff );
            X( ii, dd, : ) = t1.ic( selected_ics(dd), : );
        end
    end

    disp('load labels')
    y = [ones(1, n_bd), 2*ones(1, n_mdd)]';

    params.X = X;
    params.y = y;
