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

require 'ronin/model'
require 'ronin/model/has_unique_name'

module Ronin
  #
  # Represents a software license and pre-defines many other common ones
  # ({bsd}, {cc_by}, {cc_by_sa}, {cc_by_nd}, {cc_by_nc}, {cc_by_nc_sa},
  # {cc_by_nc_nd}, {cc0}, {gpl2}, {gpl3}, {lgpl3} and {mit}).
  #
  class License

    include Model
    include Model::HasUniqueName

    # Primary key
    property :id, Serial

    # Description of license
    property :description, Text, :required => true

    # URL of the License document
    property :url, URI, :length => 256

    #
    # Berkeley Software Distribution License
    #
    # @return [License]
    #
    def self.bsd
      first(:name => 'BSD')
    end

    #
    # Creative Commons By-Attribution License
    #
    # @return [License]
    #
    def self.cc_by
      first(:name => 'CC by')
    end

    #
    # Creative Commons By-Attribution Share-Alike License
    #
    # @return [License]
    #
    def self.cc_by_sa
      first(:name => 'CC by-sa')
    end

    #
    # Creative Commons By-Attribution No-Derivative Works License
    #
    # @return [License]
    #
    def self.cc_by_nd
      first(:name => 'CC by-nd')
    end

    #
    # Creative Commons By-Attribution Non-Commercial License
    #
    # @return [License]
    #
    def self.cc_by_nc
      first(:name => 'CC by-nc')
    end

    #
    # Creative Commons By-Attribution Non-Commercial Share-Alike License
    #
    def self.cc_by_nc_sa
      first(:name => 'CC by-nc-sa')
    end

    #
    # Creative Commons By-Attribution Non-Commercial No-Derivative Works
    # License
    #
    # @return [License]
    #
    def self.cc_by_nc_nd
      first(:name => 'CC by-nc-nd')
    end

    #
    # Creative Commons Zero License
    #
    # @return [License]
    #
    def self.cc0
      first(:name => 'CC0')
    end

    #
    # General Public License, version 2
    #
    # @return [License]
    #
    def self.gpl2
      first(:name => 'GPL-2')
    end

    #
    # Lesser General Public License, version 2.1
    #
    # @return [License]
    #
    def self.lgpl2
      first(:name => 'LGPL-2.1')
    end

    #
    # General Public License, version 3
    #
    # @return [License]
    #
    def self.gpl3
      first(:name => 'GPL-3')
    end

    #
    # Lesser General Public License, version 3
    #
    # @return [License]
    #
    def self.lgpl3
      first(:name => 'LGPL-3')
    end

    #
    # The MIT "as-is" License
    #
    # @return [License]
    #
    def self.mit
      first(:name => 'MIT')
    end

  end
end
