function Dir = getAircDir(Init,Fin)
% getAircDir Aircraft Direction (Heading) 
%
% Synopsis: Dir = getAircDir(Init,Fin)
%
% Input:    Init = (Required) Initial Coordinates Long,Lat Vector in Degrees
%           Fin  = (Required) Final Coordinates Long,Lat Vector in Degrees
%
% Output:   Dir = Heading Angle in Degrees
%
% See also: .
%
Dir = atan2d(cosd(Init.Latitude)*sind(Fin.Latitude)-sind(Init.Latitude)*cosd(Fin.Latitude)*...
    cosd(Fin.Latitude-Init.Latitude),sind(Fin.Longitude-Init.Longitude)*cosd(Fin.Latitude));

end

