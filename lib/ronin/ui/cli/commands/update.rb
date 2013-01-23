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
require 'ronin/repository'
require 'ronin/database'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Updates Ronin {Repository Repositories}.
        #
        # ## Usage
        #
        #     ronin update [options] REPO
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #
        # ## Arguments
        #
        #       REPO                             Repository to update
        #
        # ## Examples
        #
        #       ronin update repo
        #       ronin update repo@github.com
        #
        class Update < Command

          summary 'Updates Ronin Repositories'

          argument :repo, type:        String,
                          description: 'Repository to update'

          examples [
            "ronin update repo",
            "ronin update repo@github.com"
          ]

          #
          # Sets up the install command.
          #
          def setup
            super

            Database.setup
          end

          #
          # Executes the command.
          #
          def execute
            if repo?
              repository = begin
                             Repository.find(@repo)
                           rescue RepositoryNotFound => e
                             print_error e.message
                             exit -1
                           end

              print_info "Updating #{repository} ..."

              repository.update!

              print_info "Repository #{repository} updated."
            else
              print_info "Updating Repositories ..."

              Repository.update!

              print_info "Repositories updated."
            end
          end

          protected

          #
          # Print out any exceptions or validation errors encountered
          # when caching the files of the repository.
          #
          # @param [Repository] repository
          #   The repository that was updated.
          #
          def print_cache_errors(repository)
            repository.script_paths.each do |script_path|
              if script_path.cache_exception
                print_exception script_path.cache_exception
              end

              if script_path.cache_errors
                script_path.cache_errors.each do |error|
                  print_error error
                end
              end
            end
          end

        end
      end
    end
  end
end
