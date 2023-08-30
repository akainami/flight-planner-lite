function fly(Route, Earth, Aircraft)
% fly Mission Phases Master Function
%
% Synopsis: fly(Route, Earth, Aircraft)
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

%% Configurate Iteration Parameters
Route.State.TOdTime = 2; % s
Route.State.CLDEdAlt = 250; % ft
Route.State.CRsteps = 100; % X_cr/dX
Route.State.AltOptimSteps = 5;
Route.State.LDdTime = 2; % s

%% Define Initial Useful Load Breakdown for Mission
Route.State.FinalReserveTime = 30*60; % min*60, s
Route.State.SafetyMargin_ft = 2000; % ft
Route.State.Load.EmptyWeight = Aircraft.OnFly.Load.OEW;
Route.State.Load.Payload = 12000; % kg TBC
Route.State.Load.TaxiFuel = 150; % kg, constant
Route.State.Load.ExtraFuel = 0; % kg TBC
Route.State.Load.ContingencyFuel = 0; % kg TBC
Route.calculateReserveFuel(Earth, Aircraft); % Alternate and Final Reserve Fuels

Route.State.Load.FuelLoad = Aircraft.Limits.MTOW-Aircraft.Limits.OEW-Aircraft.OnFly.Load.PL; % kg % TBC
%% Set Error Tolerances
Route.Errors.RangeIterLimit = 3;
Route.Errors.RangeError = 250; % m
Route.Errors.FuelError = 250; % kg
Route.State.shortRangeCriteria = false;

%% Simple Profile
Route.evaluateSimpleProfile(Earth,Aircraft);
Route.evaluateShortRangeProfile(Earth,Aircraft);

fprintf('Mission flown in %.2f s\n',toc(ttic));
fprintf('<--- Mission Parameters --->\n');
fprintf('Distance Flown is %.2f km.\n',string(Route.Distance.Flown/1e3));
fprintf('Required Fuel Loading is %.3f kg.\n',string(Route.State.Load.FuelLoadFinal));
fprintf('Flight lasts %.3f h.\n',string(Route.State.Landing(end).Time/3600));
fprintf('<-------------------------->\n');
end