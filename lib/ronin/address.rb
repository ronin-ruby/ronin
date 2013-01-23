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

require 'dm-timestamps'

module Ronin
  #
  # A base model which represents an Internet Address, such as:
  #
  # * {MACAddress}
  # * {IPAddress}
  # * {HostName}
  #
  class Address

    include Model

    # The primary key of the Address
    property :id, Serial

    # The class name of the Address
    property :type, Discriminator, required: true

    # The Address
    property :address, String, required: true,
                               unique:   true

    # The optional organization the host belongs to
    belongs_to :organization, required: false

    # The targets associated with the address
    has 0..n, :targets

    # The campaigns targeting the address
    has 0..n, :campaigns, through: :targets

    # Tracks when the IP Address was first created
    timestamps :created_at

    #
    # Parses the address.
    #
    # @param [String] address
    #   The address to parse.
    #
    # @return [Address]
    #   The parsed address.
    #
    # @since 1.3.0
    #
    # @api public
    #
    def self.parse(address)
      first_or_new(address: address)
    end

    #
    # Finds an address.
    #
    # @param [String, Integer] key
    #   The address or index to search for.
    #
    # @return [Address, nil]
    #   The found address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.[](key)
      case key
      when String then first(address: key)
      else             super(key)
      end
    end

    #
    # Converts the address into a string.
    #
    # @return [String]
    #   The address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_s
      self.address.to_s
    end

    #
    # Inspects the address.
    #
    # @return [String]
    #   The inspected address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def inspect
      "#<#{self.class}: #{self.address}>"
    end

  end
end
