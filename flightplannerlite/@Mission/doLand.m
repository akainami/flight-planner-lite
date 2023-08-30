function doLand(Route,Aircraft,Earth,Base)
% doLand Landing Phase Function
%
% Synopsis: doLand(obj,objAircraft)
%
% Input:    obj      = (required) Mission object
%         objAircraft= (required) Aircraft object
%         objEarth = (required) Planet object
%
% Output:
%
% See also: Mission/fly.
%

ttic = tic;

%% Clear holder
Route.State.Landing = [];

%% Define initials
Route.State.Landing = Route.State.Descent(end);

%% Calculate nominal approach speed
Earth.ISA.evaluate(Route.State.Landing(1).Altitude, 0, 0); % (hp, dT, dP)
Aircraft.cleanup;
Aircraft.assignMass(Route.State.Load.Payload,Route.State.Landing(1).Fuel);
Aircraft.calculate...
    ('Atmosphere',Earth.ISA,'Phase','Landing','ThrustMode','idle',...
    'WindDirAbs',Route.State.Landing(1).WindDir,...
    'AircraftDir',Route.State.Landing(1).AircraftDir,...
    'WindMagnitude',Route.State.Landing(1).WindMag);
Route.State.Landing(1).VTAS = Aircraft.OnFly.Velocity.VTAS; % m/s

%% Determine Break Requirements
LD_DIST = Route.Distance.Takeoff; % Nominal Landing Distance, m

%% DO LOOP
iT = 1; %
timestep = Route.State.LDdTime; % s
while true
    %% Calculate Current Flight
    Earth.ISA.evaluate(Route.State.Landing(iT).Altitude, 0, 0); % (hp, dT, dP)
    Aircraft.cleanup;
    Aircraft.assignMass(Route.State.Load.Payload,Route.State.Landing(iT).Fuel);
    Aircraft.calculate...
        ('Atmosphere',Earth.ISA,'Phase','Landing','ThrustMode','idle',...
        'Mass',Route.State.Landing(iT).Mass,...
        'WindDirAbs',Route.State.Landing(iT).WindDir,...
        'AircraftDir',Route.State.Landing(iT).AircraftDir,...
        'WindMagnitude',Route.State.Landing(iT).WindMag,...
        'VTAS',Route.State.Landing(iT).VTAS);
    
    %% Record
    % Bound Parameters
    assignManeuverData(Route,Aircraft,Earth,Base,'Landing',iT,timestep);
    
     % Exceptional Data
    Route.State.Landing(iT+1).VTAS        = Aircraft.OnFly.Velocity.VTAS ...
        + timestep*(-Aircraft.OnFly.Result.DragForce)/...
        Aircraft.OnFly.Load.Mass; % m/s
       
    if Route.State.Landing(iT+1).Distance-Route.State.Landing(1).Distance >= LD_DIST
        % Remove Unused Row
        Route.State.Landing(iT+1) = [];
        break
    end
    
    % Iterators
    iT = iT + 1;
end

% Measure Distance
Route.Distance.Landing = Route.State.Landing(end).Distance - Route.State.Landing(1).Distance;
Route.Distance.Flown = Route.State.Landing(end).Distance;
fprintf('-> Landing calculated in %.2f s\n',toc(ttic));
end

