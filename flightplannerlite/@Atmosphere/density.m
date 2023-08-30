function density(obj)
% density Density
%
% Synopsis: density(obj)
%
% Input:    obj = Atmosphere object
% 
% Output: 
%
% See also: .
%

obj.DENSITY = obj.PRESSURE/obj.TEMPERATURE/obj.GAS_CONSTANT;
end