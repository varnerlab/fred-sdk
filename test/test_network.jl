# test_network.jl: tests for api and the default handler, against the local mock server -
include("mock_server.jl")

# a handler that returns its two arguments -
function echo_handler(model::Type{T}, body::String) where T <: AbstractFredEndpointModel
    return (model, body);
end

# check that a call throws an ArgumentError with the given text, and that neither the message nor a chained cause shows the key -
function check_api_error(endpoint, request_url::String, expected::Vector{String})
    @test occursin("api_key=" * KEY, request_url) == true;
    caught = nothing;
    try
        api(endpoint, request_url);
    catch e
        caught = e;

        # the full display of the error stack must hold one error, and must not show the key -
        @test length(current_exceptions()) == 1;
        @test occursin(KEY, sprint(Base.display_error, current_exceptions())) == false;
    end
    @test caught isa ArgumentError;
    message = sprint(showerror, caught);
    for text in expected
        @test occursin(text, message) == true;
    end
    @test occursin(KEY, message) == false;
end

routes = Dict{String,Tuple{Int64,String}}(
    "/fred/series" => (200, "{\"seriess\": []}"),
    "/fred/releases" => (400, "{\"error_code\": 400, \"error_message\": \"Bad Request. The series does not exist.\"}"),
    "/fred/sources" => (503, "<html>Service Unavailable</html>"),
    "/fred/tags" => (500, ""),
    "/fred/category" => (400, "{\"error_message\": "),
    "/fred/v2/release/observations" => (200, "{\"observations\": []}")
);
(server, base) = start_mock_server(routes);

# a successful call returns the parsed JSON as a dictionary -
let
    request_url = url(base, MyFredSeriesEndpointModel(apikey = KEY, series_id = "GNPCA"));
    result = api(MyFredSeriesEndpointModel, request_url);
    @test result isa AbstractDict
    @test haskey(result, "seriess") == true
    @test result["seriess"] == []
end

# a custom handler receives the endpoint model type and the body -
let
    request_url = url(base, MyFredSeriesEndpointModel(apikey = KEY, series_id = "GNPCA"));
    result = api(MyFredSeriesEndpointModel, request_url; handler = echo_handler);
    @test result == (MyFredSeriesEndpointModel, "{\"seriess\": []}")
end

# each error case throws an ArgumentError with the status code, and never shows the key -
check_api_error(MyFredReleasesEndpointModel, url(base, MyFredReleasesEndpointModel(apikey = KEY)), ["400", "The series does not exist."]);
check_api_error(MyFredSourcesEndpointModel, url(base, MyFredSourcesEndpointModel(apikey = KEY)), ["503"]);
check_api_error(MyFredTagsEndpointModel, url(base, MyFredTagsEndpointModel(apikey = KEY)), ["500"]);
check_api_error(MyFredCategoryEndpointModel, url(base, MyFredCategoryEndpointModel(apikey = KEY, category_id = 1)), ["400"]);
check_api_error(MyFredSeriesEndpointModel, url("http://127.0.0.1:1", MyFredSeriesEndpointModel(apikey = KEY, series_id = "GNPCA")), ["could not connect"]);
check_api_error(MyFredSeriesEndpointModel, "ftp://127.0.0.1/fred/series?api_key=" * KEY, ["http://"]);

# a path that is not a route gets a 404 -
check_api_error(MyFredSeriesTagsEndpointModel, url(base, MyFredSeriesTagsEndpointModel(apikey = KEY, series_id = "GNPCA")), ["404"]);

# a failed status code is not retried: the server sees one request -
let
    empty!(MOCK_REQUEST_LOG);
    try
        api(MyFredTagsEndpointModel, url(base, MyFredTagsEndpointModel(apikey = KEY)));
    catch
    end
    @test length(MOCK_REQUEST_LOG) == 1
end

# a version 1 call sends no authorization header, and keeps the key in the URL -
let
    empty!(MOCK_REQUEST_LOG);
    api(MyFredSeriesEndpointModel, url(base, MyFredSeriesEndpointModel(apikey = KEY, series_id = "GNPCA")));
    @test length(MOCK_REQUEST_LOG) == 1
    @test haskey(MOCK_REQUEST_LOG[1], "authorization") == false
    @test occursin("api_key=" * KEY, MOCK_REQUEST_LOG[1]["request-target"]) == true
    @test MOCK_REQUEST_LOG[1]["user-agent"] == "FredAPI.jl"
    @test MOCK_REQUEST_LOG[1]["accept"] == "application/json"
end

# a version 2 call sends the key as a bearer token, and the request target has no api_key -
let
    empty!(MOCK_REQUEST_LOG);
    model = MyFredV2ReleaseObservationsEndpointModel(apikey = KEY, release_id = 52, limit = 10);
    result = api(MyFredV2ReleaseObservationsEndpointModel, url(base, model));
    @test result == Dict("observations" => [])
    @test length(MOCK_REQUEST_LOG) == 1
    @test MOCK_REQUEST_LOG[1]["authorization"] == "Bearer " * KEY
    @test occursin("api_key", MOCK_REQUEST_LOG[1]["request-target"]) == false
    @test occursin(KEY, MOCK_REQUEST_LOG[1]["request-target"]) == false
    @test occursin("release_id=52", MOCK_REQUEST_LOG[1]["request-target"]) == true
end

stop_mock_server(server);

# the default handler returns a dictionary for each of the 36 model types -
model_types = subtypes(AbstractFredEndpointModel);
@test length(model_types) == 36
for T in model_types
    @test FredAPI._default_handler_process_fred_response(T, "{}") isa AbstractDict
end
# a model type that has no entry in the default handler gets nothing -
struct MyUnknownTestEndpointModel <: AbstractFredEndpointModel end
@test isnothing(FredAPI._default_handler_process_fred_response(MyUnknownTestEndpointModel, "{}"))
