classdef Atmosphere < handle
    properties
        % INPUTS
        ALTITUDE_P % [m]
        DELTA_T % [K]
        DELTA_P % [Pa]
        % CONSTANTS
        TEMPERATURE_0 = 288.15; % K
        SPEEDSOUND_0 = 340.294; % m/s
        PRESSURE_0 = 101325; % Pa
        DENSITY_0 = 1.225; % kg/m3
        GRAVITY_0 = 9.80665; % m/s2
        
        AIR_INDEX = 1.4; % 
        GAS_CONSTANT = 287.05287; % m2/Ks2
        TEMP_GRAD_BELOWTROP = -0.0065; % K/m
        
        ALTITUDE_TROP = 11000; % m
        
        % TBC in order
        PRESSURE_MSL % [Pa]
        ALTITUDE_PMSL % [m]
        TEMPERATURE_ISAMSL % [K]
        TEMPERATURE_MSL % [K]
        ALTITUDE_ZEROPRESSALT % [m]
        
        TEMPERATURE_ISA % [K]
        TEMPERATURE_TROP % [K]
        PRESSURE_TROP % [Pa]
        
        DENSITY % [kg/m3]
        PRESSURE % [Pa]
        TEMPERATURE % [K]
        SPEEDSOUND % [m/s]
        DYNAMIC_VISCOSITY % [sPa]
        
        TEMP_RATIO % []
        DENS_RATIO % []
        PRESS_RATIO % []
    end
    methods
        % Atmosphere.density;
        % Atmosphere.dynamic_visc;
        % Atmosphere.init;
        % Atmosphere.pressure;
        % Atmosphere.speedsound;
        % Atmosphere.temperature;
    end
end