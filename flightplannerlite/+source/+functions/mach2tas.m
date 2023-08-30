function [VTAS] = mach2tas(M,objAtmos)
% mach2tas
%
% Synopsis: mach2tas(M,objAtmos)
%
% Input:    M = Mach Number
%           objAtmos = Atmosphere object 
%
% Output: VTAS = True Airspeed
%
% See also: .
%
VTAS = M * objAtmos.SPEEDSOUND;
end

