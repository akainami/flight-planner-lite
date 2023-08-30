function massEval(obj)
% massEval Weight Evaluations 
%
% Synopsis: massEval(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

% Weight [N]
obj.OnFly.Load.Weight = obj.OnFly.Load.Mass * obj.ISA.GRAVITY_0;
obj.OnFly.Load.WeightRef = obj.ACM.PFM.MREF * obj.ISA.GRAVITY_0;
end

