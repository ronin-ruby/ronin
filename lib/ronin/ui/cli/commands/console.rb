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
require 'ronin/ui/console'
require 'ronin/database'
require 'ronin/version'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Starts the Ronin Console.
        #
        # ## Usage
        #
        #     ronin console [options]
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #      --[no-]silent                    Silence all output.
        #      -D, --database [URI]             The database to URI.
        #      -r, --require [PATH]             Ruby files to require.
        #                                       Default: []
        #          --[no-]backtrace             Enable long backtraces.
        #      -V, --[no-]version               Print the Ronin version.
        #
        class Console < Command

          summary 'Start the Ronin Console'

          option :database, :type        => URI,
                            :flag        => '-D',
                            :description => 'The database to URI'

          option :require, :type        => Array,
                           :default     => [],
                           :flag        => '-r',
                           :usage       => 'PATH',
                           :description => 'Ruby files to require'

          option :backtrace, :type        => true,
                             :description => 'Enable long backtraces'

          option :version, :type        => true,
                           :flag        => '-V',
                           :description => 'Print the Ronin version'

          #
          # Sets up the Ronin Console.
          #
          # @since 1.5.0
          #
          def setup
            super

            UI::Console.short_errors = !backtrace?

            @require.each do |path|
              UI::Console.auto_load << path
            end

            if database?
              Database.repositories[:default] = @database
            end
          end

          #
          # Starts the Ronin Console.
          #
          def execute
            if version?
              puts "ronin #{Ronin::VERSION}"
              return
            end

            UI::Console.start
          end

        end
      end
    end
  end
end
