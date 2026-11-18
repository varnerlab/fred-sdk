# test_utility.jl: tests for read_configuration and hidekey -

# write a configuration file with the given text, and return its path -
function write_config(dir::String, name::String, text::String)::String
    path = joinpath(dir, name);
    write(path, text);
    return path;
end

# check that reading a file throws an ArgumentError, and that neither the message nor a chained cause shows the key -
function check_error(path::String)
    caught = nothing;
    try
        read_configuration(path);
    catch e
        caught = e;

        # the full display of the error stack must hold one error, and must not show the key -
        @test length(current_exceptions()) == 1;
        full_display = sprint(Base.display_error, current_exceptions());
        @test occursin(KEY, full_display) == false;
        @test occursin(KEY[1:31], full_display) == false;
    end
    @test caught isa ArgumentError;
    message = sprint(showerror, caught);
    @test occursin(KEY, message) == false;
    @test occursin(KEY[1:31], message) == false;
    return message;
end

dir = mktempdir();

# a valid file -
good = write_config(dir, "good.toml", "[connection]\napikey = \"$(KEY)\"\nbaseurl = \"$(BASE)\"\n");
connection = read_configuration(good);
@test connection["apikey"] == KEY;
@test connection["baseurl"] == BASE;

# each broken file throws an ArgumentError -
missing_message = check_error(joinpath(dir, "missing.toml"));
@test occursin(abspath(joinpath(dir, "missing.toml")), missing_message);
check_error(write_config(dir, "notoml.toml", "this is [not toml = \"$(KEY)\"\n"));
check_error(write_config(dir, "unquoted.toml", "[connection]\napikey = $(KEY)\nbaseurl = \"$(BASE)\"\n"));
check_error(write_config(dir, "nosection.toml", "[other]\napikey = \"$(KEY)\"\nbaseurl = \"$(BASE)\"\n"));
check_error(write_config(dir, "nokey.toml", "[connection]\nbaseurl = \"$(BASE)\"\n"));
check_error(write_config(dir, "nobase.toml", "[connection]\napikey = \"$(KEY)\"\n"));
check_error(write_config(dir, "notext.toml", "[connection]\napikey = 12345\nbaseurl = \"$(BASE)\"\n"));
check_error(write_config(dir, "short.toml", "[connection]\napikey = \"$(KEY[1:31])\"\nbaseurl = \"$(BASE)\"\n"));

# hidekey replaces the key, and leaves the URL alone for an empty key -
@test hidekey(BASE * "/fred/series?series_id=GNPCA&api_key=" * KEY * "&file_type=json", KEY) ==
    BASE * "/fred/series?series_id=GNPCA&api_key=<your key>&file_type=json";
@test hidekey("abc", "") == "abc";
