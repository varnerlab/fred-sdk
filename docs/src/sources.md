# Sources

## `fred/sources`

The `fred/sources` endpoint returns every source, with its identifier, its name, and its link.

```julia
model = MyFredSourcesEndpointModel(apikey = apikey, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSourcesEndpointModel, request_url; handler = process_sources_response_dataframe);
```

```@docs
MyFredSourcesEndpointModel
url(::String, ::MyFredSourcesEndpointModel)
```

## `fred/source`

The `fred/source` endpoint returns the name and the link of one source, such as source `1`, the Board of Governors of the Federal Reserve System.

```julia
model = MyFredSourceEndpointModel(apikey = apikey, source_id = 1);
request_url = url(baseurl, model);
table = api(MyFredSourceEndpointModel, request_url; handler = process_sources_response_dataframe);
```

```@docs
MyFredSourceEndpointModel
url(::String, ::MyFredSourceEndpointModel)
```

## `fred/source/releases`

The `fred/source/releases` endpoint returns the releases that one source publishes, such as the first `3` releases of source `1`.

```julia
model = MyFredSourceReleasesEndpointModel(apikey = apikey, source_id = 1, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredSourceReleasesEndpointModel, request_url; handler = process_releases_response_dataframe);
```

```@docs
MyFredSourceReleasesEndpointModel
url(::String, ::MyFredSourceReleasesEndpointModel)
```
