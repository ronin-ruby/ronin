# ronin-install 1 "APRIL 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin install` [*options*] *URI*

## DESCRIPTION

Installs Ronin Repositories.

## ARGUMENTS

*URI*
	The URI of the Repository to be installed.

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`--[no-]rsync`
	Installs the Repository using Rsync.

`--[no-]svn`
	Installs the Repository using SubVersion (SVN).

`--[no-]hg`
	Installs the Repository using Mercurial (Hg).

`--[no-]git`
	Installs the Repository using Git.

## FILES

*~/.ronin/*
	Ronin configuration directory.

*~/.ronin/repos/*
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

## EXAMPLES

`ronin install git://github.com/user/repo.git`
	Installs a Ronin Repository using git.

`ronin install --git git@example.com:/home/secret/repo`
	Installs a Ronin Repository using git over ssh.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-repos(1) ronin-uninstall(1) ronin-update(1)
