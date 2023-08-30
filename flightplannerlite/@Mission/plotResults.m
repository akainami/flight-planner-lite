function plotResults(Route)
% plotResults
%
% Synopsis: plotResults(objRoute,objEarth)
%
% Input:  Route = Route object
%         Earth = Planet object
%
% Output:
%
% See also: .
%
figure;
subplot(7,7,36:48)
Route.plotMissionPath;

subplot(7,7,[1 2 3 8 9 10 15 16 17 22 23 24])
Route.plotLoadPie;
% subplot(7,7,[4:7 11:14 18:21 25:28]);
Route.plotMapTrajectory;
end