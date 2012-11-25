# ronin-ips 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin ips` [*options*]

## DESCRIPTION

Manages IPAddresses.

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

`-4`, `--[no-]v4`
	Searches for IPv4 addresses.

`-6`, `--[no-]v6`
	Searches for IPv6 addresses.

`-p`, `--with-ports` *PORT* [...]
	Searches for IPAddresses associated with the user PORT(s).

`-I`, `--with-macs` *MAC* [...]
	Searches for IPAddresses associated with the MAC Address(es).

`-I`, `--with-hosts` *HOST* [...]
	Searches for IPAddresses associated with the HOST(s).

`-l`, `--[no-]list`
	Lists the IPAddresses.

`-L`, `--lookup` *IP*
	Looks the IPAddresses associated with the IP Address.

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

