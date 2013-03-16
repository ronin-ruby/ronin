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

require 'ronin/extensions/ip_addr'
require 'ronin/network/dns'
require 'ronin/model/importable'
require 'ronin/address'
require 'ronin/host_name'

require 'ipaddr'

module Ronin
  #
  # Represents IP addresses that can be stored in the {Database}.
  #
  class IPAddress < Address

    include Model::Importable

    # The IP Address
    property :address, IPAddress, required: true,
                                  unique: true

    # Type of the address
    property :version, Integer, set: [4, 6],
                                default: lambda { |ip_addr,version|
                                  if ip_addr.address
                                    if ip_addr.address.ipv6? then 6
                                    else                          4
                                    end
                                  end
                                }

    # The MAC Addresses associations
    has 0..n, :ip_address_mac_addresses, model: 'IPAddressMACAddress'

    # The MAC Addresses associated with the IP Address
    has 0..n, :mac_addresses, through: :ip_address_mac_addresses,
                              model: 'MACAddress'

    # The host-names that the IP Address serves
    has 0..n, :host_name_ip_addresses, model: 'HostNameIPAddress'

    # The host-names associated with the IP Address
    has 0..n, :host_names, through: :host_name_ip_addresses

    # Open ports of the host
    has 0..n, :open_ports

    # Ports of the host
    has 0..n, :ports, through: :open_ports

    # Any OS guesses against the IP Address
    has 0..n, :os_guesses, model: 'OSGuess'

    # Any OSes that the IP Address might be running
    has 0..n, :oses, through: :os_guesses,
                     model: 'OS',
                     via: :os

    #
    # Extracts and parses IP addresses from text.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @param [Symbol, Integer] version
    #   Specifies whether to parse IPv4 or IPv6 addresses.
    #
    # @yield [ip]
    #   The given block will be passed each extracted IP address.
    #
    # @yieldparam [IPAddress] ip
    #   An extracted IP Address from the text.
    #
    # @see https://ronin-rb.dev/docs/ronin-support/IPAddr.html#extract-class_method
    #
    # @since 1.3.0
    #
    # @api public
    #
    def self.extract(text,version=nil)
      return enum_for(__method__,text,version).to_a unless block_given?

      IPAddr.extract(text,version) do |ip|
        yield parse(ip)
      end

      return nil
    end

    #
    # Searches for all IPv4 addresses.
    #
    # @return [Array<IPAddress>]
    #   The IPv4 addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.v4
      all(version: 4)
    end

    #
    # Searches for all IPv6 addresses.
    #
    # @return [Array<IPAddress>]
    #   The IPv6 addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.v6
      all(version: 6)
    end

    #
    # Searches for all IP addresses associated with specific MAC addresses.
    #
    # @param [Array<String>, String] macs
    #   The MAC address(es) to search for.
    #
    # @return [Array<IPAddress>]
    #   The matching IP addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_macs(macs)
      all('mac_addresses.address' => macs)
    end

    #
    # Searches for IP addresses associated with the given host names.
    #
    # @param [Array<String>, String] names
    #   The host name(s) to search for.
    #
    # @return [Array<IPAddress>]
    #   The matching IP addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_hosts(names)
      all('host_names.address' => names)
    end

    #
    # Searches for IP addresses with the given open ports.
    #
    # @param [Array<Integer>, Integer] numbers
    #   The port number(s) to search for.
    #
    # @return [Array<IPAddress>]
    #   The matching IP addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_ports(numbers)
      all('ports.number' => numbers)
    end

    #
    # Looks up the host name to multiple IP addresses.
    #
    # @param [String] name
    #   The host name to look up.
    #
    # @param [Array<String>, String] nameservers
    #   Optional nameserver(s) to query.
    #
    # @return [Array<IPAddress>]
    #   The new or previously saved IP Addresses for the host name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.lookup(name,nameservers=[])
      host = HostName.first_or_new(address: name)
      resolver = Network::DNS.resolver(nameservers)

      ips = begin
              resolver.getaddresses(name)
            rescue
              []
            end
        
      ips.map! do |addr|
        IPAddress.first_or_create(address: addr, host_names: [host])
      end

      return ips
    end

    #
    # Performs a reverse lookup on the IP address.
    #
    # @param [Array<String>, String] nameservers
    #   Optional nameservers to query.
    #
    # @return [Array<HostName>]
    #   The host-names associated with the IP Address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def lookup!(nameservers=[])
      resolver = Network::DNS.resolver(nameservers)
      hosts = begin
                resolver.getnames(self.address.to_s)
              rescue
                []
              end

      hosts.map! do |name|
        HostName.first_or_create(address: name, ip_addresses: [self])
      end

      return hosts
    end

    #
    # The MAC Address that was most recently used by the IP Address.
    #
    # @return [MacAddress]
    #   The MAC Address that most recently used the IP Address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_mac_address
      self.ip_address_mac_addresses.all(
        order: [:created_at.desc]
      ).mac_addresses.first
    end

    #
    # The host-name that was most recently used by the IP Address.
    #
    # @return [HostName]
    #   The host-name that most recently used by the IP Address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_host_name
      self.host_name_ip_addresses.all(
        order: [:created_at.desc]
      ).host_names.first
    end

    #
    # The Operating System that was most recently guessed for the IP
    # Address.
    #
    # @return [OS]
    #   The Operating System that most recently was guessed.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_os_guess
      self.os_guesses.all(order: [:created_at.desc]).oses.first
    end

    #
    # Determines when the IP address was last scanned.
    #
    # @return [Time, nil]
    #   The time the IP address was last scanned at.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def last_scanned_at
      last_scanned_port = self.open_ports.first(
        order: [:last_scanned_at.desc]
      )

      return last_scanned_port.last_scanned_at if last_scanned_port
    end

    #
    # Converts the address to an IP address object.
    #
    # @return [IPAddr]
    #   The IPAddr object representing either the IPv4 or IPv6 address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_ip
      self.address
    end

    #
    # Converts the address to an Integer.
    #
    # @return [Integer]
    #   The network representation of the IP address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_i
      self.address.to_i
    end

  end
end
