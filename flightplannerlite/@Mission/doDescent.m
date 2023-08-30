function doDescent(Route,Aircraft,Earth,Base)
% doDescent Descent Phase Function
%
% Synopsis: doDescent(obj,objAircraft,objEarth)
%
% Input:    Mission = (required) Mission object
%         Aircraft = (required) Aircraft object
%         Earth = (required) Planet object
%
% Output:
%
% See also: Mission/fly.
%

% Clear holder
Route.State.Descent = [];

ttic = tic;


%% Define initials
try
    if  Route.State.shortRangeCriteria
        Route.State.Descent = Route.State.Climb(end);
    else
        Route.State.Descent = Route.State.Cruise(end);
    end
catch
    Route.State.Descent = Route.State.Cruise(end);
end

%% Calculate Atmosphere
Earth.ISA.evaluate(Route.State.Descent(1).Altitude, 0, 0); % (hp, dT, dP)

%% Determine Break Requirements
H_DES = Base.Elevation*units.ft2m;

%% DO LOOP
iT = 1;
dAlt = Route.State.CLDEdAlt*units.ft2m; % ft

%% Descend to initial h_opt
while true
    %% Calculate Current Flight
    Earth.ISA.evaluate(Route.State.Descent(iT).Altitude, 0, 0); % (hp, dT, dP)
    Aircraft.cleanup;
    Aircraft.assignMass(Route.State.Load.Payload,Route.State.Descent(iT).Fuel);
    Aircraft.calculate...
        ('Atmosphere',Earth.ISA,'Phase','Descent','ThrustMode','idle',...
        'WindDirAbs',Route.State.Descent(iT).WindDir,...
        'AircraftDir',Route.State.Descent(iT).AircraftDir,...
        'WindMagnitude',Route.State.Descent(iT).WindMag);
    
    %% Record
    % Bound Parameters
    deltaTime = - dAlt / Aircraft.OnFly.Result.RateCD;
    
    assignManeuverData(Route,Aircraft,Earth,Base,'Descent',iT,deltaTime);
    
    %% Break Condition
    if Route.State.Descent(iT+1).Altitude <= H_DES
        % Remove Unused Row
        Route.State.Descent(iT+1) = [];
        break
    end
    
    % Iterators
    iT = iT + 1;
end

%% Measure Distance
Route.Distance.Descent = Route.State.Descent(end).Distance - Route.State.Descent(1).Distance;

fprintf('-> Descent calculated in %.2f s\n',toc(ttic));

end

