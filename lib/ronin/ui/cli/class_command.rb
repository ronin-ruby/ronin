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

require 'parameters'

module Ronin
  module UI
    module CLI
      #
      # @since 1.4.0
      #
      class ClassCommand < Command

        # The object created from the Class
        attr_reader :instance

        #
        # Initializes the class command.
        #
        # @param [Hash] options
        #   Options for the class command and for the instance.
        #
        # @raise [TypeError]
        #   The class associated with the command does not support Parameters.
        #
        def initialize(options={})
          super(options)

          unless self.class.command_class < Parameters
            raise(TypeError,"#{command_class} does not include Parameters")
          end

          @instance = self.class.command_class.new()
          @instance.params = options
        end

        protected

        #
        # Sets or gets the class namespace.
        #
        # @param [Module, nil] new_namespace
        #   The namespace to load the class from.
        #
        # @return [Module]
        #   The namespace that the class resides in.
        #
        # @api semipublic
        #
        def self.class_namespace(new_namespace=nil)
          if new_namespace
            @class_namespace = new_namespace
          else
            @class_namespace ||= if superclass < ClassCommand
                                   superclass.class_namespace
                                 end
          end
        end

        #
        # Sets or gets the class name.
        #
        # @param [Symbol, nil] name
        #   The class name to load from the namespace.
        #
        # @return [Symbol]
        #   The class name.
        #
        # @api semipublic
        #
        def self.class_name(name=nil)
          if name then @class_name = name.to_sym
          else         @class_name ||= self.name.split('::').last.to_sym
          end
        end

        #
        # The loaded class from the namespace.
        #
        # @return [Class]
        #   The loaded class.
        #
        # @api semipublic
        #
        def self.command_class
          @command_class ||= class_namespace.const_get(class_name)
        end

        #
        # Creates an OptionParser for the class command.
        #
        # @yield [opts]
        #   The given block will be passed the newly created OptionParser,
        #   after options for the class have been defined.
        #
        # @yieldparam [OptionParser] opts
        #   The newly created OptionParser.
        #
        # @return [OptionParser]
        #   The fully configured OptionParser.
        #
        # @since 1.4.0
        #
        # @api semipublic
        #
        def option_parser
          super do |opts|
            @instance.each_param do |param|
              Parameters::Options.define(opts,param)
            end

            yield opts if block_given?
          end
        end

      end
    end
  end
end
