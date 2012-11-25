# ronin-emails 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin emails` [*options*]

## DESCRIPTION

Manages EmailAddresses.

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-D`, `--database` [*URI*]
	The database to URI (`mysql://user:password@host/ronin`).

`--[no-]csv`
	CSV output.

`--[no-]xml`
	XML output.

`--[no-]yaml`
	YAML output.

`--[no-]json`
	JSON output.

`-H`, `--with-hosts` *HOST* [...]
	Searches for EmailAddresses associated with the HOST(s).

`-I`, `--with-ips` *IP* [...]
	Searches for EmailAddresses associated with the IP Address(es).

`-u`, `--with-users` *NAME* [...]
	Searches for EmailAddresses associated with the user NAME(s).

`-l`, `--[no-]list`
	Lists the EmailAddresses.

`-i`, `--import` *FILE*
	Imports EmailAddresses from the FILE.

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

