# Paging

FRED returns a list of records one page at a time, and each call to `api` returns one page. Version 1 and version 2 move from one page to the next in different ways.

## Version 1: limit and offset

A version 1 endpoint whose model has `limit` and `offset` fields returns its records in pages. `limit` caps the number of records in one page, and `offset` sets the number of records that FRED skips before the page starts. Each paged response also holds `count`, the total number of records that match the request.

We'll collect every series in release `51`, `200` series at a time:

```julia
using DataFrames

# ask for the first page with the default handler, to read the total number of series -
model = MyFredReleaseSeriesEndpointModel(apikey = apikey, release_id = 51, limit = 200);
first_page = api(MyFredReleaseSeriesEndpointModel, url(baseurl, model));

# the number of pages: the count divided by the limit, rounded up -
number_of_pages = cld(first_page["count"], model.limit);

# ask for each page with the table handler, and stack the tables -
page_tables = DataFrame[];
for page in 1:number_of_pages
    model.offset = (page - 1) * model.limit;
    page_table = api(MyFredReleaseSeriesEndpointModel, url(baseurl, model); handler = process_series_response_dataframe);
    push!(page_tables, page_table);
end
all_series = vcat(page_tables...);
```

## Version 2: next_cursor

A version 2 response holds `has_more`, which is `true` when another page follows, and `next_cursor`, which marks where the next page starts. To ask for the next page, copy `next_cursor` into the endpoint model:

```julia
# ask for the first page with the default handler, to read next_cursor -
model = MyFredV2ReleaseObservationsEndpointModel(apikey = apikey, release_id = 52, limit = 500);
first_page = api(MyFredV2ReleaseObservationsEndpointModel, url(baseurl, model));

# ask for the next page, when there is one -
if (first_page["has_more"] == true)
    model.next_cursor = first_page["next_cursor"];
    second_page = api(MyFredV2ReleaseObservationsEndpointModel, url(baseurl, model));
end
```
