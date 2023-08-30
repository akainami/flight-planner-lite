function findConfig(obj)
% findConfig Find Configurations for Takeoff and Landing
%
% Synopsis: findConfig(obj)
%
% Input:    obj = Atmosphere object
% 
% Output: 
%
% See also: .
%

labelstr = struct;

% TOFF label
tofflabel = 'TO';
for i = 1 : length(obj.ACM.AFCM.Configuration)
    if strcmp(obj.ACM.AFCM.Configuration(i).phase,tofflabel)
        labelstr.tofflabel = tofflabel;
        labelstr.toffindex = i;
        labelstr.toffhlpos = obj.ACM.AFCM.Configuration(i).HLPosition;
        break
    end
end

% LD label
ldlabel = 'LD';
for i = 1 : length(obj.ACM.AFCM.Configuration)
    if strcmp(obj.ACM.AFCM.Configuration(i).phase,ldlabel)
        labelstr.ldlabel = ldlabel;
        labelstr.ldindex = i;
        labelstr.ldhlpos = obj.ACM.AFCM.Configuration(i).HLPosition;
        break
    end
end
obj.ACM.LBL = labelstr;
end

