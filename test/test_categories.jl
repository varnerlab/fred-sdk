# test_categories.jl: tests for the models and the url methods of the categories endpoints -

# every field of a new model is at its empty value, and the model is a subtype of the abstract type -
for T in [MyFredCategoryEndpointModel, MyFredCategoryChildrenEndpointModel, MyFredCategoryRelatedEndpointModel, MyFredCategorySeriesEndpointModel, MyFredCategoryTagsEndpointModel, MyFredCategoryRelatedTagsEndpointModel]
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

# MyFredCategoryEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredCategoryEndpointModel(apikey = KEY, category_id = 125);
    @test url(BASE, model) == BASE * "/fred/category?category_id=125&api_key=" * KEY * "&file_type=json"
    model = MyFredCategoryEndpointModel(apikey = KEY, category_id = 7);
    @test url(BASE, model) == BASE * "/fred/category?category_id=7&api_key=" * KEY * "&file_type=json"
end

# MyFredCategoryChildrenEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredCategoryChildrenEndpointModel(apikey = KEY, category_id = 13);
    @test url(BASE, model) == BASE * "/fred/category/children?category_id=13&api_key=" * KEY * "&file_type=json"
    model = MyFredCategoryChildrenEndpointModel(apikey = KEY, category_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/category/children?category_id=7&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredCategoryRelatedEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredCategoryRelatedEndpointModel(apikey = KEY, category_id = 32073);
    @test url(BASE, model) == BASE * "/fred/category/related?category_id=32073&api_key=" * KEY * "&file_type=json"
    model = MyFredCategoryRelatedEndpointModel(apikey = KEY, category_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end");
    @test url(BASE, model) == BASE * "/fred/category/related?category_id=7&realtime_start=realtime_start&realtime_end=realtime_end&api_key=" * KEY * "&file_type=json"
end

# MyFredCategorySeriesEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredCategorySeriesEndpointModel(apikey = KEY, category_id = 125, limit = 3);
    @test url(BASE, model) == BASE * "/fred/category/series?category_id=125&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredCategorySeriesEndpointModel(apikey = KEY, category_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order", filter_variable = "filter_variable", filter_value = "filter_value", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names");
    @test url(BASE, model) == BASE * "/fred/category/series?category_id=7&realtime_start=realtime_start&realtime_end=realtime_end&limit=7&offset=7&order_by=order_by&sort_order=sort_order&filter_variable=filter_variable&filter_value=filter_value&tag_names=tag_names&exclude_tag_names=exclude_tag_names&api_key=" * KEY * "&file_type=json"
end

# MyFredCategoryTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredCategoryTagsEndpointModel(apikey = KEY, category_id = 125, limit = 3);
    @test url(BASE, model) == BASE * "/fred/category/tags?category_id=125&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredCategoryTagsEndpointModel(apikey = KEY, category_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", tag_group_id = "tag_group_id", search_text = "search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/category/tags?category_id=7&realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&tag_group_id=tag_group_id&search_text=search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end

# MyFredCategoryRelatedTagsEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredCategoryRelatedTagsEndpointModel(apikey = KEY, category_id = 125, tag_names = "services;quarterly", limit = 3);
    @test url(BASE, model) == BASE * "/fred/category/related_tags?category_id=125&tag_names=services%3Bquarterly&limit=3&api_key=" * KEY * "&file_type=json"
    model = MyFredCategoryRelatedTagsEndpointModel(apikey = KEY, category_id = 7, realtime_start = "realtime_start", realtime_end = "realtime_end", tag_names = "tag_names", exclude_tag_names = "exclude_tag_names", tag_group_id = "tag_group_id", search_text = "search_text", limit = 7, offset = 7, order_by = "order_by", sort_order = "sort_order");
    @test url(BASE, model) == BASE * "/fred/category/related_tags?category_id=7&realtime_start=realtime_start&realtime_end=realtime_end&tag_names=tag_names&exclude_tag_names=exclude_tag_names&tag_group_id=tag_group_id&search_text=search_text&limit=7&offset=7&order_by=order_by&sort_order=sort_order&api_key=" * KEY * "&file_type=json"
end
