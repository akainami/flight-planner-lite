function KCASstall = landingstallspeed(obj)
% landingstallspeed Landing Conf. Stall Speed
%
% Synopsis: landingstallspeed(obj)
%
% Input:    obj      = (required) BADA3 object
%
% Output:   KCASstall= Stall speed of aircraft in knots (calibrated)
%
% See also: calculate, cleanCLmax.
%

% check takeoffstallspeed

KCASstall =  obj.ACM.AFCM.Configuration(obj.ACM.LBL.ldindex).vstall;

end

