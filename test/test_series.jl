# test_series.jl: tests for the models and the url methods of the series endpoints -

# every field of a new model is at its empty value, and the model is a subtype of the abstract type -
for T in [MyFredSeriesEndpointModel, MyFredSeriesCategoriesEndpointModel, MyFredSeriesObservationsEndpointModel, MyFredSeriesReleaseEndpointModel, MyFredSeriesSearchEndpointModel, MyFredSeriesSearchTagsEndpointModel, MyFredSeriesSearchRelatedTagsEndpointModel, MyFredSeriesTagsEndpointModel, MyFredSeriesUpdatesEndpointModel, MyFredSeriesVintageDatesEndpointModel]
    model = T();
    @test model isa AbstractFredEndpointModel
    for name in fieldnames(T)
        value = getfield(model, name);
        if (fieldtype(T, name) == String)
            @test value == ""
        elseif (fieldtype(T, name) == Int64)
            @test value == 0
        else
            @test value == false
        end
    end
end

# MyFredSeriesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesEndpointModel(apikey = KEY, series_id = "GNPCA");
    @test url(BASE, model) == BASE * "/fred/series?series_id=GNPCA&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesEndpointModel(apikey = KEY, series_id = "series_id", realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/series?series_id=series_id&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesCategoriesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesCategoriesEndpointModel(apikey = KEY, series_id = "EXJPUS");
    @test url(BASE, model) == BASE * "/fred/series/categories?series_id=EXJPUS&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesCategoriesEndpointModel(apikey = KEY, series_id = "series_id", realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/series/categories?series_id=series_id&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesObservationsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesObservationsEndpointModel(apikey = KEY, series_id = "DHHNGSP", observation_start = "2025-01-01", observation_end = "2025-01-10");
    @test url(BASE, model) == BASE * "/fred/series/observations?series_id=DHHNGSP&observation_start=2025-01-01&observation_end=2025-01-10&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesObservationsEndpointModel(apikey = KEY, series_id = "series_id", realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, sort_order = "sort_order", observation_start = "observation_start", observation_end = "observation_end", units = "units", frequency = "frequency", aggregation_method = "aggregation_method", output_type = 7, vintage_dates = "vintage_dates");
    @test url(BASE, model) == BASE * "/fred/series/observations?series_id=series_id&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&sort_order=sort_order&observation_start=observation_start&observation_end=observation_end&units=units&frequency=frequency&aggregation_method=aggregation_method&output_type=7&vintage_dates=vintage_dates&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesReleaseEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesReleaseEndpointModel(apikey = KEY, series_id = "IRA");
    @test url(BASE, model) == BASE * "/fred/series/release?series_id=IRA&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesReleaseEndpointModel(apikey = KEY, series_id = "series_id", realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/series/release?series_id=series_id&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesSearchEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesSearchEndpointModel(apikey = KEY, search_text = "monetary service index", limit = 3);
    @test url(BASE, model) == BASE * "/fred/series/search?search_text=monetary%20service%20index&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesSearchEndpointModel(apikey = KEY, search_text = "search_text", search_type = "search_type", realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order", filter_variable = "filter_variable", filter_value = "filter_value", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names");
    @test url(BASE, model) == BASE * "/fred/series/search?search_text=search_text&search_type=search_type&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&filter_variable=filter_variable&filter_value=filter_value&tag_names=tag_names&exclude_tag_names=exclude_tag_names&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesSearchTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesSearchTagsEndpointModel(apikey = KEY, series_search_text = "monetary service index", limit = 3);
    @test url(BASE, model) == BASE * "/fred/series/search/tags?series_search_text=monetary%20service%20index&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesSearchTagsEndpointModel(apikey = KEY, series_search_text = "series_search_text", realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", tag_group_id = "tag_group_id", tag_search_text = "tag_search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/series/search/tags?series_search_text=series_search_text&realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&tag_group_id=tag_group_id&tag_search_text=tag_search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesSearchRelatedTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesSearchRelatedTagsEndpointModel(apikey = KEY, series_search_text = "mortgage rate", tag_names = "30-year;frb", limit = 3);
    @test url(BASE, model) == BASE * "/fred/series/search/related_tags?series_search_text=mortgage%20rate&tag_names=30-year%3Bfrb&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesSearchRelatedTagsEndpointModel(apikey = KEY, series_search_text = "series_search_text", realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names", tag_group_id = "tag_group_id", tag_search_text = "tag_search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/series/search/related_tags?series_search_text=series_search_text&realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&exclude_tag_names=exclude_tag_names&tag_group_id=tag_group_id&tag_search_text=tag_search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesTagsEndpointModel(apikey = KEY, series_id = "STLFSI");
    @test url(BASE, model) == BASE * "/fred/series/tags?series_id=STLFSI&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesTagsEndpointModel(apikey = KEY, series_id = "series_id", realtime_start = "realtime_start", realtime_end = "realtime_end", order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/series/tags?series_id=series_id&realtime_start=realtime_start&realtime_end=realtime_end&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesUpdatesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesUpdatesEndpointModel(apikey = KEY, limit = 3);
    @test url(BASE, model) == BASE * "/fred/series/updates?limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesUpdatesEndpointModel(apikey = KEY, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, filter_value = "filter_value", start_time = "start_time", end_time = "end_time");
    @test url(BASE, model) == BASE * "/fred/series/updates?realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&filter_value=filter_value&start_time=start_time&end_time=end_time&api_key=" * KEY * "&file_type=json"
end

# MyFredSeriesVintageDatesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSeriesVintageDatesEndpointModel(apikey = KEY, series_id = "GNPCA", limit = 3);
    @test url(BASE, model) == BASE * "/fred/series/vintagedates?series_id=GNPCA&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSeriesVintageDatesEndpointModel(apikey = KEY, series_id = "series_id", realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/series/vintagedates?series_id=series_id&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# the search call of the reference design, with a space in the search text -
@test url(BASE, MyFredSeriesSearchEndpointModel(apikey = KEY, search_text = "natural gas", limit = 5)) ==
    BASE * "/fred/series/search?search_text=natural%20gas&limit=5&api_key=" * KEY * "&file_type=json"

# the observations model of the reference design builds a URL without error -
@test url(BASE, MyFredSeriesObservationsEndpointModel(apikey = KEY, series_id = "DHHNGSP", observation_start = "2025-01-01",
    observation_end = "2025-12-31", frequency = "m", units = "lin")) isa String
