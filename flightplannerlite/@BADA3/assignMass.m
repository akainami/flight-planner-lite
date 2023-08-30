function assignMass(obj, PL, FL)
% assignMass Mass Breakdowns and Assignments
%
% Synopsis: assignMass(obj, CPW, PL, FL)
%
% Input:    obj      = (required) BADA3 object
%           PL = (required) Payload Weight
%           FL = (required) Fuel Weight
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

% Mass [kg]
obj.OnFly.Load.PL = PL;
obj.OnFly.Load.FL = FL;
obj.OnFly.Load.OEW = obj.ACM.ALM.DLM.OEW;
obj.OnFly.Load.Mass = PL + FL + obj.ACM.ALM.DLM.OEW;
end

