function [VCAS] = tas2cas(VTAS,objAtmos)
% tas2mcas
%
% Synopsis: tas2cas(VTAS,objAtmos)
%
% Input:    VTAS = True Airspeed
%           objAtmos = Atmosphere object 
%
% Output: VCAS = Calibrated Airspeed
%
% See also: .
%

mu = (objAtmos.AIR_INDEX - 1)/objAtmos.AIR_INDEX;
VCAS = sqrt(2/mu*objAtmos.PRESSURE_0/objAtmos.DENSITY_0*((1+objAtmos.PRESSURE...
    /objAtmos.PRESSURE_0*((1+mu/2*objAtmos.DENSITY/objAtmos.PRESSURE*VTAS^2)...
    ^(1/mu)-1))^mu-1));
end

