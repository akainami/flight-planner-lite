function checkAlternate(Route, Aircraft, Earth)
% checkAlternate Alternate Base Assignment
%
% Synopsis: checkDivert(Route,Aircraft, Earth)
%
% Input:    Route      = (required) Mission object
%           Earth      = (required) Planet object
%           Aircraft   = (required) Aircraft object
%
% Output:
%
% See also: Base/defineBase, Mission/addDivert.
%

if strcmp(Aircraft.ACM.ICAO.designator,'B738')
    Route.Alternate.AlternatingRadius = 500e3;
    deltaDiv = Route.Alternate.AlternatingRadius;
else
    error('Import Alternating/Diversion Radius');
end

deltaNoDV = 100e3;
nNoDV = 0;
divCumRange = deltaDiv;

Route.Alternate.Base = {};

% Extract Airports to reduce computation time
airports = [Earth.Location.Airports.large; Earth.Location.Airports.medium];

latcent = interp1(Route.Distance.Cumulative,Route.Path.Lat,Route.Distance.Total/2);
loncent = interp1(Route.Distance.Cumulative,Route.Path.Lon,Route.Distance.Total/2);
airportslat = airports.latitude_deg;
airportslong = airports.longitude_deg;
% Eliminate Outside-Range Airports
iAirports = sqrt(abs((airportslat-latcent).^2+(airportslong-loncent).^2)) < 180/pi*Route.Distance.Total/earthRadius;
airports = table2struct(airports);
airports = airports(iAirports);

% Search the closest base
clat = [airports.latitude_deg];
clong = [airports.longitude_deg];

while divCumRange < Route.Distance.Total
    % Obtain Searching Central Coordinates,
    lat = interp1(Route.Distance.Cumulative,Route.Path.Lat,divCumRange);
    lon = interp1(Route.Distance.Cumulative,Route.Path.Lon,divCumRange);
    
    [~,iClosest] = min((clat-lat).^2+(clong-lon).^2);
    
    if ~isempty(clat)
        % Skip to next search point
        Route.addAlternate(Earth,'name',airports(iClosest).name);
        % Iterate
        divCumRange = divCumRange + deltaDiv;
    else
        % Iterate
        divCumRange = divCumRange + deltaNoDV;
        nNoDV = nNoDV + 1;
    end
end

if nNoDV > 0
    warning('Critical Segments Exist, Consider Adding On-Air Waypoints to Eliminate The Risk.');
end
end

