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

module Ronin
  #
  # Represents a Software product.
  #
  class Software

    include Model

    # Primary key
    property :id, Serial

    # Name
    property :name, String, required: true,
                            index:    true

    # Version
    property :version, String, required: true,
                               index:    true

    # The vendor of the software
    belongs_to :vendor, required: false

    # The open ports running the software
    has 0..n, :open_ports

    #
    # Converts the software to a String.
    #
    # @return [String]
    #   The software vendor, name and version.
    #
    # @api public
    #
    def to_s
      [self.vendor, self.name, self.version].compact.join(' ')
    end

  end
end
