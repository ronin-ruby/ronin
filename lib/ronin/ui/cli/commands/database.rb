#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/ui/cli/command'
require 'ronin/database'

require 'addressable/uri'
require 'yaml/store'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Manages the Ronin Database.
        #
        # ## Usage
        #
        #     ronin database [options]
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #      -a, --add [NAME]
        #      -s, --set [NAME]
        #      -r, --remove [NAME]
        #      -C, --clear [NAME]
        #          --uri [sqlite3:///path]
        #          --adapter [DB]
        #          --host [HOST]
        #          --port [PORT]
        #          --user [USER]
        #          --password [PASSWORD]
        #          --database [NAME]
        #          --path [PATH]
        #
        class Database < Command

          summary 'Manages the Ronin Database'

          option :add, :type        => Symbol,
                       :flag        => '-a',
                       :usage       => 'NAME',
                       :description => 'Adds a Database Repository'

          option :set, :type        => Symbol,
                       :flag        => '-s',
                       :usage       => 'NAME',
                       :description => 'Sets the information for a Database Repository'

          option :remove, :type        => Symbol,
                          :flag        => '-r',
                          :usage       => 'NAME',
                          :description => 'Removes a Database Repository'

          option :clear, :type        => Symbol,
                         :flag        => '-C',
                         :usage       => 'NAME',
                         :description => 'WARNING: Clears a Database Repository'
          
          # repository options
          option :uri, :type        => String,
                       :usage       => 'sqlite3:///path',
                       :description => 'The URI for the Database Repository'

          option :adapter, :type        => String,
                           :usage       => 'sqlite3|mysql|postgres',
                           :description => 'The Database Adapter'

          option :host, :type        => String,
                        :usage       => 'HOST',
                        :description => 'The host running the Database'

          option :port, :type        => Integer,
                        :usage       => 'PORT',
                        :description => 'The port the Database is listening on'

          option :user, :type        => String,
                        :description => 'User to authenticate with'

          option :password, :type        => String,
                            :description => 'Password to authenticate with'

          option :database, :type        => String,
                            :usage       => 'NAME',
                            :description => 'Database name'

          option :path, :type        => String,
                        :usage       => 'PATH',
                        :description => 'Path to the Database file.'

          #
          # Displays or modifies the Ronin Database configuration.
          #
          def execute
            if clear?
              print_info "Clearing the Database repository #{@clear} ..."

              Ronin::Database.clear(@clear) do
                print_info "Database repository #{@clear} cleared."
              end

              return
            elsif (add? || set? || remove?)
              config = YAML::Store.new(Ronin::Database::CONFIG_FILE)

              config.transaction do
                if add?
                  if config[add]
                    print_error "Database repisotory #{add} already exists"
                    exit -1
                  end

                  config[add] = repository_uri

                  print_info "Database repository #{add} added."
                elsif set?
                  unless config[set]
                    print_error "Unknown Database repository #{set}"
                    exit -1
                  end

                  config[set] = repository_uri

                  print_info "Database repository #{set} updated."
                elsif remove?
                  unless config[remove]
                    print_error "Unknown Database repository #{remove}"
                    exit -1
                  end

                  config.delete(remove)

                  print_info "Database repository #{remove} removed."
                end

                config[:default] ||= Ronin::Database::DEFAULT_REPOSITORY
              end
            else
              Ronin::Database.repositories.each do |name,uri|
                print_hash uri, :title => name
              end
            end
          end

          protected

          #
          # Creates a repository URI from the command options.
          #
          # @return [Addressable::URI]
          #   The repository URI.
          #
          def repository_uri
            if uri?
              uri = Addressable::URI.parse(@uri)

              {
                :adapter  => uri.scheme,
                :host     => uri.host,
                :port     => uri.port,
                :user     => uri.user,
                :password => uri.password,
                :database => uri.path
              }
            else
              {
                :adapter  => @adapter,
                :host     => @host,
                :port     => @port,
                :user     => @user,
                :password => @password,
                :database => (@database || @path)
              }
            end
          end

        end
      end
    end
  end
end
