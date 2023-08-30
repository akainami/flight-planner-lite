function importLocation(obj)
% importLocation Import airports, countries, regions, runways
%
% Synopsis: importLocation(obj)
%
% Input:    obj      = (required) Planet object
%
% Output:  
%
% See also: .
%

% Definition
tic;
runways = readtable('+source/Data/runways.csv');
runways = runways( ~isnan(runways.le_latitude_deg),:);
runways = runways( ~isnan(runways.he_latitude_deg),:);
runways = runways( ~isnan(runways.le_elevation_ft),:);
runways = runways( ~isnan(runways.he_elevation_ft),:);
obj.Location.Runways = runways;
fprintf('-> Runways are read in %.2f s\n',toc);

tic;
airports = readtable('+source/Data/airports.csv');
smallairports = airports(strcmp(airports.type,'small_airport'),:);
mediumairports = airports(strcmp(airports.type,'medium_airport'),:);
largeairports = airports(strcmp(airports.type,'large_airport'),:);
% airports = airports(strcmp(airports.scheduled_service,'yes'),:);
obj.Location.Airports.small = smallairports;
obj.Location.Airports.medium = mediumairports;
obj.Location.Airports.large = largeairports;
fprintf('-> Aiports are read in %.2f s\n',toc);

tic;
regions = readtable('+source/Data/regions.csv');
obj.Location.Regions = regions;
fprintf('-> Regions are read in %.2f s\n',toc);

tic;
countries = readtable('+source/Data/countries.csv');
obj.Location.Countries = countries;
fprintf('-> Countries are read in %.2f s\n',toc);

tic;
stations = readtable('+source/Data/Stations.csv');
obj.Location.Stations = stations;
fprintf('-> Waypoint Stations are read in %.f s\n',toc);
end

