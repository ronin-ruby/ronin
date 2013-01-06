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

require 'ronin/ui/printing'

require 'dm-migrations'

module Ronin
  module Database
    #
    # Represents a Database Migration.
    #
    class Migration < DataMapper::Migration

      # The dependencies of the migration
      attr_reader :needs

      #
      # Creates a new migration.
      #
      # @param [Symbol] name
      #   The name of the migration.
      #
      # @param [Hash] options
      #   Additional options for the migration.
      #
      # @option options [Boolean] :verbose (false)
      #   Enables or disables verbose output.
      #
      # @option options [Symbol] :repository (:default)
      #   The DataMapper repository the migration will operate on.
      #
      # @option options [Array, Symbol] :needs ([])
      #   Other migrations that are dependencies of the migration.
      #
      # @api private
      #
      def initialize(name,options={},&block)
        @needs = Array(options.delete(:needs)).uniq

        super(0,name,options.merge(:verbose => UI::Printing.verbose?),&block)
      end

    end
  end
end
