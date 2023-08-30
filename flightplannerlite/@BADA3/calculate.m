function calculate(obj, varargin)
% calculate Aircraft OnFly Data Calculations
%
% Synopsis: calculate(obj,varargin)
%
% Input:    obj      = (required) BADA3 object
%           varargin = (required) Fields and Values/Strings
%
% Output:   obj      = Updated BADA3 object
%
% See also: assignConfig, assignMass, assignPhase, assignSpeed, dragEval, liftEval,
% thrustEval, fuelEval, evalROCD
%


% Inputs Map:
%     -Mass [kg] -> 0
%     -VCAS [m/s], VTAS [m/s], M [] -> 'VCAS','VTAS','M'
%     -bankAngle [rad] -> 0
% 
%     -ThrottleParameter [] -> 0
%     -ConfigurationIndex [] -> 0
%     -LandingGear [] -> 0
%     -SpeedBrakes [] -> 0
% 
%     -Phase <string>
%     -thrustMode <string>
%     -ISA <Atmosphere>

% t = tic;
inputs = containers.Map();

for i = 1 : 2 : length(varargin)
    inputs(varargin{i}) = varargin{i+1};
end
%% Assign
% Mandatory Assignments
obj.ISA = inputs('Atmosphere');

% Inputs Assignments
obj.assignPhase(inputs('Phase'));

% Evaluate Weights
obj.massEval;

% Assign Configurations
obj.assignConfig(inputs);

% Speed Assignments (VCAS-VTAS-M)
obj.assignSpeed(inputs);

% Wind Correction
obj.windCorrection(inputs);

% Limits of Aircraft
obj.limitations;

%% Calculate
% Lift Calculation
obj.liftEval;

% Drag Calculation
obj.dragEval;

% Engine Thrust Calculation
obj.thrustEval;

% Fuel Consumption Calculation
obj.fuelEval;

% Rate of Climb/Descent Calculation
obj.evalROCD;

% fprintf('.Aircraft calculated in %.2f s\n',toc(t));
end

