function plotMissionPath(Route)
% plotGreatCircle
%
% Synopsis: plotGreatCircle(objRoute,objAircraft)
%
% Input:  objRoute = Route object
%         objEarth = Aircraft object
%
% Output:
%
% See also: .
%

tic;

% Plot
hold on;
orange = [255 160 0]/255;
try
    plot([Route.State.Takeoff.Distance]*units.m2nmi,[Route.State.Takeoff.Altitude]*units.m2ft,'k');
    area([Route.State.Takeoff.Distance]*units.m2nmi,[Route.State.Takeoff.TerrainElevation]*units.m2ft,'FaceColor',orange);
    plot([Route.State.Takeoff.Distance]*units.m2nmi,Route.State.SafetyMargin_ft + [Route.State.Takeoff.TerrainElevation]*units.m2ft,'--','Color',[1 0.5 0]);
catch
end
try
    plot([Route.State.Climb.Distance]*units.m2nmi,[Route.State.Climb.Altitude]*units.m2ft,'k');
    area([Route.State.Climb.Distance]*units.m2nmi,[Route.State.Climb.TerrainElevation]*units.m2ft,'FaceColor',orange);
    plot([Route.State.Climb.Distance]*units.m2nmi,Route.State.SafetyMargin_ft + [Route.State.Climb.TerrainElevation]*units.m2ft,'--','Color',[1 0.5 0]);
catch
end
try
    plot([Route.State.Cruise.Distance]*units.m2nmi,[Route.State.Cruise.Altitude]*units.m2ft,'-.r');
    plot([Route.State.Cruise.Distance]*units.m2nmi,[Route.State.Cruise.BaseAltitude]*units.m2ft,'k','Color',[0.3 0.3 0.3]);
    area([Route.State.Cruise.Distance]*units.m2nmi,[Route.State.Cruise.TerrainElevation]*units.m2ft,'FaceColor',orange);
    plot([Route.State.Cruise.Distance]*units.m2nmi,Route.State.SafetyMargin_ft + [Route.State.Cruise.TerrainElevation]*units.m2ft,'--','Color',[1 0.5 0]);
catch
end
try
    plot([Route.State.Descent.Distance]*units.m2nmi,[Route.State.Descent.Altitude]*units.m2ft,'k');
    area([Route.State.Descent.Distance]*units.m2nmi,[Route.State.Descent.TerrainElevation]*units.m2ft,'FaceColor',orange);
    plot([Route.State.Descent.Distance]*units.m2nmi,Route.State.SafetyMargin_ft + [Route.State.Descent.TerrainElevation]*units.m2ft,'--','Color',[1 0.5 0]);
catch
end
try
    plot([Route.State.Landing.Distance]*units.m2nmi,[Route.State.Landing.Altitude]*units.m2ft,'k');
    area([Route.State.Landing.Distance]*units.m2nmi,[Route.State.Landing.TerrainElevation]*units.m2ft,'FaceColor',orange);
    plot([Route.State.Landing.Distance]*units.m2nmi,Route.State.SafetyMargin_ft + [Route.State.Landing.TerrainElevation]*units.m2ft,'--','Color',[1 0.5 0]);
catch
end
title('Mission Profile');
xlabel('Ground Distance [nmi]');
ylabel('Altitude [ft]');
try
    xlim([-10,max([Route.State.Landing.Distance]*units.m2nmi)+20]);
catch
end
ylim([0 max([Route.State.Descent.Altitude]*units.m2ft*1.1)]);
hold off;

fprintf('Mission Profile is drawn in %.2f s\n',toc);
end