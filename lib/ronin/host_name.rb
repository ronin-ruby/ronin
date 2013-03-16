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
require 'ronin/network/dns'
require 'ronin/model/importable'
require 'ronin/address'
require 'ronin/ip_address'

require 'uri/generic'
require 'strscan'
require 'resolv'

module Ronin
  #
  # Represents host names that can be stored in the {Database}.
  #
  class HostName < Address

    include Model::Importable

    # The address of the host name
    property :address, String, length:   256,
                               required: true,
                               unique:   true,
                               format:   /^#{Regexp::HOST_NAME}$/,
                               messages: {
                                 format: 'Must be a valid host-name'
                               }

    # The IP Address associations
    has 0..n, :host_name_ip_addresses, model: 'HostNameIPAddress'

    # The IP Addresses that host the host name
    has 0..n, :ip_addresses, through: :host_name_ip_addresses,
                             model:   'IPAddress'

    # Open ports of the host
    has 0..n, :open_ports, through: :ip_addresses

    # Ports of the host
    has 0..n, :ports, through: :ip_addresses

    # The email addresses that are associated with the host-name.
    has 0..n, :email_addresses

    # URLs that point to this host name
    has 0..n, :urls, model: 'URL'

    #
    # Extracts host-names from the given text.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @yield [host]
    #   The given block will be passed each extracted host-name.
    #
    # @yieldparam [HostName] host
    #   An extracted host-name.
    #
    # @return [Array<HostName>]
    #   If no block is given, an Array of host-names will be returned.
    #
    # @see 1.3.0
    #
    # @api public
    #
    def self.extract(text)
      return enum_for(__method__,text).to_a unless block_given?

      scanner = StringScanner.new(text)

      while scanner.skip_until(Regexp::HOST_NAME)
        yield parse(scanner.matched)
      end

      return nil
    end

    #
    # Searches for host names associated with the given IP address(es).
    #
    # @param [Array<String>, String] ips
    #   The IP address(es) to search for.
    #
    # @return [Array<HostName>]
    #   The matching host names.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_ips(ips)
      all('ip_addresses.address' => ips)
    end

    #
    # Searches for host names with the given open port(s).
    #
    # @param [Array<Integer>, Integer] numbers
    #   The open port(s) to search for.
    #
    # @return [Array<HostName>]
    #   The matching host names.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_ports(numbers)
      all('ports.number' => numbers)
    end

    #
    # Searches for all host names under the Top-Level Domain (TLD).
    #
    # @param [String] name
    #   The Top-Level Domain (TLD).
    #
    # @return [Array<HostName>]
    #   The matching host names.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.tld(name)
      all(:address.like => "%.#{name}")
    end

    #
    # Searches for all host names sharing a common domain name.
    #
    # @param [String] name
    #   The common domain name to search for.
    #
    # @return [Array<HostName>]
    #   The matching host names.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.domain(name)
      all(:address.like => "#{name}.%") |
      all(:address.like => "%.#{name}.%")
    end

    #
    # Looks up all host names associated with an IP address.
    #
    # @param [IPAddr, String] addr
    #   The IP address to lookup.
    #
    # @param [Array<String>, String] nameservers
    #   The optional nameserver(s) to query.
    #
    # @return [Array<HostName>]
    #   The host names associated with the IP address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.lookup(addr,nameservers=[])
      addr = addr.to_s
      ip = IPAddress.first_or_new(address: addr)

      resolver = Network::DNS.resolver(nameservers)
      hosts = begin
                resolver.getnames(addr)
              rescue
                []
              end

      hosts.map! do |name|
        HostName.first_or_create(address: name, ip_addresses: [ip])
      end

      return hosts
    end

    alias name address

    #
    # Looks up all IP Addresses for the host name.
    #
    # @param [Array<String>, String] nameservers
    #   The optional nameserver(s) to query.
    #
    # @return [Array<IPAddress>]
    #   The IP Addresses for the host name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def lookup!(nameservers=[])
      resolver = Network::DNS.resolver(nameservers)
      ips = begin
              resolver.getaddresses(self.address)
            rescue
              []
            end

      ips.map! do |addr|
        IPAddress.first_or_create(address: addr, host_names: [self])
      end

      return ips
    end

    #
    # The IP Address that was most recently used by the host name.
    #
    # @return [IpAddress]
    #   The IP Address that most recently used by the host name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_ip_address
      self.host_name_ip_addresses.all(
        order: [:created_at.desc]
      ).ip_addresses.first
    end

    #
    # Determines when the host was last scanned.
    #
    # @return [Time, nil]
    #   The time the host was last scanned at.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def last_scanned_at
      last_scanned_url = self.urls.first(order: [:last_scanned_at.desc])

      return last_scanned_url.last_scanned_at if last_scanned_url
    end

  end
end
