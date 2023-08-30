% Istanbul Technical University Aeronautical Engineering
% Atakan Ozturk, 2022-2023
% Mission Body
%
% See also: Planet, Mission, Atmosphere, BADA3

clc; clear;

Earth = Planet; % '88MGG' or 'GLOBE' or 'ETOPO'

B738_bada3  = BADA3('B738');

% IST to ESB
IST2DOH_bada3 = Mission(Earth,B738_bada3,'IATA','IST','DOH');
IST2DOH_bada3.fly(Earth,B738_bada3);
IST2DOH_bada3.plotResults;
