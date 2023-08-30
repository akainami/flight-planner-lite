function [VCAS] = assignARPM_Jet(obj,VCAS1,VCAS2,M,inputs)
% assignARPM_Jet Procedural Nominal Speeds for a Jet
%
% Synopsis: assignARPM_Jet(obj, VCAS1, VCAS2, M, inputs)
%
% Input:    obj      = (required) BADA3 object
%           VCAS     = (required) VCAS1 value provided by model
%           VCAS2    = (required) VCAS2 value provided by model
%           M        = (required) M value provided by model
%           inputs   = (required) inputs map
%
% Output:   obj      = Updated BADA3 object
%
% See also: stallspeed, landingstallspeed, takeoffstallspeed, source.functions.machcastransition,
% source.functions.cas2tas,source.functions.tas2cas, source.functions.tas2mach,
% source.functions.mach2tas, units.ms2kts, units.ft2m, units.kts2ms.
%

phase = obj.OnFly.Phase.PhaseName;
Cvmin = 1.3;
CvminTO = 1.2;

[~] = CvminTO;

% M-CAS Transition altitude is in meters
H_Mtrs = source.functions.machcastransition(VCAS2*units.kts2ms, M, obj.ISA);
obj.OnFly.Velocity.CASM_TRANS_M = H_Mtrs;
didCatch = false;
%% SpeedMode Assign
try
    obj.OnFly.Phase.speedMode = inputs('speedMode');
catch
    didCatch = true;
    % Default Mode
    obj.OnFly.Phase.speedMode = 'CAS';
end

% Assign Nominal Speeds According to Air Traffic Control

% Stall Speed of Aircraft
[~] = stallspeed(obj);

if strcmp(phase, 'Climb')
    vsto = takeoffstallspeed(obj);
    %% Climb
    if     obj.ISA.ALTITUDE_P < 1500*units.ft2m
        KCAS = Cvmin * vsto + 5;
    elseif obj.ISA.ALTITUDE_P < 3000*units.ft2m
        KCAS = Cvmin * vsto + 10;
    elseif obj.ISA.ALTITUDE_P < 4000*units.ft2m
        KCAS = Cvmin * vsto + 30;
    elseif obj.ISA.ALTITUDE_P < 5000*units.ft2m
        KCAS = Cvmin * vsto + 60;
    elseif obj.ISA.ALTITUDE_P < 6000*units.ft2m
        KCAS = Cvmin * vsto + 80;
    elseif obj.ISA.ALTITUDE_P < 10000*units.ft2m
        KCAS = min(VCAS1,250);
    elseif obj.ISA.ALTITUDE_P < H_Mtrs || (obj.ISA.ALTITUDE_P >= H_Mtrs && ~didCatch)
        KCAS = VCAS2;
    else
        KCAS = source.functions.tas2cas(...
            source.functions.mach2tas(M,obj.ISA),obj.ISA)*units.ms2kts;
        % Correct if over crossover altitude
        if didCatch
            obj.OnFly.Phase.speedMode = 'M';
        end
    end
elseif strcmp(phase, 'Cruise')
    %% Cruise
    if obj.ISA.ALTITUDE_P < 3000*units.ft2m
        KCAS = min(VCAS1,170);
    elseif obj.ISA.ALTITUDE_P < 6000*units.ft2m
        KCAS = min(VCAS1,220);
    elseif obj.ISA.ALTITUDE_P < 14000*units.ft2m
        KCAS = min(VCAS1,250);
    elseif obj.ISA.ALTITUDE_P < H_Mtrs || (obj.ISA.ALTITUDE_P >= H_Mtrs && ~didCatch)
        KCAS = VCAS2;
    else
        % Correct if over crossover altitude
        if didCatch
            obj.OnFly.Phase.speedMode = 'M';
        end
        KCAS = source.functions.tas2cas(...
            source.functions.mach2tas(M,obj.ISA),obj.ISA)*units.ms2kts;
    end
    
elseif strcmp(phase, 'Descent')
    vsld = landingstallspeed(obj);
    %% Descent
    if obj.ISA.ALTITUDE_P < 1000*units.ft2m
        KCAS = Cvmin * vsld + 5;
    elseif obj.ISA.ALTITUDE_P < 1500*units.ft2m
        KCAS = Cvmin * vsld + 10;
    elseif obj.ISA.ALTITUDE_P < 2000*units.ft2m
        KCAS = Cvmin * vsld + 20;
    elseif obj.ISA.ALTITUDE_P < 3000*units.ft2m
        KCAS = Cvmin * vsld + 50;
    elseif obj.ISA.ALTITUDE_P < 6000*units.ft2m
        KCAS = min(VCAS1,220);
    elseif obj.ISA.ALTITUDE_P < 10000*units.ft2m
        KCAS = min(VCAS1,250);
    elseif obj.ISA.ALTITUDE_P < H_Mtrs || (obj.ISA.ALTITUDE_P >= H_Mtrs && ~didCatch)
        KCAS = VCAS2;
    else
        % Correct if over crossover altitude
        if didCatch
            obj.OnFly.Phase.speedMode = 'M';
        end
        KCAS = source.functions.tas2cas(...
            source.functions.mach2tas(M,obj.ISA),obj.ISA)*units.ms2kts;
    end
end

VCAS = KCAS*units.kts2ms;
end

