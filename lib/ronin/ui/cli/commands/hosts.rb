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
require 'ronin/host_name'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Manages {HostName HostNames}.
        #
        # ## Usage
        #
        #     ronin hosts [options]
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #          --database [URI]             The Database URI.
        #          --[no-]csv                   CSV output.
        #          --[no-]xml                   XML output.
        #          --[no-]yaml                  YAML output.
        #          --[no-]json                  JSON output.
        #      -i, --import [FILE]
        #      -I, --with-ips [IP [...]]
        #      -p, --with-ports [PORT [...]]
        #      -D, --domain [DOMAIN]
        #      -T, --tld [TLD]
        #      -l, --[no-]list                  Default: true
        #      -L, --lookup [IP]
        #
        class Hosts < ResourcesCommand

          model HostName

          summary 'Manages HostNames'

          query_option :with_ips, type:        Array,
                                  flag:        '-I',
                                  usage:       'IP [...]',
                                  description: 'Searches for the associated IP(s)'

          query_option :with_ports, type:        Array[Integer],
                                    flag:        '-p',
                                    usage:       'PORT [...]',
                                    description: 'Searches for the associated PORT(s)'

          query_option :domain, type:        String,
                                flag:        '-D',
                                usage:       'DOMAIN',
                                description: 'Searches for the associated parent DOMAIN'

          query_option :tld, type:        String,
                             flag:        '-T',
                             usage:       'TLD',
                             description: 'Searches for the associated TLD'

          option :list, type:        true,
                        default:     true,
                        flag:        '-l',
                        description: 'Lists the HostNames'

          option :lookup, type:        String,
                          flag:        '-L',
                          usage:       'IP',
                          description: 'Looks up HostNames for the IP'

          option :import, type:        String,
                          flag:        '-i',
                          usage:       'FILE',
                          description: 'Imports HostNames from the FILE'

          #
          # Queries the {HostName} model.
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
          # Looks up an IP address.
          #
          # @param [String] ip
          #   The IP address to look up.
          #
          # @since 1.0.0
          #
          def lookup(ip)
            print_info "Looking up #{ip} ..."

            HostName.lookup(ip).each do |host|
              print_info "  #{host}"
            end

            print_info "Looked up #{ip}"
          end

          #
          # Prints a host name.
          #
          # @param [HostName] host
          #   The host name to print.
          #
          # @since 1.0.0
          #
          def print_resource(host)
            return super(host) unless verbose?

            print_title host.address

            indent do
              if (org = host.organization)
                print_hash 'Organization' => org
              end

              if (last_scanned_at = host.last_scanned_at)
                print_hash 'Last Scanned' => last_scanned_at
              end

              unless host.ip_addresses.empty?
                print_array host.ip_addresses, title: 'IP Addresses'
              end

              unless host.open_ports.empty?
                print_section 'Open Ports' do
                  host.open_ports.each do |port|
                    if port.service
                      puts "#{port}\t#{port.service}"
                    else
                      puts port
                    end
                  end
                end
              end

              unless host.email_addresses.empty?
                print_array host.email_addresses, title: 'Email Addresses'
              end

              unless host.urls.empty?
                print_array host.urls, title: 'URLs'
              end
            end
          end

        end
      end
    end
  end
end
