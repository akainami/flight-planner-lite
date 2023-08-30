function cutAlt = altitudeShortRange(Route)
% altitudeShortRange Short Range cut altitude
%
% Synopsis: altitudeShortRange(obj,objAircraft,objEarth)
%
% Input:    obj      = (required) Mission object
%
% Output:  
%
% See also: Mission/fly.
%

% Sense Exceed Climb Altitude by Climb, Not the total distance...
offDist = (Route.Distance.Takeoff+Route.Distance.Climb+...
    Route.Distance.Descent+Route.Distance.Landing)-Route.Distance.Total;

climbDistances = [Route.State.Climb(:).Distance];
climbAltitudes = [Route.State.Climb(:).Altitude];

descentDistances = [Route.State.Descent(:).Distance]...
    -Route.State.Descent(1).Distance-offDist...
    +Route.Distance.Climb+Route.Distance.Takeoff; % Fit to total path
descentAltitudes = [Route.State.Descent(:).Altitude];

% Intersections function by Doug Schwarz
[~,cutAlt] = source.functions.intersections(climbDistances,climbAltitudes,descentDistances,descentAltitudes);

end

