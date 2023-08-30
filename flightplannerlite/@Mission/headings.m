function headings(Route)
% headings Heading angles on Great Circle between two points
%
% Synopsis: waypoints(Route)
%
% Input:    Route      = (required) Mission object
%
% Output:
%
% See also: Mission/fly .
%

n = length(Route.Path.Lat);
nInner = (n+length(Route.WaypointBases))/(length(Route.WaypointBases)+1);
Route.Path.Heading_noWind = nan(n,1);

wpsCell = cell(length(Route.WaypointBases)+1,1) ;
for iB = 1 : length(wpsCell)-1
    wpsCell{iB} = Route.WaypointBases{iB};
end
wpsCell{end} = Route.Arrival;

targetLat = wpsCell{1}.Latitude*ones(nInner,1);
targetLon = wpsCell{1}.Longitude*ones(nInner,1);
for iB = 2 : length(wpsCell)
    targetLat = [targetLat; wpsCell{iB}.Latitude*ones(nInner-1,1)];
    targetLon = [targetLon; wpsCell{iB}.Longitude*ones(nInner-1,1)];
end

% Refer to Real North
for iP = 1 : n-1
    Route.Path.Heading_noWind(iP) = azimuth(Route.Path.Lat(iP),Route.Path.Lon(iP),...
        targetLat(iP),targetLon(iP));
end

% Correct Headings
for iFix = 1 : length(wpsCell)-1 
    Route.Path.Heading_noWind(iFix*(nInner-1)+1) = Route.Path.Heading_noWind(iFix*nInner+1);
end
Route.Path.Heading_noWind(end) = Route.Path.Heading_noWind(end-1);

Route.Path.Heading_noWind(n) = interpn(1:n-1,Route.Path.Heading_noWind(1:n-1),n,'spline');

% Change Interval from [0 360] to [-180 180]
Route.Path.Heading_noWind(Route.Path.Heading_noWind>180) = Route.Path.Heading_noWind(Route.Path.Heading_noWind>180)-360;
end

