function windCorrection(obj,inputs)
% windCorrection Wind Correction for Airspeeds
%
% Synopsis: windCorrection(obj, inputs)
%
% Input:    obj      = (required) BADA3 object
%           inputs   = (required) inputs map
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

% Wind Input -> Exists or catches
% Absolute Refers to North
% Adjust Wind Direction if standards conflict

try
    % Correct Directions
    inputs = correctDirections(inputs);
    % Direction is in boundary [-180 180], Magnitude value is corrected
    obj.OnFly.Velocity.WIND = inputs('WindMagnitude');
    obj.OnFly.Directions.DirAbs = inputs('WindDirAbs');
catch % Use Default
    obj.OnFly.Velocity.WIND = 0;
    obj.OnFly.Directions.DirAbs = 0;
end

% Wind Direction Related to Aircraft Determination
% Aircraft Determination Refers to North
try
    % Angle between wind and aircraft
    obj.OnFly.Directions.AircraftDir = inputs('AircraftDir');
catch
    % Assume 0 for dummy applications (ie. no aircraft heading)
    obj.OnFly.Directions.AircraftDir = 0; % North
end

% Relative Angle
relativeAngle(obj);

% Introduce Wind Deflection [m/s]
obj.OnFly.Velocity.WIND_DEFLECTION = - obj.OnFly.Velocity.WIND * sind(obj.OnFly.Directions.WindRel);

end

function obj = relativeAngle(obj)
% Unit Wind Vectors
[xw,yw] = polar2rect(1,obj.OnFly.Directions.DirAbs);
% Unit Aircraft Vectors
[xa,ya] = polar2rect(1,obj.OnFly.Directions.AircraftDir);
% Angle Between Two Unit Vectors
if xa+xw ~= 0 || ya+yw ~= 0
    obj.OnFly.Directions.WindRel = 180 - acosd((xw*xa+yw*ya)/(sqrt(xw^2+yw^2)*sqrt(xa^2+ya^2)));
else
    obj.OnFly.Directions.WindRel = 180;
end

% Shifted Angle
R = obj.OnFly.Directions.DirAbs - obj.OnFly.Directions.AircraftDir;
while (R > 180)
    R = R - 360;
end
while (R < -180)
    R = R + 360;
end
if R > 0
    obj.OnFly.Directions.WindRel = -obj.OnFly.Directions.WindRel;
end

end

function [x,y] = polar2rect(r,theta)
x = r*sind(theta); % East -> x
y = r*cosd(theta); % North -> y
end

function inputs = correctDirections(inputs)
% Invert if magnitude is negative
    if inputs('WindMagnitude') < 0
        inputs('WindDirAbs') = inputs('WindDirAbs') - 180;
        inputs('WindMagnitude') = inputs('WindMagnitude') * -1;
    end
    % Use periods if exceed (-180,180) interval
    % Wind
    while inputs('WindDirAbs') > 180
        inputs('WindDirAbs') = inputs('WindDirAbs') - 360;
    end
    while inputs('WindDirAbs') < -180
        inputs('WindDirAbs') = inputs('WindDirAbs') + 360;
    end
    % Aircraft
    while inputs('AircraftDir') > 180
        inputs('AircraftDir') = inputs('AircraftDir') - 360;
    end
    while inputs('AircraftDir') < -180
        inputs('AircraftDir') = inputs('AircraftDir') + 360;
    end
end