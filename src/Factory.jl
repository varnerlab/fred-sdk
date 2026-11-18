# =============================================================================
# Factory.jl: the url(...) methods that build the request URL of each endpoint model.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #

# --- SERIES ENDPOINTS ----------------------------------------------------------------------------------------- #

"""
    url(base::String, model::MyFredSeriesEndpointModel) -> String

Build the URL string for the `fred/series` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the description of one economic data series: its title, units, frequency, seasonal adjustment, and date range.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesEndpointModel(apikey = apikey, series_id = "GNPCA");
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_id", model.series_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesCategoriesEndpointModel) -> String

Build the URL string for the `fred/series/categories` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the categories that hold one economic data series.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesCategoriesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesCategoriesEndpointModel(apikey = apikey, series_id = "EXJPUS");
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesCategoriesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_id", model.series_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/categories", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesObservationsEndpointModel) -> String

Build the URL string for the `fred/series/observations` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the observations (the data values) of one economic data series.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesObservationsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesObservationsEndpointModel(apikey = apikey, series_id = "DHHNGSP", observation_start = "2025-01-01", observation_end = "2025-01-10");
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesObservationsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_id", model.series_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "sort_order", model.sort_order);
    _add_parameter!(parameters, "observation_start", model.observation_start);
    _add_parameter!(parameters, "observation_end", model.observation_end);
    _add_parameter!(parameters, "units", model.units);
    _add_parameter!(parameters, "frequency", model.frequency);
    _add_parameter!(parameters, "aggregation_method", model.aggregation_method);
    _add_parameter!(parameters, "output_type", model.output_type);
    _add_parameter!(parameters, "vintage_dates", model.vintage_dates);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/observations", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesReleaseEndpointModel) -> String

Build the URL string for the `fred/series/release` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the release that publishes one economic data series.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesReleaseEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesReleaseEndpointModel(apikey = apikey, series_id = "IRA");
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesReleaseEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_id", model.series_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/release", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesSearchEndpointModel) -> String

Build the URL string for the `fred/series/search` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the economic data series that match a search text.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesSearchEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesSearchEndpointModel(apikey = apikey, search_text = "monetary service index", limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesSearchEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "search_text", model.search_text);
    _add_parameter!(parameters, "search_type", model.search_type);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);
    _add_parameter!(parameters, "filter_variable", model.filter_variable);
    _add_parameter!(parameters, "filter_value", model.filter_value);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "exclude_tag_names", model.exclude_tag_names);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/search", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesSearchTagsEndpointModel) -> String

Build the URL string for the `fred/series/search/tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags of the series that match a search text.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesSearchTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesSearchTagsEndpointModel(apikey = apikey, series_search_text = "monetary service index", limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesSearchTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_search_text", model.series_search_text);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "tag_group_id", model.tag_group_id);
    _add_parameter!(parameters, "tag_search_text", model.tag_search_text);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/search/tags", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesSearchRelatedTagsEndpointModel) -> String

Build the URL string for the `fred/series/search/related_tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags that are related to a set of tags, among the series that match a search text.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesSearchRelatedTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesSearchRelatedTagsEndpointModel(apikey = apikey, series_search_text = "mortgage rate", tag_names = "30-year;frb", limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesSearchRelatedTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_search_text", model.series_search_text);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "exclude_tag_names", model.exclude_tag_names);
    _add_parameter!(parameters, "tag_group_id", model.tag_group_id);
    _add_parameter!(parameters, "tag_search_text", model.tag_search_text);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/search/related_tags", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesTagsEndpointModel) -> String

Build the URL string for the `fred/series/tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags of one economic data series.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesTagsEndpointModel(apikey = apikey, series_id = "STLFSI");
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_id", model.series_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/tags", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesUpdatesEndpointModel) -> String

Build the URL string for the `fred/series/updates` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the economic data series, sorted by the time that FRED last updated them, most recent first.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesUpdatesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesUpdatesEndpointModel(apikey = apikey, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesUpdatesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "filter_value", model.filter_value);
    _add_parameter!(parameters, "start_time", model.start_time);
    _add_parameter!(parameters, "end_time", model.end_time);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/updates", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredSeriesVintageDatesEndpointModel) -> String

Build the URL string for the `fred/series/vintagedates` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the dates on which FRED revised the data of one economic data series, or added data to it.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredSeriesVintageDatesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredSeriesVintageDatesEndpointModel(apikey = apikey, series_id = "GNPCA", limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredSeriesVintageDatesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "series_id", model.series_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/series/vintagedates", parameters);

    # return the URL string -
    return url_string;
end

# --- CATEGORIES ENDPOINTS ------------------------------------------------------------------------------------- #

"""
    url(base::String, model::MyFredCategoryEndpointModel) -> String

