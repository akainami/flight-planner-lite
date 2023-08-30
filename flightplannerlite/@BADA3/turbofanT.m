function turbofanT(obj)
% turbofanT Thrust for Turbofan Engine
%
% Synopsis: turbofanT(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate.
%

% obj.OnFly.Coeff.ThrustCoeff
% obj.OnFly.Result.ThrustForce

Hp = obj.ISA.ALTITUDE_P*units.m2ft;

% Reference Climb Thrust
Tisa = obj.ACM.PFM.CT(1)*(1-Hp/obj.ACM.PFM.CT(2)+obj.ACM.PFM.CT(3)*Hp^2);
dTeff = obj.ISA.DELTA_T - obj.ACM.PFM.CT(4);
crit = obj.ACM.PFM.CT(5)*dTeff;
if obj.ACM.PFM.CT(5) <= 0 || crit >= 0.4
    error('Out of engine envelope.')
end
Tclimb = Tisa*(1-crit);

switch obj.OnFly.Phase.thrustMode
    case 'MCMB'
        obj.OnFly.Result.ThrustForce = Tclimb;
        obj.OnFly.Coeff.ThrustCoeff = obj.OnFly.Result.ThrustForce/(obj.ISA.PRESS_RATIO*obj.ACM.PFM.MREF*...
            obj.ISA.GRAVITY_0);
        
    case 'MCRZ'
        obj.OnFly.Coeff.ThrustCoeff = obj.ACM.PFM.CTCR;
        obj.OnFly.Result.ThrustForce = obj.OnFly.Coeff.ThrustCoeff * Tclimb;
        
    case 'idle'
        if obj.ISA.ALTITUDE_P > obj.ACM.PFM.LIDL.DescLevel*units.ft2m
            obj.OnFly.Coeff.ThrustCoeff = obj.ACM.PFM.LIDL.DescHigh;
        else
            switch obj.OnFly.Phase.PhaseID
                case 'CR'
                    obj.OnFly.Coeff.ThrustCoeff = obj.ACM.PFM.LIDL.DescLow;
                case 'AP'
                    obj.OnFly.Coeff.ThrustCoeff = obj.ACM.PFM.LIDL.DescApp;
                case 'LD'
                    obj.OnFly.Coeff.ThrustCoeff = obj.ACM.PFM.LIDL.DescLd;
                otherwise
                    obj.OnFly.Coeff.ThrustCoeff = obj.ACM.PFM.LIDL.DescLd;
            end
        end
        obj.OnFly.Result.ThrustForce = obj.OnFly.Coeff.ThrustCoeff * Tclimb;
    otherwise
        error('Define Thrust Mode!');
end
end
