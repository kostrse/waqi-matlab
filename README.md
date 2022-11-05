
# WAQI client for MATLAB

WAQI (World Air Quality Index) provides open API for reading air quality data from the stations registered on the project.

## Get your API token

Request the WAQI API access token at https://aqicn.org/api/.

## Usage samples

```MATLAB
token = "<your token>";

aqi = waqi.WAQI(token);

% Get data for given known city
bangkok = aqi.city("bangkok");

% Get data from the nearest station for given coordinates
seattle = aqi.nearest([47.62050, -122.34930]);

% Get list of stations for given boundary
jakarta_area = [
    geopoint(-5.88855, 106.55352)
    geopoint(-6.57708, 107.30635)
];

jakarta_stations = aqi.stations(jakarta_area);
```
