# test_handlers.jl: tests for the table handlers of the version 1 lists -
import JSON
using DataFrames
using Dates

# the folder that holds the fixtures, and the endpoint model of each fixture -
fixtures_dir = joinpath(@__DIR__, "fixtures");
model_of = Dict{String,Any}();
for (name, model) in example_models(KEY)
    model_of[name] = typeof(model);
end

# each handler: its function, its response key, its column names, and the fixtures that it serves -
series_columns = [:id, :title, :frequency, :units, :seasonal_adjustment, :observation_start, :observation_end, :last_updated, :popularity, :notes];
tags_columns = [:name, :group_id, :notes, :created, :popularity, :series_count];
handlers = [
    (process_series_response_dataframe, "seriess", series_columns,
        ["fred_series", "fred_category_series", "fred_release_series", "fred_series_search", "fred_series_updates", "fred_tags_series"]),
    (process_categories_response_dataframe, "categories", [:id, :name, :parent_id, :notes],
        ["fred_category", "fred_category_children", "fred_category_related", "fred_series_categories"]),
    (process_releases_response_dataframe, "releases", [:id, :name, :press_release, :link, :notes],
        ["fred_releases", "fred_release", "fred_series_release", "fred_source_releases"]),
    (process_release_dates_response_dataframe, "release_dates", [:release_id, :release_name, :date],
        ["fred_releases_dates", "fred_release_dates"]),
    (process_sources_response_dataframe, "sources", [:id, :name, :link, :notes],
        ["fred_sources", "fred_source", "fred_release_sources"]),
    (process_tags_response_dataframe, "tags", tags_columns,
        ["fred_tags", "fred_related_tags", "fred_category_tags", "fred_category_related_tags", "fred_release_tags",
         "fred_release_related_tags", "fred_series_tags", "fred_series_search_tags", "fred_series_search_related_tags"]),
    (process_vintage_dates_response_dataframe, "vintage_dates", [:date], ["fred_series_vintagedates"]),
];

# the columns that the handlers convert to Date -
date_columns = [:observation_start, :observation_end, :date];

# the value that a handler should put in a column for a record: a Date for a date column, missing for an absent key or a null, otherwise the value as sent -
function expected_cell(record, column::Symbol)

    # a vintage date is a text value, not a record with keys -
    if (record isa String)
        return Date(record);
    end

    # an absent key or a null becomes missing -
    key = String(column);
    if (haskey(record, key) == false || isnothing(record[key]) == true)
        return missing;
    end

    # a date column becomes a Date -
    if (column in date_columns)
        return Date(record[key]);
    end

    # any other value, including an empty string, stays as sent -
    return record[key];
end

# the fixtures: the column names, the number of rows, and the first row, column by column -
for (handler, key, columns, fixtures) in handlers
    for name in fixtures
        raw = read(joinpath(fixtures_dir, name * ".json"), String);
        record_list = JSON.parse(raw)[key];
        frame = handler(model_of[name], raw);
        @test frame isa DataFrame
        @test Symbol.(names(frame)) == columns
        @test nrow(frame) == length(record_list)
        @test nrow(frame) > 0
        for column in columns
            @test isequal(frame[1, column], expected_cell(record_list[1], column))
        end
    end
end

# the first row of selected fixtures matches the first record -
body = read(joinpath(fixtures_dir, "fred_category_series.json"), String);
parsed = JSON.parse(body);
tbl = process_series_response_dataframe(MyFredCategorySeriesEndpointModel, body);
@test tbl.id[1] == parsed["seriess"][1]["id"]
@test tbl.title[1] == parsed["seriess"][1]["title"]
@test tbl.frequency[1] == parsed["seriess"][1]["frequency"]
@test tbl.units[1] == parsed["seriess"][1]["units"]
@test tbl.seasonal_adjustment[1] == parsed["seriess"][1]["seasonal_adjustment"]
@test tbl.observation_start[1] == Date(parsed["seriess"][1]["observation_start"])
@test tbl.observation_end[1] == Date(parsed["seriess"][1]["observation_end"])
@test tbl.last_updated[1] == parsed["seriess"][1]["last_updated"]
@test tbl.popularity[1] == parsed["seriess"][1]["popularity"]
@test tbl.notes[1] == parsed["seriess"][1]["notes"]

