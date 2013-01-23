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

require 'ronin/database/graph'

require 'dm-core'

module Ronin
  module Database
    module Migrations
      extend DataMapper::Property::Lookup

      #
      # The defined migrations.
      #
      # @return [Graph]
      #   The defined migrations.
      #
      # @since 1.0.1
      #
      # @api private
      #
      def self.migrations
        @migrations ||= Graph.new
      end

      #
      # Defines a new migration.
      #
      # @param [Array] arguments
      #   Additional arguments.
      #
      # @yield []
      #   The given block will define the migration.
      #
      # @return [Migration]
      #   The newly defined migration.
      #
      # @raise [ArgumentError]
      #   The first argument was not a `Symbol`, `String` or `Integer`.
      #
      # @raise [DuplicateMigration]
      #   Another migration was previously defined with the same name or
      #   position.
      #
      # @example Defining a migration at a position
      #   migration 1, :create_people_table do
      #     up do
      #       create_table :people do
      #         column :id,   Integer, serial: true
      #         column :name, String, size: 50
      #         column :age,  Integer
      #       end
      #     end
      #
      #     down do
      #       drop_table :people
      #     end
      #   end
      #
      # @example Defining a migration with a name
      #   migration :create_people_table do
      #     up do
      #       create_table :people do
      #         column :id,   Integer, serial: true
      #         column :name, String, size: 50
      #         column :age,  Integer
      #       end
      #     end
      #
      #     down do
      #       drop_table :people
      #     end
      #   end
      #
      # @example Defining a migration with dependencies
      #   migration :add_salary_column, needs: :create_people_table do
      #     up do
      #       modify_table :people do
      #         add_column :salary, Integer
      #       end
      #     end
      #
      #     down do
      #       modify_table :people do
      #         drop_column :salary
      #       end
      #     end
      #   end
      #
      # @note
      #   Its recommended that you stick with raw SQL for migrations that
      #   manipulate data. If you write a migration using a model, then
      #   later change the model, there's a possibility the migration
      #   will no longer work. Using SQL will always work.
      #
      # @since 1.0.1
      #
      # @api public
      #
      def self.migration(*arguments,&block)
        case arguments[0]
        when Integer
          position = arguments[0]
          name = arguments[1]
          options = (arguments[2] || {})

          self.migrations.migration_at(position,name,options,&block)
        when Symbol, String
          name = arguments[0]
          options = (arguments[1] || {})

          self.migrations.migration_named(name,options,&block)
        else
          raise(ArgumentError,"first argument must be an Integer, Symbol or a String",caller)
        end
      end

      #
      # Migrates the database upward to a given migration position or name.
      #
      # @param [Symbol, Integer, nil] position_or_name
      #   The migration position or name to migrate the database to.
      #
      # @return [true]
      #   The database was successfully migrated up.
      #
      # @raise [UnknownMigration]
      #   A migration had a dependency on an unknown migration.
      #
      # @since 1.0.1
      #
      # @api private
      #
      def self.migrate_up!(position_or_name=nil)
        self.migrations.upto(position_or_name) do |migration|
          migration.perform_up
        end

        return true
      end

      #
      # Migrates the database downwards to a certain migration position or
      # name.
      #
      # @param [Symbol, Integer, nil] position_or_name
      #   The migration position or name to migrate the database down to.
      #
      # @return [true]
      #   The database was successfully migrated down.
      #
      # @raise [UnknownMigration]
      #   A migration had a dependency on an unknown migration.
      #
      # @since 1.0.1
      #
      # @api private
      #
      def self.migrate_down!(position_or_name=nil)
        self.migrations.downto(position_or_name) do |migration|
          migration.perform_down
        end

        return true
      end
    end
  end
end
