classdef Mission < handle
    properties
        Departure
        WaypointBases
        Arrival
        Alternate
        Diversion
        Distance
        Path
        State
        Errors
    end
    methods
        function obj = Mission(objEarth, objAircraft, airportCode, varargin)
            if length(varargin) < 2
                error('Increase points to define departure and arrival')
            end
            
            obj.assignDeparture(objEarth,airportCode,varargin{1}); % (Type,Value)
            obj.assignArrival(objEarth,airportCode,varargin{end}); % (Type,Value)
            
            obj.WaypointBases = {};
            
            for iW = 1 : length(varargin) - 2
                obj.WaypointBases{iW} = Base;
                obj.WaypointBases{iW}.defineBase(objEarth,airportCode,varargin{iW+1});
            end
            
            obj.Alternate.addDiversion = false;
            obj.init(objAircraft,objEarth); % SR Blocker is inside
        end
        
        % Mission.init;
        % Mission.waypoints;
        % Mission.assignArrival(objEarth,valtype,value);
        % Mission.addEmergency(objEarth,valtype,value);
        % Mission.assignDeparture(objEarth,valtype,value);
        % Mission.fly
        % Mission.doTakeoff(objAircraft)
        % Mission.doClimb(objAircraft)
        % Mission.doCruise(objAircraft)
        % Mission.doDescent(objAircraft)
        % Mission.doLand(objAircraft)
    end
end