body = read(joinpath(fixtures_dir, "fred_category_children.json"), String);
parsed = JSON.parse(body);
tbl = process_categories_response_dataframe(MyFredCategoryChildrenEndpointModel, body);
@test tbl.id[1] == parsed["categories"][1]["id"]
@test tbl.name[1] == parsed["categories"][1]["name"]
@test tbl.parent_id[1] == parsed["categories"][1]["parent_id"]
@test ismissing(tbl.notes[1])

body = read(joinpath(fixtures_dir, "fred_releases.json"), String);
parsed = JSON.parse(body);
tbl = process_releases_response_dataframe(MyFredReleasesEndpointModel, body);
@test tbl.id[1] == parsed["releases"][1]["id"]
@test tbl.name[1] == parsed["releases"][1]["name"]
@test tbl.press_release[1] == parsed["releases"][1]["press_release"]
@test tbl.link[1] == parsed["releases"][1]["link"]
@test tbl.notes[1] == parsed["releases"][1]["notes"]

body = read(joinpath(fixtures_dir, "fred_releases_dates.json"), String);
parsed = JSON.parse(body);
tbl = process_release_dates_response_dataframe(MyFredReleasesDatesEndpointModel, body);
@test tbl.release_id[1] == parsed["release_dates"][1]["release_id"]
@test tbl.release_name[1] == parsed["release_dates"][1]["release_name"]
@test tbl.date[1] == Date(parsed["release_dates"][1]["date"])

body = read(joinpath(fixtures_dir, "fred_release_dates.json"), String);
tbl = process_release_dates_response_dataframe(MyFredReleaseDatesEndpointModel, body);
@test ismissing(tbl.release_name[1])

body = read(joinpath(fixtures_dir, "fred_sources.json"), String);
parsed = JSON.parse(body);
tbl = process_sources_response_dataframe(MyFredSourcesEndpointModel, body);
@test tbl.id[1] == parsed["sources"][1]["id"]
@test tbl.name[1] == parsed["sources"][1]["name"]
@test tbl.link[1] == parsed["sources"][1]["link"]
@test ismissing(tbl.notes[1])

body = read(joinpath(fixtures_dir, "fred_tags.json"), String);
parsed = JSON.parse(body);
tbl = process_tags_response_dataframe(MyFredTagsEndpointModel, body);
@test tbl.name[1] == parsed["tags"][1]["name"]
@test tbl.group_id[1] == parsed["tags"][1]["group_id"]
@test tbl.notes[1] == parsed["tags"][1]["notes"]
@test tbl.created[1] == parsed["tags"][1]["created"]
@test tbl.popularity[1] == parsed["tags"][1]["popularity"]
@test tbl.series_count[1] == parsed["tags"][1]["series_count"]

body = read(joinpath(fixtures_dir, "fred_series_vintagedates.json"), String);
parsed = JSON.parse(body);
tbl = process_vintage_dates_response_dataframe(MyFredSeriesVintageDatesEndpointModel, body);
@test tbl.date[1] == Date(parsed["vintage_dates"][1])

# the unchanged handlers still return their columns -
body = read(joinpath(fixtures_dir, "fred_series_search.json"), String);
parsed = JSON.parse(body);
tbl = process_search_response_dataframe(MyFredSeriesSearchEndpointModel, body);
@test Symbol.(names(tbl)) == [:id, :title, :frequency, :units, :observation_start, :observation_end]
@test nrow(tbl) == length(parsed["seriess"])
body = read(joinpath(fixtures_dir, "fred_series_observations.json"), String);
parsed = JSON.parse(body);
tbl = process_observations_response_dataframe(MyFredSeriesObservationsEndpointModel, body);
@test Symbol.(names(tbl)) == [:date, :value]
@test nrow(tbl) == length(parsed["observations"])
@test tbl.date[1] == Date(parsed["observations"][1]["date"])

