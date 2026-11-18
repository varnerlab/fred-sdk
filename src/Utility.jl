# =============================================================================
# Utility.jl: helper functions, e.g., loading the connection settings.
# =============================================================================
# --- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------- #

"""
    read_configuration(path::String) -> Dict{String,Any}

Read the configuration file, and check that it holds a FRED API key.

The file is written in the TOML format. Its `[connection]` section has two entries:
`apikey`, your FRED API key, and `baseurl`, the base URL of the FRED API.

### Arguments
- `path::String`: the path to the configuration file, e.g., `joinpath("conf", "Configuration.toml")`.

### Returns
- `Dict{String,Any}`: the `[connection]` section as a dictionary with the keys `"apikey"` and `"baseurl"`.

### Throws
- `ArgumentError`: when the file does not exist, when the file is not valid TOML, when an entry is not there, or when the key is not
  32 characters long. The messages never show the contents of the file. The message for a missing file names the absolute path that it checked.

### Example
```julia
connection = read_configuration(joinpath("conf", "Configuration.toml"));
baseurl = connection["baseurl"];
apikey = connection["apikey"];
```
"""
function read_configuration(path::String)::Dict{String,Any}

    # check: does the file exist?
    if (isfile(path) == false)
        throw(ArgumentError("We cannot find the configuration file $(abspath(path)). " *
            "Create it with the lines of conf/Configuration-template.toml in the package repository."));
    end

    # read the file: each [section] of a TOML file becomes a dictionary. The error of the TOML
    # reader shows the line that it could not read, which may hold the key. We only record that the
    # read failed, and we throw our own error after the catch block, so no cause is chained to it -
    configuration = nothing;
    try
        configuration = TOML.parsefile(path);
    catch
        configuration = nothing;
    end

    # check: did the read fail?
    if (isnothing(configuration) == true)
        throw(ArgumentError("We cannot read the configuration file. Check that the key is between the quotes " *
            "on the apikey line, and compare the file with conf/Configuration-template.toml in the package repository."));
    end

    # check: does the file have a [connection] section with the two entries?
    if (haskey(configuration, "connection") == false)
        throw(ArgumentError("The configuration file has no [connection] section. " *
            "Compare it with conf/Configuration-template.toml in the package repository."));
    end
    connection = configuration["connection"];
    if (haskey(connection, "apikey") == false)
        throw(ArgumentError("The [connection] section has no apikey entry. " *
            "Compare the file with conf/Configuration-template.toml in the package repository."));
    end
    if (haskey(connection, "baseurl") == false)
        throw(ArgumentError("The [connection] section has no baseurl entry. " *
            "Compare the file with conf/Configuration-template.toml in the package repository."));
    end

    # check: a FRED API key has 32 characters. The message does not show the key -
    apikey = connection["apikey"];
    if (isa(apikey, String) == false)
        throw(ArgumentError("The apikey entry is not text. Paste your key between the quotes on the apikey line of $(abspath(path))."));
    end
    if (length(apikey) != 32)
        throw(ArgumentError("The apikey entry is not a FRED API key: a key has 32 characters, and this entry has $(length(apikey)). " *
            "Paste your key between the quotes on the apikey line of $(abspath(path))."));
    end

    # return the connection settings -
    return connection;
end

"""
    hidekey(url::String, apikey::String) -> String

Return a copy of a URL that shows the text `<your key>` in place of the API key.
Use this copy to print or share a URL. Use the original URL to call FRED.

### Arguments
- `url::String`: the URL string that a `url(...)` method returned.
- `apikey::String`: your FRED API key.

### Returns
- `String`: the URL with the key replaced, e.g.,
  `"https://api.stlouisfed.org/fred/series?series_id=DHHNGSP&api_key=<your key>&file_type=json"`.

### Example
```julia
safe_url = hidekey(request_url, apikey);
println(safe_url);
```
"""
function hidekey(url::String, apikey::String)::String

    # an empty key matches everywhere in a String, so we return the URL unchanged -
    if (isempty(apikey) == true)
        return url;
    end

    # replace each copy of the key with the text <your key> -
    hidden_url = replace(url, apikey => "<your key>");
    return hidden_url;
end

# --- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------- #
