# Releases

## `fred/releases`

The `fred/releases` endpoint returns every release, with its identifier and its name.

```julia
model = MyFredReleasesEndpointModel(apikey = apikey, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredReleasesEndpointModel, request_url; handler = process_releases_response_dataframe);
```

```@docs
MyFredReleasesEndpointModel
url(::String, ::MyFredReleasesEndpointModel)
```

## `fred/releases/dates`

The `fred/releases/dates` endpoint returns the release dates of every release, i.e., the dates on which each release published data.

```julia
model = MyFredReleasesDatesEndpointModel(apikey = apikey, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredReleasesDatesEndpointModel, request_url; handler = process_release_dates_response_dataframe);
```

```@docs
MyFredReleasesDatesEndpointModel
url(::String, ::MyFredReleasesDatesEndpointModel)
```

## `fred/release`

The `fred/release` endpoint returns the name of one release, such as release `53`, Gross Domestic Product.

```julia
model = MyFredReleaseEndpointModel(apikey = apikey, release_id = 53);
request_url = url(baseurl, model);
table = api(MyFredReleaseEndpointModel, request_url; handler = process_releases_response_dataframe);
```

```@docs
MyFredReleaseEndpointModel
url(::String, ::MyFredReleaseEndpointModel)
```

## `fred/release/dates`

The `fred/release/dates` endpoint returns the release dates of one release, such as the first `3` release dates of release `82`.

```julia
model = MyFredReleaseDatesEndpointModel(apikey = apikey, release_id = 82, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredReleaseDatesEndpointModel, request_url; handler = process_release_dates_response_dataframe);
```

```@docs
MyFredReleaseDatesEndpointModel
url(::String, ::MyFredReleaseDatesEndpointModel)
```

## `fred/release/series`

The `fred/release/series` endpoint returns the series in one release, such as the first `3` series in release `51`.

```julia
model = MyFredReleaseSeriesEndpointModel(apikey = apikey, release_id = 51, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredReleaseSeriesEndpointModel, request_url; handler = process_series_response_dataframe);
```

```@docs
MyFredReleaseSeriesEndpointModel
url(::String, ::MyFredReleaseSeriesEndpointModel)
```

## `fred/release/sources`

The `fred/release/sources` endpoint returns the sources that publish one release, such as release `51`.

```julia
model = MyFredReleaseSourcesEndpointModel(apikey = apikey, release_id = 51);
request_url = url(baseurl, model);
table = api(MyFredReleaseSourcesEndpointModel, request_url; handler = process_sources_response_dataframe);
```

```@docs
MyFredReleaseSourcesEndpointModel
url(::String, ::MyFredReleaseSourcesEndpointModel)
```

## `fred/release/tags`

The `fred/release/tags` endpoint returns the tags of the series in one release, such as the first `3` tags of the series in release `86`.

```julia
model = MyFredReleaseTagsEndpointModel(apikey = apikey, release_id = 86, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredReleaseTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredReleaseTagsEndpointModel
url(::String, ::MyFredReleaseTagsEndpointModel)
```

## `fred/release/related_tags`

The `fred/release/related_tags` endpoint selects the series in one release that carry every tag in `tag_names`, and returns the other tags of those series.

```julia
model = MyFredReleaseRelatedTagsEndpointModel(apikey = apikey, release_id = 86, tag_names = "sa;foreign", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredReleaseRelatedTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredReleaseRelatedTagsEndpointModel
url(::String, ::MyFredReleaseRelatedTagsEndpointModel)
```

## `fred/release/tables`

The `fred/release/tables` endpoint returns the elements of the tables of one release, i.e., the sections and series of the tables. The example asks for the elements below element `12886`, Personal consumption expenditures, in release `53`.

```julia
model = MyFredReleaseTablesEndpointModel(apikey = apikey, release_id = 53, element_id = 12886);
request_url = url(baseurl, model);
table = api(MyFredReleaseTablesEndpointModel, request_url; handler = process_release_tables_response_dataframe);
```

```@docs
MyFredReleaseTablesEndpointModel
url(::String, ::MyFredReleaseTablesEndpointModel)
```
