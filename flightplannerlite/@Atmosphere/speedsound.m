function speedsound(obj)
% speedsound Speed of Sound
%
% Synopsis: speedsound(obj)
%
% Input:    obj = Atmosphere object
% 
% Output: 
%
% See also: .
%

obj.SPEEDSOUND = sqrt(obj.GAS_CONSTANT*obj.AIR_INDEX*obj.TEMPERATURE);
end