function [VTAS] = cas2tas(VCAS,objAtmos)
% cas2tas
%
% Synopsis: cas2tas(VCAS,objAtmos)
%
% Input:  VCAS = Calibrated Airspeed
%         objAtmos = Atmosphere object 
%
% Output: VTAS = True Airspeed
%
% See also: .
%
mu = (objAtmos.AIR_INDEX - 1)/objAtmos.AIR_INDEX;
VTAS = sqrt(2/mu*objAtmos.PRESSURE/objAtmos.DENSITY*((1+objAtmos.PRESSURE_0...
    /objAtmos.PRESSURE*((1+mu/2*objAtmos.DENSITY_0/objAtmos.PRESSURE_0*VCAS^2)...
    ^(1/mu)-1))^mu-1));
end