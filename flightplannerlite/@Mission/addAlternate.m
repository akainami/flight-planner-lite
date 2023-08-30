function addAlternate(Route,objEarth,valtype,value)
% addDivert Diverting Base Assignment
%
% Synopsis: addDivert(obj,objEarth,valtype,value)
%
% Input:    Route      = (required) Mission object
%           objEarth = (required) Planet object
%           valtype = (required) variable type for value variable
%           value = (required) value
%
% Output:  
%
% See also: Base/defineBase.
%

altBase = Base;
altBase.defineBase(objEarth,valtype,value);
nB = length(Route.Alternate.Base);
Route.Alternate.Base{nB+1} = altBase;
end

