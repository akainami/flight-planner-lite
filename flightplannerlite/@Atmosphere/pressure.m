function pressure(obj)
% pressure Pressure
%
% Synopsis: pressure (obj)
%
% Input:    obj = Atmosphere object
% 
% Output: 
%
% See also: .
%
obj.PRESSURE_TROP = obj.PRESSURE_0*((obj.TEMPERATURE_TROP-obj.DELTA_T)/...
    obj.TEMPERATURE_0)^(-obj.GRAVITY_0/obj.TEMP_GRAD_BELOWTROP/obj.GAS_CONSTANT);

if obj.ALTITUDE_P <= obj.ALTITUDE_TROP % TROPOPAUSE
    obj.PRESSURE = obj.PRESSURE_0*(obj.TEMPERATURE_ISA/obj.TEMPERATURE_0)...
        ^(-obj.GRAVITY_0/obj.TEMP_GRAD_BELOWTROP/obj.GAS_CONSTANT);
else
    obj.PRESSURE = obj.PRESSURE_TROP * exp(-obj.GRAVITY_0/obj.GAS_CONSTANT/...
        (obj.TEMPERATURE_TROP-obj.DELTA_T)*(obj.ALTITUDE_P-obj.ALTITUDE_TROP));
end
end