function assignSpeed(obj, inputs)
% assignSpeed Speed Assignments Master Function
%
% Synopsis: assignSpeed(obj, inputs)
%
% Input:    obj      = (required) BADA3 object
%           inputs   = (required) inputs map
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate, stallspeed, assignARPM_Jet, assignARPM_PistonProp,
% source.functions.cas2tas,source.functions.tas2cas, source.functions.tas2mach,
% source.functions.mach2tas, units.ms2kts.
%

try % VCAS exists
    VCAS = inputs('VCAS'); % m/s
    VTAS = source.functions.cas2tas(VCAS, obj.ISA); % m/s
    M = source.functions.tas2mach(VTAS, obj.ISA);
    obj.OnFly.Phase.speedMode = 'CAS';
    obj.OnFly.Phase.speedModeInput = true;
catch
    try % VTAS exists
        VTAS = inputs('VTAS'); % m/s
        VCAS = source.functions.tas2cas(VTAS,obj.ISA); % m/s
        M = source.functions.tas2mach(VTAS,obj.ISA);
        obj.OnFly.Phase.speedMode = 'TAS';
        obj.OnFly.Phase.speedModeInput = true;
    catch
        try % M exists
            M = inputs('M');
            VTAS = source.functions.mach2tas(M,obj.ISA);
            VCAS = source.functions.tas2cas(VTAS,obj.ISA);
            obj.OnFly.Phase.speedMode = 'M';
            obj.OnFly.Phase.speedModeInput = true;
        catch % Use ARPM
            obj.OnFly.Phase.speedModeInput = false;
            sct = obj.ACM.ARPM.SpeedScheduleList.SpeedSchedule.SpeedPhase(:);
            VCAS = -1;
            for i = 1 : length(sct)
                if strcmp(obj.OnFly.Phase.PhaseName, sct(i).name)
                    VCAS1 = sct(i).CAS1; % kts
                    VCAS2 = sct(i).CAS2; % kts
                    Mn = sct(i).M;
                    if strcmpi(obj.ACM.type,'jet')
                        VCAS = obj.assignARPM_Jet(VCAS1,VCAS2,Mn,inputs); % m/s
                    elseif strcmpi(obj.ACM.type,'piston') || strcmp(obj.ACM.type,'turboprop')
                        VCAS = obj.assignARPM_PistonProp(VCAS1,VCAS2,Mn,inputs); % m/s
                    end
                elseif strcmpi(obj.OnFly.Phase.PhaseName,'landing')
                    VCAS = obj.landingstallspeed * 1.23 * units.kts2ms;
                    obj.OnFly.Phase.speedMode = 'CAS';
                elseif strcmpi(obj.OnFly.Phase.PhaseName,'takeoff')
                    VCAS = obj.takeoffstallspeed * 1.13 * units.kts2ms;
                    obj.OnFly.Phase.speedMode = 'CAS';
                end
                    VTAS = source.functions.cas2tas(VCAS,obj.ISA); % m/s
                    M = source.functions.tas2mach(VTAS,obj.ISA);
            end
            if VCAS == -1
                error('Airline Procedure Model does not supply CAS for this maneuver.');
            end
        end
    end
end
obj.OnFly.Velocity.KCASstall = stallspeed(obj);
obj.OnFly.Velocity.M    = M;
obj.OnFly.Velocity.VTAS = VTAS; % m/s
obj.OnFly.Velocity.VCAS = VCAS; % m/s
obj.OnFly.Velocity.KTAS = VTAS*units.ms2kts;
obj.OnFly.Velocity.KCAS = VCAS*units.ms2kts;
end

