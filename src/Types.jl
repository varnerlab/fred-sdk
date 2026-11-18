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
- `sort_order::String`: the order of the observations by observation date: `"asc"` (ascending) or `"desc"` (descending). When
  the field is empty, FRED uses `"asc"`.
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
  `"sum"` (sum), or `"eop"` (end of period). FRED uses this field only when `frequency` is set. When the field is empty, FRED
  uses `"avg"`.
- `output_type::Int64`: the layout of the observations: `1` (the observations for each real-time period), `2` (all the
  observations for each vintage date), `3` (the new and the revised observations for each vintage date), or `4` (the initial
  release of the observations only). When the field is `0`, FRED uses `1`.
- `vintage_dates::String`: the vintage dates to return, written as comma-separated `"YYYY-MM-DD"` dates, e.g.,
  `"2024-01-01,2024-06-01"`. FRED uses these dates in place of `realtime_start` and `realtime_end`. When the field is empty,
  FRED does not select by vintage date.

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
  `"observation_end"`, `"popularity"`, or `"group_popularity"`. When the field is empty, FRED uses `"search_rank"` when
  `search_type` is `"full_text"` and `"series_id"` when `search_type` is `"series_id"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"desc"` if `order_by` is `"search_rank"` or `"popularity"`, and `"asc"` otherwise.
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
- `limit::Int64`: the largest number of series to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `filter_value::String`: the kind of series to return: `"macro"` (macroeconomic series), `"regional"` (regional series), or
  `"all"`. When the field is empty, FRED uses `"all"`.
- `start_time::String`: the start of the time window for the last update of a series, written as `"YYYYMMDDHhmm"` (year,
  month, day, hour, minute). FRED requires `end_time` when this field is set. When the field is empty, FRED does not filter
  by time.
- `end_time::String`: the end of the time window for the last update of a series, written as `"YYYYMMDDHhmm"` (year, month,
  day, hour, minute). FRED requires `start_time` when this field is set. When the field is empty, FRED does not filter by
  time.

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
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses
  `"1776-07-04"`.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  `"9999-12-31"`.
- `limit::Int64`: the largest number of vintage dates to return, between `1` and `10000`. When the field is `0`, FRED uses
  `10000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `sort_order::String`: the order of the vintage dates: `"asc"` (ascending) or `"desc"` (descending). When the field is
  empty, FRED uses `"asc"`.

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

# --- CATEGORIES ENDPOINTS ------------------------------------------------------------------------------------- #

"""
    mutable struct MyFredCategoryEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/category` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/category.html.
This endpoint returns one category: its identifier, name, and parent category.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `category_id::Int64`: the identifier of the category, e.g., `125`. `0` is the root category of FRED. When the field is `0`, FRED uses the root category, so leaving the field out gives the same result.

### Constructors
- `MyFredCategoryEndpointModel(; apikey::String = "", category_id::Int64 = 0)`: returns a new `MyFredCategoryEndpointModel`
  instance. Every argument is a keyword argument.
"""
mutable struct MyFredCategoryEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    category_id::Int64

    # methods -
    MyFredCategoryEndpointModel(;
        apikey::String = "",
        category_id::Int64 = 0) = new(
            apikey, category_id);
end

"""
    mutable struct MyFredCategoryChildrenEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/category/children` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/category_children.html.
This endpoint returns the child categories of one category.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `category_id::Int64`: the identifier of the category, e.g., `13`. `0` is the root category of FRED. When the field is `0`, FRED uses the root category, so leaving the field out gives the same result.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredCategoryChildrenEndpointModel(; apikey::String = "", category_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "")`: returns a new `MyFredCategoryChildrenEndpointModel` instance. Every argument is a keyword
  argument.
