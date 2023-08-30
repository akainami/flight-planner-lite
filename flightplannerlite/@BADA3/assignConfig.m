function assignConfig(obj,inputs)
% assignConfig Configuration for High Lift & Landing Gear & Airbrakes
%
% Synopsis: assignConfig(obj, inputs)
%
% Input:    obj      = (required) BADA3 object
%           inputs   = (required) inputs map
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%
try
    % Manual Configuration
    cX = inputs('ConfigurationIndex');
catch
    for i = 1 : length([obj.ACM.AFCM.Configuration])
        if strcmp(obj.ACM.AFCM.Configuration(i).phase,obj.OnFly.Phase.PhaseID)
            cX = i;
            break
        end
    end
end
obj.OnFly.Phase.configIndex = cX; % cX is configuration index

obj.OnFly.Phase.thrustMode = inputs('ThrustMode');

try
    obj.OnFly.Phase.BankAngle  = inputs('BankAngle');
catch
    obj.OnFly.Phase.BankAngle  = 0;
end
%% Assign Path Angle
try
    obj.OnFly.Result.PathAngle  = inputs('PathAngle');
catch
    obj.OnFly.Result.PathAngle  = 0;
end
end

