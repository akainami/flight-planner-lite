function evaluateSimpleProfile(Route, Earth, Aircraft)
% evaluateSimpleProfile Simple Profile Implementation
%
% Synopsis: evaluateSimpleProfile(Route, Earth, Aircraft)
%
% Input:    Route = (required) Mission object
%           Earth = (required) Planet object
%           Aircraft = (required) Aircraft object
%
% Output:
%
% See also: Mission/fly.
%

Arrival   = Route.Arrival;
Departure = Route.Departure;
iterRange = 1;

%% Create
if isempty(Arrival)
    error('Where to land?')
end

Route.Distance.CruiseNominal = Route.Distance.Total; % Initial Guess

%% Range Super Iterations
while true % Range Loop
    fprintf(['<--- Iteration #' char(string(iterRange)) '--->\n']);
    % Precautions
    Aircraft.assignMass(Route.State.Load.Payload, Route.State.Load.FuelLoad);
    % Take Off
    Route.doTakeoff(Aircraft,Earth,Departure);
    % Climb (Climb up to optimal SR altitude)
    Route.doClimb(Aircraft,Earth);
    % Cruise (Cruise at optimal SR altitude)
    Route.doCruise(Aircraft,Earth);
    % Descent (Descent from ceiling)
    Route.doDescent(Aircraft,Earth,Arrival);
    % Landing
    Route.doLand(Aircraft,Earth,Arrival);
    
    % Short Range Criteria
    if Route.Distance.Climb + Route.Distance.Descent > Route.Distance.Total
        fprintf('Mission is short-ranged. Fall back algorithm is run.\n');
        Route.State.shortRangeCriteria = true;
        break
    end
    
    % Evaluate Range Error
    flightDistanceError = Route.Distance.Total - Route.Distance.Flown ;
    Route.Distance.CruiseNominal = Route.Distance.Cruise + flightDistanceError;
    
    if flightDistanceError < 0
        fprintf('Overflown Distance Error = %f.\n',flightDistanceError);
    else
        fprintf('More-to-fly Distance Error = %f.\n',flightDistanceError);
    end
    
    if abs(flightDistanceError) < Route.Errors.RangeError
        break
    end
    
    if iterRange > Route.Errors.RangeIterLimit
        fprintf('Distance did not Converge.\n');
        break
    end
    
    iterRange = iterRange + 1;
    
    % Short Range Criteria
    if Route.State.shortRangeCriteria
        return
    end
    
    Route.State.Load.TripFuelNominal = Route.State.Landing(end).FuelCons;
    
    %% Second Iteration for Trip Fuel
    Route.State.Load.FuelLoad = Route.State.Load.ExtraFuel + ...
        Route.State.Load.ContingencyFuel + ...
        Route.State.Load.AlternateFuel + ...
        Route.State.Load.FinalReserveFuel + ...
        Route.State.Load.TripFuelNominal;
    
    fprintf('#-- Iteration for Trip Fuel---#\n');
    Aircraft.assignMass(Route.State.Load.Payload, Route.State.Load.FuelLoad);
    % Take Off
    Route.doTakeoff(Aircraft,Earth,Departure);
    % Climb (Climb up to optimal SR altitude)
    Route.doClimb(Aircraft,Earth);
    % Cruise (Cruise at optimal SR altitude)
    Route.doCruise(Aircraft,Earth);
    % Descent (Descent from ceiling)
    Route.doDescent(Aircraft,Earth,Arrival);
    % Landing
    Route.doLand(Aircraft,Earth,Arrival);
    
    % Results
    Route.State.Load.TripFuelFinal = Route.State.Landing(end).FuelCons;
    Route.State.Load.FuelLoadFinal = Route.State.Load.ExtraFuel + ...
        Route.State.Load.ContingencyFuel + ...
        Route.State.Load.AlternateFuel + ...
        Route.State.Load.FinalReserveFuel + ...
        Route.State.Load.TripFuelFinal;
    flightDistanceError = Route.Distance.Total - Route.Distance.Flown ;
    Route.Distance.CruiseNominal = Route.Distance.Cruise + flightDistanceError;
    
    if flightDistanceError < 0
        fprintf('Overflown Distance Error = %f.\n',flightDistanceError);
    else
        fprintf('More-to-fly Distance Error = %f.\n',flightDistanceError);
    end
    Route.Errors.FlownDistanceError = flightDistanceError;
end% End Range Loop
end