function init(Route,Aircraft,Earth)
% init Initialize Mission Object
%
% Synopsis: init(obj)
%
% Input:    obj      = (required) Mission object
%           Earth      = (required) Planet object
%           Aircraft   = (required) Aircraft object
%
% Output:
%
% See also: Mission/waypoints.
%
tic;

Route.State = struct;
Route.Errors = struct;
Route.waypoints;
Route.headings;

Route.checkAlternate(Aircraft,Earth); % Add Alternates

Route.alternatePaths; % Alternate Paths

Route.DiversionPath(Aircraft,Earth); % Diversion Paths

Route.horizontalPathOptimization; 

fprintf('Route initialized in %.2f s\n',toc);
end