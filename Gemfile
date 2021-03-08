source 'https://rubygems.org'

DM_URI     = 'https://github.com/datamapper'
DM_VERSION = '~> 1.2'
DO_VERSION = '~> 0.10.3'
RONIN_URI  = 'https://github.com/ronin-rb'

gemspec

gem 'jruby-openssl',	'~> 0.7', platforms: :jruby

# DataMapper dependencies
# gem 'data_objects',       DO_VERSION, git: "#{DM_URI}/do.git"
# gem 'do_sqlite3',         DO_VERSION, git: "#{DM_URI}/do.git"
# gem 'dm-do-adapter',      DM_VERSION, git: "#{DM_URI}/dm-do-adapter.git"
# gem 'dm-sqlite-adapter',  DM_VERSION, git: "#{DM_URI}/dm-sqlite-adapter.git"
# gem 'dm-core',            DM_VERSION, git: "#{DM_URI}/dm-core.git"
# gem 'dm-types',           DM_VERSION, git: "#{DM_URI}/dm-types.git"
# gem 'dm-migrations',      DM_VERSION, git: "#{DM_URI}/dm-migrations.git"
# gem 'dm-validations',     DM_VERSION, git: "#{DM_URI}/dm-validations.git"
# gem 'dm-aggregates',      DM_VERSION, git: "#{DM_URI}/dm-aggregates.git"
# gem 'dm-timestamps',      DM_VERSION, git: "#{DM_URI}/dm-timestamps.git"

# Library dependencies
gem 'ronin-support',	'~> 0.6', git: "#{RONIN_URI}/ronin-support.git",
                                branch: '0.6.0'
gem 'ronin-db', '~> 0.1', git: "#{RONIN_URI}/ronin-db.git",
                          branch: 'main'
gem 'ronin-repos', '~> 0.1', git: "#{RONIN_URI}/ronin-repos.git",
                             branch: 'main'

group :development do
  gem 'rake'
  gem 'rubygems-tasks', '~> 0.1'
  gem 'rspec',          '~> 3.0'

  gem 'kramdown',      '~> 2.0'
  gem 'kramdown-man',  '~> 0.1'

  gem 'ruby-graphviz',  '~> 0.9.10'
  gem 'dm-visualizer',  '~> 0.2.0'
end

#
# To enable additional DataMapper adapters for development work or for
# testing purposes, simple set the ADAPTER or ADAPTERS environment
# variable:
#
#     export ADAPTER="postgres"
#     bundle install
#
#     ./bin/ronin --database postgres://ronin@localhost/ronin
#
require 'set'

DM_ADAPTERS = Set['postgres', 'mysql', 'oracle', 'sqlserver']

adapters = (ENV['ADAPTER'] || ENV['ADAPTERS']).to_s
adapters = Set.new(adapters.to_s.tr(',',' ').split)

(DM_ADAPTERS & adapters).each do |adapter|
  gem "dm-#{adapter}-adapter", DM_VERSION #, git: "#{DM_URI}/dm-#{adapter}-adapter.git"
end
