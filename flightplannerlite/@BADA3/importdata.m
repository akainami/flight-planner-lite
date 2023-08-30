function importdata(obj,aircraftname)
% importdata Reading Data from Source
%
% Synopsis: importdata(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   obj      = Updated BADA3 object
%
% See also:
%

obj.id = aircraftname;
obj.importAircraft;

end