"""
mutable struct MyFredCategoryChildrenEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    category_id::Int64
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredCategoryChildrenEndpointModel(;
        apikey::String = "",
        category_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, category_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredCategoryRelatedEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/category/related` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/category_related.html.
This endpoint returns the categories that are related to one category. Most categories have no related categories.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `category_id::Int64`: the identifier of the category, e.g., `32073`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredCategoryRelatedEndpointModel(; apikey::String = "", category_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "")`: returns a new `MyFredCategoryRelatedEndpointModel` instance. Every argument is a keyword
  argument.
"""
mutable struct MyFredCategoryRelatedEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    category_id::Int64
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredCategoryRelatedEndpointModel(;
        apikey::String = "",
        category_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, category_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredCategorySeriesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/category/series` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/category_series.html.
This endpoint returns the economic data series that belong to one category.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `category_id::Int64`: the identifier of the category, e.g., `125`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of series to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_id"`, `"title"`, `"units"`, `"frequency"`,
  `"seasonal_adjustment"`, `"realtime_start"`, `"realtime_end"`, `"last_updated"`, `"observation_start"`,
  `"observation_end"`, `"popularity"`, or `"group_popularity"`. When the field is empty, FRED uses `"series_id"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.
- `filter_variable::String`: the attribute of a series to filter the results by: `"frequency"`, `"units"`, or
  `"seasonal_adjustment"`. Set this field together with `filter_value`. When the field is empty, FRED does not filter.
- `filter_value::String`: the value of the `filter_variable` attribute to keep, e.g., `"Monthly"` for the frequency or
  `"Percent"` for the units. Set this field together with `filter_variable`. When the field is empty, FRED does not filter.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"income;bea"`. When the
  field is empty, FRED does not select by tag.
- `exclude_tag_names::String`: the tag names that a series must not have, separated by semicolons. Set this field together
  with `tag_names`. When the field is empty, FRED does not exclude by tag.

### Constructors
- `MyFredCategorySeriesEndpointModel(; apikey::String = "", category_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", limit::Int64 = 0, offset::Int64 = 0, order_by::String = "", sort_order::String = "",
  filter_variable::String = "", filter_value::String = "", tag_names::String = "", exclude_tag_names::String = "")`: returns
  a new `MyFredCategorySeriesEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredCategorySeriesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    category_id::Int64
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
    MyFredCategorySeriesEndpointModel(;
        apikey::String = "",
        category_id::Int64 = 0,
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
            apikey, category_id, realtime_start, realtime_end, limit, offset, order_by, sort_order, filter_variable, filter_value, tag_names, exclude_tag_names);
end

"""
    mutable struct MyFredCategoryTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/category/tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/category_tags.html.
This endpoint returns the tags of the series that belong to one category.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `category_id::Int64`: the identifier of the category, e.g., `125`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"income;bea"`. When the
  field is empty, FRED does not select by tag.
- `tag_group_id::String`: the group of tags to return: `"freq"` (frequency), `"gen"` (general or concept), `"geo"`
  (geography), `"geot"` (geography type), `"rls"` (release), `"seas"` (seasonal adjustment), or `"src"` (source). When the
  field is empty, FRED returns the tags of every group.
- `search_text::String`: the words to match against the tag names and the tag notes. When the field is empty, FRED does
  not filter the tags by text.
- `limit::Int64`: the largest number of tags to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredCategoryTagsEndpointModel(; apikey::String = "", category_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", tag_names::String = "", tag_group_id::String = "", search_text::String = "", limit::Int64 = 0,
  offset::Int64 = 0, order_by::String = "", sort_order::String = "")`: returns a new `MyFredCategoryTagsEndpointModel`
  instance. Every argument is a keyword argument.
"""
mutable struct MyFredCategoryTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    category_id::Int64
    realtime_start::String
    realtime_end::String
    tag_names::String
    tag_group_id::String
    search_text::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredCategoryTagsEndpointModel(;
        apikey::String = "",
        category_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "",
        tag_names::String = "",
        tag_group_id::String = "",
        search_text::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, category_id, realtime_start, realtime_end, tag_names, tag_group_id, search_text, limit, offset, order_by, sort_order);
end

"""
    mutable struct MyFredCategoryRelatedTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/category/related_tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/category_related_tags.html.
This endpoint returns the tags that are related to a set of tags, among the series that belong to one category.
Every field is at its empty value by default. A field at its empty value (`""` or `0`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `category_id::Int64`: the identifier of the category, e.g., `125`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's
  date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"services;quarterly"`. FRED
  requires this field. The returned tags are the tags that these series have in addition.
- `exclude_tag_names::String`: the tag names that a series must not have, separated by semicolons. Set this field together
  with `tag_names`. When the field is empty, FRED does not exclude by tag.
- `tag_group_id::String`: the group of tags to return: `"freq"` (frequency), `"gen"` (general or concept), `"geo"`
  (geography), `"geot"` (geography type), `"rls"` (release), `"seas"` (seasonal adjustment), or `"src"` (source). When the
  field is empty, FRED returns the tags of every group.
- `search_text::String`: the words to match against the tag names and the tag notes. When the field is empty, FRED does
  not filter the tags by text.
- `limit::Int64`: the largest number of tags to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredCategoryRelatedTagsEndpointModel(; apikey::String = "", category_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", tag_names::String = "", exclude_tag_names::String = "", tag_group_id::String = "",
  search_text::String = "", limit::Int64 = 0, offset::Int64 = 0, order_by::String = "", sort_order::String = "")`: returns a
  new `MyFredCategoryRelatedTagsEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredCategoryRelatedTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    category_id::Int64
    realtime_start::String
    realtime_end::String
    tag_names::String
    exclude_tag_names::String
    tag_group_id::String
    search_text::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredCategoryRelatedTagsEndpointModel(;
        apikey::String = "",
        category_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "",
        tag_names::String = "",
        exclude_tag_names::String = "",
        tag_group_id::String = "",
        search_text::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, category_id, realtime_start, realtime_end, tag_names, exclude_tag_names, tag_group_id, search_text, limit, offset, order_by, sort_order);
end

# --- RELEASES ENDPOINTS --------------------------------------------------------------------------------------- #

"""
    mutable struct MyFredReleasesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/releases` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/releases.html.
This endpoint returns every release of economic data: its identifier, name, and whether FRED publishes a press release for it.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of releases to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"release_id"`, `"name"`, `"press_release"`, `"realtime_start"`, or
  `"realtime_end"`. When the field is empty, FRED uses `"release_id"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredReleasesEndpointModel(; apikey::String = "", realtime_start::String = "", realtime_end::String = "", limit::Int64 =
  0, offset::Int64 = 0, order_by::String = "", sort_order::String = "")`: returns a new `MyFredReleasesEndpointModel`
  instance. Every argument is a keyword argument.
"""
mutable struct MyFredReleasesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredReleasesEndpointModel(;
        apikey::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, realtime_start, realtime_end, limit, offset, order_by, sort_order);
end

"""
    mutable struct MyFredReleasesDatesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/releases/dates` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/releases_dates.html.
This endpoint returns the release dates of every release of economic data. Each record holds a release identifier, a release name, and a date.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the release dates that we see. When the field is empty, FRED uses the first day of the current year.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  `"9999-12-31"`.
- `limit::Int64`: the largest number of release dates to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"release_date"`, `"release_id"`, or `"release_name"`. When the
  field is empty, FRED uses `"release_date"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"desc"`.
- `include_release_dates_with_no_data::Bool`: whether to include the release dates that have no data. When the field
  is `false`, FRED leaves out those dates, and the parameter stays out of the URL.

### Constructors
- `MyFredReleasesDatesEndpointModel(; apikey::String = "", realtime_start::String = "", realtime_end::String = "",
  limit::Int64 = 0, offset::Int64 = 0, order_by::String = "", sort_order::String = "",
  include_release_dates_with_no_data::Bool = false)`: returns a new `MyFredReleasesDatesEndpointModel` instance. Every
  argument is a keyword argument.
"""
mutable struct MyFredReleasesDatesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String
    include_release_dates_with_no_data::Bool

    # methods -
    MyFredReleasesDatesEndpointModel(;
        apikey::String = "",
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "",
        include_release_dates_with_no_data::Bool = false) = new(
            apikey, realtime_start, realtime_end, limit, offset, order_by, sort_order, include_release_dates_with_no_data);
end

"""
    mutable struct MyFredReleaseEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release.html.
This endpoint returns one release of economic data: its identifier, name, and whether FRED publishes a press release for it.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `53`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredReleaseEndpointModel(; apikey::String = "", release_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "")`: returns a new `MyFredReleaseEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredReleaseEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredReleaseEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, release_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredReleaseDatesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release/dates` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release_dates.html.
This endpoint returns the release dates of one release of economic data. Each record holds a release identifier and a date.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `82`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the release dates that we see. When the field is empty, FRED uses `"1776-07-04"`.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  `"9999-12-31"`.
- `limit::Int64`: the largest number of release dates to return, between `1` and `10000`. When the field is `0`, FRED uses `10000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.
- `include_release_dates_with_no_data::Bool`: whether to include the release dates that have no data. When the field
  is `false`, FRED leaves out those dates, and the parameter stays out of the URL.

### Constructors
- `MyFredReleaseDatesEndpointModel(; apikey::String = "", release_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", limit::Int64 = 0, offset::Int64 = 0, sort_order::String = "",
  include_release_dates_with_no_data::Bool = false)`: returns a new `MyFredReleaseDatesEndpointModel` instance. Every
  argument is a keyword argument.
"""
mutable struct MyFredReleaseDatesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
    realtime_start::String
    realtime_end::String
    limit::Int64
    offset::Int64
    sort_order::String
    include_release_dates_with_no_data::Bool

    # methods -
    MyFredReleaseDatesEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        sort_order::String = "",
        include_release_dates_with_no_data::Bool = false) = new(
            apikey, release_id, realtime_start, realtime_end, limit, offset, sort_order, include_release_dates_with_no_data);
