# ronin-creds 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin creds` [*options*]

## DESCRIPTION

Lists Credentials.

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

`-u`, `--for-user` *USER*
	Searches for Credentials associated with the USER.

`-p`, `--with-password` *PASSWORD*
	Searches for Credentials that have the PASSWORD.

`-l`, `--[no-]list`
	Lists the Credentials.

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

