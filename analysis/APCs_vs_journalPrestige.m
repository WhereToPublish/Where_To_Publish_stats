% Script aimed at asserting whether there is a link between the prestige of
% a journal (H-index/Scimago rank) and the APCs that are required. The
% analysis is done for all types of journals + separately for journals that
% are for-profit and the others

%% load the data
[data_table] = load_whereToPublish_data;

%% define groups of interest
% specific groups
FP_idx = strcmp(data_table.PublisherType,'For-profit');
NP_idx = strcmp(data_table.PublisherType,'Non-profit');
UP_idx = ismember(data_table.PublisherType,{'University Press','University Press associated with a society'}); % pool together all university press
FPs_idx = strcmp(data_table.PublisherType,'For-profit associated with a society'); % create a separate category for journals associated with a society
% more global groups
ethic_idx = ismember(data_table.PublisherType,...
    {'Non-profit','University Press','University Press associated with a society'}); % pool together all university press
unethic_idx = ismember(data_table.PublisherType,...
    {'For-profit','For-profit associated with a society'});

%% extract the APCs for each category + pool non-profit and UP together in a 4th category
APC.all = data_table.APC___;
APC.FP = data_table.APC___(FP_idx);
APC.NP = data_table.APC___(NP_idx);
APC.UP = data_table.APC___(UP_idx);
APC.FP_S = data_table.APC___(FPs_idx);

% to simplify with just 2 groups
APC.ethic = data_table.APC___(ethic_idx);
APC.unethic = data_table.APC___(unethic_idx);

%% extract the "prestige" indices
% H-index
H_idx.all = data_table.HIndex;
H_idx.FP = data_table.HIndex(FP_idx);
H_idx.NP = data_table.HIndex(NP_idx);
H_idx.UP = data_table.HIndex(UP_idx);
H_idx.FP_S = data_table.HIndex(FPs_idx);

% to simplify with just 2 groups
H_idx.ethic = data_table.HIndex(ethic_idx);
H_idx.unethic = data_table.HIndex(unethic_idx);

% Scimago rank
Scimago.all = data_table.ScimagoRank;
Scimago.FP = data_table.ScimagoRank(FP_idx);
Scimago.NP = data_table.ScimagoRank(NP_idx);
Scimago.UP = data_table.ScimagoRank(UP_idx);
Scimago.FP_S = data_table.ScimagoRank(FPs_idx);

% to simplify with just 2 groups
Scimago.ethic = data_table.ScimagoRank(ethic_idx);
Scimago.unethic = data_table.ScimagoRank(unethic_idx);

%% test correlations
% H-index
[r_corr.APC_f_Hidx.all, ~, pval.APC_f_Hidx.all,...
    ~, H_idx_sorted.all, APC_fit_Hidx_sorted.all, r_corr_pval.APC_f_Hidx.all] = glm_package(H_idx.all, APC.all, 'normal', 'on');
[r_corr.APC_f_Hidx.FP, ~, pval.APC_f_Hidx.FP,...
    ~, H_idx_sorted.FP, APC_fit_Hidx_sorted.FP, r_corr_pval.APC_f_Hidx.FP] = glm_package(H_idx.FP, APC.FP, 'normal', 'on');
[r_corr.APC_f_Hidx.NP, ~, pval.APC_f_Hidx.NP,...
    ~, H_idx_sorted.NP, APC_fit_Hidx_sorted.NP, r_corr_pval.APC_f_Hidx.NP] = glm_package(H_idx.NP, APC.NP, 'normal', 'on');
[r_corr.APC_f_Hidx.UP, ~, pval.APC_f_Hidx.UP,...
    ~, H_idx_sorted.UP, APC_fit_Hidx_sorted.UP, r_corr_pval.APC_f_Hidx.UP] = glm_package(H_idx.UP, APC.UP, 'normal', 'on');
[r_corr.APC_f_Hidx.FP_S, ~, pval.APC_f_Hidx.FP_S,...
    ~, H_idx_sorted.FP_S, APC_fit_Hidx_sorted.FP_S, r_corr_pval.APC_f_Hidx.FP_S] = glm_package(H_idx.FP_S, APC.FP_S, 'normal', 'on');
[r_corr.APC_f_Hidx.ethic, ~, pval.APC_f_Hidx.ethic,...
    ~, H_idx_sorted.ethic, APC_fit_Hidx_sorted.ethic, r_corr_pval.APC_f_Hidx.ethic] = glm_package(H_idx.ethic, APC.ethic, 'normal', 'on');
[r_corr.APC_f_Hidx.unethic, ~, pval.APC_f_Hidx.unethic,...
    ~, H_idx_sorted.unethic, APC_fit_Hidx_sorted.unethic, r_corr_pval.APC_f_Hidx.unethic] = glm_package(H_idx.unethic, APC.unethic, 'normal', 'on');

