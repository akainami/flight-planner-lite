function evaluate(obj,ALTITUDE_P,DELTA_T,DELTA_P)
% evaluate Initialize Atmosphere Object
%
% Synopsis: evaluat(obj,ALTITUDE_P, DELTA_T, DELTA_P)
%
% Input:       obj = Atmosphere object
%       ALTITUDE_P = Pressure Altitude
%       DELTA_T = Temperature Offset
%       DELTA_P = Pressure Offset
%
% Output:
%
% See also: Atmosphere/density, Atmosphere/dynamic_visc, Atmosphere/pressure,
% Atmosphere/speedsound, Atmosphere/temperature.
%
obj.ALTITUDE_P = ALTITUDE_P;
obj.DELTA_T = DELTA_T;
obj.DELTA_P = DELTA_P;

obj.PRESSURE_MSL = obj.PRESSURE_0 + obj.DELTA_P;
obj.ALTITUDE_PMSL = obj.TEMPERATURE_0/obj.TEMP_GRAD_BELOWTROP*...
    ((obj.PRESSURE_MSL/obj.PRESSURE_0)^(-obj.TEMP_GRAD_BELOWTROP*...
    obj.GAS_CONSTANT/obj.GRAVITY_0)-1);

obj.temperature;
obj.pressure;
obj.density;
obj.speedsound;
obj.dynamic_visc;

obj.DENS_RATIO = obj.DENSITY / obj.DENSITY_0;
obj.PRESS_RATIO = obj.PRESSURE / obj.PRESSURE_0;
obj.TEMP_RATIO = obj.TEMPERATURE / obj.TEMPERATURE_0;
end