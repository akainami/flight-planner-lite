function thrustEval(obj)
% thrustEval Thrust Evaluation Master Function
%
% Synopsis: thrustEval(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate, cruiseThrust, turbofanT, turbopropT, pistonT.
%

if strcmp(obj.OnFly.Phase.PhaseName,'Cruise')
    obj.cruiseThrust;
else
    % turboProp() & pistonThrust() on WIP
    if strcmpi(obj.ACM.type,'JET')
        obj.turbofanT;
    elseif strcmpi(obj.ACM.type,'TURBOPROP')
        obj.turbopropT;
    elseif strcmpi(obj.ACM.type,'PISTON')
        obj.pistonT;
    end
end

end