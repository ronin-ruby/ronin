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
require 'ronin/ui/cli/cli'
require 'ronin/installation'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Displays the list of available commands or prints information on a
        # specific command.
        #
        # ## Usage
        #
        #     ronin help [options] COMMAND
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #
        # ## Arguments
        #
        #      COMMAND                          The command to display
        #
        class Help < Command

          summary 'Displays the list of available commands or prints information on a specific command'

          argument :command, type:        String,
                             description: 'The command to display'

          #
          # Lists the available commands.
          #
          def execute
            if command?
              begin
                CLI.command(command).help
              rescue UnknownCommand
                print_error "Unknown command: #{@command.dump}"
                exit -1
              end
            else
              print_array CLI.commands, title: 'Available commands'
            end
          end

        end
      end
    end
  end
end
