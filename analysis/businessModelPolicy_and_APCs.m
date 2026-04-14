% script to observe the potential relationship between OA policy and APCs
% in for-profit journals

%% load the data
[data_table] = load_whereToPublish_data;

%% filter to keep only for-profit journals
forProfit_journals_idx = ismember(data_table.PublisherType,{'For-profit','For-profit associated with a society'});
% forProfit_journals_idx = ismember(data_table.PublisherType,{'For-profit'});
% forProfit_journals_idx = ismember(data_table.PublisherType,{'For-profit associated with a society'});
data_forProfit = data_table(forProfit_journals_idx,:);

% % alternative version: filter for one specific publisher
% forProfit_journals_idx = ismember(data_table.Publisher,{'Springer Nature'});
% forProfit_journals_idx = ismember(data_table.Publisher,{'Elsevier'});
% forProfit_journals_idx = ismember(data_table.Publisher,{'Taylor & Francis Group'});
% forProfit_journals_idx = ismember(data_table.Publisher,{'John Wiley & Sons'});
% data_forProfit = data_table(forProfit_journals_idx,:);

%% extract APCs according to publishing policy
% OA journals
% OA_journals_idx = ismember(data_forProfit.BusinessModel,{'OA','OA diamond'}); % if you want to also include OA diamond, but this is a bit
% unfair as these journals have 0€ APCs (+ not very likely as we are in the
% for-profit category)
OA_journals_idx = ismember(data_forProfit.BusinessModel,{'OA'});
OA_APCs = data_forProfit.APC___(OA_journals_idx);
% non-OA journals
nonOA_journals_idx = ismember(data_forProfit.BusinessModel,{'Hybrid','Subscription'});
nonOA_APCs = data_forProfit.APC___(nonOA_journals_idx);
% split non-OA between Hybrid and Subscription
hybrid_journals_idx = ismember(data_forProfit.BusinessModel,{'Hybrid'});
hybrid_APCs = data_forProfit.APC___(hybrid_journals_idx);
subscribe_journals_idx = ismember(data_forProfit.BusinessModel,{'Subscription'});
subscribe_APCs = data_forProfit.APC___(subscribe_journals_idx);

%% perform stats
% check if distributions can be considered normal or not
[h_norm.OA, p_norm.OA] = lillietest(OA_APCs);
[h_norm.nonOA, p_norm.nonOA] = lillietest(nonOA_APCs);
[h_norm.hybrid, p_norm.hybrid] = lillietest(hybrid_APCs);
[h_norm.subscribe, p_norm.subscribe] = lillietest(subscribe_APCs);
% perform test to compare both distributions
if h_norm.OA == 0 && h_norm.nonOA == 0 % apply t-test only if data is normal in both distributions
    [~,pval_ttest] = ttest2(OA_APCs, nonOA_APCs);
    [pval_mw, pval_ks] = deal([]);
else % use non-parametric test
    pval_ttest = [];
    [pval_mw] = ranksum(OA_APCs, nonOA_APCs); % Mann-Whitney test
    [~,pval_ks] = kstest2(OA_APCs, nonOA_APCs); % Kolmogorov-Smirnoff test
end

% extract average+SEM
[APC.OA.mean, APC.OA.sem, APC.OA.sd, APC.OA.median] = mean_sem_sd(OA_APCs,1);
[APC.nonOA.mean, APC.nonOA.sem, APC.nonOA.sd, APC.nonOA.median] = mean_sem_sd(nonOA_APCs,1);
[APC.hybrid.mean, APC.hybrid.sem, APC.hybrid.sd, APC.hybrid.median] = mean_sem_sd(hybrid_APCs,1);
[APC.subscribe.mean, APC.subscribe.sem, APC.subscribe.sd, APC.subscribe.median] = mean_sem_sd(subscribe_APCs,1);

%% display data

% just show OA vs non-OA
fig;
Violin({OA_APCs}, 1);
Violin({nonOA_APCs}, 2);
if ~isempty(pval_ttest)
    [l_hdl, star_hdl] = add_pval_comparison(OA_APCs', nonOA_APCs', pval_ttest, 1, 2);
elseif ~isempty(pval_mw) && ~isempty(pval_ks)
    % keep less significant pvalue
    max_pval = max([pval_mw, pval_ks]);
    [l_hdl, star_hdl] = add_pval_comparison(OA_APCs', nonOA_APCs', max_pval, 1, 2);
end
ylabel('APCs (€)');
xticks(1:2);
xticklabels({'OA','non-OA'});

% split data between OA, Hybrid and Subscription
fig;
Violin({OA_APCs}, 1);
Violin({hybrid_APCs}, 2);
Violin({subscribe_APCs}, 3);
ylabel('APCs (€)');
xticks(1:3);
xticklabels({'OA','Hybrid','Subscription'});