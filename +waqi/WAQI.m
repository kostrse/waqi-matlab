classdef WAQI
    properties (Access = private)
        api waqi.internal.ApiClient
    end

    methods
        function obj = WAQI(token)
            obj.api = waqi.internal.ApiClient("https://api.waqi.info", token);
        end

        function result = station(obj, station)
            arguments
                obj waqi.WAQI
                station (1, 1) waqi.AirQualityStation
            end

            resp = obj.api.get(["feed", sprintf("@%u", station.ID)], {});

            result = waqi.internal.parseStationEntry(resp);
        end

        function result = city(obj, city)
            arguments
                obj waqi.WAQI
                city (1, 1) string
            end

            resp = obj.api.get(["feed", city], {});

            result = waqi.internal.parseStationEntry(resp);
        end

        % TODO: Prove that this is actually nearest, not interpolated
        function result = nearest(obj, point)
            arguments
                obj waqi.WAQI
                point
            end

            if (isnumeric(point)) && width(point) == 2
                % TODO: To normalize shape, use nearestForGeoPoint
                result = obj.nearestForCoordinates(point(:, 1), point(:, 2));
            elseif isa(point, "geopoint")
                result = obj.nearestForGeoPoint(point);
            elseif isa(point, "geopointshape")
                result = obj.nearestForGeoPointShape(point);
            else
                error("Input argument 'point' should be a geopoint, geopointshape or numeric vector of [latitude, longitude].");
            end
        end

        function result = stations(obj, boundingBox)
            arguments
                obj waqi.WAQI
                boundingBox (2, 1) geopoint
            end

            % TODO: Support different types of shapes
            result = obj.getStationsForBoundingBox(boundingBox);
        end

        function result = search(obj, query)
            arguments
                obj waqi.WAQI
                query (1, 1) string
            end

            result = obj.api.get("search", {"keyword", query});
        end
    end

    methods (Access = private)
        function result = nearestForGeoPoint(obj, point)
            arguments
                obj waqi.WAQI
                point (:, 1) geopoint
            end

            % geopoint vector is always vertical
            % Latitude and Longitude of geopoint vector are always horizontal
            result = obj.nearestForCoordinates(point.Latitude', point.Longitude');
        end

        function result = nearestForGeoPointShape(obj, point)
            arguments
                obj waqi.WAQI
                point (:, 1) geopointshape
            end

            % geopointshape vector can be horizontal, vertical and 2-dimentional
            % Latitude and Longitude can be nested horizontal for multipoint
            result = obj.nearestForCoordinates(point.Latitude, point.Longitude);
        end

        function result = nearestForCoordinates(obj, latitude, longitude)
            arguments
                obj waqi.WAQI
                latitude (1, 1) double
                longitude (1, 1) double
            end

            % Consider support for multiple points
            resp = obj.api.get(["feed", sprintf("geo:%.6f;%.6f", latitude, longitude)], {});

            result = waqi.internal.parseStationEntry(resp);
        end

        function result = getStationsForBoundingBox(obj, boundingBox)
            arguments
                obj waqi.WAQI
                boundingBox (2, 1) geopoint
            end

            resp = obj.api.get(["map", "bounds"], {"latlng", sprintf("%.6f,%.6f,%.6f,%.6f", ...
                boundingBox(1).Latitude, boundingBox(1).Longitude, boundingBox(2).Latitude, boundingBox(2).Longitude)});

            result = waqi.internal.parseStationList(resp);
        end
    end
end
