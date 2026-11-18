using Test
using FredAPI

# each test file runs in its own testset -
@testset "Types" begin
    include("test_types.jl")
end
