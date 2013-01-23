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

require 'dm-timestamps'

module Ronin
  #
  # Represents a open port at a specified IP address.
  #
  class OpenPort

    include Model

    # The primary key of the open port
    property :id, Serial

    # The IP Address that was scanned
    belongs_to :ip_address, model: 'IPAddress'

    # The port
    belongs_to :port

    # The service detected on the port
    belongs_to :service, required: false

    # The software running on the open port
    belongs_to :software, required: false

    # Credentials used by the service running on the port
    has 0..n, :service_credentials

    # Specifies whether the service requires SSL.
    property :ssl, Boolean

    # When the open-port was last scanned
    property :last_scanned_at, Time

    # Define the created_at timestamp
    timestamps :created_at

    #
    # The IP Address of the open port.
    #
    # @return [String]
    #   The IP Address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def address
      self.ip_address.address
    end

    #
    # The port number.
    #
    # @return [Integer]
    #   The port number.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def number
      self.port.number
    end

    #
    # Converts the open port to an integer.
    #
    # @return [Integer]
    #   The port number.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_i
      self.port.to_i
    end

    #
    # Converts the open port to a string.
    #
    # @return [String]
    #   The information of the open port.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_s
      if self.service then "#{self.port} (#{self.service})"
      else                 "#{self.port}"
      end
    end

  end
end
