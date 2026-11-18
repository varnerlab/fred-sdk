# Tags

## `fred/tags`

The `fred/tags` endpoint returns every tag, with the number of series that carry the tag.

```julia
model = MyFredTagsEndpointModel(apikey = apikey, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredTagsEndpointModel
url(::String, ::MyFredTagsEndpointModel)
```

## `fred/related_tags`

The `fred/related_tags` endpoint selects the series that carry every tag in `tag_names`, and returns the other tags of those series.

```julia
model = MyFredRelatedTagsEndpointModel(apikey = apikey, tag_names = "monetary aggregates;weekly", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredRelatedTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredRelatedTagsEndpointModel
url(::String, ::MyFredRelatedTagsEndpointModel)
```

## `fred/tags/series`

The `fred/tags/series` endpoint returns the series that carry every tag in `tag_names`, such as the series that carry the tags `"slovenia"` and `"food"`.

```julia
model = MyFredTagsSeriesEndpointModel(apikey = apikey, tag_names = "slovenia;food", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredTagsSeriesEndpointModel, request_url; handler = process_series_response_dataframe);
```

```@docs
MyFredTagsSeriesEndpointModel
url(::String, ::MyFredTagsSeriesEndpointModel)
```
