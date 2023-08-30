function turbopropF(obj)
% turbopropF Fuel for Turboprop Engine
%
% Synopsis: turbopropF(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

KTAS = obj.OnFly.Velocity.KTAS;
Thr = obj.OnFly.Results.ThrustForce;

obj.OnFly.Coeff.FuelCoeff = obj.ACM.PFM.CF(1)*(1+KTAS/obj.ACM.PFM.CF(2))*KTAS/1000; % TSFC, kg/min/kN
fnom = obj.OnFly.Coeff.FuelCoeff * Thr /60;

if strcmpi(obj.OnFly.Phase.thrustMode,'idle')
    fmin = obj.ACM.PFM.CF(3)*(1-obj.ACM.PFM.CF(4));
    obj.OnFly.Result.FuelConsumption = max(fnom,fmin);
elseif strcmpi(obj.OnFly.Phase.phaseName,'cruise')
    obj.OnFly.Result.FuelConsumption = fnom * obj.ACM.PFM.CFCR;
else
    obj.OnFly.Result.FuelConsumption = fnom;
end
end

