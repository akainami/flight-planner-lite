function fuelEval(obj)
% fuelEval Fuel Evaluations Master Function
%
% Synopsis: fuelEval(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also: calculate, turbofanF, turbopropF, pistonF.
%

if strcmpi(obj.ACM.type,'JET')
    obj.turbofanF;
elseif strcmpi(obj.ACM.type,'TURBOPROP')
    obj.turbopropF;
elseif strcmpi(obj.ACM.type,'PISTON')
    obj.pistonF;
end
end

