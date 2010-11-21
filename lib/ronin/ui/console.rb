#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

require 'ronin/config'

require 'irb'

module Ronin
  module UI
    module Console
      # Default prompt style.
      PROMPT = :SIMPLE

      # Default indentation mode.
      INDENT = true

      # Default backtrace depth.
      BACKTRACE_DEPTH = 5

      # Default completion mode.
      COMPLETION = true

      #
      # @return [String]
      #   The default Console prompt style.
      #
      def Console.prompt
        @@ronin_console_prompt ||= PROMPT
      end

      #
      # Sets the default Console prompt style.
      #
      # @param [String] style
      #   The new Console prompt style to use.
      #
      def Console.prompt=(style)
        @@ronin_console_prompt = style
      end

      #
      # @return [Boolean]
      #   The default Console indent setting.
      #
      def Console.indent
        @@ronin_console_indent ||= INDENT
      end

      #
      # Sets the default Console indent setting.
      #
      # @param [Boolean] mode
      #   The new default Console indent setting.
      #
      # @example
      #   Console.indent = false
      #   # => false
      #
      def Console.indent=(mode)
        @@ronin_console_indent = mode
      end

      #
      # @return [Integer]
      #   The default Console back-trace depth.
      #
      def Console.backtrace_depth
        @@ronin_console_backtrace_depth ||= BACKTRACE_DEPTH
      end

      #
      # Sets the default Console back-trace depth.
      #
      # @param [Integer] depth
      #   The new default Console back-trace depth.
      #
      def Console.backtrace_depth=(depth)
        @@ronin_console_backtrace_depth = depth
      end

      #
      # @return [Boolean]
      #   The default Console tab-completion setting.
      #
      def Console.completion
        @@ronin_console_completion ||= COMPLETION
      end

      #
      # Sets the default Console tab-completion setting.
      #
      # @param [Boolean] mode
      #   The new default Console tab-completion setting.
      #
      # @example
      #   Console.completion = false
      #   # => false
      #
      def Console.completion=(mode)
        @@ronin_console_completion = mode
      end

      #
      # @return [Array]
      #   The files to require when the Console starts.
      #
      def Console.auto_load
        @@ronin_console_auto_load ||= []
      end

      #
      # Adds a block to be ran from within the Console after it is
      # started.
      #
      # @yield []
      #   The block to be ran from within the Console.
      #
      def Console.setup(&block)
        Console.setup_blocks << block if block
      end

      #
      # Starts a Console.
      #
      # @param [Hash{Symbol => Object}] variables
      #   Instance variable names and values to set within the console.
      #
      # @yield []
      #   The block to be ran within the Console, after it has been setup.
      #
      # @return [nil]
      #
      # @example
      #   Console.start
      #   # >>
      #
      # @example
      #   Console.start(:var => 'hello')
      #   # >> @var
      #   # # => "hello"
      #
      # @example
      #   Console.start { @var = 'hello' }
      #   # >> @var
      #   # # => "hello"
      #
      def Console.start(variables={},&block)
        # clear ARGV, so IRB does not try to interpret the command-line args
        ARGV.clear

        IRB.setup(nil)

        # configure IRB
        IRB.conf[:IRB_NAME] = 'ronin'
        IRB.conf[:PROMPT_MODE] = Console.prompt
        IRB.conf[:AUTO_INDENT] = Console.indent
        IRB.conf[:BACK_TRACE_LIMIT] = Console.backtrace_depth

        irb = IRB::Irb.new(nil)
        main = irb.context.main

        # configure the IRB context
        main.instance_eval do
          require 'ronin'
          require 'ronin/overlay'

          require 'pp'

          # include the output helpers
          include Ronin::UI::Output::Helpers

          if Ronin::UI::Console.completion
            begin
              # setup irb completion
              require 'irb/completion'
            rescue LoadError
              print_error "Unable to load 'irb/completion'."
              print_error "Ruby was not compiled with readline support."
            end
          end

          include Ronin

          # activates all installed or added overlays
          Ronin::Overlay.activate!

          # require any of the auto-load paths
          Ronin::UI::Console.auto_load.each { |path| require path }

          # append the current directory to $LOAD_PATH for Ruby 1.9.
          $LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
        end

        # run any setup-blocks
        Console.setup_blocks.each do |setup_block|
          main.instance_eval(&setup_block)
        end

        # populate instance variables
        variables.each do |name,value|
          main.instance_variable_set("@#{name}".to_sym,value)
        end

        # run the supplied configuration block is given
        main.instance_eval(&block) if block

        IRB.conf[:MAIN_CONTEXT] = irb.context

        trap('SIGINT') { irb.signal_handle }
        catch(:IRB_EXIT) { irb.eval_input }

        putc "\n"
        return nil
      end

      protected

      #
      # @return [Array]
      #   The blocks to be ran from within the Console after it is started.
      #
      def Console.setup_blocks
        @@console_setup_blocks ||= []
      end
    end
  end
end
