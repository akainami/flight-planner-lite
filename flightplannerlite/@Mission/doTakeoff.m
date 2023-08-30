function doTakeoff(Route,Aircraft,Earth,Base)
% doTakeoff Takeoff Phase Function
%
% Synopsis: doTakeoff(obj,objAircraft)
%
% Input:    obj      = (required) Mission object
%           objAircraft = (required) Aircraft object
%          objEarth = (required) Earth object
%
% Output:
%
% See also: Mission/fly.
%

ttic = tic;

%% Clear holder
Route.State.Takeoff = [];

%% Define initials
[ToWindDir,ToWindMag] = source.functions.WindZMtoMD(Base.Latitude,Base.Longitude,Base.Elevation);
Route.State.Takeoff(1).Altitude = Base.Elevation*units.ft2m;
Route.State.Takeoff(1).VTAS = 0; % m/s
Route.State.Takeoff(1).Time = 0; % s
Route.State.Takeoff(1).Distance = 0; % m
Route.State.Takeoff(1).Mass = Aircraft.OnFly.Load.Mass; % kg
Route.State.Takeoff(1).Fuel = Aircraft.OnFly.Load.FL; % kg
Route.State.Takeoff(1).TerrainElevation = Base.Elevation*units.ft2m; % kg
Route.State.Takeoff(1).WindDir = ToWindDir; % deg
Route.State.Takeoff(1).WindMag = ToWindMag; % m/s
Route.State.Takeoff(1).AircraftDir = interp1(Route.Distance.Cumulative,Route.Path.Heading_noWind,0); % deg
Route.State.Takeoff(1).FuelCons = 0; % m
Route.State.Takeoff(1).Latitude = Base.Latitude;
Route.State.Takeoff(1).Longitude = Base.Longitude;
Route.State.Takeoff(1).WindRel = 0; % m
Route.State.Takeoff(1).RealDir = 0; % m

%% Calculate Atmosphere
Earth.ISA.evaluate(Route.State.Takeoff(1).Altitude, 0, 0); % (hp, dT, dP)
Aircraft.cleanup;
Aircraft.assignMass(Route.State.Load.Payload, Route.State.Takeoff(1).Fuel);
Aircraft.calculate...
    ('Atmosphere',Earth.ISA,'Phase','Takeoff','ThrustMode','MCMB',...
    'Mass',Route.State.Takeoff(1).Mass,...
    'WindDirAbs',Route.State.Takeoff(1).WindDir,...
    'AircraftDir',Route.State.Takeoff(1).AircraftDir,...
    'WindMagnitude',Route.State.Takeoff(1).WindMag);

%% Determine Break Requirements
TOFF_SPEED = Aircraft.OnFly.Velocity.VTAS;

%% DO LOOP
iT = 1; %
timestep = Route.State.TOdTime; % s

while true
    % Calculate Current Flight
    Earth.ISA.evaluate(Route.State.Takeoff(iT).Altitude, 0, 0); % (hp, dT, dP)
    Aircraft.cleanup;
    Aircraft.assignMass(Route.State.Load.Payload,Route.State.Takeoff(iT).Fuel);
    Aircraft.calculate...
        ('Atmosphere',Earth.ISA,'Phase','Takeoff','ThrustMode','MCMB',...
        'Mass',Route.State.Takeoff(iT).Mass,...
        'WindDirAbs',Route.State.Takeoff(iT).WindDir,...
        'AircraftDir',Route.State.Takeoff(iT).AircraftDir,...
        'WindMagnitude',Route.State.Takeoff(iT).WindMag,...
        'VTAS',Route.State.Takeoff(iT).VTAS);
    
    % Record
    assignManeuverData(Route,Aircraft,Earth,Base,'Takeoff',iT,timestep);
    
        % Exceptional Data
    Route.State.Takeoff(iT+1).VTAS  = Aircraft.OnFly.Velocity.VTAS ...
        + timestep*(Aircraft.OnFly.Result.ThrustForce)/Aircraft.OnFly.Load.Mass; % m/s
    
    if Route.State.Takeoff(iT+1).VTAS > TOFF_SPEED
        % Remove Unused Row
        Route.State.Takeoff(iT+1) = [];
        break
    end
    
    % Iterators
    iT = iT + 1;
end

% Measure Distance
Route.Distance.Takeoff = Route.State.Takeoff(end).Distance - Route.State.Takeoff(1).Distance;

% Replace Data
Route.State.Takeoff(end).Latitude = interp1(Route.Distance.Cumulative,Route.Path.Lat,Route.State.Takeoff(end).Distance);
Route.State.Takeoff(end).Longitude = interp1(Route.Distance.Cumulative,Route.Path.Lon,Route.State.Takeoff(end).Distance);

fprintf('-> Takeoff calculated in %.2f s\n',toc(ttic));
end

