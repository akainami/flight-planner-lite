function [M] = tas2mach(VTAS,objAtmos)
% tas2mach
%
% Synopsis: tas2mach(VTAS,objAtmos)
%
% Input:    VTAS = True Airspeed
%           objAtmos = Atmosphere object 
%
% Output: M = Mach Number
%
% See also: .
%

M = VTAS / objAtmos.SPEEDSOUND;
end

