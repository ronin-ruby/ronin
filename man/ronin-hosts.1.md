# ronin-hosts 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin hosts` [*options*]

## DESCRIPTION

Manages HostNames.

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

`-I`, `--with-ips` *IP* [...]
	Searches for HostNames associated with the IP Address(es).

`-p`, `--with-ports` *PORT* [...]
	Searches for HostNames associated with the PORT(s).

`-D`, `--domain` *DOMAIN*
	Searches for HostNames belonging to the DOMAIN (`co.uk`).

`-T`, `--tld` *TLD*
	Searches for HostNames with the Top-Level-Domain (TLD) (`ru`).

`-l`, `--[no-]list`
	Lists the HostNames.

`-L`, `--lookup` *IP*
	Looks the HostNames associated with the IP Address.

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

