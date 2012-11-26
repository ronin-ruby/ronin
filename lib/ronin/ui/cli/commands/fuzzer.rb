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
require 'ronin/fuzzing/repeater'
require 'ronin/fuzzing/fuzzer'

require 'shellwords'
require 'tempfile'
require 'socket'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Performs basic fuzzing of files, commands or TCP/UDP services.
        #
        # ## Usage
        #
        #     ronin fuzzer [options]
        #
        # ## Options
        #
        #     -v, --[no-]verbose               Enable verbose output.
        #     -q, --[no-]quiet                 Disable verbose output.
        #         --[no-]silent                Silence all output.
        #     -r [[PATTERN|/REGEXP/]:[METHOD|STRING*N[-M]]],
        #         --rule                       Fuzzing rules.
        #     -i, --input [FILE]               Input file to fuzz.
        #     -o, --output [FILE]              Output file path.
        #     -c [PROGRAM [OPTIONS|#string#|#path#] ...],
        #         --command                    Template command to run.
        #     -t, --tcp [HOST:PORT]            TCP service to fuzz.
        #     -u, --udp [HOST:PORT]            UDP service to fuzz.
        #     -p, --pause [SECONDS]            Pause in between mutations.
        #
        # ## Examples
        #
        #     ronin fuzzer -i request.txt -r unix_path:bad_strings -o bad.txt
        #
        # @since 1.5.0
        #
        class Fuzzer < Command

          summary 'Performs basic fuzzing of files'

          option :input, :type        => String,
                         :flag        => '-i',
                         :usage       => 'FILE',
                         :description => 'Input file to fuzz'

          option :rules, :type        => Hash[String => String],
                         :flag        => '-r',
                         :usage       => '[PATTERN|/REGEXP/|STRING]:[METHOD|STRING*N[-M]]',
                         :description => 'Fuzzing rules'

          option :output, :type        => String,
                          :flag        => '-o',
                          :usgae       => 'PATH',
                          :description => 'Output file path'

          option :command, :type        => String,
                           :flag        => '-c',
                           :usage       => 'PROGRAM [OPTIONS|#string#|#path#] ...',
                           :description => 'Template command to run'

          option :tcp, :type        => String,
                       :flag        => '-t',
                       :usage       => 'HOST:PORT',
                       :description => 'TCP service to fuzz'

          option :udp, :type        => String,
                       :flag        => '-u',
                       :usage       => 'HOST:PORT',
                       :description => 'UDP service to fuzz'

          option :pause, :type        => Float,
                         :flag        => '-p',
                         :usage       => 'SECONDS',
                         :description => 'Pause in between mutations'

          examples [
            "ronin fuzzer -i request.txt -o bad.txt -r unix_path:bad_strings"
          ]

          #
          # Sets up the fuzz command.
          #
          def setup
            super

            unless rules?
              print_error "Must specify at least one fuzzing rule"
              exit -1
            end

            @rules = Hash[@rules.map { |pattern,substitution|
              [parse_pattern(pattern), parse_substitution(substitution)]
            }]

            if output?
              @file_ext  = File.extname(@output)
              @file_name = @file.chomp(@file_ext)
            elsif command?
              @command = shellwords(@command)
            elsif (tcp? || udp?)
              @socket_class = if    tcp? then TCPSocket
                              elsif udp? then UDPSocket
                              end

              @host, @port = (@tcp || @udp).split(':',2)
              @port = @port.to_i
            end
          end

          def execute
            data   = if input? then File.read(@input)
                     else           $stdin.read
                     end

            method = if    output?        then method(:fuzz_file)
                     elsif command?       then method(:fuzz_command)
                     elsif (tcp? || udp?) then method(:fuzz_network)
                     else                      method(:print_fuzz)
                     end

            fuzzer = Fuzzing::Fuzzer.new(@rules)
            fuzzer.each(data).each_with_index do |string,index|
              method.call(string,index + 1)

              sleep(pause) if pause?
            end
          end

          protected

          include Shellwords

          #
          # Writes the fuzzed string to a file.
          #
          # @param [String] string
          #   The fuzzed string.
          #
          # @param [Integer] index
          #   The iteration number.
          #
          def fuzz_file(string,index)
            path = "#{@file_name}-#{index}#{@file_ext}"

            print_info "Creating file ##{index}: #{path} ..."

            File.open(path,'wb') do |file|
              file.write string
            end
          end

          #
          # Runs the fuzzed string in a command.
          #
          # @param [String] string
          #   The fuzzed string.
          #
          # @param [Integer] index
          #   The iteration number.
          #
          def fuzz_command(string,index)
            Tempfile.open("ronin-fuzzer-#{index}") do |tempfile|
              tempfile.write(string)
              tempfile.flush

              arguments = @command.map do |argument|
                if argument.include?('#path#')
                  argument.sub('#path#',tempfile.path)
                elsif argument.include?('#string#')
                  argument.sub('#string#',string)
                else
                  argument
                end
              end

              print_info "Running command #{index}: #{arguments.join(' ')} ..."

              # run the command as it's own process
              unless system(*arguments)
                status = $?

                if status.coredump?
                  # jack pot!
                  print_error "Process ##{status.pid} coredumped!"
                else
                  # process errored out
                  print_warning "Process ##{status.pid} exited with status #{status.exitstatus}"
                end
              end
            end
          end

          #
          # Sends the fuzzed string to a TCP/UDP Service.
          #
          # @param [String] string
          #   The fuzzed string.
          #
          # @param [Integer] index
          #   The iteration number.
          #
          def fuzz_network(string,index)
            print_debug "Connecting to #{@host}:#{@port} ..."
            socket = @socket_class.new(@host,@port)

            print_info "Sending message ##{index}: #{string.inspect} ..."
            socket.write(string)
            socket.flush

            print_debug "Disconnecting from #{@host}:#{@port} ..."
            socket.close
          end

          #
          # Prints the fuzzed string to STDOUT.
          #
          # @param [String] string
          #   The fuzzed string.
          #
          # @param [Integer] index
          #   The iteration number.
          #
          def print_fuzz(string,index)
            print_debug "String ##{index} ..."

            puts string
          end

          #
          # Parses a fuzz pattern.
          #
          # @param [String] string
          #   The string to parse.
          #
          # @return [Regexp, String]
          #   The parsed pattern.
          #
          def parse_pattern(string)
            case string
            when /^\/.+\/$/
              Regexp.new(string[1..-2])
            when /^[a-z][a-z_]+$/
              const = string.upcase

              if (Regexp.const_defined?(const) &&
                  Regexp.const_get(const).kind_of?(Regexp))
                Regexp.const_get(const)
              else
                string
              end
            else
              string
            end
          end

          #
          # Parses a fuzz substitution Enumerator.
          #
          # @param [String] string
          #   The string to parse.
          #
          # @return [Enumerator]
          #   The parsed substitution Enumerator.
          #
          def parse_substitution(string)
            if string.include?('*')
              string, lengths = string.split('*',2)

              lengths = if lengths.include?('-')
                          min, max = lengths.split('-',2)

                          (min.to_i .. max.to_i)
                        else
                          lengths.to_i
                        end

              Fuzzing::Repeater.new(lengths).each(string)
            else
              Fuzzing[string]
            end
          end

        end
      end
    end
  end
end
