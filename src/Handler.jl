# =============================================================================
# Handler.jl: the functions that turn each JSON response into a DataFrame.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #
# This handler overlaps with `process_series_response_dataframe`; we keep it unchanged, with its six columns.
"""
    process_search_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the `fred/series/search` endpoint of the FRED API.
We parse the response string, select six fields from each series, and return them as a `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the `fred/series/search` endpoint.

### Returns
- `DataFrame`: a table with one row for each series. The columns are:
    - `id::String`: the series id.
    - `title::String`: the title of the series.
    - `frequency::String`: the frequency of the series.
    - `units::String`: the units of the series.
    - `observation_start::String`: the date of the first observation, as text.
    - `observation_end::String`: the date of the last observation, as text.

  If the search matched no series, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when a series lacks one of the six fields.

### Example
```julia
model = MyFredSeriesSearchEndpointModel(apikey = apikey, search_text = "monetary service index");
table = api(MyFredSeriesSearchEndpointModel, url("https://api.stlouisfed.org", model); handler = process_search_response_dataframe);
```
"""
function process_search_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    ids = Array{String,1}();
    titles = Array{String,1}();
    frequencies = Array{String,1}();
    units = Array{String,1}();
    observation_starts = Array{String,1}();
    observation_ends = Array{String,1}();

    # parse the response. FRED spells the key of the list of series with a double s: "seriess" -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["seriess"]

        # select the keys we want from the JSON response, and store them in the order we want -
        push!(ids, data["id"]);
        push!(titles, data["title"]);
        push!(frequencies, data["frequency"]);
        push!(units, data["units"]);
        push!(observation_starts, data["observation_start"]);
        push!(observation_ends, data["observation_end"]);
    end

    # put the six columns into a table, and return it -
    dataframe = DataFrame(id = ids, title = titles, frequency = frequencies, units = units,
        observation_start = observation_starts, observation_end = observation_ends);
    return dataframe
end

# This handler does the same "." check as `_parse_value`; we keep it unchanged.
"""
    process_observations_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the `fred/series/observations` endpoint of the FRED API.
We parse the response string, convert the date and the value of each observation, and return them as a `DataFrame`.

FRED sends the date and the value of an observation as text. When FRED has no value for a date, e.g., a holiday in a
daily series, the `"value"` key holds a period, `"."`. We store `missing` for that observation.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the `fred/series/observations` endpoint.

### Returns
- `DataFrame`: a table with one row for each observation, in the order of the response. The columns are:
    - `date::Date`: the date of the observation.
    - `value::Union{Missing,Float64}`: the value of the observation, or `missing` when FRED has no value for the date.

  If the response has no observations, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when an observation lacks a `"date"` or `"value"` key.

### Example
```julia
model = MyFredSeriesObservationsEndpointModel(apikey = apikey, series_id = "GNPCA");
table = api(MyFredSeriesObservationsEndpointModel, url("https://api.stlouisfed.org", model); handler = process_observations_response_dataframe);
```
"""
function process_observations_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    dates = Array{Date,1}(); # the date of each observation
    observation_values = Array{Union{Missing,Float64},1}(); # the value of each observation: a number, or missing

    # parse the response, and visit the observations one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["observations"]

        # get the date and the value of this observation as text -
        date_string = data["date"]; # e.g., "2025-01-02"
        value_string = data["value"]; # e.g., "3.65", or "." when FRED has no value for this date

        # convert the date text to a Date -
        date = Date(date_string);

        # the value starts as missing, and stays missing when FRED sent a period -
        value = missing;
        if (value_string != ".")
            value = parse(Float64, value_string);
        end

        # store the date and the value of this observation -
        push!(dates, date);
        push!(observation_values, value);
    end

    # put the two columns into a table, and return it -
    dataframe = DataFrame(date = dates, value = observation_values);
    return dataframe
end

