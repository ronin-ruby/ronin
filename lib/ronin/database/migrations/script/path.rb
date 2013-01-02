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
require 'ronin/database/migrations/repository'

module Ronin
  module Database
    module Migrations
      migration :create_script_paths_table,
                :needs => :create_repositories_table do
        up do
          create_table :ronin_script_paths do
            column :id, Integer, :serial => true
            column :path, FilePath, :not_null => true
            column :timestamp, Time, :not_null => true
            column :class_name, String, :not_null => true
            column :repository_id, Integer, :not_null => true
          end
        end

        down do
          drop_table :ronin_script_paths
        end
      end
    end
  end
end
