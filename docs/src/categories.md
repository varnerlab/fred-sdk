# Categories

## `fred/category`

The `fred/category` endpoint returns the name and the parent category of one category, such as category `125`, Trade Balance.

```julia
model = MyFredCategoryEndpointModel(apikey = apikey, category_id = 125);
request_url = url(baseurl, model);
table = api(MyFredCategoryEndpointModel, request_url; handler = process_categories_response_dataframe);
```

```@docs
MyFredCategoryEndpointModel
url(::String, ::MyFredCategoryEndpointModel)
```

## `fred/category/children`

The `fred/category/children` endpoint returns the child categories of one category, such as category `13`, the parent category of Trade Balance.

```julia
model = MyFredCategoryChildrenEndpointModel(apikey = apikey, category_id = 13);
request_url = url(baseurl, model);
table = api(MyFredCategoryChildrenEndpointModel, request_url; handler = process_categories_response_dataframe);
```

```@docs
MyFredCategoryChildrenEndpointModel
url(::String, ::MyFredCategoryChildrenEndpointModel)
```

## `fred/category/related`

The `fred/category/related` endpoint returns the categories that FRED links to one category outside the tree of categories, such as category `32073`.

```julia
model = MyFredCategoryRelatedEndpointModel(apikey = apikey, category_id = 32073);
request_url = url(baseurl, model);
table = api(MyFredCategoryRelatedEndpointModel, request_url; handler = process_categories_response_dataframe);
```

```@docs
MyFredCategoryRelatedEndpointModel
url(::String, ::MyFredCategoryRelatedEndpointModel)
```

## `fred/category/series`

The `fred/category/series` endpoint returns the series in one category, such as the first `3` series in category `125`.

```julia
model = MyFredCategorySeriesEndpointModel(apikey = apikey, category_id = 125, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredCategorySeriesEndpointModel, request_url; handler = process_series_response_dataframe);
```

```@docs
MyFredCategorySeriesEndpointModel
url(::String, ::MyFredCategorySeriesEndpointModel)
```

## `fred/category/tags`

The `fred/category/tags` endpoint returns the tags of the series in one category, such as the first `3` tags of the series in category `125`.

```julia
model = MyFredCategoryTagsEndpointModel(apikey = apikey, category_id = 125, limit = 3);
request_url = url(baseurl, model);
table = api(MyFredCategoryTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredCategoryTagsEndpointModel
url(::String, ::MyFredCategoryTagsEndpointModel)
```

## `fred/category/related_tags`

The `fred/category/related_tags` endpoint selects the series in one category that carry every tag in `tag_names`, and returns the other tags of those series.

```julia
model = MyFredCategoryRelatedTagsEndpointModel(apikey = apikey, category_id = 125, tag_names = "services;quarterly", limit = 3);
request_url = url(baseurl, model);
table = api(MyFredCategoryRelatedTagsEndpointModel, request_url; handler = process_tags_response_dataframe);
```

```@docs
MyFredCategoryRelatedTagsEndpointModel
url(::String, ::MyFredCategoryRelatedTagsEndpointModel)
```
