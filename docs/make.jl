using Documenter
using FredAPI

DocMeta.setdocmeta!(FredAPI, :DocTestSetup, :(using FredAPI); recursive = true)

const REPOSITORY = "github.com/varnerlab/fred-sdk.git"
const HAS_COMMIT = success(pipeline(
    `git rev-parse --verify HEAD`;
    stdout = devnull,
    stderr = devnull,
))

makedocs(;
    modules = [FredAPI],
    sitename = "FredAPI.jl",
    authors = "Jeffrey Varner",
    # A brand-new local checkout has no HEAD until its first commit. Omitting
    # source links in that one case keeps local documentation previews working.
    repo = HAS_COMMIT ? Remotes.GitHub("varnerlab", "fred-sdk") : "",
    remotes = HAS_COMMIT ? Dict() : nothing,
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://varnerlab.github.io/fred-sdk",
        edit_link = "main",
        repolink = "https://github.com/varnerlab/fred-sdk",
    ),
    pages = [
        "Home" => "index.md",
        "Getting started" => "getting_started.md",
        "Endpoints" => [
            "Categories" => "categories.md",
            "Releases" => "releases.md",
            "Series" => "series.md",
            "Sources" => "sources.md",
            "Tags" => "tags.md",
            "Maps" => "maps.md",
            "Version 2" => "version2.md",
        ],
        "Handlers" => "handlers.md",
        "Paging" => "paging.md",
        "API reference" => "reference.md",
    ],
    checkdocs = :exports,
)

deploydocs(repo = REPOSITORY, devbranch = "main")
