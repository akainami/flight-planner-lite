function evalROCD(obj)
% evalROCD Rate of Climb/Descent Evaluations
%
% Synopsis: evalROCD(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate, energyShareFactor.
%

% 
%  Regarding to the approach in 4.1.2.a
%  Th and VTAS is controlled
% 

% obj.OnFly.Result.RateCD
% obj.OnFly.Result.energySF
% obj.OnFly.Result.PathAngle
% obj.OnFly.Velocity.GROUND_SPEED

obj.OnFly.Result.energySF = energyShareFactor(obj);
obj.OnFly.Result.RateCD = (obj.ISA.TEMPERATURE-obj.ISA.DELTA_T)/obj.ISA.TEMPERATURE...
    *(obj.OnFly.Result.ThrustForce-obj.OnFly.Result.DragForce)*...
    obj.OnFly.Velocity.VTAS/obj.OnFly.Load.WeightRef*obj.OnFly.Result.energySF;

if obj.OnFly.Velocity.VTAS > 0
    obj.OnFly.Result.PathAngle = asind(obj.OnFly.Result.RateCD/obj.OnFly.Velocity.VTAS);
else
    obj.OnFly.Result.PathAngle = 0; 
end
obj.OnFly.Velocity.GROUND_SPEED = cosd(obj.OnFly.Result.PathAngle)*...
    obj.OnFly.Velocity.VTAS - obj.OnFly.Velocity.WIND * cosd(obj.OnFly.Directions.WindRel);

end
