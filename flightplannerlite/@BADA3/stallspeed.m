function KCASstall = stallspeed(obj)
% stallspeed Stall Speed for Actual Conf.
%
% Synopsis: turbopropT(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   KCASstall= Stall speed of aircraft in knots (calibrated)
%
% See also: calculate, cleanCLmax.
%

% GET FROM AFCM CONFIG

cfid = obj.OnFly.Phase.configIndex;
KCASstall = obj.ACM.AFCM.Configuration(cfid).vstall;
obj.OnFly.Velocity.VCASstall = KCASstall*units.kts2ms;
obj.OnFly.Velocity.VTASstall = source.functions.cas2tas(obj.OnFly.Velocity.VCASstall, obj.ISA);
obj.OnFly.Velocity.Mstall = source.functions.tas2mach(obj.OnFly.Velocity.VTASstall, obj.ISA);

obj.OnFly.Coeff.MaxLiftCoeff = obj.OnFly.Load.Weight/(obj.ACM.AFCM.S*...
    obj.ISA.DENSITY/2*obj.OnFly.Velocity.VTASstall^2);
end