"""
    process_series_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the endpoints that list series: `fred/series`, `fred/category/series`, `fred/release/series`, `fred/series/search`, `fred/series/updates`, and `fred/tags/series` of the FRED API.
We parse the response string, select ten fields from each series, convert the two observation dates to `Date`, and return the fields as a `DataFrame`.
FRED spells the key of the list of series with a double s: `"seriess"`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the endpoints that list series: `fred/series`, `fred/category/series`, `fred/release/series`, `fred/series/search`, `fred/series/updates`, and `fred/tags/series`.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `id::String`: the series id.
    - `title::String`: the title of the series.
    - `frequency::String`: the frequency of the series.
    - `units::String`: the units of the series.
    - `seasonal_adjustment::String`: the seasonal adjustment of the series.
    - `observation_start::Date`: the date of the first observation.
    - `observation_end::Date`: the date of the last observation.
    - `last_updated::String`: the time FRED last updated the series, as text.
    - `popularity::Union{Missing,Int64}`: the popularity of the series, or `missing` when FRED sends none.
    - `notes::Union{Missing,String}`: the notes on the series, or `missing` when FRED sends none.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"seriess"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredSeriesEndpointModel(apikey = apikey, series_id = "GNPCA");
table = api(MyFredSeriesEndpointModel, url("https://api.stlouisfed.org", model); handler = process_series_response_dataframe);
```
"""
function process_series_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    ids = Array{String,1}(); # the series id
    titles = Array{String,1}();
    frequencies = Array{String,1}();
    units = Array{String,1}();
    seasonal_adjustments = Array{String,1}();
    observation_starts = Array{Date,1}();
    observation_ends = Array{Date,1}();
    last_updateds = Array{String,1}();
    popularities = Array{Union{Missing,Int64},1}();
    notes = Array{Union{Missing,String},1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["seriess"]

        # the series id -
        push!(ids, data["id"]);
        # the title -
        push!(titles, data["title"]);
        # the frequency -
        push!(frequencies, data["frequency"]);
        # the units -
        push!(units, data["units"]);
        # the seasonal adjustment -
        push!(seasonal_adjustments, data["seasonal_adjustment"]);
        # the date of the first observation, as a Date -
        push!(observation_starts, Date(data["observation_start"]));
        # the date of the last observation, as a Date -
        push!(observation_ends, Date(data["observation_end"]));
        # the time of the last update, as text -
        push!(last_updateds, data["last_updated"]);
        # the popularity, or missing when FRED sends none -
        push!(popularities, _value_or_missing(data, "popularity"));
        # the notes, or missing when FRED sends none -
        push!(notes, _value_or_missing(data, "notes"));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(id = ids, title = titles, frequency = frequencies, units = units,
        seasonal_adjustment = seasonal_adjustments, observation_start = observation_starts,
        observation_end = observation_ends, last_updated = last_updateds, popularity = popularities, notes = notes);
    return dataframe
end

"""
    process_categories_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the endpoints that list categories: `fred/category`, `fred/category/children`, `fred/category/related`, and `fred/series/categories` of the FRED API.
We parse the response string, select four fields from each category, and return them as a `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the endpoints that list categories: `fred/category`, `fred/category/children`, `fred/category/related`, and `fred/series/categories`.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `id::Int64`: the category id.
    - `name::String`: the name of the category.
    - `parent_id::Int64`: the id of the parent category.
    - `notes::Union{Missing,String}`: the notes on the category, or `missing` when FRED sends none.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"categories"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredCategoryChildrenEndpointModel(apikey = apikey, category_id = 13);
table = api(MyFredCategoryChildrenEndpointModel, url("https://api.stlouisfed.org", model); handler = process_categories_response_dataframe);
```
"""
function process_categories_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    ids = Array{Int64,1}();
    names = Array{String,1}();
    parent_ids = Array{Int64,1}();
    notes = Array{Union{Missing,String},1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["categories"]

        # the category id -
        push!(ids, data["id"]);
        # the name -
        push!(names, data["name"]);
        # the id of the parent category -
        push!(parent_ids, data["parent_id"]);
        # the notes, or missing when FRED sends none -
        push!(notes, _value_or_missing(data, "notes"));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(id = ids, name = names, parent_id = parent_ids, notes = notes);
    return dataframe
end

"""
    process_releases_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the endpoints that list releases: `fred/releases`, `fred/release`, `fred/series/release`, and `fred/source/releases` of the FRED API.
We parse the response string, select five fields from each release, and return them as a `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the endpoints that list releases: `fred/releases`, `fred/release`, `fred/series/release`, and `fred/source/releases`.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `id::Int64`: the release id.
    - `name::String`: the name of the release.
    - `press_release::Bool`: `true` when the release is a press release.
    - `link::Union{Missing,String}`: the link to the release, or `missing` when FRED sends none.
    - `notes::Union{Missing,String}`: the notes on the release, or `missing` when FRED sends none.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"releases"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredReleasesEndpointModel(apikey = apikey);
table = api(MyFredReleasesEndpointModel, url("https://api.stlouisfed.org", model); handler = process_releases_response_dataframe);
```
"""
function process_releases_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    ids = Array{Int64,1}();
    names = Array{String,1}();
    press_releases = Array{Bool,1}();
    links = Array{Union{Missing,String},1}();
    notes = Array{Union{Missing,String},1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["releases"]

        # the release id -
        push!(ids, data["id"]);
        # the name -
        push!(names, data["name"]);
        # whether the release is a press release -
        push!(press_releases, data["press_release"]);
        # the link, or missing when FRED sends none -
        push!(links, _value_or_missing(data, "link"));
        # the notes, or missing when FRED sends none -
        push!(notes, _value_or_missing(data, "notes"));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(id = ids, name = names, press_release = press_releases, link = links, notes = notes);
    return dataframe
end

"""
    process_release_dates_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the endpoints that list release dates: `fred/releases/dates` and `fred/release/dates` of the FRED API.
We parse the response string, select three fields from each release date, convert the date to `Date`, and return the fields as a `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the endpoints that list release dates: `fred/releases/dates` and `fred/release/dates`.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `release_id::Int64`: the release id.
    - `release_name::Union{Missing,String}`: the name of the release, or `missing` when FRED sends none. The `fred/release/dates` endpoint sends no name.
    - `date::Date`: the date of the release.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"release_dates"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredReleasesDatesEndpointModel(apikey = apikey);
table = api(MyFredReleasesDatesEndpointModel, url("https://api.stlouisfed.org", model); handler = process_release_dates_response_dataframe);
```
"""
function process_release_dates_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    release_ids = Array{Int64,1}();
    release_names = Array{Union{Missing,String},1}();
    dates = Array{Date,1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["release_dates"]

        # the release id -
        push!(release_ids, data["release_id"]);
        # the name of the release, or missing when FRED sends none -
        push!(release_names, _value_or_missing(data, "release_name"));
        # the date of the release, as a Date -
        push!(dates, Date(data["date"]));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(release_id = release_ids, release_name = release_names, date = dates);
    return dataframe
end

"""
    process_sources_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the endpoints that list sources: `fred/sources`, `fred/source`, and `fred/release/sources` of the FRED API.
We parse the response string, select four fields from each source, and return them as a `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the endpoints that list sources: `fred/sources`, `fred/source`, and `fred/release/sources`.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `id::Int64`: the source id.
    - `name::String`: the name of the source.
    - `link::Union{Missing,String}`: the link to the source, or `missing` when FRED sends none.
    - `notes::Union{Missing,String}`: the notes on the source, or `missing` when FRED sends none.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"sources"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredSourcesEndpointModel(apikey = apikey);
table = api(MyFredSourcesEndpointModel, url("https://api.stlouisfed.org", model); handler = process_sources_response_dataframe);
```
"""
function process_sources_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    ids = Array{Int64,1}();
    names = Array{String,1}();
    links = Array{Union{Missing,String},1}();
    notes = Array{Union{Missing,String},1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["sources"]

        # the source id -
        push!(ids, data["id"]);
        # the name -
        push!(names, data["name"]);
        # the link, or missing when FRED sends none -
        push!(links, _value_or_missing(data, "link"));
        # the notes, or missing when FRED sends none -
        push!(notes, _value_or_missing(data, "notes"));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(id = ids, name = names, link = links, notes = notes);
    return dataframe
end

"""
    process_tags_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the nine endpoints that list tags: `fred/tags`, `fred/related_tags`, `fred/category/tags`, `fred/category/related_tags`, `fred/release/tags`, `fred/release/related_tags`, `fred/series/tags`, `fred/series/search/tags`, and `fred/series/search/related_tags` of the FRED API.
We parse the response string, select six fields from each tag, and return them as a `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the nine endpoints that list tags: `fred/tags`, `fred/related_tags`, `fred/category/tags`, `fred/category/related_tags`, `fred/release/tags`, `fred/release/related_tags`, `fred/series/tags`, `fred/series/search/tags`, and `fred/series/search/related_tags`.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `name::String`: the name of the tag.
    - `group_id::String`: the id of the tag group.
    - `notes::Union{Missing,String}`: the notes on the tag, or `missing` when FRED sends none. An empty string from FRED stays an empty string.
    - `created::String`: the time FRED created the tag, as text.
    - `popularity::Int64`: the popularity of the tag.
    - `series_count::Int64`: the number of series that have the tag.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"tags"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredTagsEndpointModel(apikey = apikey);
table = api(MyFredTagsEndpointModel, url("https://api.stlouisfed.org", model); handler = process_tags_response_dataframe);
```
"""
function process_tags_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    names = Array{String,1}();
    group_ids = Array{String,1}();
    notes = Array{Union{Missing,String},1}();
    createds = Array{String,1}();
    popularities = Array{Int64,1}();
    series_counts = Array{Int64,1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["tags"]

        # the name -
        push!(names, data["name"]);
        # the id of the tag group -
        push!(group_ids, data["group_id"]);
        # the notes, or missing when FRED sends none -
        push!(notes, _value_or_missing(data, "notes"));
        # the time FRED created the tag, as text -
        push!(createds, data["created"]);
        # the popularity -
        push!(popularities, data["popularity"]);
        # the number of series that have the tag -
        push!(series_counts, data["series_count"]);
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(name = names, group_id = group_ids, notes = notes, created = createds,
        popularity = popularities, series_count = series_counts);
    return dataframe
end

"""
    process_vintage_dates_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the `fred/series/vintagedates` endpoint of the FRED API.
We parse the response string, convert each vintage date to a `Date`, and return the dates as a `DataFrame`.
FRED sends the vintage dates as a list of text values, not as a list of records.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the `fred/series/vintagedates` endpoint.

### Returns
- `DataFrame`: a table with one row for each record, in the order of the response. The columns are:
    - `date::Date`: a vintage date of the series.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"vintage_dates"` key, or when a record lacks a required field.

### Example
```julia
model = MyFredSeriesVintageDatesEndpointModel(apikey = apikey, series_id = "GNPCA");
table = api(MyFredSeriesVintageDatesEndpointModel, url("https://api.stlouisfed.org", model); handler = process_vintage_dates_response_dataframe);
```
"""
function process_vintage_dates_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    dates = Array{Date,1}();

    # parse the response, and visit the records one at a time -
    response_dict = JSON.parse(response);
    for data ∈ response_dict["vintage_dates"]

        # the vintage date, as a Date -
        push!(dates, Date(data));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(date = dates);
    return dataframe
end

# --- PUBLIC METHODS ABOVE HERE -------------------------------------------------------------------------------- #

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #
"""
    _value_or_missing(record, key::String)

Private helper. It reads the value of a key from one record of a FRED response.

### Arguments
- `record`: one record of a parsed response, a dictionary with text keys.
- `key::String`: the key to read.

### Returns
- The value of `key`, or `missing` when the key is absent or the value is `nothing` (a JSON `null`). An empty string stays an empty string.

### Throws
- This function does not throw an error.

### Example
```julia
notes = FredAPI._value_or_missing(Dict("name" => "GDP"), "notes"); # missing
```
"""
function _value_or_missing(record, key::String)

    # the key is absent: return missing -
    if (haskey(record, key) == false)
        return missing;
    end

    # get the value, and return missing when it is a JSON null -
    value = record[key];
    if (isnothing(value) == true)
        return missing;
    end

    # return the value -
    return value;
end

"""
    _parse_value(text::String)::Union{Missing,Float64}

Private helper. It converts the text value of an observation to a number.

### Arguments
- `text::String`: the value as FRED sends it, e.g., `"3.65"`, or `"."` when FRED has no value for the date.

### Returns
- `missing` when `text` is `"."`, otherwise the `Float64` that `text` holds.

### Throws
- An `ArgumentError` when `text` is not a period and not a number.

### Example
```julia
value = FredAPI._parse_value("3.65"); # 3.65
```
"""
function _parse_value(text::String)::Union{Missing,Float64}

    # a period means that FRED has no value for this date -
    if (text == ".")
        return missing;
    end

    # otherwise, convert the text to a Float64 -
    return parse(Float64, text);
end

"""
    _default_handler_process_fred_response(model::Type{T}, response::String) where T <: AbstractFredEndpointModel

Private default handler. It parses the JSON text that FRED returned into a dictionary.
The function looks up the parsing function for the endpoint model type, and calls that function.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON text of the response body.

### Returns
- The parsed JSON as a dictionary, or `nothing` if the model type is not recognized.

### Throws
- This function does not throw an error itself. The JSON parser throws an error when `response` is not valid JSON.

### Example
```julia
parsed = FredAPI._default_handler_process_fred_response(MyFredSeriesEndpointModel, "{}");
```
"""
function _default_handler_process_fred_response(model::Type{T},
    response::String) where T <: AbstractFredEndpointModel

    # initialize: the dictionary that holds one parsing function for each endpoint model -
    type_handler_dict = Dict{Any,Function}();

    # hardcode the response handler for each endpoint model -
    type_handler_dict[MyFredCategoryChildrenEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryRelatedEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategorySeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsRegionalDataEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsSeriesDataEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsSeriesGroupEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsShapesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseDatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseSeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseSourcesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseTablesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleasesDatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleasesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesCategoriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesObservationsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesReleaseEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesSearchEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesSearchRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesSearchTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesUpdatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesVintageDatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSourceEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSourceReleasesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSourcesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredTagsSeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredV2ReleaseObservationsEndpointModel] = (x::String) -> JSON.parse(x) # default handler

    # lookup the function to handle the response -
    if (haskey(type_handler_dict, model) == true)
        handler_function = type_handler_dict[model];
        return handler_function(response);
    end

    # default: return nothing -
    return nothing;
end
