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

require 'ronin/extensions/regexp'
require 'ronin/address'

require 'strscan'

module Ronin
  #
  # Represents MAC addresses that can be stored in the {Database}.
  #
  class MACAddress < Address

    # The MAC address
    property :address, String, length:   17..17,
                               required: true,
                               unique:   true,
                               format:   /^#{Regexp::MAC}$/,
                               messages: {
                                 format: 'Must be a valid MAC address'
                               }

    # The IP Addresses the MAC Address hosts
    has 0..n, :ip_address_mac_addresses, model: 'IPAddressMACAddress'

    # The IP Addresses associated with the MAC Address
    has 0..n, :ip_addresses, through: :ip_address_mac_addresses,
                             model:   'IPAddress'

    #
    # Extracts MAC addresses from the given text.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @yield [mac]
    #   The given block will be passed each extracted MAC address.
    #
    # @yieldparam [MACAddress] mac
    #   An extracted MAC Address
    #
    # @return [Array<MACAddress>]
    #   If no block is given, an Array of MACAddress will be returned.
    #
    # @see 1.3.0
    #
    # @api public
    #
    def self.extract(text)
      return enum_for(__method__,text).to_a unless block_given?

      scanner = StringScanner.new(text)

      while scanner.skip_until(Regexp::MAC)
        yield parse(scanner.matched)
      end

      return nil
    end

    #
    # The IP Address that most recently used the MAC Address.
    #
    # @return [IpAddress]
    #   The IP Address that most recently used the MAC Address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_ip_address
      self.ip_address_mac_addresses.all(
        order: [:created_at.desc]
      ).ip_addresses.first
    end

    #
    # Converts the MAC address to an Integer.
    #
    # @return [Integer]
    #   The network representation of the MAC address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_i
      self.address.split(':').inject(0) do |bits,char|
        bits = ((bits << 8) | char.hex)
      end
    end

  end
end
