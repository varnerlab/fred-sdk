# test_live.jl: live tests that call each of the 36 FRED endpoints. runtests.jl includes this file only when FRED_API_KEY is set -
using DataFrames

# the API key of the person who runs the tests -
live_key = ENV["FRED_API_KEY"];

# the table handler of each fixture name. An endpoint that is not in this dictionary has only the default handler -
table_handler_of = Dict{String,Function}();
for name in ["fred_series", "fred_category_series", "fred_release_series", "fred_series_search", "fred_series_updates", "fred_tags_series"]
    table_handler_of[name] = process_series_response_dataframe;
end
for name in ["fred_category", "fred_category_children", "fred_category_related", "fred_series_categories"]
    table_handler_of[name] = process_categories_response_dataframe;
end
for name in ["fred_releases", "fred_release", "fred_series_release", "fred_source_releases"]
    table_handler_of[name] = process_releases_response_dataframe;
end
for name in ["fred_releases_dates", "fred_release_dates"]
    table_handler_of[name] = process_release_dates_response_dataframe;
end
for name in ["fred_sources", "fred_source", "fred_release_sources"]
    table_handler_of[name] = process_sources_response_dataframe;
end
for name in ["fred_tags", "fred_related_tags", "fred_category_tags", "fred_category_related_tags", "fred_release_tags",
    "fred_release_related_tags", "fred_series_tags", "fred_series_search_tags", "fred_series_search_related_tags"]
    table_handler_of[name] = process_tags_response_dataframe;
end
table_handler_of["fred_series_observations"] = process_observations_response_dataframe;
table_handler_of["fred_series_vintagedates"] = process_vintage_dates_response_dataframe;
table_handler_of["fred_release_tables"] = process_release_tables_response_dataframe;
table_handler_of["geofred_series_data"] = process_maps_series_data_response_dataframe;
table_handler_of["geofred_regional_data"] = process_maps_regional_data_response_dataframe;
table_handler_of["fred_v2_release_observations"] = process_release_observations_response_dataframe;

# call each endpoint with the default handler, and with its table handler when it has one -
for (name, model) in example_models(live_key)

    # build the request URL. The URL holds the key, so we never print it -
    request_url = url(BASE, model);

    # the default handler returns a dictionary. JSON.jl 1 gives it as a JSON.Object, which is an AbstractDict -
    result = api(typeof(model), request_url);
    @test result isa AbstractDict
    sleep(0.5); # stay below the FRED limit of 120 requests per minute

    # the table handler returns a DataFrame -
    if (haskey(table_handler_of, name) == true)
        table = api(typeof(model), request_url; handler = table_handler_of[name]);
        @test table isa DataFrame
        sleep(0.5);
    end
end
