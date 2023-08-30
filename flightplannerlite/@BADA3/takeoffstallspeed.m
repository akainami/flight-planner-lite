function KCASstall = takeoffstallspeed(obj)
% takeoffstallspeed Takeoff Conf. Stall Speed
%
% Synopsis: takeoffstallspeed(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   KCASstall= Stall speed of aircraft in knots (calibrated)
%
% See also: calculate, cleanCLmax.
%

KCASstall =  obj.ACM.AFCM.Configuration(obj.ACM.LBL.toffindex).vstall;

end

