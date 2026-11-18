# mock_server.jl: a local web server that stands in for FRED in the tests -
using HTTP
using Sockets

# the routes that the server answers: a path maps to a status code and a response body -
MOCK_ROUTES = Dict{String,Tuple{Int64,String}}();

# one entry for each request that the server received: the headers, with lowercase names,
# and the request target (the path and the query) under the name "request-target" -
MOCK_REQUEST_LOG = Dict{String,String}[];

# answer one request: log it, then send the status and the body of its route, or a 404 for any other path -
function mock_handler(request::HTTP.Request)::HTTP.Response

    # log the request: the headers with lowercase names, and the request target -
    logged = Dict{String,String}();
    for (name, value) in request.headers
        logged[lowercase(name)] = value;
    end
    logged["request-target"] = request.target;
    push!(MOCK_REQUEST_LOG, logged);

    # look up the path of the request in the routes -
    path = HTTP.URI(request.target).path;
    if (haskey(MOCK_ROUTES, path) == true)
        status, body = MOCK_ROUTES[path];
        return HTTP.Response(status, body);
    end

    # any other path gets a 404 -
    return HTTP.Response(404, "");
end

# start the server on a free port of 127.0.0.1, and return the server and its base URL -
function start_mock_server(routes::Dict{String,Tuple{Int64,String}})

    # install the routes, and clear the log -
    global MOCK_ROUTES = routes;
    empty!(MOCK_REQUEST_LOG);

    # find a free port: open a listening socket on port 8000 or above, read its port, and close it -
    probe_port, probe = Sockets.listenany(ip"127.0.0.1", 8000);
    close(probe);

    # serve in the background. verbose = -1 keeps the log lines of the server out of the test output -
    server = HTTP.serve!(mock_handler, "127.0.0.1", probe_port; verbose = -1);
    return (server, "http://127.0.0.1:" * string(probe_port));
end

# close the server -
function stop_mock_server(server)
    close(server);
    return nothing;
end
