function [MCAS_ALT] = machcastransition(VCAS,M,objAtmos)
% machcastransition
%
% Synopsis:  machcastransition(VCAS,M,objAtmos)
%
% Input:    VCAS = Calibrated Airspeed
%           M = Mach Number
%           objAtmos = Atmosphere object 
%
% Output: MCAS_ALT = Mach/CAS Transition Altitude in meters
%
% See also: .
%
deltaTrans = ((1+(objAtmos.AIR_INDEX-1)/2*(VCAS/objAtmos.SPEEDSOUND_0)^2)^...
    (objAtmos.AIR_INDEX/(objAtmos.AIR_INDEX-1))-1)...
    /(((1+(objAtmos.AIR_INDEX-1)/2*M^2)^...
    (objAtmos.AIR_INDEX/(objAtmos.AIR_INDEX-1))-1));

thetaTrans = deltaTrans^(-objAtmos.TEMP_GRAD_BELOWTROP*objAtmos.GAS_CONSTANT...
    /objAtmos.GRAVITY_0);

MCAS_ALT = (1000/0.3048/6.5)*(objAtmos.TEMPERATURE_0*(1-thetaTrans))*0.3048; % m
end

