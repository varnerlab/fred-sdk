# FredAPI.jl

FRED (Federal Reserve Economic Data) is the database of economic data of the Federal Reserve Bank of St. Louis, and the FRED API is the web service that returns that data. FredAPI is a Julia package that calls the FRED API.

FRED organizes its data with five kinds of objects:

- A series is a sequence of observations of one economic quantity over time, such as the daily Henry Hub natural gas spot price. Each observation is a date and a value.
- A category groups series by topic, such as Trade Balance. The categories form a tree, so each category has a parent category.
- A source is an agency that publishes data, such as the U.S. Bureau of Economic Analysis.
- A release is a set of series that one or more sources publish together, such as Gross Domestic Product.
- A tag is a short label that describes a series, such as `"usa"` for its geography or `"nsa"` for not seasonally adjusted.

Each endpoint of the FRED API answers one kind of request. For example, the `fred/series/observations` endpoint returns the observations of one series. FredAPI calls 36 endpoints: the 31 endpoints of version 1, the 4 endpoints of the Maps API, which returns data by region, and the `fred/v2/release/observations` endpoint of version 2.

## Installation

Install FredAPI from its GitHub repository:

```julia
using Pkg
Pkg.add(url = "https://github.com/varnerlab/fred-sdk.git")
```

## Example

We'll fetch the observations of the real gross national product, the series `"GNPCA"`, as a `DataFrame`. You need a FRED API key in a configuration file, as described in [Getting started](getting_started.md).

```julia
using FredAPI

connection = read_configuration("conf/Configuration.toml");
model = MyFredSeriesObservationsEndpointModel(apikey = connection["apikey"], series_id = "GNPCA");
request_url = url(connection["baseurl"], model);
table = api(MyFredSeriesObservationsEndpointModel, request_url; handler = process_observations_response_dataframe);
```
