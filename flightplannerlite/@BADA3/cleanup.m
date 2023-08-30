function cleanup(obj)
% cleanup Clear Aircraft OnFly Data
%
% Synopsis: cleanup(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%

obj.OnFly.Phase = [];
obj.OnFly.Velocity = [];
obj.OnFly.Coeff = [];
obj.OnFly.Directions = [];
obj.OnFly.Result = [];
end