end

"""
    mutable struct MyFredReleaseSeriesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release/series` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release_series.html.
This endpoint returns the economic data series that belong to one release.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `51`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `limit::Int64`: the largest number of series to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_id"`, `"title"`, `"units"`, `"frequency"`,
  `"seasonal_adjustment"`, `"realtime_start"`, `"realtime_end"`, `"last_updated"`, `"observation_start"`,
  `"observation_end"`, `"popularity"`, or `"group_popularity"`. When the field is empty, FRED uses `"series_id"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.
- `filter_variable::String`: the attribute of a series to filter the results by: `"frequency"`, `"units"`, or
  `"seasonal_adjustment"`. Set this field together with `filter_value`. When the field is empty, FRED does not filter.
- `filter_value::String`: the value of the `filter_variable` attribute to keep, e.g., `"Monthly"` for the frequency or
  `"Percent"` for the units. Set this field together with `filter_variable`. When the field is empty, FRED does not filter.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"income;bea"`. When the
  field is empty, FRED does not select by tag.
- `exclude_tag_names::String`: the tag names that a series must not have, separated by semicolons. Set this field together
  with `tag_names`. When the field is empty, FRED does not exclude by tag.

### Constructors
- `MyFredReleaseSeriesEndpointModel(; apikey::String = "", release_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", limit::Int64 = 0, offset::Int64 = 0, order_by::String = "", sort_order::String = "",
  filter_variable::String = "", filter_value::String = "", tag_names::String = "", exclude_tag_names::String = "")`: returns
  a new `MyFredReleaseSeriesEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredReleaseSeriesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
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
    MyFredReleaseSeriesEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
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
            apikey, release_id, realtime_start, realtime_end, limit, offset, order_by, sort_order, filter_variable, filter_value, tag_names, exclude_tag_names);
end

"""
    mutable struct MyFredReleaseSourcesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release/sources` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release_sources.html.
This endpoint returns the sources of the data of one release. The results are not paged.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `51`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.

### Constructors
- `MyFredReleaseSourcesEndpointModel(; apikey::String = "", release_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "")`: returns a new `MyFredReleaseSourcesEndpointModel` instance. Every argument is a keyword
  argument.
"""
mutable struct MyFredReleaseSourcesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
    realtime_start::String
    realtime_end::String

    # methods -
    MyFredReleaseSourcesEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "") = new(
            apikey, release_id, realtime_start, realtime_end);
end

"""
    mutable struct MyFredReleaseTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release/tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release_tags.html.
This endpoint returns the tags of the series that belong to one release.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `86`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"income;bea"`. When the
  field is empty, FRED does not select by tag.
