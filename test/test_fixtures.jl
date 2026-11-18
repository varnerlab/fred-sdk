# test_fixtures.jl: tests for the saved FRED responses in test/fixtures -
import JSON

# the folder that holds the fixtures -
fixtures_dir = joinpath(@__DIR__, "fixtures");

# each endpoint in example_models has a fixture -
for (name, model) in example_models(KEY)
    @test isfile(joinpath(fixtures_dir, name * ".json")) == true
end

# every fixture parses as JSON, and holds no API key: no 32 character word of lowercase letters and digits, and no api_key parameter -
for file in readdir(fixtures_dir)
    text = read(joinpath(fixtures_dir, file), String);
    @test JSON.parse(text) isa AbstractDict
    @test occursin(r"\b[a-z0-9]{32}\b", text) == false
    @test occursin("api_key", text) == false
end
