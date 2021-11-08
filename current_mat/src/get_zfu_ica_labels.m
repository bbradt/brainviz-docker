% resolved subject IDs and preprocessed data locations between the following
t1 = readcell('../data/zfu_prep_list.txt', 'delimiter', ' ');
[~,~,t2] = xlsread('../data/osuch_abbreviated_list.xlsx');
t2 = t2(2:end,[1, 5]);
root_ = '/data/analysis/collaboration/NeuroMark/Data/OSUCH/Data_BIDS/Raw_Data/';

for ii = 1:length( t2 )
    ff = [];
    pat_ = num2str( t2{ii,1} );
    ff = find( contains( t1, pat_ ) );
    if ~isempty( ff )
        if length( ff ) > 1
            pat1_ = ['BP_' pat_];
            ff = find( contains( t1, pat1_ ) );
            disp( [num2str(ii) ': looking for ' pat1_ ' (' num2str( t2{ii,1} ) '), found at ' t1{ff}] )
            t2{ii, 3} = [root_ t1{ff}];
        else
            disp( [num2str(ii) ': looking for ' num2str( t2{ii,1} ) ', found at ' t1{ff}] )
            t2{ii, 3} = [root_ t1{ff}];
        end
    else
        pat1_ = strrep( pat_, '-', '_' );
        ff = find( contains( t1, pat1_ ) );
        if ~isempty( ff )
            disp( [num2str(ii) ': looking for ' pat1_ ' (' num2str( t2{ii,1} ) '), found at ' t1{ff}] )
            t2{ii, 3} = [root_ t1{ff}];
        else
            disp( [num2str(ii) ': ' num2str( t2{ii,1} ) ' NOT FOUND '] )
        end
    end
    % break
end

% lose the empty rows
idx = find( cellfun( @isempty, t2(:,3) ) );
t2(idx, :) = [];

headers_ = {'subject_id', 'medication_category', 'preprocessed_data'}
t2 = [headers_ ;t2]
% writecell( t2, '../results/zfu_ica_subjects.csv' )
