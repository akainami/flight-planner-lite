function doClimb(Route,Aircraft,Earth,climbAlt)
% doClimb Climb Phase Function
%
% Synopsis: doClimb(obj,objAircraft,objEarth)
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

%% Define initials
Route.State.Climb = Route.State.Takeoff(end);
% Route.State.Climb.FuelCons = 0;

Route.Distance.LevelAccelerationDistance = 0;

%% Calculate Atmosphere
Earth.ISA.evaluate(Route.State.Climb(1).Altitude, 0, 0); % (hp, dT, dP)

%% Determine Break Requirements
if nargin < 4
    % Optimal Cruise speed altitude
    H_OPT = source.functions.findOptimalAltitude(Earth, Aircraft);
    setClimbAltitude = false;
else
    H_OPT = climbAlt;
    setClimbAltitude = true;
end
    
%% DO LOOP
iT = 1; %
dKCAS = [5 20 30 20 10 50];
H_sawtooth = [1500 3000 4000 5000 6000 10000]*units.ft2m; % m
dAlt = Route.State.CLDEdAlt*units.ft2m; % ft
isHopt = false;

%% Climb to initial h_opt
while true
    %% Calculate Current Flight Parameters
    Earth.ISA.evaluate(Route.State.Climb(iT).Altitude, 0, 0); % (hp, dT, dP)
    Aircraft.cleanup;
    Aircraft.assignMass(Route.State.Load.Payload,Route.State.Climb(iT).Fuel);
    Aircraft.calculate...
        ('Atmosphere',Earth.ISA,'Phase','Climb','ThrustMode','MCMB',...
        'WindDirAbs',Route.State.Climb(iT).WindDir,...
        'AircraftDir',Route.State.Climb(iT).AircraftDir,...
        'WindMagnitude',Route.State.Climb(iT).WindMag);
    
    %% SAWTOOTH CLIMB
    if min(abs(Route.State.Climb(iT).Altitude*ones(1,6)-H_sawtooth))<dAlt
        %% Level Acceleration
        [~,minIndex] = min(abs(Route.State.Climb(iT).Altitude*ones(1,6)-H_sawtooth));
        dV = dKCAS(minIndex);
        dF = Aircraft.OnFly.Result.ThrustForce- Aircraft.OnFly.Result.DragForce;
        % Bound Parameters
        deltaTimeAcc = dV / dF * Aircraft.OnFly.Load.Mass; % s
        
        assignManeuverData(Route,Aircraft,Earth,[],'Climb',iT,deltaTimeAcc);
        
        % Exceptional Data
        Route.State.Climb(iT+1).Altitude = Route.State.Climb(iT).Altitude;
        
        Route.Distance.LevelAccelerationDistance = Route.Distance.LevelAccelerationDistance + deltaTimeAcc*Aircraft.OnFly.Velocity.GROUND_SPEED;
        
        % Block the re-entry to level
        H_sawtooth(minIndex) = 1e12;
    else
        %% Climb
        % Bound Parameters
        deltaTime = dAlt / Aircraft.OnFly.Result.RateCD;
        assignManeuverData(Route,Aircraft,Earth,[],'Climb',iT,deltaTime);
    end
    
    %% Check initial h_opt
    if Route.State.Climb(iT+1).Altitude >= H_OPT && ~setClimbAltitude
        % Assign final h_opt
        % H_opt is updated since
        H_OPT = source.functions.findOptimalAltitude(Earth, Aircraft);
        if isHopt
            % Remove Unused Row
            Route.State.Climb(iT+1) = [];
            break
        end
        isHopt = true;
    elseif Route.State.Climb(iT+1).Altitude >= H_OPT && setClimbAltitude
        % Remove Unused Row
        Route.State.Climb(iT+1) = [];
        break
    end
    
    % Iterators
    iT = iT + 1;
end

% Measure Distance
Route.Distance.Climb = Route.State.Climb(end).Distance - Route.State.Climb(1).Distance;

fprintf('-> Climb calculated in %.2f s\n',toc(ttic));
end

