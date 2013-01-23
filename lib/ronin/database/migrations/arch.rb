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

require 'ronin/database/migrations/migrations'

module Ronin
  module Database
    module Migrations
      #
      # 1.0.0
      #
      migration :create_arches_table do
        up do
          create_table :ronin_arches do
            column :id, Integer, serial: true
            column :name, String, not_null: true
            column :endian, String, not_null: true
            column :address_length, Integer, not_null: true
          end

          create_index :ronin_arches, :name, unique: true
        end

        down do
          drop_table :ronin_arches
        end
      end

      #
      # 1.6.0
      #
      migration :populate_arches_table do
        up do
          [
            # name, endian, address_length
            ['x86', 'little', 4],
            ['x86-64', 'little', 8],
            ['ia64', 'little', 8],
            ['ppc', 'big', 4],
            ['ppc64', 'big', 8],
            ['sparc', 'big', 4],
            ['sparc64', 'big', 8],
            ['mips_le', 'little', 4],
            ['mips_be', 'big', 4],
            ['arm_le', 'little', 4],
            ['arm_be', 'big', 4]
          ].each do |name,endian,address_length|
            adapter.execute(
              'INSERT OR IGNORE INTO ronin_arches (name,endian,address_length) VALUES (?,?,?)',
              name, endian, address_length
            )
          end
        end

        down do
        end
      end
    end
  end
end
