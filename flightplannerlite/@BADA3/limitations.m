function limitations(obj)
% limitations Aircraft Limitations Model
%
% Synopsis: limitations(obj)
%
% Input:    obj      = (required) BADA3 object

% Output:   obj      = Updated BADA3 object
%
% See also: stallspeed, source.functions.machcastransition,
% source.functions.cas2tas,source.functions.tas2cas, source.functions.tas2mach,
% source.functions.mach2tas, units.ms2kts, units.ft2m, units.kts2ms.
%

% REMOVE ASSIGNMENTS & KEEP CHECKS

% Ceiling
obj.Limits.Ceiling = obj.ACM.ALM.GLM.hmo*units.ft2m;
obj.Limits.Mmax = obj.ACM.ALM.KLM.mmo;
obj.Limits.KCASmax = obj.ACM.ALM.KLM.vmo;
% If exceeded
if obj.ISA.ALTITUDE_P > obj.Limits.Ceiling
%     error('Ceiling Exceeded.')
end

% Max Calibrated Airspeed
if obj.OnFly.Velocity.M > obj.Limits.Mmax || ...
        obj.OnFly.Velocity.KCAS > obj.Limits.KCASmax
    error('Airspeed Exceeded.')
end

% Weight Limitations
obj.Limits.OEW  = obj.ACM.ALM.DLM.OEW;
obj.Limits.MTOW = obj.ACM.ALM.DLM.MTOW;
obj.Limits.MPL  = obj.ACM.ALM.DLM.MPL;
obj.Limits.MFL  = obj.ACM.ALM.DLM.MTOW - obj.ACM.ALM.DLM.MPL - obj.ACM.ALM.DLM.OEW;
% Check Limits
% MTOW
if obj.OnFly.Load.Mass > obj.Limits.MTOW
    error('Aircraft mass exceeds maximum take off weight.');
end
% Fuel
if obj.OnFly.Load.FL > obj.Limits.MFL
%     error('Fuel Tanks are full. Check FL.');
elseif obj.OnFly.Load.FL < 0
    error('Fuel Tanks are empty. Check FL.');
end
% Payload
if obj.OnFly.Load.PL > obj.Limits.MPL
    error('Payload limits are exceeded. Check PL.');
end

obj.Limits.W_OEW  = obj.ACM.ALM.DLM.OEW*obj.ISA.GRAVITY_0;
obj.Limits.W_MTOW = obj.ACM.ALM.DLM.MTOW*obj.ISA.GRAVITY_0;
obj.Limits.W_MPL  = obj.ACM.ALM.DLM.MPL*obj.ISA.GRAVITY_0;

% Load Factor Limits
obj.Limits.Nmax = 2.5;
obj.Limits.Nmin = -1;

if obj.Limits.Nmax < 1/cosd(obj.OnFly.Phase.BankAngle)
    error('Load factor exceeded, decrease bank angle.')
end

% Temp Deviation Limits
obj.Limits.TempDevMax = 30;
obj.Limits.TempDevMin = -20;

end