function correctAlt = optimalAltitudeCorrection(Earth, Aircraft, Lat, Long, AircraftDir, n)
% optimalAltitudeCorrection Crusie Altitude Correction
%
% Synopsis: optimalAltitudeCorrection(Earth,Aircraft,Lat,Long,AircraftDir)
%
% Input:  Aircraft = (required) Aircraft object
%         Earth = (required) Planet object
%
% Output:   correctAlt = integer
%
% See also: calculate.
%

baseAlt = Aircraft.ISA.ALTITUDE_P;
serviceCeiling = Aircraft.ACM.ALM.GLM.hmo*0.3048;
searchAltRange = linspace(baseAlt-1000,serviceCeiling-50,n);
resultArr = zeros(n,1);
k = 1;
for iAlt = searchAltRange
    [WindDir,WindMag] = source.functions.WindZMtoMD(Lat,Long,iAlt);
    Earth.ISA.evaluate(iAlt, 0, 0);
    Aircraft.calculate('Atmosphere',Earth.ISA,'Phase','Cruise','ThrustMode','',...
        'WindDirAbs',WindDir,'AircraftDir',AircraftDir,'WindMagnitude',WindMag);
    
    resultArr(k) = Aircraft.OnFly.Velocity.GROUND_SPEED / Aircraft.OnFly.Result.FuelConsumption;
    k = k + 1;
end

% Search local maxima 
gradResultArr = gradient(resultArr);
OptimalAltitude = interp1(gradResultArr,searchAltRange,0,'nearest');

if isnan(OptimalAltitude)
    [~,iMax] = max(resultArr);
    OptimalAltitude = searchAltRange(iMax);
end

correctAlt = OptimalAltitude - baseAlt;
end

