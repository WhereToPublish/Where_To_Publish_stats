function[data_table] = load_whereToPublish_data()
% [data_table] = load_whereToPublish_data()
% load_whereToPublish_data will load the where to publish database and
% create a table where the data will be stored.
%
% OUTPUTS
% data_table: table containing all the journals and all the associated
% information from the where-to-publish database.

%% working directory
curr_folder = pwd; % folder where analysis folder is located
prt_folder = fileparts(curr_folder);
data_folder = fullfile(prt_folder,'data');

%% load the data
data_path = fullfile(data_folder,'WhereToPublish.csv');
data_table = readtable(data_path);

end % function