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

require 'ronin/ui/cli/resources_command'
require 'ronin/extensions/ip_addr'
require 'ronin/ip_address'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Manages {IPAddress IPAddresses}.
        #
        # ## Usage
        #
        #     ronin ips [options]
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #      -D, --database [URI]             The Database URI.
        #          --[no-]csv                   CSV output.
        #          --[no-]xml                   XML output.
        #          --[no-]yaml                  YAML output.
        #          --[no-]json                  JSON output.
        #      -i, --import [FILE]
        #      -4, --[no-]v4
        #      -6, --[no-]v6
        #      -p, --with-ports [PORT [...]]
        #      -M, --with-macs [MAC [...]]
        #      -H, --with-hosts [HOST [...]]
        #          --[no-]list                  Default: true
        #      -L, --lookup [HOST]
        #
        class Ips < ResourcesCommand

          model IPAddress

          summary 'Manages IPAddresses'

          query_option :v4, :type => true,
                            :flag => '-4',
                            :description => 'Searches for IPv4 addresses'

          query_option :v6, :type => true,
                            :flag => '-6',
                            :description => 'Searches for IPv6 addresses'

          query_option :with_ports, :type        => Array[Integer],
                                    :flag        => '-p',
                                    :usage       => 'PORT [...]',
                                    :description => 'Searches for the associated PORT(s)'

          query_option :with_macs, :type        => Array,
                                   :flag        => '-M',
                                   :usage       => 'MAC [...]',
                                   :description => 'Searches for the associated MAC address(es)'

          query_option :with_hosts, :type        => Array,
                                    :flag        => '-H',
                                    :usage       => 'HOST [...]',
                                    :description => 'Searches for the associated HOST(s)'

          option :list, :type        => true,
                        :default     => true,
                        :flag        => '-l',
                        :description => 'Lists the IP addresses'

          option :lookup, :type        => String,
                          :flag        => '-L',
                          :usage       => 'HOST',
                          :description => 'Looks up the IP addresses for the HOST'

          option :import, :type  => String,
                          :flag  => '-i',
                          :usage => 'FILE',
                          :description => 'Imports IP addresses from the FILE'

          #
          # Queries the {IPAddress} model.
          #
          # @since 1.0.0
          #
          def execute
            if lookup? then lookup(@lookup)
            else            super
            end
          end

          protected

          #
          # Looks up a host name.
          #
          # @param [String] host
          #   The host name to lookup.
          #
          # @since 1.0.0
          #
          def lookup(host)
            print_info "Looking up #{host} ..."

            IPAddress.lookup(host).each do |ip|
              print_info "  #{ip}"
            end

            print_info "Looked up #{host}"
          end

          #
          # Prints an IP Address.
          #
          # @param [IPAddress] ip
          #   The IP Address to print.
          #
          # @since 1.0.0
          #
          def print_resource(ip)
            return super(ip) unless verbose?

            print_title ip.address

            indent do
              if (org = ip.organization)
                print_hash 'Organization' => org
              end

              if (last_scanned_at = ip.last_scanned_at)
                print_hash 'Last Scanned' => last_scanned_at
              end

              unless ip.mac_addresses.empty?
                print_array ip.mac_addresses, :title => 'MAC Addresses'
              end

              unless ip.host_names.empty?
                print_array ip.host_names, :title => 'Hostnames'
              end

              unless ip.open_ports.empty?
                print_section 'Open Ports' do
                  ip.open_ports.each do |port|
                    if port.service
                      puts "#{port}\t#{port.service}"
                    else
                      puts port
                    end
                  end
                end
              end
            end
          end

        end
      end
    end
  end
end
