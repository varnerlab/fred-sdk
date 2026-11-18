# =============================================================================
# Network.jl: the HTTP calls to the FRED API.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #
"""
    api(endpoint::Type{T}, request_url::String;
        handler::Function = _default_handler_process_fred_response) where T <: AbstractFredEndpointModel

Make an HTTP GET request to a FRED endpoint, and process the response.

### Arguments
- `endpoint::Type{T}`: the endpoint model type that identifies the response to process.
- `request_url::String`: the complete URL that `url(...)` returned. The URL holds the API key, so do not print it.
- `handler::Function`: the function that receives the endpoint model type and the response body as a `String`.
  The default handler parses the JSON text into a dictionary.

### Returns
- The result of the handler. The default handler returns a dictionary.

### Throws
- `ArgumentError`: when the URL does not start with `http://` or `https://`, when the connection fails, or when the status code
  of the response is not `200`. The message gives the status code and FRED's description of the problem when there is one.
  The messages never show the URL or the API key.

### Example
```julia
request_url = url(baseurl, MyFredSeriesEndpointModel(apikey = apikey, series_id = "GNPCA"));
result = api(MyFredSeriesEndpointModel, request_url);
```
"""
function api(endpoint::Type{T}, request_url::String;
    handler::Function = _default_handler_process_fred_response) where T <: AbstractFredEndpointModel

    # the request headers tell the server who is calling, and which format we want back -
    headers = Pair{String,String}[
        "User-Agent" => "FredAPI.jl", # identifies the client
        "Accept" => "application/json" # the format (media type) that we want for the response body
    ];

    # version 2 of the API takes the key in the Authorization header, not in the URL -
    if (endpoint == MyFredV2ReleaseObservationsEndpointModel)

        # read the API key from the query of the URL -
        key = HTTP.queryparams(HTTP.URI(request_url))["api_key"];

        # remove api_key from the URL: split off the query, keep every parameter except api_key, and join them again -
        url_parts = split(request_url, "?"; limit = 2);
        kept_parameters = String[];
        for parameter in split(url_parts[2], "&")
            if (startswith(parameter, "api_key=") == false)
                push!(kept_parameters, String(parameter));
            end
        end
        request_url = String(url_parts[1]) * "?" * join(kept_parameters, "&");

        # send the key as a bearer token -
        push!(headers, "Authorization" => "Bearer " * key);
    end

    # make the HTTP GET call and read the response body as a String -
    response_string = _http_get_call_with_url(request_url, headers);

    # process the response, and return the result of the handler -
    return handler(endpoint, response_string);
end
# --- PUBLIC METHODS ABOVE HERE -------------------------------------------------------------------------------- #

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #
"""
    _http_get_call_with_url(url::String, headers::Vector{Pair{String,String}}) -> String

Private function that makes an HTTP GET call with the URL and the headers that were passed in.
We check for a status code other than 200, and throw an error if we get one. Otherwise, we return the response body.

### Arguments
- `url::String`: the complete URL of the request. It must start with `http://` or `https://`.
- `headers::Vector{Pair{String,String}}`: the request headers, e.g., `"Accept" => "application/json"`.

### Returns
- `String`: the body of the response.

### Throws
- `ArgumentError`: when the URL is not formatted as a URL, when the connection fails, or when the status code is not `200`.
  The messages never show the URL or the API key.
"""
function _http_get_call_with_url(url::String, headers::Vector{Pair{String,String}})::String

    # check: is this string formatted as a URL? The URL holds the API key, so the message does not show the URL -
    if (startswith(url, "http://") == false && startswith(url, "https://") == false)
        throw(ArgumentError("The url is not properly formatted: it must start with http:// or https://"));
    end

    # make the HTTP GET call. This is a blocking call, and it uses the HTTP.jl package. We handle a failed status code
    # on our own, so HTTP.jl does not throw an error for it. We also turn off retries: HTTP.jl would otherwise
    # repeat a call that got a 5xx or a 429 status. The error of HTTP.jl shows the URL, which holds the API key,
    # so we only record that the call failed, and we throw our own error after the catch block, so no cause is chained to it -
    response = nothing;
    try
        response = HTTP.request("GET", url, headers; status_exception = false, retry = false);
    catch
        response = nothing;
    end

    # check: did the call fail before we got a response?
    if (isnothing(response) == true)
        throw(ArgumentError("HTTP GET call failed: we could not connect to the server. Check the base URL and your network connection."));
    end

    # the body of the response as a String -
    body = String(response.body);

    # a status code of 200 means OK. Any other status code is a failed call -
    if (response.status != 200)

        # start the error message with the status code -
        message = "HTTP GET call failed with status code $(response.status)";

        # FRED describes the problem in the body of an error response, as JSON text like
        # {"error_code": 400, "error_message": "Bad Request. ..."}. A proxy can send other text, e.g., an HTML page.
        # We only record whether the body parses, and we throw after the catch block -
        error_dictionary = nothing;
        if (startswith(body, "{") == true)
            try
                error_dictionary = JSON.parse(body);
            catch
                error_dictionary = nothing;
            end
        end

        # add the description of FRED to the message, when the body has one -
        if (isa(error_dictionary, AbstractDict) == true && haskey(error_dictionary, "error_message") == true)
            message = message * ": " * string(error_dictionary["error_message"]);
        end

        throw(ArgumentError(message));
    end

    # return the body of the response -
    return body;
end
# --- PRIVATE METHODS ABOVE HERE ------------------------------------------------------------------------------- #
