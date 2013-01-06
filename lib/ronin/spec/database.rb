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

require 'ronin/database'

require 'rspec'
require 'tmpdir'

RSpec.configure do |spec|
  defaults = {
    :user     => 'ronin_test',
    :password => 'ronin_test',
    :database => 'ronin_test'
  }
  adapter  = ENV.fetch('ADAPTER','sqlite3')

  uri = case adapter
        when 'sqlite3', 'sqlite'
          path = File.join(Dir.tmpdir,'ronin_database.sqlite3')

          {:adapter  => 'sqlite3', :database => path}
        else
          defaults.merge(:adapter => adapter)
        end

  spec.before(:suite) do
    # setup the database
    Ronin::Database.setup(uri)
  end

  spec.after(:suite) do
    case adapter
    when 'sqlite3', 'sqlite'
      File.unlink(path)
    end
  end
end
