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

require 'ronin/ui/cli/resources_command'
require 'ronin/url'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Manages {URL URLs}.
        #
        # ## Usage
        #
        #     ronin urls [options]
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #          --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #      -D, --database [URI]             The Database URI.
        #          --[no-]csv                   CSV output.
        #          --[no-]xml                   XML output.
        #          --[no-]yaml                  YAML output.
        #          --[no-]json                  JSON output.
        #      -i, --import [FILE]
        #          --[no-]http
        #          --[no-]https
        #      -H, --hosts [HOST [...]]
        #      -P, --ports [PORT [...]]
        #      -d, --directory [SUBDIR]
        #      -q [NAME [...]],
        #          --with-query-param
        #      -Q [VALUE [...]],
        #          --with-query-value
        #      -l, --[no-]list                  Default: true
        #
        class Urls < ResourcesCommand

          model URL

          summary 'Manages URLs'

          query_option :http, :type        => true,
                              :description => 'Searches for http:// URLs'

          query_option :https, :type        => true,
                               :description => 'Searches for https:// URLs'

          query_option :hosts, :type        => Array,
                               :flag        => '-H',
                               :usage       => 'HOST [...]',
                               :description => 'Searches for the associated HOST(s)'

          query_option :ports, :type        => Array[Integer],
                               :flag        => '-P',
                               :usage       => 'PORT [...]',
                               :description => 'Searches for the associated PORT(s)'

          query_option :directory, :type        => String, 
                                   :flag        => '-d',
                                   :description => 'Searches for the associated DIRECTORY'

          query_option :with_query_param, :type        => Array,
                                          :flag        => '-q',
                                          :usage       => 'NAME [...]',
                                          :description => 'Searches for the associated query-param NAME(s)'

          query_option :with_query_value, :type        => Array,
                                          :flag        => '-Q',
                                          :usage       => 'VALUE [...]',
                                          :description => 'Searches for the associated query-param VALUE(s)'

          option :list, :type        => true,
                        :default     => true,
                        :flag        => '-l',
                        :description => 'Lists the URLs'

          option :import, :type        => String,
                          :flag        => '-i',
                          :usage       => 'FILE',
                          :description => 'Imports URLs from the FILE'

          protected

          #
          # Prints a URL.
          #
          # @param [Ronin::URL] url
          #   The URL to print.
          #
          # @since 1.0.0
          #
          def print_resource(url)
            return super(url) unless verbose?

            print_title url

            indent do
              print_hash 'Host' => url.host_name,
                         'Port' => url.port.number,
                         'Path' => url.path,
                         'Fragment' => url.fragment,
                         'Last Scanned' => url.last_scanned_at

              unless url.query_params.empty?
                params = {}

                url.query_params.each do |param|
                  params[param.name] = param.value
                end

                print_hash params, :title => 'Query Params'
              end
            end
          end

        end
      end
    end
  end
end
