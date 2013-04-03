require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler"
  exit -1
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new(sign: {checksum: true, pgp: true}) do |tasks|
  tasks.console.command = 'ripl'
  tasks.console.options = %w[
    -rripl/multi_line
    -rripl/auto_indent
    -rripl/color_result
  ]
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test    => :spec
task :default => :spec

require 'dm-visualizer/rake/graphviz_task'
DataMapper::Visualizer::Rake::GraphVizTask.new(
  include: %w[lib],
  require: %w[
    ronin/arch
    ronin/address
    ronin/author
    ronin/campaign
    ronin/credential
    ronin/email_address
    ronin/host_name_ip_address
    ronin/host_name
    ronin/ip_address_mac_address
    ronin/ip_address
    ronin/license
    ronin/mac_address
    ronin/open_port
    ronin/organization
    ronin/os_guess
    ronin/os
    ronin/script/path
    ronin/repository
    ronin/port
    ronin/service
    ronin/service_credential
    ronin/web_credential
    ronin/software
    ronin/vendor
    ronin/target
    ronin/tcp_port
    ronin/udp_port
    ronin/url_scheme
    ronin/url_query_param_name
    ronin/url_query_param
    ronin/url
    ronin/user_name
    ronin/password
  ]
)

require 'yard'
YARD::Rake::YardocTask.new

desc "Generates all documentation"
task :docs => [:yard, 'dm:doc:graphviz']

require 'kramdown/man/task'
Kramdown::Man::Task.new
