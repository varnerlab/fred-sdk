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
- `DataFrame`: a table with one row for each vintage date, in the order of the response. The columns are:
    - `date::Date`: a vintage date of the series.

  If the response holds no vintage dates, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"vintage_dates"` key. An `ArgumentError` is thrown when a vintage date is a malformed date string.

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

"""
    process_release_tables_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the `fred/release/tables` endpoint of the FRED API.
We parse the response string, select seven fields from each element of the release table, and return them as a `DataFrame`.
FRED sends the elements as a dictionary keyed by element id. We visit the elements in the order of the response.
FRED sends `element_id`, `parent_id`, and `level` as numbers in some records and as text in others. We convert each one to an `Int64`.
FRED lists every element, nested ones included, as its own entry of `elements`, so each element is one row.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the `fred/release/tables` endpoint.

### Returns
- `DataFrame`: a table with one row for each element, in the order of the response. The columns are:
    - `element_id::Int64`: the id of the element.
    - `parent_id::Union{Missing,Int64}`: the id of the parent element, or `missing` when FRED sends none.
    - `series_id::Union{Missing,String}`: the id of the series of the element, or `missing` when FRED sends none.
    - `type::String`: the type of the element, e.g., `"series"`.
    - `name::String`: the name of the element.
    - `line::Union{Missing,String}`: the line number of the element in the table, as text, or `missing` when FRED sends none.
    - `level::Int64`: the depth of the element in the table.

  If the response holds no elements, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"elements"` key, or when an element lacks a required field. An `ArgumentError` is thrown when an id or level is not a whole number.

### Example
```julia
model = MyFredReleaseTablesEndpointModel(apikey = apikey, release_id = 53);
table = api(MyFredReleaseTablesEndpointModel, url("https://api.stlouisfed.org", model); handler = process_release_tables_response_dataframe);
```
"""
function process_release_tables_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    element_ids = Array{Int64,1}();
    parent_ids = Array{Union{Missing,Int64},1}();
    series_ids = Array{Union{Missing,String},1}();
    types = Array{String,1}();
    element_names = Array{String,1}();
    lines = Array{Union{Missing,String},1}();
    levels = Array{Int64,1}();

    # parse the response, and visit the elements one at a time -
    response_dict = JSON.parse(response);
    for data ∈ values(response_dict["elements"])

        # the element id, as an Int64 -
        push!(element_ids, _to_int(data["element_id"]));
        # the parent id as an Int64, or missing when FRED sends none -
        parent_id = _value_or_missing(data, "parent_id");
        if (ismissing(parent_id) == true)
            push!(parent_ids, missing);
        else
            push!(parent_ids, _to_int(parent_id));
        end
        # the series id, or missing when FRED sends none -
        push!(series_ids, _value_or_missing(data, "series_id"));
        # the type of the element -
        push!(types, data["type"]);
        # the name of the element -
        push!(element_names, data["name"]);
        # the line number, or missing when FRED sends none -
        push!(lines, _value_or_missing(data, "line"));
        # the level, as an Int64 -
        push!(levels, _to_int(data["level"]));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(element_id = element_ids, parent_id = parent_ids, series_id = series_ids, type = types,
        name = element_names, line = lines, level = levels);
    return dataframe
end

"""
    process_maps_series_data_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the `geofred/series/data` endpoint of the FRED API.
We parse the response string, select the records under `meta.data`, and return them as a `DataFrame`.
FRED sends the records as a dictionary keyed by date, with a list of records for each date.
When `meta.data` is a list of records instead, we use `meta.date` as the date of each record.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the `geofred/series/data` endpoint.