% Scimago rank
[r_corr.APC_f_Scimago.all, ~, pval.APC_f_Scimago.all,...
    ~, Scimago_sorted.all, APC_fit_Scimago_sorted.all, r_corr_pval.APC_f_Scimago.all] = glm_package(Scimago.all, APC.all, 'normal', 'on');
[r_corr.APC_f_Scimago.FP, ~, pval.APC_f_Scimago.FP,...
    ~, Scimago_sorted.FP, APC_fit_Scimago_sorted.FP, r_corr_pval.APC_f_Scimago.FP] = glm_package(Scimago.FP, APC.FP, 'normal', 'on');
[r_corr.APC_f_Scimago.NP, ~, pval.APC_f_Scimago.NP,...
    ~, Scimago_sorted.NP, APC_fit_Scimago_sorted.NP, r_corr_pval.APC_f_Scimago.NP] = glm_package(Scimago.NP, APC.NP, 'normal', 'on');
[r_corr.APC_f_Scimago.UP, ~, pval.APC_f_Scimago.UP,...
    ~, Scimago_sorted.UP, APC_fit_Scimago_sorted.UP, r_corr_pval.APC_f_Scimago.UP] = glm_package(Scimago.UP, APC.UP, 'normal', 'on');
[r_corr.APC_f_Scimago.FP_S, ~, pval.APC_f_Scimago.FP_S,...
    ~, Scimago_sorted.FP_S, APC_fit_Scimago_sorted.FP_S, r_corr_pval.APC_f_Scimago.FP_S] = glm_package(Scimago.FP_S, APC.FP_S, 'normal', 'on');
[r_corr.APC_f_Scimago.ethic, ~, pval.APC_f_Scimago.ethic,...
    ~, Scimago_sorted.ethic, APC_fit_Scimago_sorted.ethic, r_corr_pval.APC_f_Scimago.ethic] = glm_package(Scimago.ethic, APC.ethic, 'normal', 'on');
[r_corr.APC_f_Scimago.unethic, ~, pval.APC_f_Scimago.unethic,...
    ~, Scimago_sorted.unethic, APC_fit_Scimago_sorted.unethic, r_corr_pval.APC_f_Scimago.unethic] = glm_package(Scimago.unethic, APC.unethic, 'normal', 'on');

% Next you can compare the For-profit to the non-profit correlations with
% the http://comparingcorrelations.org/ package

