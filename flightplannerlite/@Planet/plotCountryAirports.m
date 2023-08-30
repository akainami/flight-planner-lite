function plotCountryAirports(obj,string)
% plotCountryAirports Plot Airports of a Country
%
% Synopsis: plotCountryAirports(obj,string)
%
% Input:    obj      = (required) Mission object
%           string = (required) Country name/abbreviation
%
% Output:  
%
% See also: .
%

tic;

% Understand the region
countries = obj.Location.Countries;
try % Country Name
    row = countries( strcmp(countries.name,string),:);
    if isempty(row)
        error;
    end
catch % Country Abbreviation
    try
        row = countries( strcmp(countries.code,string),:);
        if isempty(row)
            error;
        end
    catch
        error('Country Not Found in Database.')
    end
end
code = char(row.code(1));
name = char(row.name(1));

% List all airports
ports = obj.Location.Airports;
% Small
smallports = ports.small;
smallports = smallports(strcmp(smallports.iso_country,code),:);

% Medium
mediumports = ports.medium;
mediumports = mediumports(strcmp(mediumports.iso_country,code),:);

% Large
largeports = ports.large;
largeports = largeports(strcmp(largeports.iso_country,code),:);

% Plot
figure;
geoaxes('Basemap','colorterrain')
hold on;

a1=geoplot(largeports.latitude_deg(:),largeports.longitude_deg(:),'pr','DisplayName','Large Airports');
a2=geoplot(mediumports.latitude_deg(:),mediumports.longitude_deg(:),'py','DisplayName','Medium Airports');
a3=geoplot(smallports.latitude_deg(:),smallports.longitude_deg(:),'pk','DisplayName','Small Airports');
legend([a1,a2,a3],{'Large Airports','Medium Airports','Small Airports'});

fprintf('Airports are drawn in %.2f s\n',toc);
end

