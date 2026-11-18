# =============================================================================
# Factory.jl: the url(...) methods that build the request URL of each endpoint model.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #

"""
    _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::String) -> Nothing

Add the pair `key => value` to the list of query parameters, unless `value` is the empty string.
An empty string means that the model does not set this parameter, so it stays out of the URL.

### Arguments
- `parameters::Vector{Pair{String,String}}`: the list of query parameters. This function adds to the list.
- `key::String`: the name of the FRED parameter, e.g., `"series_id"`.
- `value::String`: the value of the parameter. The empty string `""` means not set.

### Returns
- `Nothing`: this function changes `parameters` and returns nothing.

### Throws
- This function does not throw an error.

### Example
```julia
parameters = Pair{String,String}[];
_add_parameter!(parameters, "series_id", "DHHNGSP");
```
"""
function _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::String)::Nothing

    # check: is the value set? An empty string means not set -
    if (value != "")
        push!(parameters, key => value);
    end

    return nothing;
end

"""
    _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Int64) -> Nothing

Add the pair `key => string(value)` to the list of query parameters, unless `value` is `0`.
A value of `0` means that the model does not set this parameter, so it stays out of the URL.

### Arguments
- `parameters::Vector{Pair{String,String}}`: the list of query parameters. This function adds to the list.
- `key::String`: the name of the FRED parameter, e.g., `"limit"`.
- `value::Int64`: the value of the parameter. The value `0` means not set.

### Returns
- `Nothing`: this function changes `parameters` and returns nothing.

### Throws
- This function does not throw an error.

### Example
```julia
parameters = Pair{String,String}[];
_add_parameter!(parameters, "limit", 100);
```
"""
function _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Int64)::Nothing

    # check: is the value set? The value 0 means not set -
    if (value != 0)
        push!(parameters, key => string(value));
    end

    return nothing;
end

"""
    _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Bool) -> Nothing

Add the pair `key => "true"` to the list of query parameters when `value` is `true`.
A value of `false` means that the model does not set this parameter, so it stays out of the URL.

### Arguments
- `parameters::Vector{Pair{String,String}}`: the list of query parameters. This function adds to the list.
- `key::String`: the name of the FRED parameter, e.g., `"include_release_dates_with_no_data"`.
- `value::Bool`: the value of the parameter. The value `false` means not set.

### Returns
- `Nothing`: this function changes `parameters` and returns nothing.

### Throws
- This function does not throw an error.

### Example
```julia
parameters = Pair{String,String}[];
_add_parameter!(parameters, "include_release_dates_with_no_data", true);
```
"""
function _add_parameter!(parameters::Vector{Pair{String,String}}, key::String, value::Bool)::Nothing

    # check: is the value set? The value false means not set -
    if (value == true)
        push!(parameters, key => "true");
    end

    return nothing;
end

"""
    _build_url(base::String, path::String, parameters::Vector{Pair{String,String}}) -> String

Build the request URL from the base URL, the path of an endpoint, and the list of query parameters.
The URL has the form `base * path * "?" * query`. The query joins each `key=value` with `&`, in the order of the list,
and encodes each value, so that characters such as `&`, `;`, `,`, and spaces reach FRED intact.

### Arguments
- `base::String`: the base URL of the FRED API, e.g., `"https://api.stlouisfed.org"`.
- `path::String`: the path of the endpoint, e.g., `"/fred/series/search"`.
- `parameters::Vector{Pair{String,String}}`: the query parameters, in the order that they appear in the URL.

### Returns
- `String`: the request URL.

### Throws
- This function does not throw an error.

### Example
```julia
request_url = _build_url("https://api.stlouisfed.org", "/fred/series", ["series_id" => "DHHNGSP"]);
```
"""
function _build_url(base::String, path::String, parameters::Vector{Pair{String,String}})::String

    # build the query text, one key=value piece at a time -
    query = "";
    for (index, parameter) in enumerate(parameters)

        # get the key and the value of this parameter -
        key = parameter.first;
        value = parameter.second;

        # separate this piece from the previous piece with & -
        if (index > 1)
            query = query * "&";
        end

        # add the piece, with the value encoded for a URL -
        query = query * key * "=" * HTTP.escapeuri(value);
    end

    # join the base URL, the path, and the query -
    return base * path * "?" * query;
end
