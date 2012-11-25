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

require 'ronin/credential'
require 'ronin/service_credential'
require 'ronin/web_credential'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Lists {Credential Credentials}.
        #
        # ## Usage
        #
        #     ronin creds [options]
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
        #      -u, --for-user [USER]            Username to search for.
        #      -p, --with-password [PASS]       Password to search for.
        #      -l, --[no-]list                  List all Credentials.
        #                                       Default: true
        #
        class Creds < ResourcesCommand

          model Credential

          summary 'Lists Credentials'

          query_option :for_user, :type        => String,
                                  :flag        => '-u',
                                  :usage       => 'USER',
                                  :description => 'Username to search for'

          query_option :with_password, :type        => String,
                                       :flag        => '-p',
                                       :usage       => 'PASS',
                                       :description => 'Password to search for'

          option :list, :type        => true,
                        :default     => true,
                        :flag        => '-l',
                        :description => 'List the Credentials'

          #
          # Queries the {Credential} model.
          #
          # @since 1.0.0
          #
          def execute
            super if list?
          end

          protected

          #
          # Prints a credential.
          #
          # @param [Credential] cred
          #   The credential to display.
          #
          # @since 1.0.0
          #
          def print_resource(cred)
            case cred
            when ServiceCredential
              puts "#{cred}\t(#{cred.open_port.ip_address} #{cred.open_port})"
            when WebCredential
              puts "#{cred}\t(#{cred.url})"
            else
              super(cred)
            end
          end

        end
      end
    end
  end
end
