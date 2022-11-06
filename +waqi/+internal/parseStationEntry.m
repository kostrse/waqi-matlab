function result = parseStationEntry(resp)
    location = geopoint(resp.city.geo(1), resp.city.geo(2));

    result = struct();
    result.Latitude = location.Latitude';
    result.Longitude = location.Longitude';
    result.Location = location;
    result.Station = waqi.AirQualityStation(resp.idx, resp.city.name, location, resp.city.url);

    result.AQI = resp.aqi;
    result.Timestamp = datetime(resp.time.iso, InputFormat="yyyy-MM-dd'T'HH:mm:ssXXX", TimeZone="local");

    result.Measurements = parseMeasurements(resp);
    result.Forecast = parseForecast(resp);
end

function result = parseMeasurements(resp)
    result = structfun(@(x) x.v, resp.iaqi, UniformOutput=false);
end

function result = parseForecast(resp)
    result = structfun(@parseForecastTable, resp.forecast.daily, UniformOutput=false);
end

function result = parseForecastTable(resp)
    t = struct2table(resp);
    result = timetable(datetime(t.day), t.avg, t.max, t.min, VariableNames=["Avg", "Max", "Min"]);
end
