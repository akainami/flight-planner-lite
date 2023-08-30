function waypoints(Route)
% waypoints Waypoints on Great Circle between two points
%
% Synopsis: waypoints(Route)
%
% Input:    Route      = (required) Mission object
%
% Output:
%
% See also: gcwaypts, earthRadius.
%

% Obtain Coordinates
wpsCell = {Route.Departure};
for iB = 1 : length(Route.WaypointBases)
    wpsCell{iB+1} = Route.WaypointBases{iB};
end
wpsCell{end+1} = Route.Arrival;

% Define Path Properties
% WGS84 referred
n = 100; % n track legs for each station

% Obtain way-points through spherical trigonometry and great circle waypoints
latCell = cell(length(wpsCell)-1,1);
lonCell = cell(length(wpsCell)-1,1);
Route.Distance.GreatCircleWP = zeros(length(wpsCell)-1,1);
Route.Distance.GreatCircleWPCumulative = zeros(length(wpsCell)-1,1);
for iW = 1 : length(wpsCell)-1
    LatDep = wpsCell{iW}.Latitude;
    LatArr = wpsCell{iW+1}.Latitude;
    LonDep = wpsCell{iW}.Longitude;
    LonArr = wpsCell{iW+1}.Longitude;
    [latCell{iW},lonCell{iW}] = gcwaypts(LatDep,LonDep,LatArr,LonArr,n);
    
    Route.Path.TargetLon(iW) = LonArr;
    Route.Path.TargetLat(iW) = LatArr;
    Route.Distance.GreatCircleWP(iW) = deg2km(distance(LatDep,LonDep,LatArr,LonArr))*1e3;
    Route.Distance.GreatCircleWPCumulative(iW) = sum(Route.Distance.GreatCircleWP);
end

Route.Path.Lat = latCell{1};
Route.Path.Lon = lonCell{1};

[Route.Path.GreatCircleLat,Route.Path.GreatCircleLon] = gcwaypts(wpsCell{1}.Latitude,wpsCell{1}.Longitude,wpsCell{end}.Latitude,wpsCell{end}.Longitude,n);

for iW = 1 : length(wpsCell)-2
    dum = latCell{iW+1};
    Route.Path.Lat = [Route.Path.Lat;dum(2:end)];
    dum = lonCell{iW+1};
    Route.Path.Lon = [Route.Path.Lon;dum(2:end)];
end

% Measure Distances between waypoints
for i = 1 : length(Route.Path.Lat)-1
    % Use Haversine Formula
    Route.Distance.Waypoints(i) = 2*earthRadius*asin(sqrt(sind((Route.Path.Lat(i+1)-Route.Path.Lat(i))/2)^2+...
        cosd(Route.Path.Lat(i))*cosd(Route.Path.Lat(i+1))*sind((Route.Path.Lon(i+1)-Route.Path.Lon(i))/2)^2));
end

Route.Distance.Total = sum(Route.Distance.Waypoints);
Route.Distance.Cumulative = zeros(1,length(Route.Distance.Waypoints));
Route.Distance.Cumulative(1) = 0;
for i = 1 : length(Route.Distance.Waypoints)
    Route.Distance.Cumulative(i+1) = Route.Distance.Cumulative(i)+Route.Distance.Waypoints(i);
end

end