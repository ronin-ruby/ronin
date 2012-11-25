# ronin-database 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin database` [*options*]

## DESCRIPTION

Manages the Ronin Database.

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-a`, `--add` *NAME*
	Adds a new Database Repository.

`-s`, `--set` *NAME*
	Sets the configure information for a Database Repository.

`-r`, `--remove` *NAME*
	Removes a Database Repository.

`-C`, `--clear` *NAME*
	`WARNING:` This will delete all database within a Database Repository.

`--uri` *URI*
	The URI of a Database Repository (`sqlite3:///path/to/db`).

`--adapter` *ADAPTER*
	The Database ADAPTER to use:

	* `sqlite3`
	* `mysql`
	* `postgres`

`--host` *HOST*
	The HOST that the Database is running on.

`--port` *PORT*
	The PORT that the Database is listening on.

`--user` *USER*
	The USER to login as.

`--password` *PASSWORD*
	The PASSWORD to use while authenticating.

`--database` *NAME*
	The name of the Database.

`--path` *PATH*
	The path to the Database. Only valid with `sqlite3` Databases.

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

