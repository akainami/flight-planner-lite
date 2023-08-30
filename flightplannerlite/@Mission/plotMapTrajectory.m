function plotMapTrajectory(Route)
% plotMapTrajectory
%
% Synopsis: plotMapTrajectory(objRoute,objEarth)
%
% Input:  Route = Route object
%         Earth = Planet object
%
% Output:
%
% See also: .
%

tic;

% Plot
geoaxes('Basemap','colorterrain','InnerPosition',[.50 .50 .48 .48]);
% geoaxes('Basemap','colorterrain');

hold on;
% Trajectory
try
    if Route.State.shortRangeCriteria
        phaseCell = {'Takeoff','Climb','Descent','Landing'};
    else
        phaseCell = {'Takeoff','Climb','Cruise','Descent','Landing'};
    end
    for iP = 1 : length(phaseCell)
        if iP == 1
                renk = 'k';
        elseif iP == 2
                renk = 'k';
        elseif iP == 3
                renk = 'k';
        elseif iP == 4
                renk = 'k';
        elseif iP == 5
                renk = 'k';
        end
        
        for iR = 1 : 5 : length(Route.State.(phaseCell{iP}))
            text(Route.State.(phaseCell{iP})(iR).Latitude,Route.State.(phaseCell{iP})(iR).Longitude,...
                '>','Rotation',90-Route.State.(phaseCell{iP})(iR).RealDir,'Color',renk);
        end
    end
catch
end
geoplot(Route.Path.GreatCircleLat,Route.Path.GreatCircleLon,':k','LineWidth',1.2);
geoplot(Route.Path.WindOptimalLat,Route.Path.WindOptimalLon,'--r','LineWidth',1.5);
% Bases and Alternatives
r = Route.Alternate.AlternatingRadius/2/pi/earthRadius*360;
th = 0 : .1 : 2*pi+.1;

text(Route.Departure.Latitude,Route.Departure.Longitude,strcat(" ",Route.Departure.IATA),'Color','r');
geoplot(Route.Departure.Latitude,Route.Departure.Longitude,'^r');
text(Route.Arrival.Latitude,Route.Arrival.Longitude,strcat(" ",Route.Arrival.IATA),'Color','r');
geoplot(Route.Arrival.Latitude,Route.Arrival.Longitude,'^r');

geoplot(Route.Departure.Latitude+r*cos(th),Route.Departure.Longitude+r*sin(th),'-.k','linewidth',1)
geoplot(Route.Arrival.Latitude+r*cos(th),Route.Arrival.Longitude+r*sin(th),'-.k','linewidth',1)

% Plot diversion
text(Route.Diversion.Base.Latitude,Route.Diversion.Base.Longitude,strcat(" ",Route.Diversion.Base.IATA),'Color','r');
geoplot(Route.Diversion.Base.Latitude,Route.Diversion.Base.Longitude,'hr');

% Plot alternate bases along with departure and arrival
for iB = 1 : length(Route.Alternate.Base)
    geoplot(Route.Alternate.Base{iB}.Latitude,Route.Alternate.Base{iB}.Longitude,'xg','linewidth',3);
    geoplot(Route.Alternate.Base{iB}.Latitude+r*cos(th),Route.Alternate.Base{iB}.Longitude+r*sin(th),'-.k','linewidth',1)
    for iP = 1 : length(Route.Alternate.Path(iB).PathLon)-1
        text(Route.Alternate.Path(iB).PathLat(iP),Route.Alternate.Path(iB).PathLon(iP),...
            '>','Rotation',90-Route.Alternate.Path(iB).Headings(iP),'Color','r');
    end
end

% Plot Stations
% plot(Earth.Location.Stations.Longitude,Earth.Location.Stations.Latitude,'.k');

fprintf('Path is drawn in %.2f s\n',toc);
end