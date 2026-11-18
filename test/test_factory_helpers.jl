# test_factory_helpers.jl: tests for _add_parameter! and _build_url -

# an empty String, 0, and false add nothing to the parameter list -
let
    parameters = Pair{String,String}[];
    FredAPI._add_parameter!(parameters, "k", "");
    FredAPI._add_parameter!(parameters, "k", 0);
    FredAPI._add_parameter!(parameters, "k", false);
    @test isempty(parameters)
end

# a non-empty String, a non-zero Int64, and true each add one pair -
let
    parameters = Pair{String,String}[];
    FredAPI._add_parameter!(parameters, "k", "x");
    FredAPI._add_parameter!(parameters, "k", 5);
    FredAPI._add_parameter!(parameters, "k", true);
    @test parameters == ["k" => "x", "k" => "5", "k" => "true"]
end

# text with reserved characters is encoded, and the order of the parameters is kept -
let
    parameters = ["search_text" => "S&P 500", "tag_names" => "gdp;quarterly", "api_key" => KEY, "file_type" => "json"];
    expected = BASE * "/fred/series/search?search_text=S%26P%20500&tag_names=gdp%3Bquarterly&api_key=" * KEY * "&file_type=json";
    @test FredAPI._build_url(BASE, "/fred/series/search", parameters) == expected
end

# a comma is encoded -
let
    url = FredAPI._build_url(BASE, "/fred/series/observations", ["vintage_dates" => "2000-01-01,2005-02-24"]);
    @test endswith(url, "vintage_dates=2000-01-01%2C2005-02-24")
end
