# ronin-repos 1 "APRIL 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin repos` [*options*] [*REPO*]

## DESCRIPTION

Lists Ronin Repositories.

## ARGUMENTS

*REPO*
	The name of the Repository to list.

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-D`, `--database` *URI*
	The database to URI (`mysql://user:password@host/ronin`).

`--domain` *DOMAIN*
	Searches for Repositories installed from the DOMAIN.

`-n`, `--named` *NAME*
	Searches for Repositories with the given NAME.

`-t`, `--titled` *TITLE*
	Searches for Repositories with the similar TITLE.

`-d`, `--describing` *DESCRIPTION*
	Searches for Repositories with the similar DESCRIPTION.

`-L`, `--licensed-under` *LICENSE*
	Searches for Repositories with the given LICENSE (`MIT`).

## FILES

*~/.ronin/*
	Ronin configuration directory.

*~/.ronin/repos*
	Installation directory for Ronin Repositories.

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

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-install(1) ronin-uninstall(1) ronin-update(1)
