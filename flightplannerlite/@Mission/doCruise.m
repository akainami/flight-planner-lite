function doCruise(Route,Aircraft,Earth)
% doCruise Cruise Phase Function
%
% Synopsis: doCruise(obj,objAircraft)
%
% Input:    obj      = (required) Mission object
%         objAircraft = (required) Aircraft object
%         objEarth = (required) Planet object
%
% Output:
%
% See also: Mission/fly.
%

ttic = tic;

%% Define initials
Route.State.Cruise = Route.State.Climb(end);
Route.State.Cruise.BaseAltitude = Route.State.Cruise.Altitude;
baseAltitude = Route.State.Cruise.BaseAltitude;
%% Define Gradual Step Heights
iT = 1;
nCr = Route.State.CRsteps;
Xcr = Route.Distance.CruiseNominal;
dX = Xcr / nCr;

% Manually
dH = 600; % m
gammaCr = 5.74e-04; % rad
deltaXcr = dH/gammaCr;

cruiseCorrection = 0; % m
cumulativeXcruise = 0;

% If not short range, proceed; if short range, call doShortRange()
if Xcr >= 0
    while true
        %% Calculate Current Flight
        Earth.ISA.evaluate(Route.State.Cruise(iT).Altitude + cruiseCorrection, 0, 0); % (hp, dT, dP)
        Aircraft.cleanup;
        Aircraft.assignMass(Route.State.Load.Payload,Route.State.Cruise(iT).Fuel);
        Aircraft.calculate...
            ('Atmosphere',Earth.ISA,'Phase','Cruise','ThrustMode','',...
            'WindDirAbs',Route.State.Cruise(iT).WindDir,...
            'AircraftDir',Route.State.Cruise(iT).AircraftDir,...
            'WindMagnitude',Route.State.Cruise(iT).WindMag);
        
        %% Record
        % Bound Parameters
        deltaTime = dX / Aircraft.OnFly.Velocity.GROUND_SPEED;
        
        assignManeuverData(Route,Aircraft,Earth,[],'Cruise',iT,deltaTime);
        
        cumulativeXcruise = cumulativeXcruise + dX;
        
        if cumulativeXcruise > deltaXcr
            cumulativeXcruise = cumulativeXcruise - deltaXcr;
            baseAltitude = source.functions.findOptimalAltitude(Earth, Aircraft);
            Route.State.Cruise(iT+1).Altitude = baseAltitude;
        end
        
        Route.State.Cruise(iT+1).BaseAltitude = baseAltitude;
        
        cruiseCorrection = source.functions.optimalAltitudeCorrection(...
            Earth,Aircraft,Route.State.Cruise(iT).Latitude, Route.State.Cruise(iT).Longitude, Route.State.Cruise(iT).AircraftDir,Route.State.AltOptimSteps);

        
        %% Break Cond.
        if iT + 1 == nCr
            break
        end
        iT = iT + 1;
    end
end

Route.Distance.Cruise = Route.State.Cruise(end).Distance - Route.State.Cruise(1).Distance;
Route.Distance.CruiseWindDrift = Route.Distance.CruiseNominal - Route.Distance.Cruise;
fprintf('-> Cruise calculated in %.2f s\n',toc(ttic));
end

