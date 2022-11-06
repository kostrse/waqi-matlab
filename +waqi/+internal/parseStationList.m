function result = parseStationList(resp)
    resp = struct2table(resp);
    resp_stations = struct2table(resp.station);

    location = geopoint(resp.lat, resp.lon);

    result = table();
    result.Latitude = location.Latitude';
    result.Longitude = location.Longitude';
    result.Location = location;
    result.Station = arrayfun(@waqi.AirQualityStation, uint32(resp.uid), resp_stations.name, location);

    result.AQI = str2double(resp.aqi);
    result.Timestamp = datetime(resp_stations.time, InputFormat="yyyy-MM-dd'T'HH:mm:ssXXX", TimeZone="local");
end
