# the abstract type is the parent of every endpoint model -
@test isabstracttype(AbstractFredEndpointModel)

# the package has 36 endpoint models, 31 for version 1 of FRED, 4 for the maps API, and 1 for version 2 -
@test length(InteractiveUtils.subtypes(AbstractFredEndpointModel)) == 36
