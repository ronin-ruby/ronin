# ronin-console 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin console` [*options*]

## DESCRIPTION

Start the Ronin Console.

## OPTIONS

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-v`, `--[no-]verbose`
	Enable verbose output.

`-D`, `--database` [*URI*]
	The database to URI (`mysql://user:password@host/ronin`).

`--[no-]backtrace`
	Enable or disables long backtraces.

`-V`, `--[no-]version`
	Print the Ronin version.

`-r`, `--require` [*PATH*]
	Ruby files to require.

## FILES

*~/.ronin/*
	Ronin configuration directory.

*~/.ronin/config.rb*
	Configuration file that is loaded before the Ronin Console starts.

*~/.ronin/console.log*
	History log for the Ronin Console.

*~/.ronin/database.log*
	Database log.

*~/.ronin/database.sqlite3*
	The default sqlite3 Database file.

*~/.ronin/database.yml*
	Optional Database configuration.

## ENVIRONMENT

HOME
	Specifies the home directory of the user. Ronin will search for the
	*~/.ronin/* configuration directory within the home directory.

EDITOR
	Specifies the editor to use when invoking the `.edit` console command.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin(1)
