# ronin-urls 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin urls` [*options*]

## DESCRIPTION

Manages URLs.

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-D`, `--database` *URI*
	The database to URI (`mysql://user:password@host/ronin`).

`--[no-]csv`
	CSV output.

`--[no-]xml`
	XML output.

`--[no-]yaml`
	YAML output.

`--[no-]json`
	JSON output.

`-i`, `--import` *FILE*
	Imports HostNames from the FILE.

`--[no-]http`
	Searches for `http://` URLs.

`--[no-]https`
	Searches for `https://` URLs.

`-H`, `--hosts` *HOST* [...]
	Searches for URLs with the given HOST name(s).

`-p`, `--with-ports` *PORT* [...]
	Searches for URLs associated with the PORT(s).

`-d`, `--directory` *DIRECTORY*
	Searches for URLs sharing the DIRECTORY.

`-q`, `--with-query-param` *NAME* [...]
	Searches for URLs containing the query-param NAME.

`-Q`, `--with-query-value` *VALUE* [...]
	Searches for URLs containing the query-param VALUE.

`-l`, `--[no-]list`
	Lists the HostNames.

## FILES

*~/.ronin/*
	Ronin configuration directory.

*~/.ronin/database.log*
	Database log.

*~/.ronin/database.sqlite3*
	The default sqlite3 Database file.

*~/.ronin/database.yml*
	Optional Database configuration.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

