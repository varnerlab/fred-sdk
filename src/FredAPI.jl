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
    export MyFredSeriesEndpointModel, MyFredSeriesCategoriesEndpointModel, MyFredSeriesObservationsEndpointModel
    export MyFredSeriesReleaseEndpointModel, MyFredSeriesSearchEndpointModel, MyFredSeriesSearchTagsEndpointModel
    export MyFredSeriesSearchRelatedTagsEndpointModel, MyFredSeriesTagsEndpointModel, MyFredSeriesUpdatesEndpointModel
    export MyFredSeriesVintageDatesEndpointModel
    export MyFredCategoryEndpointModel, MyFredCategoryChildrenEndpointModel, MyFredCategoryRelatedEndpointModel
    export MyFredCategorySeriesEndpointModel, MyFredCategoryTagsEndpointModel, MyFredCategoryRelatedTagsEndpointModel
    export MyFredReleasesEndpointModel, MyFredReleasesDatesEndpointModel, MyFredReleaseEndpointModel
    export MyFredReleaseDatesEndpointModel, MyFredReleaseSeriesEndpointModel, MyFredReleaseSourcesEndpointModel
    export MyFredReleaseTagsEndpointModel, MyFredReleaseRelatedTagsEndpointModel, MyFredReleaseTablesEndpointModel
    export MyFredSourcesEndpointModel, MyFredSourceEndpointModel, MyFredSourceReleasesEndpointModel
    export MyFredTagsEndpointModel, MyFredRelatedTagsEndpointModel, MyFredTagsSeriesEndpointModel
    export MyFredMapsShapesEndpointModel, MyFredMapsSeriesGroupEndpointModel, MyFredMapsSeriesDataEndpointModel
    export MyFredMapsRegionalDataEndpointModel, MyFredV2ReleaseObservationsEndpointModel
    export url, api
    export process_search_response_dataframe, process_observations_response_dataframe, process_series_response_dataframe
    export process_categories_response_dataframe, process_releases_response_dataframe, process_release_dates_response_dataframe
    export process_sources_response_dataframe, process_tags_response_dataframe, process_vintage_dates_response_dataframe

    # load the package code, in this order -
    include("Types.jl")   # the endpoint models
    include("Factory.jl") # the url(...) methods for the request URLs
    include("Handler.jl") # the functions that process the responses
    include("Network.jl") # the HTTP calls
    include("Utility.jl") # helper functions, e.g., loading the configuration
end
