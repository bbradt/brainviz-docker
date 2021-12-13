%{
    Read features from GICA output and perform classification- cross validation and testing

    Usage:
        $ matlab -batch "main --dataset <dataset> --labels <labels> --dataset_test <test dataset> --labels_test <test labels> --modality <modality> --folds <folds> --percent <percent voxels> --outpath <output directory>
        $ matlab -batch "main -d <dataset> -l '<labels>' -dt <test dataset> -lt <test labels> -m <modality> -f <folds> -p <percent voxels> -o <output directory>
        >> main( 'dataset', '<dataset>', 'labels', '<labels>', 'dataset_test', '<test dataset>', 'labels_test', '<test labels>', 'modality', '<modality>', 'folds', <folds>, 'percent', <percent voxels>, '-o', '<output directory>' )
        >> main( '-d', '<dataset>', '-l', '<labels>', '-dt', '<test dataset>', '-lt', '<test labels>', '-m', '<modality>', '-f', <folds>, '-p', <percent voxels>, '-o', '<output directory>' )

    Arguments:
    {'-d', '--dataset', 'dataset'}
        Path to GIFT output directory of the dataset used for training and cross-validation, string
    {'-l', '--label', 'label'}
        Path to labels file corresponding to the GIFT subject list, string
    {'-s', '--select_label', 'select_label'}
        comma separated list of subset of labels to run training on, string, optional
    {'-dt', '--dataset_test', 'dataset_test'}
        Path to GIFT output directory of the test dataset, string, optional
    {'-lt', '--labels_test', 'labels_test'}
        Path to labels file corresponding to the test subject list, string, optional
    {'-st', '--select_label_test', 'select_label_test'}
        comma separated list of subset of labels to run testing on, string, optional
    {'-m', '--modality', 'modality'}
        modality. possible values: sm, fnc, multi. default: sm
    {'-cm', '--concat_mode', 'concat_mode'}
        feature concatenation mode in multimodal training. for `-m multi` only. not implemented.
        possible values:
            eig (default): compute distances from different modalities, then concat the eigenvalues
            feat: concat the feaures from different modalities, then compute the distance
    {'-f', '--folds', 'folds'}
        number of folds in K-fold cross-validation, numeric. default: 10
    {'-p', '--percent', 'percent'}
        threshold fraction of voxels, numeric. default: 0.01
    {'-o', '--outpath', 'outpath'}
        output directory

    Environment variables:
    OSUCH_DEBUG
        Run analysis with 5 ICs only
    EMBARC_SITES
        comma separated list of sites in the EMBARC dataset

    Examples:
        TRAIN_DAT='../results/zfu_136_nm_ref/'
        TRAIN_LABEL='../results/zfu_136_nm_ref.csv'
        TEST_DAT='/data/collaboration/NeuroMark2/Results/ICA/LA5c/'
        TEST_LABEL='../results/la5c_ica_subjects.csv'
        matlab -batch "main -d $TRAIN_DAT -l $TRAIN_LABEL -dt $TEST_DAT -lt $TEST_LABEL -m sm -f 10 -p 0.01 -o ./"
        $ matlab -batch "main --dataset $TRAIN_DAT --labels $TRAIN_LABEL --dataset_test $TEST_DAT --labels_test $TEST_LABEL --modality sm --folds 10 --percent 0.01 --outpath ./"
        $ matlab -batch "main -d $TRAIN_DAT -l $TRAIN_LABEL -dt $TEST_DAT -lt $TEST_LABEL -m sm -f 10 -p 0.01 -o ./"

        train_dat = '../results/zfu_136_nm_ref/'
        train_label = '../results/zfu_136_nm_ref.csv'
        test_dat = '/data/collaboration/NeuroMark2/Results/ICA/LA5c/'
        test_label = '../results/la5c_ica_subjects.csv'
        >> main( 'dataset', train_dat, 'labels', train_label, 'dataset_test', test_dat, 'labels_test', test_label, 'modality', 'sm', 'folds', 10, 'percent', 0.01, 'outpath', './' )
        >> main( '-d', train_dat, '-l', train_label, '-dt', test_dat, '-lt', test_label, '-m', 'sm', '-f', 10, '-p', 0.01, '-o', './' )
%}

