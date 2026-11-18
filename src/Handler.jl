# =============================================================================
# Handler.jl: the functions that turn each JSON response into a DataFrame.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #
"""
    _default_handler_process_fred_response(model::Type{T}, response::String) where T <: AbstractFredEndpointModel

Private default handler. It parses the JSON text that FRED returned into a dictionary.
The function looks up the parsing function for the endpoint model type, and calls that function.

### Arguments
- `model::Type{T}`: the endpoint model type. Must be a subtype of `AbstractFredEndpointModel`.
- `response::String`: the JSON text of the response body.

### Returns
- The parsed JSON as a dictionary, or `nothing` if the model type is not recognized.

### Throws
- This function does not throw an error itself. The JSON parser throws an error when `response` is not valid JSON.

### Example
```julia
parsed = FredAPI._default_handler_process_fred_response(MyFredSeriesEndpointModel, "{}");
```
"""
function _default_handler_process_fred_response(model::Type{T},
    response::String) where T <: AbstractFredEndpointModel

    # initialize: the dictionary that holds one parsing function for each endpoint model -
    type_handler_dict = Dict{Any,Function}();

    # hardcode the response handler for each endpoint model -
    type_handler_dict[MyFredCategoryChildrenEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryRelatedEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategorySeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredCategoryTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsRegionalDataEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsSeriesDataEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsSeriesGroupEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredMapsShapesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseDatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseSeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseSourcesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseTablesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleaseTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleasesDatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredReleasesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesCategoriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesObservationsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesReleaseEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesSearchEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesSearchRelatedTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesSearchTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesUpdatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSeriesVintageDatesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSourceEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSourceReleasesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredSourcesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredTagsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredTagsSeriesEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyFredV2ReleaseObservationsEndpointModel] = (x::String) -> JSON.parse(x) # default handler

    # lookup the function to handle the response -
    if (haskey(type_handler_dict, model) == true)
        handler_function = type_handler_dict[model];
        return handler_function(response);
    end

    # default: return nothing -
    return nothing;
end
