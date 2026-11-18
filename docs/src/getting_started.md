# Getting started

## Get a FRED API key

You need a FRED API key to call the FRED API. Create a free FRED account, then request a key, as described on the [API key page of FRED](https://fred.stlouisfed.org/docs/api/api_key.html). A FRED API key is a string of 32 lowercase letters and digits.

## The configuration file

FredAPI reads your key from a configuration file. Create the file `conf/Configuration.toml` in your project folder, with these lines, and paste your key between the quotes on the `apikey` line:

```toml
[connection]
apikey = "paste-your-FRED-API-key-here"
baseurl = "https://api.stlouisfed.org"
```

The package repository holds the same lines in `conf/Configuration-template.toml`. Your key works like a password, so do not commit the configuration file: add `conf/Configuration.toml` to your `.gitignore` file.

Read the configuration file with `read_configuration`, which returns a dictionary with the keys `"apikey"` and `"baseurl"`:

```julia
using FredAPI

connection = read_configuration("conf/Configuration.toml");
apikey = connection["apikey"];
baseurl = connection["baseurl"];
```

The examples in the rest of these docs use the `apikey` and `baseurl` variables that this code defines.

## The four steps

Every endpoint works in the same four steps:

1. Build the endpoint model. An endpoint model is a `mutable struct` that holds your key and the parameters of one endpoint. You set its fields with keyword arguments. A field that you do not set stays out of the URL, so FRED uses its own default for that field.
2. Build the URL with `url(baseurl, model)`.
3. Call `api` with the endpoint model type and the URL. `api` sends the request to FRED and passes the response to a handler, a function that turns the response into a Julia object.
4. The handler returns a dictionary, or a `DataFrame` when you pass a table handler with the `handler` keyword.

We'll fetch the daily Henry Hub natural gas spot price, the series `"DHHNGSP"`, from `2025-01-01` to `2025-01-10`:

```julia
# build the endpoint model -
model = MyFredSeriesObservationsEndpointModel(apikey = apikey, series_id = "DHHNGSP",
    observation_start = "2025-01-01", observation_end = "2025-01-10");

# build the URL -
request_url = url(baseurl, model);

# call FRED, and turn the response into a DataFrame with a table handler -
table = api(MyFredSeriesObservationsEndpointModel, request_url; handler = process_observations_response_dataframe);
```

The [Handlers](handlers.md) page lists the table handler of each endpoint.

## Print a URL with hidekey

The URL that `url` builds holds your key. To print or share a URL, replace the key with `hidekey`:

```julia
println(hidekey(request_url, apikey));
```

```
https://api.stlouisfed.org/fred/series/observations?series_id=DHHNGSP&observation_start=2025-01-01&observation_end=2025-01-10&api_key=<your key>&file_type=json
```