### Returns
- `DataFrame`: a table with one row for each region and date, in the order of the response. The columns are:
    - `date::Date`: the date of the value.
    - `region::String`: the name of the region.
    - `code::String`: the code of the region.
    - `series_id::Union{Missing,String}`: the id of the series of the region, or `missing` when FRED sends none.
    - `value::Union{Missing,Float64}`: the value for the region, or `missing` when FRED sends `"."`, `null`, or no value.

  If the response holds no records, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"meta"` or `"data"` key, or when a record lacks a required field. An `ArgumentError` is thrown when a date or value is malformed.

### Example
```julia
model = MyFredMapsSeriesDataEndpointModel(apikey = apikey, series_id = "WIPCPI");
table = api(MyFredMapsSeriesDataEndpointModel, url("https://api.stlouisfed.org", model); handler = process_maps_series_data_response_dataframe);
```
"""
function process_maps_series_data_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    dates = Array{Date,1}();
    regions = Array{String,1}();
    codes = Array{String,1}();
    series_ids = Array{Union{Missing,String},1}();
    values_list = Array{Union{Missing,Float64},1}();

    # parse the response, and collect the (period, record) pairs under meta.data -
    response_dict = JSON.parse(response);
    period_pairs = _collect_period_records(response_dict["meta"]);
    for (period, data) ∈ period_pairs

        # the date of the value, as a Date -
        push!(dates, Date(period));
        # the name of the region -
        push!(regions, data["region"]);
        # the code of the region -
        push!(codes, data["code"]);
        # the id of the series of the region, or missing when FRED sends none -
        push!(series_ids, _value_or_missing(data, "series_id"));
        # the value, or missing when FRED sends a period -
        push!(values_list, _to_float(_value_or_missing(data, "value")));
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(date = dates, region = regions, code = codes, series_id = series_ids, value = values_list);
    return dataframe
end

"""
    process_maps_regional_data_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the `geofred/regional/data` endpoint of the FRED API.
We parse the response string and visit each entry of the response, which holds the title of the series group and its data.
For each entry, we select the records under `data`, and return them as a `DataFrame`.
FRED sends the records as a dictionary keyed by period, with a list of records for each period.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the `geofred/regional/data` endpoint.

### Returns
- `DataFrame`: a table with one row for each region and period, in the order of the response. The columns are:
    - `period::String`: the period of the value, as text.
    - `region::String`: the name of the region.
    - `code::String`: the code of the region.
    - `series_id::Union{Missing,String}`: the id of the series of the region, or `missing` when FRED sends none.
    - `value::Union{Missing,Float64}`: the value for the region, or `missing` when FRED sends `"."`, `null`, or no value.

  If the response holds no entries, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when an entry lacks the `"data"` key, or when a record lacks a required field. An `ArgumentError` is thrown when a value is malformed.

### Example
```julia
model = MyFredMapsRegionalDataEndpointModel(apikey = apikey, series_group = "882", region_type = "state", date = "2013-01-01", season = "NSA", units = "Dollars", frequency = "a");
table = api(MyFredMapsRegionalDataEndpointModel, url("https://api.stlouisfed.org", model); handler = process_maps_regional_data_response_dataframe);
```
"""
function process_maps_regional_data_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    periods = Array{String,1}();
    regions = Array{String,1}();
    codes = Array{String,1}();
    series_ids = Array{Union{Missing,String},1}();
    values_list = Array{Union{Missing,Float64},1}();

    # parse the response, and visit each entry (the title of the series group and its data) -
    response_dict = JSON.parse(response);
    for entry ∈ values(response_dict)

        # collect the (period, record) pairs of the entry, and visit them one at a time -
        period_pairs = _collect_period_records(entry);
        for (period, data) ∈ period_pairs

            # the period, as text -
            push!(periods, period);
            # the name of the region -
            push!(regions, data["region"]);
            # the code of the region -
            push!(codes, data["code"]);
            # the id of the series of the region, or missing when FRED sends none -
            push!(series_ids, _value_or_missing(data, "series_id"));
            # the value, or missing when FRED sends a period -
            push!(values_list, _to_float(_value_or_missing(data, "value")));
        end
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(period = periods, region = regions, code = codes, series_id = series_ids, value = values_list);
    return dataframe
end

"""
    process_release_observations_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

Process the JSON response string from the version 2 `fred/release/observations` endpoint of the FRED API.
We parse the response string, visit each series, and visit each observation of the series.
We return the observations of all series as one `DataFrame`.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON response string from the version 2 `fred/release/observations` endpoint.

### Returns
- `DataFrame`: a table with one row for each observation, in the order of the response. The columns are:
    - `series_id::String`: the id of the series that holds the observation.
    - `date::Date`: the date of the observation.
    - `value::Union{Missing,Float64}`: the value of the observation, or `missing` when FRED sends `"."`, `null`, or no value.

  If the response holds no series, the table is empty.

### Throws
- The JSON parser throws an error when `response` is not valid JSON. A `KeyError` is thrown when the response lacks the `"series"` key, or when a series or an observation lacks a required field. An `ArgumentError` is thrown when a date or value is malformed.

### Example
```julia
model = MyFredV2ReleaseObservationsEndpointModel(apikey = apikey, release_id = 52);
table = api(MyFredV2ReleaseObservationsEndpointModel, url("https://api.stlouisfed.org", model); handler = process_release_observations_response_dataframe);
```
"""
function process_release_observations_response_dataframe(model::Type{T}, response::String)::DataFrame where T <: AbstractFredEndpointModel

    # initialize: one array for each column of the table -
    series_ids = Array{String,1}();
    dates = Array{Date,1}();
    values_list = Array{Union{Missing,Float64},1}();

    # parse the response, and visit the series one at a time -
    response_dict = JSON.parse(response);
    for series ∈ response_dict["series"]

        # visit the observations of the series one at a time -
        for data ∈ series["observations"]

            # the id of the series that holds the observation -
            push!(series_ids, series["series_id"]);
            # the date of the observation, as a Date -
            push!(dates, Date(data["date"]));
            # the value, or missing when FRED sends a period -
            push!(values_list, _to_float(_value_or_missing(data, "value")));
        end
    end

    # put the columns into a table, and return it -
    dataframe = DataFrame(series_id = series_ids, date = dates, value = values_list);
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
    _to_int(x)::Int64

Private helper. It converts an id or a level from a FRED response to an `Int64`.
FRED sends these fields as numbers in some records and as text in others.

### Arguments
- `x`: an `Int64`, or a `String` that holds a whole number, e.g., `"12"`.

### Returns
- The `Int64` that `x` holds.

### Throws
- An `ArgumentError` when `x` is a `String` that is not a whole number, or when `x` is neither an `Int64` nor a `String`.

### Example
```julia
level = FredAPI._to_int("2"); # 2
```
"""
function _to_int(x)::Int64

    # a number stays as it is -
    if (x isa Int64)
        return x;
    end

    # text becomes a number -
    if (x isa String)
        return parse(Int64, x);
    end

    # any other type is not an id or a level -
    throw(ArgumentError("expected an Int64 or a String, but got a value of type $(typeof(x))"));
end

"""
    _to_float(x)::Union{Missing,Float64}

Private helper. It converts a value from a FRED response to a `Float64`.
FRED sends a value as text in some endpoints and as a number in others.

### Arguments
- `x`: a `String` such as `"3.65"` or `"."`, a number, `nothing` (a JSON `null`), or `missing`.

### Returns
- `missing` when `x` is `nothing`, `missing`, or the text `"."`, otherwise the `Float64` that `x` holds.

### Throws
- An `ArgumentError` when `x` is text that is not a period and not a number, or when `x` is neither text, a number, nor `nothing`.

### Example
```julia
value = FredAPI._to_float(35544); # 35544.0
```
"""
function _to_float(x)::Union{Missing,Float64}

    # an absent key has no value -
    if (ismissing(x) == true)
        return missing;
    end

    # a JSON null has no value -
    if (isnothing(x) == true)
        return missing;
    end

    # text goes through the period rule -
    if (x isa String)
        return _parse_value(x);
    end

    # a number becomes a Float64 -
    if (x isa Number)
        return Float64(x);
    end

    # any other type is not a value -
    throw(ArgumentError("expected text or a number, but got a value of type $(typeof(x))"));
end

"""
    _collect_period_records(holder)::Vector{Tuple{String,Any}}

Private helper. It collects the records of a maps response as (period, record) pairs.
The `holder` is the dictionary that has the key `"data"`.
FRED sends `data` as a dictionary keyed by period, with a list of records for each period.
When `data` is a list of records instead, `holder["date"]` is the period of each record.

### Arguments
- `holder`: the parsed dictionary that holds `"data"`, e.g., the value of `"meta"`.

### Returns
- A vector of (period, record) pairs, in the order of the response. The vector is empty when `data` holds no records.

### Throws
- A `KeyError` when `holder` lacks `"data"`, or when `data` holds records and `holder` lacks `"date"`.

### Example
```julia
period_pairs = FredAPI._collect_period_records(Dict("data" => Dict("2012-01-01" => [Dict("code" => "01")])));
```
"""
function _collect_period_records(holder)::Vector{Tuple{String,Any}}

    # initialize: the vector of pairs -
    period_pairs = Vector{Tuple{String,Any}}();
    data_holder = holder["data"];

    # data is a dictionary keyed by period: pair each record with its period -
    if (data_holder isa AbstractDict)
        for (period, record_list) ∈ data_holder
            for record ∈ record_list
                push!(period_pairs, (String(period), record));
            end
        end
        return period_pairs
    end

    # data is a list of records: pair each record with the date of the response -
    for record ∈ data_holder
        push!(period_pairs, (String(holder["date"]), record));
    end
    return period_pairs
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
