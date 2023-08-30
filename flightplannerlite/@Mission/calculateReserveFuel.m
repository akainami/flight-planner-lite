function calculateReserveFuel(Route, Earth, Aircraft)
% calculateReserveFuel Reserve Fuel Calculation after landing
%
% Synopsis: calculateReserveFuel(Route, Earth, Aircraft)
%
% Input:    Route = (required) Mission object
%           Earth = (required) Planet object
%           Aircraft = (required) Aircraft object
%
% Output:
%
% See also: .

%
ttic = tic;

deltaTime = 10; % s

%% Alternate Flight
iT = 1; 
altDistance = Route.Diversion.Distance; % m

Aircraft.assignMass(Route.State.Load.Payload,2000);

Route.State.Diversion(1).Altitude = 1500*units.ft2m; % m
Route.State.Diversion(1).VTAS = 0; % m/s
Route.State.Diversion(1).Time = 0; % s
Route.State.Diversion(1).Distance = 0; % m
Route.State.Diversion(1).Mass = Aircraft.OnFly.Load.Mass; % kg
Route.State.Diversion(1).Fuel = Aircraft.OnFly.Load.FL; % kg
Route.State.Diversion(1).TerrainElevation = Route.Diversion.Base.Elevation*units.ft2m; % ft
Route.State.Diversion(1).WindDir = 0; % deg
Route.State.Diversion(1).WindMag = 0; % m/s
Route.State.Diversion(1).AircraftDir = 0; % deg
Route.State.Diversion(1).FuelCons = 0; % m
Route.State.Diversion(1).Latitude = Route.Diversion.Base.Latitude;
Route.State.Diversion(1).Longitude = Route.Diversion.Base.Longitude;
Route.State.Diversion(1).WindRel = 0; % m
Route.State.Diversion(1).RealDir = 0; % m

while true
    Earth.ISA.evaluate(Route.State.Diversion(iT).Altitude, 0, 0); % (hp, dT, dP)
    Aircraft.cleanup;
    Aircraft.assignMass(Route.State.Load.Payload,Route.State.Diversion(iT).Fuel); % kg
    Aircraft.calculate('Atmosphere',Earth.ISA,'Phase','Cruise','ThrustMode','');
    %% Record
    % Bound Parameters    
    Route.assignManeuverData(Aircraft,Earth,[],'Diversion',iT,deltaTime);
    
    if Route.State.Diversion(iT).Distance > altDistance
        Route.State.Diversion(end) = [];
        break
    end
    iT = iT + 1;
end

Route.State.Load.AlternateFuel = Route.State.Diversion(end).FuelCons; % kg

%% Final Reserve Flight
iT = 1;

Aircraft.assignMass(Route.State.Load.Payload,2000);

Route.State.FinalReserve(1).Altitude = 1500; % ft
Route.State.FinalReserve(1).VTAS = 0; % m/s
Route.State.FinalReserve(1).Time = 0; % s
Route.State.FinalReserve(1).Distance = 0; % m
Route.State.FinalReserve(1).Mass = Aircraft.OnFly.Load.Mass; % kg
Route.State.FinalReserve(1).Fuel = Aircraft.OnFly.Load.FL; % kg
Route.State.FinalReserve(1).TerrainElevation = Route.Arrival.Elevation*units.ft2m; % ft
Route.State.FinalReserve(1).WindDir = 0; % deg
Route.State.FinalReserve(1).WindMag = 0; % m/s
Route.State.FinalReserve(1).AircraftDir = 0; % deg
Route.State.FinalReserve(1).FuelCons = 0; % m
Route.State.FinalReserve(1).Latitude = Route.Arrival.Latitude;
Route.State.FinalReserve(1).Longitude = Route.Arrival.Longitude;
Route.State.FinalReserve(1).WindRel = 0; % m
Route.State.FinalReserve(1).RealDir = 0; % m

while true
    Earth.ISA.evaluate(1500, 0, 0); % (hp, dT, dP)
    Aircraft.cleanup;
    Aircraft.assignMass(Route.State.Load.Payload,Route.State.FinalReserve(iT).Fuel); % kg
    Aircraft.calculate('Atmosphere',Earth.ISA,'Phase','Cruise','ThrustMode','');
    %% Record
    % Bound Parameters    
    Route.assignManeuverData(Aircraft,Earth,[],'FinalReserve',iT,deltaTime);
    if Route.State.FinalReserve(iT).Time > Route.State.FinalReserveTime
        Route.State.FinalReserve(end) = [];
        break
    end
    iT = iT + 1;
end

Route.State.Load.FinalReserveFuel = Route.State.FinalReserve(end).FuelCons; % kg
fprintf('-> Reserve & Alternate Calculated in %.2f s\n',toc(ttic));
end

