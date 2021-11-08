function params = load_dataset_generic( ica_path, varargin )
    labels_path = '';
    labels = '';
    if nargin > 1
        labels_path = varargin{1};
    end
    if nargin > 2
        labels = varargin{2};
    end
    ic_labels_path = '../results/neuromark_ic_labels.csv';
    
    % get number of voxels from param file
    t1 = strip( ls( [ica_path '*param*'] ) );
    t1 = load( t1 );
    n_voxels = numel( t1.sesInfo.mask_ind );

    % grab the domain labels
    ic_labels = readcell( ic_labels_path );
    domains = unique( sort( ic_labels(:,2) ) )
    n_domains = length( domains );

    y = [];
    sub_idx = [];
    if labels_path
        % grab the subject labels
        y = readcell( labels_path, 'delimiter', ',' );

        % % handle numeric labels
        % if iscell( y ) && ~ischar( y{1} )
        %     y = cell2mat( y );
        % end
        y = string( y );
        
        sub_idx = 1:length( y );

        % handle selected labels input
        if labels
            labels = strsplit( labels, ',' );
            sub_idx = find( ismember(y, labels) );
            y = y( sub_idx );
        end

        y = double( categorical( y ) );

        disp( ['labels: '] )
        disp( unique(y) )
    
        disp( length( sub_idx ) )
    end

    file_pat = fullfile( ica_path, [t1.sesInfo.calibrate_components_mat_file '$1-1.mat'] )

    % return values
    params.ica_path = ica_path;
    params.file_pat = file_pat;
    params.y = y;
    params.n_voxels = n_voxels;
    params.ic_labels = ic_labels;
    params.domains = domains;
    % selct particular subjects from ICA result
    params.sub_idx = sub_idx;
    
    