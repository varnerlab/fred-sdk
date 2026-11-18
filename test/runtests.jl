using Test
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
