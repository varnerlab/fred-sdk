# test_maps_v2.jl: tests for the models and the url methods of the maps endpoints and the version 2 endpoint -

# every field of a new model is at its empty value, and the model is a subtype of the abstract type -
for T in [MyFredMapsShapesEndpointModel, MyFredMapsSeriesGroupEndpointModel, MyFredMapsSeriesDataEndpointModel, MyFredMapsRegionalDataEndpointModel, MyFredV2ReleaseObservationsEndpointModel]
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

# MyFredMapsShapesEndpointModel: the URL ends with the API key, because this endpoint takes no format parameter -
let
    model = MyFredMapsShapesEndpointModel(apikey = KEY, shape = "state");
    @test url(BASE, model) == BASE * "/geofred/shapes/file?shape=state&api_key=" * KEY
    model = MyFredMapsShapesEndpointModel(apikey = KEY, shape = "shape");
    @test url(BASE, model) == BASE * "/geofred/shapes/file?shape=shape&api_key=" * KEY
end

# MyFredMapsSeriesGroupEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredMapsSeriesGroupEndpointModel(apikey = KEY, series_id = "SMU56000000500000001a");
    @test url(BASE, model) == BASE * "/geofred/series/group?series_id=SMU56000000500000001a&api_key=" * KEY * "&file_type=json"
    model = MyFredMapsSeriesGroupEndpointModel(apikey = KEY, series_id = "series_id");
    @test url(BASE, model) == BASE * "/geofred/series/group?series_id=series_id&api_key=" * KEY * "&file_type=json"
end

# MyFredMapsSeriesDataEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredMapsSeriesDataEndpointModel(apikey = KEY, series_id = "WIPCPI", date = "2012-01-01");
    @test url(BASE, model) == BASE * "/geofred/series/data?series_id=WIPCPI&date=2012-01-01&api_key=" * KEY * "&file_type=json"
    model = MyFredMapsSeriesDataEndpointModel(apikey = KEY, series_id = "series_id", date = "date", start_date = "start_date");
    @test url(BASE, model) == BASE * "/geofred/series/data?series_id=series_id&date=date&start_date=start_date&api_key=" * KEY * "&file_type=json"
end

# MyFredMapsRegionalDataEndpointModel: the URL with only the required fields, and the URL with every field -
let
    model = MyFredMapsRegionalDataEndpointModel(apikey = KEY, series_group = "882", region_type = "state", date = "2013-01-01", season = "NSA", units = "Dollars", frequency = "a");
    @test url(BASE, model) == BASE * "/geofred/regional/data?series_group=882&region_type=state&date=2013-01-01&season=NSA&units=Dollars&frequency=a&api_key=" * KEY * "&file_type=json"
    model = MyFredMapsRegionalDataEndpointModel(apikey = KEY, series_group = "series_group", region_type = "region_type", date = "date", start_date = "start_date", season = "season", units = "units", transformation = "transformation", frequency = "frequency", aggregation_method = "aggregation_method");
    @test url(BASE, model) == BASE * "/geofred/regional/data?series_group=series_group&region_type=region_type&date=date&start_date=start_date&season=season&units=units&transformation=transformation&frequency=frequency&aggregation_method=aggregation_method&api_key=" * KEY * "&file_type=json"
end

# MyFredV2ReleaseObservationsEndpointModel: the URL ends with format=json, in place of file_type=json -
let
    model = MyFredV2ReleaseObservationsEndpointModel(apikey = KEY, release_id = 52, limit = 10);
    @test url(BASE, model) == BASE * "/fred/v2/release/observations?release_id=52&limit=10&api_key=" * KEY * "&format=json"
    model = MyFredV2ReleaseObservationsEndpointModel(apikey = KEY, release_id = 7, limit = 7, next_cursor = "next_cursor");
    @test url(BASE, model) == BASE * "/fred/v2/release/observations?release_id=7&limit=7&next_cursor=next_cursor&api_key=" * KEY * "&format=json"
end