Build the URL string for the `fred/category` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns one category: its identifier, name, and parent category.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredCategoryEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredCategoryEndpointModel(apikey = apikey, category_id = 125);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredCategoryEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "category_id", model.category_id);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/category", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredCategoryChildrenEndpointModel) -> String

Build the URL string for the `fred/category/children` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the child categories of one category.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredCategoryChildrenEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredCategoryChildrenEndpointModel(apikey = apikey, category_id = 13);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredCategoryChildrenEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "category_id", model.category_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/category/children", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredCategoryRelatedEndpointModel) -> String

Build the URL string for the `fred/category/related` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the categories that are related to one category. Most categories have no related categories.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredCategoryRelatedEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredCategoryRelatedEndpointModel(apikey = apikey, category_id = 32073);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredCategoryRelatedEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "category_id", model.category_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/category/related", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredCategorySeriesEndpointModel) -> String

Build the URL string for the `fred/category/series` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the economic data series that belong to one category.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredCategorySeriesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredCategorySeriesEndpointModel(apikey = apikey, category_id = 125, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredCategorySeriesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "category_id", model.category_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);
    _add_parameter!(parameters, "filter_variable", model.filter_variable);
    _add_parameter!(parameters, "filter_value", model.filter_value);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "exclude_tag_names", model.exclude_tag_names);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/category/series", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredCategoryTagsEndpointModel) -> String

Build the URL string for the `fred/category/tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags of the series that belong to one category.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredCategoryTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredCategoryTagsEndpointModel(apikey = apikey, category_id = 125, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredCategoryTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "category_id", model.category_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "tag_group_id", model.tag_group_id);
    _add_parameter!(parameters, "search_text", model.search_text);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/category/tags", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredCategoryRelatedTagsEndpointModel) -> String

Build the URL string for the `fred/category/related_tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags that are related to a set of tags, among the series that belong to one category.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredCategoryRelatedTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredCategoryRelatedTagsEndpointModel(apikey = apikey, category_id = 125, tag_names = "services;quarterly", limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredCategoryRelatedTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "category_id", model.category_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "exclude_tag_names", model.exclude_tag_names);
    _add_parameter!(parameters, "tag_group_id", model.tag_group_id);
    _add_parameter!(parameters, "search_text", model.search_text);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/category/related_tags", parameters);

    # return the URL string -
    return url_string;
end

# --- RELEASES ENDPOINTS --------------------------------------------------------------------------------------- #

