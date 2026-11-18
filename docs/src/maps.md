# Maps

The Maps API returns data by region, such as the value of one quantity in each state. A region type names a kind of region, such as `"state"`. A series group is the set of regional series that measure one quantity across the regions of one region type, such as series group `882`, the per capita personal income of each state. The `geofred/shapes/file` and `geofred/series/group` endpoints have no table handler, so their examples return a dictionary.

## `geofred/shapes/file`

The `geofred/shapes/file` endpoint returns the boundaries of the regions of one region type, such as `"state"`, in the GeoJSON format.

```julia
model = MyFredMapsShapesEndpointModel(apikey = apikey, shape = "state");
request_url = url(baseurl, model);
result = api(MyFredMapsShapesEndpointModel, request_url);
```

```@docs
MyFredMapsShapesEndpointModel
url(::String, ::MyFredMapsShapesEndpointModel)
```

## `geofred/series/group`

The `geofred/series/group` endpoint returns the series group of one regional series, with its title, region type, units, frequency, and first and last dates. The example asks for the series group of `"SMU56000000500000001a"`, the number of employees in total private industries in Wyoming.

```julia
model = MyFredMapsSeriesGroupEndpointModel(apikey = apikey, series_id = "SMU56000000500000001a");
request_url = url(baseurl, model);
result = api(MyFredMapsSeriesGroupEndpointModel, request_url);
```

```@docs
MyFredMapsSeriesGroupEndpointModel
url(::String, ::MyFredMapsSeriesGroupEndpointModel)
```

## `geofred/series/data`

The `geofred/series/data` endpoint returns the value of each series in the series group of one regional series. The example asks for the per capita personal income of each state on `2012-01-01`, from the series group of `"WIPCPI"`, the per capita personal income of Wisconsin.

```julia
model = MyFredMapsSeriesDataEndpointModel(apikey = apikey, series_id = "WIPCPI", date = "2012-01-01");
request_url = url(baseurl, model);
table = api(MyFredMapsSeriesDataEndpointModel, request_url; handler = process_maps_series_data_response_dataframe);
```

```@docs
MyFredMapsSeriesDataEndpointModel
url(::String, ::MyFredMapsSeriesDataEndpointModel)
```

## `geofred/regional/data`

The `geofred/regional/data` endpoint returns the value of one series group in each region of one region type. The example asks for series group `882` on `2013-01-01`, as annual (`"a"`) values in dollars that are not seasonally adjusted (`"NSA"`).

```julia
model = MyFredMapsRegionalDataEndpointModel(apikey = apikey, series_group = "882", region_type = "state",
    date = "2013-01-01", season = "NSA", units = "Dollars", frequency = "a");
request_url = url(baseurl, model);
table = api(MyFredMapsRegionalDataEndpointModel, request_url; handler = process_maps_regional_data_response_dataframe);
```

```@docs
MyFredMapsRegionalDataEndpointModel
url(::String, ::MyFredMapsRegionalDataEndpointModel)
```