function main_test_only( varargin )
    % add toolboxes to path

    % default values
    dset_test = '';
    mod_ = 'sm';
    folds_ = 10;
    perc_ = 1;
    concat_mode = 'eig';
    outpath = '';
    % selected labels for subsetting data
    labels_train = [];
    labels_test = [];
    precomputed_model = 'NONE';
    precomputed_kernel = 'NONE';
    train = 0;
    
    disp( 'parse parameters' )
    for jj = 1:2:nargin
        switch varargin{jj}
        case {'-d', '--dataset', 'dataset'}
            disp( ['dataset: ' varargin{jj+1}] )
            dset_ = varargin{jj+1};
        case {'-l', '--label', 'label'}
            disp( ['training labels path: ' num2str(varargin{jj+1})] )
            labels_path_train = varargin{jj+1};
        case {'-s', '--select_label', 'select_label'}
            disp( ['selected training labels: ' num2str(varargin{jj+1})] )
            labels_train = varargin{jj+1};
        case {'-dt', '--dataset_test', 'dataset_test'}
            disp( ['test dataset: ' varargin{jj+1}] )
            dset_test = varargin{jj+1};
        case {'-lt', '--label_test', 'label_test'}
            disp( ['testing labels path: ' varargin{jj+1}] )
            labels_path_test = varargin{jj+1};
        case {'-st', '--select_label_test', 'select_label_test'}
            disp( ['selected testing labels: ' num2str(varargin{jj+1})] )
            labels_test = varargin{jj+1};
        case {'-m', '--modality', 'modality'}
            disp( ['modality: ' varargin{jj+1}] )
            mod_ = varargin{jj+1};
        case {'-cm', '--concat_mode', 'concat_mode'}
            disp( ['feature concatenation mode: ' varargin{jj+1}] )
            concat_mode = varargin{jj+1};
        case {'-f', '--folds', 'folds'}
            disp( ['folds: ' num2str( varargin{jj+1} )] )
            if ~isnumeric( varargin{jj+1} )
                folds_ = str2num( varargin{jj+1} );
            else
                folds_ = varargin{jj+1};
            end
        case {'-p', '--percent', 'percent'}
            disp( ['percent voxels: ' num2str(varargin{jj+1})] )
            if ~isnumeric( varargin{jj+1} )
                perc_ = str2num( varargin{jj+1} );
            else
                perc_ = varargin{jj+1};
            end
        case {'-o', '--outpath', 'outpath'}
            disp( ['output directory: ' varargin{jj+1}] )
            outpath = varargin{jj+1};
        case {'-pm', '--precomputed_model', 'precomputed_model'}
            disp( ['precomputed_model: ' varargin{jj+1}] )
            precomputed_model = varargin{jj+1};
        case {'-pk', '--precomputed_kernel', 'precomputed_kernel'}
            disp( ['precomputed_kernel: ' varargin{jj+1}] )
            precomputed_kernel = varargin{jj+1};
        end
    end

    % % Osuch paper replication
    % params = load_dataset_details( 'osuch', '2,3' );
    % % generate cross validation indices
    % rng( 'shuffle' )
    % cv_idx = crossvalind('Kfold', params.y, folds_);
    % acc_ = f_svm_riemann( params.X, params.y, cv_idx );
    % disp(['Best CV acc: ' num2str(acc_)])
    % return

    % collect parameters of the training set
    params      = f_load_dataset_generic( dset_, labels_path_train, labels_train );
    file_pat    = params.file_pat; % for loading spatial maps
    ica_path    = params.ica_path; % for loading FNC from postprocess file
    y           = params.y;
    n_voxels    = params.n_voxels;
    ic_labels   = params.ic_labels;
    domains     = params.domains;
    sub_idx     = [];
    if ( isfield(params, 'sub_idx') )
        sub_idx = params.sub_idx;
    end

    % collect parameters of the testing set
    test_ = 0;
    if dset_test
        test_ = 1;
        % case: surrogate dataset
        if isstring( dset_test ) | ischar( dset_test )
            params_test      = f_load_dataset_generic_bf( dset_test, labels_path_test, labels_test );
            file_pat_test    = params_test.file_pat; % for loading spatial maps
            ica_path_test    = params_test.ica_path; % for loading FNC from postprocess file
            y_test           = params_test.y;
            n_voxels_test    = params_test.n_voxels;
            sub_idx_test     = [];
            if ( isfield(params_test, 'sub_idx') )
                sub_idx_test = params_test.sub_idx;
            end
        elseif isneumeric( dset_test )
            % case: split train/test
            % todo
            % based on spltting sub_idx 
        end

        % resolve differece in class label of train and test sets
        y_unq = unique(y);
        y_unq_test = unique(y_test);
        y_test_new = zeros( size( y_test ) );
        for jj = 1:length( y_unq_test )
            idx_ = y_test == y_unq_test( jj );
            y_test_new( idx_ ) = y_unq( jj );
        end
        y_test = y_test_new;
    end

    % generate cross validation indices
    rng( 'shuffle' )
    cv_idx = crossvalind('Kfold', y, folds_);

    % get the train and test data
    if strcmp( mod_, 'sm' )
        % load training spatial maps
        X = f_load_spatial_maps( file_pat, cell2mat(ic_labels(:,1)), n_voxels, sub_idx );
        if test_
            X_test = f_load_spatial_maps_nii( file_pat_test, cell2mat(ic_labels(:,1)), n_voxels_test, sub_idx_test );
        end
        % apply voxel mask based on ttest
        [X, vox_mask] = f_threshold_sm( X, y, perc_ );
        % apply IC mask- best IC from each domain
        [X, ic_mask] = f_select_ic( X, y, ic_labels, cv_idx );
        if test_
            if n_voxels == n_voxels_test
                X_test = X_test( :, :, vox_mask );
            else
                % make sure train and test has same number of voxels
                % todo we need to make sure train/test are in the same space
                vox_test = size( X, 3 );
                X_test = f_threshold_sm( X_test, y_test, vox_test );
            end
            % apply IC mask to test data
            % X_test = X_test( :, ic_mask, : );
        end
    elseif strcmp( mod_, 'fnc' )
        % load FNC
        X = f_load_fnc( ica_path, sub_idx );
        X_test = f_load_fnc( ica_path_test, sub_idx_test );
    elseif strcmp( mod_, 'multi' )
        % load spatial maps
        X_sm = f_load_spatial_maps( file_pat, cell2mat(ic_labels(:,1)), n_voxels, sub_idx );
        % apply voxel mask based on ttest
        [X_sm, vox_mask] = f_threshold_sm( X_sm, y, perc_ );
        % apply IC mask- best IC from each domain
        [X_sm, ic_mask] = f_select_ic( X_sm, y, ic_labels, cv_idx );
        X_fnc = f_load_fnc( ica_path, sub_idx );
    end

    if ~strcmp( mod_, 'multi' )
        disp( 'prediction with the best features' )
        if strcmp(precomputed_model,'NONE')
            [acc_, acc_test, out_] = f_svm_riemann_surrogate( X, y, cv_idx, X_test, y_test );
            if outpath
                if ~exist( outpath, 'dir' )
                    mkdir( outpath );
                end
                num_ = floor( rand*10000 );
                writematrix( out_.y_pred, fullfile( outpath, ['y_pred' num2str( num_ ) '.csv'] ) );
                model_precomputed = out_.model_precomputed;
                save( fullfile( outpath, ['model_precomputed' num2str( num_ ) '.mat'] ), 'model_precomputed' );
                kernel = out_.kernel;
                save( fullfile( outpath, ['kernel' num2str( num_ ) '.mat'] ), 'kernel' );
                if exist('vox_mask', 'var')
                    save( fullfile( outpath, ['mask' num2str( num_ ) '.mat'] ), 'vox_mask' );
                end
            end
        else
            disp( 'Using precomputed model ');
            disp(precomputed_model);
            [predict_label_L, accuracy_L, dec_values_L] = f_svm_riemann_surrogate_test_only( X, y, X_test, precomputed_model, precomputed_kernel);
            save([outpath '/results.mat'], 'predict_label_L', 'accuracy_L', 'dec_values_L');
            get_correct_figures(outpath, dset_path);
            %[acc_, acc_test, out_] = f_svm_riemann_surrogate( X, y, cv_idx, X_test, y_test );
        end
    else
        disp( 'prediction with multimodal features' )
        acc_ = f_svm_kernel_multi( X_sm, X_fnc, y, cv_idx, concat_mode );
    end
    
end