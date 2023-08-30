function H_OPT = findOptimalAltitude(Earth,Aircraft)
% findOptimalAltitude Optimal Cruise Altitude Initiation
%
% Synopsis: findOptimalAltitude(Earth,Aircraft)
%
% Input:    Earth = (required) Planet Object
%           Aircraft = (required) Aircraft Object
%
% Output:   
%
% See also: calculate.
%

altiArr = linspace(0,Aircraft.ACM.ALM.GLM.hmo*units.ft2m,100);
resultArr = zeros(1,length(altiArr));

for iAlt = 1 : length(altiArr)
    Earth.ISA.evaluate(altiArr(iAlt), 0, 0);
    Aircraft.calculate('Atmosphere',Earth.ISA,'Phase','Cruise','ThrustMode','');
    
    gs(iAlt) = Aircraft.OnFly.Velocity.GROUND_SPEED;
    fc(iAlt) = Aircraft.OnFly.Result.FuelConsumption;
    t(iAlt) = Aircraft.OnFly.Result.ThrustForce;
    
    resultArr(iAlt) = Aircraft.OnFly.Velocity.GROUND_SPEED / Aircraft.OnFly.Result.FuelConsumption;
end
[~,ix] = max(resultArr);
H_OPT = altiArr(ix);
end

