function [winddir,windmag] = WindZMtoMD(lat,lon,alt)
% WindZMtoMD Zonal & Meridional Winds to Direction & Magnitude Vector
% Conversion
%
% Synopsis: WindZMtoMD(lat,lon,alt)
%
% Input:    lat = (required) Latitude
%           lon = (required) Longitude
%           alt = (required) Altitude
%
% Output:
%
% See also: atmoshwm .
%
wind = atmoshwm(lat,lon,alt);

% Northward to Rel Aircraft
% mwind = -wind(1);
mwind = wind(1);
% Eastward to Rel Aircraft
% zwind = -wind(2);
zwind = wind(2);

windmag = (mwind^2+zwind^2)^.5;
winddir = atand(zwind/mwind);
if mwind > 0
    if zwind > 0
        % Quartet-I
        winddir = winddir + 0;
    else
        % Quartet-II
        winddir = winddir + 180;        
    end
else
    if zwind > 0
        % Quartet-IV
        winddir = winddir + 360;        
    else
        % Quartet-III
        winddir = winddir + 180;        
    end
end

if winddir > 180
    winddir = -(360-winddir);
end
end

