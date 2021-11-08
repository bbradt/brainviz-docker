% loading FNC from GICA postprocess file
function X = load_fnc( ica_path, sub_idx ) 
    % get FNC from param file
    t1 = strip( ls( [ica_path '/*postprocess*'] ) );
    t1 = load( t1 );
    X = icatb_mat2vec( squeeze( t1.fnc_corrs_all ) );
    X = X( sub_idx, : );
    