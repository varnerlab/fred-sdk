# =============================================================================
# Types.jl: the endpoint models. Each model holds the data for one FRED endpoint.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #
"""
    AbstractFredEndpointModel

Abstract base type for all FRED (Federal Reserve Economic Data) API endpoint models.
Each subtype represents one endpoint of the API and holds the data needed to call it.
"""
abstract type AbstractFredEndpointModel end
