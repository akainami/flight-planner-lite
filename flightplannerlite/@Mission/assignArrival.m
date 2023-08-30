function assignArrival(obj,objEarth,valtype,value)
% assignArrival Arriving Base Assignment
%
% Synopsis: assignArrival(obj,objEarth,valtype,value)
%
% Input:    obj      = (required) Mission object
%           objEarth = (required) Planet object
%           valtype = (required) variable type for value variable
%           value = (required) value
%
% Output:  
%
% See also: Base/defineBase.
%

obj.Arrival = Base;
obj.Arrival.defineBase(objEarth,valtype,value);
end

