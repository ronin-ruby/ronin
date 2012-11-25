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
        # Installs Ronin {Repository Repositories}.
        #
        # ## Usage
        #
        #     ronin install [options] URI
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #          --[no-]rsync
        #          --[no-]svn
        #          --[no-]hg
        #          --[no-]git
        #
        # ## Arguments
        #
        #      URI                              The URI of the Repository
        #
        # ## Examples
        #
        #      ronin install git://github.com/user/repo.git
        #      ronin install --git git@example.com:/home/secret/repo
        # 
        class Install < Command

          summary 'Installs Ronin Repositories'

          option :rsync, :type        => true,
                         :description => 'Install via rsync'

          option :svn, :type        => true,
                       :description => 'Install via SubVersion (SVN)'

          option :hg, :type        => true,
                      :description => 'Install via Mercurial (Hg)'

          option :git, :type        => true,
                       :description => 'Install via Git'

          argument :uri, :type        => String,
                         :description => 'The URI of the Repository'

          examples [
            "ronin install git://github.com/user/repo.git",
            "ronin install --git git@example.com:/home/secret/repo"
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
            unless uri?
              print_error "Must specify the URI argument"
              exit -1
            end

            scm = if    rsync? then :rsync
                  elsif svn?   then :sub_version
                  elsif hg?    then :mercurial
                  elsif git?   then :git
                  end

            repository = begin
                           if File.directory?(@uri)
                             # add local repositories
                             Repository.add(:path => @uri, :scm => scm)
                           else
                             # install remote repositories
                             Repository.install(:uri => @uri, :scm => scm)
                           end
                         rescue DuplicateRepository => e
                           print_error e.message
                           exit -1
                         end

            print_info "Repository #{repository} installed."

            # print any caching exceptions/errors
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
