using Test
using InteractiveUtils
using FredAPI

# the test key (the demo key of FRED) and the base URL, shared by every test file -
const KEY = "abcdefghijklmnopqrstuvwxyz123456";
const BASE = "https://api.stlouisfed.org";

# each test file runs in its own testset -
@testset "Types" begin
    include("test_types.jl")
end

@testset "Utility" begin
    include("test_utility.jl")
end

@testset "Factory helpers" begin
    include("test_factory_helpers.jl")
end

@testset "Series endpoints" begin
    include("test_series.jl")
end

@testset "Categories endpoints" begin
    include("test_categories.jl")
end

@testset "Releases endpoints" begin
    include("test_releases.jl")
end

@testset "Sources and tags endpoints" begin
    include("test_sources_tags.jl")
end

@testset "Maps and version 2 endpoints" begin
    include("test_maps_v2.jl")
end

@testset "Network and the default handler" begin
    include("test_network.jl")
end

@testset "Fixtures" begin
    include("test_fixtures.jl")
end
