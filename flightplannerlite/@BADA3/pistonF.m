function pistonF(obj)
% pistonF Fuel for Piston Engine
%
% Synopsis: pistonF(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

obj.OnFly.Coeff.FuelCoeff = NaN; % TSFC, kg/min/kN
fnom = obj.ACM.PFM.CF(1);

if strcmpi(obj.OnFly.Phase.thrustMode,'idle')
    obj.OnFly.Result.FuelConsumption = obj.ACM.PFM.CF(3);
elseif strcmpi(obj.OnFly.Phase.phaseName,'cruise')
    obj.OnFly.Result.FuelConsumption = fnom * obj.ACM.PFM.CFCR;
else
    obj.OnFly.Result.FuelConsumption = fnom;
end
end

