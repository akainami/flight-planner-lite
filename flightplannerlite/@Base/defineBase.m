function defineBase(obj,objEarth,valtype,value)
% defineBase Define Base 
%
% Synopsis: defineBase(obj,objEarth,valtype,value)
%
% Input:    obj      = (required) Base object
%           objEarth = (required) Earth object
%           valtype = (required) variable type for value variable
%           value = (required) value
%
% Output:   obj      = Updated Base object
%
% See also: Mission/addEmergency, Mission/assignArrival, Mission/assignDeparture
%

if prod(value == 0) || strcmp(value,'') || isempty(value)
    error('Holder value is empty or zero, check it.');
end
% Handle field
if strcmp(valtype,'id')
    holder = 'id';
elseif strcmp(valtype,'identity')
    holder = 'identity';
elseif strcmp(valtype,'name')
    holder = 'name';
elseif strcmp(valtype,'IATA')
    holder = 'iata_code';
elseif strcmp(valtype,'GPS')
    holder = 'gps_code';
end

% Find index at table
sizeArray = {'small','medium','large'};
rowBase = [];
i = 1;
while isempty(rowBase)
    rowBase = objEarth.Location.Airports.(sizeArray{i})...
        (strcmp(objEarth.Location.Airports.(sizeArray{i}).(holder),value),:);
    i = i + 1;
end
if height(rowBase) > 1    
    fprintf('%d bases found with " %s ".\n',height(rowBase),value);
    error('Base is not well defined. Check defining value.');
end

obj.id = rowBase.id;
obj.Name = string(rowBase.name);
obj.Identity = string(rowBase.ident);
obj.Type = string(rowBase.type);
obj.Latitude = rowBase.latitude_deg;
obj.Longitude = rowBase.longitude_deg;
obj.Elevation = rowBase.elevation_ft;
obj.Continent = string(rowBase.continent);
obj.Municipality = string(rowBase.municipality);
obj.IATA = string(rowBase.iata_code);
obj.GPS = string(rowBase.gps_code);
end

