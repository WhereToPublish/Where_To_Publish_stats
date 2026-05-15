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

    % merge categories that should go together
    if ismember(journal_country,{'Germany / UK','UK / Germany'})
        journals_country_idx = strcmp('Germany / UK', allPubCountry_names);
    else
        journals_country_idx = strcmp(journal_country, allPubCountry_names);
    end
    n_journals_perCountry(journals_country_idx) = n_journals_perCountry(journals_country_idx) + 1;
end % journals loop

%% convert into percentage
n_total_journals = sum(n_journals_perCountry,2,'omitnan');
perc_JournalsperCountry = n_journals_perCountry./n_total_journals;

%% display pie chart
figure;
set(0,'defaultfigurecolor','w'); % change matlab font from ugly grey to white
set(0,'defaultTextFontSize',15);
p = pie(n_journals_perCountry, allPubCountry_names);

% trick to improve visual properties (found here
% https://blogs.mathworks.com/graphics-and-apps/2023/11/13/pie-charts-and-donut-charts/):
% use findobj to get the set of objects with the desired "Type"
% change edges from black to white to make it look nicer
pch = findobj(p,'Type','patch');
set(pch,'EdgeColor','w','LineWidth',2);

%% filter countries which are under-represented and pool them into an "other" category
perc_threshold = 0.01;
% extract countries which are the most represented
n_journals_perCountry2 = n_journals_perCountry(perc_JournalsperCountry > perc_threshold);
perc_JournalsperCountry2 = perc_JournalsperCountry(perc_JournalsperCountry > perc_threshold);
allPubCountry_names2 = allPubCountry_names(perc_JournalsperCountry > perc_threshold);

% regroup all the remaining journals into one additional "other" category
n_other_journals = sum(n_journals_perCountry(perc_JournalsperCountry <= perc_threshold));
perc_other_journals = n_other_journals/n_total_journals;

% append the other category at the end
n_journals_perCountry2 = [n_journals_perCountry2, n_other_journals];
allPubCountry_names2{length(allPubCountry_names2)+1}= 'other';

%% display filtered pie chart
figure;
set(0,'defaultfigurecolor','w'); % change matlab font from ugly grey to white
set(0,'defaultTextFontSize',15);
p2 = pie(n_journals_perCountry2, allPubCountry_names2);

% trick to improve visual properties (found here
% https://blogs.mathworks.com/graphics-and-apps/2023/11/13/pie-charts-and-donut-charts/):
% use findobj to get the set of objects with the desired "Type"
% change edges from black to white to make it look nicer
pch2 = findobj(p2,'Type','patch');
set(pch2,'EdgeColor','w','LineWidth',2);

%% additional query to verify the % of each publisher for a given country
country_to_check = 'Switzerland';
publishers_for_that_country = data_table.Publisher(strcmp(publisherCountries,country_to_check));
pubForThatCountry_names = unique(publishers_for_that_country);
n_publishers = length(pubForThatCountry_names);
[n_PublishersForThatCountry, perc_PublishersForThatCountry] = deal(NaN(n_publishers,1));
for iPub = 1:n_publishers
    pub_nm = pubForThatCountry_names{iPub};
    n_PublishersForThatCountry(iPub) = sum(strcmp(publishers_for_that_country,pub_nm));
    perc_PublishersForThatCountry(iPub) = n_PublishersForThatCountry(iPub)./length(publishers_for_that_country);
end % publishers loop