- `tag_group_id::String`: the group of tags to return: `"freq"` (frequency), `"gen"` (general or concept), `"geo"`
  (geography), `"geot"` (geography type), `"rls"` (release), `"seas"` (seasonal adjustment), or `"src"` (source). When the
  field is empty, FRED returns the tags of every group.
- `search_text::String`: the words to match against the tag names and the tag notes. When the field is empty, FRED does
  not filter the tags by text.
- `limit::Int64`: the largest number of tags to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredReleaseTagsEndpointModel(; apikey::String = "", release_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", tag_names::String = "", tag_group_id::String = "", search_text::String = "", limit::Int64 = 0,
  offset::Int64 = 0, order_by::String = "", sort_order::String = "")`: returns a new `MyFredReleaseTagsEndpointModel`
  instance. Every argument is a keyword argument.
"""
mutable struct MyFredReleaseTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
    realtime_start::String
    realtime_end::String
    tag_names::String
    tag_group_id::String
    search_text::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredReleaseTagsEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "",
        tag_names::String = "",
        tag_group_id::String = "",
        search_text::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, release_id, realtime_start, realtime_end, tag_names, tag_group_id, search_text, limit, offset, order_by, sort_order);
end

"""
    mutable struct MyFredReleaseRelatedTagsEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release/related_tags` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release_related_tags.html.
This endpoint returns the tags that are related to a set of tags, among the series that belong to one release.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `86`. FRED requires this field.
- `realtime_start::String`: the first day of the real-time period, written as `"YYYY-MM-DD"`. The real-time period selects
  the vintage of the data that we see, i.e., the data as it stood on those days. When the field is empty, FRED uses today's date.
- `realtime_end::String`: the last day of the real-time period, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  today's date.
- `tag_names::String`: the tag names that a series must all have, separated by semicolons, e.g., `"sa;foreign"`. FRED
  requires this field. The returned tags are the tags that these series have in addition.
