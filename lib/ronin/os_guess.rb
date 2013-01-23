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
  # Represents a guess about what {OS} an {IPAddress} might be running.
  #
  class OSGuess

    include Model

    # The primary-key of the OS guess.
    property :id, Serial

    # The IP Address the OS guess was made against.
    belongs_to :ip_address, model: 'IPAddress'

    # The guessed OS.
    belongs_to :os, model: 'OS'

    # Tracks when an OS guess is made against an IP Address.
    timestamps :created_at

  end
end
