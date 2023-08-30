function alternatePaths(Route)
% AlternatePaths Obtain Alternate Paths
%
% Synopsis: AlternatePaths(Route)
%
% Input:    Route      = (required) Mission object
% Output:
%
% See also: Mission/init.
%

nBase = length(Route.Alternate.Base);

Route.Alternate.Path = struct;

for iBase = 1 : nBase
    AltBase = Route.Alternate.Base{iBase};
    BaseLat = AltBase.Latitude;
    BaseLong = AltBase.Longitude;
    
    nPath =  length(Route.Path.Lat);
    distanceToBase = zeros(nPath,1);
    for iPath = 1 : nPath
        distanceToBase(iPath) = distance(BaseLat,BaseLong,...
            Route.Path.Lat(iPath),Route.Path.Lon(iPath));
    end
    [~,minDex] = min(distanceToBase);
    
    Route.Alternate.Path(iBase).AlternatingBase = AltBase.Name;
    Route.Alternate.Path(iBase).BaseElevation = AltBase.Elevation;
    Route.Alternate.Path(iBase).BaseLatitude = AltBase.Latitude;
    Route.Alternate.Path(iBase).BaseLongitude = AltBase.Longitude;
    Route.Alternate.Path(iBase).ShortestLatitude = Route.Path.Lat(minDex);
    Route.Alternate.Path(iBase).ShortestLongitude = Route.Path.Lon(minDex);
    Route.Alternate.Path(iBase).ShortestDistance = deg2km(distanceToBase(minDex))*1e3;
    nLeg = ceil(Route.Alternate.Path(iBase).ShortestDistance/5e3);
    [pathLat,pathLon] = gcwaypts(Route.Path.Lat(minDex),Route.Path.Lon(minDex),AltBase.Latitude,AltBase.Longitude,nLeg);
    Route.Alternate.Path(iBase).PathLon = pathLon;
    Route.Alternate.Path(iBase).PathLat = pathLat;

    Route.Alternate.Path(iBase).Headings = azimuth(pathLat,pathLon,BaseLat.*ones(length(pathLat),1),BaseLong.*ones(length(pathLon),1));
end

end

