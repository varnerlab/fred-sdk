module FredAPI

    # load external packages -
    import HTTP # make the HTTP calls to FRED, and encode text for a URL
    import JSON # parse the JSON text that FRED returns
    import Dates: Date # the type of a calendar date, for the observation dates
    import DataFrames: DataFrame # tables for the processed responses
    import TOML # read the connection settings from a configuration file

    # what do we want to export? one export line for each kind of name -
    export AbstractFredEndpointModel
    export read_configuration, hidekey

    # load the package code, in this order -
    include("Types.jl")   # the endpoint models
    include("Factory.jl") # the url(...) methods for the request URLs
    include("Handler.jl") # the functions that process the responses
    include("Network.jl") # the HTTP calls
    include("Utility.jl") # helper functions, e.g., loading the configuration
end
