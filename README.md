# ronin

[![CI](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin.svg)](https://codeclimate.com/github/ronin-rb/ronin)

* [Website](https://ronin-rb.dev)
* [Source](https://github.com/ronin-rb/ronin)
* [Issues](https://github.com/ronin-rb/ronin/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [IRC](https://ronin-rb.dev/irc/)

## Description

Ronin is a [Ruby] platform for vulnerability research and [exploit development].
Ronin allows for the rapid development and distribution of code,
[Exploits][example-exploit], [Payloads][example-payload],
[Scanners][example-scanner], etc, via [Repositories].

### Console

Ronin provides users with a powerful Ruby Console, pre-loaded with powerful
convenience methods. In the Console one can work with data and automate
complex tasks, with greater ease than the command-line.

    >> File.read('data').base64_decode

### Database

Ronin ships with a preconfigured Database, that one can interact with from Ruby,
without having to write any SQL.

    >> HostName.tld('eu').urls.with_query_param('id')

### Repositories

Ronin provides a Repository system, allowing users to organize and share
miscallaneous Data, Code, [Exploits][example-exploit],
[Payloads][example-payload], [Scanners][example-scanner], etc.

    $ ronin install git://github.com/user/myexploits.git

### Libraries

Ronin provides libraries with additional functionality, such as
[Exploitation][ronin-exploits] and [Scanning][ronin-scanners]:

    $ gem install ronin-exploits

## Features

* Supports installing/updating/uninstalling of Repositories.
  * Supports installing Repositories from various media types:
    * [Subversion (SVN)][svn]
    * [Mercurial (Hg)][hg]
    * [Git][git]
    * Rsync
* Provides a Database using [DataMapper] with:
  * {Ronin::Author}
  * {Ronin::License}
  * {Ronin::Arch}
  * {Ronin::OS}
  * {Ronin::Software}
  * {Ronin::Vendor}
  * {Ronin::Address}
    * {Ronin::MACAddress}
    * {Ronin::IPAddress}
    * {Ronin::HostName}
  * {Ronin::Port}
    * {Ronin::TCPPort}
    * {Ronin::UDPPort}
  * {Ronin::Service}
  * {Ronin::OpenPort}
  * {Ronin::OSGuess}
  * {Ronin::UserName}
  * {Ronin::URL}
  * {Ronin::EmailAddress}
  * {Ronin::Credential}
    * {Ronin::ServiceCredential}
    * {Ronin::WebCredential}
  * {Ronin::Organization}
  * {Ronin::Campaign}
  * {Ronin::Target}
* Caches exploits, payloads, scanners, etc stored within Repositories
  into the Database.
* Convenience methods provided by [ronin-support].
* Provides a customized Ruby Console using [Ripl][ripl] with:
  * Syntax highlighting.
  * Tab completion.
  * Auto indentation.
  * Pretty Printing (`pp`).
  * `print_info`, `print_error`, `print_warning` and `print_debug`
    output helper methods with color-output.
  * Inline commands (`!nmap -v -sT victim.com`)
* Provides an extensible command-line interface.

## Synopsis

Start the Ronin console:

    $ ronin

Run a Ruby script in Ronin:

    $ ronin exec script.rb

View available commands:

    $ ronin help

View a man-page for a command:

    $ ronin help wordlist

Install a Repository:

    $ ronin install svn://example.com/path/to/repo

List installed Repositories:

    $ ronin repos

Update all installed Repositories:

    $ ronin update

Update a specific Repositories:

    $ ronin update repo-name

Uninstall a specific Repositories:

    $ ronin uninstall repo-name

List available Databases:

    $ ronin database

Add a new Database:

    $ ronin database --add team --uri mysql://user:pass@vpn.example.com/db

Remove a Database:

    $ ronin database --remove team

## Requirements

* [Ruby] >= 1.9.1
* [DataMapper]:
  * [dm-sqlite-adapter] ~> 1.2
    * [libsqlite3]
  * [dm-core] ~> 1.2
  * [dm-types] ~> 1.2
  * [dm-migrations] ~> 1.2
  * [dm-validations] ~> 1.2
  * [dm-aggregates] ~> 1.2
  * [dm-timestamps] ~> 1.2
* [dm-is-predefined] ~> 0.4
* [uri-query_params] ~> 0.6
* [open_namespace] ~> 0.4
* [data_paths] ~> 0.3
* [object_loader] ~> 1.0
* [parameters] ~> 0.4
* [pullr] ~> 0.1, >= 0.1.2
* [ripl] ~> 0.3
* [ripl-multi_line] ~> 0.2
* [ripl-auto_indent] ~> 0.1
* [ripl-short_errors] ~> 0.1
* [ripl-color_result] ~> 0.3
* [ronin-support] ~> 0.5

## Install

    $ gem install ronin

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin/fork)
2. Clone It!
3. `cd ronin`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of ronin.

Ronin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[exploit development]: https://www.exploit-db.com
[example-exploit]: https://github.com/ronin-rb/example-repo/blob/master/scripts/exploits/http/oracle/dav_bypass.rb
[example-payload]: https://gist.github.com/1403961
[example-scanner]: https://github.com/ronin-rb/example-repo/blob/master/scripts/scanners/oracle_dad_scanner.rb
[Repositories]: https://github.com/ronin-rb/example-repo

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-scanners]: https://github.com/ronin-rb/ronin-scanners#readme

[svn]: https://subversion.apache.org/
[hg]: https://www.mercurial-scm.org/
[git]: https://git-scm.com/

[DataMapper]: http://datamapper.org
[dm-sqlite-adapter]: https://github.com/datamapper/dm-sqlite-adapter#readme
[libsqlite3]: https://sqlite.org/
[dm-core]: https://github.com/datamapper/dm-core#readme
[dm-types]: https://github.com/datamapper/dm-types#readme
[dm-migrations]: https://github.com/datamapper/dm-migrations#readme
[dm-validations]: https://github.com/datamapper/dm-validations#readme
[dm-aggregates]: https://github.com/datamapper/dm-aggregates#readme
[dm-timestamps]: https://github.com/datamapper/dm-timestamps#readme
[dm-is-predefined]: https://github.com/postmodern/dm-is-predefined#readme
[uri-query_params]: https://github.com/postmodern/uri-query_params#readme
[open_namespace]: https://github.com/postmodern/open_namespace#readme
[data_paths]: https://github.com/postmodern/data_paths#readme
[object_loader]: https://github.com/postmodern/object_loader#readme
[parameters]: https://github.com/postmodern/parameters#readme
[pullr]: https://github.com/postmodern/pullr#readme
[ripl]: https://github.com/cldwalker/ripl#readme
[ripl-multi_line]: https://github.com/janlelis/ripl-multi_line#readme
[ripl-auto_indent]: https://github.com/janlelis/ripl-auto_indent#readme
[ripl-short_errors]: https://rubygems.org/gems/ripl-short_errors
[ripl-color_result]: https://github.com/janlelis/ripl-color_result#readme
[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
