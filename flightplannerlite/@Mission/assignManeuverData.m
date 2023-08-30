function assignManeuverData(Route,Aircraft,Earth,Base,maneuver,iT,deltaTime)
% assignManeuverData Iterate State Structure for given parameters
%
% Synopsis: assignManeuverData(Route,Aircraft, Earth,Base,maneuver,iT,deltaTime)
%
% Input:    Route      = (required) Mission object
%           Earth      = (required) Planet object
%           Aircraft   = (required) Aircraft object
%           Base       = Base object for Arrival/Departure/Emergency
%           maneuver   = Phase String
%           iT         = Iteration Index
%           deltaTime  = Time Step
%
% Output:  
%
% See also: Mission/doTakeoff, Mission/doClimb, Mission/doCruise, Mission/doDescent
% Mission/doLand, source/functions/WindZMtoMD.
%

% Kinematics
Route.State.(maneuver)(iT+1).VTAS        = Aircraft.OnFly.Velocity.VTAS; % m/s
Route.State.(maneuver)(iT+1).Altitude    = Aircraft.ISA.ALTITUDE_P + deltaTime*Aircraft.OnFly.Result.RateCD; % m
Route.State.(maneuver)(iT+1).Time        = Route.State.(maneuver)(iT).Time + deltaTime; % s
Route.State.(maneuver)(iT+1).Distance    = Route.State.(maneuver)(iT).Distance + deltaTime*Aircraft.OnFly.Velocity.GROUND_SPEED; % m

% Dynamics
Route.State.(maneuver)(iT+1).Mass        = Aircraft.OnFly.Load.Mass - deltaTime*Aircraft.OnFly.Result.FuelConsumption; % kg
Route.State.(maneuver)(iT+1).FuelCons    = Route.State.(maneuver)(iT).FuelCons + deltaTime*Aircraft.OnFly.Result.FuelConsumption; % kg
Route.State.(maneuver)(iT+1).Fuel        = Route.State.(maneuver)(iT).Fuel - deltaTime*Aircraft.OnFly.Result.FuelConsumption; % kg

% Navigational Data
Route.State.(maneuver)(iT+1).TerrainElevation = interp2(...
    Earth.Geometry.Topology.LongitudeGrid,Earth.Geometry.Topology.LatitudeGrid,...
    Earth.Geometry.Topology.Elevation,...
    Route.State.(maneuver)(iT).Longitude,Route.State.(maneuver)(iT).Latitude);

[WindDir,WindMag]                        = source.functions.WindZMtoMD(Route.State.(maneuver)(iT).Latitude,Route.State.(maneuver)(iT).Longitude,Route.State.(maneuver)(iT).Altitude); % deg, m/s
Route.State.(maneuver)(iT+1).WindDir     = WindDir; % deg
Route.State.(maneuver)(iT+1).WindMag     = WindMag; % m/s
Route.State.(maneuver)(iT+1).WindRel     = Aircraft.OnFly.Directions.WindRel; % m/s
 
%%
% aircraftHeading = interpn(Route.Distance.Cumulative,Route.Path.Heading_noWind,Route.State.(maneuver)(iT).Distance,'spline'); % deg
% Route.State.(maneuver)(iT+1).AircraftDir = aircraftHeading;

for iC = length(Route.Distance.GreatCircleWP) : -1 :  1
   if Route.State.(maneuver)(iT).Distance < Route.Distance.GreatCircleWPCumulative(iC)
        targetLat = Route.Path.TargetLat(iC);
        targetLon = Route.Path.TargetLon(iC);
   end
end
try
    Route.State.(maneuver)(iT+1).AircraftDir = azimuth(Route.State.(maneuver)(iT).Latitude,...
        Route.State.(maneuver)(iT).Longitude,targetLat,targetLon);
catch
    Route.State.(maneuver)(iT+1).AircraftDir = 0;
end
%%
if strcmpi(maneuver,'takeoff') %||  strcmpi(maneuver,'landing') 
    Route.State.(maneuver)(iT+1).Latitude  = Base.Latitude; % deg
    Route.State.(maneuver)(iT+1).Longitude = Base.Longitude; % deg
    Route.State.(maneuver)(iT+1).RealDir = 0;
else
    wsgs_angle = atand(Aircraft.OnFly.Velocity.WIND_DEFLECTION/Aircraft.OnFly.Velocity.GROUND_SPEED);
    
    arclen = deltaTime*1e-3*(Aircraft.OnFly.Velocity.GROUND_SPEED^2-Aircraft.OnFly.Velocity.WIND_DEFLECTION^2)^.5; % km
    trackDir = Route.State.(maneuver)(iT).AircraftDir;
    
    [latStep,lonStep] = track1(Route.State.(maneuver)(iT).Latitude,Route.State.(maneuver)(iT).Longitude,...
        trackDir,arclen,Earth.Ellipsoid,'degrees',1); % deg,deg
    Route.State.(maneuver)(iT+1).Latitude = latStep; % deg
    Route.State.(maneuver)(iT+1).Longitude = lonStep; % deg
    Route.State.(maneuver)(iT+1).RealDir = trackDir-wsgs_angle; % deg
end

end

