# test_releases.jl: tests for the models and the url methods of the releases endpoints -

# every field of a new model is at its empty value, and the model is a subtype of the abstract type -
for T in [MyFredReleasesEndpointModel, MyFredReleasesDatesEndpointModel, MyFredReleaseEndpointModel, MyFredReleaseDatesEndpointModel, MyFredReleaseSeriesEndpointModel, MyFredReleaseSourcesEndpointModel, MyFredReleaseTagsEndpointModel, MyFredReleaseRelatedTagsEndpointModel, MyFredReleaseTablesEndpointModel]
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

# MyFredReleasesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleasesEndpointModel(apikey = KEY, limit = 3);
    @test url(BASE, model) == BASE * "/fred/releases?limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredReleasesEndpointModel(apikey = KEY, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/releases?realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredReleasesDatesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleasesDatesEndpointModel(apikey = KEY, limit = 3);
    @test url(BASE, model) == BASE * "/fred/releases/dates?limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredReleasesDatesEndpointModel(apikey = KEY, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order", include_release_dates_with_no_data = true);
    @test url(BASE, model) == BASE * "/fred/releases/dates?realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&include_release_dates_with_no_data=true&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseEndpointModel(apikey = KEY, release_id = 53);
    @test url(BASE, model) == BASE * "/fred/release?release_id=53&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseEndpointModel(apikey = KEY, release_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/release?release_id=7&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseDatesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseDatesEndpointModel(apikey = KEY, release_id = 82, limit = 3);
    @test url(BASE, model) == BASE * "/fred/release/dates?release_id=82&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseDatesEndpointModel(apikey = KEY, release_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, sort_order = "sort_order", include_release_dates_with_no_data = true);
    @test url(BASE, model) == BASE * "/fred/release/dates?release_id=7&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&sort_order=sort_order&include_release_dates_with_no_data=true&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseSeriesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseSeriesEndpointModel(apikey = KEY, release_id = 51, limit = 3);
    @test url(BASE, model) == BASE * "/fred/release/series?release_id=51&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseSeriesEndpointModel(apikey = KEY, release_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order", filter_variable = "filter_variable", filter_value = "filter_value", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names");
    @test url(BASE, model) == BASE * "/fred/release/series?release_id=7&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&filter_variable=filter_variable&filter_value=filter_value&tag_names=tag_names&exclude_tag_names=exclude_tag_names&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseSourcesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseSourcesEndpointModel(apikey = KEY, release_id = 51);
    @test url(BASE, model) == BASE * "/fred/release/sources?release_id=51&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseSourcesEndpointModel(apikey = KEY, release_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/release/sources?release_id=7&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseTagsEndpointModel(apikey = KEY, release_id = 86, limit = 3);
    @test url(BASE, model) == BASE * "/fred/release/tags?release_id=86&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseTagsEndpointModel(apikey = KEY, release_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", tag_group_id = "tag_group_id", search_text = "search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/release/tags?release_id=7&realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&tag_group_id=tag_group_id&search_text=search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseRelatedTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseRelatedTagsEndpointModel(apikey = KEY, release_id = 86, tag_names = "sa;foreign", limit = 3);
    @test url(BASE, model) == BASE * "/fred/release/related_tags?release_id=86&tag_names=sa%3Bforeign&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseRelatedTagsEndpointModel(apikey = KEY, release_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names", tag_group_id = "tag_group_id", search_text = "search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/release/related_tags?release_id=7&realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&exclude_tag_names=exclude_tag_names&tag_group_id=tag_group_id&search_text=search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredReleaseTablesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredReleaseTablesEndpointModel(apikey = KEY, release_id = 53, element_id = 12886);
    @test url(BASE, model) == BASE * "/fred/release/tables?release_id=53&element_id=12886&api_key=" * KEY * "&file_type=json"
    model = MyFredReleaseTablesEndpointModel(apikey = KEY, release_id = 7, element_id = 7, include_observation_values = true, observation_date = "observation_date");
    @test url(BASE, model) == BASE * "/fred/release/tables?release_id=7&element_id=7&include_observation_values=true&observation_date=observation_date&api_key=" * KEY * "&file_type=json"
end
