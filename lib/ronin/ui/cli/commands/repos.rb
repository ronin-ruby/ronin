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

require 'ronin/ui/cli/model_command'
require 'ronin/repository'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Lists Ronin {Repository Repositories}.
        #
        # ## Usage
        #
        #     ronin repos [options] REPO
        #
        # ## Options
        #
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #      -D, --database [URI]             The Database URI.
        #          --domain [DOMAIN]            Domain to filter by.
        #      -n, --named [NAME]               Name to filter by.
        #      -t, --titled [TITLE]             Title to filter by.
        #      -d, --describing [DESC]
        #      -L, --licensed-under [LICENSE]   License to filter by.
        #
        # ## Arguments
        #
        #      REPO                             Repository to list
        #
        class Repos < ModelCommand

          summary 'Lists Ronin Repositories'

          model Repository

          query_option :domain, :type        => String,
                                :description => 'Domain to filter by'

          query_option :named, :type        => String,
                               :flag        => '-n',
                               :usage       => 'NAME',
                               :description => 'Name to filter by'

          query_option :titled, :type        => String,
                                :flag        => '-t',
                                :usage       => 'TITLE',
                                :description => 'Title to filter by'

          query_option :describing, :type        => String,
                                    :flag        => '-d',
                                    :usage       => 'DESC',
                                    :description => 'Description to filter by'

          query_option :licensed_under, :type        => String,
                                        :flag        => '-L',
                                        :usage       => 'LICENSE',
                                        :description => 'License to filter by'

          argument :repo, :type        => String,
                          :description => 'Repository to list'

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

              print_repository(repository)
            else
              print_array query
            end
          end

          protected

          #
          # Prints information about a Repository.
          #
          # @param [Repository] repo
          #   The repository to print.
          #
          def print_repository(repo)
            print_title repo.name

            indent do
              if repo.installed?
                puts "Domain: #{repo.domain}"
              else
                puts "Path: #{repo.path}"
              end

              puts "SCM: #{repo.scm}" if repo.scm

              if repo.verbose?
                putc "\n"

                puts "Title: #{repo.title}" if repo.title
                puts "URI: #{repo.uri}" if repo.uri
                puts "Source URI: #{repo.source}" if repo.source
                puts "Website: #{repo.website}" if repo.website

                executables = repo.executables

                unless executables.empty?
                  puts "Executables: #{executables.join(', ')}"
                end

                putc "\n"

                unless repo.script_paths.empty?
                  print_title 'Cached Files'

                  indent do
                    repo.script_paths.each do |script_path|
                      puts script_path.path
                    end
                  end
                end

                if repo.description
                  print_title "Description"

                  indent { puts "#{repo.description}\n\n" }
                else
                  putc "\n"
                end
              else
                putc "\n"
              end
            end
          end

        end
      end
    end
  end
end
