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

require 'data_paths'
require 'fileutils'

module Ronin
  #
  # Configuration information for Ronin.
  #
  # @api semipublic
  #
  module Config
    include DataPaths
    extend DataPaths::Finders

    # The users home directory
    HOME = Gem.user_home

    # Ronin home directory
    PATH = File.join(HOME,'.ronin')

    # Configuration files directory
    CONFIG_DIR = File.join(PATH,'config')

    # Temporary file directory
    TMP_DIR = File.join(PATH,'tmp')

    # Directories which contain binaries
    BIN_DIRS = ENV.fetch('PATH','').split(File::PATH_SEPARATOR)

    [PATH, CONFIG_DIR, TMP_DIR].each do |dir|
      FileUtils.mkdir(dir) unless File.directory?(dir)
    end

    #
    # Loads the Ronin configuration file.
    #
    # @param [Symbol, String, nil] name
    #   The optional name of the file to load within {CONFIG_DIR}.
    #
    # @example Load the config file at `~/.ronin/config.rb`
    #   Config.load
    #   # => true
    #
    # @example Load the config file at `~/.ronin/config/sql.rb`
    #   Config.load :sql
    #   # => true
    #
    # @api semipublic
    #
    def Config.load(name=nil)
      dir, file = if name then [CONFIG_DIR, "#{name}.rb"]
                  else         [PATH, 'config.rb']
                  end

      path = File.expand_path(File.join(dir,file))
      require path if File.file?(path)
    end

    #
    # Auto-creates a directory within {TMP_DIR}.
    #
    # @param [String] sub_path
    #   The sub-path within {TMP_DIR}.
    #
    # @return [String]
    #   The full path within {TMP_DIR}.
    #
    # @api semipublic
    #
    def Config.tmp_dir(sub_path=nil)
      if sub_path
        sub_path = File.expand_path(File.join('',sub_path))
        path     = File.join(TMP_DIR,sub_path)

        FileUtils.mkdir_p(path) unless File.exist?(path)
        return path
      end

      return TMP_DIR
    end
  end
end
