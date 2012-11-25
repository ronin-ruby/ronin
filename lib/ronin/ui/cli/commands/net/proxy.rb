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

require 'ronin/ui/cli/command'
require 'ronin/network/tcp/proxy'
require 'ronin/network/udp/proxy'

require 'hexdump/dumper'

module Ronin
  module UI
    module CLI
      module Commands
        module Net
          #
          # Starts a TCP/UDP intercept proxy.
          #
          # ## Usage
          #
          #     ronin net:proxy [options]
          #
          # ## Options
          #
          #     -v, --[no-]verbose               Enable verbose output.
          #     -q, --[no-]quiet                 Disable verbose output.
          #         --[no-]silent                Silence all output.
          #     -t, --[no-]tcp                   TCP Proxy.
          #                                      Default: true
          #     -u, --[no-]udp                   UDP Proxy.
          #     -x, --[no-]hexdump               Enable hexdump output.
          #     -H, --host [HOST]                Host to listen on.
          #                                      Default: "0.0.0.0"
          #     -p, --port [PORT]                Port to listen on.
          #     -s, --server [HOST[:PORT]]       Server to forward connections to.
          #     -r, --rewrite [/REGEXP/:STRING] Rewrite rules.
          #         --rewrite-client [/REGEXP/:STRING]
          #                                      Client rewrite rules.
          #         --rewrite-server [/REGEXP/:STRING]
          #                                      Server rewrite rules.
          #     -i, --ignore [/REGEXP/ [...]]    Ignore rules.
          #         --ignore-client [/REGEXP/ [...]]
          #                                      Client ignore rules.
          #         --ignore-server [/REGEXP/ [...]]
          #                                      Server ignore rules.
          #     -C, --close [/REGEXP/ [...]]     Close rules.
          #         --close-client [/REGEXP/ [...]]
          #                                      Client close rules.
          #         --close-server [/REGEXP/ [...]]
          #                                      Server close rules.
          #     -R, --reset [/REGEXP/ [...]]     Reset rules.
          #         --reset-client [/REGEXP/ [...]]
          #                                      Client reset rules.
          #         --reset-server [/REGEXP/ [...]]
          #                                      Server reset rules.
          #
          # @since 1.5.0
          # 
          class Proxy < Command

            summary 'Starts a TCP/UDP intercept proxy'

            option :tcp, :type        => true,
                         :default     => true,
                         :flag        => '-t',
                         :description => 'TCP Proxy'

            option :udp, :type        => true,
                         :flag        => '-u',
                         :description => 'UDP Proxy'

            option :hexdump, :type        => true,
                             :flag        => '-x',
                             :description => 'Enable hexdump output'

            option :host, :type        => String,
                          :default     => Network::Proxy::DEFAULT_HOST,
                          :flag        => '-H',
                          :usage       => 'HOST',
                          :description => 'Host to listen on'

            option :port, :type        => Integer,
                          :flag        => '-p',
                          :usage       => 'PORT',
                          :description => 'Port to listen on'

            option :server, :type        => String,
                            :flag        => '-s',
                            :usage       => 'HOST[:PORT]',
                            :description => 'Server to forward connections to'

            option :rewrite, :type        => Hash[Regexp => String],
                             :flag        => '-r',
                             :usage       => '/REGEXP/:STRING',
                             :description => 'Rewrite rules'

            option :rewrite_client, :type        => Hash[Regexp => String],
                                    :usage       => '/REGEXP/:STRING',
                                    :description => 'Client rewrite rules'

            option :rewrite_server, :type        => Hash[Regexp => String],
                                    :usage       => '/REGEXP/:STRING',
                                    :description => 'Server rewrite rules'

            option :ignore, :type        => Set[Regexp],
                            :flag        => '-i',
                            :usage       => '/REGEXP/ [...]',
                            :description => 'Ignore rules'

            option :ignore_client, :type        => Set[Regexp],
                                   :usage       => '/REGEXP/ [...]',
                                   :description => 'Client ignore rules'

            option :ignore_server, :type        => Set[String],
                                   :usage       => '/REGEXP/ [...]',
                                   :description => 'Server ignore rules'

            option :close, :type        => Set[Regexp],
                           :flag        => '-C',
                           :usage       => '/REGEXP/ [...]',
                           :description => 'Close rules'

            option :close_client, :type        => Set[Regexp],
                                  :usage       => '/REGEXP/ [...]',
                                  :description => 'Client close rules'

            option :close_server, :type        => Set[Regexp],
                                  :usage       => '/REGEXP/ [...]',
                                  :description => 'Server close rules'

            option :reset, :type        => Set[Regexp],
                           :flag        => '-R',
                           :usage       => '/REGEXP/ [...]',
                           :description => 'Reset rules'

            option :reset_client, :type        => Set[Regexp],
                                  :usage       => '/REGEXP/ [...]',
                                  :description => 'Client reset rules'

            option :reset_server, :type        => Set[Regexp],
                                  :usage       => '/REGEXP/ [...]',
                                  :description => 'Server reset rules'

            examples [
              "ronin net:proxy --port 8080 --server google.com:80",
              "ronin net:proxy --port 53 --server 4.2.2.1 --udp --hexdump"
            ]

            #
            # Sets up the proxy command.
            #
            def setup
              super

              unless (tcp? || udp?)
                print_error "Must specify --tcp or --udp"
                exit -1
              end

              unless server?
                print_error "Must specify the SERVER argument"
                exit -1
              end

              @server_host, @server_port = server.split(':',2)
              @server_port = if @server_port
                               @server_port.to_i
                             end

              if hexdump?
                @hexdumper = Hexdump::Dumper.new
              end
            end

            #
            # Executes the proxy command.
            #
            def execute
              @proxy = proxy_class.new(
                :port   => @port,
                :host   => @host,
                :server => [@server_host, @server_port]
              )

              case @proxy
              when Network::TCP::Proxy
                @proxy.on_client_connect do |client|
                  print_outgoing client, '[connecting]'
                end

                @proxy.on_client_disconnect do |client,server|
                  print_outgoing client, '[disconnecting]'
                end

                @proxy.on_server_connect do |client,server|
                  print_incoming client, '[connected]'
                end

                @proxy.on_server_disconnect do |client,server|
                  print_incoming client, '[disconnected]'
                end
              end

              if @reset_client
                @reset_client.each do |pattern|
                  @proxy.on_client_data do |client,server,data|
                    @proxy.reset! if data =~ pattern
                  end
                end
              end

              if @close_client
                @close_client.each do |pattern|
                  @proxy.on_client_data do |client,server,data|
                    @proxy.close! if data =~ pattern
                  end
                end
              end

              if @ignore_client
                @ignore_client.each do |pattern|
                  @proxy.on_client_data do |client,server,data|
                    @proxy.ignore! if data =~ pattern
                  end
                end
              end

              if @rewrite_client
                @rewrite_client.each do |pattern,replace|
                  @proxy.on_client_data do |client,server,data|
                    data.gsub!(pattern,replace)
                  end
                end
              end

              if @reset_server
                @reset_server.each do |pattern|
                  @proxy.on_server_data do |client,server,data|
                    @proxy.reset! if data =~ pattern
                  end
                end
              end

              if @close_server
                @close_server.each do |pattern|
                  @proxy.on_server_data do |client,server,data|
                    @proxy.close! if data =~ pattern
                  end
                end
              end

              if @ignore_server
                @ignore_server.each do |pattern|
                  @proxy.on_server_data do |client,server,data|
                    @proxy.ignore! if data =~ pattern
                  end
                end
              end

              if @rewrite_server
                @rewrite_server.each do |pattern,replace|
                  @proxy.on_server_data do |client,server,data|
                    data.gsub!(pattern,replace)
                  end
                end
              end

              if @reset
                @reset.each do |pattern|
                  @proxy.on_data do |client,server,data|
                    @proxy.reset! if data =~ pattern
                  end
                end
              end

              if @close
                @close.each do |pattern|
                  @proxy.on_data do |client,server,data|
                    @proxy.close! if data =~ pattern
                  end
                end
              end

              if @ignore
                @ignore.each do |pattern|
                  @proxy.on_data do |client,server,data|
                    @proxy.ignore! if data =~ pattern
                  end
                end
              end

              if @rewrite
                @rewrite.each do |pattern,replace|
                  @proxy.on_data do |client,server,data|
                    data.gsub!(pattern,replace)
                  end
                end
              end

              @proxy.on_client_data do |client,server,data|
                print_outgoing client
                print_data data
              end

              @proxy.on_server_data do |client,server,data|
                print_incoming client
                print_data data
              end

              print_info "Listening on #{@host}:#{@port} ..."
              @proxy.start
            end

            protected

            #
            # Determines the Proxy class based on the `--tcp` or `--udp`
            # options.
            #
            # @return [Network::TCP::Proxy, Network::UDP::Proxy]
            #   The proxy class.
            #
            def proxy_class
              if    udp? then Network::UDP::Proxy
              elsif tcp? then Network::TCP::Proxy
              end
            end

            #
            # Returns the address for the connection.
            #
            # @param [(UDPSocket,(host, port)), TCPSocket, UDPSocket] connection
            #   The connection.
            #
            # @return [String]
            #   The address of the connection.
            #
            def address(connection)
              case connection
              when Array
                socket, (host, port) = connection

                "#{host}:#{port}"
              when TCPSocket, UDPSocket
                addrinfo = connection.peeraddr

                "#{addrinfo[3]}:#{addrinfo[1]}"
              end
            end

            #
            # Prints a connection header for an incoming event.
            #
            # @param [(UDPSocket,(host, port)), TCPSocket, UDPSocket] client
            #   The client.
            #
            # @param [String] event
            #   The optional name of the event.
            #
            def print_incoming(client,event=nil)
              print_info "#{address(client)} <- #{@proxy} #{event}"
            end

            #
            # Prints a connection header for an outgoing event.
            #
            # @param [(UDPSocket,(host, port)), TCPSocket, UDPSocket] client
            #   The client.
            #
            # @param [String] type
            #   The optional name of the event.
            #
            def print_outgoing(client,type=nil)
              print_info "#{address(client)} -> #{@proxy} #{type}"
            end

            #
            # Prints data from a message.
            #
            # @param [String] data
            #   The data from a message.
            #
            def print_data(data)
              if hexdump? then @hexdumper.dump(data)
              else             puts data
              end
            end

          end
        end
      end
    end
  end
end
