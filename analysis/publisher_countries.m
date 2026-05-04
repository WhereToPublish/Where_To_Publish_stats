% Script to load Where-to-publish database and display the country of
% origin of the publishers in a pie chart.

%% load the data
[data_table] = load_whereToPublish_data;
n_journals = size(data_table,1);

%% extract the publisher's country column
publisherCountries = data_table.Country_Publisher_;
% replace empty by "unknown" as a category
publisherCountries(strcmp(publisherCountries,'')) = {'other / unknown'};
% extract the list of all unique countries
allPubCountry_names = unique(publisherCountries);
% merge "Germany / UK" with "UK / Germany"
allPubCountry_names(strcmp(allPubCountry_names,'UK / Germany')) = [];
n_countries = length(allPubCountry_names);

%% extract number for each country
% create vector for pie chart
n_journals_perCountry = zeros(1,n_countries);
% loop through journals
for iJ = 1:n_journals
    journal_country = publisherCountries{iJ};
    if ismember(journal_country,{'Germany / UK','UK / Germany'})
        journals_country_idx = strcmp('Germany / UK', allPubCountry_names);
    else
        journals_country_idx = strcmp(journal_country, allPubCountry_names);
    end
    n_journals_perCountry(journals_country_idx) = n_journals_perCountry(journals_country_idx) + 1;
end % journals loop

%% merge

%% convert into percentage


%% display pie chart
figure;
pie(n_journals_perCountry,allPubCountry_names);