%% display corresponding figures
%% all journals
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_all_hdl = scatter(H_idx.all, APC.all);
scat_hdl_upgrade(APC_f_Hidx_all_hdl);
% fit
APC_f_Hidx_all_fit_hdl = plot(H_idx_sorted.all, APC_fit_Hidx_sorted.all);
fit_hdl_upgrade(APC_f_Hidx_all_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.all, r_corr_pval.APC_f_Hidx.all);
xlabel('H-index');
ylabel('APC all (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_all_hdl = scatter(Scimago.all, APC.all);
scat_hdl_upgrade(APC_f_Scimago_all_hdl);
% fit
APC_f_Scimago_all_fit_hdl = plot(Scimago_sorted.all, APC_fit_Scimago_sorted.all);
fit_hdl_upgrade(APC_f_Scimago_all_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.all, r_corr_pval.APC_f_Scimago.all);
xlabel('Scimago rank');
ylabel('APC all (€)');

%% For-profit
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_FP_hdl = scatter(H_idx.FP, APC.FP);
scat_hdl_upgrade(APC_f_Hidx_FP_hdl);
% fit
APC_f_Hidx_FP_fit_hdl = plot(H_idx_sorted.FP, APC_fit_Hidx_sorted.FP);
fit_hdl_upgrade(APC_f_Hidx_FP_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.FP, r_corr_pval.APC_f_Hidx.FP);
xlabel('H-index');
ylabel('APC For-profit journals (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_FP_hdl = scatter(Scimago.FP, APC.FP);
scat_hdl_upgrade(APC_f_Scimago_FP_hdl);
% fit
APC_f_Scimago_FP_fit_hdl = plot(Scimago_sorted.FP, APC_fit_Scimago_sorted.FP);
fit_hdl_upgrade(APC_f_Scimago_FP_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.FP, r_corr_pval.APC_f_Scimago.FP);
xlabel('Scimago rank');
ylabel('APC For-profit journals (€)');

%% Non-profit
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_NP_hdl = scatter(H_idx.NP, APC.NP);
scat_hdl_upgrade(APC_f_Hidx_NP_hdl);
% fit
APC_f_Hidx_NP_fit_hdl = plot(H_idx_sorted.NP, APC_fit_Hidx_sorted.NP);
fit_hdl_upgrade(APC_f_Hidx_NP_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.NP, r_corr_pval.APC_f_Hidx.NP);
xlabel('H-index');
ylabel('APC Non-profit journals (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_NP_hdl = scatter(Scimago.NP, APC.NP);
scat_hdl_upgrade(APC_f_Scimago_NP_hdl);
% fit
APC_f_Scimago_NP_fit_hdl = plot(Scimago_sorted.NP, APC_fit_Scimago_sorted.NP);
fit_hdl_upgrade(APC_f_Scimago_NP_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.NP, r_corr_pval.APC_f_Scimago.NP);
xlabel('Scimago rank');
ylabel('APC Non-profit journals (€)');

%% University Press
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_UP_hdl = scatter(H_idx.UP, APC.UP);
scat_hdl_upgrade(APC_f_Hidx_UP_hdl);
% fit
APC_f_Hidx_UP_fit_hdl = plot(H_idx_sorted.UP, APC_fit_Hidx_sorted.UP);
fit_hdl_upgrade(APC_f_Hidx_UP_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.UP, r_corr_pval.APC_f_Hidx.UP);
xlabel('H-index');
ylabel('APC University Press journals (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_UP_hdl = scatter(Scimago.UP, APC.UP);
scat_hdl_upgrade(APC_f_Scimago_UP_hdl);
% fit
APC_f_Scimago_UP_fit_hdl = plot(Scimago_sorted.UP, APC_fit_Scimago_sorted.UP);
fit_hdl_upgrade(APC_f_Scimago_UP_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.UP, r_corr_pval.APC_f_Scimago.UP);
xlabel('Scimago rank');
ylabel('APC University Press journals (€)');

%% For-profit associated with a Society
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_FP_S_hdl = scatter(H_idx.FP_S, APC.FP_S);
scat_hdl_upgrade(APC_f_Hidx_FP_S_hdl);
% fit
APC_f_Hidx_FP_S_fit_hdl = plot(H_idx_sorted.FP_S, APC_fit_Hidx_sorted.FP_S);
fit_hdl_upgrade(APC_f_Hidx_FP_S_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.FP_S, r_corr_pval.APC_f_Hidx.FP_S);
xlabel('H-index');
ylabel('APC For-profit associated with a Society (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_FP_S_hdl = scatter(Scimago.FP_S, APC.FP_S);
scat_hdl_upgrade(APC_f_Scimago_FP_S_hdl);
% fit
APC_f_Scimago_FP_S_fit_hdl = plot(Scimago_sorted.FP_S, APC_fit_Scimago_sorted.FP_S);
fit_hdl_upgrade(APC_f_Scimago_FP_S_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.FP_S, r_corr_pval.APC_f_Scimago.FP_S);
xlabel('Scimago rank');
ylabel('APC For-profit associated with a Society (€)');

%% "ethic" journals
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_ethic_hdl = scatter(H_idx.ethic, APC.ethic);
scat_hdl_upgrade(APC_f_Hidx_ethic_hdl);
% fit
APC_f_Hidx_ethic_fit_hdl = plot(H_idx_sorted.ethic, APC_fit_Hidx_sorted.ethic);
fit_hdl_upgrade(APC_f_Hidx_ethic_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.ethic, r_corr_pval.APC_f_Hidx.ethic);
xlabel('H-index');
ylabel('APC NP+UP journals (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_ethic_hdl = scatter(Scimago.ethic, APC.ethic);
scat_hdl_upgrade(APC_f_Scimago_ethic_hdl);
% fit
APC_f_Scimago_ethic_fit_hdl = plot(Scimago_sorted.ethic, APC_fit_Scimago_sorted.ethic);
fit_hdl_upgrade(APC_f_Scimago_ethic_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.ethic, r_corr_pval.APC_f_Scimago.ethic);
xlabel('Scimago rank');
ylabel('APC NP+UP journals (€)');

%% "unethic" journals
fig;

% APC = f(H-index)
subplot(1,2,1); hold on;
% raw data
APC_f_Hidx_unethic_hdl = scatter(H_idx.unethic, APC.unethic);
scat_hdl_upgrade(APC_f_Hidx_unethic_hdl);
% fit
APC_f_Hidx_unethic_fit_hdl = plot(H_idx_sorted.unethic, APC_fit_Hidx_sorted.unethic);
fit_hdl_upgrade(APC_f_Hidx_unethic_fit_hdl);
place_r_and_pval(r_corr.APC_f_Hidx.unethic, r_corr_pval.APC_f_Hidx.unethic);
xlabel('H-index');
ylabel('APC all For-profit journals (€)');

% APC = f(Scimago Rank)
subplot(1,2,2); hold on;
APC_f_Scimago_unethic_hdl = scatter(Scimago.unethic, APC.unethic);
scat_hdl_upgrade(APC_f_Scimago_unethic_hdl);
% fit
APC_f_Scimago_unethic_fit_hdl = plot(Scimago_sorted.unethic, APC_fit_Scimago_sorted.unethic);
fit_hdl_upgrade(APC_f_Scimago_unethic_fit_hdl);
place_r_and_pval(r_corr.APC_f_Scimago.unethic, r_corr_pval.APC_f_Scimago.unethic);
xlabel('Scimago rank');
ylabel('APC all For-profit journals (€)');