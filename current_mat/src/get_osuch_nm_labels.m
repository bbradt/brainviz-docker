% resolved subject IDs and preprocessed data locations between the following
t1 = '/data/collaboration/NeuroMark2/Results/ICA/OSUCH/OSUCH_ica_parameter_info.mat';
sesInfo = load(t1);
sesInfo = sesInfo.sesInfo;

[~,~,list_] = xlsread('../data/osuch_abbreviated_table-08-20-2021.xlsx');
headers_ = list_(1,[1:6]);
list_ = list_(2:end,[1:6]);

t2 = {};
for ii = 1:length( sesInfo.userInput.files )
    t1 = strtrim( sesInfo.userInput.files(ii).name(1,:) );
    t2{ii, 1} = t1(1:end-2);
end

for ii = 1:length( t2 )
    ff = [];
    pat_ = num2str( list_{ii,1} );
    ff = find( contains( t2(:,1), pat_ ) );
    if ~isempty( ff )
        if length( ff ) > 1
            pat1_ = ['BP_' pat_];
            ff = find( contains( t2(:,1), pat1_ ) );
            disp( [num2str(ii) ': looking for ' pat1_ ' (' num2str( list_{ii,1} ) '), found at ' t2{ff}] )
            list_{ii, 7} = t2{ff};
        else
            disp( [num2str(ii) ': looking for ' pat_ ' (' num2str( list_{ii,1} ) '), found at ' t2{ff}] )
            list_{ii, 7} = t2{ff};
        end
    else
        pat1_ = strrep( pat_, '-', '_' );
        ff = find( contains( t2(:,1), pat1_ ) );
        if ~isempty( ff )
            disp( [num2str(ii) ': looking for ' pat1_ ' (' num2str( list_{ii,1} ) '), found at ' t2{ff}] )
            list_{ii, 7} = t2{ff};
        else
            disp( [num2str(ii) ': ' num2str( t2{ii,1} ) ' NOT FOUND '] )
        end
    end
    % break
end

% % lose the empty rows
% idx = find( cellfun( @isempty, list_(:,7) ) );
% list_(idx, :) = [];

headers_ = [headers_, {'preprocessed_data'}];
list_ = [headers_ ;list_]
writecell( list_, '../results/osuch_nm_labels.csv' )
