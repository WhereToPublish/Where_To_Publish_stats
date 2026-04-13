% This script will compute the average Article Processing Charges (APCs)
% for journals that are non-profit or University Press vs journals that are
% for-profit based on the where to publish database. It will also look at
% their eventual statistical difference depending on the scheme.

%% load the data
[data_table] = load_whereToPublish_data;

%% extract the data for each category + pool non-profit and UP together in a 4th category
APC.FP = data_table.APC___(strcmp(data_table.PublisherType,'For-profit'));
APC.NP = data_table.APC___(strcmp(data_table.PublisherType,'Non-profit'));
APC.UP = data_table.APC___(ismember(data_table.PublisherType,{'University Press','University Press associated with a society'})); % pool together all university press
APC.FP_S = data_table.APC___(strcmp(data_table.PublisherType,'For-profit associated with a society')); % create a separate category for journals associated with a society

% to simplify with just 2 groups
APC.ethic = data_table.APC___(ismember(data_table.PublisherType,{'Non-profit','University Press','University Press associated with a society'})); % pool together all university press
APC.unethic = data_table.APC___(ismember(data_table.PublisherType,{'For-profit','For-profit associated with a society'}));

%% check data normality (if h=1 data is NOT normal)
[h_norm.FP, p_norm.FP] = lillietest(APC.FP);
[h_norm.NP, p_norm.NP] = lillietest(APC.NP);
[h_norm.UP, p_norm.UP] = lillietest(APC.UP);
[h_norm.FP_S, p_norm.FP_S] = lillietest(APC.FP_S);
[h_norm.ethic, p_norm.ethic] = lillietest(APC.ethic);
[h_norm.unethic, p_norm.unethic] = lillietest(APC.unethic);

%% average the APCs for each category
[FP.mean, FP.sem, FP.sd, FP.median] = mean_sem_sd(APC.FP,1);
[NP.mean, NP.sem, NP.sd, NP.median] = mean_sem_sd(APC.NP,1);
[UP.mean, UP.sem, UP.sd, UP.median] = mean_sem_sd(APC.UP,1);
[FP_S.mean, FP_S.sem, FP_S.sd, FP_S.median] = mean_sem_sd(APC.FP_S,1);
[ethic.mean, ethic.sem, ethic.sd, ethic.median] = mean_sem_sd(APC.ethic,1);
[unethic.mean, unethic.sem, unethic.sd, unethic.median] = mean_sem_sd(APC.unethic,1);

%% compare the APCs between the categories (only for normal data)
% ethic (UP+NP) vs unethic (FP + FP and society)
if h_norm.ethic == 0 && h_norm.unethic == 0
    [~, pval_ttest.ethic_vs_unethic] = ttest2(APC.ethic, APC.unethic);
end
% FP vs NP
if h_norm.FP == 0 && h_norm.NP == 0
    [~,pval_ttest.FP_vs_NP] = ttest2(APC.FP, APC.NP);
end
% FP vs UP
if h_norm.FP == 0 && h_norm.UP == 0
    [~,pval_ttest.FP_vs_UP] = ttest2(APC.FP, APC.UP);
end
% NP vs UP
if h_norm.NP == 0 && h_norm.UP == 0
    [~,pval_ttest.NP_vs_UP] = ttest2(APC.NP, APC.UP);
end
% FP vs FP and society
if h_norm.FP == 0 && h_norm.FP_S == 0
    [~,pval_ttest.FP_vs_FPS] = ttest2(APC.FP, APC.FP_S);
end

%% Kruskal-Wallis test
if h_norm.FP == 1 || h_norm.FP_S == 1 || h_norm.UP == 1 || h_norm.NP == 1 % data NOT normal => use Kruskal-Wallis
    % global Rank-Sum test
    [pval_ranksum.ethic_vs_unethic, h_ranksum.ethic_vs_unethic, stats_ranksum.ethic_vs_unethic] = ranksum(APC.ethic, APC.unethic);

    % detailled test
    all_APCs = [APC.FP; APC.FP_S; APC.UP; APC.NP];
    all_APC_names = [repmat("For-profit",length(APC.FP),1);...
        repmat("For-profit & Society",length(APC.FP_S),1);...
        repmat("University Press",length(APC.UP),1);...
        repmat("Non-profit",length(APC.NP),1)];
    [p, tbl, stats] = kruskalwallis(all_APCs, all_APC_names);

    % post-hoc 2-by-2 comparisons (Dunn-Sidak post-hoc test)
    [results, means, h, gnames] = multcompare(stats, 'CriticalValueType', 'dunn-sidak'); % Dunn & Sidak's approach
    % [results, means, h, gnames] = multcompare(stats, 'CriticalValueType', 'hsd'); % Tukey's honestly significant difference approach
    comparisonTable = array2table(results, ...
        'VariableNames', {'Group_A', 'Group_B', 'Lower_CI', 'Difference', 'Upper_CI', 'P_Value'});

    % Replace the group numbers with their actual names
    comparisonTable.Group_A = gnames(comparisonTable.Group_A);
    comparisonTable.Group_B = gnames(comparisonTable.Group_B);

    disp(comparisonTable);
end
