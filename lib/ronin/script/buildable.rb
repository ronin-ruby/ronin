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

require 'ronin/script/exceptions/not_built'
require 'ronin/script/exceptions/build_failed'
require 'ronin/script/testable'
require 'ronin/ui/printing'

module Ronin
  module Script
    #
    # Adds building methods to an {Script}.
    #
    # @since 1.1.0
    #
    module Buildable
      include Testable, UI::Printing

      #
      # Initializes the buildable script.
      #
      # @param [Hash] attributes
      #   Additional attributes for the script.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def initialize(attributes={})
        super(attributes)

        @build_blocks = []
        @built = false
      end

      #
      # Determines whether the script has been built.
      #
      # @return [Boolean]
      #   Specifies whether the script is built.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def built?
        @built == true
      end

      #
      # Builds the script.
      #
      # @param [Hash] options
      #   Additional options to also use as parameters.
      #
      # @yield []
      #   The given block will be called after the script has been built.
      #
      # @see #build
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def build!(options={})
        self.params = options
        print_debug "#{self.class.short_name} #{self} parameters: #{self.params.inspect}"

        print_info "Building #{self.class.short_name} #{self} ..."

        @built = false
        @build_blocks.each { |block| block.call() }
        @built = true

        print_info "#{self.class.short_name} #{self} built!"

        yield if block_given?
        return self
      end

      #
      # Tests that the script has been built and is properly configured.
      #
      # @return [true]
      #   The script has been tested.
      #
      # @raise [NotBuilt]
      #   The script has not been built, and cannot be verified.
      #
      # @see #test
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def test!
        unless built?
          raise(NotBuilt,"cannot verify an unbuilt #{self.class.short_name}")
        end

        super
      end

      protected

      #
      # Indicates the build has failed.
      #
      # @raise [BuildFailed]
      #   The building of the script failed.
      #
      # @since 1.4.0
      #
      # @api public
      #
      def build_failed!(message)
        raise(BuildFailed,message)
      end

      #
      # Registers a given block to be called when the script is built.
      #
      # @yield []
      #   The given block will be called when the script is being built.
      #
      # @return [Script]
      #   The script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def build(&block)
        @build_blocks << block
        return self
      end
    end
  end
end
