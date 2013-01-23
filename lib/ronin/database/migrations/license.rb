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
      migration :create_licenses_table do
        up do
          create_table :ronin_licenses do
            column :id, Integer, serial: true
            column :name, String, not_null: true
            column :description, Text, not_null: true
            column :url, String, length: 256
          end

          create_index :ronin_licenses, :name, unique: true
        end

        down do
          drop_table :ronin_licenses
        end
      end

      migration :populate_licenses_table do
        up do
          [
            [
              'GPL-2',
              'GNU Public License v2.0',
              'http://www.gnu.org/licenses/gpl-2.0.txt'
            ],

            [
              'LGPL-2.1',
              'GNU Lesser General Public License v2.1',
              'http://www.gnu.org/licenses/lgpl-2.1.txt'
            ],

            [
              'GPL-3',
              'GNU Public License v3.0',
              'http://www.gnu.org/licenses/gpl-3.0.txt'
            ],

            [
              'LGPL-3',
              'GNU Lesser General Public License v3.0',
              'http://www.gnu.org/licenses/lgpl-3.0.txt'
            ],

            [
              'BSD',
              'Berkeley Software Distribution License',
              'http://www.opensource.org/licenses/bsd-license.php'
            ],

            [
              'MIT',
              'The MIT Licence',
              'http://www.opensource.org/licenses/mit-license.php'
            ],

            [
              'CC by',
              'Creative Commons Attribution v3.0 License',
              'http://creativecommons.org/licenses/by/3.0/'
            ],

            [
              'CC by-sa',
              'Creative Commons Attribution-Share Alike v3.0 License',
              'http://creativecommons.org/licenses/by-sa/3.0/'
            ],

            [
              'CC by-nd',
              'Creative Commons Attribution-No Derivative Works v3.0 License',
              'http://creativecommons.org/licenses/by-nd/3.0/'
            ],

            [
              'CC by-nc',
              'Creative Commons Attribution-Noncommercial v3.0 License',
              'http://creativecommons.org/licenses/by-nc/3.0/'
            ],

            [
              'CC by-nc-sa',
              'Creative Commons Attribution-Noncommercial-Share Alike v3.0 License',
              'http://creativecommons.org/licenses/by-nc-sa/3.0/'
            ],

            [
              'CC by-nc-nd',
              'Creative Commons Attribution-Noncommercial-No Derivative Works v3.0 License',
              'http://creativecommons.org/licenses/by-nc-nd/3.0/'
            ],

            [
              'CC0',
              'Creative Commons Zero License',
              'http://creativecommons.org/licenses/zero/1.0/'
            ]
          ].each do |name,description,url|
            adapter.execute(
              'INSERT OR IGNORE INTO ronin_licenses (name,description,url) VALUES (?,?,?)',
              name, description, url
            )
          end
        end

        down do
        end
      end
    end
  end
end
