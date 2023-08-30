function turbofanF(obj)
% turbofanF Fuel for Turbofan Engine
%
% Synopsis: turbofanF(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

KTAS = obj.OnFly.Velocity.KTAS; % kts
Thr = obj.OnFly.Result.ThrustForce; % N
Hp = obj.ISA.ALTITUDE_P; % m

obj.OnFly.Coeff.FuelCoeff = obj.ACM.PFM.CF(1)*(1+KTAS/obj.ACM.PFM.CF(2)); % TSFC, kg/min/kN
fnom = obj.OnFly.Coeff.FuelCoeff * Thr /60/1000;

if strcmpi(obj.OnFly.Phase.thrustMode,'idle')
    fmin = (obj.ACM.PFM.CFidle(1)*(1-Hp*units.m2ft/obj.ACM.PFM.CFidle(2)))/60;
    obj.OnFly.Result.FuelConsumption = max(fnom,fmin);
elseif strcmpi(obj.OnFly.Phase.PhaseName,'cruise')
    obj.OnFly.Result.FuelConsumption = fnom * obj.ACM.PFM.CFCR;
else
    obj.OnFly.Result.FuelConsumption = fnom;
end
end