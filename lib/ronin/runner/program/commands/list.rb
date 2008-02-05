#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/runner/program/program'
require 'ronin/cache/repository'

module Ronin
  module Runner
    module Program
      Program.command(:list) do |argv|
        options = Options.command('ronin','list','[NAME ...] [options]') do |options|
          options.specific do
            options.on_verbose
          end

          options.common do
            options.on('-C','--cache','Specify alternant location of repository cache') do |cache|
              Cache::Repository.load_cache(cache)
            end

            options.help_option
          end

          options.arguments do
            options.arg('NAME','Repository to display')
          end

          options.summary('Display all or the specified repositories within the repository cache')
        end

        options.parse(argv) do |args|
          if args.empty?
            # list all repositories by name
            Cache::Repository.each do |repo|
              puts "  #{repo}"
            end
          else
            # list specified repositories
            args.each do |name|
              repo = Cache::Repository.get(name)

              puts "[ #{repo} ]\n\n"

              puts "  path: #{repo.path}" if options.verbose
              puts "  media: #{repo.media}"
              puts "  uri: #{repo.uri}" if repo.uri

              if repo.description
                puts "  description:\n\n    #{repo.description}"
              end

              puts "\n"

              if options.verbose
                puts "  extensions:\n\n"

                repo.each_extension do |ext|
                  puts "    #{ext}"
                end
              end
            end
          end
        end
      end
    end
  end
end
