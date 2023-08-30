function defineGeometry(obj,dataSelection)
% defineGeometry Define Earth's Geometry
%
% Synopsis: defineGeometry(obj)
%
% Input:    obj      = (required) Planet object
%
% Output:
%
% See also: .
%

Geometry = struct;

Geometry.MeanRadius = earthRadius; % m, roughly
Geometry.minLatitude = -90;
Geometry.maxLatitude = 90;
Geometry.minLongitude = -180;
Geometry.maxLongitude = 180;

load('+source/Data/coastlines.mat','coastlat','coastlon');
coastlon(coastlon>180) = nan;
Geometry.Coast.Lat = coastlat;
Geometry.Coast.Lon = coastlon;

if strcmpi(dataSelection,'88MGG')
    % Data in this case is available from the National Geophysical Data
    % Center, NOAA US Department of Commerce under data announcement 88-MGG-02.
    load('+source/Data/topology.mat','topo','topomap1')
    topo_shifted = [topo(:,181:360) topo(:,1:180)];
    tlat = linspace(-90,90,180);
    tlon = linspace(-180,180,360);
    [mlon,mlat] = meshgrid(tlon,tlat);
    
    Geometry.Topology.Latitude = tlat;
    Geometry.Topology.Longitude = tlon;
    Geometry.Topology.LatitudeGrid = mlat;
    Geometry.Topology.LongitudeGrid = mlon;
    Geometry.Topology.Elevation = topo_shifted;
    
    Geometry.Topology.ColorMap = [[0 0 1].*ones(36,3); topomap1(37:end,:)];
    
elseif strcmpi(dataSelection,'ETOPO')
    
    error('ESRI data can not be imported into model.');
    
elseif strcmpi(dataSelection,'GLOBE')
    % Data in this case is available from the National Geophysical Data
    % Center, NOAA US Department of Commerce under GLOBE project.
    error('no data.')
end
obj.Geometry = Geometry;
end