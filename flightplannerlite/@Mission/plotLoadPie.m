function plotLoadPie(Route)
% plotLoadPie Mission Weight Fractions
%
% Synopsis: plotLoadPie(Route)
%
% Input:    Route      = (required) Mission object
%
% Output:
%
% See also: .
%

Weights = [Route.State.Load.EmptyWeight ...
    Route.State.Load.Payload ...
    Route.State.Load.TaxiFuel ...
    Route.State.Load.AlternateFuel ...
    Route.State.Load.FinalReserveFuel ...
    Route.State.Load.TripFuelFinal];

Labels = {'Empty Weight','Payload','Taxi Fuel','Alternate Fuel'...
    ,'Final Reserve Fuel','Trip Fuel'};

if Route.State.Load.ExtraFuel > 0 
    Weights = [Weights Route.State.Load.ExtraFuel];
    Labels{end+1} = 'ExtraFuel';
end

if Route.State.Load.ContingencyFuel  > 0 
    Weights = [Weights Route.State.Load.ContingencyFuel];
    Labels{end+1} = 'ContingencyFuel';
end

title('Weight Fractions of Aircraft')
pie(Weights,[0 1 1 1 1 1]);
legend(Labels,'Location','northeastoutside');
end

