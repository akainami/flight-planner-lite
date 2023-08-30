function VCAS = assignARPM_PistonProp(obj,VCAS1,VCAS2,M)
% assignARPM_PistonProp Procedural Nominal Speeds for Piston and Turboprop Aircraft
%
% Synopsis: assignARPM_PistonProp(obj, VCAS1, VCAS2, M, inputs)
%
% Input:    obj      = (required) BADA3 object
%           VCAS     = (required) VCAS1 value provided by model
%           VCAS2    = (required) VCAS2 value provided by model
%           M        = (required) M value provided by model
%           inputs   = (required) inputs map
%
% Output:   obj      = Updated BADA3 object
%
% See also: stallspeed, source.functions.machcastransition,BADA3
% source.functions.cas2tas,source.functions.tas2cas, source.functions.tas2mach,
% source.functions.mach2tas, units.ms2kts, units.ft2m, units.kts2ms.
%

phase = obj.OnFly.Phase.PhaseName;
Cvmin = 1.23;
CvminTO = 1.13;

[~] = CvminTO;

% M-CAS Transition altitude is in meters
H_Mtrs = source.functions.machcastransition(VCAS2*units.kts2ms, M, obj.ISA);

didCatch = false;
%% SpeedMode Assign
try
    obj.OnFly.speedMode = inputs('speedMode');
catch
    didCatch = true;
    % Default Mode
    obj.OnFly.speedMode = 'CAS';
end

% Assign Nominal Speeds According to Air Traffic Control

% Stall Speed of Aircraft
[~] = stallspeed(obj);

if strcmp(phase, 'Climb')
    vsto = takeoffstallspeed(obj);
    %% Climb
    if     obj.ISA.ALTITUDE_P < 500*units.ft2m
        KCAS = Cvmin * vsto + 20;
    elseif obj.ISA.ALTITUDE_P < 1000*units.ft2m
        KCAS = Cvmin * vsto + 30;
    elseif obj.ISA.ALTITUDE_P < 1500*units.ft2m
        KCAS = Cvmin * vsto + 35;
    elseif obj.ISA.ALTITUDE_P < 10000*units.ft2m
        KCAS = min(VCAS1,250);
    elseif obj.ISA.ALTITUDE_P < H_Mtrs || (obj.ISA.ALTITUDE_P >= H_Mtrs && ~didCatch)
        KCAS = VCAS2;
    else
        KCAS = source.functions.tas2cas(...
            source.functions.mach2tas(M,obj.ISA),obj.ISA)*units.ms2kts;
        % Correct if over crossover altitude
        if didCatch
            obj.OnFly.speedMode = 'M';
        end
    end
elseif strcmp(phase, 'Cruise')
    %% Cruise
    if obj.ISA.ALTITUDE_P < 3000*units.ft2m
        KCAS = min(VCAS1,150);
    elseif obj.ISA.ALTITUDE_P < 6000*units.ft2m
        KCAS = min(VCAS1,180);
    elseif obj.ISA.ALTITUDE_P < 10000*units.ft2m
        KCAS = min(VCAS1,250);
    elseif obj.ISA.ALTITUDE_P < H_Mtrs || (obj.ISA.ALTITUDE_P >= H_Mtrs && ~didCatch)
        KCAS = VCAS2;
    else
        % Correct if over crossover altitude
        if didCatch
            obj.OnFly.speedMode = 'M';
        end
        KCAS = source.functions.tas2cas(...
            source.functions.mach2tas(M,obj.ISA),obj.ISA)*units.ms2kts;
    end
    
elseif strcmp(phase, 'Descent')
    vsld = landingstallspeed(obj);
    %% Descent
    if obj.ISA.ALTITUDE_P < 500*units.ft2m
        KCAS = Cvmin * vsld + 5;
    elseif obj.ISA.ALTITUDE_P < 1000*units.ft2m
        KCAS = Cvmin * vsld + 10;
    elseif obj.ISA.ALTITUDE_P < 1500*units.ft2m
        KCAS = Cvmin * vsld + 20;
    elseif obj.ISA.ALTITUDE_P < 10000*units.ft2m
        KCAS = VCAS1;
    elseif obj.ISA.ALTITUDE_P < H_Mtrs || (obj.ISA.ALTITUDE_P >= H_Mtrs && ~didCatch)
        KCAS = VCAS2;
    else
        % Correct if over crossover altitude
        if didCatch
            obj.OnFly.speedMode = 'M';
        end
        KCAS = source.functions.tas2cas(...
            source.functions.mach2tas(M,obj.ISA),obj.ISA)*units.ms2kts;
    end
elseif strcmp(obj.OnFly.Phase.PhaseName,'Landing')
    KCAS = obj.landingstallspeed * Cvmin;
    obj.OnFly.Phase.speedMode = 'CAS';
elseif strcmp(obj.OnFly.Phase.PhaseName,'Takeoff')
    KCAS = obj.takeoffstallspeed * CvminTO;
    obj.OnFly.Phase.speedMode = 'CAS';
end

VCAS = KCAS*units.kts2ms;
end