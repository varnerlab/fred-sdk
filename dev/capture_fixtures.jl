# =============================================================================
# capture_fixtures.jl: call each FRED endpoint once with its example model, trim the response, and save the
# trimmed response as a test fixture in test/fixtures. Run the script from the root of the repository:
#
#     julia --project=. dev/capture_fixtures.jl
#
# The script reads your FRED API key from the FRED_API_KEY environment variable when it is set,
# and from conf/Configuration.toml otherwise.
# =============================================================================
using FredAPI
import JSON

# load example_models: the example model of each endpoint, and the name of its fixture -
include(joinpath(@__DIR__, "..", "test", "example_models.jl"));

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #
"""
    _read_apikey() -> String

Private function that reads the FRED API key. It reads the `FRED_API_KEY` environment variable when it is set,
and the configuration file `conf/Configuration.toml` otherwise.

### Returns
- `String`: the FRED API key.

### Throws
- `ArgumentError`: when the environment variable is not set and `read_configuration` cannot read the configuration file.
"""
function _read_apikey()::String

    # use the key in the FRED_API_KEY environment variable, when it is set -
    if (haskey(ENV, "FRED_API_KEY") == true && isempty(ENV["FRED_API_KEY"]) == false)
        return ENV["FRED_API_KEY"];
    end

    # otherwise, read the key from the configuration file -
    connection = read_configuration(joinpath(@__DIR__, "..", "conf", "Configuration.toml"));
    return connection["apikey"];
end

"""
    _trim_lists(value::Any, count::Int64) -> Any

Private function that returns a copy of a parsed JSON value in which every list holds at most its first `count` records.
The function calls itself on each value inside a dictionary or a list, so it trims the lists at every depth.

### Arguments
- `value::Any`: a parsed JSON value: a dictionary, a list, text, a number, `true`, `false`, or `nothing`.
- `count::Int64`: the largest number of records that a list keeps.

### Returns
- The trimmed copy of `value`. A dictionary keeps the order of its keys.
"""
function _trim_lists(value::Any, count::Int64)::Any

    # a dictionary: trim the value of each key, and keep the order of the keys -
    if (isa(value, AbstractDict) == true)
        trimmed_dictionary = JSON.Object{String,Any}();
        for (key, item) in value
            trimmed_dictionary[key] = _trim_lists(item, count);
        end
        return trimmed_dictionary;
    end

    # a list: keep the first count records, and trim each record -
    if (isa(value, AbstractVector) == true)
        trimmed_list = Any[];
        for i in 1:min(count, length(value))
            push!(trimmed_list, _trim_lists(value[i], count));
        end
        return trimmed_list;
    end

    # any other value, e.g., text or a number, stays the same -
    return value;
end

"""
    _trim_coordinates(coordinates::Vector{Any}) -> Vector{Any}

Private function that keeps the first 3 points of the outline of a shape. A point is a list of two numbers, `[x, y]`.
A line or a ring is a list of points, a polygon is a list of rings, and a multipolygon is a list of polygons.
The function keeps the first item at each level above the points, and the first 3 points.

### Arguments
- `coordinates::Vector{Any}`: the `coordinates` list of the geometry of a feature.

### Returns
- `Vector{Any}`: the trimmed list, with the same number of levels as `coordinates`.
"""
function _trim_coordinates(coordinates::Vector{Any})::Vector{Any}

    # a list of points: its first item is a point, i.e., a list of numbers. Keep the first 3 points -
    if (isa(coordinates[1][1], Number) == true)
        return coordinates[1:min(3, length(coordinates))];
    end

    # a list of rings or polygons: keep the first item, and trim that item -
    first_item = _trim_coordinates(coordinates[1]);
    return Any[first_item];
end

"""
    _trim_response(model::AbstractFredEndpointModel, response::AbstractDict) -> AbstractDict

Private function that trims a parsed FRED response, so that the fixture stays small.
Every list keeps its first 3 records. The release tables keep 3 elements, the shapes keep 1 feature with the first 3 points
of its outline, and version 2 keeps 2 series with 3 observations each.

### Arguments
- `model::AbstractFredEndpointModel`: the example model of the endpoint that returned the response.
- `response::AbstractDict`: the parsed JSON response.

### Returns
- `AbstractDict`: the trimmed copy of the response.
"""
function _trim_response(model::AbstractFredEndpointModel, response::AbstractDict)::AbstractDict

    # trim every list to its first 3 records -
    trimmed = _trim_lists(response, 3);

    # release tables: the elements are a dictionary keyed by element id, not a list. Keep the first 3 elements -
    if (isa(model, MyFredReleaseTablesEndpointModel) == true)
        kept_elements = JSON.Object{String,Any}();
        for (element_id, element) in trimmed["elements"]
            if (length(kept_elements) < 3)
                kept_elements[element_id] = element;
            end
        end
        trimmed["elements"] = kept_elements;
    end

    # shapes: keep the first feature, and the first 3 points of its outline -
    if (isa(model, MyFredMapsShapesEndpointModel) == true)
        first_feature = trimmed["features"][1];
        first_feature["geometry"]["coordinates"] = _trim_coordinates(first_feature["geometry"]["coordinates"]);
        trimmed["features"] = Any[first_feature];
    end

    # version 2: keep the first 2 series. Each series already holds at most 3 observations -
    if (isa(model, MyFredV2ReleaseObservationsEndpointModel) == true)
        trimmed["series"] = trimmed["series"][1:min(2, length(trimmed["series"]))];
    end

    # return the trimmed response -
    return trimmed;
end
# --- PRIVATE METHODS ABOVE HERE ------------------------------------------------------------------------------- #

# --- SCRIPT BELOW HERE ---------------------------------------------------------------------------------------- #
# the base URL of the FRED API, and the API key -
baseurl = "https://api.stlouisfed.org";
apikey = _read_apikey();

# the folder of the fixtures: create the folder when it is not there -
fixtures_dir = joinpath(@__DIR__, "..", "test", "fixtures");
mkpath(fixtures_dir);

# call each endpoint, trim its response, and save the trimmed response as a fixture -
models = example_models(apikey);
failed_names = String[];
for (name, model) in models

    # call FRED with the default handler, which parses the JSON response into a dictionary.
    # The error messages of api never show the URL or the key, so we can print them -
    response = nothing;
    try
        response = api(typeof(model), url(baseurl, model));
    catch e
        println("$(name): the call failed. $(sprint(showerror, e))");
        push!(failed_names, name);
    end

    # wait 0.5 seconds between calls: FRED allows 120 requests per minute -
    sleep(0.5);

    # go to the next endpoint when the call failed -
    if (isnothing(response) == true)
        continue;
    end

    # trim the response, and write the trimmed response as indented JSON text -
    trimmed = _trim_response(model, response);
    text = JSON.json(trimmed; pretty = true) * "\n";

    # check: a fixture must never hold the key. The message does not show the key -
    if (occursin(apikey, text) == true)
        throw(ErrorException("The trimmed response of $(name) holds the API key, so we do not save it."));
    end

    # save the fixture -
    write(joinpath(fixtures_dir, name * ".json"), text);
    println("$(name): saved test/fixtures/$(name).json");
end

# check: did every call succeed?
if (isempty(failed_names) == false)
    throw(ErrorException("$(length(failed_names)) of $(length(models)) calls failed: $(join(failed_names, ", "))"));
end
println("saved $(length(models)) fixtures");
