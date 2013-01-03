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

require 'ronin/model'
require 'ronin/model/has_name'
require 'ronin/extensions/meta'

module Ronin
  #
  # Represents an Operating System and pre-defines other common ones
  # ({linux}, {freebsd}, {openbsd}, {netbsd}, {osx}, {solaris}, {windows}
  # and {unix}).
  #
  class OS

    include Model
    include Model::HasName

    # Primary key
    property :id, Serial

    # Version of the Operating System
    property :version, String, :index => true

    # Any OS guesses for the Operating System
    has 0..n, :os_guesses, :model => 'OSGuess'

    # Any IP Addresses that might be running the Operating System
    has 0..n, :ip_addresses, :through => :os_guesses,
                             :model => 'IPAddress',
                             :via => :ip_address

    #
    # The IP Address that was most recently guessed to be using the
    # Operating System.
    #
    # @return [IPAddress]
    #   The IP Address most recently guessed to be using the
    #   Operating System.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def recent_ip_address
      relation = self.os_guesses.first(:order => [:created_at.desc])

      if relation
        return relation.ip_address
      end
    end

    #
    # Converts the Operating System to a String.
    #
    # @return [String]
    #   The OS name and version.
    #
    # @example
    #   os = OS.new(:name => 'Linux', :version => '2.6.11')
    #   os.to_s # => "Linux 2.6.11"
    #
    # @api public
    #
    def to_s
      if self.version then "#{self.name} #{self.version}"
      else                 super
      end
    end

    #
    # The Linux OS
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.linux(version=nil)
      if version then first_or_create(:name => 'Linux', :version => version)
      else            first(:name => 'Linux')
      end
    end

    #
    # The FreeBSD OS
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.freebsd(version=nil)
      if version then first_or_create(:name => 'FreeBSD', :version => version)
      else            first(:name => 'FreeBSD')
      end
    end

    #
    # The OpenBSD OS
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.openbsd(version=nil)
      if version then first_or_create(:name => 'OpenBSD', :version => version)
      else            first(:name => 'OpenBSD')
      end
    end

    #
    # The NetBSD OS
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.netbsd(version=nil)
      if version then first_or_create(:name => 'NetBSD', :version => version)
      else            first(:name => 'NetBSD')
      end
    end

    #
    # OS X
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.osx(version=nil)
      if version then first_or_create(:name => 'OS X', :version => version)
      else            first(:name => 'OS X')
      end
    end

    #
    # The Solaris OS
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.solaris(version=nil)
      if version then first_or_create(:name => 'Solaris', :version => version)
      else            first(:name => 'Solaris')
      end
    end

    #
    # The family UNIX OSes
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.unix(version=nil)
      if version then first_or_create(:name => 'UNIX', :version => version)
      else            first(:name => 'UNIX')
      end
    end

    #
    # The Windows OS
    #
    # @param [String] version
    #   Optional version of the OS.
    #
    # @return [OS]
    #
    def self.windows(version=nil)
      if version then first_or_create(:name => 'Windows', :version => version)
      else            first(:name => 'Windows')
      end
    end

  end
end
