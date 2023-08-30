function cruiseThrust(obj)
% cruiseThrust Cruise Thrust Assumption
%
% Synopsis: cruiseThrust(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

% Assume T = D
obj.OnFly.Result.ThrustForce = obj.OnFly.Result.DragForce;
obj.OnFly.Coeff.ThrustCoeff = obj.OnFly.Result.ThrustForce/...
    (obj.ISA.PRESS_RATIO*obj.OnFly.Load.WeightRef);
end

