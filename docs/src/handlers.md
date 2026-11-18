# Handlers

A handler is a function that turns the response of FRED into a Julia object. `api` sends the request, calls the handler with the endpoint model type and the response body, a `String`, and returns what the handler returns.

## The default handler

When you call `api` without the `handler` keyword, the default handler parses the JSON text into a dictionary. Every endpoint works with the default handler. FRED names the list of series `"seriess"`, with a double s:

```julia
model = MyFredSeriesEndpointModel(apikey = apikey, series_id = "GNPCA");
result = api(MyFredSeriesEndpointModel, url(baseurl, model));
title = result["seriess"][1]["title"];
```

## Table handlers

A table handler returns a `DataFrame` with one row for each record of the response, such as each series or each tag. Each table handler reads one kind of record, so one table handler serves every endpoint that returns that kind of record. The response key is the key of the JSON text that holds the records. The `geofred/shapes/file` and `geofred/series/group` endpoints have no table handler.

| Handler | Response key | Endpoints |
|:--- |:--- |:--- |
| [`process_search_response_dataframe`](@ref) | `seriess` | `fred/series/search` |
| [`process_series_response_dataframe`](@ref) | `seriess` | `fred/series`, `fred/category/series`, `fred/release/series`, `fred/series/search`, `fred/series/updates`, `fred/tags/series` |
| [`process_observations_response_dataframe`](@ref) | `observations` | `fred/series/observations` |
| [`process_categories_response_dataframe`](@ref) | `categories` | `fred/category`, `fred/category/children`, `fred/category/related`, `fred/series/categories` |
| [`process_releases_response_dataframe`](@ref) | `releases` | `fred/releases`, `fred/release`, `fred/series/release`, `fred/source/releases` |
| [`process_release_dates_response_dataframe`](@ref) | `release_dates` | `fred/releases/dates`, `fred/release/dates` |
| [`process_sources_response_dataframe`](@ref) | `sources` | `fred/sources`, `fred/source`, `fred/release/sources` |
| [`process_tags_response_dataframe`](@ref) | `tags` | `fred/tags`, `fred/related_tags`, `fred/category/tags`, `fred/category/related_tags`, `fred/release/tags`, `fred/release/related_tags`, `fred/series/tags`, `fred/series/search/tags`, `fred/series/search/related_tags` |
| [`process_vintage_dates_response_dataframe`](@ref) | `vintage_dates` | `fred/series/vintagedates` |
| [`process_release_tables_response_dataframe`](@ref) | `elements` | `fred/release/tables` |
| [`process_maps_series_data_response_dataframe`](@ref) | `data`, inside `meta` | `geofred/series/data` |
| [`process_maps_regional_data_response_dataframe`](@ref) | `data`, inside `meta` | `geofred/regional/data` |
| [`process_release_observations_response_dataframe`](@ref) | `observations`, inside each entry of `series` | `fred/v2/release/observations` |

For a search, `process_search_response_dataframe` returns 6 columns, and `process_series_response_dataframe` returns 10 columns.

```@docs
process_search_response_dataframe
process_series_response_dataframe
process_observations_response_dataframe
process_categories_response_dataframe
process_releases_response_dataframe
process_release_dates_response_dataframe
process_sources_response_dataframe
process_tags_response_dataframe
process_vintage_dates_response_dataframe
process_release_tables_response_dataframe
process_maps_series_data_response_dataframe
process_maps_regional_data_response_dataframe
process_release_observations_response_dataframe
```

## Write your own handler

A handler takes the endpoint model type and the response body, and it can return any value. We'll write a handler that returns the title of each series in a list of series. The handler parses the JSON text with the JSON package, so add JSON to your environment first.

```julia
import JSON

"""
    process_titles_response(model::Type{T}, response::String)::Vector{String} where T <: AbstractFredEndpointModel

Return the title of each series in a FRED response that lists series.
"""
function process_titles_response(model::Type{T}, response::String)::Vector{String} where T <: AbstractFredEndpointModel

    # parse the JSON text into a dictionary -
    response_dict = JSON.parse(response);

    # collect the title of each series -
    titles = String[];
    for series in response_dict["seriess"]
        push!(titles, series["title"]);
    end

    # return the titles -
    return titles;
end
```

Pass your handler to `api` with the `handler` keyword:

```julia
model = MyFredSeriesSearchEndpointModel(apikey = apikey, search_text = "monetary service index", limit = 3);
titles = api(MyFredSeriesSearchEndpointModel, url(baseurl, model); handler = process_titles_response);
```
