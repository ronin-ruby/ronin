#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
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
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
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
        #          --[no-]color                 Enables color output.
        #
        # ## Arguments
        #
        #      COMMAND                          The command to display
        #
        class Help < Command

          summary 'Displays the list of available commands or prints information on a specific command'

          argument :command, :type        => Symbol,
                             :description => 'The command to display'

          #
          # Lists the available commands.
          #
          def execute
            if command?
              sub_path = command.tr(':',File::SEPARATOR)

              Installation.paths.each do |path|
                man_page = File.join(path,'man',"#{sub_path}.1")

                if File.file?(man_page)
                  system('man',man_page)
                  return
                end
              end

              print_error "No man-page for the command: #{@command}"
            else
              print_array CLI.commands, :title => 'Available commands'
            end
          end

        end
      end
    end
  end
end
