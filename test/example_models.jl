# example_models.jl: one example model for each FRED endpoint. The fixture capture script and the live tests use these models -

"""
    example_models(apikey::String) -> Vector{Pair{String,AbstractFredEndpointModel}}

Build one example model for each FRED endpoint. Each entry pairs the fixture name of an endpoint with the model of that endpoint.
The fixture name is the path of the endpoint without its leading `/`, with each remaining `/` replaced by `_`,
e.g., `fred_category_series` for the path `/fred/category/series`.

### Arguments
- `apikey::String`: the FRED API key that each model holds.

### Returns
- `Vector{Pair{String,AbstractFredEndpointModel}}`: 36 entries of the form fixture name => model, one for each endpoint.

### Example
```julia
for (name, model) in example_models(apikey)
    result = api(typeof(model), url(baseurl, model));
end
```
"""
function example_models(apikey::String)::Vector{Pair{String,AbstractFredEndpointModel}}

    # initialize: the list of fixture name => model pairs -
    models = Pair{String,AbstractFredEndpointModel}[];

    # --- SERIES ENDPOINTS --- #
    # fred/series: the description of the series GNPCA, the real gross national product -
    push!(models, "fred_series" => MyFredSeriesEndpointModel(apikey = apikey, series_id = "GNPCA"));

    # fred/series/categories: the categories that hold the series EXJPUS -
    push!(models, "fred_series_categories" => MyFredSeriesCategoriesEndpointModel(apikey = apikey, series_id = "EXJPUS"));

    # fred/series/observations: the daily Henry Hub natural gas spot price, DHHNGSP, from 2025-01-01 to 2025-01-10. FRED has
    # no price for the holiday 2025-01-01, so the observation of that day has the value "." -
    push!(models, "fred_series_observations" => MyFredSeriesObservationsEndpointModel(apikey = apikey, series_id = "DHHNGSP",
        observation_start = "2025-01-01", observation_end = "2025-01-10"));

    # fred/series/release: the H.6 Money Stock Measures release, which publishes the series IRA -
    push!(models, "fred_series_release" => MyFredSeriesReleaseEndpointModel(apikey = apikey, series_id = "IRA"));

    # fred/series/search: the first 3 series that match the search text "monetary service index" -
    push!(models, "fred_series_search" => MyFredSeriesSearchEndpointModel(apikey = apikey, search_text = "monetary service index",
        limit = 3));

    # fred/series/search/tags: the first 3 tags of the series that match the search text "monetary service index" -
    push!(models, "fred_series_search_tags" => MyFredSeriesSearchTagsEndpointModel(apikey = apikey,
        series_search_text = "monetary service index", limit = 3));

    # fred/series/search/related_tags: the first 3 tags that appear with the tags 30-year and frb on the series that
    # match the search text "mortgage rate" -
    push!(models, "fred_series_search_related_tags" => MyFredSeriesSearchRelatedTagsEndpointModel(apikey = apikey,
        series_search_text = "mortgage rate", tag_names = "30-year;frb", limit = 3));

    # fred/series/tags: the tags of the series STLFSI -
    push!(models, "fred_series_tags" => MyFredSeriesTagsEndpointModel(apikey = apikey, series_id = "STLFSI"));

    # fred/series/updates: the 3 series that FRED updated most recently -
    push!(models, "fred_series_updates" => MyFredSeriesUpdatesEndpointModel(apikey = apikey, limit = 3));

    # fred/series/vintagedates: the first 3 vintage dates of the series GNPCA -
    push!(models, "fred_series_vintagedates" => MyFredSeriesVintageDatesEndpointModel(apikey = apikey, series_id = "GNPCA",
        limit = 3));

    # --- CATEGORIES ENDPOINTS --- #
    # fred/category: the description of category 125, Trade Balance -
    push!(models, "fred_category" => MyFredCategoryEndpointModel(apikey = apikey, category_id = 125));

    # fred/category/children: the child categories of category 13 -
    push!(models, "fred_category_children" => MyFredCategoryChildrenEndpointModel(apikey = apikey, category_id = 13));

    # fred/category/related: the categories related to category 32073 -
    push!(models, "fred_category_related" => MyFredCategoryRelatedEndpointModel(apikey = apikey, category_id = 32073));

    # fred/category/series: the first 3 series in category 125 -
    push!(models, "fred_category_series" => MyFredCategorySeriesEndpointModel(apikey = apikey, category_id = 125, limit = 3));

    # fred/category/tags: the first 3 tags of the series in category 125 -
    push!(models, "fred_category_tags" => MyFredCategoryTagsEndpointModel(apikey = apikey, category_id = 125, limit = 3));

    # fred/category/related_tags: the first 3 tags that appear with the tags services and quarterly on the series in
    # category 125 -
    push!(models, "fred_category_related_tags" => MyFredCategoryRelatedTagsEndpointModel(apikey = apikey, category_id = 125,
        tag_names = "services;quarterly", limit = 3));

    # --- RELEASES ENDPOINTS --- #
    # fred/releases: the first 3 releases -
    push!(models, "fred_releases" => MyFredReleasesEndpointModel(apikey = apikey, limit = 3));

    # fred/releases/dates: the first 3 release dates of all releases -
    push!(models, "fred_releases_dates" => MyFredReleasesDatesEndpointModel(apikey = apikey, limit = 3));

    # fred/release: the description of release 53, Gross Domestic Product -
    push!(models, "fred_release" => MyFredReleaseEndpointModel(apikey = apikey, release_id = 53));

    # fred/release/dates: the first 3 release dates of release 82 -
    push!(models, "fred_release_dates" => MyFredReleaseDatesEndpointModel(apikey = apikey, release_id = 82, limit = 3));

    # fred/release/series: the first 3 series in release 51 -
    push!(models, "fred_release_series" => MyFredReleaseSeriesEndpointModel(apikey = apikey, release_id = 51, limit = 3));

    # fred/release/sources: the sources of release 51 -
    push!(models, "fred_release_sources" => MyFredReleaseSourcesEndpointModel(apikey = apikey, release_id = 51));

    # fred/release/tags: the first 3 tags of the series in release 86 -
    push!(models, "fred_release_tags" => MyFredReleaseTagsEndpointModel(apikey = apikey, release_id = 86, limit = 3));

    # fred/release/related_tags: the first 3 tags that appear with the tags sa and foreign on the series in release 86 -
    push!(models, "fred_release_related_tags" => MyFredReleaseRelatedTagsEndpointModel(apikey = apikey, release_id = 86,
        tag_names = "sa;foreign", limit = 3));

    # fred/release/tables: element 12886 of release 53, the table of personal consumption expenditures, with its child
    # elements -
    push!(models, "fred_release_tables" => MyFredReleaseTablesEndpointModel(apikey = apikey, release_id = 53,
        element_id = 12886));

    # --- SOURCES AND TAGS ENDPOINTS --- #
    # fred/sources: the first 3 sources -
    push!(models, "fred_sources" => MyFredSourcesEndpointModel(apikey = apikey, limit = 3));

    # fred/source: the description of source 1, the Board of Governors of the Federal Reserve System -
    push!(models, "fred_source" => MyFredSourceEndpointModel(apikey = apikey, source_id = 1));

    # fred/source/releases: the first 3 releases of source 1 -
    push!(models, "fred_source_releases" => MyFredSourceReleasesEndpointModel(apikey = apikey, source_id = 1, limit = 3));

    # fred/tags: the first 3 tags -
    push!(models, "fred_tags" => MyFredTagsEndpointModel(apikey = apikey, limit = 3));

    # fred/related_tags: the first 3 tags that appear with the tags monetary aggregates and weekly -
    push!(models, "fred_related_tags" => MyFredRelatedTagsEndpointModel(apikey = apikey, tag_names = "monetary aggregates;weekly",
        limit = 3));

    # fred/tags/series: the first 3 series that have the tags slovenia and food -
    push!(models, "fred_tags_series" => MyFredTagsSeriesEndpointModel(apikey = apikey, tag_names = "slovenia;food", limit = 3));

    # --- MAPS ENDPOINTS --- #
    # geofred/shapes/file: the outlines of the states -
    push!(models, "geofred_shapes_file" => MyFredMapsShapesEndpointModel(apikey = apikey, shape = "state"));

    # geofred/series/group: the series group of the series SMU56000000500000001a, the number of employees in total
    # private industries -
    push!(models, "geofred_series_group" => MyFredMapsSeriesGroupEndpointModel(apikey = apikey,
        series_id = "SMU56000000500000001a"));

    # geofred/series/data: the per capita personal income of each state for 2012-01-01, from the series group of the
    # series WIPCPI -
    push!(models, "geofred_series_data" => MyFredMapsSeriesDataEndpointModel(apikey = apikey, series_id = "WIPCPI",
        date = "2012-01-01"));

    # geofred/regional/data: the annual per capita personal income of each state (series group 882) for 2013-01-01, in dollars,
    # not seasonally adjusted -
    push!(models, "geofred_regional_data" => MyFredMapsRegionalDataEndpointModel(apikey = apikey, series_group = "882",
        region_type = "state", date = "2013-01-01", season = "NSA", units = "Dollars", frequency = "a"));

    # --- VERSION 2 ENDPOINTS --- #
    # fred/v2/release/observations: the first 500 observations of the series in release 52, the Z.1 Financial Accounts of the
    # United States. The first series of release 52 has fewer than 500 observations, so the response holds at least 2 series -
    push!(models, "fred_v2_release_observations" => MyFredV2ReleaseObservationsEndpointModel(apikey = apikey, release_id = 52,
        limit = 500));

    # return the list of pairs -
    return models;
end
