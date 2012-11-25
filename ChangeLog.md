### 1.5.1 / 2021-02-28

* Require [ronin-support] ~> 0.5, >= 0.5.2.
* Support Ruby 3.0:
  * {Ronin::UI::CLI.commands} now uses `Set`, since Ruby 3.0 moved `SortedSet`
    out of the stdlib.
* Activate bundler in `bin/ronin` and `bin/ronin-*` commands, if a
  `Gemfile.lock` file is found.
* Re-finalize all DataMapper models in
  {Ronin::AutoLoad::ClassMethods#require_const}.
* Avoid calling `Ronin::Network::TCP::Proxy` specific methods in the
  `ronin net:proxy` command, if working with a UDP proxy.

### 1.5.0 / 2012-06-16

* Require [ronin-support] ~> 0.5.
* Added {Ronin::UI::CLI::Command#setup}.
* Added {Ronin::UI::CLI::Command#cleanup}.
* Added {Ronin::UI::CLI::Command.examples}.
* Added the {Ronin::UI::CLI::Commands::Net::Proxy net:proxy} ronin command.
* Added man-pages for each `ronin` command.
* Added more specs for the {Ronin::UI::CLI::Command} DSL methods.
* Added {Ronin::AutoLoad::ClassMethods#require_const}, to also
  finalize auto-loaded DataMapper models.
* Renamed `Ronin::Database.setup_log` to {Ronin::Database.log}.
* Allow {Ronin::Database.setup} to accept a URI for the `default` repository.
* Allow `ronin/spec/database` to test against other Databases,
  specified by the `ADAPTER` environment variable.
  * If `ADAPTER` is set to `mysql` or `postgres`, then `ronin/spec/database`
    will connect to the `ronin_test` database with username/password
    `ronin_test`.
  * By default `ronin/spec/database` will test against a temporary sqlite3
    database.
* Allow console `!command`s to embed Ruby expressions:

        >> !ncat #{ip} #{port}

* Moved console `!command` logic into {Ronin::UI::Console::Shell}.
  * `!command`s now only execute shell commands.
* Moved console `.command` logic into {Ronin::UI::Console::Commands}.
  * `.command`s are now reserved only for special console commands
    (ex: `.edit`).
* Improved recognition of console `!command`s and `.command`s.
* Do not allow execution of console commands while in multi-line mode!
* Fixed a bug in {Ronin::UI::CLI::Command} which disabled colour output.
* When {Ronin::UI::CLI::Command#start} catches an Interrupt, it should exit
  with status 130.
* Rescue `Errno::EPIPE` in {Ronin::UI::CLI::Command#start}.
* Improved `--help` output of `ronin` commands by adding `examples` and more
  `:description`s to their options.
* Changed the `ronin-help COMMAND` to display the man-page for the given
  command.
* No longer honor the `DEBUG` environment variable. Use `ruby -w` or `ruby -d`
  instead.
* Removed dm-constraints from the dependencies.

### 1.4.1 / 2012-04-01

* Removed dependencey on env.
* Removed `#to_ary` methods from Ronin Models that were causing
  `SystemStackError: stack level too deep` exceptions. Fixes issue #4.
* {Ronin::UI::CLI::Command#start} now rescues Interupts.

### 1.4.0 / 2012-02-12

* Require open_namespace ~> 0.4.
* Require parameters ~> 0.4.
* Require uri-query_params ~> 0.6.
* Require [ronin-support] ~> 0.4.
* Added {Ronin::Port.parse}.
* Added {Ronin::Port.from}.
* Added {Ronin::EmailAddress.from}.
* Added {Ronin::Password.parse}.
* Added {Ronin::URL#inspect}.
* Added {Ronin::Model::HasUniqueName::ClassMethods#parse}.
* Added {Ronin::Script::ClassMethods#short_name}.
* Added {Ronin::Script::Buildable#build_failed!}.
* Added {Ronin::Script::Path#clean}.
* Added {Ronin::Script::Path#destroy!}.
* Added {Ronin::UI::CLI::Command.usage}.
* Added {Ronin::UI::CLI::Command.summary}.
* Added {Ronin::UI::CLI::Command.option}.
* Added {Ronin::UI::CLI::Command.options}.
* Added {Ronin::UI::CLI::Command.options?}.
* Added {Ronin::UI::CLI::Command.each_option}.
* Added {Ronin::UI::CLI::Command.argument}.
* Added {Ronin::UI::CLI::Command.arguments}.
* Added {Ronin::UI::CLI::Command.arguments?}.
* Added {Ronin::UI::CLI::Command.each_argument}.
* Added {Ronin::UI::CLI::Command#start}.
* Added {Ronin::UI::CLI::Command#run}.
* Added {Ronin::UI::CLI::Command#option_parser}.
* Added {Ronin::UI::CLI::Printing}.
* Added {Ronin::UI::CLI::ClassCommand}.
* Added {Ronin::UI::CLI::ScriptCommand#setup}.
* Re-added the `ronin install` command.
* Re-added the `ronin uninstall` command.
* Re-added the `ronin update` command.
* Renamed `Ronin::URL.query_param` to {Ronin::URL.with_query_param}.
* Renamed `Ronin::URL.query_value` to {Ronin::URL.with_query_value}.
* Renamed `Ronin::Repository.add!` to {Ronin::Repository.add}.
* Renamed `Ronin::Repository.install!` to {Ronin::Repository.install}.
* Renamed `Ronin::Repository.uninstall!` to {Ronin::Repository.uninstall}.
* Renamed `Ronin::UI::CLI::ScriptCommand#load_script` to
  {Ronin::UI::CLI::ScriptCommand#load!}.
* Renamed `Ronin::UI::CLI::Commands::IPs` to
  {Ronin::UI::CLI::Commands::Ips}.
* Renamed `Ronin::UI::CLI::Commands::URLs` to
  {Ronin::UI::CLI::Commands::Urls}.
* Removed thor from the dependencies.
* Removed `Ronin::Script::InstanceMethods#script_type` in favor of
  {Ronin::Script::ClassMethods#short_name}.
* Have {Ronin::AutoLoad} call `finalize` directly on the newly auto-loaded
  model.
* Associate {Ronin::EmailAddress} with {Ronin::Credential}.
* Ensure that all {Ronin::Script}s have unique name/version properties.
* Include {Ronin::Model::HasName}, {Ronin::Model::HasTitle},
  {Ronin::Model::HasDescription} into {Ronin::Repository}.
* Refactored {Ronin::UI::CLI::Command} to use
  [Parameters::Options](http://rubydoc.info/gems/parameters/0.4.0/Parameters/Options)
  from parameters 0.4.0.
* {Ronin::UI::CLI::Command#start} now rescues and prints exceptions, then
  exits with status `-1`.
* {Ronin::UI::CLI::ScriptCommand} may now accept additional options for the
  loaded script after `--`:

      ronin exploit -f myexploit.rb -- --host victim.com --port 1337

* Fixed a typo in the `ronin repos` command.
* The `ronin repos` command now only lists installed Repositories.
* `Ronin::Support` is now included into {Ronin}, making all support methods
  accessible in the `ronin` console.
* Allow `ronin` console commands to be prefixed with a `.`.

### 1.3.0 / 2011-10-16

* Require DataMapper ~> 1.2.
* Require [ronin-support] ~> 0.3.
* Added {Ronin::Model::Importable}.
* Added {Ronin::MACAddress.extract}.
* Added {Ronin::IPAddress.extract}.
* Added {Ronin::HostName.extract}.
* Added {Ronin::URL.extract}.
* Added {Ronin::EmailAddress.extract}.
* Renamed `license!` to `licensed_under` in
  {Ronin::Model::HasLicense::InstanceMethods}.
* Moved `Ronin::UI::Output`, `Ronin::UI::Shell` and `Ronin::Network::Mixins`
  into [ronin-support].
* {Ronin::Author.site} and {Ronin::License.url} now use the URI property.
* Merged `Ronin::UI::CLI::ModelCommand.query_model` into
  {Ronin::UI::CLI::ModelCommand.model}.

### 1.2.0 / 2011-08-15

* Require dm-is-predefined ~> 0.4.
* Added {Ronin::UI::Console::Context}.
* Added custom tab-completion to {Ronin::UI::Console} for:
  * {Ronin::IPAddress}
  * {Ronin::HostName}
  * {Ronin::EmailAddress}
  * {Ronin::URL}
  * Paths
  * Commands
* Added the ability to run commands in Ronin Console, via the
  `!command --args` syntax.
* Added custom `!command`s to the Ronin Console:
  * `!edit` - Edits a Ruby tempfile and loads the contents afterwards.
  * `!cd` - Changes the current working directory and updates
    `ENV['OLDPWD']`.
  * `!export` - Sets `ENV` variables.
* Added an index to {Ronin::OS.version}.
* Refactored {Ronin::OS.predefine} using dm-is-predefined.
* Fixed a bug in {Ronin::UI::Console.setup} where the wrong binding was
  being passed to Ripl.

### 1.1.0 / 2011-07-04

* Require env ~> 0.2.
* Require data_paths ~> 0.3.
* Require [ronin-support] ~> 0.2.
* Added `ronin/repositories`, for quickly loading all repositories.
* Added {Ronin#script}.
* Added {Ronin::AutoLoad}.
* Added {Ronin::Arch.arm}.
* Added {Ronin::Arch.mips}.
* Added {Ronin::Arch.x86}.
* Added {Ronin::URLQueryParamName}.
* Added timestamps to {Ronin::Campaign}.
* Added the `created_at` timestamp to {Ronin::Target}.
* Added `Ronin::Network::Mixins::HTTP#http_status`.
* Added `Ronin::Network::Mixins::HTTP#http_ok?`.
* Added `Ronin::Network::Mixins::HTTP#http_server`.
* Added `Ronin::Network::Mixins::HTTP#http_powered_by`.
* Added `print_info` method calls to `Ronin::Network::Mixins::HTTP`.
* Added {Ronin::Script::InstanceMethods#run}.
* Added {Ronin::Script::Exception}.
* Added {Ronin::Script::Path#to_s}.
* Added {Ronin::Script::ClassMethods#load_from}.
* Added {Ronin::Repository#find_script}.
* Added {Ronin::UI::CLI::Command#setup}.
* Added {Ronin::UI::CLI::ResourcesCommand}.
* Added {Ronin::UI::CLI::ScriptCommand}.
* Added the `--database` option to {Ronin::UI::CLI::ModelCommand}.
* Renamed `Ronin::Engine` to {Ronin::Script}.
* Renamed `Ronin::Engine::Verifiable` to {Ronin::Script::Testable}.
* Renamed `Ronin::Engine#engine_name` to
  `Ronin::Script::InstanceMethods#script_type`.
* Renamed `Ronin::Engine::InstanceMethods#load_original!` to
  {Ronin::Script::InstanceMethods#load_script!}.
* Renamed `Ronin::CachedFile` to {Ronin::Script::Path}.
* Renamed `Ronin::UI::CLI::ModelCommand.model=` to
  {Ronin::UI::CLI::ModelCommand.model}.
* Renamed `Ronin::UI::CLI::ModelCommand#model` to
  `Ronin::UI::CLI::ModelCommand.query_model`.
* Renamed `Ronin::UI::CLI::ModelCommand#new_query` to
  {Ronin::UI::CLI::ModelCommand#query}.
* Renamed `Ronin::UI::CLI::ModelCommand#print_resource` to
  {Ronin::UI::CLI::ResourcesCommand#print_resource}.
* Renamed `Ronin::UI::CLI::ModelCommand#print_resources` to
  {Ronin::UI::CLI::ResourcesCommand#print_resources}.
* Removed `Ronin::Engine#method_missing`.
* Extend `DataPaths::Finders` into {Ronin::Config}.
* Fixed a RubyGems deprecation in {Ronin::Installation}.
* Enabled verbose DataMapper logging if `$DEBUG` or the `DEBUG`
  environment variable are set.
* Switched from DataMapper URIs to Hashes.
* Fixed a bug in {Ronin::Database::Migrations::Migration#initialize}, where
  `:needs` was being overridden.
* Group Database migration files by {Ronin::VERSION}.
* Ensure that {Ronin::Database::Migrations} preserves the order of loaded
  migrations.
* Set the length of {Ronin::Password.clear_text} to 256.
* Set the length of {Ronin::License.url} to 256.
* Merged `Ronin::Model::Cacheable` into {Ronin::Script}.
* Repositories can now cache/load scripts from the `scripts/` directory.
* Disable {Ronin::UI::Console.short_errors?} if the `VERBOSE` environment
  variable is set.
* Disable `Ronin::UI::Console.color?` if the `STDOUT` is a tty.
* Set `Ronin::UI::Output.handler` to `Ronin::UI::Output::Terminal::Raw`,
  when `STDOUT` is not a tty.
* Enable `Ronin::UI::Output.verbose?` if `$VERBOSE` or `$DEBUG` are set.
* {Ronin::UI::CLI::ModelCommand#setup} now automatically calls
  {Ronin::Database.setup}, before executing the command.
* Merged `query_method` into {Ronin::UI::CLI::ModelCommand#query}.
* Allow {Ronin::UI::CLI::ModelCommand.query_option} to map to Model
  properties.
* Use DataMapper query-paths to improve performance of query-helper methods.
* Removed `Ronin::Target#directory`.

### 1.0.0 / 2011-03-25

* Upgraded to the GPL-3 license.
* Require Ruby >= 1.8.7.
* Require dm-do-adapter ~> 1.1.0.
* Require dm-sqlite-adapter ~> 1.1.0.
* Require dm-core ~> 1.1.0.
* Require dm-types ~> 1.1.0.
* Require dm-constraints ~> 1.1.0.
* Require dm-migrations ~> 1.1.0.
* Require dm-validations ~> 1.1.0.
* Require dm-serializer ~> 1.1.0.
* Require dm-aggregates ~> 1.1.0.
* Require dm-timestamps ~> 1.1.0.
* Require dm-is-predefined ~> 0.3, >= 0.3.1.
* Require uri-query_params ~> 0.5, >= 0.5.2.
* Require open_namespace ~> 0.3.
* Require parameters ~> 0.2, >= 0.2.3.
* Require data_paths ~> 0.2, >= 0.2.1.
* Require object_loader ~> 1.0.
* Require env ~> 0.1, >= 0.1.2.
* Require pullr ~> 0.1, >= 0.1.2.
* Require hexdump ~> 0.1.
* Require ripl ~> 0.3.
* Require ripl-multi_line ~> 0.2.
* Require ripl-auto_indent ~> 0.1.
* Require ripl-short_errors ~> 0.1.
* Require ripl-color_result ~> 0.2.
* Require thor ~> 0.14.3.
* Require [ronin-support] ~> 0.1.
* Added `ronin/bootstrap` which only loads configuration and the Database.
* Added {Ronin::Database::Migrations}.
* Added {Ronin::Model::HasUniqueName}.
* Added {Ronin::Address}:
  * Added {Ronin::MACAddress}.
  * Added {Ronin::IPAddress}.
  * Added {Ronin::HostName}.
* Added {Ronin::Port}:
  * Added {Ronin::TCPPort}.
  * Added {Ronin::UDPPort}.
* Added {Ronin::Service}.
* Added {Ronin::OpenPort}.
* Added {Ronin::OSGuess}.
* Added {Ronin::UserName}.
* Added {Ronin::URL}:
  * Added {Ronin::URLScheme}.
  * Added {Ronin::URLQueryParam}.
* Added {Ronin::EmailAddress}.
* Added {Ronin::Credential}.
* Added {Ronin::ServiceCredential}.
* Added {Ronin::WebCredential}.
* Added {Ronin::Organization}.
* Added {Ronin::Campaign}.
* Added {Ronin::Target}.
* Added `Ronin::Engine`.
* Added `Ronin::UI::Output::Terminal::Raw`.
* Added `Ronin::UI::Output::Terminal::Color`.
* Added the `ronin-repos` command for listing, adding, installing and
  uninstalling Repositories.
* Added the `ronin-exec` command for running Ruby scripts (local files
  or `bin/` scripts in Repositories) within the Ronin environment.
* Added the `ronin-ips` command for listing, importing and exporting
  IP addresses from the Database.
* Added the `ronin-hosts` command for listing, importing and exporting
  host names from the Database.
* Added the `ronin-urls` command for listing, importing and exporting
  URLs from the Database.
* Added the `ronin-emails` command for listing, importing and exporting
  Email addresses from the Database.
* Added the `ronin-creds` command for listing, importing and exporting
  credentials from the Database.
* Added the `ronin-campaigns` command for listing, importing and exporting
  Campaigns from the Database.
* Renamed `Ronin::Product` to {Ronin::Software}.
* Renamed `Ronin::UI::CommandLine` to {Ronin::UI::CLI}.
* Renamed `Ronin::Platform::Overlay` to {Ronin::Repository}.
* Renamed `Ronin::Platform::CachedFile` to `Ronin::CachedFile`.
* Renamed `Ronin::Platform::Cacheable` to `Ronin::Model::Cacheable`.
* Removed `Ronin::Platform::Extension`.
* Removed `Ronin::Platform`.
* Moved the `ronin-add`, `ronin-install`, `ronin-list` and `ronin-uninstall`
  commands into the `ronin-repos` command.
* Switched from [Jeweler](https://github.com/technicalpickles/jeweler)
  to [Ore](http://github.com/ruby-ore/ore) and [Bundler](http://gembundler.com).
* Use [OpenNamespace](http://github.com/postmodern/open_namespace) to auto-load
  everything in the {Ronin} namespace.
* Switched from DataMapper auto-migrations to explicit-migrations.
* Switched {Ronin::UI::Console} from IRB to
  [Ripl](https://github.com/cldwalker/ripl):
  * Enabled result coloring with
    [ripl-color_result](https://github.com/janlelis/ripl-color_result).
  * Enabled short errors with
    [ripl-short_error](https://github.com/janlelis/ripl-misc/blob/master/lib/ripl/short_errors.rb).

### 0.3.0 / 2009-09-24

* Require yard >= 0.2.3.5.
* Require nokogiri >= 1.3.3.
* Require extlib >= 0.9.13.
* Require data_objects >= 0.10.0.
* Require do_sqlite3 >= 0.10.0.
* Require dm-core >= 0.10.0.
* Require dm-types >= 0.10.0.
* Require dm-validations >= 0.10.0.
* Require dm-predefined >= 0.2.0.
* Require chars >= 0.1.2.
* Require parameters >= 0.1.8.
* Require contextify >= 0.1.3.
* Require repertoire >= 0.2.3.
* Require thor >= 0.11.5.
* Require rspec >= 1.1.12.
* Moved to YARD based documentation.
* Added YARD handlers for detecting DataMapper property, has and belongs_to
  method-calles.
* Added YARD handlers for detecting Ronin::Scanners::Scanner.scanner
  method-calles.
* Added Ronin::Config.tmp_dir.
* Added Kernel.require_within.
* Added Net.tcp_server.
* Added Net.tcp_server_session.
* Added Net.tcp_single_server.
* Added Net.udp_server.
* Added Net.udp_server_session.
* Added Ronin::Network::HTTP::Proxy.
* Added Ronin::Model#humanize_attributes.
* Added Ronin::Model::HasVersion.revision.
* Added Ronin::Templates::Template.
* Added Ronin::Platform::Overlay#gems.
* Added attr_reader, attr_writer and attr_accessor instance methods to
  Ronin::Platform::Extension.
* Added Ronin::Platform::Overlay#load!.
* Added Ronin::Platform::Overlay#reload!.
* Added Ronin::Platform::Extension#tmp_dir.
* Added Ronin::Platform::ExtensionCache#reload!.
* Added Ronin::Platform.reload!.
* Added Ronin::UI::Output.verbose=.
* Added Ronin::UI::Output.verbose?.
* Added Ronin::UI::Output.quiet=.
* Added Ronin::UI::Output.quiet?.
* Added Ronin::UI::Output.silent=.
* Added Ronin::UI::Output.silent?.
* Added Ronin::UI::Output::Helpers.
* Added Ronin::UI::CommandLine::Command#indent.
* Added Ronin::UI::CommandLine::Command#print_title.
* Added Ronin::UI::CommandLine::Command#print_array.
* Added Ronin::UI::CommandLine::Command#print_hash.
* Renamed Ronin::License.gpl_2 to Ronin::License.gpl2.
* Renamed Ronin::License.gpl_3 to Ronin::License.gpl3.
* Renamed Ronin::License.lgpl_3 to Ronin::License.lgpl3.
* Renamed the :post_data option to :postdata for the Net.http_post and
  Net.http_post_body methods.
* Renamed Ronin::Sessions to Ronin::Network::Helpers.
* Renamed Ronin::Platform::ExtensionCache#has_extension? to
  Ronin::Platform::ExtensionCache#has?.
* Renamed Ronin::Platform::ExtensionCache#extension_with to
  Ronin::Platform::ExtensionCache#with.
* Renamed Ronin::UI::Diagnostics to Ronin::UI::Output.
* Removed Hash#explode.
* Removed URI::HTTP#explode_query_params and URI::HTTP#test_query_params.
* Removed Ronin::Model.first_or_new, since it is provided by
  dm-core 0.10.0.
* Removed Ronin.console.
* Removed Ronin::License.predefine.
* Updated the summary and 3-point description of Ronin.
* Aliased Integer#char to Integer#chr.
* Changed Ronin::Database::DEFAULT_CONFIG to be a String, for printability.
* Overrode Ronin::Model.allocate so that the initialize method of models
  is always called when resources are allocated.
* Improved the white-space removal in Ronin::Model::HasDescription.
* Have Ronin::Model::HasLicense auto-define a relationship with
  Ronin::License.
* Fixed formatting issue in Ronin::Product#to_s.
* Allow Ronin::Cacheable.load_first to accept a block.
* Make sure Ronin::Static.directory raises a RuntimeError if the given
  directory is missing or not a directory.
* Allow the :proxy option passed to Net.http_* methods to be a String,
  Hash or Ronin::Network::HTTP::Proxy.
* Make sure Ronin::Network::Helpers::Helper.require_variable raises
  a RuntimeError if the required instance variable is not set.
* Merged Ronin::Platform::Extension.load into
  Ronin::Platform::ExtensionCache#load_extension.
* Updated the overlay.xsl used to render the ronin.xml files within
  Overlays.
* Merged Ronin::UI::Verbose into Ronin::UI::Output.
* Rewrote Ronin::UI::CommandLine::Command to inherit from Thor.
* Rewrote the Ronin::UI::CommandLine commands to use Thor options.
* Include Ronin::UI::Output::Helpers into Ronin::Sessions::Session.
* Include Ronin::UI::Output::Helpers into Ronin::Console sessions.

### 0.2.4 / 2009-07-02

* Require Hoe >= 2.0.0
* Require Parameters >= 0.1.6.
* Dropped dependency for dm-serializer.
* Added Kernel#catch_all.
* Added Array#bytes.
* Added Array#chars.
* Added Array#char_string.
* Added File.unhexdump.
* Added Ronin::Templates::Erb.
* Added Ronin::Model::HasName.
* Added Ronin::Model::HasDescription.
* Added Ronin::Model::HasVersion.
* Added Cacheable#prepared_for_cache?.
* Added Cacheable#original_loaded?.
* Added Network::HTTP.expand_options.
* Added Net.http_request.
* Added Sessions::HTTP#http_request.
* Added Ronin::Scanners::Scanner.
* Added Ronin::UI::Console.backtrace_depth.
* Added Ronin::UI::Console.backtrace_depth=.
* Moved Ronin::HasLicense into Ronin::Model.
* Renamed Kernel#try to Kernel#attempt.
* Renamed Ronin.method_missing to Ronin#method_missing.
* Renamed Ronin::UI::CommandLine::Commands::Ls to
  Ronin::UI::CommandLine::Commands::List.
* Renamed Ronin::UI::CommandLine::Commands::Rm to
  Ronin::UI::CommandLine::Commands::Remove.
* Refactored OS.define.
* Refactored Ronin::Shell as a module.
* Removed Ronin::Translators.
* Fixed a bug where if an object failed to be cached,
  it would prevent an Overlay from being added to the
  OverlayCache.
* Fixed a bug where Gem::LoadError was being rescued,
  when only ::LoadError should be rescued.
* Fixed a typo in Maintainer#inspect.
* Updated the Overlay XSL file.
  * Cleaned up CSS.
  * Removed the jQuery expander plugin.

### 0.2.3 / 2009-05-06

* Require extlib >= 0.9.12.
* Require dm-core >= 0.9.11.
* Require data_objects >= 0.9.11.
* Require do_sqlite3 >= 0.9.11.
* Require dm-types >= 0.9.11.
* Require dm-serializer >= 0.9.11.
* Require dm-validations >= 0.9.11.
* Require chars >= 0.1.1.
* Require parameters >= 0.1.5.
* No longer require dm-aggregates.
* Added Kernel#try.
* Added String#pad.
* Added Array#power_set.
* Added IPAddr#each for iterating over CIDR address ranges.
* Added IPAddr.each for iterating over CIDR and globbed address ranges.
* Added Net.http_powered_by that returns the HTTP X-Powered-By header.
* Added Net.http_server that returns the HTTP Server header.
* Added Database.setup?.
* Added Database.update!.
* Added Extension#exposed_methods.
* Added ExtensionCache#names.
* Added OverlayCache#names.
* Added Diagnostics#print_debug.
* Added more specs.
* Properly escape URI::HTTP#query_params.
* Fixed a bug in File.hexdump where the file was not being closed.
* Fixed a bug in HasLicense#licensed_under.
* Fixed a bug in Product#to_s.
* Moved Ronin::Target to the ronin-exploits library.
* Renamed Net.http_prop_path to Net.http_prop_patch.
* Removed the Parameters code from Ronin::Sessions.
* Replaced Ronin::Objectify with Ronin::Cacheable.
* Removed 'ronin/models'.
* Catch exceptions when loading Extensions and carry on.
* Renamed Overlay#deactive! to Overlay#deactivate!.
* Allow Overlays to automatically load the 'lib/init.rb' file when
  activated.
* Rewrote Ronin::Platform::ObjectCache to use the new Ronin::Cacheable
  module.
* Enable Diagnostic#print_info and Diagnostic#print_error by default.
* Refactored Ronin::UI::CommandLine:
  * Added CommandLine.get_command which loads command classes on-demand.
  * CommandLine.commands now stores all the available command names.
  * Renamed Ronin::UI::CommandLine::Commands::LS to
    Ronin::UI::CommandLine::Commands::Ls.
  * Renamed Ronin::UI::CommandLine::Commands::RM to
    Ronin::UI::CommandLine::Commands::Rm.
  * Moved Ronin::UI::CommandLine::ParamParser into the Parameters library.
* Refactored specs to run on Ruby 1.9.1-p0.
* Added more specs.
* All specs now pass on Ruby 1.9.1-p0.

### 0.2.2 / 2009-03-26

* Split out Ronin::Chars into the Chars library.
* Split out ronin-overlay and ronin-ext sub-commands into the Ronin Gen
  library.
* Require chars >= 0.1.0.
* Require repertoire >= 0.2.1.
* Removed String#to_method_name, use Extlib instead.
* Refactored Ronin::Platform::Overlay.
  * Renamed Overlay#media_type to Overlay#media.
  * Fixed parsing bugs in Overlay#initialize_metadata.
* Allow Extensions to be accessed via constants.
* Added the Creative Commons Zero license to Ronin::License.
* Added the Integer#bytes method.
* Added the String#hex_unescape method.
* Added the String#unhexdump method.
* Added Ronin::Static for managing static resources.
* Added Ronin::Static::Finders for searching for static files.
* Added static directories to Overlays and Extensions.
* Added ronin/platform/tasks:
  * Added ronin/platform/tasks/spec task for running RSpec tests in an
    Overlay.
* Added the ExtensionCache#reload! method.
* Added more specs.

### 0.2.1 / 2009-02-23

* Added Ronin::UI::Verbose.
* Require Nokogiri >= 1.2.0:
  * Use Nokogiri::XML, instead of REXML, for XML parsing and building.
* Renamed String#inspect to String#dump.
  * Aliased String#inspect to String#dump.
* Rewrote Ronin::UI::CommandLine.
  * Removed Ronin::UI::CommandLine::Options.command.
  * Refactored Ronin::UI::CommandLine::Command.
    * Added Command#defaults method to give the command's variables
      default values.
    * Fixed a bug in Command.run.
  * Renamed DefaultCommand to ConsoleCommand.
  * Implement git style sub-commands.
  * Use reverse-require to find sub-commands.
* Refactored Ronin::UI::ParamParser.
  * Control parameter formats and their parsers with ParamParser.recognize.
* Rewrote the Ronin::Chars spec.
* Updated the Ronin::UI::ParamParser spec.

=== 0.2.0 / 2009-02-06

* Moved the HTML formatting methods into the
  [ronin-html](http://ronin.rubyforge.org/html/) library.
* Added 'ronin/environment' which loads the Ronin Environment.
* Added the --database option to the DefaultCommand.
* Added the -C option to the add, install, list, update, remove and
  uninstall commands.
* Added String#hex_escape.
* Added Net.http_ok?.
* Added UI::Diagnostics.
* Require Contextify >= 0.1.2 for the self.load_context_block method.
* Renamed Platform to Ronin::OS.
* Renamed Cache to Ronin::Platform.
* Refactored Ronin::Platform:
  * Added Overlay#activate!.
  * Added Overlay#deactivate!.
  * Added a title attribute to Ronin::Platform::Overlay.
  * Added a dirty flag to Ronin::Platform::OverlayCache to reduce
    unnecessary writes.
  * Added OverlayCache#has_extension?.
  * Added Ronin::Platform::ObjectCache to handle the mass caching/mirroring
    of object contexts.
  * Added Platform.add.
  * Added Platform.install.
  * Added Platform.update.
  * Added Platform.remove.
  * Added Platform.uninstall.
  * Added Platform::Extension#find_paths.
  * Added specs for:
    * Ronin::Platform.
    * Ronin::Platform::Overlay.
    * Ronin::Platform::OverlayCache.
    * Ronin::Platform::Extension.
    * Ronin::Platform::ExtensionCache.
  * Shortened method names.
    * Renamed OverlayCache#has_overlay? to OverlayCache#has?.
    * Renamed OverlayCache#get_overlay to OverlayCache#get.
    * Renamed OverlayCache#overlay_with to OverlayCache#with.
    * Renamed Extension#was_setup? to Extension#setup?.
    * Renamed Extension#was_toredown? to Extension#toredown?.
    * Renamed Extension#perform_setup to Extension#setup!.
    * Renamed Extension#perform_teardown to Extension#teardown!.
  * Removed un-used or surpurfulous methods.
  * Removed 'lib/ronin/platform/config.rb'.
  * Allow Overlays to have their own `lib/` directories.
  * Many bug fixes.
* Updated the README.txt.
* Fixed bug in UI::Console.auto_load and UI::Console.start.

### 0.1.4 / 2009-01-22

* Moved Ronin::Web and Ronin::Sessions::Web into the ronin-web library.
* Removed dependencies to hpricot, mechanize, spidr and rack.
* Moved Hexdump into the Ronin::UI namespace.
* Require parameters >= 0.1.3:
  * Parameters 0.1.3 adds support for using lambdas as the default values
    of parameters.
* Temporarily added Ronin::Model.first_or_new:
  * Will be removed once dkubb's version of first_or_new is merged into
    dm-core.
* Added the File.write method.
* Added specs for String#format_http and String#format_html.
* Fixed a formatting bug in String#format_chars and String#format_bytes.
* Fixed typos.
* Automatically load 'ronin/ui/hexdump' when starting the
  Ronin::UI::Console.

### 0.1.3 / 2009-01-08

* Moved Context into the Contextify library.
* Require dm-core >= 0.9.9.
* Require dm-predefined >= 0.1.0.
* Require parameters >= 0.1.2.
* Require contextify >= 0.1.0.
* Require reverse-require >= 0.3.1.
* Renamed Ronin::ObjectContext to Ronin::Objectify.
* Added the MIT license to the Ronin::License model, using dm-predefined.
* Added Ronin::HasLicense mixin for adding licenses to a model.
* Added Net.tcp_send and Ronin::Sessions::TCP#tcp_send for quickly sending
  data through a TCP connection then closing it.
* Added Ronin::UI::CommandLine::ParamParser for parsing command-line
  options into a Hash of parameters.
* Automatically create the `~/.ronin/config/` directory.
* Refactored Ronin::Objectify and how it uses primary keys.
* All Ronin::Session mixins use standard naming conventions for defining
  the 'host' and 'port' parameters.
* Removed Ronin::Cache::Extension dependencies.
* Filter out the 'objects' directory from Ronin::Cache::Overlay#extensions.
* Improved tearing down of Extensions at exit.
* Improved output formatting of the +list+ sub-command.
* Ronin::UI::CommandLine.run now prints any exceptions and exits.
* Cleaned up the specs.
* Added more specs.
* Added more documentation.

### 0.1.2 / 2008-12-10

* Require do_sqlite3 >= 0.9.9, since version 0.9.8 was totally broken.
* Require reverse-require >= 0.2.0, for improved performance.
* Require Spidr >= 0.1.3.
* Moved Ronin::Parameters into the parameters 0.1.0 RubyGem.
* Added a Ronin::Hexdump module:
  * Provides Ronin::Hexdump.dump and Kernel#hexdump, which can hexdump any 
    object that supports the #each_byte method.
* Refactored Ronin::Chars::CharSet:
  * Now inherites the SortedSet class.
  * Stores chars as bytes.
  * Added a Ronin::Chars::CharSet#=~ operator, for determining if a String
    exists in the language over the alphabet represented by the character
    set.
  * Added a Ronin::Chars::CharSet#inspect method which prints C-like
    characters.
* Added a String#inspect method which prints C-like strings.
* Added a String#xor method (it might come in handy).
* Renamed Ronin::Encoders::Encoder to Ronin::Translators::Translator.
* Added URI::QueryParams#each_query_param.
* Added extensions to Hpricot, for comparing two Hpricot Element trees.
* Added the Ronin::Web.spider_agent, Ronin::Web.spider_host and
  Ronin::Web.spider_site methods.
* Added Ronin::Code::SymbolTable#symbols.
* Added a basic Ronin::Code::Emittable module and a Ronin::Code::Token
  class.
* Renamed Ronin::ObjectContext.object_contextify to
  Ronin::ObjectContext.objectify.
* Merged the Ronin::Environment module into the Ronin::Config module.
* Refactored the Ronin::Shell class.
* Refactored the Ronin::Runner::Program module.
* Created the Ronin::UI namespace, to contain all things User Interfacing:
  * Moved Ronin::Console and Ronin::Shell into the UI namespace.
  * Renamed Ronin::Runner::Program to Ronin::UI::CommandLine.
* Added a Ronin::Cache::Overlay::Maintainer class to define maintainers of
  an Ronin::Cache::Overlay and their contact information.
* Refactored the parsing of Overlay XML files.
* Added the sub-commands +overlay+ and +extension+ for generating skeleton
  Overlays and Extensions.
* Added a XSL file for generating pretty HTML from Overlay XML files.
* Added even more specs.
* More typo and documentation fixes.

### 0.1.1 / 2008-10-26

* Depend on the newly renamed reverse-require (>= 0.1.2) gem.
* Added Ronin::Code::SymbolTable for DSLs to make use of.
* Added String#common_prefix, String#common_postfix and
  String#uncommon_substring, which will be useful when testing for
  successful injections.
* Added DataMapper column indexes to Author.name, Product.name, Platform.os
  and Platform.version.
* Renamed String#rand_case to String#random_case.
* Removed the Ronin::Runner namespace, renaming the Ronin::Runner::Program
  namespace to Ronin::Program.

### 0.1.0 / 2008-09-28

* Changed how Sessions are setup.
* Have Ronin use it's own DataMapper Repository name-space to avoid
  conflicts with other DataMapper libraries.
* Added the Ronin::Parameters#set_params methods.
* Added specs.
* Fixed various trivial bugs.

### 0.0.9 / 2008-08-20

* Initial release.
* Supports installing/updating/uninstalling of Overlays.
  * Supports accessing Overlays from various media types:
    * CVS
    * Darcs
    * Subversion (SVN)
    * Git
    * Rsync
* Allows for the loading of Extensions from one or more Overlays.
* Provides a persistant Database using DataMapper.
* Caches and mirrors objects stored in Overlays using DataMapper.
* Provides convievance methods for:
  * Formating data:
    * Binary
    * HTTP
    * URIs
    * HTML
  * Generating random text.
  * Networking:
    * TCP
    * UDP
    * SMTP
    * POP
    * Imap
    * Telnet
    * HTTP
  * Web access (utilizing Mechanize and Hpricot).
* Provides an IRB styled console with:
  * Tab-completion enabled.
  * Auto-indentation enabled.
  * Pretty-Print loaded.

[ronin-support]: https://github.com/ronin-rb/ronin-support
