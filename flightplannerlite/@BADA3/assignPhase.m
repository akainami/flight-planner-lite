function assignPhase(obj, phase)
% assignPhase Phase and Configurations Assignments
%
% Synopsis: assignPhase(obj, phase)
%
% Input:    obj      = (required) BADA3 object
%           phase    = (required) phase string
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

hmaxTO = 400 * units.ft2m;
hmaxIC = 2000 * units.ft2m;
hmaxAP = 8000 * units.ft2m;
hmaxLD = 3000 * units.ft2m;

if ischar(phase)
    phaseN = 0;
else
    phaseN = phase;
end

% Check if Input V exists
catchV = true;
KCAScheck = -1;
try
    KCAScheck = source.functions.tas2cas(inputs('VTAS'),obj.ISA)...
        *units.ms2kts;
    % try VTAS
catch
    try
        KCAScheck = source.functions.tas2cas(source.functions.mach2tas(inputs('M'),...
            obj.ISA),obj.ISA)*units.ms2kts;
        % try M
    catch
        try
            KCAScheck = inputs('VCAS')*units.ms2kts;
            % try VCAS
        catch
            catchV = false;
        end
    end
end

if strcmp(phase,'Takeoff') || phaseN == 1
    obj.OnFly.Phase.PhaseName = 'Takeoff';
    obj.OnFly.Phase.PhaseID = 'TO';
elseif strcmp(phase,'Climb') || phaseN == 2
    obj.OnFly.Phase.PhaseName = 'Climb';
    if obj.ISA.ALTITUDE_P < hmaxTO
        obj.OnFly.Phase.PhaseID = 'TO';
    elseif obj.ISA.ALTITUDE_P < hmaxIC
        obj.OnFly.Phase.PhaseID = 'IC';
    else
        obj.OnFly.Phase.PhaseID = 'CR';
    end
    
elseif strcmp(phase,'Cruise') || phaseN == 3
    obj.OnFly.Phase.PhaseName = 'Cruise';
    obj.OnFly.Phase.PhaseID = 'CR';
    
elseif strcmp(phase,'Descent') || phaseN == 4
    obj.OnFly.Phase.PhaseName = 'Descent';
    vmincr = 0;
    vminap = 0;
    if catchV
        clmaxclean = cleanCLmax(obj);
        vs = sqrt(obj.OnFly.Load.Weight*2/(obj.ISA.DENSITY*obj.ACM.AFCM.S*...
            clmaxclean))*units.ms2kts; % used as kts
        vmincr = 1.23*vs+10; % cruise configuration speed limit
        vminap = 1.23*landingstallspeed+10; % approach configuration upper speed limit
    end
    if obj.ISA.ALTITUDE_P < hmaxLD && vminap > KCAScheck
        obj.OnFly.Phase.PhaseID = 'LD';
    elseif (obj.ISA.ALTITUDE_P < hmaxAP && vmincr > KCAScheck) ||...
            (obj.ISA.ALTITUDE_P < hmaxLD && vminap < KCAScheck && vmincr > KCAScheck)
        obj.OnFly.Phase.PhaseID = 'AP';
    elseif (obj.ISA.ALTITUDE_P < hmaxAP && vmincr < KCAScheck) || ...
            (obj.ISA.ALTITUDE_P > hmaxAP)
        obj.OnFly.Phase.PhaseID = 'CR';
    end
    
elseif strcmp(phase,'Landing') || phaseN == 5
    obj.OnFly.Phase.PhaseName = 'Landing';
    obj.OnFly.Phase.PhaseID = 'LD';
end
end