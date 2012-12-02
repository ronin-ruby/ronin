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

require 'ronin/ui/console/context'
require 'ronin/config'
require 'ronin/repository'

require 'ripl'
require 'ripl/multi_line'
require 'ripl/auto_indent'
require 'ripl/shell_commands'

module Ronin
  module UI
    #
    # An interactive Ruby {Console} using
    # [Ripl](https://github.com/cldwalker/ripl).
    #
    module Console

      # The history file for the Console session
      HISTORY_FILE = File.join(Config::PATH,'console.log')

      @@short_errors = !(ENV.has_key?('VERBOSE'))
      @@auto_load    = []
      @@setup_blocks = []

      #
      # Determines whether one-line errors will be printed, instead of full
      # backtraces.
      #
      # @return [Boolean]
      #   The Console short-errors setting.
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def Console.short_errors?
        @@short_errors
      end

      #
      # Enables or disables the printing of one-line errors.
      #
      # @param [Boolean] mode
      #   The new Console short-errors setting.
      #
      # @return [Boolean]
      #   The Console short-errors setting.
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def Console.short_errors=(mode)
        @@short_errors = mode
      end

      #
      # The list of files to load before starting the Console.
      #
      # @return [Array]
      #   The files to require when the Console starts.
      #
      # @api semipublic
      #
      def Console.auto_load
        @@auto_load
      end

      #
      # Adds a block to be ran from within the Console after it is
      # started.
      #
      # @yield []
      #   The block to be ran from within the Console.
      #
      # @api semipublic
      #
      def Console.setup(&block)
        @@setup_blocks << block if block
      end

      #
      # The list of completions files to require.
      #
      # @return [Array<String>]
      #   The sub-paths to require within `bond/completions/`.
      #
      # @since 1.2.0
      #
      # @api semipublic
      #
      def Console.completions
        (Ripl.config[:completion][:gems] ||= [])
      end

      Console.completions << 'ronin'

      #
      # Starts a Console.
      #
      # @param [Object] context
      #   The context for the console.
      #
      # @yield []
      #   The block to be ran within the console, after it has been setup.
      #
      # @return [Console]
      #   The instance context the console ran within.
      #
      # @example
      #   Console.start
      #   # >>
      #
      # @example Start a console inside of an Object:
      #   Console.start(exploit)
      #   # >> self
      #   # # => exploit
      #
      # @example Start a console with a custom block:
      #   Console.start { @var = 'hello' }
      #   # >> @var
      #   # # => "hello"
      #
      # @api semipublic
      #
      def Console.start(context=Context.new,&block)
        require 'ripl/color_result' if $stdout.tty?
        require 'ripl/short_errors' if @@short_errors

        require 'ronin'
        require 'ronin/repositories'
        require 'pp'

        # append the current directory to $LOAD_PATH for Ruby 1.9.
        $LOAD_PATH << '.' unless $LOAD_PATH.include?('.')

        # require any of the auto-load paths
        @@auto_load.each { |path| require path }

        # run any setup-blocks
        @@setup_blocks.each do |setup_block|
          context.instance_eval(&setup_block)
        end

        # run the supplied configuration block is given
        context.instance_eval(&block) if block

        # Start the Ripl console
        Ripl.start(
          :argv    => [],
          :name    => 'ronin',
          :binding => context.instance_eval('binding'),
          :history => HISTORY_FILE,
          :irbrc   => false
        )

        return context
      end

    end
  end
end