"""
    url(base::String, model::MyFredReleasesEndpointModel) -> String

Build the URL string for the `fred/fred/releases` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns every release of economic data: its identifier, name, and whether FRED publishes a press release for it.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleasesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleasesEndpointModel(apikey = apikey, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleasesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/releases", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleasesDatesEndpointModel) -> String

Build the URL string for the `fred/fred/releases/dates` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the release dates of every release of economic data. Each record holds a release identifier, a release name, and a date.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleasesDatesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleasesDatesEndpointModel(apikey = apikey, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleasesDatesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);
    _add_parameter!(parameters, "include_release_dates_with_no_data", model.include_release_dates_with_no_data);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/releases/dates", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseEndpointModel) -> String

Build the URL string for the `fred/fred/release` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns one release of economic data: its identifier, name, and whether FRED publishes a press release for it.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseEndpointModel(apikey = apikey, release_id = 53);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseDatesEndpointModel) -> String

Build the URL string for the `fred/fred/release/dates` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the release dates of one release of economic data. Each record holds a release identifier and a date.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseDatesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseDatesEndpointModel(apikey = apikey, release_id = 82, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseDatesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "sort_order", model.sort_order);
    _add_parameter!(parameters, "include_release_dates_with_no_data", model.include_release_dates_with_no_data);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release/dates", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseSeriesEndpointModel) -> String

Build the URL string for the `fred/fred/release/series` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the economic data series that belong to one release.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseSeriesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseSeriesEndpointModel(apikey = apikey, release_id = 51, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseSeriesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);
    _add_parameter!(parameters, "filter_variable", model.filter_variable);
    _add_parameter!(parameters, "filter_value", model.filter_value);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "exclude_tag_names", model.exclude_tag_names);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release/series", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseSourcesEndpointModel) -> String

Build the URL string for the `fred/fred/release/sources` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the sources of the data of one release. The results are not paged.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseSourcesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseSourcesEndpointModel(apikey = apikey, release_id = 51);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseSourcesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release/sources", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseTagsEndpointModel) -> String

Build the URL string for the `fred/fred/release/tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags of the series that belong to one release.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseTagsEndpointModel(apikey = apikey, release_id = 86, limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "tag_group_id", model.tag_group_id);
    _add_parameter!(parameters, "search_text", model.search_text);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release/tags", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseRelatedTagsEndpointModel) -> String

Build the URL string for the `fred/fred/release/related_tags` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the tags that are related to a set of tags, among the series that belong to one release.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseRelatedTagsEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseRelatedTagsEndpointModel(apikey = apikey, release_id = 86, tag_names = "sa;foreign", limit = 3);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseRelatedTagsEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "realtime_start", model.realtime_start);
    _add_parameter!(parameters, "realtime_end", model.realtime_end);
    _add_parameter!(parameters, "tag_names", model.tag_names);
    _add_parameter!(parameters, "exclude_tag_names", model.exclude_tag_names);
    _add_parameter!(parameters, "tag_group_id", model.tag_group_id);
    _add_parameter!(parameters, "search_text", model.search_text);
    _add_parameter!(parameters, "limit", model.limit);
    _add_parameter!(parameters, "offset", model.offset);
    _add_parameter!(parameters, "order_by", model.order_by);
    _add_parameter!(parameters, "sort_order", model.sort_order);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release/related_tags", parameters);

    # return the URL string -
    return url_string;
end

"""
    url(base::String, model::MyFredReleaseTablesEndpointModel) -> String

Build the URL string for the `fred/fred/release/tables` endpoint of the FRED API.
An HTTP GET call to this URL calls the endpoint with the parameters that the model holds. This endpoint returns the elements of the table of one release. Each element is a section or a series of the table, and an element can have children. This endpoint takes no real-time parameters.
The URL lists the parameters in the order of the fields of the model, then the API key, then `file_type=json`, which asks FRED for JSON text.
A field at its empty value stays out of the URL.

### Arguments
- `base::String`: the base URL of the FRED API, i.e., `"https://api.stlouisfed.org"`.
- `model::MyFredReleaseTablesEndpointModel`: the endpoint model that holds the API key and the parameters of the call.

### Returns
- `String`: the complete URL string. The URL holds the API key, so do not print it or share it.

### Throws
- This function does not throw an error.

### Example
```julia
model = MyFredReleaseTablesEndpointModel(apikey = apikey, release_id = 53, element_id = 12886);
request_url = url("https://api.stlouisfed.org", model);
```
"""
function url(base::String, model::MyFredReleaseTablesEndpointModel)::String

    # initialize: the list of key=value parameters for the query string -
    parameters = Vector{Pair{String,String}}();

    # add the parameters of this endpoint. A parameter at its empty value stays out of the URL -
    _add_parameter!(parameters, "release_id", model.release_id);
    _add_parameter!(parameters, "element_id", model.element_id);
    _add_parameter!(parameters, "include_observation_values", model.include_observation_values);
    _add_parameter!(parameters, "observation_date", model.observation_date);

    # every request carries the API key, and asks FRED for JSON text (the default of FRED is XML) -
    _add_parameter!(parameters, "api_key", model.apikey);
    _add_parameter!(parameters, "file_type", "json");

    # build the URL string: base + path + ? + query string -
    url_string = _build_url(base, "/fred/release/tables", parameters);

    # return the URL string -
    return url_string;
end

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #

"""
    _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::String) -> Nothing

