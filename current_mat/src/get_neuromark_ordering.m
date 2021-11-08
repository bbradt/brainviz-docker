[Num_scores,FILE_ID]  = xlsread('/data/analysis/collaboration/NeuroMark/NetworkTemplate/Functional/MatchTable_High_NetworkLabling_20190301_ZN.xlsx', 'Sheet1', 'A1:K101');
ICN_idx = 10;
temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'SCN'))-1;
ICN_SC = Num_scores(temp_idx,2);

temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'AUD'))-1;
ICN_AD = Num_scores(temp_idx,2);

temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'SMN'))-1;
ICN_SM = Num_scores(temp_idx,2);

temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'VIS'))-1;
ICN_VS = Num_scores(temp_idx,2);

temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'CON'))-1;
ICN_CC = Num_scores(temp_idx,2);

temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'DMN'))-1;
ICN_DM = Num_scores(temp_idx,2);

temp_idx = find(strcmp(FILE_ID(:,ICN_idx),'CER'))-1;
ICN_CB = Num_scores(temp_idx,2);

temp_NAN = find(strcmp(FILE_ID(:,ICN_idx),'NAN'))-1;

select_ICN = [ICN_SC; ICN_AD; ICN_SM; ICN_VS; ICN_CC; ICN_DM; ICN_CB];
domain_Name = {'SCN', 'ADN', 'SMN', 'VSN', 'CON', 'DMN', 'CBN'};
domain_ICN  = {ICN_SC, ICN_AD, ICN_SM, ICN_VS, ICN_CC, ICN_DM, ICN_CB};
num_ICN  = length(select_ICN);

out_ = {};
for jj = 1:length( domain_Name )
    for ii = 1:length( domain_ICN{jj} )
        t1 = { domain_ICN{jj}(ii), domain_Name{jj} };
        out_ = [out_; t1];
    end
end
writecell( out_, '../results/neuromark_ic_labels.csv' )

