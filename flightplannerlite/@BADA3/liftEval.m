function liftEval(obj)
% liftEval Lift Evaluations
%
% Synopsis: liftEval(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

if strcmp(obj.OnFly.Phase.PhaseID,'TO') ...
        || strcmp(obj.OnFly.Phase.PhaseID,'LD') % On Ground
    Linit = obj.OnFly.Load.Weight;
    CLinit = Linit/...
        (1/2*obj.ISA.PRESS_RATIO*obj.ISA.PRESSURE_0*...
        obj.ISA.AIR_INDEX*(obj.OnFly.Velocity.Mstall*1.13)^2*obj.ACM.AFCM.S);
    
    obj.OnFly.Result.LiftForce = CLinit*1/2*obj.ISA.PRESS_RATIO*obj.ISA.PRESSURE_0*...
        obj.ISA.AIR_INDEX*obj.OnFly.Velocity.M^2*obj.ACM.AFCM.S;
    obj.OnFly.Coeff.LiftCoeff = CLinit;
    
else % On Air
% Lift Force
obj.OnFly.Result.LiftForce = obj.OnFly.Load.Weight/cos(obj.OnFly.Phase.BankAngle);
% Lift Coefficient
obj.OnFly.Coeff.LiftCoeff = obj.OnFly.Result.LiftForce/...
    (1/2*obj.ISA.PRESS_RATIO*obj.ISA.PRESSURE_0*...
    obj.ISA.AIR_INDEX*obj.OnFly.Velocity.M^2*obj.ACM.AFCM.S);
end
end
