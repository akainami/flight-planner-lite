function f = energyShareFactor(obj)
% energyShareFactor Energy Share Factor Evaluations for ROCD
%
% Synopsis: energyShareFactor(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   f        = Energy Share Factor, ESF
%
% See also: calculate, fuelEval.
%

if ~obj.OnFly.Phase.speedModeInput
        if obj.ISA.ALTITUDE_P > obj.ISA.ALTITUDE_TROP
            if strcmp(obj.OnFly.Phase.speedMode,'CAS') % Constant CAS
                K = obj.ISA.AIR_INDEX;
                M = obj.OnFly.Velocity.M;
                f = (1+(1+(K-1)/2*M^2)^(1/(1-K))*((1+(K-1)/2*M^2)^(K/(K-1))-1))^-1;
            elseif strcmp(obj.OnFly.Phase.speedMode,'M') % Constant M
                f = 1;
            elseif strcmp(obj.OnFly.Phase.speedMode,'TAS') % Constant TAS
                f = 1; % Assume
            end
        else
            if strcmp(obj.OnFly.Phase.speedMode,'CAS') % Constant CAS
                f = (1+...
                    obj.ISA.AIR_INDEX*obj.ISA.GAS_CONSTANT*obj.ISA.TEMP_GRAD_BELOWTROP*...
                    obj.OnFly.Velocity.M^2/2/obj.ISA.GRAVITY_0*(obj.ISA.TEMPERATURE-obj.ISA.DELTA_T)...
                    /obj.ISA.TEMPERATURE+...
                    (1+(obj.ISA.AIR_INDEX-1)/2*obj.OnFly.Velocity.M^2)^(1/(1-obj.ISA.AIR_INDEX))*...
                    ((1+(obj.ISA.AIR_INDEX-1)/2*obj.OnFly.Velocity.M^2)^...
                    (obj.ISA.AIR_INDEX/(obj.ISA.AIR_INDEX-1))-1))^-1;
                
            elseif strcmp(obj.OnFly.Phase.speedMode,'M') ...
                    || strcmp(obj.OnFly.Phase.speedMode,'TAS') % Constant M-TAS
                f = (1+obj.ISA.AIR_INDEX*obj.ISA.GAS_CONSTANT*...
                    obj.ISA.TEMP_GRAD_BELOWTROP*obj.OnFly.Velocity.M^2/2/...
                    obj.ISA.GRAVITY_0*(obj.ISA.TEMPERATURE-obj.ISA.DELTA_T)/...
                    obj.ISA.TEMPERATURE)^-1;
            end
        end
else
    if strcmp(obj.OnFly.Phase.PhaseName,'Climb')
        if obj.OnFly.Result.DragForce > obj.OnFly.Result.ThrustForce
            f = 1.7;
        else
            f = 0.3;
        end
    elseif strcmp(obj.OnFly.Phase.PhaseName,'Cruise') || ...
            strcmp(obj.OnFly.Phase.PhaseName,'Landing') || ...
            strcmp(obj.OnFly.Phase.PhaseName,'Takeoff')
        f = 0;
    elseif strcmp(obj.OnFly.Phase.PhaseName,'Descent')
        if obj.OnFly.Result.DragForce > obj.OnFly.Result.ThrustForce
            f = 0.3;
        else
            f = 1.7;
        end
    end
end
end