# =============================================================================
# Types.jl: the endpoint models. Each model holds the data for one FRED endpoint.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #
"""
    AbstractFredEndpointModel

Abstract base type for all FRED (Federal Reserve Economic Data) API endpoint models.
Each subtype represents one endpoint of the API and holds the data needed to call it.
"""
abstract type AbstractFredEndpointModel end

# --- SERIES ENDPOINTS ----------------------------------------------------------------------------------------- #

"""
    mutable struct MyFredSeriesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series.html.
This endpoint returns the description of one economic data series: its title, units, frequency, seasonal adjustment, and date range.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_id::String`: the identifier of the series, e.g., `"GNPCA"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredSeriesEndpointModel(; apikey::String = "", series_id::String = "", realtime_start::String = "", realtime_end::String
  = "")`: returns a new `MyFredSeriesEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredSeriesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_id::String
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredSeriesEndpointModel(;
        apikey::String = "",
        series_id::String = "",
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, series_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredSeriesCategoriesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/categories` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_categories.html.
This endpoint returns the categories that hold one economic data series.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_id::String`: the identifier of the series, e.g., `"EXJPUS"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredSeriesCategoriesEndpointModel(; apikey::String = "", series_id::String = "", realtime_start::String = "",
  realtime_end::String = "")`: returns a new `MyFredSeriesCategoriesEndpointModel` instance. Every argument is a keyword
  argument.
"""
mutable struct MyFredSeriesCategoriesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_id::String
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredSeriesCategoriesEndpointModel(;
        apikey::String = "",
        series_id::String = "",
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, series_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredSeriesObservationsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/observations` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_observations.html.
This endpoint returns the observations (the data values) of one economic data series.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_id::String`: the identifier of the series, e.g., `"DHHNGSP"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of observations to return, between `1` and `100000`. When the field is `0`, FRED uses
  `100000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.
- `observation_start::String`: the first observation date that we want, written as `"YYYY-MM-DD"`. When the field is empty,
  FRED uses `"1776-07-04"`, the earliest date that FRED allows.
- `observation_end::String`: the last observation date that we want, written as `"YYYY-MM-DD"`. When the field is empty, FRED
  uses `"9999-12-31"`, the latest date that FRED allows.
- `units::String`: the transformation that FRED applies to the observations: `"lin"` (levels, no transformation), `"chg"`
  (change), `"ch1"` (change from a year ago), `"pch"` (percent change), `"pc1"` (percent change from a year ago), `"pca"`
  (compounded annual rate of change), `"cch"` (continuously compounded rate of change), `"cca"` (continuously compounded
  annual rate of change), or `"log"` (natural log). When the field is empty, FRED uses `"lin"`.
- `frequency::String`: the frequency of the observations that FRED returns: `"d"` (daily), `"w"` (weekly), `"bw"` (biweekly),
  `"m"` (monthly), `"q"` (quarterly), `"sa"` (semiannual), or `"a"` (annual). FRED also accepts the weekly variants, e.g.,
  `"wef"` (weekly, ending Friday). FRED aggregates the observations to a lower frequency using the `aggregation_method`
  field, and returns an error when the frequency is higher than the frequency of the series. When the field is empty, FRED
  returns the observations at the frequency of the series.
- `aggregation_method::String`: the way that FRED combines the observations when it lowers the frequency: `"avg"` (average),
  `"sum"` (sum), or `"eop"` (end of period). When the field is empty, FRED uses `"avg"`.
- `output_type::Int64`: the layout of the observations: `1` (the observations for each real-time period), `2` (all the
  observations for each vintage date), `3` (the new and the revised observations for each vintage date), or `4` (the initial
  release of the observations only). FRED allows `2`, `3`, and `4` only for series that have vintage dates. When the field is
  `0`, FRED uses `1`.
- `vintage_dates::String`: the vintage dates to return, written as comma-separated `"YYYY-MM-DD"` dates, e.g.,
  `"2024-01-01,2024-06-01"`. FRED returns the data as it stood on each date. When the field is empty, FRED does not select by
  vintage date.

### Constructors
- `MyFredSeriesObservationsEndpointModel(; apikey::String = "", series_id::String = "", realtime_start::String = "",
  realtime_end::String = "", limit::Int64 = 0, offset::Int64 = 0, sort_order::String = "", observation_start::String = "",
  observation_end::String = "", units::String = "", frequency::String = "", aggregation_method::String = "",
  output_type::Int64 = 0, vintage_dates::String = "")`: returns a new `MyFredSeriesObservationsEndpointModel` instance. Every
  argument is a keyword argument.
"""
mutable struct MyFredSeriesObservationsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_id::String
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    sort_order::String
    observation_start::String
    observation_end::String
    units::String
    frequency::String
    aggregation_method::String
    output_type::Int64
    vintage_dates::String

    # methods -
    MyFredSeriesObservationsEndpointModel(;
        apikey::String = "",
        series_id::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        sort_order::String = "",
        observation_start::String = "",
        observation_end::String = "",
        units::String = "",
        frequency::String = "",
        aggregation_method::String = "",
        output_type::Int64 = 0,
        vintage_dates::String = "") = new(
            apikey, series_id, realtime_start, realtime_end, limit, offset, sort_order, observation_start, observation_end, units, frequency, aggregation_method, output_type, vintage_dates);
end

"""
    mutable struct MyFredSeriesReleaseEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/release` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_release.html.
This endpoint returns the release that publishes one economic data series.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_id::String`: the identifier of the series, e.g., `"IRA"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredSeriesReleaseEndpointModel(; apikey::String = "", series_id::String = "", realtime_start::String = "",
  realtime_end::String = "")`: returns a new `MyFredSeriesReleaseEndpointModel` instance. Every argument is a keyword
  argument.
"""
mutable struct MyFredSeriesReleaseEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_id::String
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredSeriesReleaseEndpointModel(;
        apikey::String = "",
        series_id::String = "",
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, series_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredSeriesSearchEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/search` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_search.html.
This endpoint returns the economic data series that match a search text.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `search_text::String`: the words to search for, e.g., `"natural gas"`. FRED requires this field. The search text can hold
  spaces and other characters, because `url` encodes them.
- `search_type::String`: what the search text matches: `"full_text"` (the words of the series title, units, and tags) or
  `"series_id"` (the series identifiers). When the field is empty, FRED uses `"full_text"`.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of series to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"search_rank"`, `"series_id"`, `"title"`, `"units"`,
  `"frequency"`, `"seasonal_adjustment"`, `"realtime_start"`, `"realtime_end"`, `"last_updated"`, `"observation_start"`,
  `"observation_end"`, `"popularity"`, or `"group_popularity"`. When the field is empty, FRED uses `"search_rank"` for a full
  text search and `"series_id"` for a series identifier search.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.
- `filter_variable::String`: the attribute of a series to filter the results by: `"frequency"`, `"units"`, or
  `"seasonal_adjustment"`. Set this field together with `filter_value`. When the field is empty, FRED does not filter.
- `filter_value::String`: the value of the `filter_variable` attribute to keep, e.g., `"Monthly"` for the frequency or
  `"Percent"` for the units. Set this field together with `filter_variable`. When the field is empty, FRED does not filter.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"30-year;frb"`. When the
  field is empty, FRED does not select by tag.
- `exclude_tag_names::String`: the tag names that a series must not have, separated by semicolons. Set this field together
  with `tag_names`. When the field is empty, FRED does not exclude by tag.

### Constructors
- `MyFredSeriesSearchEndpointModel(; apikey::String = "", search_text::String = "", search_type::String = "",
  realtime_start::String = "", realtime_end::String = "", limit::Int64 = 0, offset::Int64 = 0, order_by::String = "",
  sort_order::String = "", filter_variable::String = "", filter_value::String = "", tag_names::String = "",
  exclude_tag_names::String = "")`: returns a new `MyFredSeriesSearchEndpointModel` instance. Every argument is a keyword
  argument.
"""
mutable struct MyFredSeriesSearchEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    search_text::String
    search_type::String
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String
    filter_variable::String
    filter_value::String
    tag_names::String
    exclude_tag_names::String

    # methods -
    MyFredSeriesSearchEndpointModel(;
        apikey::String = "",
        search_text::String = "",
        search_type::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "",
        filter_variable::String = "",
        filter_value::String = "",
        tag_names::String = "",
        exclude_tag_names::String = "") = new(
            apikey, search_text, search_type, realtime_start, realtime_end, limit, offset, order_by, sort_order, filter_variable, filter_value, tag_names, exclude_tag_names);
end

"""
    mutable struct MyFredSeriesSearchTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/search/tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_search_tags.html.
This endpoint returns the tags of the series that match a search text.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_search_text::String`: the words that select the series, e.g., `"monetary service index"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"30-year;frb"`. When the
  field is empty, FRED does not select by tag.
- `tag_group_id::String`: the group of tags to return: `"freq"` (frequency), `"gen"` (general or concept), `"geo"`
  (geography), `"geot"` (geography type), `"rls"` (release), `"seas"` (seasonal adjustment), or `"src"` (source). When the
  field is empty, FRED returns the tags of every group.
- `tag_search_text::String`: the words to match against the tag names and the tag notes. When the field is empty, FRED does
  not filter the tags by text.
- `limit::Int64`: the largest number of tags to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredSeriesSearchTagsEndpointModel(; apikey::String = "", series_search_text::String = "", realtime_start::String = "",
  realtime_end::String = "", tag_names::String = "", tag_group_id::String = "", tag_search_text::String = "", limit::Int64 =
  0, offset::Int64 = 0, order_by::String = "", sort_order::String = "")`: returns a new `MyFredSeriesSearchTagsEndpointModel`
  instance. Every argument is a keyword argument.
"""
mutable struct MyFredSeriesSearchTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_search_text::String
    realtime_start::String
    realtime_end::String
    tag_names::String
    tag_group_id::String
    tag_search_text::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredSeriesSearchTagsEndpointModel(;
        apikey::String = "",
        series_search_text::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        tag_names::String = "",
        tag_group_id::String = "",
        tag_search_text::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, series_search_text, realtime_start, realtime_end, tag_names, tag_group_id, tag_search_text, limit, offset, order_by, sort_order);
end

"""
    mutable struct MyFredSeriesSearchRelatedTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/search/related_tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_search_related_tags.html.
This endpoint returns the tags that are related to a set of tags, among the series that match a search text.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_search_text::String`: the words that select the series, e.g., `"monetary service index"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"30-year;frb"`. FRED
  requires this field. The returned tags are the tags that these series have in addition.
- `exclude_tag_names::String`: the tag names that a series must not have, separated by semicolons. Set this field together
  with `tag_names`. When the field is empty, FRED does not exclude by tag.
- `tag_group_id::String`: the group of tags to return: `"freq"` (frequency), `"gen"` (general or concept), `"geo"`
  (geography), `"geot"` (geography type), `"rls"` (release), `"seas"` (seasonal adjustment), or `"src"` (source). When the
  field is empty, FRED returns the tags of every group.
- `tag_search_text::String`: the words to match against the tag names and the tag notes. When the field is empty, FRED does
  not filter the tags by text.
- `limit::Int64`: the largest number of tags to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredSeriesSearchRelatedTagsEndpointModel(; apikey::String = "", series_search_text::String = "", realtime_start::String
  = "", realtime_end::String = "", tag_names::String = "", exclude_tag_names::String = "", tag_group_id::String = "",
  tag_search_text::String = "", limit::Int64 = 0, offset::Int64 = 0, order_by::String = "", sort_order::String = "")`:
  returns a new `MyFredSeriesSearchRelatedTagsEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredSeriesSearchRelatedTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_search_text::String
    realtime_start::String
    realtime_end::String
    tag_names::String
    exclude_tag_names::String
    tag_group_id::String
    tag_search_text::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredSeriesSearchRelatedTagsEndpointModel(;
        apikey::String = "",
        series_search_text::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        tag_names::String = "",
        exclude_tag_names::String = "",
        tag_group_id::String = "",
        tag_search_text::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, series_search_text, realtime_start, realtime_end, tag_names, exclude_tag_names, tag_group_id, tag_search_text, limit, offset, order_by, sort_order);
end

"""
    mutable struct MyFredSeriesTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_tags.html.
This endpoint returns the tags of one economic data series.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_id::String`: the identifier of the series, e.g., `"STLFSI"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredSeriesTagsEndpointModel(; apikey::String = "", series_id::String = "", realtime_start::String = "",
  realtime_end::String = "", order_by::String = "", sort_order::String = "")`: returns a new `MyFredSeriesTagsEndpointModel`
  instance. Every argument is a keyword argument.
"""
mutable struct MyFredSeriesTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_id::String
    realtime_start::String
    realtime_end::String
    order_by::String
    sort_order::String

    # methods -
    MyFredSeriesTagsEndpointModel(;
        apikey::String = "",
        series_id::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, series_id, realtime_start, realtime_end, order_by, sort_order);
end

"""
    mutable struct MyFredSeriesUpdatesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/updates` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_updates.html.
This endpoint returns the economic data series, sorted by the time that FRED last updated them, most recent first.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of series to return, between `1` and `100`. When the field is `0`, FRED uses `100`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `filter_value::String`: the kind of series to return: `"macro"` (macroeconomic series), `"regional"` (regional series), or
  `"all"`. When the field is empty, FRED uses `"all"`.
- `start_time::String`: the start of the time window for the last update of a series, written as `"YYYYMMDDHhmm"` (year,
  month, day, hour, minute) in US Eastern time. FRED requires `end_time` when this field is set. When the field is empty,
  FRED does not filter by time.
- `end_time::String`: the end of the time window for the last update of a series, written as `"YYYYMMDDHhmm"` (year, month,
  day, hour, minute) in US Eastern time. FRED requires `start_time` when this field is set. When the field is empty, FRED
  does not filter by time.

### Constructors
- `MyFredSeriesUpdatesEndpointModel(; apikey::String = "", realtime_start::String = "", realtime_end::String = "",
  limit::Int64 = 0, offset::Int64 = 0, filter_value::String = "", start_time::String = "", end_time::String = "")`: returns a
  new `MyFredSeriesUpdatesEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredSeriesUpdatesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    filter_value::String
    start_time::String
    end_time::String

    # methods -
    MyFredSeriesUpdatesEndpointModel(;
        apikey::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        filter_value::String = "",
        start_time::String = "",
        end_time::String = "") = new(
            apikey, realtime_start, realtime_end, limit, offset, filter_value, start_time, end_time);
end

"""
    mutable struct MyFredSeriesVintageDatesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/series/vintagedates` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/series_vintagedates.html.
This endpoint returns the dates on which FRED revised the data of one economic data series, or added data to it.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `series_id::String`: the identifier of the series, e.g., `"GNPCA"`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of vintage dates to return, between `1` and `10000`. When the field is `0`, FRED uses
  `10000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredSeriesVintageDatesEndpointModel(; apikey::String = "", series_id::String = "", realtime_start::String = "",
  realtime_end::String = "", limit::Int64 = 0, offset::Int64 = 0, sort_order::String = "")`: returns a new
  `MyFredSeriesVintageDatesEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredSeriesVintageDatesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    series_id::String
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    sort_order::String

    # methods -
    MyFredSeriesVintageDatesEndpointModel(;
        apikey::String = "",
        series_id::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        sort_order::String = "") = new(
            apikey, series_id, realtime_start, realtime_end, limit, offset, sort_order);
end
