function evaluateShortRangeProfile(Route, Earth, Aircraft)
% evaluateShortRangeProfile Short Range Profile Implementation
%
% Synopsis: evaluateShortRangeProfile(Route, Earth, Aircraft)
%
% Input:    Route = (required) Mission object
%           Earth = (required) Planet object
%           Aircraft = (required) Aircraft object
%
% Output:
%
% See also: Mission/fly.
%

if ~Route.State.shortRangeCriteria
    return
end

Arrival   = Route.Arrival;
Departure = Route.Departure;
iterRange = 1;

% Create
if isempty(Arrival)
    error('Where to land?')
end

% Clear
Route.State = rmfield(Route.State,'Cruise');

% Short-range cut altitude
Route.State.cutAlt = altitudeShortRange(Route); % m

% Fuel Nominations
for iH = 1 : length(Route.State.Descent)
    if Route.State.Descent(iH).Altitude < Route.State.cutAlt
        fuelDescent = Route.State.Descent(iH).FuelCons - Route.State.Descent(1).FuelCons;
        break
    end
end
for iH = 1 : length(Route.State.Climb)
    if Route.State.Climb(iH).Altitude > Route.State.cutAlt
        fuelClimb = Route.State.Climb(iH).FuelCons - Route.State.Climb(1).FuelCons;
        break
    end
end

fuelLanding = Route.State.Landing(end).FuelCons - Route.State.Landing(1).FuelCons;
fuelTakeoff = Route.State.Takeoff(end).FuelCons - Route.State.Takeoff(1).FuelCons;

tripFuel = fuelTakeoff + fuelClimb + fuelDescent + fuelLanding;

Route.State.Load.FuelLoad = tripFuel + Route.State.Load.TaxiFuel + Route.State.Load.ExtraFuel ...
    + Route.State.Load.ContingencyFuel + Route.State.Load.AlternateFuel + Route.State.Load.FinalReserveFuel;

%
fprintf(['<--- Short Range Iteration --->\n']);

Aircraft.assignMass(Route.State.Load.Payload, Route.State.Load.FuelLoad);
% Take Off
Route.doTakeoff(Aircraft,Earth,Departure);
% Climb (Climb up to optimal SR altitude)
Route.doClimb(Aircraft,Earth,Route.State.cutAlt);
% Descent (Descent from ceiling)
Route.doDescent(Aircraft,Earth,Arrival);
% Landing
Route.doLand(Aircraft,Earth,Arrival);

Route.State.Load.TripFuelFinal = Route.State.Landing(end).FuelCons;
Route.State.Load.FuelLoadFinal = Route.State.Load.ExtraFuel + ...
    Route.State.Load.ContingencyFuel + ...
    Route.State.Load.AlternateFuel + ...
    Route.State.Load.FinalReserveFuel + ...
    Route.State.Load.TripFuelFinal;

Route.Errors.FlownDistanceError = Route.Distance.Total - Route.Distance.Flown;
Route.Errors.FuelError = Route.State.Takeoff(1).Fuel - Route.State.Landing(end).FuelCons;
end