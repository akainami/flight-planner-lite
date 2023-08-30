classdef BADA3 < handle
    properties
        % Import
        ACM
        % Definer
        id
        % On-fly
        ISA
        OnFly = struct;
        Limits = struct
    end
    methods
        function obj = BADA3(aircraftName)
            % - Aircraft Initialization
            %
            % Synopsis: init(obj)
            %
            % Input:    obj      = (required) BADA3object
            %
            % Output:   obj      = Updated BADA3 object
            %
            % See also: calculate, importdata, BADA3/findConfig.
            %
            
            tic;
            obj.importdata(aircraftName);
            
            % Find Takeoff and Landing Configuration IDs
            obj.findConfig;
            
            fprintf('Aircraft initialized in %.2f s\n',toc);
        end
        
        % VCAS = BADA3.assignARPM_Jet(obj, VCAS1, VCAS2, M, inputs)
        % VCAS = BADA3.assignARPM_PistonProp(obj, VCAS1, VCAS2, M, inputs)
        % BADA3.assignConfig(inputs)
        % BADA3.assignMass(inputs)
        % BADA3.assignPhase(inputs)
        % BADA3.assignSpeed(inputs)
        % BADA3.calculate
        % BADA3.cleanCD
        % CLmax = BADA3.cleanCLmax
        % BADA3.cruiseThrust
        % BADA3.dragEval
        % BADA3.energyShareFactor
        % BADA3.evalROCD
        % BADA3.findConfig
        % BADA3.fuelEval
        % BADA3.importdata
        % BADA3.init
        % BADA3.landingstallspeed
        % BADA3.liftEval
        % BADA3.limitations
        % BADA3.noncleanCD(lgCR)
        % BADA3.pistonF
        % BADA3.pistonT
        % BADA3.stallspeed
        % BADA3.takeoffstallspeed
        % BADA3.thrustEval
        % BADA3.turbofanT
        % BADA3.turbofanF
        % BADA3.turbopropT
        % BADA3.turbopropT
    end
end

