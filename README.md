# FredAPI.jl

FredAPI is a Julia package that calls the 36 endpoints of the FRED (Federal Reserve Economic Data) API and turns each response into a dictionary or a `DataFrame`.

## Installation

Install FredAPI from its GitHub repository. In the Julia package manager, run:

```julia
] add https://github.com/varnerlab/fred-sdk.git
```

## Configuration

You need a FRED API key, which you request on the [API key page of FRED](https://fred.stlouisfed.org/docs/api/api_key.html). Create the file `conf/Configuration.toml` in your project folder with these lines, paste your key between the quotes on the `apikey` line, and add the file to your `.gitignore` file, so that git does not track your key:

```toml
[connection]
apikey = "paste-your-FRED-API-key-here"
baseurl = "https://api.stlouisfed.org"
```

## Example

We'll search for a series, then fetch the observations of the first series that the search returns, and show its first three observations:

```julia
using FredAPI
connection = read_configuration("conf/Configuration.toml");
search = MyFredSeriesSearchEndpointModel(apikey = connection["apikey"], search_text = "real gross domestic product", limit = 1);
found = api(MyFredSeriesSearchEndpointModel, url(connection["baseurl"], search); handler = process_search_response_dataframe);
model = MyFredSeriesObservationsEndpointModel(apikey = connection["apikey"], series_id = found[1, :id]);
request_url = url(connection["baseurl"], model);
observations = api(MyFredSeriesObservationsEndpointModel, request_url; handler = process_observations_response_dataframe);
first(observations, 3)
```

## Documentation and license

The documentation is at [https://varnerlab.github.io/fred-sdk](https://varnerlab.github.io/fred-sdk). FredAPI is released under the MIT license, in `LICENSE`.
