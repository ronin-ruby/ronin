#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/runner/program/program'

module Ronin
  module Runner
    module Program
      Program.command(:help) do |argv|
        options = Options.command('ronin','help','[COMMAND]') do |options|
          options.common do
            options.help_option
          end

          options.arguments do
            options.arg('COMMAND','The command to view')
          end

          options.summary('View a list of supported commands or information on a specific command')
        end

        options.parse(argv) do |args|
          unless args.length<=1
            Program.fail('help: only one command maybe specified')
          end

          Program.success do
            Program.help(args.first)
          end
        end
      end
    end
  end
end
