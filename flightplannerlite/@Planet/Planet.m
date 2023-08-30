classdef Planet < handle
    properties
        Geometry
        name = 'Earth'
        ISA
        Location
        Ellipsoid
    end
    methods
        function obj = Planet(dataSelection)
            % - Initialize Planet Object
            %
            % Synopsis: 
            %
            % Input:    obj      = (required) Planet object
            %
            % Output:
            %
            % See also: Planet/defineGeometry, Planet/importLocation.
            %
            
            if nargin < 1
                dataSelection = '88MGG';
            end
            
            t = tic;
            obj.ISA = Atmosphere;
            obj.Geometry = struct;
            obj.Location = struct;
            obj.Ellipsoid = wgs84Ellipsoid('km');
            obj.defineGeometry(dataSelection);
            obj.importLocation;
            fprintf('Earth initialized in %.2f s\n',toc(t));
        end
        % Planet.defineGeometry
        % Planet.importLocation
        % Planet.plotCountryAirports('TR') % or 'South Korea'
        % Planet.init
    end
end