- `exclude_tag_names::String`: the tag names that a series must not have, separated by semicolons. Set this field together
  with `tag_names`. When the field is empty, FRED does not exclude by tag.
- `tag_group_id::String`: the group of tags to return: `"freq"` (frequency), `"gen"` (general or concept), `"geo"`
  (geography), `"geot"` (geography type), `"rls"` (release), `"seas"` (seasonal adjustment), or `"src"` (source). When the
  field is empty, FRED returns the tags of every group.
- `search_text::String`: the words to match against the tag names and the tag notes. When the field is empty, FRED does
  not filter the tags by text.
- `limit::Int64`: the largest number of tags to return, between `1` and `1000`. When the field is `0`, FRED uses `1000`.
- `offset::Int64`: the number of results to skip, starting at `0`. When the field is `0`, FRED skips none.
- `order_by::String`: the attribute to sort the results by: `"series_count"`, `"popularity"`, `"created"`, `"name"`, or
  `"group_id"`. When the field is empty, FRED uses `"series_count"`.
- `sort_order::String`: the order of the results: `"asc"` (ascending) or `"desc"` (descending). When the field is empty, FRED
  uses `"asc"`.

### Constructors
- `MyFredReleaseRelatedTagsEndpointModel(; apikey::String = "", release_id::Int64 = 0, realtime_start::String = "",
  realtime_end::String = "", tag_names::String = "", exclude_tag_names::String = "", tag_group_id::String = "",
  search_text::String = "", limit::Int64 = 0, offset::Int64 = 0, order_by::String = "", sort_order::String = "")`: returns a
  new `MyFredReleaseRelatedTagsEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredReleaseRelatedTagsEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
    realtime_start::String
    realtime_end::String
    tag_names::String
    exclude_tag_names::String
    tag_group_id::String
    search_text::String
    limit::Int64
    offset::Int64
    order_by::String
    sort_order::String

    # methods -
    MyFredReleaseRelatedTagsEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
        realtime_start::String = "",
        realtime_end::String = "",
        tag_names::String = "",
        exclude_tag_names::String = "",
        tag_group_id::String = "",
        search_text::String = "",
        limit::Int64 = 0,
        offset::Int64 = 0,
        order_by::String = "",
        sort_order::String = "") = new(
            apikey, release_id, realtime_start, realtime_end, tag_names, exclude_tag_names, tag_group_id, search_text, limit, offset, order_by, sort_order);
end

"""
    mutable struct MyFredReleaseTablesEndpointModel <: AbstractFredEndpointModel

Endpoint model for the FRED `fred/release/tables` endpoint, described at https://fred.stlouisfed.org/docs/api/fred/release_tables.html.
This endpoint returns the elements of the table of one release. Each element is a section or a series of the table, and an element can have children. This endpoint takes no real-time parameters.
Every field is at its empty value by default. A field at its empty value (`""`, `0`, or `false`) stays out of the URL, so FRED applies its own default for that field.

### Fields
- `apikey::String`: the FRED API key of the client, a 32 character string of lowercase letters and digits.
- `release_id::Int64`: the identifier of the release, e.g., `53`. FRED requires this field.
- `element_id::Int64`: the identifier of the element of the table to start from, e.g., `12886`. When the field is `0`, FRED uses the
  root element of the release.
- `include_observation_values::Bool`: whether to include the observation values. FRED returns values only for the elements that
  are series. When the field is `false`, FRED leaves out the values, and the parameter stays out of the URL.
- `observation_date::String`: the date of the observation values, written as `"YYYY-MM-DD"`. When the field is empty, FRED uses
  `"9999-12-31"`, i.e., the latest observation.

### Constructors
- `MyFredReleaseTablesEndpointModel(; apikey::String = "", release_id::Int64 = 0, element_id::Int64 = 0,
  include_observation_values::Bool = false, observation_date::String = "")`: returns a new
  `MyFredReleaseTablesEndpointModel` instance. Every argument is a keyword argument.
"""
mutable struct MyFredReleaseTablesEndpointModel <: AbstractFredEndpointModel

    # data -
    apikey::String
    release_id::Int64
    element_id::Int64
    include_observation_values::Bool
    observation_date::String

    # methods -
    MyFredReleaseTablesEndpointModel(;
        apikey::String = "",
        release_id::Int64 = 0,
        element_id::Int64 = 0,
        include_observation_values::Bool = false,
        observation_date::String = "") = new(
            apikey, release_id, element_id, include_observation_values, observation_date);
end
