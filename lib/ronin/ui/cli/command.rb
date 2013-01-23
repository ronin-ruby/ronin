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

require 'ronin/ui/cli/printing'
require 'ronin/support/inflector'

require 'parameters'
require 'parameters/options'

module Ronin
  module UI
    module CLI
      #
      # The {Command} provides a base-class for defining commands for the {CLI}.
      #
      # # Extending
      #
      # To create a new command one can inherit the {Command} class.
      # The new command can define multiple `class_options` and `arguments`
      # which `Thor::Group` will use to parse command-line arguments.
      #
      #     require 'ronin/ui/cli/command'
      #
      #     module Ronin
      #       module UI
      #         module CLI
      #           module Commands
      #             class MyCommand < Command
      #
      #               summary 'My command'
      #
      #               option :enable, type:        true,
      #                               flag:        '-e',
      #                               description: 'Enables stuff'
      #
      #               option :syntax, type:        Symbol,
      #                               flag:        '-S',
      #                               description: 'Syntax to use'
      #
      #               option :includes, type:        Array[String],
      #                                 default:     [],
      #                                 flag:        '-I',
      #                                 usage:       'FILE [...]',
      #                                 description: 'Files to include'
      #
      #               option :params, type:        Hash[Symbol => Object],
      #                               flag:        '-P',
      #                               description: 'Additional params'
      #
      #               argument :path
      #
      #               #
      #               # Executes the command.
      #               #
      #               def execute
      #                 print_info "Stuff enabled" if enable?
      #
      #                 if syntax?
      #                   print_info "Using syntax #{@syntax}"
      #                 end
      #
      #                 if includes?
      #                   print_info "Including:"
      #                   print_array @includes
      #                 end
      #               end
      #
      #             end
      #           end
      #         end
      #       end
      #     end
      #
      # # Running
      #
      # To run the command from Ruby, with raw command-line options, one
      # can call the `start` class method:
      #
      #     MyCommand.start([
      #       '--stuff', 'true', '--syntax', 'bla', '--includes', 'other',
      #       'some/file.txt'
      #     ])
      #
      # Note: If `MyCommand.start` is not given any arguments, it will use
      # `ARGV` instead.
      #
      # To ensure that your command is accessible to the `ronin` command,
      # make sure that the ruby file the command is defined within is in
      # the `ronin/ui/cli/commands` directory of a Ronin library.
      # If the command class is named 'MyCommand' it's ruby file must also
      # be named 'my_command.rb'.
      #
      # To run the command using the `ronin` command, simply specify it's
      # underscored name:
      #
      #     ronin my_command some/file.txt --stuff --syntax bla \
      #       --includes one two
      #
      class Command

        include Parameters
        include Printing

        #
        # Initializes the command object.
        #
        # @param [Hash{Symbol => Object}] options
        #   Options for the command.
        #
        # @api semipublic
        #
        def initialize(options={})
          super()

          initialize_params(options)
        end

        #
        # Returns the name of the command.
        #
        # @api semipublic
        #
        def self.command_name
          @command_name ||= Support::Inflector.underscore(
            self.name.sub('Ronin::UI::CLI::Commands::','').gsub('::',':')
          )
        end

        #
        # Runs the command.
        #
        # @param [Array<String>] argv
        #   The arguments for the command to parse.
        #
        # @return [true]
        #   Specifies that the command successfully executed.
        #
        # @note
        #   If the command raises an Exception, the process will exit with
        #   status code `-1`.
        #
        # @since 1.0.0
        #
        # @api public
        #
        def self.start(argv=ARGV)
          new().start(argv)
        end

        #
        # Runs the command with the given options.
        #
        # @param [Hash{Symbol => Object}] options
        #   Options for the command.
        #
        # @return [true]
        #   Specifies that the command successfully executed.
        #
        # @raise [Exception]
        #   An exception raised within the command.
        #
        # @api public
        #
        def self.run(options={})
          new().run(options)
        end

        #
        # Starts the command with the given command-line arguments.
        #
        # @param [Array<String>] argv
        #   The given command-line arguments.
        #
        # @return [true]
        #   Specifies whether the command executed successfully.
        #
        # @note
        #   If the command raises an Exception, the process will exit with
        #   status code `-1`.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def start(argv=ARGV)
          arguments = option_parser.parse(argv)

          # set additional arguments
          self.class.each_argument do |name|
            # no more arguments left
            break if arguments.empty?

            param = get_param(name)

            if param.type <= Parameters::Types::Array
              # allow Array/Set arguments to collect all remaining args
              param.value = arguments.shift(arguments.length)
            else
              param.value = arguments.shift
            end
          end

          unless arguments.empty?
            print_error "Too many arguments. Please consult --help"
            exit -1
          end

          begin
            run
          rescue Interrupt
            # Ctrl^C
            exit 130
          rescue Errno::EPIPE
            # STDOUT was closed
          rescue => error
            print_exception(error)
            exit -1
          end

          return true
        end

        #
        # Sets up and executes the command.
        #
        # @param [Hash{Symbol => Object}] options
        #   Additional options to run the command with.
        #
        # @return [true]
        #   Specifies that the command exited successfully.
        #
        # @see #setup
        # @see #execute
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def run(options={})
          self.params = options

          setup
          execute

          return true
        ensure
          cleanup
        end

        #
        # Default method to call before {#execute}.
        #
        # @since 1.1.0
        #
        # @api semipublic
        #
        def setup
          UI::Printing.verbose! if verbose?
          UI::Printing.quiet!   if quiet?
          UI::Printing.silent!  if silent?
        end

        #
        # Default method to call after the options have been parsed.
        #
        # @api semipublic
        #
        def execute
        end

        #
        # Default method to call after the command has finished.
        #
        # @since 1.5.0
        #
        # @api semipublic
        #
        def cleanup
        end

        protected

        #
        # The usage for the command.
        #
        # @param [String] new_usage
        #   The new usage for the command.
        #
        # @return [String]
        #   The usage string.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.usage(new_usage=nil)
          if new_usage
            @usage = new_usage
          else
            @usage ||= if superclass < Command
                         superclass.usage
                       else
                         '[options]'
                       end
          end
        end

        #
        # The summary for the command.
        #
        # @param [String] new_summary
        #   The new summary for the command.
        #
        # @return [String]
        #   The summary string.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.summary(new_summary=nil)
          if new_summary
            @summary = new_summary
          else
            @summary ||= if superclass < Command
                           superclass.summary
                         end
          end
        end

        #
        # Example usages for the command.
        #
        # @param [Array<String>] new_examples
        #   The new examples for the command.
        #
        # @return [Array]
        #   Example commands.
        #
        # @since 1.5.0
        #
        # @api semipublic
        #
        def self.examples(new_examples=nil)
          if new_examples
            @examples = new_examples
          else
            @examples ||= if superclass < Command
                            superclass.examples.dup
                          else
                            []
                          end
          end
        end

        #
        # The options for the parameters.
        #
        # @return [Hash{Symbol => Hash}]
        #   The banner string.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.options
          @options ||= {}
        end

        #
        # Defines an option for the command.
        #
        # @param [Symbol] name
        #   The name of the option.
        #
        # @param [Hash] options
        #   Additional options for the option.
        #
        # @option options [Hash{Class => Class}, Set<Class>, Array<Class>, Class, true] :type
        #   The type of the options.
        #
        # @option options [Object, Proc] :default
        #   The default value for the options.
        #
        # @option options [String] :flag
        #   The short-flag for the option.
        #
        # @option options [String] :usage
        #   The usage for the option.
        #
        # @option options [String] :description
        #   The description of the option.
        #
        # @return [Parameters::ClassParam]
        #   The parameter that will contain the value of the option.
        #
        # @example
        #   option :output, type:        String,
        #                   flag:        '-f',
        #                   usage:       'PATH',
        #                   description: 'The path to write the output to'
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.option(name,options={})
          self.options[name] = {
            flag:  options[:flag],
            usage: options[:usage]
          }

          return parameter(name,options)
        end

        option :verbose, type:        true,
                         flag:        '-v',
                         description: 'Enable verbose output'

        option :quiet, type:        true,
                       flag:        '-q',
                       description: 'Disable verbose output'

        option :silent, type:         true,
                        description:  'Silence all output'

        #
        # Enumerates through the options define by every sub-class.
        #
        # @yield [name,options]
        #   The given block will be passed each option.
        #
        # @yieldparam [Symbol] name
        #   The name of the option.
        #
        # @yieldparam [Hash] options
        #   Additional options associated with the option.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        # @since 1.4.0
        #
        # @api private
        #
        def self.each_option(&block)
          return enum_for(__method__) unless block

          ancestors.reverse_each do |ancestor|
            if ancestor <= Command
              ancestor.options.each(&block)
            end
          end
        end

        #
        # Determines if there are any options defined by the command.
        #
        # @return [Boolean]
        #   Specifies if there are any options defined by the command.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.options?
          each_option.any?
        end

        #
        # The additional arguments of the command.
        #
        # @return [Array<Symbol>]
        #   The names of the arguments.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.arguments
          @arguments ||= []
        end

        #
        # Defines an argument for the command.
        #
        # @param [Symbol] name
        #   The name of the argument.
        #
        # @param [Hash] options
        #   Additional options for the argument.
        #
        # @option options [Hash{Class => Class}, Set<Class>, Array<Class>, Class, true] :type (String)
        #   The type of the argument.
        #
        # @option options [Object, Proc] :default
        #   The default value for the argument.
        #
        # @return [Parameters::ClassParam]
        #   The parameter that will contain the value of the argument.
        #
        # @example
        #   argument :file, type:        String,
        #                   description: "The file to process"
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.argument(name,options={})
          self.arguments << name.to_sym

          return parameter(name,options)
        end

        #
        # Enumerates through the arguments define by every sub-class.
        #
        # @yield [name]
        #   The given block will be passed each argument name.
        #
        # @yieldparam [Symbol] name
        #   The name of the argument.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.each_argument(&block)
          return enum_for(__method__) unless block

          ancestors.reverse_each do |ancestor|
            if ancestor <= Command
              ancestor.arguments.each(&block)
            end
          end
        end

        #
        # Determines if there are any arguments defined by the command.
        #
        # @return [Boolean]
        #   Specifies if there are any arguments defined by the command.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def self.arguments?
          each_argument.any?
        end

        #
        # Creates an OptionParser for the command.
        #
        # @yield [opts]
        #   The given block will be passed the new OptionParser, after
        #   all options have been defined, but before the Arguments have
        #   been listed.
        #
        # @yieldparam [OptionParser] opts
        #   The newly created OptionParser.
        #
        # @return [OptionParser]
        #   The new configured OptionParser.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def option_parser
          OptionParser.new do |opts|
            opts.banner = "Usage: ronin #{self.class.command_name} #{self.class.usage}"

            # append the arguments to the banner
            self.class.each_argument do |name|
              opts.banner << " #{name.upcase}"
            end

            opts.separator ''
            opts.separator 'Options:'

            self.class.each_option do |name,options|
              Parameters::Options.define(opts,get_param(name),options)
            end

            yield opts if block_given?

            if self.class.arguments?
              opts.separator ''
              opts.separator 'Arguments:'

              self.class.each_argument do |name|
                param = get_param(name)
                name  = name.upcase.to_s
                desc  = param.description

                opts.separator "    #{name.ljust(33)}#{desc}"
              end
            end

            unless self.class.examples.empty?
              opts.separator ''
              opts.separator 'Examples:'

              self.class.examples.each do |example|
                opts.separator "  #{example}"
              end
            end

            if self.class.summary
              opts.separator ''
              opts.separator self.class.summary
            end
          end
        end

      end
    end
  end
end
