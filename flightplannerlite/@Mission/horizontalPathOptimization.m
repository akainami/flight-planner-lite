function horizontalPathOptimization(Route)
% plotMapTrajectory
%
% Synopsis: plotMapTrajectory(objRoute,objEarth)
%
% Input:  Route = Route object
%
% Output:
%
% See also: .
%

% geoaxes('Basemap','colorterrain');
% hold on;
lat1 = Route.Departure.Latitude;
lon1 = Route.Departure.Longitude;
% geoplot(lat1,lon1,'rp');

lat2 = Route.Arrival.Latitude;
lon2 = Route.Arrival.Longitude;
% geoplot(lat2,lon2,'rp');

nStations = 20;
nFan = 10;

alt = 1000*0.3048; % m
Vcr = 230; % m/s

% stations
waypts = gcwaypts(lat1,lon1,lat2,lon2,nStations-1);
% geoplot(waypts(:,1),waypts(:,2),'-.k','LineWidth',1.5);

% radius
l = distance(lat1,lon1,lat2,lon2);
r = l/5/nFan;
rVec = (-nFan:nFan)*r;

kNode = 2;
latnodes(1) = lat1;
lonnodes(1) = lon1;
for i = 2 : nStations-1
    for j = 1 : nFan*2+1
        latnodes(kNode) = waypts(i,1) + rVec(j);
        lonnodes(kNode) = waypts(i,2) + rVec(j);
        wind = atmoshwm(latnodes(kNode),lonnodes(kNode),alt);
%         geoplot(latnodes(kNode),lonnodes(kNode),'.k');
%         text(latnodes(kNode),lonnodes(kNode),"v",'Color','k','Rotation',-atand(wind(1)/wind(2)));
        kNode = kNode + 1;
    end
end
latnodes(end+1) = lat2;
lonnodes(end+1) = lon2;

% mesh
kNode = 0;
for iS = 1 : nStations-1
    for iF = 1 : nFan*2+1
        kNode = kNode + 1;
        if iS == 1
            targets(1:nFan*2+1) = 2:nFan*2+2;
            sources(1:nFan*2+1) = kNode;
            break
        elseif iS == nStations-1
            targets(end+1:end+nFan*2+1) = (nStations-2)*(nFan*2+1)+2;
            sources(end+1:end+nFan*2+1) = kNode:kNode+nFan*2;
            break
        elseif iF == 1
            targets(end+1:end+2) = kNode+nFan*2+1:kNode+nFan*2+2;
            sources(end+1:end+2) = kNode;
        elseif iF == nFan*2+1
            targets(end+1:end+2) = kNode+nFan*2:kNode+nFan*2+1;
            sources(end+1:end+2) = kNode;
        else
            targets(end+1:end+3) = kNode+nFan*2:kNode+nFan*2+2;
            sources(end+1:end+3) = kNode;
        end
    end
end
nNode = max(targets);

% weights
weights = zeros(length(targets),1);
for i = 1 : length(targets)
    depnode = sources(i);
    arrnode = targets(i);
    
    deplat = latnodes(depnode);
    deplon = lonnodes(depnode);
    
    arrlat = latnodes(arrnode);
    arrlon = lonnodes(arrnode);
    
    [windDepMag,windDepDir] = source.functions.WindZMtoMD(deplat,deplon,alt);
    [windArrMag,windArrDir] = source.functions.WindZMtoMD(arrlat,arrlon,alt);
    
    % weight is time
    pathAzi = azimuth(deplat,deplon,arrlat,arrlon);
    d = distance(deplat,deplon,arrlat,arrlon)*earthRadius/180*pi;
    Vw = ((windDepMag*cosd(pathAzi-windDepDir))+(windArrMag*cosd(pathAzi-windArrDir)))/2;

    weights(i) = d/(Vcr+Vw); % s
end

G = graph(sources,targets,weights);
TR = shortestpath(G,1,nNode);
% Create path
shrtpath = nan(length(TR),2);
for i = 1 : length(TR)
    shrtpath(i,:) = [latnodes(TR(i)) lonnodes(TR(i))];
end
% geoplot(shrtpath(:,1),shrtpath(:,2),'--r','LineWidth',1.5);
Route.Path.WindOptimalLat = shrtpath(:,1);
Route.Path.WindOptimalLon = shrtpath(:,2);
end