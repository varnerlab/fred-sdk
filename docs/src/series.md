# Series

## `fred/series`

The `fred/series` endpoint returns the title, units, frequency, and date range of one series, such as `"GNPCA"`, the real gross national product.

```julia
model = MyFredSeriesEndpointModel(apikey = apikey, series_id = "GNPCA");
request_url = url(baseurl, model);
table = api(MyFredSeriesEndpointModel, request_url; handler = process_series_response_dataframe);
```

```@docs
MyFredSeriesEndpointModel
url(::String, ::MyFredSeriesEndpointModel)
```

## `fred/series/categories`

The `fred/series/categories` endpoint returns the categories that hold one series, such as `"EXJPUS"`, the exchange rate of the Japanese yen to the U.S. dollar.

```julia
model = MyFredSeriesCategoriesEndpointModel(apikey = apikey, series_id = "EXJPUS");
request_url = url(baseurl, model);
table = api(MyFredSeriesCategoriesEndpointModel, request_url; handler = process_categories_response_dataframe);
```

```@docs
MyFredSeriesCategoriesEndpointModel
url(::String, ::MyFredSeriesCategoriesEndpointModel)
```

## `fred/series/observations`

The `fred/series/observations` endpoint returns the observations of one series, such as the daily Henry Hub natural gas spot price, `"DHHNGSP"`, from `2025-01-01` to `2025-01-10`. FRED has no price for the holiday `2025-01-01`, so FRED sends the value `"."` for that date, and the table handler stores `missing`.

```julia
model = MyFredSeriesObservationsEndpointModel(apikey = apikey, series_id = "DHHNGSP",
    observation_start = "2025-01-01", observation_end = "2025-01-10");
request_url = url(baseurl, model);
table = api(MyFredSeriesObservationsEndpointModel, request_url; handler = process_observations_response_dataframe);
```

```@docs
MyFredSeriesObservationsEndpointModel
url(::String, ::MyFredSeriesObservationsEndpointModel)
```

## `fred/series/release`

The `fred/series/release` endpoint returns the release that holds one series, such as `"IRA"`.

```julia
model = MyFredSeriesReleaseEndpointModel(apikey = apikey, series_id = "IRA");
request_url = url(baseurl, model);
table = api(MyFredSeriesReleaseEndpointModel, request_url; handler = process_releases_response_dataframe);
```

```@docs
MyFredSeriesReleaseEndpointModel
url(::String, ::MyFredSeriesReleaseEndpointModel)
```

## `fred/series/search`

The `fred/series/search` endpoint returns the series that match a search text, such as the first `3` series that match `"monetary service index"`.

```julia
model = MyFredSeriesSearchEndpointModel(apikey = apikey, search_text = "monetary service index", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSeriesSearchEndpointModel, request_url; handler = process_search_response_dataframe);
```

```@docs
MyFredSeriesSearchEndpointModel
url(::String, ::MyFredSeriesSearchEndpointModel)
```

## `fred/series/search/tags`

The `fred/series/search/tags` endpoint returns the tags of the series that match a search text.

```julia
model = MyFredSeriesSearchTagsEndpointModel(apikey = apikey, series_search_text = "monetary service index", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSeriesSearchTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredSeriesSearchTagsEndpointModel
url(::String, ::MyFredSeriesSearchTagsEndpointModel)
```

## `fred/series/search/related_tags`

The `fred/series/search/related_tags` endpoint selects the series that match a search text and carry every tag in `tag_names`, and returns the other tags of those series.

```julia
model = MyFredSeriesSearchRelatedTagsEndpointModel(apikey = apikey, series_search_text = "mortgage rate", tag_names = "30-year;frb", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSeriesSearchRelatedTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredSeriesSearchRelatedTagsEndpointModel
url(::String, ::MyFredSeriesSearchRelatedTagsEndpointModel)
```

## `fred/series/tags`

The `fred/series/tags` endpoint returns the tags of one series, such as `"STLFSI"`, the St. Louis Fed Financial Stress Index.

```julia
model = MyFredSeriesTagsEndpointModel(apikey = apikey, series_id = "STLFSI");
request_url = url(baseurl, model);
table = api(MyFredSeriesTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredSeriesTagsEndpointModel
url(::String, ::MyFredSeriesTagsEndpointModel)
```

## `fred/series/updates`

The `fred/series/updates` endpoint returns the series that FRED updated most recently, most recent first.

```julia
model = MyFredSeriesUpdatesEndpointModel(apikey = apikey, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSeriesUpdatesEndpointModel, request_url; handler = process_series_response_dataframe);
```

```@docs
MyFredSeriesUpdatesEndpointModel
url(::String, ::MyFredSeriesUpdatesEndpointModel)
```

## `fred/series/vintagedates`

The `fred/series/vintagedates` endpoint returns the vintage dates of one series, i.e., the dates on which FRED revised the data of the series or added data to it.

```julia
model = MyFredSeriesVintageDatesEndpointModel(apikey = apikey, series_id = "GNPCA", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSeriesVintageDatesEndpointModel, request_url; handler = process_vintage_dates_response_dataframe);
```

```@docs
MyFredSeriesVintageDatesEndpointModel
url(::String, ::MyFredSeriesVintageDatesEndpointModel)
```
