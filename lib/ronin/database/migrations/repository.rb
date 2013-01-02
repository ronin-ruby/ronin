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
require 'ronin/database/migrations/license'
require 'ronin/database/migrations/author'

module Ronin
  module Database
    module Migrations
      #
      # 1.0.0
      #
      migration :create_repositories_table,
                :needs => [
                  :create_licenses_table,
                  :create_authors_table
                ] do
        up do
          create_table :ronin_repositories do
            column :id, Integer, :serial => true
            column :scm, String
            column :path, FilePath, :not_null => true 
            column :uri, DataMapper::Property::URI
            column :installed, Boolean, :default => false
            column :name, String
            column :domain, String, :not_null => true
            column :title, Text
            column :source, DataMapper::Property::URI
            column :website, DataMapper::Property::URI
            column :description, Text

            column :license_id, Integer
          end

          create_table :ronin_author_repositories do
            column :id, Integer, :serial => true
            column :author_id, Integer
            column :repository_id, Integer
          end

          create_index :ronin_repositories, :path, :unique => true
        end

        down do
          drop_table :ronin_author_repositories
          drop_table :ronin_repositories
        end
      end
    end
  end
end
