function assignDeparture(obj,objEarth,valtype,value)
% assignDeparture Departed Base Assignment
%
% Synopsis: assignDeparture(obj,objEarth,valtype,value)
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

obj.Departure = Base;
obj.Departure.defineBase(objEarth,valtype,value);
end

