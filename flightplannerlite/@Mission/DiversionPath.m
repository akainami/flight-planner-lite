function DiversionPath(Route,Aircraft,Earth)
% DiversionPath 
%
% Synopsis: DiversionPath(Route,Earth)
%
% Input:    Route      = (required) Mission object
%           Earth      = (required) Planet object
%           Aircraft   = (required) Aircraft object
%
% Output:  
%
% See also: Mission/init.
%

% Find Base to Divert within 30 min flight distance at 1.5k FT (X = Velocity*Time)
Aircraft.assignMass(0,0);
Earth.ISA.evaluate(1500*units.ft2m, 0, 0); % (hp, dT, dP)
Aircraft.calculate('Atmosphere',Earth.ISA,'Phase','Cruise','ThrustMode','');

radiusBase = 30*60*Aircraft.OnFly.Velocity.VTAS; % m 

airports = [Earth.Location.Airports.large; Earth.Location.Airports.medium];
airportslat = airports.latitude_deg;
airportslong = airports.longitude_deg;
% Eliminate Outside-Range Airports
iAirports = sqrt(abs((airportslat-Route.Arrival.Latitude).^2+(airportslong-Route.Arrival.Longitude).^2)) < 180/pi*radiusBase/earthRadius;
airports = table2struct(airports);
airports = airports(iAirports);
airportslat = [airports.latitude_deg];
airportslong = [airports.longitude_deg];

% Search the furthest base
distances = distance(airportslat,airportslong,Route.Arrival.Latitude,Route.Arrival.Longitude);
[~,index] = max(distances);

divBase = Base;
divBase.defineBase(Earth,'GPS',airports(index).gps_code);

Route.Diversion.Base = divBase;
Route.Diversion.Distance = deg2km(max(distances))*1e3;

end