Add the pair `key => value` to the list of query parameters, unless `value` is the empty string.
An empty string means that the model does not set this parameter, so it stays out of the URL.

### Arguments
- `parameters::Vector{Pair{String,String}}`: the list of query parameters. This function adds to the list.
- `key::String`: the name of the FRED parameter, e.g., `"series_id"`.
- `value::String`: the value of the parameter. The empty string `""` means not set.

### Returns
- `Nothing`: this function changes `parameters` and returns nothing.

### Throws
- This function does not throw an error.

### Example
```julia
parameters = Pair{String,String}[];
_add_parameter!(parameters, "series_id", "DHHNGSP");
```
"""
function _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::String)::Nothing

    # check: is the value set? An empty string means not set -
    if (value != "")
        push!(parameters, key => value);
    end

    return nothing;
end

"""
    _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Int64) -> Nothing

Add the pair `key => string(value)` to the list of query parameters, unless `value` is `0`.
A value of `0` means that the model does not set this parameter, so it stays out of the URL.

### Arguments
- `parameters::Vector{Pair{String,String}}`: the list of query parameters. This function adds to the list.
- `key::String`: the name of the FRED parameter, e.g., `"limit"`.
- `value::Int64`: the value of the parameter. The value `0` means not set.

### Returns
- `Nothing`: this function changes `parameters` and returns nothing.

### Throws
- This function does not throw an error.

### Example
```julia
parameters = Pair{String,String}[];
_add_parameter!(parameters, "limit", 100);
```
"""
function _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Int64)::Nothing

    # check: is the value set? The value 0 means not set -
    if (value != 0)
        push!(parameters, key => string(value));
    end

    return nothing;
end

"""
    _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Bool) -> Nothing

Add the pair `key => "true"` to the list of query parameters when `value` is `true`.
A value of `false` means that the model does not set this parameter, so it stays out of the URL.

### Arguments
- `parameters::Vector{Pair{String,String}}`: the list of query parameters. This function adds to the list.
- `key::String`: the name of the FRED parameter, e.g., `"include_release_dates_with_no_data"`.
- `value::Bool`: the value of the parameter. The value `false` means not set.

### Returns
- `Nothing`: this function changes `parameters` and returns nothing.

### Throws
- This function does not throw an error.

### Example
```julia
parameters = Pair{String,String}[];
_add_parameter!(parameters, "include_release_dates_with_no_data", true);
```
"""
function _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Bool)::Nothing

    # check: is the value set? The value false means not set -
    if (value == true)
        push!(parameters, key => "true");
    end

    return nothing;
end

"""
    _build_url(base::String, path::String, parameters::Vector{Pair{String,String}}) -> String

Build the request URL from the base URL, the path of an endpoint, and the list of query parameters.
The URL has the form `base * path * "?" * query`. The query joins each `key=value` with `&`, in the order of the list,
and encodes each value, so that characters such as `&`, `;`, `,`, and spaces reach FRED intact.

### Arguments
- `base::String`: the base URL of the FRED API, e.g., `"https://api.stlouisfed.org"`.
- `path::String`: the path of the endpoint, e.g., `"/fred/series/search"`.
- `parameters::Vector{Pair{String,String}}`: the query parameters, in the order that they appear in the URL.

### Returns
- `String`: the request URL.

### Throws
- This function does not throw an error.

### Example
```julia
request_url = _build_url("https://api.stlouisfed.org", "/fred/series", ["series_id" => "DHHNGSP"]);
```
"""
function _build_url(base::String, path::String, parameters::Vector{Pair{String,String}})::String

    # build the query text, one key=value piece at a time -
    query = "";
    for (index, parameter) in enumerate(parameters)

        # get the key and the value of this parameter -
        key = parameter.first;
        value = parameter.second;

        # separate this piece from the previous piece with & -
        if (index > 1)
            query = query * "&";
        end

        # add the piece, with the value encoded for a URL -
        query = query * key * "=" * HTTP.escapeuri(value);
    end

    # join the base URL, the path, and the query -
    return base * path * "?" * query;
end
