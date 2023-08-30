function dragEval(obj)
% dragEval Drag Evaluations Master Function
%
% Synopsis: dragEval(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate, cleanCD, noncleanCD.
%
cd0 = obj.ACM.AFCM.Configuration(obj.OnFly.Phase.configIndex).cd0;
cd2 = obj.ACM.AFCM.Configuration(obj.OnFly.Phase.configIndex).cd2;
cdlg = obj.ACM.AFCM.dLGDN;

% Correct for speedbrakes
if strcmpi(obj.OnFly.Phase.PhaseID,'cr')
    obj.OnFly.Coeff.DragCoeff = cd0 + cd2*obj.OnFly.Coeff.LiftCoeff^2;
else
    obj.OnFly.Coeff.DragCoeff = cd0 + cd2*obj.OnFly.Coeff.LiftCoeff^2+cdlg;
end

% Drag Force
obj.OnFly.Result.DragForce = 1/2*obj.ISA.PRESS_RATIO*obj.ISA.PRESSURE_0*...
    obj.ISA.AIR_INDEX*obj.OnFly.Velocity.M^2*obj.ACM.AFCM.S*...
    obj.OnFly.Coeff.DragCoeff;
end
