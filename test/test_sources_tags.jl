# test_sources_tags.jl: tests for the models and the url methods of the sources and tags endpoints -

# every field of a new model is at its empty value, and the model is a subtype of the abstract type -
for T in [MyFredSourcesEndpointModel, MyFredSourceEndpointModel, MyFredSourceReleasesEndpointModel, MyFredTagsEndpointModel, MyFredRelatedTagsEndpointModel, MyFredTagsSeriesEndpointModel]
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

# MyFredSourcesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSourcesEndpointModel(apikey = KEY, limit = 3);
    @test url(BASE, model) == BASE * "/fred/sources?limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSourcesEndpointModel(apikey = KEY, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/sources?realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredSourceEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSourceEndpointModel(apikey = KEY, source_id = 1);
    @test url(BASE, model) == BASE * "/fred/source?source_id=1&api_key=" * KEY * "&file_type=json"
    model = MyFredSourceEndpointModel(apikey = KEY, source_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/source?source_id=7&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredSourceReleasesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredSourceReleasesEndpointModel(apikey = KEY, source_id = 1, limit = 3);
    @test url(BASE, model) == BASE * "/fred/source/releases?source_id=1&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredSourceReleasesEndpointModel(apikey = KEY, source_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/source/releases?source_id=7&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredTagsEndpointModel(apikey = KEY, limit = 3);
    @test url(BASE, model) == BASE * "/fred/tags?limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredTagsEndpointModel(apikey = KEY, realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", tag_group_id = "tag_group_id", search_text = "search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/tags?realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&tag_group_id=tag_group_id&search_text=search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredRelatedTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredRelatedTagsEndpointModel(apikey = KEY, tag_names = "monetary aggregates;weekly", limit = 3);
    @test url(BASE, model) == BASE * "/fred/related_tags?tag_names=monetary%20aggregates%3Bweekly&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredRelatedTagsEndpointModel(apikey = KEY, realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names", tag_group_id = "tag_group_id", search_text = "search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/related_tags?realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&exclude_tag_names=exclude_tag_names&tag_group_id=tag_group_id&search_text=search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredTagsSeriesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredTagsSeriesEndpointModel(apikey = KEY, tag_names = "slovenia;food", limit = 3);
    @test url(BASE, model) == BASE * "/fred/tags/series?tag_names=slovenia%3Bfood&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredTagsSeriesEndpointModel(apikey = KEY, tag_names = "tag_names", exclude_tag_names = "exclude_tag_names", realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/tags/series?tag_names=tag_names&exclude_tag_names=exclude_tag_names&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end
