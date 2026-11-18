# Version 2

FredAPI calls one endpoint of version 2 of the FRED API, `fred/v2/release/observations`. Version 2 uses the same four steps as version 1, with two differences:

- Version 2 reads the API key from the `Authorization: Bearer` header of the request, not from the URL. `url` puts the key in the URL, as in version 1, and `api` moves the key from the URL into the header.
- Version 2 moves to the next page of results with the `next_cursor` value of the previous response, in place of `offset`. The [Paging](paging.md) page shows how to follow `next_cursor`.

## `fred/v2/release/observations`

The `fred/v2/release/observations` endpoint returns the observations of every series in one release. In version 2, `limit` caps the total number of observations across all series of the release. The example asks for the first `500` observations of release `52`, the Z.1 Financial Accounts of the United States.

```julia
model = MyFredV2ReleaseObservationsEndpointModel(apikey = apikey, release_id = 52, limit = 500);
request_url = url(baseurl, model);
table = api(MyFredV2ReleaseObservationsEndpointModel, request_url; handler = process_release_observations_response_dataframe);
```

```@docs
MyFredV2ReleaseObservationsEndpointModel
url(::String, ::MyFredV2ReleaseObservationsEndpointModel)
```
