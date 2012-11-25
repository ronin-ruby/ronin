# ronin-campaigns 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin campaigns` *[options]*

## DESCRIPTION

Manages Campaigns.

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

`-n`, `--named` *NAME*
	Searches for Campaigns with the similar NAME.

`-d`, `--describing` *DESCRIPTION*
	Searches for Campaigns with the similar DESCRIPTION.

`-T`, `--targeting` *ADDRESS* [...]
	Searches for Campaigns targetting the given ADDRESSes.

`-O`, `--targeting-orgs` *NAME* [...]
	Searches for Campaigns targetting the NAMEed Organizations.

`-l`, `--[no-]list`
	Lists the Campaigns.

`-a`, `--add` *NAME*
	Creates a new Campaign with the given NAME.

`--targets` *ADDRESS* [...]
	ADDRESSes for the Campaign to target.

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