# empty lists: no rows, the right column names, and the right column types -
for (handler, key, columns, fixtures) in handlers
    frame = handler(model_of[fixtures[1]], "{\"" * key * "\": []}");
    @test nrow(frame) == 0
    @test Symbol.(names(frame)) == columns
end
tbl = process_search_response_dataframe(MyFredSeriesSearchEndpointModel, "{\"seriess\": []}");
@test nrow(tbl) == 0
@test Symbol.(names(tbl)) == [:id, :title, :frequency, :units, :observation_start, :observation_end]
tbl = process_observations_response_dataframe(MyFredSeriesObservationsEndpointModel, "{\"observations\": []}");
@test nrow(tbl) == 0
@test Symbol.(names(tbl)) == [:date, :value]
tbl = process_series_response_dataframe(MyFredSeriesEndpointModel, "{\"seriess\": []}");
@test eltype(tbl.observation_start) == Date
@test eltype(tbl.popularity) == Union{Missing,Int64}
@test eltype(tbl.notes) == Union{Missing,String}
tbl = process_releases_response_dataframe(MyFredReleasesEndpointModel, "{\"releases\": []}");
@test eltype(tbl.press_release) == Bool

# absent fields and null fields become missing; an empty string stays an empty string -
tbl = process_sources_response_dataframe(MyFredSourcesEndpointModel, "{\"sources\": [{\"id\": 1, \"name\": \"A\"}]}");
@test ismissing(tbl.link[1])
@test ismissing(tbl.notes[1])
tag = "{\"tags\": [{\"name\": \"gdp\", \"group_id\": \"gen\", \"notes\": null, \"created\": \"2012-02-27 10:18:19-06\", \"popularity\": 1, \"series_count\": 2}," *
    "{\"name\": \"nsa\", \"group_id\": \"seas\", \"notes\": \"\", \"created\": \"2012-02-27 10:18:19-06\", \"popularity\": 3, \"series_count\": 4}]}";
tbl = process_tags_response_dataframe(MyFredTagsEndpointModel, tag);
@test ismissing(tbl.notes[1])
@test tbl.notes[2] == ""
tbl = process_series_response_dataframe(MyFredSeriesEndpointModel,
    "{\"seriess\": [{\"id\": \"A\", \"title\": \"T\", \"frequency\": \"Annual\", \"units\": \"U\", \"seasonal_adjustment\": \"NSA\", " *
    "\"observation_start\": \"2000-01-01\", \"observation_end\": \"2001-01-01\", \"last_updated\": \"2002-01-01 08:00:00-06\"}]}");
@test ismissing(tbl.popularity[1])
@test ismissing(tbl.notes[1])
tbl = process_release_dates_response_dataframe(MyFredReleaseDatesEndpointModel, "{\"release_dates\": [{\"release_id\": 9, \"date\": \"2025-01-02\"}]}");
@test ismissing(tbl.release_name[1])
@test tbl.date[1] == Date(2025, 1, 2)

# the "." value: missing; any other value: a Float64 -
body = "{\"observations\": [{\"date\": \"2025-01-01\", \"value\": \".\"}, {\"date\": \"2025-01-02\", \"value\": \"3.65\"}]}";
tbl = process_observations_response_dataframe(MyFredSeriesObservationsEndpointModel, body);
@test ismissing(tbl.value[1])
@test tbl.value[2] == 3.65
@test eltype(tbl.value) == Union{Missing,Float64}

# the private helpers -
@test ismissing(FredAPI._parse_value("."))
@test FredAPI._parse_value("3.65") == 3.65
@test FredAPI._value_or_missing(Dict{String,Any}("a" => 1), "a") == 1
@test ismissing(FredAPI._value_or_missing(Dict{String,Any}("a" => 1), "b"))
@test ismissing(FredAPI._value_or_missing(Dict{String,Any}("a" => nothing), "a"))
@test FredAPI._value_or_missing(Dict{String,Any}("a" => ""), "a") == ""
