classdef AirQualityStation
    properties (SetAccess = private)
        ID uint32
        Name string
        Location geopoint
        Url string
    end

    methods
        function obj = AirQualityStation(id, name, location, url)
            arguments
                id uint32
                name string
                location geopoint
                url string = ""
            end
            obj.ID = id;
            obj.Name = name;
            obj.Location = location;
            obj.Url = url;
        end
    end
end
