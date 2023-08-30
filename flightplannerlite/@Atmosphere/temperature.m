function temperature(obj)
% temperature Temperature
%
% Synopsis: temperature(obj)
%
% Input:    obj = Atmosphere object
% 
% Output: 
%
% See also: .
%

obj.TEMPERATURE_TROP = obj.TEMPERATURE_0 + obj.ALTITUDE_TROP *...
    obj.TEMP_GRAD_BELOWTROP + obj.DELTA_T;

obj.TEMPERATURE_ISAMSL = obj.TEMPERATURE_0 + obj.ALTITUDE_PMSL *...
    obj.TEMP_GRAD_BELOWTROP;
obj.TEMPERATURE_MSL = obj.TEMPERATURE_ISAMSL + obj.DELTA_T;

if obj.ALTITUDE_P <= obj.ALTITUDE_TROP
    obj.TEMPERATURE_ISA = obj.TEMPERATURE_0 + obj.ALTITUDE_P *...
        obj.TEMP_GRAD_BELOWTROP;
    obj.TEMPERATURE= obj.TEMPERATURE_ISA + obj.DELTA_T;
else
    obj.TEMPERATURE_ISA = obj.TEMPERATURE_TROP;
    obj.TEMPERATURE = obj.TEMPERATURE_TROP - obj.DELTA_T;
end

obj.ALTITUDE_ZEROPRESSALT = 1/obj.TEMP_GRAD_BELOWTROP*(obj.TEMPERATURE_0 - ...
    obj.TEMPERATURE_ISAMSL + obj.DELTA_T * log(obj.TEMPERATURE_0/obj.TEMPERATURE_ISAMSL));

end